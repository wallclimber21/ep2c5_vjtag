
module top(
	input	wire		clk,

	output	wire		led0,
	output	wire		led1,
	output	wire		led2,

	input	wire		switch_
);

	reg [31:0] counter;

	always @(posedge clk)
	begin
		if (!switch_) begin
			counter <= 0;
		end
		else begin
			counter <= counter + 1'b1;
		end
	end

	assign led2 = ~counter[24];

	wire		vjtag_m2s_tck;
	wire		vjtag_m2s_tdi;
	wire		vjtag_s2m_tdo;

	wire [1:0] vjtag_m2s_ir;

	wire		virtual_state_sdr;

	vjtag u_vjtag (
		.tck				( vjtag_m2s_tck ),
		.tdi				( vjtag_m2s_tdi ),
		.tdo				( vjtag_s2m_tdo ),

		.ir_out				(				),
		.ir_in				( vjtag_m2s_ir  ),

		.virtual_state_cdr	( ),
		.virtual_state_cir  ( ),
		.virtual_state_e1dr	( ),
		.virtual_state_e2dr	( ),
		.virtual_state_pdr	( ),
		.virtual_state_sdr	( virtual_state_sdr ),
		.virtual_state_udr	( ),
		.virtual_state_uir	( )
		);

	vjtag_client u_vjtag_client (
		.tck				( vjtag_m2s_tck ),
		.tdi				( vjtag_m2s_tdi ),
		.tdo				( vjtag_s2m_tdo ),

		.ir_in				( vjtag_m2s_ir  ),

		.virtual_state_sdr	( virtual_state_sdr ),

		.leds				( { led1, led0 } )
	);

endmodule
