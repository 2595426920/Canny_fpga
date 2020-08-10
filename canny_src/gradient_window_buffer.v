// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : ZYS 2595426920@qq.com
// WeChat : 18232247765
// File   : gradient_window_buffer.v
// Create : 2020-04-09 10:19:25
// Revise : 2020-04-10 10:12:38
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module gradient_window_buffer(
 			clk,
 			rst,
 			din_valid,
 			din,
 			IH,
 			IW,
 			//输出
 			window_data_all,
 			window_mid,
 			dout_valid

 		
	);

//gaussian and sobel会使图像缩小
// parameter 		IW-1 				= 507;
// parameter 		IH-1 				= 507;
parameter 		KSZ 			= 3;
parameter 		DATAWID 		= 12;
parameter 		WINDOW_DATA_WID = 108;

input 	wire 						clk;
input 	wire 						rst;
input 	wire [10:0] 				IH;
input 	wire [10:0] 				IW;
input 	wire 						din_valid;
input 	wire [DATAWID-1:0]			din;
output 	reg [WINDOW_DATA_WID-1:0]	window_data_all;
output  reg [DATAWID-1:0] 			window_mid;
output 	reg							dout_valid;

reg						wr_en1,wr_en2;
reg		[10:0]			cnt_col,cnt_row;
reg						wr_en1_pre1;
reg						rd_en;
wire 	[DATAWID-1:0]	dout1,dout2;
reg		[DATAWID-1:0]	data_in1,data_in2;

	
wire 					full1,empty1,full2,empty2;
reg						flag_shift;
reg		[DATAWID-1:0]	dout1_t,dout1_tt;
reg		[DATAWID-1:0]	dout2_t,dout2_tt;
reg		[DATAWID-1:0]	rx_data,rx_data_t,rx_data_tt,rx_data_ttt;

reg						flag_d;

always @(posedge clk) begin
	if (rst== 1'b1) begin
		// reset
		cnt_col <= 'd0;
	end
	else if (din_valid == 1'b1 && cnt_col == IW-1) begin
		cnt_col <= 'd0;
	end
	else if (din_valid == 1'b1 && cnt_col != IW-1) begin
		cnt_col <=cnt_col + 1'b1;
	end
end
//一行像素技术
always @(posedge clk) begin
	if (rst== 1'b1) begin
		// reset
		cnt_row <= 'd0;
	end
	else if(din_valid == 1'b1 && cnt_col == IW-1 && cnt_row == IH-1)begin
		cnt_row <= 'd0;
	end
	else if (din_valid == 1'b1 && cnt_col == IW-1) begin
		cnt_row <= cnt_row + 1'b1;
	end
end
always @(posedge clk) begin
	if (rst == 1'b1) begin
		wr_en1 <= 1'b0;
	end
	else if (cnt_row == 'd0) begin
		wr_en1 <= din_valid;
	end
	else begin
		wr_en1 <= wr_en1_pre1;
	end
end

always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		wr_en1_pre1 <= 1'b0;
	end
	else if (cnt_row >=2 && cnt_row <=IH-1-1 && din_valid == 1'b1) begin//计算区间
		wr_en1_pre1 <= 1'b1;
	end
	else begin
		wr_en1_pre1 <= 1'b0;
	end
end



always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		rd_en <= 1'b0;
	end
	else if (cnt_row >=2 && cnt_row <=IH-1 && din_valid == 1'b1) begin
		rd_en <= 1'b1;
	end
	else begin
		rd_en <= 1'b0;
	end
end
//fifo1
always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		data_in1 <= 'd0;
	end
	else if (cnt_row == 'd0) begin
		data_in1 <= din;
	end
	else  begin//if (cnt_row >=2 && cnt_row <=84)
		data_in1 <= dout2;
	end
end

always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		wr_en2 <= 1'b0;
	end
	else if (cnt_row >=1 && cnt_row <=IH-1-1 && din_valid == 1'b1) begin
		wr_en2 <= 1'b1;
	end
	else begin
		wr_en2 <= 1'b0;
	end
end

always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		data_in2 <= 'd0;
	end
	else if ( cnt_row >=1 && cnt_row <=IH-1-1) begin
		data_in2 <= din;
	end
end

always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		flag_shift <= 1'b0;
	end
	else begin
		flag_shift <= 1'b1;
	end
end

always @(posedge clk) begin
	if (rst == 1'b1) begin
		// reset
		flag_d <= 1'b0;
	end
	else if (cnt_col >=2&&cnt_row>=2 && din_valid == 1'b1) begin
		flag_d <= 1'b1;
	end
	else begin
		flag_d <= 1'b0;
	end
end



always@(posedge clk)begin
	dout_valid <= flag_d;
end
	
sfifo_wr12x1024 fifo1 (
  .clk(clk),     
  .din(data_in1),
  .wr_en(wr_en1),
  .rd_en(rd_en), 
  .dout(dout1),  
  .full(full1),  
  .empty(empty1) 
);
sfifo_wr12x1024 fifo2 (
  .clk(clk),     
  .din(data_in2),
  .wr_en(wr_en2),
  .rd_en(rd_en), 
  .dout(dout2),  
  .full(full2),  
  .empty(empty2) 
);
always@(posedge clk)begin
	rx_data <= din;
end
always@(posedge clk)begin
	if(flag_shift == 1'b1)begin
	{dout1_tt,dout1_t} <= {dout1_t,dout1};
	{dout2_tt,dout2_t} <= {dout2_t,dout2};
	{rx_data_tt,rx_data_t}<={rx_data_t,rx_data};
	end
end
always@(posedge clk)begin
	if(rst == 1'b1)begin
		window_data_all <= 'd0;
	end
	else if(flag_d == 1'b1)begin
		window_data_all <= {rx_data,rx_data_t,rx_data_tt,dout2,dout2_t,dout2_tt,dout1,dout1_t,dout1_tt};
	end
	else begin
		window_data_all <= 'd0;
	end
end
always@(posedge clk)begin
	if(rst == 1'b1)begin
		window_mid <= 'd0;
	end
	else if(flag_d == 1'b1)begin
		window_mid <= dout2_t;
	end
	else begin
		window_mid <= 'd0;
	end
end

endmodule 