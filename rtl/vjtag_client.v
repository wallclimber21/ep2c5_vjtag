
module vjtag_client(
		input	wire		tck,
		input	wire		tdi,
		output	reg			tdo,
		input	wire [1:0]	ir_in,
		input	wire		virtual_state_sdr,
		input	wire		virtual_state_udr,
		output	reg [1:0]	leds
	);

	wire select_dr0		= (ir_in == 2'd0);
	wire select_dr1		= (ir_in == 2'd1);

	reg			dr0_bypass;
	reg [6:0]	dr1;

	always @(posedge tck) 
	begin
		dr0_bypass <= tdi;

		if (virtual_state_sdr) begin
			if (select_dr1) begin
				dr1 <= {tdi, dr1[6:1] };
			end
		end
	end

	always @*
	begin
		if (select_dr1) begin
			tdo <= dr1[0];
		end
		else begin
			tdo <= dr0_bypass;
		end
	end

	always @(virtual_state_udr) 
	begin
		leds = { dr1[6], dr1[0] };
	end

endmodule
