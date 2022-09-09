`include"define.v"
module Control(
	input [31:0]		inst,
	output [2:0]		Imm_sel,
	output				A_sel,
	output				B_sel,
	output [3:0]		Alu_op,
	output				MemRen,
	output				MemWen,
	output				RegWen,
	output [1:0]		Wb_sel,
	output [2:0]		Br_sel
);
	reg [2:0] Imm_sel_R;
	reg A_sel_R;
	reg B_sel_R;
	reg [3:0] Alu_op_R;
	reg MemRen_R;
	reg MemWen_R;
	reg RegWen_R;
	reg [1:0] Wb_sel_R;
	reg [2:0] Br_sel_R;
	always @(*) begin
		casez (inst)
			`ADDI:begin
				Imm_sel_R		= `IMM_I;
				A_sel_R			= `A_SR1;
				B_sel_R			= `B_IMM;
				Alu_op_R		= `ALU_ADD;
				MemRen_R		= `MemXX;
				MemWen_R		= `MemXXX;
				RegWen_R		= `RegWen;
				Wb_sel_R		= `WB_ALU;
				Br_sel_R		= `BR_XXX;
			end
			default:begin
				Imm_sel_R		= `IMM_X;
				A_sel_R			= `A_XXX;
				B_sel_R			= `B_XXX;
				Alu_op_R		= `ALU_XXX;
				MemRen_R		= `MemXX;
				MemWen_R		= `MemXXX;
				RegWen_R		= `RegXXX;
				Wb_sel_R		= `WB_XXX;
				Br_sel_R		= `BR_XXX;
			end
		endcase
	end
	assign Imm_sel		= Imm_sel_R;
	assign A_sel		= A_sel_R;
	assign B_sel		= B_sel_R;
	assign Alu_op		= Alu_op_R;
	assign MemRen		= MemRen_R;
	assign MemWen		= MemWen_R;
	assign RegWen		= RegWen_R;
	assign Wb_sel		= Wb_sel_R;
	assign Br_sel		= Br_sel_R;
endmodule


