module wallace_mul(
  input  logic [7:0] a,
  input  logic [7:0] b,
  output logic [15:0] result
);

  logic [7:0][15:0] partial;
  logic      [15:0] product;

/*
7,8,9 are wrong
                        a3  a2  a1  a0
                        b3  b2  b1  b0
                   b0a3 b0a2 b0a1 b0a0     partial[0]
              b1a3 b1a2 b1a1 b1a0          partial[1]
         b2a3 b2a2 b2a1 b2a0               partial[2]
    b3a3 b3a2 b3a1 b3a0                    partial[3]
 p7   p6   p5   p4   p3   p2   p1   p0
*/

  logic [5:0][14:0] stage1;
  logic [3:0][14:0] stage2;
  logic [2:0][14:0] stage3;
  logic [1:0][15:0] stage4;


  for(genvar i = 0; i < 8; i++) 
    assign partial[i] = b[i] ? {{(8 - i){1'b0}},  a, {(i){1'b0}}} : 8'b0;


  assign stage1[0] = {
                       5'b00000,
                       partial[2][9],
                       partial[1][8] + partial[2][8],
                       partial[0][7] + partial[1][7] + partial[2][7],
                       partial[0][6] + partial[1][6] + partial[2][6],
                       partial[0][5] + partial[1][5] + partial[2][5],
                       partial[0][4] + partial[1][4] + partial[2][4],
                       partial[0][3] + partial[1][3] + partial[2][3],
                       partial[0][2] + partial[1][2] + partial[2][2],
                       partial[0][1] + partial[1][1],
                       partial[0][0]
                     };

  assign stage1[1] = {
                       5'b00000,
                       partial[3][9] + partial[4][9] + partial[5][9],
                       partial[3][8] + partial[4][8] + partial[5][8],
                       partial[3][7] + partial[4][7] + partial[5][7],
                       partial[3][6] + partial[4][6] + partial[5][6],
                       partial[3][5] + partial[4][5] + partial[5][5],
                       partial[3][4] + partial[4][4],
                       {2'(partial[0][2] + partial[1][2] + partial[2][2])}[1],
                       {2'(partial[0][1] + partial[1][1])}[1],
                       2'b00
                     };

  assign stage1[2] = {
                       2'b00,
                       {2'(partial[4][11] + partial[5][11])}[1],
                       partial[4][11] + partial[5][11],
                       partial[3][10] + partial[4][10] + partial[5][10],
                       {2'(partial[1][8] + partial[2][8])}[1],
                       {2'(partial[0][7] + partial[1][7] + partial[2][7])}[1],
                       {2'(partial[0][6] + partial[1][6] + partial[2][6])}[1],
                       {2'(partial[0][5] + partial[1][5] + partial[2][5])}[1],
                       {2'(partial[0][4] + partial[1][4] + partial[2][4])}[1],
                       {2'(partial[0][3] + partial[1][3] + partial[2][3])}[1],
                       partial[3][3],
                       3'b000
                     };


  assign stage1[3][0] = 1'b0;
  assign stage1[4][0] = 1'b0;
  assign stage1[5][0] = 1'b0;

  assign stage1[3][1] = 1'b0;
  assign stage1[4][1] = 1'b0;
  assign stage1[5][1] = 1'b0;

  assign stage1[3][2] = 1'b0;
  assign stage1[4][2] = 1'b0;
  assign stage1[5][2] = 1'b0;

  assign stage1[3][3] = 1'b0;
  assign stage1[4][3] = 1'b0;
  assign stage1[5][3] = 1'b0;

  assign stage1[3][4] = 1'b0;
  assign stage1[4][4] = 1'b0;
  assign stage1[5][4] = 1'b0;

  assign stage1[3][5] = {2'(partial[3][4] + partial[4][4])}[1]; // carry
  assign stage1[4][5] = 1'b0;
  assign stage1[5][5] = 1'b0;

  assign stage1[3][6] = {2'(partial[3][5] + partial[4][5] + partial[5][5])}[1]; // carry
  assign stage1[4][6] = partial[6][6];
  assign stage1[5][6] = 1'b0;

  assign stage1[3][7] = {2'(partial[3][6] + partial[4][6] + partial[5][6])}[1]; // carry
  assign stage1[4][7] = partial[6][7];
  assign stage1[5][7] = partial[7][7];

  assign stage1[3][8] = {2'(partial[3][7] + partial[4][7] + partial[5][7])}[1]; // carry
  assign stage1[4][8] = partial[6][8];
  assign stage1[5][8] = partial[7][8];

  assign stage1[3][9] = {2'(partial[3][8] + partial[4][8] + partial[5][8])}[1]; // carry
  assign stage1[4][9] = partial[6][9];
  assign stage1[5][9] = partial[7][9];

  assign stage1[3][10] = {2'(partial[3][9] + partial[4][9] + partial[5][9])}[1]; // carry
  assign stage1[4][10] = partial[6][10];
  assign stage1[5][10] = partial[7][10];

  assign stage1[3][11] = {2'(partial[3][10] + partial[4][10] + partial[5][10])}[1]; // carry
  assign stage1[4][11] = partial[6][11];
  assign stage1[5][11] = partial[7][11];

  assign stage1[3][12] = partial[5][12];
  assign stage1[4][12] = partial[6][12];
  assign stage1[5][12] = partial[7][12];

  assign stage1[3][13] = 1'b0;
  assign stage1[4][13] = partial[6][13];
  assign stage1[5][13] = partial[7][13];

  assign stage1[3][14] = 1'b0;
  assign stage1[4][14] = 1'b0;
  assign stage1[5][14] = partial[7][14];

  // stage 2
  assign stage2[0][0] = stage1[0][0];
  assign stage2[1][0] = 1'b0;
  assign stage2[2][0] = 1'b0;
  assign stage2[3][0] = 1'b0;

  assign stage2[0][1] = stage1[0][1];
  assign stage2[1][1] = 1'b0;
  assign stage2[2][1] = 1'b0;
  assign stage2[3][1] = 1'b0;

  assign stage2[0][2] = stage1[0][2] + stage1[1][2];
  assign stage2[1][2] = 1'b0;
  assign stage2[2][2] = 1'b0;
  assign stage2[3][2] = 1'b0;

  assign stage2[0][3] = stage1[0][3] + stage1[1][3] + stage1[2][3];
  assign stage2[1][3] = {2'(stage1[0][2] + stage1[1][2])}[1];
  assign stage2[2][3] = 1'b0;
  assign stage2[3][3] = 1'b0;

  assign stage2[0][4] = stage1[0][4] + stage1[1][4] + stage1[2][4];
  assign stage2[1][4] = {2'(stage1[0][3] + stage1[1][3] + stage1[2][3])}[1];
  assign stage2[2][4] = 1'b0;
  assign stage2[3][4] = 1'b0;

  assign stage2[0][5] = stage1[0][5] + stage1[1][5] + stage1[2][5];
  assign stage2[1][5] = {2'(stage1[0][4] + stage1[1][4] + stage1[2][4])}[1];
  assign stage2[2][5] = stage1[3][5];
  assign stage2[3][5] = 1'b0;

  assign stage2[0][6] = stage1[0][6] + stage1[1][6] + stage1[2][6];
  assign stage2[1][6] = stage1[3][6] + stage1[4][6];
  assign stage2[2][6] = {2'(stage1[0][5] + stage1[1][5] + stage1[2][5])}[1];
  assign stage2[3][6] = 1'b0;

  assign stage2[0][7] = stage1[0][7] + stage1[1][7] + stage1[2][7];
  assign stage2[1][7] = stage1[3][7] + stage1[4][7] + stage1[5][7];
  assign stage2[2][7] = {2'(stage1[0][6] + stage1[1][6] + stage1[2][6])}[1];
  assign stage2[3][7] = {2'(stage1[3][6] + stage1[4][6])}[1];

  assign stage2[0][8] = stage1[0][8] + stage1[1][8] + stage1[2][8];
  assign stage2[1][8] = stage1[3][8] + stage1[4][8] + stage1[5][8];
  assign stage2[2][8] = {2'(stage1[0][7] + stage1[1][7] + stage1[2][7])}[1];
  assign stage2[3][8] = {2'(stage1[3][7] + stage1[4][7] + stage1[5][7])}[1];

  assign stage2[0][9] = stage1[0][9] + stage1[1][9] + stage1[2][9];
  assign stage2[1][9] = stage1[3][9] + stage1[4][9] + stage1[5][9];
  assign stage2[2][9] = {2'(stage1[0][8] + stage1[1][8] + stage1[2][8])}[1];
  assign stage2[3][9] = {2'(stage1[3][8] + stage1[4][8] + stage1[5][8])}[1];

  assign stage2[0][10] = stage1[2][10];
  assign stage2[1][10] = stage1[3][10] + stage1[4][10] + stage1[5][10];
  assign stage2[2][10] = {2'(stage1[0][9] + stage1[1][9] + stage1[2][9])}[1];
  assign stage2[3][10] = {2'(stage1[3][9] + stage1[4][9] + stage1[5][9])}[1];

  assign stage2[0][11] = 1'b0;
  assign stage2[1][11] = stage1[3][11] + stage1[4][11] + stage1[5][11];
  assign stage2[2][11] = {2'(stage1[3][10] + stage1[4][10] + stage1[5][10])}[1];
  assign stage2[3][11] = stage1[2][11];

  assign stage2[0][12] = 1'b0;
  assign stage2[1][12] = stage1[3][12] + stage1[4][12] + stage1[5][12];
  assign stage2[2][12] = {2'(stage1[3][11] + stage1[4][11] + stage1[5][11])}[1];
  assign stage2[3][12] = stage1[2][12];

  assign stage2[0][13] = 1'b0;
  assign stage2[1][13] = 1'b0;
  assign stage2[2][13] = stage1[4][13] + stage1[5][13];
  assign stage2[3][13] = {2'(stage1[3][12] + stage1[4][12] + stage1[5][12])}[1];

  assign stage2[0][14] = 1'b0;
  assign stage2[1][14] = 1'b0;
  assign stage2[2][14] = stage1[5][14];
  assign stage2[3][14] = {2'(stage1[4][13] + stage1[5][13])}[1];

  // stage 3
  assign stage3[0][0] = stage2[0][0];
  assign stage3[1][0] = 1'b0;
  assign stage3[2][0] = 1'b0;

  assign stage3[0][1] = stage2[0][1];
  assign stage3[1][1] = 1'b0;
  assign stage3[2][1] = 1'b0;

  assign stage3[0][2] = stage2[0][2];
  assign stage3[1][2] = 1'b0;
  assign stage3[2][2] = 1'b0;

  assign stage3[0][3] = stage2[0][3] + stage2[1][3];
  assign stage3[1][3] = 1'b0;
  assign stage3[2][3] = 1'b0;

  assign stage3[0][4] = stage2[0][4] + stage2[1][4];
  assign stage3[1][4] = {2'(stage2[0][3] + stage2[1][3])}[1]; // carry
  assign stage3[2][4] = 1'b0;

  assign stage3[0][5] = stage2[0][5] + stage2[1][5] + stage2[2][5];
  assign stage3[1][5] = {2'(stage2[0][4] + stage2[1][4])}[1]; // carry
  assign stage3[2][5] = 1'b0;

  assign stage3[0][6] = stage2[0][6] + stage2[1][6] + stage2[2][6];
  assign stage3[1][6] = {2'(stage2[0][5] + stage2[1][5] + stage2[2][5])}[1]; // carry
  assign stage3[2][6] = 1'b0;

  assign stage3[0][7] = stage2[0][7] + stage2[1][7] + stage2[2][7];
  assign stage3[1][7] = {2'(stage2[0][6] + stage2[1][6] + stage2[2][6])}[1]; // carry
  assign stage3[2][7] = stage2[3][7];

  assign stage3[0][8] = stage2[0][8] + stage2[1][8] + stage2[2][8];
  assign stage3[1][8] = {2'(stage2[0][7] + stage2[1][7] + stage2[2][7])}[1]; // carry
  assign stage3[2][8] = stage2[3][8];

  assign stage3[0][9] = stage2[0][9] + stage2[1][9] + stage2[2][9];
  assign stage3[1][9] = {2'(stage2[0][8] + stage2[1][8] + stage2[2][8])}[1]; // carry
  assign stage3[2][9] = stage2[3][9];

  assign stage3[0][10] = stage2[0][10] + stage2[1][10] + stage2[2][10];
  assign stage3[1][10] = {2'(stage2[0][9] + stage2[1][9] + stage2[2][9])}[1]; // carry
  assign stage3[2][10] = stage2[3][10];

  assign stage3[0][11] = stage2[1][11] + stage2[2][11];
  assign stage3[1][11] = {2'(stage2[0][10] + stage2[1][10] + stage2[2][10])}[1]; // carry
  assign stage3[2][11] = stage2[3][11];

  assign stage3[0][12] = stage2[1][12] + stage2[2][12];
  assign stage3[1][12] = {2'(stage2[1][11] + stage2[2][11])}[1]; // carry
  assign stage3[2][12] = stage2[3][12];

  assign stage3[0][13] = {2'(stage2[1][12] + stage2[2][12])}[1];
  assign stage3[1][13] = stage2[2][13];
  assign stage3[2][13] = stage2[3][13];

  assign stage3[0][14] = 1'b0;
  assign stage3[1][14] = stage2[2][14];
  assign stage3[2][14] = stage2[3][14];

  // stage 4
  assign stage4[0][0] = stage3[0][0];
  assign stage4[1][0] = 1'b0;

  assign stage4[0][1] = stage3[0][1];
  assign stage4[1][1] = 1'b0;

  assign stage4[0][2] = stage3[0][2];
  assign stage4[1][2] = 1'b0;

  assign stage4[0][3] = stage3[0][3];
  assign stage4[1][3] = 1'b0;

  assign stage4[0][4] = stage3[0][4] + stage3[1][4];
  assign stage4[1][4] = 1'b0;

  assign stage4[0][5] = stage3[0][5] + stage3[1][5];
  assign stage4[1][5] = {2'(stage3[0][4] + stage3[1][4])}[1]; // carry

  assign stage4[0][6] = stage3[0][6] + stage3[1][6];
  assign stage4[1][6] = {2'(stage3[0][5] + stage3[1][5])}[1]; // carry

  assign stage4[0][7] = stage3[0][7] + stage3[1][7] + stage3[2][7];
  assign stage4[1][7] = {2'(stage3[0][6] + stage3[1][6])}[1]; // carry

  assign stage4[0][8] = stage3[0][8] + stage3[1][8] + stage3[2][8];
  assign stage4[1][8] = {2'(stage3[0][7] + stage3[1][7] + stage3[2][7])}[1]; // carry

  assign stage4[0][9] = stage3[0][9] + stage3[1][9] + stage3[2][9];
  assign stage4[1][9] = {2'(stage3[0][8] + stage3[1][8] + stage3[2][8])}[1]; // carry

  assign stage4[0][10] = stage3[0][10] + stage3[1][10] + stage3[2][10];
  assign stage4[1][10] = {2'(stage3[0][9] + stage3[1][9] + stage3[2][9])}[1]; // carry

  assign stage4[0][11] = stage3[0][11] + stage3[1][11] + stage3[2][11];
  assign stage4[1][11] = {2'(stage3[0][10] + stage3[1][10] + stage3[2][10])}[1]; // carry

  assign stage4[0][12] = stage3[0][12] + stage3[1][12] + stage3[2][12];
  assign stage4[1][12] = {2'(stage3[0][11] + stage3[1][11] + stage3[2][11])}[1]; // carry

  assign stage4[0][13] = stage3[0][13] + stage3[1][13] + stage3[2][13];
  assign stage4[1][13] = {2'(stage3[0][12] + stage3[1][12] + stage3[2][12])}[1]; // carry

  assign stage4[0][14] = stage3[1][14] + stage3[2][14];
  assign stage4[1][14] = {2'(stage3[0][13] + stage3[1][13] + stage3[2][13])}[1]; // carry

  assign stage4[0][15] = {2'(stage3[1][14] + stage3[2][14])}[1]; // carry
  assign stage4[1][15] = 1'b0; 

  // final product
  assign product = stage4[0] + stage4[1];

  assign result = product;

endmodule

