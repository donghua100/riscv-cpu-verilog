`include "define.v"
module ALU(
	input [3:0]			Alu_op,
	input [`XLEN -1:0]	A,
	input [`XLEN -1:0]	B,
	output [`XLEN-1:0]  Alu_out
);
	reg [`XLEN-1:0] alu_out;
	always @(*) begin
		case(Alu_op)
			`ALU_ADD:alu_out = A + B;
			`ALU_SUB:alu_out = A - B;
			`ALU_AND:alu_out = A & B;
			`ALU_OR :alu_out = A | B;
			`ALU_XOR:alu_out = A ^ B;
			default:alu_out = A;
		endcase
	end
	assign Alu_out = alu_out;
endmodule
