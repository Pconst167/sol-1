/*
 * Dumps InfoIC2Plus.dll version 100 (6.60)
 *
 * Compiles with MinGW-w64, GCC 6.3
 *
 * i686-w64-mingw32-gcc -o dump-infoic-dll.exe -m32 -Wall -W dump-infoic-dll.c
 * wine dump-infoic-dll.exe > windb.json
 *
 * Reference:
 * http://www.nullsecurity.org/article/minipro_reverse_engineering_the_infoic_dll
 */

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

#define FATAL(fmt, args...)                                  \
	do {                                                 \
		fprintf(stderr, "ERROR: " fmt "\n", ##args); \
		exit(1);                                     \
	} while (0)

typedef int (*GetDllInfoProc)(int *, int *);

typedef struct {
	DWORD protocol_id; // 0x00
	DWORD u04_dw;	   // 0x04 - ??? always 0
	DWORD type; // 0x08 - Chip type: 0=""; 1="EEPROM"; 2="MCU/MPU"; 3="PLD/CPLD"; 4="SRAM"; 5="LOGIC"
	char name[40];		   // 0x0c
	DWORD variant;		   // 0x34
	DWORD code_memory_size;	   // 0x38
	DWORD data_memory_size;	   // 0x3c
	DWORD data_memory2_size;   // 0x40
	DWORD u44_dw;		   // 0x44
	WORD read_buffer_size;	   // 0x48
	WORD write_buffer_size;	   // 0x4a
	DWORD u4c_dw;		   // 0x4c - ???
	DWORD opts1;		   // 0x50
	DWORD opts2;		   // 0x54
	DWORD opts3;		   // 0x58
	BYTE chip_id[8];	   // 0x5c
	DWORD chip_id_bytes_count; // 0x64
	DWORD u68_dw;		   // 0x68 - ???
	DWORD package_details;	   // 0x70
	DWORD opts4;		   // 0x74
} __attribute__((__packed__)) Ic_100;

typedef struct {
	DWORD id;
	DWORD logo_id;
	char short_name[20];
	char long_name[40];
	Ic_100 *ics;
	DWORD num_ics;
} Mfc_100;

typedef void (*GetMfcStruProc_100)(DWORD, Mfc_100 *);

static void hexcat(char *dest, const BYTE b)
{
	char buffer[3];
	snprintf(buffer, sizeof(buffer), "%02x", b);
	strcat(dest, buffer);
}

static void json_dump_ic_fields(FILE *fp, const Ic_100 *ic, const char *indent)
{
	char name[100] = { 0 };
	strncat(name, ic->name, sizeof(ic->name));

	char chip_id[100] = { 0 };
	for (int i = 0; i < (int)ic->chip_id_bytes_count; ++i) {
		hexcat(chip_id, ic->chip_id[i]);
	}
#define PRINT(fmt, args...) fprintf(fp, "%s" fmt "\n", indent, ##args)
	PRINT("\"protocol_id\": %lu,", ic->protocol_id);
	PRINT("\"type\": %lu,", ic->type);
	PRINT("\"name\": \"%s\",", name);
	PRINT("\"variant\": %lu,", ic->variant);
	PRINT("\"code_memory_size\": %lu,", ic->code_memory_size);
	PRINT("\"data_memory_size\": %lu,", ic->data_memory_size);
	PRINT("\"data_memory2_size\": %lu,", ic->data_memory2_size);
	PRINT("\"read_buffer_size\": %u,", ic->read_buffer_size);
	PRINT("\"write_buffer_size\": %u,", ic->write_buffer_size);
	PRINT("\"opts1\": %lu,", ic->opts1);
	PRINT("\"opts2\": %lu,", ic->opts2);
	PRINT("\"opts3\": %lu,", ic->opts3);
	PRINT("\"chip_id\": \"%s\",", chip_id);
	PRINT("\"chip_id_bytes_count\": %lu,", ic->chip_id_bytes_count);
	PRINT("\"package_details\": %lu,", ic->package_details);
	PRINT("\"opts4\": %lu,", ic->opts4);

	PRINT("\"u04_dw\": %lu,", ic->u04_dw);
	PRINT("\"u44_dw\": %lu,", ic->u44_dw);
	PRINT("\"u4c_dw\": %lu,", ic->u4c_dw);
	PRINT("\"u68_dw\": %lu", ic->u68_dw);
#undef PRINT
}

static void json_dump_mfc_fields(FILE *fp, const Mfc_100 *mfc,
				 const char *indent)
{
	char ic_indent[100] = { 0 };
	strcat(ic_indent, indent);
	strcat(ic_indent, "    ");

	char short_name[100] = { 0 };
	char long_name[100] = { 0 };
	strncat(short_name, mfc->short_name, sizeof(mfc->short_name));
	strncat(long_name, mfc->long_name, sizeof(mfc->long_name));

#define PRINT(fmt, args...) fprintf(fp, "%s" fmt "\n", indent, ##args)
	PRINT("\"id\": %lu,", mfc->id);
	PRINT("\"short_name\": \"%s\",", short_name);
	PRINT("\"long_name\": \"%s\",", long_name);
	PRINT("\"ics\": [");
	for (int i = 0; i < (int)mfc->num_ics; ++i) {
		int last = i + 1 >= (int)mfc->num_ics;
		PRINT("  {");
		json_dump_ic_fields(fp, &mfc->ics[i], ic_indent);
		PRINT("  }%s", last ? "" : ",");
	}
	PRINT("]");
#undef PRINT
}

int main()
{
	HMODULE handle;
	GetDllInfoProc GetDllInfo;
	int num_ics, dll_version, num_mfcs;
	GetMfcStruProc_100 GetMfcStru;

	assert(sizeof(Ic_100) == 0x74);
	assert(sizeof(Mfc_100) == 0x4c);

	handle = LoadLibrary("InfoIC2Plus.dll");
	if (!handle) {
		FATAL("could not open InfoIC2Plus.dll");
	}

	GetDllInfo = (GetDllInfoProc)GetProcAddress(handle, "GetDllInfo");
	if (!GetDllInfo) {
		FATAL("function not found: GetDllInfo");
	}

	num_ics = GetDllInfo(&dll_version, &num_mfcs);
	fprintf(stderr,
		"Version %d\n"
		"%d manufacturers\n"
		"%d ics\n",
		dll_version, num_mfcs, num_ics);

	if (dll_version != 100) {
		FATAL("unsupported dll version %d", dll_version);
	}

	GetMfcStru = (GetMfcStruProc_100)GetProcAddress(handle, "GetMfcStru");
	if (!GetMfcStru) {
		FATAL("function not found: GetMfcStru");
	}

	fprintf(stdout, "[\n");
	for (int i = 0; i < num_mfcs; ++i) {
		int last = (i + 1) >= num_mfcs;
		Mfc_100 mfc;
		GetMfcStru(i, &mfc);
		fprintf(stdout, "  {\n");
		json_dump_mfc_fields(stdout, &mfc, "    ");
		fprintf(stdout, "  }%s\n", last ? "" : ",");
	}
	fprintf(stdout, "]\n");

	FreeLibrary(handle);
	return 0;
}
