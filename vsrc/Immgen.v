`include"define.v"
module Immgen(
	input [31:0]		inst,
	output [`XLEN-1:0]	immI,
	output [`XLEN-1:0]	immS,
	output [`XLEN-1:0]	immB,
	output [`XLEN-1:0]	immU,
	output [`XLEN-1:0]	immJ
);

	assign	immI = {{52{inst[31]}}, inst[31:20]};
	assign	immS = {{52{inst[31]}}, inst[31:25], inst[11:7]};
	assign	immB = {{51{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8],1'b0};
	assign	immU = {{32{inst[31]}}, inst[31:12], {12{1'b0}}};
	assign	immJ = {{43{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21],1'b0};
endmodule
