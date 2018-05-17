module top_module_tb  ; 
 
  wire   Rn_1   ; 
  reg  [6:0]  l1   ; 
  reg  [31:0]  m   ; 
  wire   TorF   ; 
  reg  [6:0]  l2   ; 
  reg    rst_n   ; 
  reg    clk   ; 
  reg  [6:0]  l3   ; 
  reg  [1:0]  ne   ; 
  top_module  
   DUT  ( 
       .Rn_1 (Rn_1 ) ,
      .l1 (l1 ) ,
      .m (m ) ,
      .TorF (TorF ) ,
      .l2 (l2 ) ,
      .rst_n (rst_n ) ,
      .clk (clk ) ,
      .l3 (l3 ) ,
      .ne (ne ) ); 

  always #10 clk=~clk;
  
	initial begin
		// Initialize Inputs
		   m=32'b11011101110111011101110111011101;
		   
		   ne=2'd3; //ne,l1,l2,l3 can be changed, or generated randomly
       l1=7'd0; //l1,l2,l3: 0~63,0 is on the left and 63 is on the right
       l2=7'd1;
       l3=7'd2;
 
       clk=1'b0;
       rst_n=1'b1;
       #100
       rst_n=1'b0;
       #500
       rst_n=1'b1;
       #10000000    
       $stop;

		// Wait 100 ns for global reset to finish
		#100;
end

endmodule


