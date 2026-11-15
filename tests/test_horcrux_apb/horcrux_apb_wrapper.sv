// Copyright 2026 cocotbext-xif contributors
// SPDX-License-Identifier: MIT
//
// APB4 wrapper around the unmodified horcrux compute core.

module horcrux_apb_wrapper #(
  parameter bit EnableInstrDecode = 1'b1
) (
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic        s_apb_psel,
  input  logic        s_apb_pwrite,
  input  logic        s_apb_penable,
  input  logic [ 2:0] s_apb_pprot,
  input  logic [ 4:0] s_apb_paddr,
  input  logic [31:0] s_apb_pwdata,
  input  logic [ 3:0] s_apb_pstrb,
  output logic        s_apb_pready,
  output logic [31:0] s_apb_prdata,
  output logic        s_apb_pslverr
);

  import horcrux_pkg::*;

  logic [31:0] o_rs1_value;
  logic [31:0] o_rs2_value;
  logic [31:0] o_rs3_value;
  logic [ 6:0] o_cmd_opcode;
  logic        o_cmd_opcode_wr_swacc;
  logic [31:0] o_instr_value;
  logic        o_instr_value_wr_swacc;

  logic        cmd_issue;
  logic        instr_issue;
  logic        issue_pulse;
  horcrux_insn decoded_insn;
  logic        decoded_match;
  horcrux_insn insn_sel;

  in_t         rs_values;
  horcrux_insn insn_core;
  logic        start_keccak;
  logic        busy;
  logic        accept;
  logic        done_pulse;
  logic [31:0] rd1_value;

  out_t        rd_values;
  logic        done_keccak;
  logic        done_sphincs;

  logic [31:0] decode_instr_word;
  logic [ 6:0] cmd_opcode_sel;

  assign cmd_issue   = o_cmd_opcode_wr_swacc && s_apb_penable;
  assign instr_issue = EnableInstrDecode && o_instr_value_wr_swacc && s_apb_penable;
  assign issue_pulse = cmd_issue | instr_issue;

  // PeakRDL field storage updates on the write clock edge; sample pwdata on the
  // issue strobe so the newly written CMD/INSTR value is decoded (same as SPI
  // host FIFO push using s_apb_pwdata, not the post-write register export).
  assign decode_instr_word = instr_issue ? s_apb_pwdata : o_instr_value;
  assign cmd_opcode_sel    = cmd_issue ? s_apb_pwdata[6:0] : o_cmd_opcode;

  if (EnableInstrDecode) begin : gen_decode
    horcrux_instr_decode u_instr_decode (
      .instr_i (decode_instr_word),
      .insn_o  (decoded_insn),
      .match_o (decoded_match)
    );
    assign insn_sel = instr_issue ? decoded_insn : horcrux_insn'(cmd_opcode_sel);
  end else begin : gen_no_decode
    assign decoded_insn  = none;
    assign decoded_match = 1'b0;
    assign insn_sel      = horcrux_insn'(cmd_opcode_sel);
  end

  horcrux_regs_apb4 u_regs (
    .clk                     (clk_i),
    .arst_n                  (rst_ni),
    .s_apb_psel              (s_apb_psel),
    .s_apb_pwrite            (s_apb_pwrite),
    .s_apb_penable           (s_apb_penable),
    .s_apb_pprot             (s_apb_pprot),
    .s_apb_paddr             (s_apb_paddr),
    .s_apb_pwdata            (s_apb_pwdata),
    .s_apb_pstrb             (s_apb_pstrb),
    .s_apb_pready            (s_apb_pready),
    .s_apb_prdata            (s_apb_prdata),
    .s_apb_pslverr           (s_apb_pslverr),
    .o_rs1_value             (o_rs1_value),
    .o_rs2_value             (o_rs2_value),
    .o_rs3_value             (o_rs3_value),
    .o_cmd_opcode            (o_cmd_opcode),
    .o_cmd_opcode_wr_swacc   (o_cmd_opcode_wr_swacc),
    .o_instr_value           (o_instr_value),
    .o_instr_value_wr_swacc  (o_instr_value_wr_swacc),
    .i_status_busy           (busy),
    .i_status_done           (done_pulse),
    .i_status_accept         (accept),
    .i_rd1_value             (rd1_value)
  );

  horcrux_cmd_seq u_seq (
    .clk_i           (clk_i),
    .rst_ni          (rst_ni),
    .issue_pulse_i   (issue_pulse),
    .insn_sel_i      (insn_sel),
    .rs1_i           (o_rs1_value),
    .rs2_i           (o_rs2_value),
    .rs3_i           (o_rs3_value),
    .keccak_done_i   (done_keccak),
    .sphincs_done_i  (done_sphincs),
    .rd_values_i     (rd_values),
    .rs_values_o     (rs_values),
    .insn_o          (insn_core),
    .start_keccak_o  (start_keccak),
    .busy_o          (busy),
    .accept_o        (accept),
    .done_pulse_o    (done_pulse),
    .rd1_o           (rd1_value)
  );

  horcrux #(
    .NUM_VARIABLES  (50),
    .VARIABLE_WIDTH (32)
  ) u_horcrux (
    .clk_i           (clk_i),
    .rst_ni          (rst_ni),
    .rs_values_i     (rs_values),
    .insn_i          (insn_core),
    .start_keccak_i  (start_keccak),
    .done_keccak_o   (done_keccak),
    .done_sphincs_o  (done_sphincs),
    .rd_values_o     (rd_values)
  );

endmodule
