// Copyright 2026 cocotbext-xif contributors
// SPDX-License-Identifier: MIT
//
// Replicates id_stage issue/commit timing for the HORCRUX core without CV-X-IF.

module horcrux_cmd_seq
  import horcrux_pkg::*;
(
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic        issue_pulse_i,
  input  horcrux_insn insn_sel_i,
  input  logic [31:0] rs1_i,
  input  logic [31:0] rs2_i,
  input  logic [31:0] rs3_i,

  input  logic        keccak_done_i,
  input  logic        sphincs_done_i,
  input  out_t        rd_values_i,

  output in_t         rs_values_o,
  output horcrux_insn insn_o,
  output logic        start_keccak_o,
  output logic        busy_o,
  output logic        accept_o,
  output logic        done_pulse_o,
  output logic [31:0] rd1_o
);

  typedef enum logic [1:0] {
    IDLE,
    WAIT_KECCAK,
    WAIT_SPHINCS
  } state_e;

  state_e state_q, state_d;

  in_t         rs_values;
  horcrux_insn select_insn;
  logic        done_d;
  logic        done_q;
  logic        state_keccak_d;
  logic        state_sphincs_d;
  logic        state_keccak;
  logic        state_sphincs;

  function automatic logic is_sphincs_insn(horcrux_insn op);
    return (op == OP_THASH1) || (op == OP_THASH2) || (op == OP_PRF_ADDR) ||
           (op == OP_THASH1_192) || (op == OP_THASH2_192) ||
           (op == OP_THASH1_256) || (op == OP_THASH2_256) ||
           (op == OP_PRF_192) || (op == OP_PRF_256);
  endfunction

  function automatic logic is_keccak_wait_insn(horcrux_insn op);
    return (op == OP_KSTART) || (op == OP_KPERM);
  endfunction

  // FSM (mirrors id_stage.sv)
  always_comb begin
    state_d = state_q;

    unique case (state_q)
      IDLE: begin
        if (state_sphincs) begin
          state_d = WAIT_SPHINCS;
        end else if (state_keccak) begin
          state_d = WAIT_KECCAK;
        end else begin
          state_d = IDLE;
        end
      end

      WAIT_KECCAK: begin
        if (keccak_done_i) begin
          state_d = IDLE;
        end
      end

      WAIT_SPHINCS: begin
        if (sphincs_done_i) begin
          state_d = IDLE;
        end
      end

      default: state_d = IDLE;
    endcase
  end

  // Issue/decode side effects (mirrors id_stage.sv done_d block)
  always_comb begin
    done_d          = 1'b0;
    state_keccak_d  = 1'b0;
    state_sphincs_d = 1'b0;
    rs_values       = '0;
    select_insn     = none;

    if (issue_pulse_i) begin
      rs_values.rs1 = rs1_i;
      rs_values.rs2 = rs2_i;
      rs_values.rs3 = rs3_i;
      select_insn   = insn_sel_i;

      if (is_sphincs_insn(insn_sel_i)) begin
        state_sphincs_d = 1'b1;
      end else if (is_keccak_wait_insn(insn_sel_i)) begin
        state_keccak_d = 1'b1;
      end else begin
        done_d = 1'b1;
      end
    end
  end

  logic done_o;
  assign done_o = done_q |
                  (state_q == WAIT_SPHINCS && sphincs_done_i) |
                  (state_q == WAIT_KECCAK && keccak_done_i);

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q       <= IDLE;
      rs_values_o   <= '0;
      insn_o        <= none;
      done_q        <= 1'b0;
      state_keccak  <= 1'b0;
      state_sphincs <= 1'b0;
      rd1_o         <= '0;
    end else begin
      state_q       <= state_d;
      rs_values_o   <= rs_values;
      insn_o        <= select_insn;
      done_q        <= done_d;
      state_keccak  <= state_keccak_d;
      state_sphincs <= state_sphincs_d;

      if (done_o) begin
        rd1_o <= rd_values_i.rd1;
      end
    end
  end

  assign start_keccak_o = (insn_o == OP_KSTART) || (insn_o == OP_KPERM);
  assign busy_o         = (state_q != IDLE);
  assign accept_o       = (state_q == IDLE);
  assign done_pulse_o   = done_o;

endmodule
