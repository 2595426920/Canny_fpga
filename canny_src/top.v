// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : ZYS 2595426920@qq.com
// WeChat : 18232247765
// File   : top.v
// Create : 2020-04-09 11:48:27
// Revise : 2020-04-10 10:24:44
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module canny_top(
	input 	wire 			clk,
	input 	wire 			rst,
	input 	wire 			pi_flag,
	input 	wire 	[31:0]	pi_data,
	input 	wire 	[11:0] 	IH,
	input 	wire 	[11:0] 	IW,
	output	wire 	[31:0] 	po_data,
	output 	wire 			po_flag
	);

wire [7:0]	din;
wire [7:0] 	dout;

assign 	din = pi_data[15:8];
assign 	po_data = {16'b0,dout,8'b0};

	canny inst_canny(
			.clk      (clk),
			.rst      (rst),
			.pi_flag  (pi_flag),
			.pi_data  (din),
			.IH       (IH[10:0]),
			.IW       (IW[10:0]),
			.dout     (dout),
			.dout_vld (po_flag)
		);



endmodule