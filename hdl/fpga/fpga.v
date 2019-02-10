// Top-level wrapper for FPGA

module fpga (
	input wire clk_osc,
	output wire [4:0] led
);

// Generate system reset signal

wire rst_n;

fpga_reset rstgen (
	.clk       (clk_osc),
	.force_rst (1'b0),
	.rst_n     (rst_n)
);

// Instantiate blinky logic

blinky #(
	.CLK_HZ(12_000_000),
	.BLINK_HZ(1)
) blinky_u (
	.clk   (clk_osc),
	.rst_n (rst_n),
	.blink (led[4])
);

// Turn off the other LEDs

assign led[3:0] = 4'h0;

endmodule
