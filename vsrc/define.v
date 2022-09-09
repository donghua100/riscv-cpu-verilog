`define		XLEN		64

// Imm_sel
`define		IMM_X		3'd0
`define		IMM_I		3'd1
`define		IMM_S		3'd2
`define		IMM_B		3'd3
`define		IMM_U		3'd4
`define		IMM_J		3'd5

// A_sel
`define		A_XXX		1'd0
`define		A_SR1		1'd0
`define		A_PC		1'd1

// B_sel
`define		B_XXX		1'd0
`define		B_SR1		1'd0
`define		B_IMM		1'd1

// Alu_op
`define		ALU_ADD		4'd0
`define		ALU_SUB		4'd1
`define		ALU_AND		4'd2
`define		ALU_OR		4'd3
`define		ALU_XOR		4'd4
`define		ALU_XXX		4'd15

// Mem
`define		MemXX		1'd0
`define		MemRen		1'd1

`define		MemXXX		1'd0
`define		MemWen		1'd1

// Wb_sel
`define		WB_XXX		2'd0
`define		WB_ALU		2'd0
`define		WB_MEM		2'd1
`define		WB_PC		2'd2

`define		RegXXX		1'd0
`define		RegWen		1'd1

// Br_sel
`define		BR_XXX		3'd0
`define		BR_EQ		3'd1
`define		BR_NEQ		3'd2
`define		BR_LT		3'd3
`define		BR_GE		3'd4
`define		BR_LTU		3'd5
`define		BR_GEU		3'd6


`define		ADDI		32'b???????_?????_000_?????0010011
