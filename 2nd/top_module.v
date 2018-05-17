
`timescale 1ns / 1ns

module top_module(
                  clk,
                  rst_n,
                  m,
                  ne,
                  l1,
                  l2,
                  l3,
                  Rn_1,
                  TorF
                  );
  input clk,rst_n;
  input [31:0] m;
  input [1:0] ne;  
  input [6:0] l1,l2,l3;
  
  wire [62:0] C,R;
  wire isEn1, isEn2,isEn3;
  wire Mistake_Done;
  wire [6:0] S;
  wire [5:0] s1,s2;
  wire [5:0] p1,p2;
  wire Lookup_Done_1,Lookup_Done_2;
  wire [2:0] S_eoro;
  
  
  output Rn_1; 
  output TorF;
  //**************************//
  encoder enc(
             .clk(clk), 
		         .rst_n(rst_n), 
		         .m(m), 
		         .C(C),
		         .isEn1(isEn1)
             );
  //**************************//
  mistake mis(
             .clk (clk ) ,
             .rst_n (rst_n ) ,
             .C (C ),
             .isEn1(isEn1),
             .ne (ne ) ,
             .l1 (l1 ) ,
             .l2 (l2 ) ,
             .l3 (l3 ) ,
             .R (R ),
             .Mistake_Done(Mistake_Done) 
             );
  //**************************//
    syndrome syn(
             .clk(clk), 
		         .rst_n(rst_n), 
		         .R(R), 
		         .Mistake_Done(Mistake_Done),
		         .S(S),
             .S_eoro(S_eoro),
		         .isEn2(isEn2)
             );
  //**************************//
    decoder dec( 
              .clk(clk),
              .rst_n(rst_n),
              .S(S),
              .isEn2(isEn2),
              .s1(s1),
              .s2(s2),
              .isEn3(isEn3)
              );
              
  //**************************//
    lookuptable lut(
							.Lookup_Done_1(Lookup_Done_1),
							.Lookup_Done_2(Lookup_Done_2),
              .clk(clk),
              .rst_n(rst_n),
              .isEn3(isEn3),
              .S(S),
              .s1(s1),
              .s2(s2),
              .p1(p1),
              .p2(p2)
                   );
 
   //**************************//                  
    decoder2 dec2(
             .clk(clk),
             .rst_n(rst_n),
             .R(R),
             .S(S),
             .S_eoro(S_eoro),
             .isEn3(isEn3),
				     .Lookup_Done_1(Lookup_Done_1),
				     .Lookup_Done_2(Lookup_Done_2),
             .p1(p1),
             .p2(p2),
             .Rn_1(Rn_1),
             .TorF(TorF)
//				 .TorF(Rn_1) revised 
             );
 endmodule


