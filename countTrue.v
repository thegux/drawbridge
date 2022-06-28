module countTrue (clk, reset, up, down, hasItem);

   input   clk, up, down, reset;
   output hasItem;
	reg [31:0] count;
	reg hasItem;


   always @ (posedge clk) begin
		if(reset) begin
			count <= 0;
		end else begin
			if(up) begin
				count = count + 1;
			end
			if(down && count > 0) begin
				count = count - 1;
			end
		end	
   end
	
	always @(count) begin
		hasItem = (count > 0) ? 1 : 0;
	end

	
endmodule