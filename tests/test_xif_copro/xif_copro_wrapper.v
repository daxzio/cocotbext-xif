module fifo_v3_3D767_B7BA8 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	full_o,
	empty_o,
	usage_o,
	data_i,
	push_i,
	data_o,
	pop_i
);
	parameter signed [31:0] dtype_T_xif_copro_pkg_XLEN = 0;
	parameter signed [31:0] dtype_T_xif_copro_pkg_X_ID_WIDTH = 0;
	parameter signed [31:0] dtype_T_xif_copro_pkg_X_RFW_WIDTH = 0;
	reg _sv2v_0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire full_o;
	output wire empty_o;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [(((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17:0] data_i;
	input wire push_i;
	output reg [(((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17:0] data_o;
	input wire pop_i;
	localparam [31:0] FifoDepth = (DEPTH > 0 ? DEPTH : 1);
	reg gate_clock;
	reg [ADDR_DEPTH - 1:0] read_pointer_n;
	reg [ADDR_DEPTH - 1:0] read_pointer_q;
	reg [ADDR_DEPTH - 1:0] write_pointer_n;
	reg [ADDR_DEPTH - 1:0] write_pointer_q;
	reg [ADDR_DEPTH:0] status_cnt_n;
	reg [ADDR_DEPTH:0] status_cnt_q;
	reg [(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? (FifoDepth * ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 18)) - 1 : (FifoDepth * (1 - ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17))) + ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 16)):(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17)] mem_n;
	reg [(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? (FifoDepth * ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 18)) - 1 : (FifoDepth * (1 - ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17))) + ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 16)):(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17)] mem_q;
	assign usage_o = status_cnt_q[ADDR_DEPTH - 1:0];
	generate
		if (DEPTH == 0) begin : gen_pass_through
			assign empty_o = ~push_i;
			assign full_o = ~pop_i;
		end
		else begin : gen_fifo
			assign full_o = status_cnt_q == FifoDepth[ADDR_DEPTH:0];
			assign empty_o = (status_cnt_q == 0) & ~(FALL_THROUGH & push_i);
		end
	endgenerate
	always @(*) begin : read_write_comb
		if (_sv2v_0)
			;
		read_pointer_n = read_pointer_q;
		write_pointer_n = write_pointer_q;
		status_cnt_n = status_cnt_q;
		data_o = (DEPTH == 0 ? data_i : mem_q[(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) + (read_pointer_q * (((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 18 : 1 - ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17)))+:(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 18 : 1 - ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17))]);
		mem_n = mem_q;
		gate_clock = 1'b1;
		if (push_i && ~full_o) begin
			mem_n[(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) + (write_pointer_q * (((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 18 : 1 - ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17)))+:(((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17) >= 0 ? (((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 18 : 1 - ((((dtype_T_xif_copro_pkg_X_ID_WIDTH + dtype_T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (dtype_T_xif_copro_pkg_X_RFW_WIDTH / dtype_T_xif_copro_pkg_XLEN)) + 17))] = data_i;
			gate_clock = 1'b0;
			if (write_pointer_q == (FifoDepth[ADDR_DEPTH - 1:0] - 1))
				write_pointer_n = 1'sb0;
			else
				write_pointer_n = write_pointer_q + 1;
			status_cnt_n = status_cnt_q + 1;
		end
		if (pop_i && ~empty_o) begin
			if (read_pointer_n == (FifoDepth[ADDR_DEPTH - 1:0] - 1))
				read_pointer_n = 1'sb0;
			else
				read_pointer_n = read_pointer_q + 1;
			status_cnt_n = status_cnt_q - 1;
		end
		if (((push_i && pop_i) && ~full_o) && ~empty_o)
			status_cnt_n = status_cnt_q;
		if ((FALL_THROUGH && (status_cnt_q == 0)) && push_i) begin
			data_o = data_i;
			if (pop_i) begin
				status_cnt_n = status_cnt_q;
				read_pointer_n = read_pointer_q;
				write_pointer_n = write_pointer_q;
			end
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni) begin
			read_pointer_q <= 1'sb0;
			write_pointer_q <= 1'sb0;
			status_cnt_q <= 1'sb0;
		end
		else if (flush_i) begin
			read_pointer_q <= 1'sb0;
			write_pointer_q <= 1'sb0;
			status_cnt_q <= 1'sb0;
		end
		else begin
			read_pointer_q <= read_pointer_n;
			write_pointer_q <= write_pointer_n;
			status_cnt_q <= status_cnt_n;
		end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni)
			mem_q <= 1'sb0;
		else if (!gate_clock)
			mem_q <= mem_n;
	initial _sv2v_0 = 0;
endmodule
module fifo_v3_B168A_14964 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	full_o,
	empty_o,
	usage_o,
	data_i,
	push_i,
	data_o,
	pop_i
);
	parameter signed [31:0] dtype_T_xif_copro_pkg_X_ID_WIDTH = 0;
	parameter signed [31:0] dtype_T_xif_copro_pkg_X_NUM_RS = 0;
	parameter signed [31:0] dtype_T_xif_copro_pkg_X_RFR_WIDTH = 0;
	reg _sv2v_0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire full_o;
	output wire empty_o;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [(((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1:0] data_i;
	input wire push_i;
	output reg [(((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1:0] data_o;
	input wire pop_i;
	localparam [31:0] FifoDepth = (DEPTH > 0 ? DEPTH : 1);
	reg gate_clock;
	reg [ADDR_DEPTH - 1:0] read_pointer_n;
	reg [ADDR_DEPTH - 1:0] read_pointer_q;
	reg [ADDR_DEPTH - 1:0] write_pointer_n;
	reg [ADDR_DEPTH - 1:0] write_pointer_q;
	reg [ADDR_DEPTH:0] status_cnt_n;
	reg [ADDR_DEPTH:0] status_cnt_q;
	reg [(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? (FifoDepth * ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 2)) - 1 : (FifoDepth * (1 - ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1))) + ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 0)):(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1)] mem_n;
	reg [(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? (FifoDepth * ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 2)) - 1 : (FifoDepth * (1 - ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1))) + ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 0)):(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1)] mem_q;
	assign usage_o = status_cnt_q[ADDR_DEPTH - 1:0];
	generate
		if (DEPTH == 0) begin : gen_pass_through
			assign empty_o = ~push_i;
			assign full_o = ~pop_i;
		end
		else begin : gen_fifo
			assign full_o = status_cnt_q == FifoDepth[ADDR_DEPTH:0];
			assign empty_o = (status_cnt_q == 0) & ~(FALL_THROUGH & push_i);
		end
	endgenerate
	always @(*) begin : read_write_comb
		if (_sv2v_0)
			;
		read_pointer_n = read_pointer_q;
		write_pointer_n = write_pointer_q;
		status_cnt_n = status_cnt_q;
		data_o = (DEPTH == 0 ? data_i : mem_q[(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) + (read_pointer_q * (((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 2 : 1 - ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1)))+:(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 2 : 1 - ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1))]);
		mem_n = mem_q;
		gate_clock = 1'b1;
		if (push_i && ~full_o) begin
			mem_n[(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? 0 : (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) + (write_pointer_q * (((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 2 : 1 - ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1)))+:(((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1) >= 0 ? (((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 2 : 1 - ((((dtype_T_xif_copro_pkg_X_NUM_RS * dtype_T_xif_copro_pkg_X_RFR_WIDTH) + 32) + dtype_T_xif_copro_pkg_X_ID_WIDTH) + 1))] = data_i;
			gate_clock = 1'b0;
			if (write_pointer_q == (FifoDepth[ADDR_DEPTH - 1:0] - 1))
				write_pointer_n = 1'sb0;
			else
				write_pointer_n = write_pointer_q + 1;
			status_cnt_n = status_cnt_q + 1;
		end
		if (pop_i && ~empty_o) begin
			if (read_pointer_n == (FifoDepth[ADDR_DEPTH - 1:0] - 1))
				read_pointer_n = 1'sb0;
			else
				read_pointer_n = read_pointer_q + 1;
			status_cnt_n = status_cnt_q - 1;
		end
		if (((push_i && pop_i) && ~full_o) && ~empty_o)
			status_cnt_n = status_cnt_q;
		if ((FALL_THROUGH && (status_cnt_q == 0)) && push_i) begin
			data_o = data_i;
			if (pop_i) begin
				status_cnt_n = status_cnt_q;
				read_pointer_n = read_pointer_q;
				write_pointer_n = write_pointer_q;
			end
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni) begin
			read_pointer_q <= 1'sb0;
			write_pointer_q <= 1'sb0;
			status_cnt_q <= 1'sb0;
		end
		else if (flush_i) begin
			read_pointer_q <= 1'sb0;
			write_pointer_q <= 1'sb0;
			status_cnt_q <= 1'sb0;
		end
		else begin
			read_pointer_q <= read_pointer_n;
			write_pointer_q <= write_pointer_n;
			status_cnt_q <= status_cnt_n;
		end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni)
			mem_q <= 1'sb0;
		else if (!gate_clock)
			mem_q <= mem_n;
	initial _sv2v_0 = 0;
endmodule
module fifo_v3_E08E6_DF286 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	full_o,
	empty_o,
	usage_o,
	data_i,
	push_i,
	data_o,
	pop_i
);
	parameter signed [31:0] dtype_T_xif_copro_pkg_X_ID_WIDTH = 0;
	reg _sv2v_0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire full_o;
	output wire empty_o;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [dtype_T_xif_copro_pkg_X_ID_WIDTH + 13:0] data_i;
	input wire push_i;
	output reg [dtype_T_xif_copro_pkg_X_ID_WIDTH + 13:0] data_o;
	input wire pop_i;
	localparam [31:0] FifoDepth = (DEPTH > 0 ? DEPTH : 1);
	reg gate_clock;
	reg [ADDR_DEPTH - 1:0] read_pointer_n;
	reg [ADDR_DEPTH - 1:0] read_pointer_q;
	reg [ADDR_DEPTH - 1:0] write_pointer_n;
	reg [ADDR_DEPTH - 1:0] write_pointer_q;
	reg [ADDR_DEPTH:0] status_cnt_n;
	reg [ADDR_DEPTH:0] status_cnt_q;
	reg [((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? (FifoDepth * (dtype_T_xif_copro_pkg_X_ID_WIDTH + 14)) - 1 : (FifoDepth * (1 - (dtype_T_xif_copro_pkg_X_ID_WIDTH + 13))) + (dtype_T_xif_copro_pkg_X_ID_WIDTH + 12)):((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? 0 : dtype_T_xif_copro_pkg_X_ID_WIDTH + 13)] mem_n;
	reg [((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? (FifoDepth * (dtype_T_xif_copro_pkg_X_ID_WIDTH + 14)) - 1 : (FifoDepth * (1 - (dtype_T_xif_copro_pkg_X_ID_WIDTH + 13))) + (dtype_T_xif_copro_pkg_X_ID_WIDTH + 12)):((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? 0 : dtype_T_xif_copro_pkg_X_ID_WIDTH + 13)] mem_q;
	assign usage_o = status_cnt_q[ADDR_DEPTH - 1:0];
	generate
		if (DEPTH == 0) begin : gen_pass_through
			assign empty_o = ~push_i;
			assign full_o = ~pop_i;
		end
		else begin : gen_fifo
			assign full_o = status_cnt_q == FifoDepth[ADDR_DEPTH:0];
			assign empty_o = (status_cnt_q == 0) & ~(FALL_THROUGH & push_i);
		end
	endgenerate
	always @(*) begin : read_write_comb
		if (_sv2v_0)
			;
		read_pointer_n = read_pointer_q;
		write_pointer_n = write_pointer_q;
		status_cnt_n = status_cnt_q;
		data_o = (DEPTH == 0 ? data_i : mem_q[((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? 0 : dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) + (read_pointer_q * ((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? dtype_T_xif_copro_pkg_X_ID_WIDTH + 14 : 1 - (dtype_T_xif_copro_pkg_X_ID_WIDTH + 13)))+:((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? dtype_T_xif_copro_pkg_X_ID_WIDTH + 14 : 1 - (dtype_T_xif_copro_pkg_X_ID_WIDTH + 13))]);
		mem_n = mem_q;
		gate_clock = 1'b1;
		if (push_i && ~full_o) begin
			mem_n[((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? 0 : dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) + (write_pointer_q * ((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? dtype_T_xif_copro_pkg_X_ID_WIDTH + 14 : 1 - (dtype_T_xif_copro_pkg_X_ID_WIDTH + 13)))+:((dtype_T_xif_copro_pkg_X_ID_WIDTH + 13) >= 0 ? dtype_T_xif_copro_pkg_X_ID_WIDTH + 14 : 1 - (dtype_T_xif_copro_pkg_X_ID_WIDTH + 13))] = data_i;
			gate_clock = 1'b0;
			if (write_pointer_q == (FifoDepth[ADDR_DEPTH - 1:0] - 1))
				write_pointer_n = 1'sb0;
			else
				write_pointer_n = write_pointer_q + 1;
			status_cnt_n = status_cnt_q + 1;
		end
		if (pop_i && ~empty_o) begin
			if (read_pointer_n == (FifoDepth[ADDR_DEPTH - 1:0] - 1))
				read_pointer_n = 1'sb0;
			else
				read_pointer_n = read_pointer_q + 1;
			status_cnt_n = status_cnt_q - 1;
		end
		if (((push_i && pop_i) && ~full_o) && ~empty_o)
			status_cnt_n = status_cnt_q;
		if ((FALL_THROUGH && (status_cnt_q == 0)) && push_i) begin
			data_o = data_i;
			if (pop_i) begin
				status_cnt_n = status_cnt_q;
				read_pointer_n = read_pointer_q;
				write_pointer_n = write_pointer_q;
			end
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni) begin
			read_pointer_q <= 1'sb0;
			write_pointer_q <= 1'sb0;
			status_cnt_q <= 1'sb0;
		end
		else if (flush_i) begin
			read_pointer_q <= 1'sb0;
			write_pointer_q <= 1'sb0;
			status_cnt_q <= 1'sb0;
		end
		else begin
			read_pointer_q <= read_pointer_n;
			write_pointer_q <= write_pointer_n;
			status_cnt_q <= status_cnt_n;
		end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni)
			mem_q <= 1'sb0;
		else if (!gate_clock)
			mem_q <= mem_n;
	initial _sv2v_0 = 0;
endmodule
module stream_fifo_472C7_6FB59 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	usage_o,
	data_i,
	valid_i,
	ready_o,
	data_o,
	valid_o,
	ready_i
);
	parameter signed [31:0] T_xif_copro_pkg_X_ID_WIDTH = 0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [T_xif_copro_pkg_X_ID_WIDTH + 13:0] data_i;
	input wire valid_i;
	output wire ready_o;
	output wire [T_xif_copro_pkg_X_ID_WIDTH + 13:0] data_o;
	output wire valid_o;
	input wire ready_i;
	wire push;
	wire pop;
	wire empty;
	wire full;
	assign push = valid_i & ~full;
	assign pop = ready_i & ~empty;
	assign ready_o = ~full;
	assign valid_o = ~empty;
	fifo_v3_E08E6_DF286 #(
		.dtype_T_xif_copro_pkg_X_ID_WIDTH(T_xif_copro_pkg_X_ID_WIDTH),
		.FALL_THROUGH(FALL_THROUGH),
		.DATA_WIDTH(DATA_WIDTH),
		.DEPTH(DEPTH)
	) fifo_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(flush_i),
		.testmode_i(testmode_i),
		.full_o(full),
		.empty_o(empty),
		.usage_o(usage_o),
		.data_i(data_i),
		.push_i(push),
		.data_o(data_o),
		.pop_i(pop)
	);
endmodule
module stream_fifo_CA27F_66AA4 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	usage_o,
	data_i,
	valid_i,
	ready_o,
	data_o,
	valid_o,
	ready_i
);
	parameter signed [31:0] T_xif_copro_pkg_XLEN = 0;
	parameter signed [31:0] T_xif_copro_pkg_X_ID_WIDTH = 0;
	parameter signed [31:0] T_xif_copro_pkg_X_RFW_WIDTH = 0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [(((T_xif_copro_pkg_X_ID_WIDTH + T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (T_xif_copro_pkg_X_RFW_WIDTH / T_xif_copro_pkg_XLEN)) + 17:0] data_i;
	input wire valid_i;
	output wire ready_o;
	output wire [(((T_xif_copro_pkg_X_ID_WIDTH + T_xif_copro_pkg_X_RFW_WIDTH) + 5) + (T_xif_copro_pkg_X_RFW_WIDTH / T_xif_copro_pkg_XLEN)) + 17:0] data_o;
	output wire valid_o;
	input wire ready_i;
	wire push;
	wire pop;
	wire empty;
	wire full;
	assign push = valid_i & ~full;
	assign pop = ready_i & ~empty;
	assign ready_o = ~full;
	assign valid_o = ~empty;
	fifo_v3_3D767_B7BA8 #(
		.dtype_T_xif_copro_pkg_XLEN(T_xif_copro_pkg_XLEN),
		.dtype_T_xif_copro_pkg_X_ID_WIDTH(T_xif_copro_pkg_X_ID_WIDTH),
		.dtype_T_xif_copro_pkg_X_RFW_WIDTH(T_xif_copro_pkg_X_RFW_WIDTH),
		.FALL_THROUGH(FALL_THROUGH),
		.DATA_WIDTH(DATA_WIDTH),
		.DEPTH(DEPTH)
	) fifo_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(flush_i),
		.testmode_i(testmode_i),
		.full_o(full),
		.empty_o(empty),
		.usage_o(usage_o),
		.data_i(data_i),
		.push_i(push),
		.data_o(data_o),
		.pop_i(pop)
	);
endmodule
module stream_fifo_EEB9B_DFA55 (
	clk_i,
	rst_ni,
	flush_i,
	testmode_i,
	usage_o,
	data_i,
	valid_i,
	ready_o,
	data_o,
	valid_o,
	ready_i
);
	parameter signed [31:0] T_xif_copro_pkg_X_ID_WIDTH = 0;
	parameter signed [31:0] T_xif_copro_pkg_X_NUM_RS = 0;
	parameter signed [31:0] T_xif_copro_pkg_X_RFR_WIDTH = 0;
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [(((T_xif_copro_pkg_X_NUM_RS * T_xif_copro_pkg_X_RFR_WIDTH) + 32) + T_xif_copro_pkg_X_ID_WIDTH) + 1:0] data_i;
	input wire valid_i;
	output wire ready_o;
	output wire [(((T_xif_copro_pkg_X_NUM_RS * T_xif_copro_pkg_X_RFR_WIDTH) + 32) + T_xif_copro_pkg_X_ID_WIDTH) + 1:0] data_o;
	output wire valid_o;
	input wire ready_i;
	wire push;
	wire pop;
	wire empty;
	wire full;
	assign push = valid_i & ~full;
	assign pop = ready_i & ~empty;
	assign ready_o = ~full;
	assign valid_o = ~empty;
	fifo_v3_B168A_14964 #(
		.dtype_T_xif_copro_pkg_X_ID_WIDTH(T_xif_copro_pkg_X_ID_WIDTH),
		.dtype_T_xif_copro_pkg_X_NUM_RS(T_xif_copro_pkg_X_NUM_RS),
		.dtype_T_xif_copro_pkg_X_RFR_WIDTH(T_xif_copro_pkg_X_RFR_WIDTH),
		.FALL_THROUGH(FALL_THROUGH),
		.DATA_WIDTH(DATA_WIDTH),
		.DEPTH(DEPTH)
	) fifo_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(flush_i),
		.testmode_i(testmode_i),
		.full_o(full),
		.empty_o(empty),
		.usage_o(usage_o),
		.data_i(data_i),
		.push_i(push),
		.data_o(data_o),
		.pop_i(pop)
	);
endmodule
module xif_copro_decoder (
	instr_i,
	decoder_o
);
	reg _sv2v_0;
	input wire [31:0] instr_i;
	localparam signed [31:0] xif_copro_pkg_X_NUM_RS = 2;
	localparam [31:0] xif_copro_pkg_NUM_COPRO_OPERATIONS = 2;
	localparam [31:0] xif_copro_pkg_COPRO_OPERATION_BITS = 1;
	output reg [8:0] decoder_o;
	localparam [31:0] xif_copro_instr_pkg_BITREV = 32'b0000010zzzzzzzzzz111zzzzz0101011;
	function automatic [0:0] sv2v_cast_B7EFA;
		input reg [0:0] inp;
		sv2v_cast_B7EFA = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		decoder_o[8-:1] = sv2v_cast_B7EFA(0);
		decoder_o[2] = 1'b1;
		decoder_o[4+:2] = 2'd0;
		decoder_o[6+:2] = 2'd0;
		decoder_o[1] = 1'b0;
		decoder_o[0] = 1'b0;
		decoder_o[3] = 1'b0;
		(* full_case, parallel_case *)
		casez (instr_i)
			xif_copro_instr_pkg_BITREV: begin
				decoder_o[8-:1] = sv2v_cast_B7EFA(1);
				decoder_o[4+:2] = 2'd3;
			end
			default: decoder_o[2] = 1'b0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module xif_copro_ex_stage_099A7_F3EC5 (
	clk_i,
	rst_ni,
	operand_a_i,
	operand_b_i,
	operator_i,
	tag_i,
	in_valid_i,
	in_ready_o,
	out_valid_o,
	out_ready_i,
	tag_o,
	result_o
);
	parameter signed [31:0] tag_t_xif_copro_pkg_X_ID_WIDTH = 0;
	reg _sv2v_0;
	parameter [31:0] XLEN = 64;
	input wire clk_i;
	input wire rst_ni;
	input wire [XLEN - 1:0] operand_a_i;
	input wire [XLEN - 1:0] operand_b_i;
	localparam [31:0] xif_copro_pkg_NUM_COPRO_OPERATIONS = 2;
	localparam [31:0] xif_copro_pkg_COPRO_OPERATION_BITS = 1;
	input wire [0:0] operator_i;
	input wire [tag_t_xif_copro_pkg_X_ID_WIDTH + 5:0] tag_i;
	input wire in_valid_i;
	output wire in_ready_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output reg [tag_t_xif_copro_pkg_X_ID_WIDTH + 5:0] tag_o;
	output reg [XLEN - 1:0] result_o;
	reg [XLEN - 1:0] bitrev_result;
	reg [XLEN - 1:0] operand_a;
	reg [XLEN - 1:0] operand_b;
	reg [0:0] operator;
	wire input_hs;
	wire output_hs;
	assign input_hs = in_valid_i & in_ready_o;
	assign output_hs = out_valid_o & out_ready_i;
	function automatic [0:0] sv2v_cast_B7EFA;
		input reg [0:0] inp;
		sv2v_cast_B7EFA = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		case (operator)
			sv2v_cast_B7EFA(1): begin
				bitrev_result = 1'sb0;
				begin : sv2v_autoblock_1
					reg signed [31:0] i;
					for (i = 0; i < XLEN; i = i + 1)
						bitrev_result[i] = operand_a[(XLEN - 1) - i];
				end
			end
			default: bitrev_result = 1'sb0;
		endcase
	end
	always @(*) begin : result_mux
		if (_sv2v_0)
			;
		result_o = 1'sb0;
		(* full_case, parallel_case *)
		case (operator)
			sv2v_cast_B7EFA(1): result_o = bitrev_result;
			default:
				;
		endcase
	end
	reg instr_in_flight;
	reg [3:0] latency_d;
	reg [3:0] latency_q;
	always @(posedge clk_i or negedge rst_ni) begin : instr_in_flight_reg
		if (~rst_ni)
			instr_in_flight <= 1'b0;
		else if (input_hs)
			instr_in_flight <= 1'b1;
		else if (output_hs)
			instr_in_flight <= 1'b0;
	end
	assign in_ready_o = ~instr_in_flight | output_hs;
	assign out_valid_o = instr_in_flight & (latency_q == 0);
	always @(posedge clk_i or negedge rst_ni) begin : input_reg
		if (~rst_ni) begin
			operand_a <= 1'sb0;
			operand_b <= 1'sb0;
			operator <= sv2v_cast_B7EFA(0);
			tag_o <= 1'sb0;
		end
		else if (input_hs) begin
			operand_a <= operand_a_i;
			operand_b <= operand_b_i;
			operator <= operator_i;
			tag_o <= tag_i;
		end
		else if (output_hs) begin
			operand_a <= 1'sb0;
			operand_b <= 1'sb0;
			operator <= sv2v_cast_B7EFA(0);
			tag_o <= 1'sb0;
		end
	end
	always @(*) begin : set_latency
		if (_sv2v_0)
			;
		latency_d = 4'b0000;
		case (operator)
			sv2v_cast_B7EFA(1): latency_d = 4'b0000;
			default:
				;
		endcase
	end
	always @(posedge clk_i or negedge rst_ni) begin : latency_reg
		if (~rst_ni)
			latency_q <= 0;
		else if (input_hs)
			latency_q <= latency_d;
		else if (latency_q > 0)
			latency_q <= latency_q - 1;
	end
	initial _sv2v_0 = 0;
endmodule
module xif_copro_predecoder (
	prd_req_i,
	prd_rsp_o
);
	reg _sv2v_0;
	input wire [31:0] prd_req_i;
	localparam signed [31:0] xif_copro_pkg_X_NUM_RS = 2;
	output reg [4:0] prd_rsp_o;
	localparam [31:0] xif_copro_predecoder_pkg_NUM_INSTR = 1;
	wire [4:0] instr_rsp;
	wire [0:0] instr_sel;
	genvar _gv_i_1;
	function automatic [1:0] sv2v_cast_8E8B9;
		input reg [1:0] inp;
		sv2v_cast_8E8B9 = inp;
	endfunction
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	localparam [68:0] xif_copro_predecoder_pkg_OFFLOAD_INSTR = {64'b0000010000000000011100000010101111111110000000000111000001111111, sv2v_cast_5({3'b100, sv2v_cast_8E8B9(2'b01)})};
	generate
		for (_gv_i_1 = 0; _gv_i_1 < xif_copro_predecoder_pkg_NUM_INSTR; _gv_i_1 = _gv_i_1 + 1) begin : gen_predecoder_selector
			localparam i = _gv_i_1;
			assign instr_sel[i] = (xif_copro_predecoder_pkg_OFFLOAD_INSTR[(i * 69) + 36-:32] & prd_req_i[31-:32]) == xif_copro_predecoder_pkg_OFFLOAD_INSTR[(i * 69) + 68-:32];
		end
	endgenerate
	genvar _gv_i_2;
	generate
		for (_gv_i_2 = 0; _gv_i_2 < xif_copro_predecoder_pkg_NUM_INSTR; _gv_i_2 = _gv_i_2 + 1) begin : gen_predecoder_mux
			localparam i = _gv_i_2;
			assign instr_rsp[(i * 5) + 4] = (instr_sel[i] ? xif_copro_predecoder_pkg_OFFLOAD_INSTR[(i * 69) + 4] : 1'b0);
			assign instr_rsp[(i * 5) + 2] = (instr_sel[i] ? xif_copro_predecoder_pkg_OFFLOAD_INSTR[(i * 69) + 2] : 1'b0);
			assign instr_rsp[(i * 5) + 3] = (instr_sel[i] ? xif_copro_predecoder_pkg_OFFLOAD_INSTR[(i * 69) + 3] : 1'b0);
			assign instr_rsp[(i * 5) + 1-:xif_copro_pkg_X_NUM_RS] = (instr_sel[i] ? xif_copro_predecoder_pkg_OFFLOAD_INSTR[(i * 69) + 1-:xif_copro_pkg_X_NUM_RS] : {2 {1'sb0}});
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		prd_rsp_o[4] = 1'b0;
		prd_rsp_o[2] = 1'b0;
		prd_rsp_o[3] = 1'sb0;
		prd_rsp_o[1-:xif_copro_pkg_X_NUM_RS] = 1'sb0;
		begin : sv2v_autoblock_1
			reg [31:0] i;
			for (i = 0; i < xif_copro_predecoder_pkg_NUM_INSTR; i = i + 1)
				begin
					prd_rsp_o[4] = prd_rsp_o[4] | instr_rsp[(i * 5) + 4];
					prd_rsp_o[2] = prd_rsp_o[2] | instr_rsp[(i * 5) + 2];
					prd_rsp_o[3] = prd_rsp_o[3] | instr_rsp[(i * 5) + 3];
					prd_rsp_o[1-:xif_copro_pkg_X_NUM_RS] = prd_rsp_o[1-:xif_copro_pkg_X_NUM_RS] | instr_rsp[(i * 5) + 1-:xif_copro_pkg_X_NUM_RS];
				end
		end
	end
	initial _sv2v_0 = 0;
endmodule
module xif_copro_regfile (
	clk_i,
	rst_ni,
	raddr_i,
	rdata_o,
	waddr_i,
	wdata_i,
	we_i
);
	reg _sv2v_0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] NR_READ_PORTS = 2;
	parameter [31:0] NR_WRITE_PORTS = 1;
	input wire clk_i;
	input wire rst_ni;
	input wire [(NR_READ_PORTS * 5) - 1:0] raddr_i;
	output wire [(NR_READ_PORTS * DATA_WIDTH) - 1:0] rdata_o;
	input wire [(NR_WRITE_PORTS * 5) - 1:0] waddr_i;
	input wire [(NR_WRITE_PORTS * DATA_WIDTH) - 1:0] wdata_i;
	input wire [NR_WRITE_PORTS - 1:0] we_i;
	localparam ADDR_WIDTH = 5;
	localparam NUM_WORDS = 32;
	reg [(32 * DATA_WIDTH) - 1:0] mem;
	reg [(NR_WRITE_PORTS * 32) - 1:0] we_dec;
	always @(*) begin : we_decoder
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg [31:0] j;
			for (j = 0; j < NR_WRITE_PORTS; j = j + 1)
				begin : sv2v_autoblock_2
					reg [31:0] i;
					for (i = 0; i < NUM_WORDS; i = i + 1)
						if (waddr_i[j * 5+:5] == i)
							we_dec[(j * 32) + i] = we_i[j];
						else
							we_dec[(j * 32) + i] = 1'b0;
				end
		end
	end
	function automatic [DATA_WIDTH - 1:0] sv2v_cast_C274E;
		input reg [DATA_WIDTH - 1:0] inp;
		sv2v_cast_C274E = inp;
	endfunction
	always @(posedge clk_i or negedge rst_ni) begin : register_write_behavioral
		if (~rst_ni)
			mem <= {NUM_WORDS {sv2v_cast_C274E(1'sb0)}};
		else begin : sv2v_autoblock_3
			reg [31:0] j;
			for (j = 0; j < NR_WRITE_PORTS; j = j + 1)
				begin : sv2v_autoblock_4
					reg [31:0] i;
					for (i = 0; i < NUM_WORDS; i = i + 1)
						if (we_dec[(j * 32) + i])
							mem[i * DATA_WIDTH+:DATA_WIDTH] <= wdata_i[j * DATA_WIDTH+:DATA_WIDTH];
				end
		end
	end
	genvar _gv_i_3;
	generate
		for (_gv_i_3 = 0; _gv_i_3 < NR_READ_PORTS; _gv_i_3 = _gv_i_3 + 1) begin : gen_read_port
			localparam i = _gv_i_3;
			assign rdata_o[i * DATA_WIDTH+:DATA_WIDTH] = mem[raddr_i[i * 5+:5] * DATA_WIDTH+:DATA_WIDTH];
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
module xif_copro_wrapper (
	clk_i,
	rst_ni,
	s_xif_issue_valid,
	s_xif_issue_req_instr,
	s_xif_issue_req_mode,
	s_xif_issue_req_id,
	s_xif_issue_req_rs_0,
	s_xif_issue_req_rs_1,
	s_xif_issue_req_rs_valid,
	s_xif_issue_ready,
	s_xif_issue_resp_accept,
	s_xif_issue_resp_writeback,
	s_xif_issue_resp_dualwrite,
	s_xif_issue_resp_dualread,
	s_xif_issue_resp_loadstore,
	s_xif_issue_resp_exc,
	z_xif_issue_valid,
	z_xif_issue_ready,
	z_xif_issue_req_instr,
	z_xif_issue_req_mode,
	z_xif_issue_req_id,
	z_xif_issue_req_rs_0,
	z_xif_issue_req_rs_1,
	z_xif_issue_req_rs_valid,
	z_xif_issue_resp_accept,
	z_xif_issue_resp_writeback,
	z_xif_issue_resp_dualwrite,
	z_xif_issue_resp_dualread,
	z_xif_issue_resp_loadstore,
	z_xif_issue_resp_exc,
	s_xif_commit_valid,
	s_xif_commit_id,
	s_xif_commit_kill,
	s_xif_mem_valid,
	s_xif_mem_ready,
	s_xif_mem_req_id,
	s_xif_mem_req_addr,
	s_xif_mem_req_mode,
	s_xif_mem_req_we,
	s_xif_mem_req_size,
	s_xif_mem_req_be,
	s_xif_mem_req_wdata,
	s_xif_mem_req_last,
	s_xif_mem_resp_exc,
	s_xif_mem_resp_exccode,
	s_xif_mem_result_valid,
	s_xif_mem_result_id,
	s_xif_mem_result_rdata,
	s_xif_mem_result_err,
	s_xif_result_valid,
	s_xif_result_ready,
	s_xif_result_id,
	s_xif_result_data,
	s_xif_result_rd,
	s_xif_result_we,
	s_xif_result_exc,
	s_xif_result_exccode
);
	input wire clk_i;
	input wire rst_ni;
	input wire s_xif_issue_valid;
	input wire [31:0] s_xif_issue_req_instr;
	input wire [1:0] s_xif_issue_req_mode;
	input wire [3:0] s_xif_issue_req_id;
	input wire [31:0] s_xif_issue_req_rs_0;
	input wire [31:0] s_xif_issue_req_rs_1;
	input wire [1:0] s_xif_issue_req_rs_valid;
	output wire s_xif_issue_ready;
	output wire s_xif_issue_resp_accept;
	output wire s_xif_issue_resp_writeback;
	output wire s_xif_issue_resp_dualwrite;
	output wire [2:0] s_xif_issue_resp_dualread;
	output wire s_xif_issue_resp_loadstore;
	output wire s_xif_issue_resp_exc;
	input wire z_xif_issue_valid;
	output wire z_xif_issue_ready;
	input wire [31:0] z_xif_issue_req_instr;
	input wire [1:0] z_xif_issue_req_mode;
	input wire [3:0] z_xif_issue_req_id;
	input wire [31:0] z_xif_issue_req_rs_0;
	input wire [31:0] z_xif_issue_req_rs_1;
	input wire [1:0] z_xif_issue_req_rs_valid;
	output wire z_xif_issue_resp_accept;
	output wire z_xif_issue_resp_writeback;
	output wire z_xif_issue_resp_dualwrite;
	output wire [2:0] z_xif_issue_resp_dualread;
	output wire z_xif_issue_resp_loadstore;
	output wire z_xif_issue_resp_exc;
	input wire s_xif_commit_valid;
	input wire [3:0] s_xif_commit_id;
	input wire s_xif_commit_kill;
	output wire s_xif_mem_valid;
	input wire s_xif_mem_ready;
	output wire [3:0] s_xif_mem_req_id;
	output wire [31:0] s_xif_mem_req_addr;
	output wire [1:0] s_xif_mem_req_mode;
	output wire s_xif_mem_req_we;
	output wire [2:0] s_xif_mem_req_size;
	output wire [3:0] s_xif_mem_req_be;
	output wire [31:0] s_xif_mem_req_wdata;
	output wire s_xif_mem_req_last;
	input wire s_xif_mem_resp_exc;
	input wire [5:0] s_xif_mem_resp_exccode;
	input wire s_xif_mem_result_valid;
	input wire [3:0] s_xif_mem_result_id;
	input wire [31:0] s_xif_mem_result_rdata;
	input wire s_xif_mem_result_err;
	output wire s_xif_result_valid;
	input wire s_xif_result_ready;
	output wire [3:0] s_xif_result_id;
	output wire [31:0] s_xif_result_data;
	output wire [4:0] s_xif_result_rd;
	output wire s_xif_result_we;
	output wire s_xif_result_exc;
	output wire [5:0] s_xif_result_exccode;
	generate
		if (1) begin : ext_if
			localparam signed [31:0] X_NUM_RS = 2;
			localparam signed [31:0] X_ID_WIDTH = 4;
			localparam signed [31:0] X_MEM_WIDTH = 32;
			localparam signed [31:0] X_RFR_WIDTH = 32;
			localparam signed [31:0] X_RFW_WIDTH = 32;
			localparam [31:0] X_MISA = 1'sb0;
			localparam [1:0] X_ECS_XS = 1'sb0;
			localparam signed [31:0] X_DUALREAD = 0;
			localparam signed [31:0] X_DUALWRITE = 0;
			localparam signed [31:0] XLEN = 32;
			wire compressed_valid;
			wire compressed_ready;
			wire [21:0] compressed_req;
			wire [32:0] compressed_resp;
			wire issue_valid;
			wire issue_ready;
			wire [((38 + (X_NUM_RS * X_RFR_WIDTH)) + X_NUM_RS) + 6:0] issue_req;
			wire [8:0] issue_resp;
			wire commit_valid;
			wire [4:0] commit;
			wire mem_valid;
			wire mem_ready;
			reg [81:0] mem_req;
			wire [7:0] mem_resp;
			wire mem_result_valid;
			wire [(X_ID_WIDTH + X_MEM_WIDTH) + 1:0] mem_result;
			wire result_valid;
			wire result_ready;
			wire [(((X_ID_WIDTH + X_RFW_WIDTH) + 5) + (X_RFW_WIDTH / XLEN)) + 17:0] result;
		end
	endgenerate
	assign ext_if.issue_valid = s_xif_issue_valid;
	assign s_xif_issue_ready = ext_if.issue_ready;
	assign ext_if.issue_req[38 + ((32'sd2 * 32'sd32) + 8)-:((38 + ((32'sd2 * 32'sd32) + 8)) >= (6 + ((32'sd2 * 32'sd32) + 9)) ? ((38 + ((32'sd2 * 32'sd32) + 8)) - (6 + ((32'sd2 * 32'sd32) + 9))) + 1 : ((6 + ((32'sd2 * 32'sd32) + 9)) - (38 + ((32'sd2 * 32'sd32) + 8))) + 1)] = s_xif_issue_req_instr;
	assign ext_if.issue_req[6 + ((32'sd2 * 32'sd32) + 8)-:((6 + ((32'sd2 * 32'sd32) + 8)) >= (32'sd4 + ((32'sd2 * 32'sd32) + 9)) ? ((6 + ((32'sd2 * 32'sd32) + 8)) - (32'sd4 + ((32'sd2 * 32'sd32) + 9))) + 1 : ((32'sd4 + ((32'sd2 * 32'sd32) + 9)) - (6 + ((32'sd2 * 32'sd32) + 8))) + 1)] = s_xif_issue_req_mode;
	assign ext_if.issue_req[32'sd4 + ((32'sd2 * 32'sd32) + 8)-:((32'sd4 + ((32'sd2 * 32'sd32) + 8)) >= ((32'sd2 * 32'sd32) + 9) ? ((32'sd4 + ((32'sd2 * 32'sd32) + 8)) - ((32'sd2 * 32'sd32) + 9)) + 1 : (((32'sd2 * 32'sd32) + 9) - (32'sd4 + ((32'sd2 * 32'sd32) + 8))) + 1)] = s_xif_issue_req_id;
	assign ext_if.issue_req[((32'sd2 * 32'sd32) + 8) - ((32'sd2 * 32'sd32) - 1)+:32'sd32] = s_xif_issue_req_rs_0;
	assign ext_if.issue_req[((32'sd2 * 32'sd32) + 8) - ((32'sd2 * 32'sd32) - 33)+:32'sd32] = s_xif_issue_req_rs_1;
	assign ext_if.issue_req[8-:2] = s_xif_issue_req_rs_valid;
	assign ext_if.issue_req[6-:6] = 6'h00;
	assign ext_if.issue_req[0] = 1'b0;
	assign s_xif_issue_resp_accept = ext_if.issue_resp[8];
	assign s_xif_issue_resp_writeback = ext_if.issue_resp[7];
	assign s_xif_issue_resp_dualwrite = ext_if.issue_resp[6];
	assign s_xif_issue_resp_dualread = ext_if.issue_resp[5-:3];
	assign s_xif_issue_resp_loadstore = ext_if.issue_resp[2];
	assign s_xif_issue_resp_exc = ext_if.issue_resp[0];
	assign ext_if.commit_valid = s_xif_commit_valid;
	assign ext_if.commit[4-:4] = s_xif_commit_id;
	assign ext_if.commit[0] = s_xif_commit_kill;
	assign s_xif_mem_valid = ext_if.mem_valid;
	assign ext_if.mem_ready = s_xif_mem_ready;
	assign s_xif_mem_req_id = ext_if.mem_req[81-:4];
	assign s_xif_mem_req_addr = ext_if.mem_req[77-:32];
	assign s_xif_mem_req_mode = ext_if.mem_req[45-:2];
	assign s_xif_mem_req_we = ext_if.mem_req[43];
	assign s_xif_mem_req_size = ext_if.mem_req[42-:3];
	assign s_xif_mem_req_be = ext_if.mem_req[39-:4];
	assign s_xif_mem_req_wdata = ext_if.mem_req[33-:32];
	assign s_xif_mem_req_last = ext_if.mem_req[1];
	assign ext_if.mem_resp[7] = s_xif_mem_resp_exc;
	assign ext_if.mem_resp[6-:6] = s_xif_mem_resp_exccode;
	assign ext_if.mem_resp[0] = 1'b0;
	assign ext_if.mem_result_valid = s_xif_mem_result_valid;
	assign ext_if.mem_result[37-:4] = s_xif_mem_result_id;
	assign ext_if.mem_result[33-:32] = s_xif_mem_result_rdata;
	assign ext_if.mem_result[1] = s_xif_mem_result_err;
	assign ext_if.mem_result[0] = 1'b0;
	assign s_xif_result_valid = ext_if.result_valid;
	assign ext_if.result_ready = s_xif_result_ready;
	assign s_xif_result_id = ext_if.result[41 + ((32'sd32 / 32'sd32) + 17)-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((41 + ((32'sd32 / 32'sd32) + 17)) - (37 + ((32'sd32 / 32'sd32) + 18))) + 1 : ((37 + ((32'sd32 / 32'sd32) + 18)) - (41 + ((32'sd32 / 32'sd32) + 17))) + 1)];
	assign s_xif_result_data = ext_if.result[37 + ((32'sd32 / 32'sd32) + 17)-:((37 + ((32'sd32 / 32'sd32) + 17)) >= (5 + ((32'sd32 / 32'sd32) + 18)) ? ((37 + ((32'sd32 / 32'sd32) + 17)) - (5 + ((32'sd32 / 32'sd32) + 18))) + 1 : ((5 + ((32'sd32 / 32'sd32) + 18)) - (37 + ((32'sd32 / 32'sd32) + 17))) + 1)];
	assign s_xif_result_rd = ext_if.result[5 + ((32'sd32 / 32'sd32) + 17)-:((5 + ((32'sd32 / 32'sd32) + 17)) >= ((32'sd32 / 32'sd32) + 18) ? ((5 + ((32'sd32 / 32'sd32) + 17)) - ((32'sd32 / 32'sd32) + 18)) + 1 : (((32'sd32 / 32'sd32) + 18) - (5 + ((32'sd32 / 32'sd32) + 17))) + 1)];
	assign s_xif_result_we = ext_if.result[(32'sd32 / 32'sd32) + 17-:(((32'sd32 / 32'sd32) + 17) >= 18 ? (32'sd32 / 32'sd32) + 0 : 19 - ((32'sd32 / 32'sd32) + 17))];
	assign s_xif_result_exc = ext_if.result[8];
	assign s_xif_result_exccode = ext_if.result[7-:6];
	assign ext_if.compressed_valid = 1'b0;
	assign ext_if.compressed_req = 1'sb0;
	localparam _param_67078_INPUT_BUFFER_DEPTH = 1;
	localparam _param_67078_FORWARDING = 1;
	generate
		if (1) begin : xif_copro_i
			reg _sv2v_0;
			localparam [31:0] XLEN = 32;
			localparam [31:0] INPUT_BUFFER_DEPTH = _param_67078_INPUT_BUFFER_DEPTH;
			localparam [0:0] FORWARDING = _param_67078_FORWARDING;
			wire clk_i;
			wire rst_ni;
			wire [31:0] prd_req;
			localparam signed [31:0] xif_copro_pkg_X_NUM_RS = 2;
			wire [4:0] prd_rsp;
			localparam [31:0] xif_copro_pkg_NUM_COPRO_OPERATIONS = 2;
			localparam [31:0] xif_copro_pkg_COPRO_OPERATION_BITS = 1;
			wire [8:0] decoded_data;
			wire in_buf_push_valid;
			wire in_buf_push_ready;
			wire in_buf_pop_valid;
			wire in_buf_pop_ready;
			localparam signed [31:0] xif_copro_pkg_X_ID_WIDTH = 4;
			localparam signed [31:0] xif_copro_pkg_X_RFR_WIDTH = 32;
			wire [(((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 32) + xif_copro_pkg_X_ID_WIDTH) + 1:0] in_buf_push_data;
			wire [(((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 32) + xif_copro_pkg_X_ID_WIDTH) + 1:0] in_buf_pop_data;
			wire [1:0] ex_fwd;
			wire [1:0] lsu_fwd;
			reg [(xif_copro_pkg_X_NUM_RS * XLEN) - 1:0] operands;
			wire [(xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) - 1:0] copreg_operands;
			reg [31:0] offset;
			wire [9:0] copreg_raddr;
			reg [4:0] copreg_wb_addr;
			reg [31:0] copreg_wb_data;
			wire copreg_we;
			wire mem_push_valid;
			wire mem_push_ready;
			wire mem_pop_ready;
			wire [17:0] mem_push_data;
			wire [17:0] mem_pop_data;
			wire [9:0] ex_tag_in;
			wire [9:0] ex_tag_out;
			wire ex_in_valid;
			wire ex_in_ready;
			wire ex_out_valid;
			wire ex_out_ready;
			wire [31:0] data_result;
			wire result_push_valid;
			wire result_pop_valid;
			localparam signed [31:0] xif_copro_pkg_XLEN = 32;
			localparam signed [31:0] xif_copro_pkg_X_RFW_WIDTH = 32;
			reg [(((xif_copro_pkg_X_ID_WIDTH + xif_copro_pkg_X_RFW_WIDTH) + 5) + (xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN)) + 17:0] result_push_data;
			wire [(((xif_copro_pkg_X_ID_WIDTH + xif_copro_pkg_X_RFW_WIDTH) + 5) + (xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN)) + 17:0] result_pop_data;
			assign xif_copro_wrapper.ext_if.compressed_ready = xif_copro_wrapper.ext_if.compressed_valid;
			assign xif_copro_wrapper.ext_if.compressed_resp[32-:32] = 1'sb0;
			assign xif_copro_wrapper.ext_if.compressed_resp[0] = 1'sb0;
			assign prd_req[31-:32] = xif_copro_wrapper.ext_if.issue_req[38 + ((32'sd2 * 32'sd32) + 8)-:((38 + ((32'sd2 * 32'sd32) + 8)) >= (6 + ((32'sd2 * 32'sd32) + 9)) ? ((38 + ((32'sd2 * 32'sd32) + 8)) - (6 + ((32'sd2 * 32'sd32) + 9))) + 1 : ((6 + ((32'sd2 * 32'sd32) + 9)) - (38 + ((32'sd2 * 32'sd32) + 8))) + 1)];
			assign xif_copro_wrapper.ext_if.issue_resp[8] = prd_rsp[4];
			assign xif_copro_wrapper.ext_if.issue_resp[7] = prd_rsp[2];
			assign xif_copro_wrapper.ext_if.issue_resp[6] = 1'sb0;
			assign xif_copro_wrapper.ext_if.issue_resp[5-:3] = 1'sb0;
			assign xif_copro_wrapper.ext_if.issue_resp[2] = prd_rsp[3];
			assign xif_copro_wrapper.ext_if.issue_resp[1] = 1'sb0;
			assign xif_copro_wrapper.ext_if.issue_resp[0] = 1'sb0;
			xif_copro_predecoder xif_copro_predecoder_i(
				.prd_req_i(prd_req),
				.prd_rsp_o(prd_rsp)
			);
			xif_copro_decoder xif_copro_decoder_i(
				.instr_i(in_buf_pop_data[37-:32]),
				.decoder_o(decoded_data)
			);
			assign in_buf_push_valid = (xif_copro_wrapper.ext_if.issue_valid & xif_copro_wrapper.ext_if.issue_ready) & xif_copro_wrapper.ext_if.issue_resp[8];
			assign in_buf_push_data[(xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 37-:(((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 37) >= 38 ? xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH : 39 - ((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 37))] = xif_copro_wrapper.ext_if.issue_req[((32'sd2 * 32'sd32) + 8) - ((32'sd2 * 32'sd32) - 1)+:32'sd32 * xif_copro_pkg_X_NUM_RS];
			assign in_buf_push_data[37-:32] = xif_copro_wrapper.ext_if.issue_req[38 + ((32'sd2 * 32'sd32) + 8)-:((38 + ((32'sd2 * 32'sd32) + 8)) >= (6 + ((32'sd2 * 32'sd32) + 9)) ? ((38 + ((32'sd2 * 32'sd32) + 8)) - (6 + ((32'sd2 * 32'sd32) + 9))) + 1 : ((6 + ((32'sd2 * 32'sd32) + 9)) - (38 + ((32'sd2 * 32'sd32) + 8))) + 1)];
			assign in_buf_push_data[5-:4] = xif_copro_wrapper.ext_if.issue_req[32'sd4 + ((32'sd2 * 32'sd32) + 8)-:((32'sd4 + ((32'sd2 * 32'sd32) + 8)) >= ((32'sd2 * 32'sd32) + 9) ? ((32'sd4 + ((32'sd2 * 32'sd32) + 8)) - ((32'sd2 * 32'sd32) + 9)) + 1 : (((32'sd2 * 32'sd32) + 9) - (32'sd4 + ((32'sd2 * 32'sd32) + 8))) + 1)];
			assign in_buf_push_data[1-:2] = xif_copro_wrapper.ext_if.issue_req[6 + ((32'sd2 * 32'sd32) + 8)-:((6 + ((32'sd2 * 32'sd32) + 8)) >= (32'sd4 + ((32'sd2 * 32'sd32) + 9)) ? ((6 + ((32'sd2 * 32'sd32) + 8)) - (32'sd4 + ((32'sd2 * 32'sd32) + 9))) + 1 : ((32'sd4 + ((32'sd2 * 32'sd32) + 9)) - (6 + ((32'sd2 * 32'sd32) + 8))) + 1)];
			stream_fifo_EEB9B_DFA55 #(
				.T_xif_copro_pkg_X_ID_WIDTH(xif_copro_pkg_X_ID_WIDTH),
				.T_xif_copro_pkg_X_NUM_RS(xif_copro_pkg_X_NUM_RS),
				.T_xif_copro_pkg_X_RFR_WIDTH(xif_copro_pkg_X_RFR_WIDTH),
				.FALL_THROUGH(1),
				.DATA_WIDTH(XLEN),
				.DEPTH(INPUT_BUFFER_DEPTH)
			) input_stream_fifo_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.usage_o(),
				.data_i(in_buf_push_data),
				.valid_i(in_buf_push_valid),
				.ready_o(in_buf_push_ready),
				.data_o(in_buf_pop_data),
				.valid_o(in_buf_pop_valid),
				.ready_i(in_buf_pop_ready)
			);
			wire [4:1] sv2v_tmp_35B50;
			assign sv2v_tmp_35B50 = in_buf_pop_data[5-:4];
			always @(*) xif_copro_wrapper.ext_if.mem_req[81-:4] = sv2v_tmp_35B50;
			wire [2:1] sv2v_tmp_B2794;
			assign sv2v_tmp_B2794 = in_buf_pop_data[1-:2];
			always @(*) xif_copro_wrapper.ext_if.mem_req[45-:2] = sv2v_tmp_B2794;
			wire [3:1] sv2v_tmp_460E6;
			assign sv2v_tmp_460E6 = 3'b010;
			always @(*) xif_copro_wrapper.ext_if.mem_req[42-:3] = sv2v_tmp_460E6;
			wire [4:1] sv2v_tmp_C852C;
			assign sv2v_tmp_C852C = 1'sb1;
			always @(*) xif_copro_wrapper.ext_if.mem_req[39-:4] = sv2v_tmp_C852C;
			wire [2:1] sv2v_tmp_61F67;
			assign sv2v_tmp_61F67 = 2'b00;
			always @(*) xif_copro_wrapper.ext_if.mem_req[35-:2] = sv2v_tmp_61F67;
			wire [1:1] sv2v_tmp_7B270;
			assign sv2v_tmp_7B270 = 1'b1;
			always @(*) xif_copro_wrapper.ext_if.mem_req[1] = sv2v_tmp_7B270;
			wire [1:1] sv2v_tmp_97BD0;
			assign sv2v_tmp_97BD0 = 1'b0;
			always @(*) xif_copro_wrapper.ext_if.mem_req[0] = sv2v_tmp_97BD0;
			always @(*) begin
				if (_sv2v_0)
					;
				if (ex_fwd[1])
					xif_copro_wrapper.ext_if.mem_req[33-:32] = data_result;
				else if (lsu_fwd[1])
					xif_copro_wrapper.ext_if.mem_req[33-:32] = xif_copro_wrapper.ext_if.mem_result[33-:32];
				else
					xif_copro_wrapper.ext_if.mem_req[33-:32] = copreg_operands[xif_copro_pkg_X_RFR_WIDTH+:xif_copro_pkg_X_RFR_WIDTH];
			end
			always @(*) begin
				if (_sv2v_0)
					;
				if (~xif_copro_wrapper.ext_if.mem_req[43])
					offset = {{20 {in_buf_pop_data[37]}}, in_buf_pop_data[37:26]};
				else
					offset = {{20 {in_buf_pop_data[37]}}, in_buf_pop_data[37:31], in_buf_pop_data[17:13]};
				xif_copro_wrapper.ext_if.mem_req[77-:32] = in_buf_pop_data[((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 37) - ((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) - 1)+:xif_copro_pkg_X_RFR_WIDTH] + offset;
			end
			assign mem_push_data[17-:4] = in_buf_pop_data[5-:4];
			assign mem_push_data[13-:5] = in_buf_pop_data[17:13];
			assign mem_push_data[8] = decoded_data[0];
			assign mem_push_data[7] = xif_copro_wrapper.ext_if.mem_resp[7];
			assign mem_push_data[6-:6] = xif_copro_wrapper.ext_if.mem_resp[6-:6];
			assign mem_push_data[0] = xif_copro_wrapper.ext_if.mem_resp[0];
			stream_fifo_472C7_6FB59 #(
				.T_xif_copro_pkg_X_ID_WIDTH(xif_copro_pkg_X_ID_WIDTH),
				.FALL_THROUGH(0),
				.DATA_WIDTH(XLEN),
				.DEPTH(3)
			) mem_stream_fifo_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.usage_o(),
				.data_i(mem_push_data),
				.valid_i(mem_push_valid),
				.ready_o(mem_push_ready),
				.data_o(mem_pop_data),
				.valid_o(),
				.ready_i(mem_pop_ready)
			);
			localparam _param_4C847_FORWARDING = FORWARDING;
			if (1) begin : xif_copro_controller_i
				reg _sv2v_0;
				localparam [0:0] FORWARDING = _param_4C847_FORWARDING;
				wire clk_i;
				wire rst_ni;
				localparam signed [31:0] xif_copro_pkg_X_NUM_RS = 2;
				wire [1:0] prd_rsp_use_gprs_i;
				wire [1:0] xif_issue_req_rs_valid_i;
				wire xif_issue_ready_o;
				wire in_buf_push_ready_i;
				wire in_buf_pop_valid_i;
				reg in_buf_pop_ready_o;
				wire rd_is_copro_i;
				wire [4:0] ex_out_addr_i;
				wire [4:0] copreg_wb_addr_i;
				wire [4:0] rd_i;
				reg copreg_we_o;
				wire rd_in_is_copro_i;
				wire [4:0] rs1_i;
				wire [4:0] rs2_i;
				reg [1:0] ex_fwd_o;
				reg [1:0] lsu_fwd_o;
				wire [3:0] op_select_i;
				wire is_load_i;
				wire is_store_i;
				reg xif_mem_valid_o;
				wire xif_mem_ready_i;
				wire xif_mem_req_we_o;
				localparam signed [31:0] xif_copro_pkg_X_ID_WIDTH = 4;
				wire [3:0] xif_mem_req_id_i;
				wire mem_push_valid_o;
				wire mem_push_ready_i;
				wire mem_pop_ready_o;
				wire [17:0] mem_pop_data_i;
				wire xif_mem_result_valid_i;
				wire use_copro_i;
				wire ex_in_valid_o;
				wire ex_in_ready_i;
				wire [3:0] ex_in_id_i;
				wire ex_out_valid_i;
				wire ex_out_ready_o;
				wire xif_result_valid_o;
				wire [3:0] xif_result_id_i;
				wire result_push_valid_o;
				wire result_pop_valid_i;
				reg [1:0] valid_operands;
				wire dep_rs1;
				wire dep_rs2;
				wire dep_rs;
				wire dep_rd;
				wire ex_in_hs;
				wire ex_out_hs;
				wire x_mem_req_hs;
				reg instr_inflight;
				reg [31:0] rd_scoreboard_d;
				reg [31:0] rd_scoreboard_q;
				reg [15:0] commit_scoreboard_d;
				reg [15:0] commit_scoreboard_q;
				assign xif_issue_ready_o = (((prd_rsp_use_gprs_i[0] & xif_issue_req_rs_valid_i[0]) | !prd_rsp_use_gprs_i[0]) & ((prd_rsp_use_gprs_i[1] & xif_issue_req_rs_valid_i[1]) | !prd_rsp_use_gprs_i[1])) & in_buf_push_ready_i;
				always @(*) begin
					if (_sv2v_0)
						;
					in_buf_pop_ready_o = 1'b0;
					if (ex_in_hs | x_mem_req_hs)
						in_buf_pop_ready_o = 1'b1;
				end
				always @(*) begin
					if (_sv2v_0)
						;
					copreg_we_o = 1'b0;
					if ((ex_out_hs & rd_is_copro_i) | (mem_pop_data_i[8] & xif_mem_result_valid_i))
						copreg_we_o = 1'b1;
				end
				assign dep_rs1 = (rd_scoreboard_q[rs1_i] & in_buf_pop_valid_i) & (op_select_i[0+:2] == 2'd1);
				assign dep_rs2 = (rd_scoreboard_q[rs2_i] & in_buf_pop_valid_i) & (op_select_i[2+:2] == 2'd2);
				assign dep_rs = (dep_rs1 & ~(ex_fwd_o[0] | lsu_fwd_o[0])) | (dep_rs2 & ~(ex_fwd_o[1] | lsu_fwd_o[1]));
				assign dep_rd = (rd_scoreboard_q[rd_i] & rd_in_is_copro_i) & ~(((ex_out_hs | xif_mem_result_valid_i) & copreg_we_o) & (copreg_wb_addr_i == rd_i));
				always @(*) begin
					if (_sv2v_0)
						;
					ex_fwd_o[0] = 1'b0;
					ex_fwd_o[1] = 1'b0;
					lsu_fwd_o[0] = 1'b0;
					lsu_fwd_o[1] = 1'b0;
					if (FORWARDING) begin
						valid_operands[0] = op_select_i[0+:2] == 2'd1;
						valid_operands[1] = op_select_i[2+:2] == 2'd2;
						ex_fwd_o[0] = ((valid_operands[0] & ex_out_hs) & rd_is_copro_i) & (rs1_i == ex_out_addr_i);
						ex_fwd_o[1] = ((valid_operands[1] & ex_out_hs) & rd_is_copro_i) & (rs2_i == ex_out_addr_i);
						lsu_fwd_o[0] = ((valid_operands[0] & xif_mem_result_valid_i) & mem_pop_data_i[8]) & (rs1_i == mem_pop_data_i[13-:5]);
						lsu_fwd_o[1] = ((valid_operands[1] & xif_mem_result_valid_i) & mem_pop_data_i[8]) & (rs2_i == mem_pop_data_i[13-:5]);
					end
				end
				assign x_mem_req_hs = xif_mem_valid_o & xif_mem_ready_i;
				assign mem_push_valid_o = x_mem_req_hs;
				assign mem_pop_ready_o = xif_mem_result_valid_i;
				always @(*) begin
					if (_sv2v_0)
						;
					xif_mem_valid_o = 1'b0;
					if ((((((is_load_i | is_store_i) & ~dep_rs) & ~dep_rd) & in_buf_pop_valid_i) & mem_push_ready_i) & (commit_scoreboard_q[xif_mem_req_id_i] | commit_scoreboard_d[xif_mem_req_id_i]))
						xif_mem_valid_o = 1'b1;
				end
				assign xif_mem_req_we_o = is_store_i;
				always @(posedge clk_i or negedge rst_ni)
					if (~rst_ni)
						instr_inflight <= 1'b0;
					else if (ex_in_hs)
						instr_inflight <= 1'b1;
					else if (ex_out_hs)
						instr_inflight <= 1'b0;
				assign ex_in_hs = ex_in_valid_o & ex_in_ready_i;
				assign ex_out_hs = ex_out_valid_i & ex_out_ready_o;
				assign ex_out_ready_o = ~xif_mem_result_valid_i;
				assign ex_in_valid_o = ((((use_copro_i & in_buf_pop_valid_i) & (commit_scoreboard_q[ex_in_id_i] | commit_scoreboard_d[ex_in_id_i])) & ~dep_rs) & ~dep_rd) & (ex_out_valid_i | ~instr_inflight);
				assign xif_result_valid_o = (ex_out_valid_i | xif_mem_result_valid_i) | result_pop_valid_i;
				assign result_push_valid_o = ex_out_hs | xif_mem_result_valid_i;
				always @(*) begin
					if (_sv2v_0)
						;
					rd_scoreboard_d = rd_scoreboard_q;
					if ((ex_in_hs & rd_in_is_copro_i) | ((x_mem_req_hs & is_load_i) & in_buf_pop_valid_i))
						rd_scoreboard_d[rd_i] = 1'b1;
					if (ex_out_hs & ~(ex_in_hs & (copreg_wb_addr_i == rd_i)))
						rd_scoreboard_d[copreg_wb_addr_i] = 1'b0;
					else if ((xif_mem_result_valid_i & mem_pop_data_i[8]) & ~((ex_in_hs & rd_in_is_copro_i) & (mem_pop_data_i[13-:5] == rd_i)))
						rd_scoreboard_d[mem_pop_data_i[13-:5]] = 1'b0;
				end
				always @(*) begin
					if (_sv2v_0)
						;
					commit_scoreboard_d = commit_scoreboard_q;
					if (xif_copro_wrapper.ext_if.commit_valid & ~xif_copro_wrapper.ext_if.commit[0])
						commit_scoreboard_d[xif_copro_wrapper.ext_if.commit[4-:4]] = 1'b1;
					if (xif_result_valid_o)
						commit_scoreboard_d[xif_result_id_i] = 1'b0;
				end
				always @(posedge clk_i or negedge rst_ni) begin : scoreboard_reg
					if (~rst_ni) begin
						rd_scoreboard_q <= 1'sb0;
						commit_scoreboard_q <= 1'sb0;
					end
					else begin
						rd_scoreboard_q <= rd_scoreboard_d;
						commit_scoreboard_q <= commit_scoreboard_d;
					end
				end
				initial _sv2v_0 = 0;
			end
			assign xif_copro_controller_i.clk_i = clk_i;
			assign xif_copro_controller_i.rst_ni = rst_ni;
			assign xif_copro_controller_i.prd_rsp_use_gprs_i = prd_rsp[1-:xif_copro_pkg_X_NUM_RS];
			assign xif_copro_controller_i.xif_issue_req_rs_valid_i = xif_copro_wrapper.ext_if.issue_req[8:7];
			assign xif_copro_wrapper.ext_if.issue_ready = xif_copro_controller_i.xif_issue_ready_o;
			assign xif_copro_controller_i.in_buf_push_ready_i = in_buf_push_ready;
			assign xif_copro_controller_i.in_buf_pop_valid_i = in_buf_pop_valid;
			assign in_buf_pop_ready = xif_copro_controller_i.in_buf_pop_ready_o;
			assign xif_copro_controller_i.rd_is_copro_i = ex_tag_out[0];
			assign xif_copro_controller_i.ex_out_addr_i = ex_tag_out[5-:5];
			assign xif_copro_controller_i.copreg_wb_addr_i = copreg_wb_addr;
			assign xif_copro_controller_i.rd_i = in_buf_pop_data[17:13];
			assign copreg_we = xif_copro_controller_i.copreg_we_o;
			assign xif_copro_controller_i.rd_in_is_copro_i = decoded_data[3];
			assign xif_copro_controller_i.rs1_i = copreg_raddr[0+:5];
			assign xif_copro_controller_i.rs2_i = copreg_raddr[5+:5];
			assign ex_fwd = xif_copro_controller_i.ex_fwd_o;
			assign lsu_fwd = xif_copro_controller_i.lsu_fwd_o;
			assign xif_copro_controller_i.op_select_i = decoded_data[7-:4];
			assign xif_copro_controller_i.is_load_i = decoded_data[0];
			assign xif_copro_controller_i.is_store_i = decoded_data[1];
			assign xif_copro_wrapper.ext_if.mem_valid = xif_copro_controller_i.xif_mem_valid_o;
			assign xif_copro_controller_i.xif_mem_ready_i = xif_copro_wrapper.ext_if.mem_ready;
			wire [1:1] sv2v_tmp_58792;
			assign sv2v_tmp_58792 = xif_copro_controller_i.xif_mem_req_we_o;
			always @(*) xif_copro_wrapper.ext_if.mem_req[43] = sv2v_tmp_58792;
			assign xif_copro_controller_i.xif_mem_req_id_i = xif_copro_wrapper.ext_if.mem_req[81-:4];
			assign mem_push_valid = xif_copro_controller_i.mem_push_valid_o;
			assign xif_copro_controller_i.mem_push_ready_i = mem_push_ready;
			assign mem_pop_ready = xif_copro_controller_i.mem_pop_ready_o;
			assign xif_copro_controller_i.mem_pop_data_i = mem_pop_data;
			assign xif_copro_controller_i.xif_mem_result_valid_i = xif_copro_wrapper.ext_if.mem_result_valid;
			assign xif_copro_controller_i.use_copro_i = decoded_data[2];
			assign ex_in_valid = xif_copro_controller_i.ex_in_valid_o;
			assign xif_copro_controller_i.ex_in_ready_i = ex_in_ready;
			assign xif_copro_controller_i.ex_in_id_i = in_buf_pop_data[5-:4];
			assign xif_copro_controller_i.ex_out_valid_i = ex_out_valid;
			assign ex_out_ready = xif_copro_controller_i.ex_out_ready_o;
			assign xif_copro_wrapper.ext_if.result_valid = xif_copro_controller_i.xif_result_valid_o;
			assign xif_copro_controller_i.xif_result_id_i = xif_copro_wrapper.ext_if.result[41 + ((32'sd32 / 32'sd32) + 17)-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((41 + ((32'sd32 / 32'sd32) + 17)) - (37 + ((32'sd32 / 32'sd32) + 18))) + 1 : ((37 + ((32'sd32 / 32'sd32) + 18)) - (41 + ((32'sd32 / 32'sd32) + 17))) + 1)];
			assign result_push_valid = xif_copro_controller_i.result_push_valid_o;
			assign xif_copro_controller_i.result_pop_valid_i = result_pop_valid;
			assign copreg_raddr[0+:5] = in_buf_pop_data[25:21];
			assign copreg_raddr[5+:5] = in_buf_pop_data[30:26];
			always @(*) begin
				if (_sv2v_0)
					;
				copreg_wb_data = data_result;
				if (xif_copro_wrapper.ext_if.mem_result_valid)
					copreg_wb_data = xif_copro_wrapper.ext_if.mem_result[33-:32];
			end
			always @(*) begin
				if (_sv2v_0)
					;
				copreg_wb_addr = ex_tag_out[5-:5];
				if (xif_copro_wrapper.ext_if.mem_result_valid)
					copreg_wb_addr = mem_pop_data[13-:5];
				else if (~decoded_data[2] & ~ex_out_valid)
					copreg_wb_addr = in_buf_pop_data[17:13];
			end
			xif_copro_regfile #(
				.DATA_WIDTH(xif_copro_pkg_X_RFR_WIDTH),
				.NR_READ_PORTS(xif_copro_pkg_X_NUM_RS),
				.NR_WRITE_PORTS(1)
			) xif_copro_regfile_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.raddr_i(copreg_raddr),
				.rdata_o(copreg_operands),
				.waddr_i(copreg_wb_addr),
				.wdata_i(copreg_wb_data),
				.we_i(copreg_we)
			);
			genvar _gv_i_4;
			for (_gv_i_4 = 0; _gv_i_4 < xif_copro_pkg_X_NUM_RS; _gv_i_4 = _gv_i_4 + 1) begin : gen_operand_select
				localparam i = _gv_i_4;
				always @(*) begin
					if (_sv2v_0)
						;
					(* full_case, parallel_case *)
					case (decoded_data[4 + (i * 2)+:2])
						2'd3:
							if (ex_fwd[i])
								operands[i * XLEN+:XLEN] = data_result;
							else
								operands[i * XLEN+:XLEN] = {{XLEN - xif_copro_pkg_X_RFR_WIDTH {1'b0}}, in_buf_pop_data[((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) + 37) - (((xif_copro_pkg_X_NUM_RS * xif_copro_pkg_X_RFR_WIDTH) - 1) - (i * xif_copro_pkg_X_RFR_WIDTH))+:xif_copro_pkg_X_RFR_WIDTH]};
						2'd1, 2'd2: begin : sv2v_autoblock_1
							reg [0:0] sv2v_tmp_cast;
							sv2v_tmp_cast = 0;
							if (ex_fwd[i] & (decoded_data[8-:1] != sv2v_tmp_cast))
								operands[i * XLEN+:XLEN] = data_result;
							else begin : sv2v_autoblock_2
								reg [0:0] sv2v_tmp_cast_1;
								sv2v_tmp_cast_1 = 0;
								if (lsu_fwd[i] & (decoded_data[8-:1] != sv2v_tmp_cast_1))
									operands[i * XLEN+:XLEN] = xif_copro_wrapper.ext_if.mem_result[33-:32];
								else
									operands[i * XLEN+:XLEN] = {{XLEN - xif_copro_pkg_X_RFR_WIDTH {1'b0}}, copreg_operands[i * xif_copro_pkg_X_RFR_WIDTH+:xif_copro_pkg_X_RFR_WIDTH]};
							end
						end
						default: operands[i * XLEN+:XLEN] = 1'sb1;
					endcase
				end
			end
			assign ex_tag_in[5-:5] = in_buf_pop_data[17:13];
			assign ex_tag_in[0] = decoded_data[3];
			assign ex_tag_in[9-:4] = in_buf_pop_data[5-:4];
			xif_copro_ex_stage_099A7_F3EC5 #(
				.tag_t_xif_copro_pkg_X_ID_WIDTH(xif_copro_pkg_X_ID_WIDTH),
				.XLEN(XLEN)
			) xif_copro_ex_stage_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.operand_a_i(operands[0+:XLEN]),
				.operand_b_i(operands[XLEN+:XLEN]),
				.operator_i(decoded_data[8-:1]),
				.tag_i(ex_tag_in),
				.in_valid_i(ex_in_valid),
				.in_ready_o(ex_in_ready),
				.out_valid_o(ex_out_valid),
				.out_ready_i(ex_out_ready),
				.tag_o(ex_tag_out),
				.result_o(data_result)
			);
			wire [((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((xif_copro_pkg_X_ID_WIDTH + (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)))) - (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18)))) + 1 : ((xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18))) - (xif_copro_pkg_X_ID_WIDTH + (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))))) + 1) * 1:1] sv2v_tmp_D9766;
			assign sv2v_tmp_D9766 = (xif_copro_wrapper.ext_if.mem_result_valid ? mem_pop_data[17-:4] : ex_tag_out[9-:4]);
			always @(*) result_push_data[xif_copro_pkg_X_ID_WIDTH + (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)))-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((xif_copro_pkg_X_ID_WIDTH + (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)))) - (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18)))) + 1 : ((xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18))) - (xif_copro_pkg_X_ID_WIDTH + (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))))) + 1)] = sv2v_tmp_D9766;
			wire [((37 + ((32'sd32 / 32'sd32) + 17)) >= (5 + ((32'sd32 / 32'sd32) + 18)) ? ((xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))) - (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18))) + 1 : ((5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18)) - (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)))) + 1) * 1:1] sv2v_tmp_CD9AF;
			assign sv2v_tmp_CD9AF = data_result;
			always @(*) result_push_data[xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))-:((37 + ((32'sd32 / 32'sd32) + 17)) >= (5 + ((32'sd32 / 32'sd32) + 18)) ? ((xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))) - (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18))) + 1 : ((5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18)) - (xif_copro_pkg_X_RFW_WIDTH + (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)))) + 1)] = sv2v_tmp_CD9AF;
			wire [((5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)) >= ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18) ? ((5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)) - ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18)) + 1 : (((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18) - (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))) + 1) * 1:1] sv2v_tmp_B401B;
			assign sv2v_tmp_B401B = ex_tag_out[5-:5];
			always @(*) result_push_data[5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)-:((5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)) >= ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18) ? ((5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17)) - ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18)) + 1 : (((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 18) - (5 + ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))) + 1)] = sv2v_tmp_B401B;
			wire [1:1] sv2v_tmp_D507F;
			assign sv2v_tmp_D507F = mem_pop_data[7];
			always @(*) result_push_data[8] = sv2v_tmp_D507F;
			wire [6:1] sv2v_tmp_9516F;
			assign sv2v_tmp_9516F = mem_pop_data[6-:6];
			always @(*) result_push_data[7-:6] = sv2v_tmp_9516F;
			wire [1:1] sv2v_tmp_B8EAD;
			assign sv2v_tmp_B8EAD = mem_pop_data[0] | (xif_copro_wrapper.ext_if.mem_result_valid & xif_copro_wrapper.ext_if.mem_result[0]);
			always @(*) result_push_data[0] = sv2v_tmp_B8EAD;
			wire [1:1] sv2v_tmp_3E728;
			assign sv2v_tmp_3E728 = xif_copro_wrapper.ext_if.mem_result_valid & xif_copro_wrapper.ext_if.mem_result[1];
			always @(*) result_push_data[1] = sv2v_tmp_3E728;
			always @(*) begin
				if (_sv2v_0)
					;
				result_push_data[(xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17-:(((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17) >= 18 ? (xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 0 : 19 - ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))] = 1'b0;
				if (ex_out_valid & ~ex_tag_out[0])
					result_push_data[(xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17-:(((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17) >= 18 ? (xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 0 : 19 - ((xif_copro_pkg_X_RFW_WIDTH / xif_copro_pkg_XLEN) + 17))] = 1'b1;
			end
			always @(*) begin
				if (_sv2v_0)
					;
				result_push_data[11-:3] = 1'sb0;
				result_push_data[17-:6] = 1'sb0;
				if (ex_out_valid & ex_tag_out[0]) begin
					result_push_data[11-:3] = 3'b010;
					result_push_data[17-:6] = 6'b001100;
				end
			end
			stream_fifo_CA27F_66AA4 #(
				.T_xif_copro_pkg_XLEN(xif_copro_pkg_XLEN),
				.T_xif_copro_pkg_X_ID_WIDTH(xif_copro_pkg_X_ID_WIDTH),
				.T_xif_copro_pkg_X_RFW_WIDTH(xif_copro_pkg_X_RFW_WIDTH),
				.FALL_THROUGH(1),
				.DATA_WIDTH(XLEN),
				.DEPTH(1)
			) result_fifo_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.flush_i(1'b0),
				.testmode_i(1'b0),
				.usage_o(),
				.data_i(result_push_data),
				.valid_i(result_push_valid),
				.ready_o(),
				.data_o(result_pop_data),
				.valid_o(result_pop_valid),
				.ready_i(xif_copro_wrapper.ext_if.result_ready)
			);
			assign xif_copro_wrapper.ext_if.result = result_pop_data;
			initial _sv2v_0 = 0;
		end
	endgenerate
	assign xif_copro_i.clk_i = clk_i;
	assign xif_copro_i.rst_ni = rst_ni;
endmodule
