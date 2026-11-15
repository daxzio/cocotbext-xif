// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// XIF-top wrapper for Ara vector unit only.
// Exposes XIF (issue/commit/result/mem) at the top; inside: XIF->acc bridge, ara, axi_zero_mem.

module ara_xif_core #(
  parameter int unsigned NrLanes = 2,
  parameter int unsigned VLEN    = 128
) (
  input  logic        clk_i,
  input  logic        rst_ni,

  // XIF Issue (CPU -> coprocessor)
  input  logic        s_xif_issue_valid,
  input  logic [31:0] s_xif_issue_req_instr,
  input  logic [1:0]  s_xif_issue_req_mode,
  input  logic [3:0]  s_xif_issue_req_id,
  input  logic [31:0] s_xif_issue_req_rs_0,
  input  logic [31:0] s_xif_issue_req_rs_1,
  input  logic [31:0] s_xif_issue_req_rs_2,
  input  logic [2:0]  s_xif_issue_req_rs_valid,
  output logic        s_xif_issue_ready,
  output logic        s_xif_issue_resp_accept,
  output logic        s_xif_issue_resp_writeback,
  output logic        s_xif_issue_resp_dualwrite,
  output logic [2:0]  s_xif_issue_resp_dualread,
  output logic        s_xif_issue_resp_loadstore,
  output logic        s_xif_issue_resp_exc,

  // XIF Commit (CPU -> coprocessor)
  input  logic        s_xif_commit_valid,
  input  logic [3:0]  s_xif_commit_id,
  input  logic        s_xif_commit_kill,

  // XIF Memory (coprocessor -> CPU) – Ara has its own AXI; tie to idle
  output logic        s_xif_mem_valid,
  input  logic        s_xif_mem_ready,
  output logic [3:0]  s_xif_mem_req_id,
  output logic [31:0] s_xif_mem_req_addr,
  output logic [1:0]  s_xif_mem_req_mode,
  output logic        s_xif_mem_req_we,
  output logic [2:0]  s_xif_mem_req_size,
  output logic [3:0]  s_xif_mem_req_be,
  output logic [31:0] s_xif_mem_req_wdata,
  output logic        s_xif_mem_req_last,
  input  logic        s_xif_mem_resp_exc,
  input  logic [5:0]  s_xif_mem_resp_exccode,

  // XIF Memory result (CPU -> coprocessor)
  input  logic        s_xif_mem_result_valid,
  input  logic [3:0]  s_xif_mem_result_id,
  input  logic [31:0] s_xif_mem_result_rdata,
  input  logic        s_xif_mem_result_err,

  // XIF Result (coprocessor -> CPU)
  output logic        s_xif_result_valid,
  input  logic        s_xif_result_ready,
  output logic [3:0]  s_xif_result_id,
  output logic [31:0] s_xif_result_data,
  output logic [4:0]  s_xif_result_rd,
  output logic        s_xif_result_we,
  output logic        s_xif_result_exc,
  output logic [5:0]  s_xif_result_exccode
);

  import config_pkg::*;
  import axi_pkg::*;
  import ara_pkg::*;
  `include "axi/typedef.svh"
  `include "ara/intf_typedef.svh"

  localparam int unsigned AxiDataWidth = 32 * NrLanes;
  localparam int unsigned AxiAddrWidth = 64;
  localparam int unsigned AxiIdWidth   = 5;
  localparam int unsigned AxiUserWidth = 1;

  localparam config_pkg::cva6_cfg_t CVA6AraConfig = build_config_pkg::build_config(cva6_config_pkg::cva6_cfg);

  `CVA6_TYPEDEF_EXCEPTION(exception_t, CVA6AraConfig);
  `CVA6_INTF_TYPEDEF_ACC_REQ(accelerator_req_t, CVA6AraConfig, fpnew_pkg::roundmode_e);
  `CVA6_INTF_TYPEDEF_ACC_RESP(accelerator_resp_t, CVA6AraConfig, exception_t);
  `CVA6_INTF_TYPEDEF_MMU_REQ(acc_mmu_req_t, CVA6AraConfig);
  `CVA6_INTF_TYPEDEF_MMU_RESP(acc_mmu_resp_t, CVA6AraConfig, exception_t);
  `CVA6_INTF_TYPEDEF_CVA6_TO_ACC(cva6_to_acc_t, accelerator_req_t, acc_mmu_resp_t);
  `CVA6_INTF_TYPEDEF_ACC_TO_CVA6(acc_to_cva6_t, accelerator_resp_t, acc_mmu_req_t);

  typedef logic [AxiDataWidth-1:0] axi_data_t;
  typedef logic [AxiDataWidth/8-1:0] axi_strb_t;
  typedef logic [AxiAddrWidth-1:0] axi_addr_t;
  typedef logic [AxiUserWidth-1:0] axi_user_t;
  typedef logic [AxiIdWidth-1:0] axi_id_t;

  `AXI_TYPEDEF_AR_CHAN_T(ara_axi_ar_t, axi_addr_t, axi_id_t, axi_user_t)
  `AXI_TYPEDEF_R_CHAN_T(ara_axi_r_t, axi_data_t, axi_id_t, axi_user_t)
  `AXI_TYPEDEF_AW_CHAN_T(ara_axi_aw_t, axi_addr_t, axi_id_t, axi_user_t)
  `AXI_TYPEDEF_W_CHAN_T(ara_axi_w_t, axi_data_t, axi_strb_t, axi_user_t)
  `AXI_TYPEDEF_B_CHAN_T(ara_axi_b_t, axi_id_t, axi_user_t)
  `AXI_TYPEDEF_REQ_T(ara_axi_req_t, ara_axi_aw_t, ara_axi_w_t, ara_axi_ar_t)
  `AXI_TYPEDEF_RESP_T(ara_axi_resp_t, ara_axi_b_t, ara_axi_r_t)

  cva6_to_acc_t acc_req;
  acc_to_cva6_t acc_resp;
  ara_axi_req_t ara_axi_req;
  ara_axi_resp_t ara_axi_resp;

  assign s_xif_mem_valid     = 1'b0;
  assign s_xif_mem_req_id    = '0;
  assign s_xif_mem_req_addr  = '0;
  assign s_xif_mem_req_mode  = '0;
  assign s_xif_mem_req_we    = 1'b0;
  assign s_xif_mem_req_size  = '0;
  assign s_xif_mem_req_be    = '0;
  assign s_xif_mem_req_wdata = '0;
  assign s_xif_mem_req_last  = 1'b0;

  assign s_xif_issue_resp_writeback  = 1'b1;
  assign s_xif_issue_resp_dualwrite   = 1'b0;
  assign s_xif_issue_resp_dualread   = 3'b0;
  assign s_xif_issue_resp_loadstore   = 1'b0;
  assign s_xif_issue_resp_exc        = 1'b0;

  logic issue_accept;
  logic result_consumed;

  // issue_ready: ready when we are not sending this cycle, or when Ara accepts.
  // Do not use issue_ready in req_valid to avoid combinational loop.
  assign s_xif_issue_ready   = ~s_xif_issue_valid | acc_resp.acc_resp.req_ready;
  assign s_xif_issue_resp_accept = issue_accept;

  assign acc_req.acc_req.req_valid  = s_xif_issue_valid;
  assign acc_req.acc_req.insn       = s_xif_issue_req_instr;
  assign acc_req.acc_req.rs1        = {{32{1'b0}}, s_xif_issue_req_rs_0};
  assign acc_req.acc_req.rs2        = {{32{1'b0}}, s_xif_issue_req_rs_1};
  assign acc_req.acc_req.frm        = fpnew_pkg::RNE;
  assign acc_req.acc_req.trans_id   = s_xif_issue_req_id[CVA6AraConfig.TRANS_ID_BITS-1:0];
  assign acc_req.acc_req.store_pending = 1'b0;
  assign acc_req.acc_req.acc_cons_en  = 1'b0;
  assign acc_req.acc_req.inval_ready  = 1'b1;
  assign acc_req.acc_req.resp_ready    = s_xif_result_ready | ~acc_resp.acc_resp.resp_valid;
  assign acc_req.acc_mmu_en   = 1'b0;
  assign acc_req.acc_mmu_resp = '0;

  assign issue_accept = acc_req.acc_req.req_valid & acc_resp.acc_resp.req_ready;
  assign result_consumed = acc_resp.acc_resp.resp_valid & s_xif_result_ready;

  assign s_xif_result_valid   = acc_resp.acc_resp.resp_valid;
  assign s_xif_result_id     = acc_resp.acc_resp.trans_id;
  assign s_xif_result_data   = acc_resp.acc_resp.result[31:0];
  assign s_xif_result_rd     = '0;
  assign s_xif_result_we     = acc_resp.acc_resp.resp_valid;
  assign s_xif_result_exc    = acc_resp.acc_resp.exception.valid;
  assign s_xif_result_exccode = acc_resp.acc_resp.exception.cause[5:0];

  ara #(
    .NrLanes           (NrLanes),
    .VLEN              (VLEN),
    .OSSupport         (1),
    .FPUSupport        (FPUSupportHalfSingleDouble),
    .FPExtSupport      (FPExtSupportEnable),
    .FixPtSupport      (FixedPointEnable),
    .SegSupport        (SegSupportEnable),
    .CVA6Cfg           (CVA6AraConfig),
    .exception_t       (exception_t),
    .accelerator_req_t (accelerator_req_t),
    .accelerator_resp_t(accelerator_resp_t),
    .acc_mmu_req_t     (acc_mmu_req_t),
    .acc_mmu_resp_t    (acc_mmu_resp_t),
    .cva6_to_acc_t     (cva6_to_acc_t),
    .acc_to_cva6_t     (acc_to_cva6_t),
    .AxiDataWidth      (AxiDataWidth),
    .AxiAddrWidth      (AxiAddrWidth),
    .axi_ar_t          (ara_axi_ar_t),
    .axi_r_t           (ara_axi_r_t),
    .axi_aw_t          (ara_axi_aw_t),
    .axi_w_t           (ara_axi_w_t),
    .axi_b_t           (ara_axi_b_t),
    .axi_req_t         (ara_axi_req_t),
    .axi_resp_t        (ara_axi_resp_t)
  ) i_ara (
    .clk_i       (clk_i),
    .rst_ni      (rst_ni),
    .scan_enable_i(1'b0),
    .scan_data_i (1'b0),
    .scan_data_o (),
    .acc_req_i   (acc_req),
    .acc_resp_o  (acc_resp),
    .axi_req_o   (ara_axi_req),
    .axi_resp_i  (ara_axi_resp)
  );

  axi_zero_mem #(
    .axi_req_t  (ara_axi_req_t),
    .axi_resp_t (ara_axi_resp_t),
    .AddrWidth  (AxiAddrWidth),
    .DataWidth  (AxiDataWidth),
    .IdWidth    (AxiIdWidth),
    .NumBanks   (1),
    .BufDepth   (1)
  ) i_axi_zero_mem (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .busy_o    (),
    .axi_req_i (ara_axi_req),
    .axi_resp_o(ara_axi_resp)
  );

endmodule
