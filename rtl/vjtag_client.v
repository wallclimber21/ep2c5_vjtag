
module vjtag_client(
		input	wire		tck,
		input	wire		tdi,
		output	wire		tdo,
		input	wire [1:0]	ir_in,
		input	wire		virtual_state_sdr,
		input	wire		virtual_state_udr,
		output	wire [1:0]	leds
	);

	assign tdo = tdi;

	assign leds	= { 1'b1, 1'b0 };

endmodule
