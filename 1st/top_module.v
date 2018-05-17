`timescale 1ns / 1ps

module top_module(
                  clk,
                  rst_n,
                  //m,
                  //ne,
                  //l1,
                  //l2,
                  //l3,
                  Rn_1,
                  TorF
                  );
  input clk,rst_n;
  //input [31:0] m;
  //input [1:0] ne;  
  //input [6:0] l1,l2,l3;
  //output [62:0] Rn;
  output Rn_1;
  output TorF;
  
  wire [62:0] C,R;
  wire isEn1,isEn2;
  wire [6:0] S;
  wire [2:0] w;
  wire [62:0] ep; 
 wire Mistake_Done;
 wire Lookup_Done;
  //**************************//
  encoder enc(
             .clk(clk), 
		         .rst_n(rst_n), 
		         //.m(m), 
		         .C(C),
		         .isEn1(isEn1)
             );
  //**************************//
  mistake mis(
             .clk (clk ) ,
             .rst_n (rst_n ) ,
             .C (C ),
             .isEn1(isEn1),
             //.ne (ne ) ,
             //.l1 (l1 ) ,
             //.l2 (l2 ) ,
             //.l3 (l3 ) ,
             .R (R ),
				 .Mistake_Done(Mistake_Done)
             );
  //**************************//
    syndrome syn(
	 .Mistake_Done(Mistake_Done),
             .clk(clk), 
		         .rst_n(rst_n), 
		         .R(R), 
		         .S(S),
		         .w(w),
		         .isEn2(isEn2)
             );
 //**************************//
     decoder dec(
	   .Lookup_Done(Lookup_Done),
             .clk(clk),
             .rst_n(rst_n),
             .R(R),
             .S(S),
             .w(w),
             .isEn2(isEn2),
             .ep(ep),
             .Rn_1(Rn_1),
             .TorF(TorF)
             );
//**************************//
     lookuptable lut(
	  .Lookup_Done(Lookup_Done),
                   .clk(clk),
                   .rst_n(rst_n),
                   .isEn2(isEn2),
                   .S(S),
                   .w(w),
                   .ep(ep)
                   );
                   
 endmodule