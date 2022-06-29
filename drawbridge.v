/**
	DRAWBRIDGE PROJECT GUIDELINES
	
	This module is responsible for instantianting and intermediating the logic for a drawbridge.
	
	It is implemented using a behavioral coding structure of VHDL.
	
	--------------------------------
	 Variable nomenclature:
		
		i_ = input variable;
		o_ = output variable;
		
		_s = state variable;
		_c = counter variable;
	--------------------------------
	
	--------------------------------
	  State nomenclature:
	  
	  Cars = has cars
	  Boat_c = boat close
	  Boat_h = boat here
	  Boat_ch = boats close and boat here
	--------------------------------
*/

module drawbridge(has_car_c, i_clk, i_reset, i_carIn, i_carOut, i_boatClose, i_boatHere, o_carBarrier, o_alert, o_bridge_s);

	input  i_carIn, i_carOut, i_boat, i_clk, i_reset, i_boatClose, i_boatHere;
	output has_car_c, o_carBarrier, o_alert, o_bridge_s;
	
	reg [2:0] EstadoAtual, EstadoFuturo;
		
	//used to count and verify if there are cars on the bridge
	countTrue ct (.clk(i_clk), .reset(i_reset), .up(i_carIn), .down(i_carOut), .hasItem(has_car_c));
	
	// {boat passing by, boat close, has cars}
	
	parameter Empty_Bridge = 3'b000,
				 Cars = 3'b001,
				 Boat_c = 3'b010,
				 Boat_c_Cars = 3'b011,
				 Boat_h = 3'100,
				 Boat_ch = 3'b110,
				 Alert = 3'b111,
				 off = 0,
				 on = 1;
				 
	
	// atualização do estado e reset
	always @ (posedge i_clk) begin
		if (!i_reset) 
			case({i_boatHere, i_boatClose, has_car_c})//os FSM s�o de acordo com o desenho de gab
				3'b000: EstadoAtual <= Empty_Bridge;//fsm: vazio
				3'b001: EstadoAtual <= Cars;//fsm: carro
				3'b010: EstadoAtual <= Boat_c;//fsm: navio perto sem carro
				3'b011: EstadoAtual <= Boat_c_Cars;//fsm: navio perto + carro
				3'b100: EstadoAtual <= Boat_h;// fsm: navio passando
				3'b110: EstadoAtual <= Boat_ch;//fsm: navio passando + carro perto
				3'b111: EstadoAtual <= Alert;//fsm: alerta
				default: EstadoAtual <= Empty_Bridge;
			endcase
		else EstadoAtual <= EstadoFuturo;
	end

	always @(i_boatHere or i_boatClose or has_car_c or EstadoAtual) begin
		//default
		EstadoFuturo = Empty_Bridge;
		o_carBarrier = off;
		o_alert = off;
		o_bridge_s = off;
		
		case (EstadoAtual)
			Empty_Bridge: case({i_boatHere, i_boatClose, has_car_c})
						3'b000: begin
									EstadoFuturo =  Empty_Bridge;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b001: begin
									EstadoFuturo =  Cars;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b010: begin
									EstadoFuturo =  Boat_c;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = off;
								 end
						3'b011: begin
									EstadoFuturo =  Boat_c_Cars;
									o_carBarrier = off;
									o_alert = on;
									o_bridge_s = off;
								 end
						3'b100: begin
									EstadoFuturo =  Alert;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b101: begin
									EstadoFuturo =  Cars;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b111: begin
									EstadoFuturo =  Cars;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end		 		 
					 endcase
			
		endcase
			Boat_c_Cars: case({i_boatHere, i_boatClose, has_car_c})
						3'b000: begin
									EstadoFuturo =  Empty_Bridge; 
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b001: begin
									EstadoFuturo =  Empty_Bridge;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b010: begin 
									EstadoFuturo =  Boat_c;
									o_carBarrier = off;
									o_alert = on;
									o_bridge_s = off;
								 end
						3'b011: begin
									EstadoFuturo =  Boat_h;
									o_carBarrier = on;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b100: begin
									EstadoFuturo =  Boat_h;
									o_carBarrier = off;
									o_alert = on;
									o_bridge_s = on;
								 end
						3'b101: begin
									EstadoFuturo =  Boat_ch;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = on;
								 end
						3'b111: begin
									EstadoFuturo =  Boat_ch;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = on;
								 end		 		 
					 endcase

		endcase
			Boat_h: case({i_boatHere, i_boatClose, has_car_c})
						3'b000: begin
									EstadoFuturo =  Empty_Bridge;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b001: begin
									EstadoFuturo =  Empty_Bridge;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b010: begin
									EstadoFuturo =  Boat_c;
									o_carBarrier = on;
									o_alert = off;
									o_bridge_s = on;
								 end
						3'b011: begin
									EstadoFuturo =  Boat_c_Cars;
									o_carBarrier = on;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b100: begin
									EstadoFuturo =  Alert;
									o_carBarrier = on;
									o_alert = off;
									o_bridge_s = on;
								 end
						3'b101: begin
									EstadoFuturo =  Boat_ch;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = on;
								 end
						3'b111: begin
									EstadoFuturo =  Alert;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = on;
								 end		 		 
					 endcase
			
		endcase
			Boat_ch: case({i_boatHere, i_boatClose, has_car_c})
						3'b000: begin
									EstadoFuturo =  Empty_Bridge;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b001: begin
									EstadoFuturo =  Empty_Bridge;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b010: begin
									EstadoFuturo =  Boat_c;
									o_carBarrier = off;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b011: begin
									EstadoFuturo =  Boat_c_Cars;
									o_carBarrier = on;
									o_alert = off;
									o_bridge_s = off;
								 end
						3'b100: begin
									EstadoFuturo =  Boat_h;
									o_carBarrier = on;
									o_alert = off;
									o_bridge_s = on;
								 end
						3'b101: begin
									EstadoFuturo =  Alert;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = on;
								 end
						3'b111: begin
									EstadoFuturo =  Alert;
									o_carBarrier = on;
									o_alert = on;
									o_bridge_s = on;
								 end		 		 
					 endcase
			
		endcase
	end
	
	
endmodule