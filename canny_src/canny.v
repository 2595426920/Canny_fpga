// -----------------------------------------------------------------------------
// Copyright (c) 2014-2020 All rights reserved
// -----------------------------------------------------------------------------
// Author : ZYS 2595426920@qq.com
// WeChat : 18232247765
// File   : canny.v
// Create : 2020-03-27 10:40:53
// Revise : 2020-04-10 13:48:34
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module canny(
	input 	wire 			clk,
	input 	wire 			rst,
	input 	wire 			pi_flag,
	input 	wire 	[7:0]	pi_data,
	// input 	wire 			vsync,
	input 	wire 	[10:0] 	IH,
	input 	wire 	[10:0] 	IW,
	output	wire 	[7:0] 	dout,
	output 	wire 			dout_vld
	// output 	wire 			vsync_out

	);

parameter KSZ 		= 3;
parameter ThrHigh 	= 40;
parameter ThrLow 	= 20;
parameter first	 	= 4'b0001;
parameter second	= 4'b0010;
parameter third	 	= 4'b0100;
parameter forth	 	= 4'b1000;

wire 				rst_n;
wire signed [11:0]	dx;
wire signed [11:0]	dy;
// reg  signed [11:0]	dx_r1,dx_r2,dx_r3,dx_r4;
// reg  signed [11:0]	dy_r1,dy_r2,dy_r3,dy_r4;
reg  signed [11:0]	abs_dx;
reg  signed [11:0]	abs_dy;
reg 		 	 	dx_sign;
reg 		 	 	dy_sign;
wire 				po_flag;


wire 		[23:0]	square_out_dx;
wire 		[23:0]	square_out_dy;
wire 		[31:0]	square_out;
reg 		[1:0]	square_data_vld;
wire 		[23:0]	square_root_data;
reg 		[11:0] 	square_root_data_r;
wire 				square_root_data_vld;
reg 		[11:0]	Max;
reg 		[11:0]	Min;
reg 		[3:0]	quardrant;
wire 		[11:0] 	gradient;
reg 		[24:0] 	dout_vld_r;
reg 				calc_dout_vld;
assign rst_n = ~rst;

sobel_ctrl inst_sobel_ctrl (
		.clk     (clk),
		.rst_n   (rst_n),
		.pi_flag (pi_flag),
		.pi_data (pi_data),
		.IH 	 (IH),
		.IW 	 (IW),
		.po_flag (po_flag),
		.dx      (dx),
		.dy      (dy)
	);
 
square square_dx (
  .CLK(clk),  // input wire CLK
  .A(dx),      // input wire [11 : 0] A
  .B(dx),      // input wire [11 : 0] B
  .P(square_out_dx)      // output wire [23 : 0] P
);

square square_dy (
  .CLK(clk),  // input wire CLK
  .A(dy),      // input wire [11 : 0] A
  .B(dy),      // input wire [11 : 0] B
  .P(square_out_dy)      // output wire [23 : 0] P
);

//打拍dx，dy的符号用来判断象限信息
always@(posedge clk)begin
	dx_sign <= dx[11];
	dy_sign <= dy[11];
end
//合并平方信息
assign square_out = {8'b0,square_out_dy} + {8'b0,square_out_dx};
//打拍sobel中的输出有效信息，用来作为平方根的有效信号，这是由于乘法器需要4个时钟周期才可以输出数据
always@(posedge clk)begin
	square_data_vld <= {square_data_vld[0],po_flag};
end
//平方根操作
square_root inst_square_root(
  .s_axis_cartesian_tvalid(square_data_vld[0]),  // input wire s_axis_cartesian_tvalid
  .s_axis_cartesian_tdata(square_out),    // input wire [31 : 0] s_axis_cartesian_tdata
  .m_axis_dout_tvalid(square_root_data_vld),            // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(square_root_data)              // output wire [23: 0] m_axis_dout_tdata
);

//打一排平方根，用于最终4元素的输出
always@(posedge clk)begin
	square_root_data_r <= square_root_data[11:0];
end
assign gradient = square_root_data_r;


always @(posedge clk) begin
	if (rst == 1'b1) begin
		abs_dx<='d0;
	end
	else if (po_flag == 1'b1 && dx[11] == 1'b1) begin
		abs_dx <= (~dx)+1;
	end
	else if(po_flag ==1'b1 && dx[11]==1'b0) begin
		abs_dx <= dx;
	end
end

always @(posedge clk ) begin
	if (rst == 1'b1) begin
		abs_dy<='d0;
	end
	else if (po_flag ==1'b1 && dy[11] == 1'b1) begin
		abs_dy <= (~dy)+1;
	end
	else if (po_flag == 1'b1  && dy[11]==1'b0) begin
		abs_dy <= dy;
	end
end

//产生最大值最小值
always@(posedge clk)begin
	if(rst == 1'b1)begin
		Max <= 'd0;
		Min <= 'd0;
	end
	else begin
		if(abs_dx > abs_dy)begin
			Max <= abs_dx;
			Min <= abs_dy;
		end
		else begin
			Max <= abs_dy;
			Min <= abs_dx;
		end
	end
end
//象限信息
always@(posedge clk)begin
	if (rst == 1'b1) begin
		quardrant <= 4'b0;
	end
	if(square_data_vld[0] == 1'b1)begin
		if ((dx_sign == 1'b0 && dy_sign == 1'b1)|(dy_sign == 1'b0 && dx_sign == 1'b1)) begin
			if (abs_dx > abs_dy) begin
				quardrant <= first;
			end
			else begin
				quardrant <= second;
			end
		end
		else if ((dx_sign == 1'b1 && dy_sign == 1'b1)|(dy_sign == 1'b0 && dx_sign == 1'b0)) begin
			if (abs_dx < abs_dy) begin
				quardrant <= third;
			end
			else begin
				quardrant <= forth;
			end
		end
	end
end
//将Max,Min,quardrant,gradient编成一股绳,12+12+8+12=44
wire [39:0]		win_buf_din;
wire [359:0] 	window_data_all;
wire [39:0]		window_mid;
wire 			window_sobel_valid;
wire [10:0]		IW_sobel_window;
wire [10:0]		IH_sobel_window;
assign IW_sobel_window = IW - 2;
assign IH_sobel_window = IH - 2;
//最低是模值，其次象限信息，再其次Min,而后Max
assign win_buf_din = {Max,Min,quardrant,gradient};	

	sobel_window_buffer sobel_window_buffer_inst (
			.clk             (clk),
			.rst             (rst),
			.IH  			 (IH_sobel_window),
			.IW 			 (IW_sobel_window),	
			.din_valid       (square_data_vld[1]),
			.din             (win_buf_din),
			.window_data_all (window_data_all),
			.window_mid      (window_mid),
			.dout_valid      (window_sobel_valid)
		);

//将9个元素的结果拆开
wire [39:0]	win_data 		[KSZ*KSZ-1:0];
wire [11:0]	win_max 		[KSZ*KSZ-1:0];
wire [11:0]	win_min 		[KSZ*KSZ-1:0];
wire [3:0]	win_quardrant 	[KSZ*KSZ-1:0];
wire [11:0]	win_gradient 	[KSZ*KSZ-1:0];	
generate
	genvar i;
	for (i = 1; i <= KSZ*KSZ; i = i + 1)
	begin:build_LOOKUP_TABLE
		assign win_data		 [i-1] = (window_sobel_valid==1'b1)?window_data_all[40*i-1 -:40]:'d0;	
		assign win_max 		 [i-1] = win_data[i-1][39:28];
		assign win_min 		 [i-1] = win_data[i-1][27:16];
		assign win_quardrant [i-1] = win_data[i-1][15:12];
		assign win_gradient	 [i-1] = win_data[i-1][11:0];
	end
endgenerate
//构建插值元素的索引参数
reg [3:0]	LUT_index 		[3:0]; 

reg [11:0]	win_max_r 		[8:0];
reg [11:0]	win_min_r 		[8:0];
// reg [3:0]	win_quardrant_r [8:0];
reg [11:0]	win_gradient_r  [8:0];

generate
	genvar v;
	for (v = 0; v <= 8; v = v + 1)
	begin:reg_window_max
		always@(posedge clk)begin
			win_max_r 		 [v]	<= win_max 	 	  [v];
			win_min_r 		 [v]	<= win_min 		  [v];
			// win_quardrant_r  [v]	<= win_quardrant  [v];
			win_gradient_r 	 [v]	<= win_gradient   [v];

		end
	end
endgenerate
//根据象限产生索引值
always @(posedge clk)
	begin 
		if(window_sobel_valid==1'b1)
		begin 
			if(win_quardrant[4]==4'b0001) //1st quadrant
			begin 
				LUT_index[0] <= 4'd2;
				LUT_index[1] <= 4'd5;
				LUT_index[2] <= 4'd6;
				LUT_index[3] <= 4'd3;
			end 
			else if(win_quardrant[4]==4'b0010)//2nd quadrant
			begin 
				LUT_index[0] <=  4'd2;
				LUT_index[1] <=  4'd1;
				LUT_index[2] <=  4'd6;
				LUT_index[3] <=  4'd7;
			end 
			else if(win_quardrant[4]==4'b0100)//3th quadrant
			begin 
				LUT_index[0] <=  4'd0;
				LUT_index[1] <=  4'd1;
				LUT_index[2] <=  4'd8;
				LUT_index[3] <=  4'd7;
			end 
			else //4th quadrant
			begin 
				LUT_index[0] <= 4'd0;
				LUT_index[1] <= 4'd3;
				LUT_index[2] <= 4'd8;
				LUT_index[3] <= 4'd5;
			end 
		end 
	end

reg 	[3:0] 			calc_beat;
reg 	[7:0]			nms_result;
reg 	[23:0]			nms_max_a4;
reg 	[23:0]			nms_max_a4_r;
reg 	[23:0]			nms_add1;
reg 	[23:0]			nms_add2;
reg 	[23:0]			nms_add3;
reg 	[23:0]			nms_add4;
reg 	[24:0]			nms_add5;
reg 	[24:0]			nms_add6;

always@(posedge clk)begin
	calc_beat <= {calc_beat[2:0],window_sobel_valid};
end

always@(posedge clk)begin
	if(rst==1'b1)begin
		nms_max_a4 <= 'd0;
		nms_add1   <= 'd0;
		nms_add2   <= 'd0;
		nms_add3   <= 'd0;
		nms_add4   <= 'd0;
	end
	else if(calc_beat[0]==1'b1)begin 
		nms_max_a4 <=  win_gradient_r[4]*win_max_r[4];
		nms_add1   <=  win_gradient_r[LUT_index[0]]*win_min_r[4];
		nms_add2   <=  win_gradient_r[LUT_index[1]]*(win_max_r[4]-win_min_r[4]);
		nms_add3   <=  win_gradient_r[LUT_index[2]]*win_min_r[4];
		nms_add4   <=  win_gradient_r[LUT_index[3]]*(win_max_r[4]-win_min_r[4]);
	end 
end
always@(posedge clk)begin
	if (rst ==1'b1) begin
		nms_max_a4_r <= 'd0;
		nms_add5	 <= 'd0;
		nms_add6	 <= 'd0;
	end
	if (calc_beat[1]==1'b1) begin
		nms_max_a4_r <=  nms_max_a4;
		nms_add5	 <=  nms_add1 + nms_add2;
		nms_add6	 <=  nms_add3 + nms_add4;
	end
end

always@(posedge clk)begin
	if (rst == 1'b1) begin
		nms_result <= 'd0;
	end
	else if(calc_beat[2]==1'b1)begin
		if(nms_max_a4_r == 'd0)
			nms_result <= 8'd0;
		else if( (nms_max_a4_r >= nms_add5) && (nms_max_a4_r >= nms_add6))
			nms_result <= 8'd128;
		else 
			nms_result <= 8'd0;	
	end 
end


//KSZ*KSZ*8-1
wire [71:0]				nms_data_temp;
wire [7:0] 				nms_mid;
wire  					window_nms_vld;
wire [10:0]				IW_nms_window;
wire [10:0]				IH_nms_window;
assign IW_nms_window = IW - 4;
assign IH_nms_window = IH - 4;
nms_window_buffer  nms_window_buffer_inst (
		.clk             (clk),
		.rst             (rst),
		.IH 			 (IH_nms_window),
		.IW 			 (IW_nms_window),
		.din_valid       (calc_beat[3]),
		.din             (nms_result),
		.window_data_all (nms_data_temp),
		.window_mid      (nms_mid),
		.dout_valid      (window_nms_vld)
	);
	//buffer mudule result 
	reg  [11:0] 	gradient_reg[2:0];
 	wire [107:0]	win_gradient_all; 
	wire [11:0]		gradient_mid_out;
	wire 			gradient_win_valid;
	generate
		genvar j;
		for (j = 0; j <= 2; j = j + 1)
		begin:reggrad
			if(j==0)begin
				always@(posedge clk)begin
					gradient_reg[0] <= win_gradient_r[4];
				end
			end
			else begin
				always@(posedge clk)begin
					gradient_reg[j] <= gradient_reg[j-1];
				end
			end
		end
	endgenerate
	//对于window_sobel中的中间元素的gradient开窗寄存
wire [10:0]				IW_gradient_window;
wire [10:0]				IH_gradient_window;
assign IW_gradient_window = IW - 4;
assign IH_gradient_window = IH - 4;
	gradient_window_buffer inst_gradient_window_buffer (
		.clk             (clk),
		.rst             (rst),
		.IH 			 (IH_gradient_window),
		.IW 			 (IW_gradient_window),
		.din_valid       (calc_beat[3]),
		.din             (gradient_reg[2]),
		.window_data_all (win_gradient_all),
		.window_mid      (gradient_mid_out),
		.dout_valid      (gradient_win_valid)
	);
	//针对window_grad构建查找表
	wire [11:0]win_gradient_data[8:0];
	generate
		genvar h;
		for (h = 0; h <= 8; h = h + 1)
		begin:build_gradient_lut
			assign win_gradient_data[h] = win_gradient_all[(h+1)*12-1-:12];
		end
	endgenerate

	//判断邻域内的gradient情况
	wire gradient_judge[0:7];
	assign gradient_judge[0] = (win_gradient_data[0] >= ThrHigh)?1'b1:1'b0; 
	assign gradient_judge[1] = (win_gradient_data[1] >= ThrHigh)?1'b1:1'b0;
	assign gradient_judge[2] = (win_gradient_data[2] >= ThrHigh)?1'b1:1'b0;
	assign gradient_judge[3] = (win_gradient_data[3] >= ThrHigh)?1'b1:1'b0;
	assign gradient_judge[4] = (win_gradient_data[5] >= ThrHigh)?1'b1:1'b0;
	assign gradient_judge[5] = (win_gradient_data[6] >= ThrHigh)?1'b1:1'b0;
	assign gradient_judge[6] = (win_gradient_data[7] >= ThrHigh)?1'b1:1'b0;
	assign gradient_judge[7] = (win_gradient_data[8] >= ThrHigh)?1'b1:1'b0;

	reg 		[2:0] 	grad_neighbour_judge_calc_beat;
	always@(posedge clk)begin
		grad_neighbour_judge_calc_beat <= {grad_neighbour_judge_calc_beat[1:0],gradient_win_valid};
	end

	reg 	grad_neighbour_judge_result;
	reg 	grad_neighbour_judge_first_step[3:0];
	reg 	grad_neighbour_judge_second_step[1:0];
	
	always @(posedge clk)
	if(rst == 1'b1)begin
		grad_neighbour_judge_first_step	[0] <= 'd0;
		grad_neighbour_judge_first_step	[1] <= 'd0;
		grad_neighbour_judge_first_step	[2] <= 'd0;
		grad_neighbour_judge_first_step	[3] <= 'd0;
 		grad_neighbour_judge_second_step[0] <= 'd0;
 		grad_neighbour_judge_second_step[1] <= 'd0;
 		grad_neighbour_judge_result 		<= 'd0;
	end
	else begin 
		if(gradient_win_valid==1'b1)
		begin
			grad_neighbour_judge_first_step[0] <= gradient_judge[0] | gradient_judge[1] ;
			grad_neighbour_judge_first_step[1] <= gradient_judge[2] | gradient_judge[3] ;
			grad_neighbour_judge_first_step[2] <= gradient_judge[4] | gradient_judge[5] ;
			grad_neighbour_judge_first_step[3] <= gradient_judge[6] | gradient_judge[7] ;
		end
		
		if(grad_neighbour_judge_calc_beat[0]==1'b1)
		begin
			grad_neighbour_judge_second_step[0] <= #1 grad_neighbour_judge_first_step[0] | grad_neighbour_judge_first_step[1] ;
			grad_neighbour_judge_second_step[1] <= #1 grad_neighbour_judge_first_step[2] | grad_neighbour_judge_first_step[3] ;
		end
		
		if(grad_neighbour_judge_calc_beat[1]==1'b1)
		begin
			grad_neighbour_judge_result <=  grad_neighbour_judge_second_step[0]|grad_neighbour_judge_second_step[1] ;
		end
	end 
//打拍使之与邻域梯度判断的结果同排，打两排
reg [7:0]	dout_temp;
reg [7:0]	nms_mid_r[2:0];
reg [11:0] 	gradient_mid_out_r[2:0];

always@(posedge clk)begin
	nms_mid_r[0]<=nms_mid;
	nms_mid_r[1]<=nms_mid_r[0];
	nms_mid_r[2]<=nms_mid_r[1];
	gradient_mid_out_r[0] <= gradient_mid_out;
	gradient_mid_out_r[1] <= gradient_mid_out_r[0];
	gradient_mid_out_r[2] <= gradient_mid_out_r[1];
end

always @(posedge clk)
	if(rst == 1'b1)begin
		dout_temp <= 'd0;
	end
	else begin 
		if(grad_neighbour_judge_calc_beat[2]==1'b1)
		begin
			if(nms_mid_r[2]==8'd128)
			begin 
				if(gradient_mid_out_r[2] >= ThrHigh)
					dout_temp <= 8'd255;
				else if(gradient_mid_out_r[2] <= ThrLow)
					dout_temp <= 'd0;
				else 
				begin 
					if(grad_neighbour_judge_result == 1'b1)
						dout_temp <= 8'd255;
					else 
						dout_temp <= 'd0;
				end 	
			end 
			else 
				dout_temp <= 'd0;
		end
	end 
	assign dout = (calc_dout_vld == 1'b1)? dout_temp : 'd0;
	always@(posedge clk)begin
		calc_dout_vld <= grad_neighbour_judge_calc_beat[2];
	end
	always@(posedge clk)begin
		dout_vld_r <= {dout_vld_r[18:0],pi_flag};
	end
	assign dout_vld = dout_vld_r[19];
	// assign vsync_out = vsync;
//debug
// reg 	[10:0] 	hcnt;
// reg 	[10:0] 	vcnt;
// wire 			dout_vld_full;
// assign dout_vld_full = (dout_vld) & (~dout_vld_r[18]);
// always@(posedge clk)begin
// 	if (rst == 1'b1) begin
// 		hcnt <= 'd0;
// 	end
// 	else if(dout_vld == 1'b0) begin
// 		hcnt<= 'd0;
// 	end
// 	else if (dout_vld == 1'b1) begin
// 		hcnt<= hcnt + 1'b1;
// 	end
// end

// always@(posedge clk)begin
// 	if (rst == 1'b1) begin
// 		vcnt<= 'd0;
// 	end
// 	else if (dout_vld_full == 1'b1) begin
// 		vcnt<= vcnt+1'b1;
// 	end
// end

endmodule