`timescale 1 ns / 1 ps

module tb;

// Instantiate the device under test (DUT)
reg clk_osc;
wire [4:0] led;

fpga dut (
	.clk_osc (clk_osc),
	.led (led)
);

// Provide test stimulus

localparam CLK_PERIOD = 1000.0 / 12.0; // for 12 MHz
initial clk_osc = 1'b0;
always #(CLK_PERIOD * 0.5) clk_osc = !clk_osc;

initial begin
	#1_000_000_000;
	$finish;
end

endmodule