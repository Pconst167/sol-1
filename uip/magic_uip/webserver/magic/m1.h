// Magic-1 specific declarations


#define CONSOLE 0
#define AUX 1

void kputc( u8_t c, u16_t stream );
u16_t kgetc( u16_t stream );
u16_t _read_ser( u16_t dev, u8_t *p, u16_t max);
u16_t _write_ser( u16_t dev, u8_t *p, u16_t max);
#define SUSPEND_ON_INPUT 1
#define SUSPEND_ON_OUTPUT 2
void _suspend( u16_t dev, u16_t direction);
void _timeout( u16_t ticks );

