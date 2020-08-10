// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu May 14 13:49:55 2020
// Host        : LB51-20150330UC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode funcsim
//               f:/tcp_image18.2/canny_test/project_1/project_1.srcs/sources_1/ip/square/square_sim_netlist.v
// Design      : square
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "square,mult_gen_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_14,Vivado 2018.2" *) 
(* NotValidForBitStream *)
module square
   (CLK,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [11:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [11:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [23:0]P;

  wire [11:0]A;
  wire [11:0]B;
  wire CLK;
  wire [23:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "12" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "12" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "23" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  square_mult_gen_v12_0_14 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "12" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "12" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "23" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "zynq" *) (* ORIG_REF_NAME = "mult_gen_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module square_mult_gen_v12_0_14
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [11:0]A;
  input [11:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [23:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [11:0]A;
  wire [11:0]B;
  wire CLK;
  wire [23:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "12" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "12" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "23" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  square_mult_gen_v12_0_14_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
Xy0rQtyFjlVkbWfeQXwuqraA3MiYyL0eFNjbY4iEa+s0Iy4tsgQeJeqb8F2nyNFI15QQro+xjbie
m+gt7LRqSA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
ket885wFwjDLqC97HI68cpTwpD1hGBIJdkMh+rsfw+vPf59MdHJNNbcLh5jkiDAOhjCAn8l7Pljd
OAdA4DPaB1th3EEcK28Uhm8xkCE8u1JeKM+cTawL1ZqM7f5vFJDMTdaQdo2ODraPwf63iOc4O7I1
Jp0iW8w4eq4dmJxUtLQ=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
0sLRbF/nd38eurlUzps5D+y+9REEleMhJud3+B55Wgm1hYo1ntzC4vdMFNHAcAq1l46fEiE/D85o
eYPC/WuBoZraAAbt+2vzvO+6NgUIpKKrii5bWkc7zSRBw4OUgkdgOToRQnup7uEq7pNL5gER2W2q
jpbl57Ks7667W7TbtoCx+55cY2wmHeQ+Fi9eAhxvopt9UQ7JhiAITU32QV0QOUo0C5DuMrCOfUPt
Q4mY/sCujPAsGwpHpQOH6JmVeTJ9/9FBANFdHkzv6F+8T8a1pEE2+YcJXysHrFHMtW27J1ZZCZGA
hChjmCakAGz4Jve6Njfz9RKNiLrrvv0gHwgvEw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Z45gwqdZGpYP0Kv2lPvhL9t/dewTJD5ANS61F5BSLbdhMd8PVbRummT3J9CrH0Xrbuzjih6sOpQw
kP9SCPfkWk0LECt8HjobCatSEoRRONU79HyCEoDk93VT8CY8JL1BVS13wUngEWn6CIfitTyUUXR/
CxyxtdDZQFDUfHXEX4XQ0Yn12IXvHzgVAVLyG8UmGQWtQl4u7U/ZvMszHbCI4hHi6FW2kYvzBYlf
e14GZYOKCoOlqFp/3u2vs2rSSE9ciWV/SYIJDbOxsQCcBEM+UYYOzWikcZxKJAlJhndq92g1JKTL
sQcp7SBbbJ1O6Xynuz0MZ47Dfl+F87qkHSjwDQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
AeZ3V4sxDArImz8Q4W0bdOLintyw5zFj71qsxS4fYZUiRz8fNjC87lJzQ+YnUM13/42C5tAz/W5B
5De7uFmIgyIiHZ7Y1Ljeaa49Hank9rJJwKCFDSSNL8oJL51I1jWnn7YQnA7UX2zo1TTkepqKq7HW
QLVQHxdIfz7XQJ1KYPLfGQXcsGEecPlraNmNXeykJAgtAFm5XnR8iyVOGbjm9W9BUx0070wOpVoK
DNLr58vy3yAgTwtSBr+RexJEsBPZIUDyrA9NgYHy91GC6l4e/tQMTkA5GUgHnQd/YiVINSR358nO
A3j+0MMXq+Hrg0TJtfXsqD7mdjD7gjs4pqa1Vw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
BTz6m4RfoEciTWA22aqSQ7leYhQBT580p+3gUMnEkDKrl8y/O8yBG9prYh9eaBfxpy/1/zsYPTfE
O0sD3klOHeyC81JjLy2AWCWL1sk9/7n5I9vvSHXaQP4PHYRjAzqZC2XENPD0SKyVkobaEQpad+o8
VjB8RI608B9GgMaZvYA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
D7Hbf96be8hL6h8aH9GXSy4IzBK9xG0ri9cVSVfA+REat+znGl+3rKoWJP3Y8xVsMkc1boG+wuph
DvXt9Y8VIRQAHNgamdZlVmWFc7YNNoioXwxsiPQUGQ033qF9EQryRyyXiVxfPqJOSfqv7PrbvgOT
5UDZUXtmOWGVrgoDlz45TFPs5v+lO6i3RYt0nujylzKTS8VLhLp7chpkjrCdjQc8hZGNDkUI5WPz
T16PgMtr8+aqlEn030MgQ09L5vJki+2qisAmejQVoQ30QbY0N/13XTb4LdaYF1u53Ib59hKf/1nP
//1d/wsq1f4QJoIkaVIa2ngZqWphjv4BhaOjtw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
IjyJAqscOdyDbY9TE6vmbV0yakgIRr2j+xTh3iRpRt/bvgeFJ3PJxRPdyx3NQOvM4JKG3kgv3dgD
+Ka8HazEh7qU7+e3NvvXcM4/XwC90MDXJiiWAvGzBbce27dzAAC1G69dKyt/ud562O0VD9RAsEKU
DvLeJjBD5+rs/DigHztuc6tI5QGv/OmqWVAPziYicowbpVlXLbBFrCE9xwfyMYxiCuL+BirJ18fn
4k18yZVs7ygdcz8pXbSghlkUuiaU2QyKVCvuuKqAmii/xa2JzB/smuP9wftk2ZuT1ajKsateNKDC
72VjHz9Kc2YPbXlcxcRA5Mv9WN/Qi/wj2VdoPw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oK54jNZ1Pt9MVx/KzBSF+kaq14JqeloQYfXCS24VWHOw2wb/TrKXjK5B+2dzosH9tRjfcwQzIJHf
7NFcU0FRsdfwpUmF4BlTUlLwwCoE0O9snozoJLsHZkm88LiKG+IqXT2ORXCGYFmLuCqoHztKYvvV
bE036FR91wLI/AjYj2eN/gEQ+UqnPjucm0uv1XJG2M/lKMhGqR46qCdvrEXwR+QXU6aGTtGuD1oC
TyIWNIc2x4jPc5hqsoN6DZY0GiAdjBQKEfBIZqPjFXoOJBux1CI3rH4xvVjR+nxNISJ5tLOUL5v1
2x/n0vOylgwPSnPoCn24Cz5nCkRty1SVOiJWDA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7264)
`pragma protect data_block
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
TazSlp/QCPobLa6yO2Dw2h6+OCCHvC11dQ==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
