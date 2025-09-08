// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Mon Mar 17 18:44:23 2025
// Host        : ws11-22 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/hazard516_v3/hazard516_v3/hazard516.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_stub.v
// Design      : blk_mem_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module blk_mem_gen_1(clka, ena, wea, addra, dina, douta, clkb, enb, web, addrb, 
  dinb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[10:0],dina[15:0],douta[15:0],clkb,enb,web[0:0],addrb[10:0],dinb[15:0],doutb[15:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [10:0]addra;
  input [15:0]dina;
  output [15:0]douta;
  input clkb;
  input enb;
  input [0:0]web;
  input [10:0]addrb;
  input [15:0]dinb;
  output [15:0]doutb;
endmodule
