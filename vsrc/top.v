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
	wire					RegWen;
	wire	[2:0]			Imm_sel;
	wire					A_sel,B_sel;
	wire	[3:0]			Alu_op;
	wire					MemRen,MemWen;
	wire	[1:0]			Wb_sel;
	wire	[2:0]			Br_sel;
	wire					taken;
	wire	[`XLEN-1:0]		Imm, immI, immS, immB, immU, immJ;
	wire	[`XLEN-1:0]		A, B, Alu_out;
	
	// IF_ID
	reg		[31:0]			if_id_inst;
	reg		[`XLEN -1:0]	if_id_pc;

	// ID_EX
	reg		[`XLEN-1:0]		id_ex_rdata1;
	reg		[`XLEN-1:0]		id_ex_rdata2;
	reg		[`XLEN-1:0]		id_ex_Imm;
	reg		[`XLEN-1:0]		id_ex_pc;
	reg		[4:0]			id_ex_rd;
	reg						id_ex_A_sel;
	reg						id_ex_B_sel;
	reg		[3:0]			id_ex_Alu_op;
	reg		[2:0]			id_ex_Br_sel;
	reg						id_ex_Mren;
	reg						id_ex_Mwen;
	reg						id_ex_Rwen;
	reg		[1:0]			id_ex_Wb_sel;


	// EX_MEM
	reg		[`XLEN-1:0]		ex_mem_Alu_out;
	reg		[`XLEN-1:0]		ex_mem_pc;
	reg		[`XLEN-1:0]		ex_mem_rdata2;
	reg		[4:0]			ex_mem_rd;
	reg						ex_mem_Mren;
	reg						ex_mem_Mwen;
	reg						ex_mem_Rwen;
	reg		[1:0]			ex_mem_Wb_sel;

	// MEM_WB
	reg		[`XLEN-1:0]		mem_wb_mdata;
	reg		[`XLEN-1:0]		mem_wb_Alu_out;
	reg		[`XLEN-1:0]		mem_wb_pc;
	reg		[1:0]			mem_wb_Wb_sel;
	reg		[4:0]			mem_wb_rd;
	reg						mem_wb_Rwen;



	
	// IFU ifu(.pc(pc),
	// 	.inst(inst));
	// initial begin
	//	pc = `XLEN'h80000000;
	// end
	
	always @(posedge clk) begin
		if (rst) begin
			if_id_pc <= `XLEN'h0;
			if_id_inst <= `NOP;
		end
		else begin
			if_id_pc <= pc;
			if_id_inst <= inst;
		end
	end

	ID  id(.inst(inst),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd));

	RegFile regfile(.clk(clk),
		.wen(mem_wb_Rwen),
		.rs1(rs1),
		.rs2(rs2),
		.rd(mem_wb_rd),
		.wdata(wdata),
		.rdata1(rdata1),
		.rdata2(rdata2));

	Control ctrl(.inst(inst),
		.Imm_sel(Imm_sel),
		.A_sel(A_sel),
		.B_sel(B_sel),
		.Alu_op(Alu_op),
		.MemRen(MemRen),
		.MemWen(MemWen),
		.RegWen(RegWen),
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
	always @(posedge clk) begin
		if (rst) begin
			id_ex_rdata1	<= 0;
			id_ex_rdata2	<= 0;
			id_ex_Imm		<= 0;
			id_ex_pc		<= 0;
			id_ex_rd		<= 0;
			id_ex_A_sel		<= `A_XXX;
			id_ex_B_sel		<= `B_XXX;
			id_ex_Alu_op	<= `ALU_XXX;
			id_ex_Br_sel	<= `BR_XXX;
			id_ex_Mren		<= `MemXX;
			id_ex_Mwen		<= `MemXXX;
			id_ex_Rwen		<= `RegXXX;
			id_ex_Wb_sel	<= `WB_XXX;
		end
		else begin
			id_ex_rdata1	<= rdata1;
			id_ex_rdata2	<= rdata2;
			id_ex_Imm		<= Imm;
			id_ex_pc		<= if_id_pc;
			id_ex_rd		<= rd;
			id_ex_A_sel		<= A_sel;
			id_ex_B_sel		<= B_sel;
			id_ex_Alu_op	<= Alu_op;
			id_ex_Br_sel	<= Br_sel;
			id_ex_Mren		<= MemRen;
			id_ex_Mwen		<= MemWen;
			id_ex_Rwen		<= RegWen;
			id_ex_Wb_sel	<= Wb_sel;
		end
	end


	assign A = (id_ex_A_sel == `A_SR1 ? id_ex_rdata1:
				(id_ex_A_sel == `A_PC ? id_ex_pc : 0));
	assign B = (id_ex_B_sel == `B_SR1 ? id_ex_rdata2:
				(id_ex_B_sel == `B_IMM ? id_ex_Imm:0));
	ALU alu(.Alu_op(id_ex_Alu_op),
		.A(A),
		.B(B),
		.Alu_out(Alu_out));
	BrCond br(.Br_sel(id_ex_Br_sel),
		.A(id_ex_rdata1),
		.B(id_ex_rdata2),
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

	always @(posedge clk) begin
		if (rst) begin
			ex_mem_Alu_out	<= 0;
			ex_mem_pc		<= 0;
			ex_mem_rdata2	<= 0;
			ex_mem_rd		<= 0;
			ex_mem_Mren		<= `MemXX;
			ex_mem_Rwen		<= `MemXXX;
			ex_mem_Rwen		<= `RegXXX;
			ex_mem_Wb_sel	<= `WB_XXX;
		end
		else begin
			ex_mem_Alu_out	<= Alu_out;
			ex_mem_pc		<= id_ex_pc;
			ex_mem_rdata2	<= id_ex_rdata2;
			ex_mem_rd		<= id_ex_rd;
			ex_mem_Mren		<= id_ex_Mren;
			ex_mem_Mwen		<= id_ex_Mwen;
			ex_mem_Rwen		<= id_ex_Rwen;
			ex_mem_Wb_sel	<= id_ex_Wb_sel;
		end
	end

	/* Mem mem(.mren(ex_mem_Mren), */
	/* 		.mwen(ex_mem_Mwen), */
	/* 		.addr(Alu_out), */
	/* 		.wdata(rdata2), */
	/* 		.rdata(rdata)); */

	assign addr		= ex_mem_Alu_out;
	assign mwdata	= ex_mem_rdata2;
	assign mwen		= ex_mem_Mwen;
	assign mren		= ex_mem_Mren;

	always @(posedge clk) begin
		if (rst) begin
			mem_wb_mdata	<= 0;
			mem_wb_Alu_out	<= 0;
			mem_wb_pc		<= 0;
			mem_wb_Wb_sel	<= `WB_XXX;
			mem_wb_Rwen		<= `RegXXX;
			mem_wb_rd		<= 0;
		end
		else begin
			mem_wb_mdata	<= mwdata;
			mem_wb_Alu_out	<= ex_mem_Alu_out;
			mem_wb_pc		<= ex_mem_pc;
			mem_wb_Wb_sel	<= ex_mem_Wb_sel;
			mem_wb_Rwen		<= ex_mem_Rwen;
			mem_wb_rd		<= ex_mem_rd;
		end
	end

	assign wdata = (mem_wb_Wb_sel == `WB_ALU ? mem_wb_Alu_out:
				(mem_wb_Wb_sel == `WB_MEM ? mem_wb_mdata :0));
endmodule
