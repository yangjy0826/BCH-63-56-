//`timescale 1ns / 1ps  revised 6


//// change all "<=" to "="
//
//
///
`timescale 1ns / 1ns
module decoder2(
             clk,
             rst_n,
             R,
             S,
             S_eoro,
             isEn3,
				     Lookup_Done_1,
				     Lookup_Done_2,
             p1,
             p2,
             Rn_1,
             TorF
             );
  input clk,rst_n;
  input [62:0] R; // R is the output of module "mistake"
  input [6:0] S; //S is the output of module "syndrome"
  input [2:0] S_eoro;
  input [5:0] p1;  
  input [5:0] p2;
  reg [5:0] p;
  output Rn_1; 
  output TorF; //0--F,1--T
  reg [62:0] Rn; //Rn is the 63-bit code after corrected
    reg  Rn_1;
  reg TorF;
  input Lookup_Done_1,Lookup_Done_2;
  input isEn3;  
  
  reg [5:0] i;
  reg allEnd;
  reg decoder_done;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Rn=R;
      TorF=1; //When the calculation beforehand is not finished, we think the code is correct
      decoder_done=1'b0;
    end
    else begin
      if (isEn3==1'b1) begin
        if (S==7'd0) begin //no mistake occured
          Rn=R;
          TorF=1'b1;
          decoder_done=1'b1;
        end
        if (S>7'd0) begin // mistake occured
          if (S_eoro[0]==1'b0) begin // 2 mistakes occured
          //if (S[0]==1'b0) begin
            Rn=R;
            TorF=1'b0;
            decoder_done=1'b1;
          end
          if (S_eoro[0]==1'b1) begin
            //if (S[0]==1'b1) begin
            if ((Lookup_Done_1==1'b1)&&(Lookup_Done_2==1'b1)) begin // 1 mistake occured
            Rn=R;
            TorF=1'b0;
            Rn[p]=~Rn[p];                      // revised 
            decoder_done=1'b1;
            end
		      end
         end
        end
      end
    end
 
 always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p=1'b0;
    end
  else begin
    if (isEn3==1'b1) begin
      if ((Lookup_Done_1==1'b1)&&(Lookup_Done_2==1'b1)) begin 
         if(p1>p2) begin
          p=7'd63-p1+p2;
         end
         if (p1<=p2) begin
          p=p2-p1;
         end
       end
     end
   end
 end
 
   wire [63:0] Rn_t;
  assign Rn_t={Rn,1'b0}; //Rn_t is the temporary value of Rn, which add a 0 on its right
  
    always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i=6'd63;
      allEnd=1'b0;
    end
    else begin
      if (decoder_done==1'b1) begin
        if(allEnd==1'b0) begin
          if(i==1'd0) begin
            allEnd=1'b1;
          end
          else begin
            i=i-1'd1;
          end
        end
      end  
    end
  end
 
  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Rn_1=1'b0;
    end
    else begin
      if (decoder_done==1'b1) begin
        if(i>6'd0) begin
          Rn_1=Rn_t[i];
        end
      end  
    end
  end
 //assign Rn_1=Rn;
    
endmodule
