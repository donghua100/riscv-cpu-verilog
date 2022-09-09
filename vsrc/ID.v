`include"define.v"
module ID(
	input [31:0]		inst,
	output [4:0]		rs1,
	output [4:0]		rs2,
	output [4:0]		rd
);
	assign	rd		= inst[11:7];
	assign	rs1		= inst[19:15];
	assign	rs2		= inst[24:20];
endmodule


