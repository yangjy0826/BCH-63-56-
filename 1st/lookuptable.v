`timescale 1ns / 1ps

module lookuptable(
							     Lookup_Done,
                   clk,
                   rst_n,
                   isEn2,
                   S,
                   w,
                   ep
                   );
  input clk,rst_n,isEn2;
  input [6:0] S;
  input [2:0] w;
  output [62:0] ep;
  reg [62:0] ep;
  output Lookup_Done;
  reg rLookup_Done;
  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
    ep<=63'b0;
    rLookup_Done<=1'b0;
    end
    else begin
      if ((isEn2==1'b1)&&(w>3'd1))  begin
        case(S)
        7'b1100010:ep<=63'b100000000000000000000000000000000000000000000000000000000000000;
        7'b0110001:ep<=63'b010000000000000000000000000000000000000000000000000000000000000;
        7'b1111010:ep<=63'b001000000000000000000000000000000000000000000000000000000000000;
        7'b0111101:ep<=63'b000100000000000000000000000000000000000000000000000000000000000;
        7'b1111100:ep<=63'b000010000000000000000000000000000000000000000000000000000000000;
        7'b0111110:ep<=63'b000001000000000000000000000000000000000000000000000000000000000;
        7'b0011111:ep<=63'b000000100000000000000000000000000000000000000000000000000000000;
        7'b1101101:ep<=63'b000000010000000000000000000000000000000000000000000000000000000;
        7'b1010100:ep<=63'b000000001000000000000000000000000000000000000000000000000000000;
        7'b0101010:ep<=63'b000000000100000000000000000000000000000000000000000000000000000;
        7'b0010101:ep<=63'b000000000010000000000000000000000000000000000000000000000000000;
        7'b1101000:ep<=63'b000000000001000000000000000000000000000000000000000000000000000;
        7'b0110100:ep<=63'b000000000000100000000000000000000000000000000000000000000000000;
        7'b0011010:ep<=63'b000000000000010000000000000000000000000000000000000000000000000;
        7'b0001101:ep<=63'b000000000000001000000000000000000000000000000000000000000000000;
        7'b1100100:ep<=63'b000000000000000100000000000000000000000000000000000000000000000;
        7'b0110010:ep<=63'b000000000000000010000000000000000000000000000000000000000000000;
        7'b0011001:ep<=63'b000000000000000001000000000000000000000000000000000000000000000;
        7'b1101110:ep<=63'b000000000000000000100000000000000000000000000000000000000000000;
        7'b0110111:ep<=63'b000000000000000000010000000000000000000000000000000000000000000;
        7'b1111001:ep<=63'b000000000000000000001000000000000000000000000000000000000000000;
        7'b1011110:ep<=63'b000000000000000000000100000000000000000000000000000000000000000;
        7'b0101111:ep<=63'b000000000000000000000010000000000000000000000000000000000000000;
        7'b1110101:ep<=63'b000000000000000000000001000000000000000000000000000000000000000;
        7'b1011000:ep<=63'b000000000000000000000000100000000000000000000000000000000000000;
        7'b0101100:ep<=63'b000000000000000000000000010000000000000000000000000000000000000;
        7'b0010110:ep<=63'b000000000000000000000000001000000000000000000000000000000000000;
        7'b0001011:ep<=63'b000000000000000000000000000100000000000000000000000000000000000;
        7'b1100111:ep<=63'b000000000000000000000000000010000000000000000000000000000000000;
        7'b1010001:ep<=63'b000000000000000000000000000001000000000000000000000000000000000;
        7'b1001010:ep<=63'b000000000000000000000000000000100000000000000000000000000000000;
        7'b0100101:ep<=63'b000000000000000000000000000000010000000000000000000000000000000;
        7'b1110000:ep<=63'b000000000000000000000000000000001000000000000000000000000000000;
        7'b0111000:ep<=63'b000000000000000000000000000000000100000000000000000000000000000;
        7'b0011100:ep<=63'b000000000000000000000000000000000010000000000000000000000000000;
        7'b0001110:ep<=63'b000000000000000000000000000000000001000000000000000000000000000;
        7'b0000111:ep<=63'b000000000000000000000000000000000000100000000000000000000000000;
        7'b1100001:ep<=63'b000000000000000000000000000000000000010000000000000000000000000;
        7'b1010010:ep<=63'b000000000000000000000000000000000000001000000000000000000000000;
        7'b0101001:ep<=63'b000000000000000000000000000000000000000100000000000000000000000;
        7'b1110110:ep<=63'b000000000000000000000000000000000000000010000000000000000000000;
        7'b0111011:ep<=63'b000000000000000000000000000000000000000001000000000000000000000;
        7'b1111111:ep<=63'b000000000000000000000000000000000000000000100000000000000000000;
        7'b1011101:ep<=63'b000000000000000000000000000000000000000000010000000000000000000;
        7'b1001100:ep<=63'b000000000000000000000000000000000000000000001000000000000000000;
        7'b0100110:ep<=63'b000000000000000000000000000000000000000000000100000000000000000;
        7'b0010011:ep<=63'b000000000000000000000000000000000000000000000010000000000000000;
        7'b1101011:ep<=63'b000000000000000000000000000000000000000000000001000000000000000;
        7'b1010111:ep<=63'b000000000000000000000000000000000000000000000000100000000000000;
        7'b1001001:ep<=63'b000000000000000000000000000000000000000000000000010000000000000;
        7'b1000110:ep<=63'b000000000000000000000000000000000000000000000000001000000000000;
        7'b0100011:ep<=63'b000000000000000000000000000000000000000000000000000100000000000;
        7'b1110011:ep<=63'b000000000000000000000000000000000000000000000000000010000000000;
        7'b1011011:ep<=63'b000000000000000000000000000000000000000000000000000001000000000;
        7'b1001111:ep<=63'b000000000000000000000000000000000000000000000000000000100000000;
        7'b1000101:ep<=63'b000000000000000000000000000000000000000000000000000000010000000;
        default: ep<=63'b0;
        endcase  
		  rLookup_Done<=1'b1;
      end  
    end
  end
  assign Lookup_Done=rLookup_Done;
endmodule