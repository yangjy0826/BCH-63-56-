`timescale 1ns / 1ps

module mistake(
             clk,
             rst_n,
             C,
             isEn1,
             //ne,
             //l1,
             //l2,
             //l3,
             R,
				 Mistake_Done
             );
  input clk,rst_n;
  input [62:0] C; //input C is the output value C of module "encoder"
  input isEn1;
  wire [1:0] ne;
  wire [6:0] l1,l2,l3;
  assign ne=2'd3;
  assign l1=7'd0;
  assign l2=7'd1;
  assign l3=7'd2;
  //input [1:0] ne;  // ne is the number of errors, which can be 0, 1, 2 or 3
  //input [6:0] l1,l2,l3; //the location of the 1st,2nd,3rd mistake,0~62
  output [62:0] R;  //the 63-bit code with error(s)
  output Mistake_Done;
  reg [62:0] C_r;
//  reg [62:0] R;
 reg Pos;
  reg rMistake_Done;
  
  always@(posedge clk or negedge rst_n)
  begin
		if(!rst_n)
		begin
			C_r<=C;
			rMistake_Done<=1'b0;
			Pos<=1'b0;
		end
		else
		begin
			if(!Mistake_Done)
			begin
				if(isEn1)
				begin
					if(!Pos)
					begin
						Pos<=1'b1;
						C_r<=C;
					end
					else 
					begin
						case(ne)
							2'd1: begin C_r[l1]<=~C_r[l1]; rMistake_Done<=1'b1; end
							2'd2: begin C_r[l1]<=~C_r[l1]; C_r[l2]<=~C_r[l2]; rMistake_Done<=1'b1; end
							2'd3: begin C_r[l1]<=~C_r[l1]; C_r[l2]<=~C_r[l2]; C_r[l3]<=~C_r[l3]; rMistake_Done<=1'b1; end 
							2'd0: begin C_r<=C_r; rMistake_Done<=1'b1; end
						endcase	
					end
				end
			end
		end
  end
  assign R=C_r;
  assign Mistake_Done=rMistake_Done;
endmodule