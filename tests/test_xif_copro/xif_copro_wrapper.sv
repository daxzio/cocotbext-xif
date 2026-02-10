// Wrapper for CocoTB testing
// Exposes XIF interface as individual Verilog vectors
// Connects to internal interface for coprocessor

module xif_copro_wrapper (
  // Clock and Reset
  input  logic        clk_i,
  input  logic        rst_ni,
  
  // Issue Interface (CPU -> Coprocessor)
  input  logic        s_xif_issue_valid,
  input  logic [31:0] s_xif_issue_req_instr,
  input  logic [1:0]  s_xif_issue_req_mode,
  input  logic [3:0]  s_xif_issue_req_id,
  input  logic [31:0] s_xif_issue_req_rs_0,
  input  logic [31:0] s_xif_issue_req_rs_1,
  input  logic [1:0]  s_xif_issue_req_rs_valid,
  input  logic [5:0]  s_xif_issue_req_ecs,
  input  logic        s_xif_issue_req_ecs_valid,
  output logic        s_xif_issue_ready,
  output logic        s_xif_issue_resp_accept,
  output logic        s_xif_issue_resp_writeback,
  output logic        s_xif_issue_resp_dualwrite,
  output logic [2:0]  s_xif_issue_resp_dualread,
  output logic        s_xif_issue_resp_loadstore,
  output logic        s_xif_issue_resp_exc,
  
  // Commit Interface (CPU -> Coprocessor)
  input  logic        s_xif_commit_valid,
  input  logic [3:0]  s_xif_commit_id,
  input  logic        s_xif_commit_kill,
  
  // Memory Request Interface (Coprocessor -> CPU)
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
  input  logic        s_xif_mem_resp_dbg,
  
  // Memory Result Interface (CPU -> Coprocessor)
  input  logic        s_xif_mem_result_valid,
  input  logic [3:0]  s_xif_mem_result_id,
  input  logic [31:0] s_xif_mem_result_rdata,
  input  logic        s_xif_mem_result_err,
  input  logic        s_xif_mem_result_dbg,
  
  // Result Interface (Coprocessor -> CPU)
  output logic        s_xif_result_valid,
  input  logic        s_xif_result_ready,
  output logic [3:0]  s_xif_result_id,
  output logic [31:0] s_xif_result_data,
  output logic [4:0]  s_xif_result_rd,
  output logic        s_xif_result_we,
  output logic        s_xif_result_exc,
  output logic [5:0]  s_xif_result_exccode,
  output logic        s_xif_result_dbg,
  input  logic        s_xif_compressed_valid,
  input  logic [21:0] s_xif_compressed_req
);

  // Internal XIF interface
  if_xif #() ext_if ();

  // ==========================================
  // Connect individual signals to interface
  // ==========================================
  
  // Issue Interface - CPU to Coprocessor
  assign ext_if.issue_valid             = s_xif_issue_valid;
  assign s_xif_issue_ready              = ext_if.issue_ready;
  assign ext_if.issue_req.instr         = s_xif_issue_req_instr;
  assign ext_if.issue_req.mode          = s_xif_issue_req_mode;
  assign ext_if.issue_req.id            = s_xif_issue_req_id;
  assign ext_if.issue_req.rs[0]         = s_xif_issue_req_rs_0;
  assign ext_if.issue_req.rs[1]         = s_xif_issue_req_rs_1;
  assign ext_if.issue_req.rs_valid      = s_xif_issue_req_rs_valid;
  assign ext_if.issue_req.ecs           = s_xif_issue_req_ecs;
  assign ext_if.issue_req.ecs_valid     = s_xif_issue_req_ecs_valid;
  assign s_xif_issue_resp_accept        = ext_if.issue_resp.accept;
  assign s_xif_issue_resp_writeback     = ext_if.issue_resp.writeback;
  assign s_xif_issue_resp_dualwrite     = ext_if.issue_resp.dualwrite;
  assign s_xif_issue_resp_dualread      = ext_if.issue_resp.dualread;
  assign s_xif_issue_resp_loadstore     = ext_if.issue_resp.loadstore;
  assign s_xif_issue_resp_exc           = ext_if.issue_resp.exc;
  
  // Commit Interface - CPU to Coprocessor
  assign ext_if.commit_valid            = s_xif_commit_valid;
  assign ext_if.commit.id               = s_xif_commit_id;
  assign ext_if.commit.commit_kill      = s_xif_commit_kill;
  
  // Memory Request Interface - Coprocessor to CPU
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
  assign ext_if.mem_resp.dbg            = s_xif_mem_resp_dbg;
  
  // Memory Result Interface - CPU to Coprocessor
  assign ext_if.mem_result_valid        = s_xif_mem_result_valid;
  assign ext_if.mem_result.id           = s_xif_mem_result_id;
  assign ext_if.mem_result.rdata        = s_xif_mem_result_rdata;
  assign ext_if.mem_result.err          = s_xif_mem_result_err;
  assign ext_if.mem_result.dbg          = s_xif_mem_result_dbg;
  
  // Result Interface - Coprocessor to CPU
  assign s_xif_result_valid             = ext_if.result_valid;
  assign ext_if.result_ready            = s_xif_result_ready;
  assign s_xif_result_id                = ext_if.result.id;
  assign s_xif_result_data              = ext_if.result.data;
  assign s_xif_result_rd                = ext_if.result.rd;
  assign s_xif_result_we                = ext_if.result.we;
  assign s_xif_result_exc               = ext_if.result.exc;
  assign s_xif_result_exccode           = ext_if.result.exccode;
  
  // Tie off unused compressed interface
  assign ext_if.compressed_valid        = s_xif_compressed_valid;
  assign ext_if.compressed_req          = s_xif_compressed_req;

  // ==========================================
  // Instantiate Coprocessor
  // ==========================================
  
  xif_copro #(
    .INPUT_BUFFER_DEPTH(1),
    .FORWARDING(1)
  ) xif_copro_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .xif_compressed_if(ext_if.coproc_compressed),
    .xif_issue_if(ext_if.coproc_issue),
    .xif_commit_if(ext_if.coproc_commit),
    .xif_mem_if(ext_if.coproc_mem),
    .xif_mem_result_if(ext_if.coproc_mem_result),
    .xif_result_if(ext_if.coproc_result)
  );

endmodule
