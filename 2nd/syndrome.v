//`timescale 1ns / 1ps revised 2
`timescale 1ns / 1ns
module syndrome( 
					Mistake_Done,
              clk,
              rst_n,
              R,
              S,
              S_eoro,
//              isEn2, revised 7
				   isEn2
              );
	input Mistake_Done;
  input clk,rst_n;
  input [62:0] R; //"R" is the output value of module "mistake"
  output [6:0] S; //this is the 7-bit syndrome
  output isEn2;
  output [2:0] S_eoro;
  reg [6:0] y; 
  reg [6:0] yp;
 
//  reg [6:0] i;
//  reg [8:0] i;//0-511?????
  reg [5:0] j;//1-63???j???
//    reg [6:0] y=7'b0; 
//  reg [6:0] yp=7'b0;
//  reg [6:0] i=7'd63;
  wire [63:0] R_t;
  assign R_t={R,1'b0}; //R_t is the temporary value of R, which add a 0 on its right
  reg isEnd2;
  
//  reg [2:0]Pos;
//	reg [1:0]Pos;
  
  //********Caculate syndrome S**********//
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      y=7'b0; 
      yp=7'b0;
//		Pos=3'd0;
//		Pos<=2'd0;
//		isEnd2<=1'b0;
		end
		else begin
		if(isEnd2==1'b0)begin
		if(Mistake_Done)begin
		  if (j>6'd0) begin
//					case (Pos)
//		  3'd0 : 
//			  begin 
//				y <= {y[6:1],yp[6]^R_t[j]};
					y[0]=yp[6]^R_t[j];
//					Pos<=Pos+3'd1;
//			  end	
//			  
//		  3'd1 :
//			  begin 
//			  y <= {y[6:2],yp[0],y[0]};
					 y[1]=yp[0];
//					Pos<=Pos+3'd1;
//			  end			  
//		  3'd2 :
//			  begin 
//			  y <= {y[6:3],yp[1]^y[6],y[1:0]};
					y[2]=yp[1]^y[6];
//					Pos<=Pos+3'd1;
//			  end		
//		  3'd3 :
//			  begin 
//			  y <= {y[6:4],yp[2],y[2:0]};
					 y[3]=yp[2];
//					Pos<=Pos+3'd1;
//			  end		
//		  3'd4 :
//			  begin 
//			  y <= {y[6:5],yp[3],y[3:0]};
					y[4]=yp[3];
//					Pos<=Pos+3'd1;
//			  end		
//		  3'd5 :
//			  begin 
//			  y <= {y[6],yp[4],y[4:0]};
					 y[5]=yp[4];
//					Pos<=Pos+3'd1;
//			  end		
//		  3'd6 :
//			  begin 
//			  y <= {yp[5]^y[6],y[5:0]};
					 y[6]=yp[5]^y[6];
//					Pos<=Pos+3'd1;
//			  end					  
//		  3'd7 :
//			  begin 
					 yp=y;
//					Pos<=Pos+3'd1;
//			  end				  
//			  endcase
      end
		end
  end
  end
	end
//	reg [2:0] count_num;
//	
//  always@(posedge clk or negedge rst_n)
//	  begin
//	  if(!rst_n)
//		  count_num<=3'd0;
//		  else if(Mistake_Done==1'b1)
//			  begin
//			  if(count_num==3'd7)
////				  clk_8<=~clk_8;
//				  count_num<=3'd0;
//			  else 
//				  count_num<=count_num+1'd1;
//
//			  end
//			end

  always@(posedge clk or negedge rst_n)
	  begin
	  if(!rst_n)
		  begin
		  j=6'd63;
		  isEnd2=1'b0;
		  end
	  else if(Mistake_Done==1'b1)
		  begin
		  if(j==6'd0)
			isEnd2=1'b1;
		  else 
//		  if(count_num==3'd7)
		  j=j-1'd1;
		  end
		end  
  
  
  assign S=y;
  assign isEn2=isEnd2;
  assign S_eoro=S[0]+S[1]+S[2]+S[3]+S[4]+S[5]+S[6];
  
endmodule

