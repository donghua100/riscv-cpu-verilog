`include"define.v"
module Mem(
	input				clk,
	input				mren,
	input				mwen,
	input [`XLEN-1:0]	addr,
	input [`XLEN-1:0]	wdata,
	output [`XLEN-1:0]	rdata
);
	reg [`XLEN-1:0] rdata_R;
	reg [`XLEN-0:0] mem [255:0];
	always @(posedge clk) begin
		if (mwen) mem[addr] <= wdata;
		else if (mren) rdata_R <= mem[addr];
	end
	assign rdata = rdata_R;
endmodule
