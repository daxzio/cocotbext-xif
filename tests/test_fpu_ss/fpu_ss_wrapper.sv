// Wrapper for CocoTB testing: fpu_ss from tests/rtl/fpu_ss
// Exposes XIF-style interface (s_xif_*) and instantiates fpu_ss

module fpu_ss_wrapper (
  // Clock and Reset
  input  logic        clk_i,
  input  logic        rst_ni,

  // Issue Interface (CPU -> FPU SS)
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

  // Commit Interface (CPU -> FPU SS)
  input  logic        s_xif_commit_valid,
  input  logic [3:0]  s_xif_commit_id,
  input  logic        s_xif_commit_kill,

  // Memory Request Interface (FPU SS -> CPU)
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

  // Memory Result Interface (CPU -> FPU SS)
  input  logic        s_xif_mem_result_valid,
  input  logic [3:0]  s_xif_mem_result_id,
  input  logic [31:0] s_xif_mem_result_rdata,
  input  logic        s_xif_mem_result_err,

  // Result Interface (FPU SS -> CPU)
  output logic        s_xif_result_valid,
  input  logic        s_xif_result_ready,
  output logic [3:0]  s_xif_result_id,
  output logic [31:0] s_xif_result_data,
  output logic [4:0]  s_xif_result_rd,
  output logic        s_xif_result_we,
  output logic        s_xif_result_exc,
  output logic [5:0]  s_xif_result_exccode
);

  import fpu_ss_pkg::*;

  // Internal nets driven by fpu_ss (compressed outputs left unconnected)
  logic             x_compressed_ready_o;
  x_compressed_resp_t x_compressed_resp_o;
  x_issue_resp_t    x_issue_resp_o;
  logic            x_issue_ready_o;
  logic            x_mem_valid_o;
  x_mem_req_t      x_mem_req_o;
  logic            x_result_valid_o;
  x_result_t       x_result_o;

  // ----------
  // Issue
  // ----------
  assign s_xif_issue_ready              = x_issue_ready_o;
  assign s_xif_issue_resp_accept         = x_issue_resp_o.accept;
  assign s_xif_issue_resp_writeback      = x_issue_resp_o.writeback;
  assign s_xif_issue_resp_dualwrite      = x_issue_resp_o.dualwrite;
  assign s_xif_issue_resp_dualread       = x_issue_resp_o.dualread;
  assign s_xif_issue_resp_loadstore      = x_issue_resp_o.loadstore;
  assign s_xif_issue_resp_exc            = x_issue_resp_o.exc;

  // ----------
  // Memory request (FPU SS -> CPU)
  // ----------
  assign s_xif_mem_valid                 = x_mem_valid_o;
  assign s_xif_mem_req_id                = x_mem_req_o.id;
  assign s_xif_mem_req_addr              = x_mem_req_o.addr;
  assign s_xif_mem_req_mode               = x_mem_req_o.mode;
  assign s_xif_mem_req_we                 = x_mem_req_o.we;
  assign s_xif_mem_req_size               = x_mem_req_o.size;
  assign s_xif_mem_req_be                 = x_mem_req_o.be;
  assign s_xif_mem_req_wdata              = x_mem_req_o.wdata;
  assign s_xif_mem_req_last               = x_mem_req_o.last;

  // ----------
  // Memory response (CPU -> FPU SS)
  // ----------
  x_mem_resp_t x_mem_resp;
  assign x_mem_resp.exc                  = s_xif_mem_resp_exc;
  assign x_mem_resp.exccode              = s_xif_mem_resp_exccode;
  assign x_mem_resp.dbg                  = 1'b0;

  // ----------
  // Memory result (CPU -> FPU SS)
  // ----------
  x_mem_result_t x_mem_result;
  assign x_mem_result.id                 = s_xif_mem_result_id;
  assign x_mem_result.rdata              = s_xif_mem_result_rdata;
  assign x_mem_result.err                = s_xif_mem_result_err;
  assign x_mem_result.dbg                = 1'b0;

  // ----------
  // Result (FPU SS -> CPU)
  // ----------
  assign s_xif_result_valid              = x_result_valid_o;
  assign s_xif_result_id                 = x_result_o.id;
  assign s_xif_result_data               = x_result_o.data;
  assign s_xif_result_rd                 = x_result_o.rd;
  assign s_xif_result_we                 = |x_result_o.we;
  assign s_xif_result_exc                = x_result_o.exc;
  assign s_xif_result_exccode            = x_result_o.exccode;

  // ----------
  // Structs for fpu_ss (assigned by member so sv2v output has no struct literals; Icarus-friendly)
  // ----------
  x_issue_req_t x_issue_req;
  assign x_issue_req.instr     = s_xif_issue_req_instr;
  assign x_issue_req.mode      = s_xif_issue_req_mode;
  assign x_issue_req.id        = s_xif_issue_req_id;
  assign x_issue_req.rs        = {s_xif_issue_req_rs_2, s_xif_issue_req_rs_1, s_xif_issue_req_rs_0};
  assign x_issue_req.rs_valid  = s_xif_issue_req_rs_valid;
  assign x_issue_req.ecs       = 6'h0;
  assign x_issue_req.ecs_valid = 1'b0;

  x_commit_t x_commit;
  assign x_commit.id         = s_xif_commit_id;
  assign x_commit.commit_kill = s_xif_commit_kill;

  // ----------
  // fpu_ss instance
  // ----------
  fpu_ss #(
    .PULP_ZFINX         (1),
    .INPUT_BUFFER_DEPTH  (2),  // Min 2 for CV-X-IF: depth 1 causes deadlock (x_issue_ready stays 0 when FIFO full)
    .OUT_OF_ORDER        (1),
    .FORWARDING          (1),
    .PulpDivsqrt         (1'b1)
  ) fpu_ss_i (
    .clk_i                 (clk_i),
    .rst_ni                 (rst_ni),

    .x_compressed_valid_i   (1'b0),
    .x_compressed_req_i     ('0),
    .x_compressed_ready_o   (x_compressed_ready_o),
    .x_compressed_resp_o   (x_compressed_resp_o),

    .x_issue_valid_i        (s_xif_issue_valid),
    .x_issue_ready_o        (x_issue_ready_o),
    .x_issue_req_i          (x_issue_req),
    .x_issue_resp_o          (x_issue_resp_o),

    .x_commit_valid_i       (s_xif_commit_valid),
    .x_commit_i             (x_commit),

    .x_mem_valid_o           (x_mem_valid_o),
    .x_mem_ready_i           (s_xif_mem_ready),
    .x_mem_req_o             (x_mem_req_o),
    .x_mem_resp_i             (x_mem_resp),

    .x_mem_result_valid_i    (s_xif_mem_result_valid),
    .x_mem_result_i          (x_mem_result),

    .x_result_valid_o        (x_result_valid_o),
    .x_result_ready_i        (s_xif_result_ready),
    .x_result_o              (x_result_o)
  );

endmodule
