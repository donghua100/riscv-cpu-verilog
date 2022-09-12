`include"define.v"
module Forward(
	input	[4:0]	id_ex_rs1,
	input	[4:0]	id_ex_rs2,
	input			ex_mem_Rwen,
	input	[4:0]	ex_mem_rd,
	input			mem_wb_Rwen,
	input	[4:0]	mem_wb_rd,
	output	[1:0]	FwdA_sel,
	output	[1:0]	FwdB_sel
);
	reg [1:0] FwdA_sel_R;
	reg [1:0] FwdB_sel_R;
	always@(*) begin
		FwdA_sel_R = `F_XXX;
		FwdB_sel_R = `F_XXX;
		if (ex_mem_Rwen==`RegWen && 
			ex_mem_rd != 0 && 
			(id_ex_rs1 == ex_mem_rd)) FwdA_sel_R = `F_alu;
		if (ex_mem_Rwen==`RegWen && 
			ex_mem_rd != 0 && 
			(id_ex_rs2 == ex_mem_rd)) FwdB_sel_R = `F_alu;

		if (mem_wb_Rwen==`RegWen &&
			mem_wb_rd != 0 &&
			!(ex_mem_Rwen == `RegWen &&
			ex_mem_rd != 0 &&
			id_ex_rs1 == ex_mem_rd) &&
			(id_ex_rs1 == mem_wb_rd)) FwdA_sel_R = `F_mem;
		if (mem_wb_Rwen==`RegWen &&
			mem_wb_rd != 0 &&
			!(ex_mem_Rwen == `RegWen &&
			ex_mem_rd != 0 &&
			id_ex_rs2 == ex_mem_rd) &&
			(id_ex_rs2 == mem_wb_rd)) FwdB_sel_R = `F_mem;
	end
	assign FwdA_sel = FwdA_sel_R;
	assign FwdB_sel = FwdB_sel_R;
endmodule
