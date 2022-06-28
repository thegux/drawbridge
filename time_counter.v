module time_counter(clk, reset, time_c);
	input clk, reset;
	output reg time_c;
	
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			time_c <= 0;
		end else begin
			time_c <= time_c + 1;
		end
	end	
endmodule