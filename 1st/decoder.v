`timescale 1ns / 1ps

module decoder(
				Lookup_Done,
             clk,
             rst_n,
             R,
             S,
             w,
             isEn2,
             ep,
             Rn_1,
             TorF
             );
  input clk,rst_n;
  input [62:0] R; // R is the output of module "mistake"
  input [6:0] S; //S is the output of module "syndrome"
  input [2:0] w; //S is the output of module "syndrome"
  input [62:0] ep;  //error pattern ep is the output of look-up table
  input isEn2;
  output Rn_1; 
  output TorF; //0--F,1--T
  reg [62:0] Rn; //Rn is the 63-bit code after corrected
  reg Rn_1;
  reg TorF;
  reg allEnd;
  input Lookup_Done;
  reg decoder_done;
  reg [5:0] i;
  
  wire [63:0] Rn_t;
  assign Rn_t={Rn,1'b0}; //Rn_t is the temporary value of Rn, which add a 0 on its right
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Rn<=R;
      TorF<=1; //When the calculation beforhand is not finished, we think the code is correct
      decoder_done<=1'b0;
    end
    else begin
      if (isEn2==1'b1) begin
        if (w==3'd0) begin
          Rn<=R;
          TorF<=1'b1;
          decoder_done<=1'b1;
        end
        if (w==3'd1) begin
          Rn<=R^{56'b0,S};
          TorF<=1'b0;
          decoder_done<=1'b1;
        end
        if (w>3'd1) begin
          if (Lookup_Done==1'b1) begin
            Rn<=R^ep;
            TorF<=1'b0;
            decoder_done<=1'b1; 
		      end
        end
      end
    end
  end
 
  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i<=6'd63;
      allEnd<=1'b0;
    end
    else begin
      if (decoder_done==1'b1) begin
        if(allEnd==1'b0) begin
          if(i==1'd0) begin
            allEnd<=1'b1;
          end
          else begin
            i<=i-1'd1;
          end
        end
      end  
    end
  end
 
  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Rn_1<=1'b0;
    end
    else begin
      if (decoder_done==1'b1) begin
        if(i>6'd0) begin
          Rn_1<=Rn_t[i];
        end
      end  
    end
  end
    
endmodule