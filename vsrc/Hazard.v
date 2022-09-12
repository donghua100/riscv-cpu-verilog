`include"define.v"
module Hazard(
	input	[4:0]	rs1,
	input	[4:0]	rs2,
	input	[4:0]	id_ex_rd,
	input			id_ex_Mren,
	output			stall
);
	assign stall = (id_ex_Mren && (rs1 == id_ex_rd || rs2 == id_ex_rd)?1'b1:1'b0);
endmodule
