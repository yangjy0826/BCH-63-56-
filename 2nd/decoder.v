`timescale 1ns / 1ns

module decoder( 
              clk,
              rst_n,
              S,
              isEn2,
              s1,
              s2,
              isEn3
              );
  input clk,rst_n;
  input [6:0] S; //this is the 7-bit syndrome
  input isEn2;
  output [5:0] s1;
  output [5:0] s2;
  output isEn3;
  reg [5:0] s1;
  reg [5:0] s2;
  reg isEn3;
  
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      s1<=6'b0; 
      isEn3<=1'b0;
		end
		else begin
		  if (isEn2==1'b1) begin
		    s1[5]<=S[5];
	      s1[4]<=S[4];
	      s1[3]<=S[3];
	      s1[2]<=S[2];
	     s1[1]<=S[6]^S[1];
	     s1[0]<=S[6]^S[0];
	     isEn3<=1'b1;
	      end
  end
  end
  
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      s2<=6'b0; 
//		s2=6'b0;  revised 12
      isEn3<=1'b0;
		end
		else begin
		  if (isEn2==1'b1) begin
		     s2[5]<=S[5];
	      s2[4]<=S[5]^S[2];
	     s2[3]<=S[4];
	      s2[2]<=S[4]^(S[6]^S[1]);
	      s2[1]<=S[3];
	     s2[0]<=S[3]^(S[6]^S[0]);
	     isEn3<=1'b1;
	      end
  end
  end
  
endmodule



