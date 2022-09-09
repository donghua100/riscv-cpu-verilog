`include"define.v"
module IFU(
	input [`XLEN - 1:0]		pc,
	output [31:0]			inst
);
	reg [31:0] imem [255:0];

	// initial begin
	// 	$readmemh('path',imem)
	// end

	assign inst = imem[pc];
endmodule


