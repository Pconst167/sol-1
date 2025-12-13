#define MAX_LINE 256

typedef struct {
  char original[MAX_LINE];  // full original line
  char label[64];           // label before the instruction, if any (e.g. "_for1_init:")
  char opcode[32];          // e.g. "mov", "mov32", "lea", "cmp", "slt", "sor", "enter"
  char operands[128];       // everything after the opcode up to comment
  char comment[128];        // "; ..." if present
  int  is_instruction;      // 1 if this is really an instruction
  int  is_label_only;       // "foo:" with no opcode
} asm_line;
