module blinky #(
	parameter CLK_HZ = 12_000_000,
	parameter BLINK_HZ = 1
) (
	input wire clk,
	input wire rst_n,
	output reg blink
);

parameter COUNT = CLK_HZ / BLINK_HZ / 2;
parameter W_CTR = $clog2(COUNT);

reg [W_CTR-1:0] ctr;


always @ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		ctr <= {W_CTR{1'b0}};
		blink <= 1'b0;
	end else begin
		if (ctr != 0) begin
			ctr <= ctr - 1'b1;
		end else begin
			ctr <= COUNT - 1;
			blink <= !blink;
		end
	end
end

endmodule