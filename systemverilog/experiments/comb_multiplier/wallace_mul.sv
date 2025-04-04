module wallace_mul(
  input  logic [7:0] a,
  input  logic [7:0] b,
  output logic [15:0] result
);

  logic [7:0][15:0] partial;
  logic [15:0]      product;
  logic [15:0]      carry;

/*
                        a3  a2  a1  a0
                        b3  b2  b1  b0
                   b0a3 b0a2 b0a1 b0a0     partial[0]
              b1a3 b1a2 b1a1 b1a0          partial[1]
         b2a3 b2a2 b2a1 b2a0               partial[2]
    b3a3 b3a2 b3a1 b3a0                    partial[3]
 p7   p6   p5   p4   p3   p2   p1   p0
*/

  logic [14:0] stage1_0;
  logic [14:0] stage1_1;
  logic [14:0] stage1_2;
  logic [14:0] stage1_3;
  logic [14:0] stage1_4;
  logic [14:0] stage1_5;

  logic [14:0] stage2_0;
  logic [14:0] stage2_1;
  logic [14:0] stage2_2;
  logic [14:0] stage2_3;

  logic [14:0] stage3_0;
  logic [14:0] stage3_1;
  logic [14:0] stage3_2;

  logic [14:0] stage4_0;
  logic [14:0] stage4_1;


  for(genvar i = 0; i < 8; i++) 
    assign partial[i] = b[i] ? {{(8 - i){1'b0}},  a, {(i){1'b0}}} : 8'b0;


  assign stage1_0[0] = partial[0][0];
  assign stage1_1[0] = 1'b0;
  assign stage1_2[0] = 1'b0;
  assign stage1_3[0] = 1'b0;
  assign stage1_4[0] = 1'b0;
  assign stage1_5[0] = 1'b0;

  assign stage1_0[1] = partial[0][1] + partial[1][1];
  assign stage1_1[1] = 1'b0;
  assign stage1_2[1] = 1'b0;
  assign stage1_3[1] = 1'b0;
  assign stage1_4[1] = 1'b0;
  assign stage1_5[1] = 1'b0;

  assign stage1_0[2] = partial[0][2] + partial[1][2] + partial[2][2];
  assign stage1_1[2] = {2'(partial[0][1] + partial[1][1])}[1]; // carry
  assign stage1_2[2] = 1'b0;
  assign stage1_3[2] = 1'b0;
  assign stage1_4[2] = 1'b0;
  assign stage1_5[2] = 1'b0;

  assign stage1_0[3] = partial[0][3] + partial[1][3] + partial[2][3];
  assign stage1_1[3] = {2'(partial[0][2] + partial[1][2] + partial[2][2])}[1]; // carry
  assign stage1_2[3] = partial[3][3];
  assign stage1_3[3] = 1'b0;
  assign stage1_4[3] = 1'b0;
  assign stage1_5[3] = 1'b0;

  assign stage1_0[4] = partial[0][4] + partial[1][4] + partial[2][4];
  assign stage1_1[4] = partial[3][4] + partial[4][4];
  assign stage1_2[4] = {2'(partial[0][3] + partial[1][3] + partial[2][3])}[1]; // carry
  assign stage1_3[4] = 1'b0;
  assign stage1_4[4] = 1'b0;
  assign stage1_5[4] = 1'b0;

  assign stage1_0[5] = partial[0][5] + partial[1][5] + partial[2][5];
  assign stage1_1[5] = partial[3][5] + partial[4][5] + partial[5][5];
  assign stage1_2[5] = {2'(partial[0][4] + partial[1][4] + partial[2][4])}[1]; // carry
  assign stage1_3[5] = {2'(partial[3][4] + partial[4][4])}[1]; // carry
  assign stage1_4[5] = {2'(partial[0][4] + partial[1][4] + partial[2][4])}[1]; // carry
  assign stage1_5[5] = 1'b0;

  assign stage1_0[6] = partial[0][6] + partial[1][6] + partial[2][6];
  assign stage1_1[6] = partial[3][6] + partial[4][6] + partial[5][6];
  assign stage1_2[6] = {2'(partial[0][5] + partial[1][5] + partial[2][5])}[1]; // carry
  assign stage1_3[6] = {2'(partial[3][5] + partial[4][5] + partial[5][5])}[1]; // carry
  assign stage1_4[6] = partial[6][6];
  assign stage1_5[6] = 1'b0;

  assign stage1_0[7] = partial[0][7] + partial[1][7] + partial[2][7];
  assign stage1_1[7] = partial[3][7] + partial[4][7] + partial[5][7];
  assign stage1_2[7] = {2'(partial[0][6] + partial[1][6] + partial[2][6])}[1]; // carry
  assign stage1_3[7] = {2'(partial[3][6] + partial[4][6] + partial[5][6])}[1]; // carry
  assign stage1_4[7] = partial[6][7];
  assign stage1_5[7] = partial[7][7];

  assign stage1_0[8] = partial[1][8] + partial[2][8];
  assign stage1_1[8] = partial[3][8] + partial[4][8] + partial[5][8];
  assign stage1_2[8] = {2'(partial[0][7] + partial[1][7] + partial[2][7])}[1]; // carry
  assign stage1_3[8] = {2'(partial[3][7] + partial[4][7] + partial[5][7])}[1]; // carry
  assign stage1_4[8] = partial[6][8];
  assign stage1_5[8] = partial[7][8];

  assign stage1_0[9] = partial[2][9];
  assign stage1_1[9] = partial[3][9] + partial[4][9] + partial[5][9];
  assign stage1_2[9] = {2'(partial[1][8] + partial[2][8])}[1]; // carry
  assign stage1_3[9] = {2'(partial[3][8] + partial[4][8] + partial[5][8])}[1]; // carry
  assign stage1_4[9] = partial[6][9];
  assign stage1_5[9] = partial[7][9];

  assign stage1_0[10] = 1'b0;
  assign stage1_1[10] = 1'b0;
  assign stage1_2[10] = partial[3][10] + partial[4][10] + partial[5][10];
  assign stage1_3[10] = {2'(partial[3][9] + partial[4][9] + partial[5][9])}[1]; // carry
  assign stage1_4[10] = partial[6][10];
  assign stage1_5[10] = partial[7][10];

  assign stage1_0[11] = 1'b0;
  assign stage1_1[11] = 1'b0;
  assign stage1_2[11] = partial[4][11] + partial[5][11];
  assign stage1_3[11] = {2'(partial[3][10] + partial[4][10] + partial[5][10])}[1]; // carry
  assign stage1_4[11] = partial[6][11];
  assign stage1_5[11] = partial[7][11];

  assign stage1_0[12] = 1'b0;
  assign stage1_1[12] = 1'b0;
  assign stage1_2[12] = {2'(partial[4][11] + partial[5][11])}[1]; // carry
  assign stage1_3[12] = partial[5][12];
  assign stage1_4[12] = partial[6][12];
  assign stage1_5[12] = partial[7][12];

  assign stage1_0[13] = 1'b0;
  assign stage1_1[13] = 1'b0;
  assign stage1_2[13] = 1'b0;
  assign stage1_3[13] = 1'b0;
  assign stage1_4[13] = partial[6][13];
  assign stage1_5[13] = partial[7][13];

  assign stage1_0[14] = 1'b0;
  assign stage1_1[14] = 1'b0;
  assign stage1_2[14] = 1'b0;
  assign stage1_3[14] = 1'b0;
  assign stage1_4[14] = 1'b0;
  assign stage1_5[14] = partial[7][14];

  // stage 2

  assign stage2_0[0] = stage1_0[0];
  assign stage2_1[0] = 1'b0;
  assign stage2_2[0] = 1'b0;
  assign stage2_3[0] = 1'b0;

  assign stage2_0[1] = stage1_0[1];
  assign stage2_1[1] = 1'b0;
  assign stage2_2[1] = 1'b0;
  assign stage2_3[1] = 1'b0;

  assign stage2_0[2] = stage1_0[2] + stage1_1[2];
  assign stage2_1[2] = 1'b0;
  assign stage2_2[2] = 1'b0;
  assign stage2_3[2] = 1'b0;

  assign stage2_0[3] = stage1_0[3] + stage1_1[3] + stage1_2[3];
  assign stage2_1[3] = {2'(stage1_0[2] + stage1_1[2])}[1];
  assign stage2_2[3] = 1'b0;
  assign stage2_3[3] = 1'b0;

  assign stage2_0[4] = stage1_0[4] + stage1_1[4] + stage1_2[4];
  assign stage2_1[4] = {2'(stage1_0[3] + stage1_1[3] + stage1_2[3])}[1];
  assign stage2_2[4] = 1'b0;
  assign stage2_3[4] = 1'b0;

  assign stage2_0[5] = stage1_0[5] + stage1_1[5] + stage1_2[5];
  assign stage2_1[5] = {2'(stage1_0[4] + stage1_1[4] + stage1_2[4])}[1];
  assign stage2_2[5] = stage1_3[5];
  assign stage2_3[5] = 1'b0;

  assign stage2_0[6] = stage1_0[6] + stage1_1[6] + stage1_2[6];
  assign stage2_1[6] = stage1_3[6] + stage1_4[6];
  assign stage2_2[6] = {2'(stage1_0[5] + stage1_1[5] + stage1_2[5])}[1];
  assign stage2_3[6] = 1'b0;

  assign stage2_0[7] = stage1_0[7] + stage1_1[7] + stage1_2[7];
  assign stage2_1[7] = stage1_3[7] + stage1_4[7] + stage1_5[7];
  assign stage2_2[7] = {2'(stage1_0[6] + stage1_1[6] + stage1_2[6])}[1];
  assign stage2_3[7] = {2'(stage1_3[6] + stage1_4[6])}[1];

  assign stage2_0[8] = stage1_0[8] + stage1_1[8] + stage1_2[8];
  assign stage2_1[8] = stage1_3[8] + stage1_4[8] + stage1_5[8];
  assign stage2_2[8] = {2'(stage1_0[7] + stage1_1[7] + stage1_2[7])}[1];
  assign stage2_3[8] = {2'(stage1_3[7] + stage1_4[7] + stage1_5[7])}[1];

  assign stage2_0[9] = stage1_0[9] + stage1_1[9] + stage1_2[9];
  assign stage2_1[9] = stage1_3[9] + stage1_4[9] + stage1_5[9];
  assign stage2_2[9] = {2'(stage1_0[8] + stage1_1[8] + stage1_2[8])}[1];
  assign stage2_3[9] = {2'(stage1_3[8] + stage1_4[8] + stage1_5[8])}[1];

  assign stage2_0[10] = stage1_2[10];
  assign stage2_1[10] = stage1_3[10] + stage1_4[10] + stage1_5[10];
  assign stage2_2[10] = {2'(stage1_0[9] + stage1_1[9] + stage1_2[9])}[1];
  assign stage2_3[10] = {2'(stage1_3[9] + stage1_4[9] + stage1_5[9])}[1];

  assign stage2_0[11] = 1'b0;
  assign stage2_1[11] = stage1_3[11] + stage1_4[11] + stage1_5[11];
  assign stage2_2[11] = {2'(stage1_3[10] + stage1_4[10] + stage1_5[10])}[1];
  assign stage2_3[11] = stage1_2[11];

  assign stage2_0[12] = 1'b0;
  assign stage2_1[12] = stage1_3[12] + stage1_4[12] + stage1_5[12];
  assign stage2_2[12] = {2'(stage1_3[11] + stage1_4[11] + stage1_5[11])}[1];
  assign stage2_3[12] = stage1_2[12];

  assign stage2_0[13] = 1'b0;
  assign stage2_1[13] = 1'b0;
  assign stage2_2[13] = stage1_4[13] + stage1_5[13];
  assign stage2_3[13] = {2'(stage1_3[12] + stage1_4[12] + stage1_5[12])}[1];

  assign stage2_0[14] = 1'b0;
  assign stage2_1[14] = 1'b0;
  assign stage2_2[14] = stage1_5[14];
  assign stage2_3[14] = {2'(stage1_4[13] + stage1_5[13])}[1];

  // stage 3
  assign stage3_0[0] = stage2_0[0];
  assign stage3_1[0] = 1'b0;
  assign stage3_2[0] = 1'b0;

  assign stage3_0[1] = stage2_0[1];
  assign stage3_1[1] = 1'b0;
  assign stage3_2[1] = 1'b0;

  assign stage3_0[2] = stage2_0[2];
  assign stage3_1[2] = 1'b0;
  assign stage3_2[2] = 1'b0;

  assign stage3_0[3] = stage2_0[3] + stage2_1[3];
  assign stage3_1[3] = 1'b0;
  assign stage3_2[3] = 1'b0;

  assign stage3_0[4] = stage2_0[4] + stage2_1[4];
  assign stage3_1[4] = {2'(stage2_0[3] + stage2_1[3])}[1]; // carry
  assign stage3_2[4] = 1'b0;

  assign stage3_0[5] = stage2_0[5] + stage2_1[5] + stage2_2[5];
  assign stage3_1[5] = {2'(stage2_0[4] + stage2_1[4])}[1]; // carry
  assign stage3_2[5] = 1'b0;

  assign stage3_0[6] = stage2_0[6] + stage2_1[6] + stage2_2[6];
  assign stage3_1[6] = {2'(stage2_0[5] + stage2_1[5] + stage2_2[5])}[1]; // carry
  assign stage3_2[6] = 1'b0;

  assign stage3_0[7] = stage2_0[7] + stage2_1[7] + stage2_2[7];
  assign stage3_1[7] = {2'(stage2_0[6] + stage2_1[6] + stage2_2[6])}[1]; // carry
  assign stage3_2[7] = stage2_3[7];

  assign stage3_0[8] = stage2_0[8] + stage2_1[8] + stage2_2[8];
  assign stage3_1[8] = {2'(stage2_0[7] + stage2_1[7] + stage2_2[7])}[1]; // carry
  assign stage3_2[8] = stage2_3[8];

  assign stage3_0[9] = stage2_0[9] + stage2_1[9] + stage2_2[9];
  assign stage3_1[9] = {2'(stage2_0[8] + stage2_1[8] + stage2_2[8])}[1]; // carry
  assign stage3_2[9] = stage2_3[9];

  assign stage3_0[10] = stage2_0[10] + stage2_1[10] + stage2_2[10];
  assign stage3_1[10] = {2'(stage2_0[9] + stage2_1[9] + stage2_2[9])}[1]; // carry
  assign stage3_2[10] = stage2_3[10];

  assign stage3_0[11] = stage2_1[11] + stage2_2[11];
  assign stage3_1[11] = {2'(stage2_0[10] + stage2_1[10] + stage2_2[10])}[1]; // carry
  assign stage3_2[11] = stage2_3[11];

  assign stage3_0[12] = stage2_1[12] + stage2_2[12];
  assign stage3_1[12] = {2'(stage2_1[11] + stage2_2[11])}[1]; // carry
  assign stage3_2[12] = stage2_3[12];

  assign stage3_0[13] = {2'(stage2_1[12] + stage2_2[12])}[1];
  assign stage3_1[13] = stage2_2[13];
  assign stage3_2[13] = stage2_3[13];

  assign stage3_0[14] = 1'b0;
  assign stage3_1[14] = stage2_2[14];
  assign stage3_2[14] = stage2_3[14];

  // stage 4
  assign stage4_0[0] = stage3_0[0];
  assign stage4_1[0] = 1'b0;

  assign stage4_0[1] = stage3_0[1];
  assign stage4_1[1] = 1'b0;

  assign stage4_0[2] = stage3_0[2];
  assign stage4_1[2] = 1'b0;

  assign stage4_0[3] = stage3_0[3];
  assign stage4_1[3] = 1'b0;

  assign stage4_0[4] = stage3_0[4] + stage3_1[4];
  assign stage4_1[4] = 1'b0;

  assign stage4_0[5] = stage3_0[5] + stage3_1[5];
  assign stage4_1[5] = {2'(stage3_0[4] + stage3_1[4])}[1]; // carry

  assign stage4_0[6] = stage3_0[6] + stage3_1[6];
  assign stage4_1[6] = {2'(stage3_0[5] + stage3_1[5])}[1]; // carry

  assign stage4_0[7] = stage3_0[7] + stage3_1[7] + stage3_2[7];
  assign stage4_1[7] = {2'(stage3_0[6] + stage3_1[6])}[1]; // carry

  assign stage4_0[8] = stage3_0[8] + stage3_1[8] + stage3_2[8];
  assign stage4_1[8] = {2'(stage3_0[7] + stage3_1[7] + stage3_2[7])}[1]; // carry

  assign stage4_0[9] = stage3_0[9] + stage3_1[9] + stage3_2[9];
  assign stage4_1[9] = {2'(stage3_0[8] + stage3_1[8] + stage3_2[8])}[1]; // carry

  assign stage4_0[10] = stage3_0[10] + stage3_1[10] + stage3_2[10];
  assign stage4_1[10] = {2'(stage3_0[9] + stage3_1[9] + stage3_2[9])}[1]; // carry

  assign stage4_0[11] = stage3_0[11] + stage3_1[11] + stage3_2[11];
  assign stage4_1[11] = {2'(stage3_0[10] + stage3_1[10] + stage3_2[10])}[1]; // carry

  assign stage4_0[12] = stage3_0[12] + stage3_1[12] + stage3_2[12];
  assign stage4_1[12] = {2'(stage3_0[11] + stage3_1[11] + stage3_2[11])}[1]; // carry

  assign stage4_0[13] = stage3_0[13] + stage3_1[13] + stage3_2[13];
  assign stage4_1[13] = {2'(stage3_0[12] + stage3_1[12] + stage3_2[12])}[1]; // carry

  assign stage4_0[14] = stage3_1[14] + stage3_2[14];
  assign stage4_1[14] = {2'(stage3_0[13] + stage3_1[13] + stage3_2[13])}[1]; // carry

  assign stage4_0[15] = {2'(stage3_1[14] + stage3_2[14])}[1]; // carry
  assign stage4_1[15] = 1'b0; // carry



  assign result = product;

endmodule

