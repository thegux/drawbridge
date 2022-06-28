/**
	 32bits up/down counter implemented as a module.
*/

module counter (clk, up, down, qd);

   input   clk, up, down;
   output reg qd;
	
   integer direction_up;
	integer direction_down;
	
   
   always @ (posedge clk) begin
      if (up) begin
         direction_up <= 1;
      end else begin 
			direction_up <= 0;
		end
      if(down) begin
         direction_down <= -1;
      end else begin
			direction_down <= 0;
		end
      qd <= qd + direction_up + direction_down;
   end
	
endmodule