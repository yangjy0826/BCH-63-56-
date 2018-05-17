//`timescale 1ns / 1ps revised 4
`timescale 1ns / 1ns
module encoder(
             clk,
             rst_n,
             m,
             C,
             isEn1
             );
  input clk,rst_n;
  input [31:0] m;
  output [62:0] C;
  output isEn1;
  wire [23:0] a;
  wire [31:0] m;
  assign a=24'b010101010101010101010101;
  wire [56:0] in;
  assign in={a,m,1'b0}; //"in" is the 56-bit input data
  reg [6:0] x; 
  reg [6:0] xp;
  reg [6:0] i;
  reg isEnd1;
//  reg [2:0] Pos;
//  reg [2:0] count_num;
  
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      x=7'b0; 
      xp=7'b0;
//		Pos=3'd0;
		end
		else begin
		if(isEnd1==1'b0)begin
		  if (i>7'd0) begin
		  
//		    case (Pos)
//		    3'd0 : 
//			    begin 
				  x[0]=xp[6]^in[i];
//					Pos<=Pos+3'd1;
//			    end	
			  
//		    3'd1 :
//			    begin 
					x[1]=xp[0];
//					Pos<=Pos+3'd1;
//			    end			  
			  
//		    3'd2 :
//			    begin 
					x[2]=xp[1]^x[0];
//					Pos<=Pos+3'd1;
//			    end		
			  
//		    3'd3 :
//			    begin 
					x[3]=xp[2];
//					Pos<=Pos+3'd1;
//			    end		
			  
//		    3'd4 :
//			    begin 
					x[4]=xp[3];
//					Pos<=Pos+3'd1;
//			    end		
			  
//		    3'd5 :
//			    begin 
					x[5]=xp[4];
//					Pos<=Pos+3'd1;
//			    end		
			  
//		    3'd6 :
//			    begin  
			    x[6]=xp[5]^x[0];
//					Pos<=Pos+3'd1;
//			    end					
			    
//		    3'd7 :
//			    begin 
          xp=x;
//					Pos<=Pos+3'd1;
//			    end				  
//			  endcase
		  
//		      x[0]=xp[6]^in[i];
//        x[1]=xp[0];
//        x[2]=xp[1]^x[0];
//        x[3]=xp[2];
//        x[4]=xp[3];
//        x[5]=xp[4];
//        x[6]=xp[5]^x[0];
//        xp=x;
      end
		end
  end
  end
  
  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
    i = 7'd56;
    isEnd1 = 1'b0;
    end
    else begin
      if(i==7'd0)
        isEnd1 = 1'b1;
      else 
		//if(count_num==3'd7)
        i = i-1'd1;
    end
  end
  
//  always@(posedge clk or negedge rst_n)
//	  begin
//	  if(!rst_n)
//		  count_num=3'd0;
//		  else 
//			  begin
//			  if(count_num==3'd7)
////				  clk_8<=~clk_8;
//				  count_num=3'd0;
//			  else 
//				  count_num=count_num+1'd1;
//
//			  end
//			end
  
  assign C={in[56:1],x};
  assign isEn1=isEnd1;
endmodule