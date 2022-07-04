/**
	DRAWBRIDGE TESTBENCH
	
*/

module drawbridge_tb;
	
	reg i_clk, i_carIn, i_carOut, i_reset, i_boatClose, i_boatHere;
	
	wire has_car_c, o_carBarrier, o_alert, o_bridge_s;
	
	wire [2:0] machine_state;

	
	drawbridge UUT (.has_car_c(has_car_c), 
						 .i_clk(i_clk), 
						 .i_reset(i_reset), 
						 .i_carIn(i_carIn), 
						 .i_carOut(i_carOut), 
						 .i_boatClose(i_boatClose), 
						 .i_boatHere(i_boatHere),
						 .o_carBarrier(o_carBarrier),
						 .o_alert(o_alert),
						 .o_bridge_s(o_bridge_s),
						 .machine_state(machine_state));
  
  	always @(has_car_c) begin 
		$display("Tem carros na ponte? %h", has_car_c);
	end
	
	always @(i_boatClose) begin 
		$display("Tem navios perto? %h", i_boatClose);
	end
	
	always @(i_boatHere) begin 
		$display("Tem navios passando na ponte? %h", i_boatHere);
	end

	
	always @(machine_state) begin 
		$display("Estado Geral: %3b, Estado da Ponte: %d, Alerta: %d, Cancela: %d", machine_state, o_bridge_s, o_alert, o_carBarrier);
	end

  
   always begin
        #20;  //every 20 ns switch...so period of clock is 40 ns...100 MHz clock
        i_clk = ~i_clk;
   end
  
	initial begin
		i_clk <= 0;
		i_reset <= 1;
		i_carIn <= 0;
		i_carOut <= 0;
		i_boatHere <= 0;
		i_boatClose <= 0;
		

		#20 i_reset <= 0;
		
		/**
			Testing only cars
			States to test: Cars
		*/
		
	   // 80ns in 2 cars
		i_carIn <= 1; #80
		
		i_carIn <= 0;  #40 
		
		// 2 cars leaving
		i_carOut <= 1; #80
		i_carOut <= 0; #20
		
		
		/**
			Testing cars with boat close
			States to test: Boat_c_Cars and Boat_c
		*/
		// 2 cars in 
		i_carIn <= 1; #80
		
		i_carIn <= 0;  #40 
		
		
		// making boat go close
		i_boatClose <= 1; #20;
		
		// 2 cars leaving
		i_carOut <= 1; #80
		i_carOut <= 0; #30
		
		// 1 car in
		i_carIn <= 1; #30
		i_carIn <= 0;
		i_carOut <= 1; #20
		i_carOut <= 0; #20

		
		
		
		
		
		#400 $finish;
	end
	
endmodule