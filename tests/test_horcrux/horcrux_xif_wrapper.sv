// Thin wrapper: flatten CV-X-IF for cocotb; instantiate HORCRUX coproc_wrapper.
// RTL lives in ~/projects/horcrux (referenced via Makefile HORCRUX_DIR).

module horcrux_xif_wrapper (
  input  logic        clk_i,
  input  logic        rst_ni,

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

  input  logic        s_xif_commit_valid,
  input  logic [3:0]  s_xif_commit_id,
  input  logic        s_xif_commit_kill,

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

  input  logic        s_xif_mem_result_valid,
  input  logic [3:0]  s_xif_mem_result_id,
  input  logic [31:0] s_xif_mem_result_rdata,
  input  logic        s_xif_mem_result_err,

  output logic        s_xif_result_valid,
  input  logic        s_xif_result_ready,
  output logic [3:0]  s_xif_result_id,
  output logic [31:0] s_xif_result_data,
  output logic [4:0]  s_xif_result_rd,
  output logic        s_xif_result_we,
  output logic        s_xif_result_exc,
  output logic [5:0]  s_xif_result_exccode
);

  if_xif #(
    .X_NUM_RS(3)
  ) ext_if ();

  assign ext_if.issue_valid             = s_xif_issue_valid;
  assign s_xif_issue_ready              = ext_if.issue_ready;
  assign ext_if.issue_req.instr         = s_xif_issue_req_instr;
  assign ext_if.issue_req.mode          = s_xif_issue_req_mode;
  assign ext_if.issue_req.id            = s_xif_issue_req_id;
  assign ext_if.issue_req.rs[0]         = s_xif_issue_req_rs_0;
  assign ext_if.issue_req.rs[1]         = s_xif_issue_req_rs_1;
  assign ext_if.issue_req.rs[2]         = s_xif_issue_req_rs_2;
  assign ext_if.issue_req.rs_valid      = s_xif_issue_req_rs_valid;
  assign ext_if.issue_req.ecs           = '0;
  assign ext_if.issue_req.ecs_valid     = '0;
  assign s_xif_issue_resp_accept        = ext_if.issue_resp.accept;
  assign s_xif_issue_resp_writeback     = ext_if.issue_resp.writeback;
  assign s_xif_issue_resp_dualwrite     = ext_if.issue_resp.dualwrite;
  assign s_xif_issue_resp_dualread      = ext_if.issue_resp.dualread;
  assign s_xif_issue_resp_loadstore     = ext_if.issue_resp.loadstore;
  assign s_xif_issue_resp_exc           = ext_if.issue_resp.exc;

  assign ext_if.commit_valid            = s_xif_commit_valid;
  assign ext_if.commit.id               = s_xif_commit_id;
  assign ext_if.commit.commit_kill      = s_xif_commit_kill;

  assign s_xif_mem_valid                = ext_if.mem_valid;
  assign ext_if.mem_ready               = s_xif_mem_ready;
  assign s_xif_mem_req_id               = ext_if.mem_req.id;
  assign s_xif_mem_req_addr             = ext_if.mem_req.addr;
  assign s_xif_mem_req_mode             = ext_if.mem_req.mode;
  assign s_xif_mem_req_we               = ext_if.mem_req.we;
  assign s_xif_mem_req_size             = ext_if.mem_req.size;
  assign s_xif_mem_req_be               = ext_if.mem_req.be;
  assign s_xif_mem_req_wdata            = ext_if.mem_req.wdata;
  assign s_xif_mem_req_last             = ext_if.mem_req.last;
  assign ext_if.mem_resp.exc            = s_xif_mem_resp_exc;
  assign ext_if.mem_resp.exccode        = s_xif_mem_resp_exccode;

  assign ext_if.mem_result_valid        = s_xif_mem_result_valid;
  assign ext_if.mem_result.id           = s_xif_mem_result_id;
  assign ext_if.mem_result.rdata        = s_xif_mem_result_rdata;
  assign ext_if.mem_result.err          = s_xif_mem_result_err;

  assign s_xif_result_valid             = ext_if.result_valid;
  assign ext_if.result_ready            = s_xif_result_ready;
  assign s_xif_result_id                = ext_if.result.id;
  assign s_xif_result_data              = ext_if.result.data;
  assign s_xif_result_rd                = ext_if.result.rd;
  assign s_xif_result_we                = ext_if.result.we;
  assign s_xif_result_exc               = ext_if.result.exc;
  assign s_xif_result_exccode           = ext_if.result.exccode;

  assign ext_if.compressed_valid        = 1'b0;
  assign ext_if.compressed_req          = '0;

  coproc_wrapper coproc_wrapper_i (
    .clk_i              (clk_i),
    .rst_ni             (rst_ni),
    .xif_compressed_if  (ext_if.coproc_compressed),
    .xif_issue_if       (ext_if.coproc_issue),
    .xif_commit_if      (ext_if.coproc_commit),
    .xif_mem_if         (ext_if.coproc_mem),
    .xif_mem_result_if  (ext_if.coproc_mem_result),
    .xif_result_if      (ext_if.coproc_result)
  );

endmodule
