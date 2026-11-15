// Copyright 2026 cocotbext-xif contributors
// SPDX-License-Identifier: MIT
//
// Optional 32-bit instruction predecoder (same CoproInstr table as id_stage).

module horcrux_instr_decode
  import horcrux_pkg::*;
(
  input  logic [31:0]       instr_i,
  output horcrux_insn       insn_o,
  output logic              match_o
);

  instruction_u instr_u;
  logic [NbInstr-1:0] sel;

  assign instr_u.raw = instr_i;

  for (genvar i = 0; i < NbInstr; i++) begin : gen_predecode
    assign sel[i] = ((CoproInstr[i].mask & instr_u.raw) == CoproInstr[i].instr);
  end

  always_comb begin
    insn_o  = none;
    match_o = 1'b0;
    for (int unsigned i = 0; i < NbInstr; i++) begin
      if (sel[i]) begin
        insn_o  = CoproInstr[i].resp.insn;
        match_o = 1'b1;
      end
    end
  end

endmodule
