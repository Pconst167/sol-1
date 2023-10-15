#include "stdio.h"

char *str = "\033[38;2;8;202;40m";
char *strWhite = "\033[38;2;255;255;255m";

char *start = "\033[2J";
char *init = "\033[";
char *semicolon = ";";
char *H = "H";


void print(int w, int h, char c){
            //printf("\033[%i;%iH%c", h, w, c);
			printf(init);
			print_unsigned(h);
			printf(semicolon);
			print_unsigned(w);
			printf(H);

	_putchar(c);
	return;
}


int main(){
	char c_ref [32];
	int rnd_h[24];	
	int rnd_w[80];

  printf(start);

	rnd_w[0] =15;
	rnd_w[1] =65;
	rnd_w[2] =1;
	rnd_w[3] =39;
	rnd_w[4] =11;
	rnd_w[5] =8;
	rnd_w[6] =76;
	rnd_w[7] =27;
	rnd_w[8] =22;
	rnd_w[9] =31;
	rnd_w[10] =7;
	rnd_w[11] =33;
	rnd_w[12] =21;
	rnd_w[13] =49;
	rnd_w[14] =58;
	rnd_w[15] =53;
	rnd_w[16] =12;
	rnd_w[17] =79;
	rnd_w[18] =16;
	rnd_w[19] =4;
	rnd_w[20] =62;
	rnd_w[21] =30;
	rnd_w[22] =46;
	rnd_w[23] =67;
	rnd_w[24] =60;
	rnd_w[25] =35;
	rnd_w[26] =28;
	rnd_w[27] =47;
	rnd_w[28] =29;
	rnd_w[29] =57;
	rnd_w[30] =42;
	rnd_w[31] =23;
	rnd_w[32] =43;
	rnd_w[33] =54;
	rnd_w[34] =19;
	rnd_w[35] =34;
	rnd_w[36] =56;
	rnd_w[37] =41;
	rnd_w[38] =3;
	rnd_w[39] =5;
	rnd_w[40] =48;
	rnd_w[41] =71;
	rnd_w[42] =36;
	rnd_w[43] =32;
	rnd_w[44] =40;
	rnd_w[45] =25;
	rnd_w[46] =51;
	rnd_w[47] =55;
	rnd_w[48] =20;
	rnd_w[49] =14;
	rnd_w[50] =72;
	rnd_w[51] =26;
	rnd_w[52] =6;
	rnd_w[53] =70;
	rnd_w[54] =18;
	rnd_w[55] =77;
	rnd_w[56] =38;
	rnd_w[57] =73;
	rnd_w[58] =74;
	rnd_w[59] =13;
	rnd_w[60] =80;
	rnd_w[61] =75;
	rnd_w[62] =45;
	rnd_w[63] =10;
	rnd_w[64] =69;
	rnd_w[65] =24;
	rnd_w[66] =63;
	rnd_w[67] =52;
	rnd_w[68] =50;
	rnd_w[69] =61;
	rnd_w[70] =59;
	rnd_w[71] =66;
	rnd_w[72] =2;
	rnd_w[73] =37;
	rnd_w[74] =17;
	rnd_w[75] =68;
	rnd_w[76] =9;
	rnd_w[77] =78;
	rnd_w[78] =64;
	rnd_w[79] =44;

	rnd_h[0] =13;
	rnd_h[1] =24;
	rnd_h[2] =19;
	rnd_h[3] =16;
	rnd_h[4] =15;
	rnd_h[5] =21;
	rnd_h[6] =22;
	rnd_h[7] =23;
	rnd_h[8] =10;
	rnd_h[9] =3;
	rnd_h[10] =8;
	rnd_h[11] =14;
	rnd_h[12] =5;
	rnd_h[13] =6;
	rnd_h[14] =7;
	rnd_h[15] =17;
	rnd_h[16] =2;
	rnd_h[17] =11;
	rnd_h[18] =18;
	rnd_h[19] =1;
	rnd_h[20] =20;
	rnd_h[21] =9;
	rnd_h[22] =12;
	rnd_h[23] =4;

	c_ref[0] ='9';
	c_ref[1] ='&';
	c_ref[2] ='.';
	c_ref[3] ='3';
	c_ref[4] ='5';
	c_ref[5] ='#';
	c_ref[6] =',';
	c_ref[7] =':';
	c_ref[8] ='%';
	c_ref[9] ='!';
	c_ref[10] ='"';
	c_ref[11] =')';
	c_ref[12] ='2';
	c_ref[13] ='/';
	c_ref[14] ='<';
	c_ref[15] ='(';
	c_ref[16] ='*';
	c_ref[17] ='7';
	c_ref[18] ='$';
	c_ref[19] ='!';
	c_ref[20] ='1';
	c_ref[21] ='6';
	c_ref[22] ='4';
	c_ref[23] ='&';
	c_ref[24] ='-';
	c_ref[25] ='8';
	c_ref[26] ='=';
	c_ref[27] ='0';
	c_ref[28] ='+';
	c_ref[29] ='>';
	c_ref[30] ='*';
	c_ref[31] =' ';

  char c;

	int i;
	int w;
	int h;
	i = 0; w = 0; h = 0;

	int ii;	ii = 0;
	int start; start = 0;
	
	while(1){
        
		print(rnd_w[w], rnd_h[h], c_ref[i]);

		w++; if( w >= 80) w = 0;
		h++; if( h >= 24){
			h = ii;
			if (ii == 0) ii = 1; else ii = 0;
		}
		i++; if( i >= 33) i = 0;
		
		if(start >= 100) start = 0;
     
  }
  

  return 0;
}