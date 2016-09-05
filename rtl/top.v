
module top(
	input	wire		clk,

	output	wire		led0,
	output	wire		led1,
	output	wire		led2
);

	reg [31:0] counter;

	always @(posedge clk)
	begin
		counter <= counter + 1'b1;
	end

	assign led0 = ~counter[26];
	assign led1 = ~counter[25];
	assign led2 = ~counter[24];

endmodule
