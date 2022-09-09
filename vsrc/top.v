`include"define.v"


module top(
	input					clk,
	input					rst,
	input	[31:0]			inst,
	input	[`XLEN-1:0]		mrdata,
	output					mren,
	output					mwen,
	output	[`XLEN-1:0]		addr,
	output	[`XLEN-1:0]		mwdata,
	output	[`XLEN-1:0]		pc_out 
);

	reg		[`XLEN-1:0]		pc = `XLEN'h80000000;
	wire	[`XLEN-1:0]		pc4, dnpc;
	// wire	[31:0]			inst;
	wire	[4:0]			rs1, rs2, rd;
	wire	[`XLEN-1:0]		rdata1, rdata2, wdata;
	// wire	[`XLEN-1:0]		mrdata;
	wire					wen;
	wire	[2:0]			Imm_sel;
	wire					A_sel,B_sel;
	wire	[3:0]			Alu_op;
	// wire					mren,mwen;
	wire	[1:0]			Wb_sel;
	wire	[2:0]			Br_sel;
	wire					taken;
	wire	[`XLEN-1:0]		Imm, immI, immS, immB, immU, immJ;
	wire	[`XLEN-1:0]		A, B, Alu_out;

	// IFU ifu(.pc(pc),
	// 	.inst(inst));
	// initial begin
	//	pc = `XLEN'h80000000;
	// end

	ID  id(.inst(inst),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd));

	RegFile regfile(.clk(clk),
		.wen(wen),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.wdata(wdata),
		.rdata1(rdata1),
		.rdata2(rdata2));

	Control ctrl(.inst(inst),
		.Imm_sel(Imm_sel),
		.A_sel(A_sel),
		.B_sel(B_sel),
		.Alu_op(Alu_op),
		.MemRen(mren),
		.MemWen(mwen),
		.RegWen(wen),
		.Wb_sel(Wb_sel),
		.Br_sel(Br_sel));

	Immgen immgen(.inst(inst),
		.immI(immI),
		.immS(immS),
		.immB(immB),
		.immU(immU),
		.immJ(immJ));
	assign Imm = (Imm_sel == `IMM_I ? immI:
				(Imm_sel == `IMM_S ? immS : 
				(Imm_sel == `IMM_B ? immB:
				(Imm_sel == `IMM_U ? immU :
				(Imm_sel == `IMM_J ? immJ:0)))));
	assign A = (A_sel == `A_SR1 ? rdata1:
				(A_sel == `A_PC ? pc : 0));
	assign B = (B_sel == `B_SR1 ? rdata2:
				(B_sel == `B_IMM ? Imm:0));
	ALU alu(.Alu_op,
		.A(A),
		.B(B),
		.Alu_out(Alu_out));
	BrCond br(.Br_sel(Br_sel),
		.A(rdata1),
		.B(rdata2),
		.taken(taken));
	assign pc4  = pc + 4;
	assign dnpc = pc + Imm;
	assign pc_out = pc;
	always @(posedge clk or posedge rst) begin
		if (rst) pc <= `XLEN'h80000000;
		else begin
			if (!taken) pc <= pc4;
			else pc <= dnpc;
		end
	end

	/* Mem mem(.mren(mren), */
	/* 		.mwen(mwen), */
	/* 		.addr(Alu_out), */
	/* 		.wdata(rdata2), */
	/* 		.rdata(rdata)); */
	assign addr = Alu_out;
	assign mwdata = rdata2; 
	assign wdata = (Wb_sel == `WB_ALU ? Alu_out:
				(Wb_sel == `WB_MEM ? mrdata :0));
endmodule
