
	Flight Simulator RGB Modifications

		By: Andrew Tuline

		CIS: 70465,1223

	The modifications included herein will allow an RGB
monitor to show some colours using the Flight Simulator program.
This modification is not perfect, nor is is very well tested.
The user should make a copy of their Flight Simulator program
using their favourite technique. As we know even the most
obvious methods may elude us. Anyways, one of the bugs is, when
the user enters the slew mode, the modifications are nullified.
Basically, the technique is to intercept the disk vector and
setup a port for the colour display adapter for the needed
values. I certainly hope, that by disclosing this technique,
Microsoft doesn't skin my hide. Anyways to modify your extra
spare disk, boot up debug in DOS 2.0 and type the following:

Note: you need a system with at least 96K to use this
modification as is.

L CS:0 0 0 1	  (FLIGHT SIMULATOR DISK IN DRIVE A)
A 0
mov	ax,201
mov	dx,0
mov	CL,2
mov	ch,27
mov	bx,1000
mov	es,bx
xor	bx,bx
int	13
jmp	1000:0
W CS:0 0 0 1



L CS:0 0 139 1	  (FLIGHT SIMULATOR DISK IN DRIVE A)
A 0
push	cs
pop	ds
mov	ax,0
mov	es,ax
es:
mov	ax,[4c]
mov	[70],ax
es:
mov	ax,[4e]
mov	[72],ax
mov	ax,48
es:
mov	[4c],ax
es:
mov	[4e],cs

cli
xor	ax,ax
mov	ds,ax
mov	es,ax
mov	ss,ax
mov	sp,c0b0
mov	cx,200
mov	SI,7c00
mov	DI,500
sti
repz
movsb
jmp	0:7c18


a 48
pushf
push	cs
cs:
mov	[74],ax
mov	ax,5b
push	ax
cs:
mov	ax,[74]
jmp	F000:EC59  <- this is also saved at 1000:0070
pushf
push	ax
push	dx
mov	dx,3d8
mov	AL,0a
out	dx,AL
inc	dx
mov	AL,20
out	dx,AL
pop	dx
pop	ax
popf
iret
W CS:0 0 139 1


The value 20 a couple of lines up sets up the colours for low
intensity cyan/magenta/white. Good luck, and may the colours
be with you!


