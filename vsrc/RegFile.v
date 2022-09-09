`include"define.v"
module RegFile(
	input				clk,
	input				wen,
	input [4:0]			rs1,
	input [4:0]			rs2,
	input [4:0]			rd,
	input [`XLEN-1:0]	wdata,
	output [`XLEN-1:0]	rdata1,
	output [`XLEN-1:0]	rdata2
);
	reg [`XLEN-1:0] Regs [31:0];
	integer i = 0;
	initial begin
		for (i = 0; i < 32; i = i+1) begin
			Regs[i] = 0;
		end
	end

	always @(posedge clk) begin
		if(wen && rd!=0) Regs[rd] = wdata;
		else Regs[0] = 0;
	end
	
	assign rdata1 = Regs[rs1];
	assign rdata2 = Regs[rs2];
endmodule
