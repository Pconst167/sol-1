/******************************************************************************
Copyright (C) V1.0 2016  cdoyen@github https://github.com/cdoyen/xmlclean
This is a stripped down version for minipro by radiomanV@gitlab

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

******************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xml.h"

#define BUFFER_SIZE 65536U

static size_t readblock(FILE *f, uint8_t *s, size_t w)
{
	fpos_t fp;
	if (fgetpos(f, &fp), 1 == fread(s, w, 1, f)) {
		return w;
	}
	fsetpos(f, &fp);
	return fread(s, 1, w, f);
}

static const uint8_t *memchrignore(const uint8_t *y, size_t w)
{
	/* for <![CDATA...]...> stuff */
	int in = 0;
	while (w--) {
		if (*y == '[')
			++in;
		else if (*y == ']')
			--in;
		else if (*y == '>') {
			if (!in)
				return y;
		}
		++y;
	}
	return 0;
}

static int nextpair(const uint8_t **value, size_t *valuelen,
		    const uint8_t **tag, size_t *taglen, MemMan *mm, void *f)
{
	const uint8_t *s;
	size_t start = mm->i;

	while (!(s = memchr(mm->b + mm->i, '<', mm->g))) {
		if (start) {
			memmove(mm->b, mm->b + mm->i, mm->g);
			mm->i = mm->g;
			start = 0;
			mm->g = 0;
		}
		mm->i += mm->g;
		if (mm->i == mm->e) {
			mm->b = realloc(mm->b, mm->e += BUFFER_SIZE);
			if (!mm->b)
				return ERRMEM;

			mm->g = BUFFER_SIZE;
		} else
			mm->g = mm->e - mm->i;

		mm->g = readblock(f, mm->b + mm->i, mm->g);
		if (!mm->g) {
			*value = mm->b + start;
			*valuelen = mm->i;
			*taglen = 0;
			*tag = (uint8_t *)"";
			return ERREND;
		}
	}
	*valuelen = (size_t)(s - (mm->b + start));
	mm->g -= ((size_t)(s - mm->b) + 1) - mm->i;
	mm->i = (size_t)(s - mm->b) + 1;

	{
		size_t i = 0;
		int first = 1;
		while (mm->i == mm->e ||
		       ((first = (first ? (i = (mm->b[mm->i] == '!') ? mm->i : 0,
					   0) :
					  0)),
			!(s = (i ? memchrignore(mm->b + i, mm->g + (mm->i - i)) :
				   memchr(mm->b + mm->i, '>', mm->g))))) {
			mm->i += mm->g;
			if (mm->i == mm->e) {
				mm->b = realloc(mm->b, mm->e += BUFFER_SIZE);
				if (!mm->b)
					return ERRMEM;

				mm->g = BUFFER_SIZE;
			} else
				mm->g = mm->e - mm->i;

			mm->g = readblock(f, mm->b + mm->i, mm->g);
			if (!mm->g) {
				*value = mm->b + start;
				*taglen = mm->i - start - *valuelen - 1;
				*tag = (mm->b + start + mm->i + mm->g) -
				       *taglen;
				return ERREND;
			}
		}
	}
	mm->g -= ((size_t)(s - mm->b) + 1) - mm->i;
	mm->i = (size_t)(s - mm->b) + 1;

	*value = mm->b + start;
	*taglen = (size_t)(s - (mm->b + start + *valuelen) - 1);
	*tag = s - *taglen;

	return XML_OK;
}

int parse(Parser *p)
{
	const uint8_t *content, *tag = NULL;
	size_t contentlen = 0, taglen = 0;
	int r, new = 1;
	while ((r = nextpair(&content, &contentlen, &tag, &taglen, &p->mm,
			     p->inputcbdata)) == XML_OK) {
		p->content = content;
		p->contentlen = contentlen;
		if (*tag == '/') {
			if ((r = p->worker(new ? NORMALCLOSE_ : FRAMECLOSE_,
					   tag + 1, taglen - 1, p)) != XML_OK)
				return r;

			return XML_OK; /* back one level */
		} else if (*tag == '!') {
			/* Comments */
			if ((r = p->worker(COMMENT_, tag, taglen, p)) != XML_OK)
				return r;
		} else if (*tag == '?') {
			/* Prolog */
			if ((r = p->worker(PROLOG_, tag, taglen, p)) != XML_OK)
				return r;
		} else if (tag[taglen - 1] == '/') {
			/* self closing tag */
			if ((r = p->worker(SELFCLOSE_, tag, taglen, p)) !=
			    XML_OK)
				return r;
		} else {
			if ((r = p->worker(OPENTAG_, tag, taglen, p)) != XML_OK)
				return r;

			p->level++;
			if ((r = parse(p)) != XML_OK)
				return r;
			p->level--;
		}

		new = 0;
	}

	if (contentlen || taglen) {
		if ((r = p->worker(UNKNOWN_, tag, taglen, p)) != XML_OK)
			return r;
	}

	if (p->level)
		return ERRHIERAR;

	return XML_OK;
}

void done(Parser *p)
{
	free(p->mm.b);
	memset(p, 0, sizeof *p);
}

Memblock get_attribute(const uint8_t *tag, size_t taglen, const char *attribute)
{
	int i = 0;
	Memblock m = (Memblock){ strlen(attribute), (uint8_t *)attribute };
	for (; i < (int)taglen - 3 - (int)m.z; ++i) {
		if (tag[i + m.z + 1] == '=' && tag[i + m.z + 2] == '\"' &&
		    memchr(" \n\r\t\v\f", tag[i], 6) != 0 &&
		    !memcmp(tag + i + 1, m.b, m.z)) {
			size_t r = i + m.z + 3;
			m.b = tag + r;
			m.z = 0;
			while (r < taglen && tag[r++] != '\"') {
				++m.z;
			}
			return m;
		}
	}
	return m.b = 0, m;
}
