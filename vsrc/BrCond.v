`include"define.v"
module BrCond(
	input [2:0]			Br_sel,
	input [`XLEN-1:0]	A,
	input [`XLEN-1:0]	B,
	output				taken
);
	wire eq,neq,lt,ge,ltu,geu;
	assign eq = (A==B)?1'b1:1'b0;
	assign neq = !eq;
	assign lt = (A[`XLEN-1]==B[`XLEN-1])?(A[`XLEN-2:0]<B[`XLEN-2:0]):(A[`XLEN-1]==1);
	assign ge = !lt;
	assign ltu = (A<B)?1'b1:1'b0;
	assign geu = !ltu;
	assign taken = (Br_sel == `BR_EQ && eq) || (Br_sel == `BR_NEQ && neq) ||
					(Br_sel == `BR_LT && lt) || (Br_sel == `BR_GE && ge) ||
					(Br_sel == `BR_LTU && ltu) || (Br_sel == `BR_GEU && geu);
endmodule
