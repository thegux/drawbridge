/**
	DRAWBRIDGE TESTBENCH
	
*/

module drawbridge_tb;
	
	reg i_clk, i_carIn, i_carOut, i_reset, i_boatClose, i_boatHere;
	
	wire has_car_c, o_carBarrier, o_alert;
	
	wire [2:0] o_bridge_s;

	
	drawbridge UUT (.has_car_c(has_car_c), 
						 .i_clk(i_clk), 
						 .i_reset(i_reset), 
						 .i_carIn(i_carIn), 
						 .i_carOut(i_carOut), 
						 .i_boatClose(i_boatClose), 
						 .i_boatHere(i_boatHere),
						 .o_carBarrier(o_carBarrier),
						 .o_alert(o_alert),
						 .o_bridge_s(o_bridge_s));
  
  	always @(has_car_c) begin 
		$display("Tem carros na ponte? %h", has_car_c);
	end

  
   always begin
        #20;  //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
        i_clk = ~i_clk;
   end
  
	initial begin
		i_clk <= 0;
		i_reset <= 1;
		i_carIn <= 0;
		i_carOut <= 0;
		

		#20 i_reset <= 0;
		
	   // 80ns in 2 cars
		i_carIn <= 1; #80
		
		i_carIn <= 0;  #20 
		i_carOut <= 1;
		
		#160 $finish;
	end
	
endmodule