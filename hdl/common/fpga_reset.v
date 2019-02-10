// Generate a clean clock-synchronised reset, removed after N cycles

// Useful if your code has a standard sync/async reset,
// and you want to run on an FPGA with no external reset button (but
// with register initialisation via config)

module fpga_reset #(
	parameter N_CYC = 5
) (
	input wire clk,       // Must be same clocked used to drive logic (use one of this module for each clock in your design)
	input wire force_rst, // Can use to re-reset your design (or hold in reset) based on some internal state e.g. PLL not locked
	                      // (tie to 0 if not used

	output wire rst_n     // system reset
);

reg [N_CYC-1:0] rst_shift = {N_CYC{1'b0}}; // Default register initialistion. Ok for most FPGAs but not portable

always @ (posedge clk) begin
	if (force_rst)
		rst_shift <= {N_CYC{1'b0}};
	else
		rst_shift = (rst_shift << 1) | 1'b1;
end

assign rst_n = rst_shift[N_CYC-1];

endmodule