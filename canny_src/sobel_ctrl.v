// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : ZYS 2595426920@qq.com
// WeChat : 18232247765
// File   : sobel_ctrl.v
// Create : 2020-04-09 10:33:11
// Revise : 2020-04-09 13:56:36
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

module sobel_ctrl(
	input	wire 			clk,
	input	wire 			rst_n,
	input	wire 			pi_flag,
	input	wire 	[7:0]	pi_data,
	input 	wire 	[10:0] 	IH,
	input 	wire 	[10:0] 	IW,
	output 	reg 			po_flag,
	output 	reg signed	[11:0]	dx,
	output 	reg signed	[11:0]	dy
	
	);

reg				wr_en1,wr_en2;
reg		[10:0]	cnt_col,cnt_row;
reg				wr_en1_pre1;
reg				rd_en;
wire 	[7:0]	dout1,dout2;
reg		[7:0]	data_in1,data_in2;
wire 			full1,empty1,full2,empty2;
reg				flag_shift;
reg		[7:0]	dout1_t,dout1_tt;
reg		[7:0]	dout2_t,dout2_tt;
reg		[7:0]	rx_data,rx_data_t,rx_data_tt;

reg				flag_d;
wire	[10:0]  CNT_COL_MAX;
wire  	[10:0]	CNT_ROW_MAX;	
//处理图像的大小
assign  CNT_COL_MAX =	IW -1;
assign 	CNT_ROW_MAX =	IH -1;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		wr_en1 <= 1'b0;
	end
	else if (cnt_row == 'd0) begin
		wr_en1 <= pi_flag;
	end
	else begin
		wr_en1 <= wr_en1_pre1;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		wr_en1_pre1 <= 1'b0;
	end
	else if (cnt_row >=2 && cnt_row <=CNT_ROW_MAX-1 && pi_flag == 1'b1) begin//计算区间
		wr_en1_pre1 <= 1'b1;
	end
	else begin
		wr_en1_pre1 <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		rd_en <= 1'b0;
	end
	else if (cnt_row >=2 && cnt_row <=CNT_ROW_MAX && pi_flag == 1'b1) begin
		rd_en <= 1'b1;
	end
	else begin
		rd_en <= 1'b0;
	end
end
//fifo1
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		data_in1 <= 'd0;
	end
	else if (cnt_row == 'd0) begin
		data_in1 <= pi_data;
	end
	else  begin//if (cnt_row >=2 && cnt_row <=84)
		data_in1 <= dout2;
	end
end

always @(posedge clk or negedge rst_n ) begin
	if (rst_n  == 1'b0) begin
		// reset
		wr_en2 <= 1'b0;
	end
	else if (cnt_row >=1 && cnt_row <=CNT_ROW_MAX-1 && pi_flag == 1'b1) begin
		wr_en2 <= 1'b1;
	end
	else begin
		wr_en2 <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		data_in2 <= 'd0;
	end
	else if ( cnt_row >=1 && cnt_row <=CNT_ROW_MAX-1) begin
		data_in2 <= pi_data;
	end
end


always @(posedge clk ) begin
	po_flag <= flag_d;
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		cnt_col <= 'd0;
	end
	else if (pi_flag == 1'b1 && cnt_col == CNT_COL_MAX) begin
		cnt_col <= 'd0;
	end
	else if (pi_flag == 1'b1 && cnt_col != CNT_COL_MAX) begin
		cnt_col <=cnt_col + 1'b1;
	end
end
//一行像素技术
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		cnt_row <= 'd0;
	end
	else if(pi_flag == 1'b1 && cnt_col == CNT_COL_MAX && cnt_row == CNT_ROW_MAX)begin
		cnt_row <= 'd0;
	end
	else if (pi_flag == 1'b1 && cnt_col == CNT_COL_MAX) begin
		cnt_row <= cnt_row + 1'b1;
	end
end


always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		flag_shift <= 1'b0;
	end
	else if(rd_en ==1'b1)begin
		flag_shift <= 1'b1;
	end
	else begin
		flag_shift <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		flag_d <= 1'b0;
	end
	else if (cnt_col >=2&&cnt_row>=2 && pi_flag == 1'b1) begin
		flag_d <= 1'b1;
	end
	else begin
		flag_d <= 1'b0;
	end
end


always@(posedge clk)begin
	po_flag <= flag_d;
end
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		dx <='d0;
		dy <='d0;
	end
	else if (flag_d == 1'b1) begin
		dx <= $signed(dout1_tt - dout1)+(($signed(dout2_tt - dout2))<<1)+$signed(rx_data_tt- rx_data);
		dy <=$signed(dout1 - rx_data)+(($signed(dout1_t - rx_data_t))<<1)+$signed(dout1_tt - rx_data_tt);
	end
end
always@(posedge clk)begin
	rx_data <= pi_data;
end
always@(posedge clk)begin
		{dout1_tt,dout1_t} <= {dout1_t,dout1};
		{dout2_tt,dout2_t} <= {dout2_t,dout2};
		{rx_data_tt,rx_data_t}<={rx_data_t,rx_data};
end



sfifo_wr1024x8 fifo1 (
  .clk(clk), // input clk
  .din(data_in1), // input [7 : 0] din
  .wr_en(wr_en1), // input wr_en
  .rd_en(rd_en), // input rd_en
  .dout(dout1), // output [7 : 0] dout
  .full(full1), // output full
  .empty(empty1) // output empty
);


sfifo_wr1024x8 fifo2 (
  .clk(clk), // input clk
  .din(data_in2), // input [7 : 0] din
  .wr_en(wr_en2), // input wr_en
  .rd_en(rd_en), // input rd_en
  .dout(dout2), // output [7 : 0] dout
  .full(full2), // output full
  .empty(empty2) // output empty
);


endmodule