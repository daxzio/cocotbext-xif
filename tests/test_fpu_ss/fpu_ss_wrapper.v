module fifo_v3_338AF (
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
	input wire [9:0] data_i;
	input wire push_i;
	output reg [9:0] data_o;
	input wire pop_i;
	localparam [31:0] FifoDepth = (DEPTH > 0 ? DEPTH : 1);
	reg gate_clock;
	reg [ADDR_DEPTH - 1:0] read_pointer_n;
	reg [ADDR_DEPTH - 1:0] read_pointer_q;
	reg [ADDR_DEPTH - 1:0] write_pointer_n;
	reg [ADDR_DEPTH - 1:0] write_pointer_q;
	reg [ADDR_DEPTH:0] status_cnt_n;
	reg [ADDR_DEPTH:0] status_cnt_q;
	reg [(FifoDepth * 10) - 1:0] mem_n;
	reg [(FifoDepth * 10) - 1:0] mem_q;
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
		data_o = (DEPTH == 0 ? data_i : mem_q[read_pointer_q * 10+:10]);
		mem_n = mem_q;
		gate_clock = 1'b1;
		if (push_i && ~full_o) begin
			mem_n[write_pointer_q * 10+:10] = data_i;
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
module fifo_v3_7C520 (
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
	input wire [133:0] data_i;
	input wire push_i;
	output reg [133:0] data_o;
	input wire pop_i;
	localparam [31:0] FifoDepth = (DEPTH > 0 ? DEPTH : 1);
	reg gate_clock;
	reg [ADDR_DEPTH - 1:0] read_pointer_n;
	reg [ADDR_DEPTH - 1:0] read_pointer_q;
	reg [ADDR_DEPTH - 1:0] write_pointer_n;
	reg [ADDR_DEPTH - 1:0] write_pointer_q;
	reg [ADDR_DEPTH:0] status_cnt_n;
	reg [ADDR_DEPTH:0] status_cnt_q;
	reg [(FifoDepth * 134) - 1:0] mem_n;
	reg [(FifoDepth * 134) - 1:0] mem_q;
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
		data_o = (DEPTH == 0 ? data_i : mem_q[read_pointer_q * 134+:134]);
		mem_n = mem_q;
		gate_clock = 1'b1;
		if (push_i && ~full_o) begin
			mem_n[write_pointer_q * 134+:134] = data_i;
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
module stream_fifo_6C171 (
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
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [9:0] data_i;
	input wire valid_i;
	output wire ready_o;
	output wire [9:0] data_o;
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
	fifo_v3_338AF #(
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
module stream_fifo_D7DC4 (
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
	parameter [0:0] FALL_THROUGH = 1'b0;
	parameter [31:0] DATA_WIDTH = 32;
	parameter [31:0] DEPTH = 8;
	parameter [31:0] ADDR_DEPTH = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire testmode_i;
	output wire [ADDR_DEPTH - 1:0] usage_o;
	input wire [133:0] data_i;
	input wire valid_i;
	output wire ready_o;
	output wire [133:0] data_o;
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
	fifo_v3_7C520 #(
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
module fpnew_rounding (
	abs_value_i,
	sign_i,
	round_sticky_bits_i,
	rnd_mode_i,
	effective_subtraction_i,
	abs_rounded_o,
	sign_o,
	exact_zero_o
);
	reg _sv2v_0;
	parameter [31:0] AbsWidth = 2;
	input wire [AbsWidth - 1:0] abs_value_i;
	input wire sign_i;
	input wire [1:0] round_sticky_bits_i;
	input wire [2:0] rnd_mode_i;
	input wire effective_subtraction_i;
	output wire [AbsWidth - 1:0] abs_rounded_o;
	output wire sign_o;
	output wire exact_zero_o;
	reg round_up;
	localparam [0:0] fpnew_pkg_DONT_CARE = 1'b1;
	always @(*) begin : rounding_decision
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (rnd_mode_i)
			3'b000:
				(* full_case, parallel_case *)
				case (round_sticky_bits_i)
					2'b00, 2'b01: round_up = 1'b0;
					2'b10: round_up = abs_value_i[0];
					2'b11: round_up = 1'b1;
					default: round_up = fpnew_pkg_DONT_CARE;
				endcase
			3'b001: round_up = 1'b0;
			3'b010: round_up = (|round_sticky_bits_i ? sign_i : 1'b0);
			3'b011: round_up = (|round_sticky_bits_i ? ~sign_i : 1'b0);
			3'b100: round_up = round_sticky_bits_i[1];
			3'b101: round_up = ~abs_value_i[0] & |round_sticky_bits_i;
			default: round_up = fpnew_pkg_DONT_CARE;
		endcase
	end
	assign abs_rounded_o = abs_value_i + round_up;
	assign exact_zero_o = (abs_value_i == {AbsWidth {1'sb0}}) && (round_sticky_bits_i == {2 {1'sb0}});
	assign sign_o = (exact_zero_o && effective_subtraction_i ? rnd_mode_i == 3'b010 : sign_i);
	initial _sv2v_0 = 0;
endmodule
module fpnew_classifier (
	operands_i,
	is_boxed_i,
	info_o
);
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	parameter [2:0] FpFormat = sv2v_cast_9FB13(0);
	parameter [31:0] NumOperands = 1;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	localparam [31:0] WIDTH = fpnew_pkg_fp_width(FpFormat);
	input wire [(NumOperands * WIDTH) - 1:0] operands_i;
	input wire [NumOperands - 1:0] is_boxed_i;
	output reg [(NumOperands * 8) - 1:0] info_o;
	function automatic [31:0] fpnew_pkg_exp_bits;
		input reg [2:0] fmt;
		fpnew_pkg_exp_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32];
	endfunction
	localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(FpFormat);
	function automatic [31:0] fpnew_pkg_man_bits;
		input reg [2:0] fmt;
		fpnew_pkg_man_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32];
	endfunction
	localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(FpFormat);
	genvar _gv_op_1;
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		for (_gv_op_1 = 0; _gv_op_1 < sv2v_cast_32_signed(NumOperands); _gv_op_1 = _gv_op_1 + 1) begin : gen_num_values
			localparam op = _gv_op_1;
			reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] value;
			reg is_boxed;
			reg is_normal;
			reg is_inf;
			reg is_nan;
			reg is_signalling;
			reg is_quiet;
			reg is_zero;
			reg is_subnormal;
			always @(*) begin : classify_input
				if (_sv2v_0)
					;
				value = operands_i[op * WIDTH+:WIDTH];
				is_boxed = is_boxed_i[op];
				is_normal = (is_boxed && (value[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)] != {((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1) * 1 {1'sb0}})) && (value[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)] != {((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1) * 1 {1'sb1}});
				is_zero = (is_boxed && (value[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)] == {((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1) * 1 {1'sb0}})) && (value[MAN_BITS - 1-:MAN_BITS] == {MAN_BITS * 1 {1'sb0}});
				is_subnormal = (is_boxed && (value[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)] == {((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1) * 1 {1'sb0}})) && !is_zero;
				is_inf = is_boxed && ((value[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)] == {((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1) * 1 {1'sb1}}) && (value[MAN_BITS - 1-:MAN_BITS] == {MAN_BITS * 1 {1'sb0}}));
				is_nan = !is_boxed || ((value[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)] == {((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1) * 1 {1'sb1}}) && (value[MAN_BITS - 1-:MAN_BITS] != {MAN_BITS * 1 {1'sb0}}));
				is_signalling = (is_boxed && is_nan) && (value[(MAN_BITS - 1) - ((MAN_BITS - 1) - (MAN_BITS - 1))] == 1'b0);
				is_quiet = is_nan && !is_signalling;
				info_o[(op * 8) + 7] = is_normal;
				info_o[(op * 8) + 6] = is_subnormal;
				info_o[(op * 8) + 5] = is_zero;
				info_o[(op * 8) + 4] = is_inf;
				info_o[(op * 8) + 3] = is_nan;
				info_o[(op * 8) + 2] = is_signalling;
				info_o[(op * 8) + 1] = is_quiet;
				info_o[op * 8] = is_boxed;
			end
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
module fpnew_opgroup_block_7726B (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	src_fmt_i,
	dst_fmt_i,
	int_fmt_i,
	vectorial_op_i,
	tag_i,
	simd_mask_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	out_valid_o,
	out_ready_i,
	busy_o
);
	reg _sv2v_0;
	parameter [1:0] OpGroup = 2'd0;
	parameter [31:0] Width = 32;
	parameter [0:0] EnableVectors = 1'b1;
	parameter [0:0] PulpDivsqrt = 1'b1;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	parameter [0:4] FpFmtMask = 1'sb1;
	localparam [31:0] fpnew_pkg_NUM_INT_FORMATS = 4;
	parameter [0:3] IntFmtMask = 1'sb1;
	parameter [159:0] FmtPipeRegs = {fpnew_pkg_NUM_FP_FORMATS {32'd0}};
	parameter [9:0] FmtUnitTypes = {fpnew_pkg_NUM_FP_FORMATS {2'd1}};
	parameter [1:0] PipeConfig = 2'd0;
	parameter [31:0] TrueSIMDClass = 0;
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	function automatic [31:0] fpnew_pkg_num_operands;
		input reg [1:0] grp;
		(* full_case, parallel_case *)
		case (grp)
			2'd0: fpnew_pkg_num_operands = 3;
			2'd1: fpnew_pkg_num_operands = 2;
			2'd2: fpnew_pkg_num_operands = 2;
			2'd3: fpnew_pkg_num_operands = 3;
			default: fpnew_pkg_num_operands = 0;
		endcase
	endfunction
	localparam [31:0] NUM_OPERANDS = fpnew_pkg_num_operands(OpGroup);
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_maximum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_max_fp_width = res;
		end
	endfunction
	function automatic signed [31:0] fpnew_pkg_minimum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_minimum = (a < b ? a : b);
	endfunction
	function automatic [31:0] fpnew_pkg_min_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = fpnew_pkg_max_fp_width(cfg);
			begin : sv2v_autoblock_2
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_minimum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_min_fp_width = res;
		end
	endfunction
	function automatic [31:0] fpnew_pkg_max_num_lanes;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg vec;
		fpnew_pkg_max_num_lanes = (vec ? width / fpnew_pkg_min_fp_width(cfg) : 1);
	endfunction
	localparam [31:0] NUM_LANES = fpnew_pkg_max_num_lanes(Width, FpFmtMask, EnableVectors);
	input wire clk_i;
	input wire rst_ni;
	input wire [(NUM_OPERANDS * Width) - 1:0] operands_i;
	input wire [(NUM_FORMATS * NUM_OPERANDS) - 1:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [2:0] src_fmt_i;
	input wire [2:0] dst_fmt_i;
	localparam [31:0] fpnew_pkg_INT_FORMAT_BITS = 2;
	input wire [1:0] int_fmt_i;
	input wire vectorial_op_i;
	input wire [9:0] tag_i;
	input wire [NUM_LANES - 1:0] simd_mask_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [Width - 1:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	wire [4:0] fmt_in_ready;
	wire [4:0] fmt_out_valid;
	wire [4:0] fmt_out_ready;
	wire [4:0] fmt_busy;
	wire [((Width + 15) >= 0 ? (5 * (Width + 16)) - 1 : (5 * (1 - (Width + 15))) + (Width + 14)):((Width + 15) >= 0 ? 0 : Width + 15)] fmt_outputs;
	assign in_ready_o = in_valid_i & fmt_in_ready[dst_fmt_i];
	genvar _gv_fmt_1;
	localparam [0:0] fpnew_pkg_DONT_CARE = 1'b1;
	function automatic fpnew_pkg_any_enabled_multi;
		input reg [9:0] types;
		input reg [0:4] cfg;
		reg [1:0] _sv2v_jump;
		begin
			_sv2v_jump = 2'b00;
			begin : sv2v_autoblock_3
				reg [31:0] i;
				begin : sv2v_autoblock_4
					reg [31:0] _sv2v_value_on_break;
					for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
						if (_sv2v_jump < 2'b10) begin
							_sv2v_jump = 2'b00;
							if (cfg[i] && (types[(4 - i) * 2+:2] == 2'd2)) begin
								fpnew_pkg_any_enabled_multi = 1'b1;
								_sv2v_jump = 2'b11;
							end
							_sv2v_value_on_break = i;
						end
					if (!(_sv2v_jump < 2'b10))
						i = _sv2v_value_on_break;
					if (_sv2v_jump != 2'b11)
						_sv2v_jump = 2'b00;
				end
			end
			if (_sv2v_jump == 2'b00) begin
				fpnew_pkg_any_enabled_multi = 1'b0;
				_sv2v_jump = 2'b11;
			end
		end
	endfunction
	function automatic [2:0] fpnew_pkg_get_first_enabled_multi;
		input reg [9:0] types;
		input reg [0:4] cfg;
		reg [1:0] _sv2v_jump;
		begin
			_sv2v_jump = 2'b00;
			begin : sv2v_autoblock_5
				reg [31:0] i;
				begin : sv2v_autoblock_6
					reg [31:0] _sv2v_value_on_break;
					for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
						if (_sv2v_jump < 2'b10) begin
							_sv2v_jump = 2'b00;
							if (cfg[i] && (types[(4 - i) * 2+:2] == 2'd2)) begin
								fpnew_pkg_get_first_enabled_multi = sv2v_cast_9FB13(i);
								_sv2v_jump = 2'b11;
							end
							_sv2v_value_on_break = i;
						end
					if (!(_sv2v_jump < 2'b10))
						i = _sv2v_value_on_break;
					if (_sv2v_jump != 2'b11)
						_sv2v_jump = 2'b00;
				end
			end
			if (_sv2v_jump == 2'b00) begin
				fpnew_pkg_get_first_enabled_multi = sv2v_cast_9FB13(0);
				_sv2v_jump = 2'b11;
			end
		end
	endfunction
	function automatic fpnew_pkg_is_first_enabled_multi;
		input reg [2:0] fmt;
		input reg [9:0] types;
		input reg [0:4] cfg;
		reg [1:0] _sv2v_jump;
		begin
			_sv2v_jump = 2'b00;
			begin : sv2v_autoblock_7
				reg [31:0] i;
				begin : sv2v_autoblock_8
					reg [31:0] _sv2v_value_on_break;
					for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
						if (_sv2v_jump < 2'b10) begin
							_sv2v_jump = 2'b00;
							if (cfg[i] && (types[(4 - i) * 2+:2] == 2'd2)) begin
								fpnew_pkg_is_first_enabled_multi = sv2v_cast_9FB13(i) == fmt;
								_sv2v_jump = 2'b11;
							end
							_sv2v_value_on_break = i;
						end
					if (!(_sv2v_jump < 2'b10))
						i = _sv2v_value_on_break;
					if (_sv2v_jump != 2'b11)
						_sv2v_jump = 2'b00;
				end
			end
			if (_sv2v_jump == 2'b00) begin
				fpnew_pkg_is_first_enabled_multi = 1'b0;
				_sv2v_jump = 2'b11;
			end
		end
	endfunction
	function automatic [31:0] fpnew_pkg_num_lanes;
		input reg [31:0] width;
		input reg [2:0] fmt;
		input reg vec;
		fpnew_pkg_num_lanes = (vec ? width / fpnew_pkg_fp_width(fmt) : 1);
	endfunction
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	function automatic [9:0] sv2v_cast_10;
		input reg [9:0] inp;
		sv2v_cast_10 = inp;
	endfunction
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	generate
		for (_gv_fmt_1 = 0; _gv_fmt_1 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_1 = _gv_fmt_1 + 1) begin : gen_parallel_slices
			localparam fmt = _gv_fmt_1;
			localparam [0:0] ANY_MERGED = fpnew_pkg_any_enabled_multi(FmtUnitTypes, FpFmtMask);
			localparam [0:0] IS_FIRST_MERGED = fpnew_pkg_is_first_enabled_multi(sv2v_cast_9FB13(fmt), FmtUnitTypes, FpFmtMask);
			if (FpFmtMask[fmt] && (FmtUnitTypes[(4 - fmt) * 2+:2] == 2'd1)) begin : active_format
				wire in_valid;
				assign in_valid = in_valid_i & (dst_fmt_i == fmt);
				localparam [31:0] INTERNAL_LANES = fpnew_pkg_num_lanes(Width, sv2v_cast_9FB13(fmt), EnableVectors);
				reg [INTERNAL_LANES - 1:0] mask_slice;
				always @(*) begin : sv2v_autoblock_9
					reg signed [31:0] b;
					if (_sv2v_0)
						;
					for (b = 0; b < INTERNAL_LANES; b = b + 1)
						mask_slice[b] = simd_mask_i[(NUM_LANES / INTERNAL_LANES) * b];
				end
				localparam [31:0] sv2v_uu_i_fmt_slice_NumPipeRegs = FmtPipeRegs[(4 - fmt) * 32+:32];
				localparam [31:0] sv2v_uu_i_fmt_slice_ExtRegEnaWidth = (sv2v_uu_i_fmt_slice_NumPipeRegs == 0 ? 1 : sv2v_uu_i_fmt_slice_NumPipeRegs);
				localparam [sv2v_cast_32((sv2v_cast_32(FmtPipeRegs[(4 - _gv_fmt_1) * 32+:32]) == 0 ? 1 : sv2v_cast_32(FmtPipeRegs[(4 - _gv_fmt_1) * 32+:32]))) - 1:0] sv2v_uu_i_fmt_slice_ext_reg_ena_i_0 = 1'sb0;
				fpnew_opgroup_fmt_slice_11DA3 #(
					.OpGroup(OpGroup),
					.FpFormat(sv2v_cast_9FB13(fmt)),
					.Width(Width),
					.EnableVectors(EnableVectors),
					.NumPipeRegs(FmtPipeRegs[(4 - fmt) * 32+:32]),
					.PipeConfig(PipeConfig),
					.TrueSIMDClass(TrueSIMDClass)
				) i_fmt_slice(
					.clk_i(clk_i),
					.rst_ni(rst_ni),
					.operands_i(operands_i),
					.is_boxed_i(is_boxed_i[fmt * NUM_OPERANDS+:NUM_OPERANDS]),
					.rnd_mode_i(rnd_mode_i),
					.op_i(op_i),
					.op_mod_i(op_mod_i),
					.vectorial_op_i(vectorial_op_i),
					.tag_i(tag_i),
					.simd_mask_i(mask_slice),
					.in_valid_i(in_valid),
					.in_ready_o(fmt_in_ready[fmt]),
					.flush_i(flush_i),
					.result_o(fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15)) : (((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15))) + ((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))) - 1)-:((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))]),
					.status_o(fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0) : ((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0)) + 4)-:5]),
					.extension_bit_o(fmt_outputs[(fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 10 : Width + 5)]),
					.tag_o(fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6) : ((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6)) + 9)-:10]),
					.out_valid_o(fmt_out_valid[fmt]),
					.out_ready_i(fmt_out_ready[fmt]),
					.busy_o(fmt_busy[fmt]),
					.reg_ena_i(sv2v_uu_i_fmt_slice_ext_reg_ena_i_0)
				);
			end
			else if ((FpFmtMask[fmt] && ANY_MERGED) && !IS_FIRST_MERGED) begin : merged_unused
				localparam FMT = fpnew_pkg_get_first_enabled_multi(FmtUnitTypes, FpFmtMask);
				assign fmt_in_ready[fmt] = fmt_in_ready[sv2v_cast_32_signed(FMT)];
				assign fmt_out_valid[fmt] = 1'b0;
				assign fmt_busy[fmt] = 1'b0;
				assign fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15)) : (((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15))) + ((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))) - 1)-:((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))] = {Width {fpnew_pkg_DONT_CARE}};
				assign fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0) : ((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0)) + 4)-:5] = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				assign fmt_outputs[(fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 10 : Width + 5)] = fpnew_pkg_DONT_CARE;
				assign fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6) : ((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6)) + 9)-:10] = sv2v_cast_10(fpnew_pkg_DONT_CARE);
			end
			else if (!FpFmtMask[fmt] || (FmtUnitTypes[(4 - fmt) * 2+:2] == 2'd0)) begin : disable_fmt
				assign fmt_in_ready[fmt] = 1'b0;
				assign fmt_out_valid[fmt] = 1'b0;
				assign fmt_busy[fmt] = 1'b0;
				assign fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15)) : (((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15))) + ((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))) - 1)-:((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))] = {Width {fpnew_pkg_DONT_CARE}};
				assign fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0) : ((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0)) + 4)-:5] = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				assign fmt_outputs[(fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 10 : Width + 5)] = fpnew_pkg_DONT_CARE;
				assign fmt_outputs[((Width + 15) >= 0 ? (fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6) : ((fmt * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6)) + 9)-:10] = sv2v_cast_10(fpnew_pkg_DONT_CARE);
			end
		end
	endgenerate
	function automatic [31:0] fpnew_pkg_get_num_regs_multi;
		input reg [159:0] regs;
		input reg [9:0] types;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_10
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i] && (types[(4 - i) * 2+:2] == 2'd2))
						res = fpnew_pkg_maximum(res, regs[(4 - i) * 32+:32]);
			end
			fpnew_pkg_get_num_regs_multi = res;
		end
	endfunction
	generate
		if (fpnew_pkg_any_enabled_multi(FmtUnitTypes, FpFmtMask)) begin : gen_merged_slice
			localparam FMT = fpnew_pkg_get_first_enabled_multi(FmtUnitTypes, FpFmtMask);
			localparam REG = fpnew_pkg_get_num_regs_multi(FmtPipeRegs, FmtUnitTypes, FpFmtMask);
			wire in_valid;
			assign in_valid = in_valid_i & (FmtUnitTypes[(4 - dst_fmt_i) * 2+:2] == 2'd2);
			localparam [31:0] sv2v_uu_i_multifmt_slice_NumPipeRegs = REG;
			localparam [31:0] sv2v_uu_i_multifmt_slice_ExtRegEnaWidth = (sv2v_uu_i_multifmt_slice_NumPipeRegs == 0 ? 1 : sv2v_uu_i_multifmt_slice_NumPipeRegs);
			localparam [sv2v_uu_i_multifmt_slice_ExtRegEnaWidth - 1:0] sv2v_uu_i_multifmt_slice_ext_reg_ena_i_0 = 1'sb0;
			fpnew_opgroup_multifmt_slice_204F7 #(
				.OpGroup(OpGroup),
				.Width(Width),
				.FpFmtConfig(FpFmtMask),
				.IntFmtConfig(IntFmtMask),
				.EnableVectors(EnableVectors),
				.PulpDivsqrt(PulpDivsqrt),
				.NumPipeRegs(REG),
				.PipeConfig(PipeConfig)
			) i_multifmt_slice(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.operands_i(operands_i),
				.is_boxed_i(is_boxed_i),
				.rnd_mode_i(rnd_mode_i),
				.op_i(op_i),
				.op_mod_i(op_mod_i),
				.src_fmt_i(src_fmt_i),
				.dst_fmt_i(dst_fmt_i),
				.int_fmt_i(int_fmt_i),
				.vectorial_op_i(vectorial_op_i),
				.tag_i(tag_i),
				.simd_mask_i(simd_mask_i),
				.in_valid_i(in_valid),
				.in_ready_o(fmt_in_ready[FMT]),
				.flush_i(flush_i),
				.result_o(fmt_outputs[((Width + 15) >= 0 ? (FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15)) : (((FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? Width + 15 : (Width + 15) - (Width + 15))) + ((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))) - 1)-:((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))]),
				.status_o(fmt_outputs[((Width + 15) >= 0 ? (FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0) : ((FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 15 : Width + 0)) + 4)-:5]),
				.extension_bit_o(fmt_outputs[(FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 10 : Width + 5)]),
				.tag_o(fmt_outputs[((Width + 15) >= 0 ? (FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6) : ((FMT * ((Width + 15) >= 0 ? Width + 16 : 1 - (Width + 15))) + ((Width + 15) >= 0 ? 9 : Width + 6)) + 9)-:10]),
				.out_valid_o(fmt_out_valid[FMT]),
				.out_ready_i(fmt_out_ready[FMT]),
				.busy_o(fmt_busy[FMT]),
				.reg_ena_i(sv2v_uu_i_multifmt_slice_ext_reg_ena_i_0)
			);
		end
	endgenerate
	wire [Width + 15:0] arbiter_output;
	localparam [31:0] sv2v_uu_i_arbiter_NumIn = NUM_FORMATS;
	localparam [31:0] sv2v_uu_i_arbiter_IdxWidth = $unsigned(3);
	localparam [sv2v_uu_i_arbiter_IdxWidth - 1:0] sv2v_uu_i_arbiter_ext_rr_i_0 = 1'sb0;
	rr_arb_tree_664D9_329E6 #(
		.DataType_Width(Width),
		.NumIn(NUM_FORMATS),
		.AxiVldRdy(1'b1)
	) i_arbiter(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(flush_i),
		.rr_i(sv2v_uu_i_arbiter_ext_rr_i_0),
		.req_i(fmt_out_valid),
		.gnt_o(fmt_out_ready),
		.data_i(fmt_outputs),
		.gnt_i(out_ready_i),
		.req_o(out_valid_o),
		.data_o(arbiter_output),
		.idx_o()
	);
	assign result_o = arbiter_output[Width + 15-:((Width + 15) >= 16 ? Width + 0 : 17 - (Width + 15))];
	assign status_o = arbiter_output[15-:5];
	assign extension_bit_o = arbiter_output[10];
	assign tag_o = arbiter_output[9-:10];
	assign busy_o = |fmt_busy;
	initial _sv2v_0 = 0;
endmodule
module fpnew_opgroup_fmt_slice_11DA3 (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	vectorial_op_i,
	tag_i,
	simd_mask_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	reg _sv2v_0;
	parameter [1:0] OpGroup = 2'd0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	parameter [2:0] FpFormat = sv2v_cast_9FB13(0);
	parameter [31:0] Width = 32;
	parameter [0:0] EnableVectors = 1'b1;
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	parameter [0:0] ExtRegEna = 1'b0;
	parameter [31:0] TrueSIMDClass = 0;
	function automatic [31:0] fpnew_pkg_num_operands;
		input reg [1:0] grp;
		(* full_case, parallel_case *)
		case (grp)
			2'd0: fpnew_pkg_num_operands = 3;
			2'd1: fpnew_pkg_num_operands = 2;
			2'd2: fpnew_pkg_num_operands = 2;
			2'd3: fpnew_pkg_num_operands = 3;
			default: fpnew_pkg_num_operands = 0;
		endcase
	endfunction
	localparam [31:0] NUM_OPERANDS = fpnew_pkg_num_operands(OpGroup);
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic [31:0] fpnew_pkg_num_lanes;
		input reg [31:0] width;
		input reg [2:0] fmt;
		input reg vec;
		fpnew_pkg_num_lanes = (vec ? width / fpnew_pkg_fp_width(fmt) : 1);
	endfunction
	localparam [31:0] NUM_LANES = fpnew_pkg_num_lanes(Width, FpFormat, EnableVectors);
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [(NUM_OPERANDS * Width) - 1:0] operands_i;
	input wire [NUM_OPERANDS - 1:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire vectorial_op_i;
	input wire [9:0] tag_i;
	input wire [NUM_LANES - 1:0] simd_mask_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [Width - 1:0] result_o;
	output reg [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(FpFormat);
	localparam [31:0] SIMD_WIDTH = $unsigned(Width / NUM_LANES);
	wire [NUM_LANES - 1:0] lane_in_ready;
	wire [NUM_LANES - 1:0] lane_out_valid;
	wire vectorial_op;
	wire [(NUM_LANES * FP_WIDTH) - 1:0] slice_result;
	wire [Width - 1:0] slice_regular_result;
	wire [Width - 1:0] slice_class_result;
	wire [Width - 1:0] slice_vec_class_result;
	wire [(NUM_LANES * 5) - 1:0] lane_status;
	wire [NUM_LANES - 1:0] lane_ext_bit;
	wire [(NUM_LANES * 10) - 1:0] lane_class_mask;
	wire [(NUM_LANES * 10) - 1:0] lane_tags;
	wire [NUM_LANES - 1:0] lane_masks;
	wire [NUM_LANES - 1:0] lane_vectorial;
	wire [NUM_LANES - 1:0] lane_busy;
	wire [NUM_LANES - 1:0] lane_is_class;
	wire result_is_vector;
	wire result_is_class;
	assign in_ready_o = lane_in_ready[0];
	assign vectorial_op = vectorial_op_i & EnableVectors;
	genvar _gv_lane_1;
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		for (_gv_lane_1 = 0; _gv_lane_1 < sv2v_cast_32_signed(NUM_LANES); _gv_lane_1 = _gv_lane_1 + 1) begin : gen_num_lanes
			localparam lane = _gv_lane_1;
			wire [FP_WIDTH - 1:0] local_result;
			wire local_sign;
			if ((lane == 0) || EnableVectors) begin : active_lane
				wire in_valid;
				wire out_valid;
				wire out_ready;
				reg [(NUM_OPERANDS * FP_WIDTH) - 1:0] local_operands;
				wire [FP_WIDTH - 1:0] op_result;
				wire [4:0] op_status;
				assign in_valid = in_valid_i & ((lane == 0) | vectorial_op);
				always @(*) begin : prepare_input
					if (_sv2v_0)
						;
					begin : sv2v_autoblock_1
						reg signed [31:0] i;
						for (i = 0; i < sv2v_cast_32_signed(NUM_OPERANDS); i = i + 1)
							local_operands[i * FP_WIDTH+:FP_WIDTH] = operands_i[(i * Width) + (((($unsigned(lane) + 1) * FP_WIDTH) - 1) >= ($unsigned(lane) * FP_WIDTH) ? (($unsigned(lane) + 1) * FP_WIDTH) - 1 : (((($unsigned(lane) + 1) * FP_WIDTH) - 1) + (((($unsigned(lane) + 1) * FP_WIDTH) - 1) >= ($unsigned(lane) * FP_WIDTH) ? (((($unsigned(lane) + 1) * FP_WIDTH) - 1) - ($unsigned(lane) * FP_WIDTH)) + 1 : (($unsigned(lane) * FP_WIDTH) - ((($unsigned(lane) + 1) * FP_WIDTH) - 1)) + 1)) - 1)-:(((($unsigned(lane) + 1) * FP_WIDTH) - 1) >= ($unsigned(lane) * FP_WIDTH) ? (((($unsigned(lane) + 1) * FP_WIDTH) - 1) - ($unsigned(lane) * FP_WIDTH)) + 1 : (($unsigned(lane) * FP_WIDTH) - ((($unsigned(lane) + 1) * FP_WIDTH) - 1)) + 1)];
					end
				end
				if (OpGroup == 2'd0) begin : lane_instance
					fpnew_fma_0C4F7 #(
						.FpFormat(FpFormat),
						.NumPipeRegs(NumPipeRegs),
						.PipeConfig(PipeConfig)
					) i_fma(
						.clk_i(clk_i),
						.rst_ni(rst_ni),
						.operands_i(local_operands),
						.is_boxed_i(is_boxed_i[NUM_OPERANDS - 1:0]),
						.rnd_mode_i(rnd_mode_i),
						.op_i(op_i),
						.op_mod_i(op_mod_i),
						.tag_i(tag_i),
						.mask_i(simd_mask_i[lane]),
						.aux_i(vectorial_op),
						.in_valid_i(in_valid),
						.in_ready_o(lane_in_ready[lane]),
						.flush_i(flush_i),
						.result_o(op_result),
						.status_o(op_status),
						.extension_bit_o(lane_ext_bit[lane]),
						.tag_o(lane_tags[lane * 10+:10]),
						.mask_o(lane_masks[lane]),
						.aux_o(lane_vectorial[lane]),
						.out_valid_o(out_valid),
						.out_ready_i(out_ready),
						.busy_o(lane_busy[lane]),
						.reg_ena_i(reg_ena_i)
					);
					assign lane_is_class[lane] = 1'b0;
					assign lane_class_mask[lane * 10+:10] = 10'b0000000001;
				end
				else if (OpGroup == 2'd1) begin
					;
				end
				else if (OpGroup == 2'd2) begin : lane_instance
					fpnew_noncomp_79CB0 #(
						.FpFormat(FpFormat),
						.NumPipeRegs(NumPipeRegs),
						.PipeConfig(PipeConfig)
					) i_noncomp(
						.clk_i(clk_i),
						.rst_ni(rst_ni),
						.operands_i(local_operands),
						.is_boxed_i(is_boxed_i[NUM_OPERANDS - 1:0]),
						.rnd_mode_i(rnd_mode_i),
						.op_i(op_i),
						.op_mod_i(op_mod_i),
						.tag_i(tag_i),
						.mask_i(simd_mask_i[lane]),
						.aux_i(vectorial_op),
						.in_valid_i(in_valid),
						.in_ready_o(lane_in_ready[lane]),
						.flush_i(flush_i),
						.result_o(op_result),
						.status_o(op_status),
						.extension_bit_o(lane_ext_bit[lane]),
						.class_mask_o(lane_class_mask[lane * 10+:10]),
						.is_class_o(lane_is_class[lane]),
						.tag_o(lane_tags[lane * 10+:10]),
						.mask_o(lane_masks[lane]),
						.aux_o(lane_vectorial[lane]),
						.out_valid_o(out_valid),
						.out_ready_i(out_ready),
						.busy_o(lane_busy[lane]),
						.reg_ena_i(reg_ena_i)
					);
				end
				assign out_ready = out_ready_i & ((lane == 0) | result_is_vector);
				assign lane_out_valid[lane] = out_valid & ((lane == 0) | result_is_vector);
				assign local_result = (lane_out_valid[lane] | ExtRegEna ? op_result : {FP_WIDTH {lane_ext_bit[0]}});
				assign lane_status[lane * 5+:5] = (lane_out_valid[lane] | ExtRegEna ? op_status : {5 {1'sb0}});
			end
			else begin : genblk1
				assign lane_out_valid[lane] = 1'b0;
				assign lane_in_ready[lane] = 1'b0;
				assign local_result = {FP_WIDTH {lane_ext_bit[0]}};
				assign lane_status[lane * 5+:5] = 1'sb0;
				assign lane_busy[lane] = 1'b0;
				assign lane_is_class[lane] = 1'b0;
			end
			assign slice_result[(($unsigned(lane) + 1) * FP_WIDTH) - 1:$unsigned(lane) * FP_WIDTH] = local_result;
			if (TrueSIMDClass && (SIMD_WIDTH >= 10)) begin : vectorial_true_class
				assign slice_vec_class_result[lane * SIMD_WIDTH+:10] = lane_class_mask[lane * 10+:10];
				assign slice_vec_class_result[((lane + 1) * SIMD_WIDTH) - 1-:SIMD_WIDTH - 10] = 1'sb0;
			end
			else if (((lane + 1) * 8) <= Width) begin : vectorial_class
				assign local_sign = (((lane_class_mask[lane * 10+:10] == 10'b0000000001) || (lane_class_mask[lane * 10+:10] == 10'b0000000010)) || (lane_class_mask[lane * 10+:10] == 10'b0000000100)) || (lane_class_mask[lane * 10+:10] == 10'b0000001000);
				assign slice_vec_class_result[((lane + 1) * 8) - 1:lane * 8] = {local_sign, ~local_sign, lane_class_mask[lane * 10+:10] == 10'b1000000000, lane_class_mask[lane * 10+:10] == 10'b0100000000, (lane_class_mask[lane * 10+:10] == 10'b0000010000) || (lane_class_mask[lane * 10+:10] == 10'b0000001000), (lane_class_mask[lane * 10+:10] == 10'b0000100000) || (lane_class_mask[lane * 10+:10] == 10'b0000000100), (lane_class_mask[lane * 10+:10] == 10'b0001000000) || (lane_class_mask[lane * 10+:10] == 10'b0000000010), (lane_class_mask[lane * 10+:10] == 10'b0010000000) || (lane_class_mask[lane * 10+:10] == 10'b0000000001)};
			end
		end
	endgenerate
	assign result_is_vector = lane_vectorial[0];
	assign result_is_class = lane_is_class[0];
	assign slice_regular_result = $signed({extension_bit_o, slice_result});
	localparam [31:0] CLASS_VEC_BITS = ((NUM_LANES * 8) > Width ? 8 * (Width / 8) : NUM_LANES * 8);
	generate
		if (!(TrueSIMDClass && (SIMD_WIDTH >= 10))) begin : genblk2
			if (CLASS_VEC_BITS < Width) begin : pad_vectorial_class
				assign slice_vec_class_result[Width - 1:CLASS_VEC_BITS] = 1'sb0;
			end
		end
	endgenerate
	assign slice_class_result = (result_is_vector ? slice_vec_class_result : lane_class_mask[0+:10]);
	assign result_o = (result_is_class ? slice_class_result : slice_regular_result);
	assign extension_bit_o = lane_ext_bit[0];
	assign tag_o = lane_tags[0+:10];
	assign busy_o = |lane_busy;
	assign out_valid_o = lane_out_valid[0];
	always @(*) begin : output_processing
		reg [4:0] temp_status;
		if (_sv2v_0)
			;
		temp_status = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < sv2v_cast_32_signed(NUM_LANES); i = i + 1)
				temp_status = temp_status | (lane_status[i * 5+:5] & {5 {lane_masks[i]}});
		end
		status_o = temp_status;
	end
	initial _sv2v_0 = 0;
endmodule
module fpnew_opgroup_multifmt_slice_204F7 (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	src_fmt_i,
	dst_fmt_i,
	int_fmt_i,
	vectorial_op_i,
	tag_i,
	simd_mask_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	reg _sv2v_0;
	parameter [1:0] OpGroup = 2'd3;
	parameter [31:0] Width = 64;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	parameter [0:4] FpFmtConfig = 1'sb1;
	localparam [31:0] fpnew_pkg_NUM_INT_FORMATS = 4;
	parameter [0:3] IntFmtConfig = 1'sb1;
	parameter [0:0] EnableVectors = 1'b1;
	parameter [0:0] PulpDivsqrt = 1'b1;
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	parameter [0:0] ExtRegEna = 1'b0;
	function automatic [31:0] fpnew_pkg_num_operands;
		input reg [1:0] grp;
		(* full_case, parallel_case *)
		case (grp)
			2'd0: fpnew_pkg_num_operands = 3;
			2'd1: fpnew_pkg_num_operands = 2;
			2'd2: fpnew_pkg_num_operands = 2;
			2'd3: fpnew_pkg_num_operands = 3;
			default: fpnew_pkg_num_operands = 0;
		endcase
	endfunction
	localparam [31:0] NUM_OPERANDS = fpnew_pkg_num_operands(OpGroup);
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_maximum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_max_fp_width = res;
		end
	endfunction
	function automatic signed [31:0] fpnew_pkg_minimum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_minimum = (a < b ? a : b);
	endfunction
	function automatic [31:0] fpnew_pkg_min_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = fpnew_pkg_max_fp_width(cfg);
			begin : sv2v_autoblock_2
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_minimum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_min_fp_width = res;
		end
	endfunction
	function automatic [31:0] fpnew_pkg_max_num_lanes;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg vec;
		fpnew_pkg_max_num_lanes = (vec ? width / fpnew_pkg_min_fp_width(cfg) : 1);
	endfunction
	localparam [31:0] NUM_SIMD_LANES = fpnew_pkg_max_num_lanes(Width, FpFmtConfig, EnableVectors);
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [(NUM_OPERANDS * Width) - 1:0] operands_i;
	input wire [(NUM_FORMATS * NUM_OPERANDS) - 1:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [2:0] src_fmt_i;
	input wire [2:0] dst_fmt_i;
	localparam [31:0] fpnew_pkg_INT_FORMAT_BITS = 2;
	input wire [1:0] int_fmt_i;
	input wire vectorial_op_i;
	input wire [9:0] tag_i;
	input wire [NUM_SIMD_LANES - 1:0] simd_mask_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [Width - 1:0] result_o;
	output reg [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	generate
		if (((OpGroup == 2'd1) && !PulpDivsqrt) && !((FpFmtConfig[0] == 1) && (FpFmtConfig[1:4] == {4 {1'sb0}}))) begin : genblk1
			initial begin
				$display("Fatal [elaboration] ../rtl/fpnew/fpnew_opgroup_multifmt_slice.sv:71:5 - fpnew_opgroup_multifmt_slice.genblk1\n msg: ", "T-Head-based DivSqrt unit supported only in FP32-only configurations. Set PulpDivsqrt to 1 not to use the PULP DivSqrt unit or set Features.FpFmtMask to support only FP32");
				$finish(1);
			end
		end
	endgenerate
	localparam [31:0] MAX_FP_WIDTH = fpnew_pkg_max_fp_width(FpFmtConfig);
	function automatic [31:0] fpnew_pkg_max_int_width;
		input reg [0:3] cfg;
		reg [31:0] w0;
		reg [31:0] w1;
		reg [31:0] w2;
		reg [31:0] w3;
		begin
			w0 = (cfg[0] ? 8 : 0);
			w1 = (cfg[1] ? 16 : 0);
			w2 = (cfg[2] ? 32 : 0);
			w3 = (cfg[3] ? 64 : 0);
			fpnew_pkg_max_int_width = fpnew_pkg_maximum(fpnew_pkg_maximum(fpnew_pkg_maximum(w0, w1), w2), w3);
		end
	endfunction
	localparam [31:0] MAX_INT_WIDTH = fpnew_pkg_max_int_width(IntFmtConfig);
	localparam [31:0] NUM_LANES = fpnew_pkg_max_num_lanes(Width, FpFmtConfig, 1'b1);
	localparam [31:0] NUM_INT_FORMATS = fpnew_pkg_NUM_INT_FORMATS;
	localparam [31:0] FMT_BITS = fpnew_pkg_maximum(3, 2);
	localparam [31:0] AUX_BITS = FMT_BITS + 2;
	wire [NUM_LANES - 1:0] lane_in_ready;
	wire [NUM_LANES - 1:0] lane_out_valid;
	wire [NUM_LANES - 1:0] divsqrt_done;
	wire [NUM_LANES - 1:0] divsqrt_ready;
	wire vectorial_op;
	wire [FMT_BITS - 1:0] dst_fmt;
	wire [AUX_BITS - 1:0] aux_data;
	wire dst_fmt_is_int;
	wire dst_is_cpk;
	wire [1:0] dst_vec_op;
	wire [2:0] target_aux_d;
	wire is_up_cast;
	wire is_down_cast;
	wire [(NUM_FORMATS * Width) - 1:0] fmt_slice_result;
	wire [(NUM_INT_FORMATS * Width) - 1:0] ifmt_slice_result;
	wire [Width - 1:0] conv_target_d;
	wire [Width - 1:0] conv_target_q;
	wire [(NUM_LANES * 5) - 1:0] lane_status;
	wire [NUM_LANES - 1:0] lane_ext_bit;
	wire [(NUM_LANES * 10) - 1:0] lane_tags;
	wire [NUM_LANES - 1:0] lane_masks;
	wire [(NUM_LANES * AUX_BITS) - 1:0] lane_aux;
	wire [NUM_LANES - 1:0] lane_busy;
	wire result_is_vector;
	wire [FMT_BITS - 1:0] result_fmt;
	wire result_fmt_is_int;
	wire result_is_cpk;
	wire [1:0] result_vec_op;
	wire simd_synch_rdy;
	wire simd_synch_done;
	assign in_ready_o = lane_in_ready[0];
	assign vectorial_op = vectorial_op_i & EnableVectors;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	assign dst_fmt_is_int = (OpGroup == 2'd3) & (op_i == sv2v_cast_7BCAE(11));
	assign dst_is_cpk = (OpGroup == 2'd3) & ((op_i == sv2v_cast_7BCAE(13)) || (op_i == sv2v_cast_7BCAE(14)));
	assign dst_vec_op = (OpGroup == 2'd3) & {op_i == sv2v_cast_7BCAE(14), op_mod_i};
	assign is_up_cast = fpnew_pkg_fp_width(dst_fmt_i) > fpnew_pkg_fp_width(src_fmt_i);
	assign is_down_cast = fpnew_pkg_fp_width(dst_fmt_i) < fpnew_pkg_fp_width(src_fmt_i);
	assign dst_fmt = (dst_fmt_is_int ? int_fmt_i : dst_fmt_i);
	assign aux_data = {dst_fmt_is_int, vectorial_op, dst_fmt};
	assign target_aux_d = {dst_vec_op, dst_is_cpk};
	generate
		if (OpGroup == 2'd3) begin : conv_target
			assign conv_target_d = (dst_is_cpk ? operands_i[2 * Width+:Width] : operands_i[Width+:Width]);
		end
		else begin : not_conv_target
			assign conv_target_d = 1'sb0;
		end
	endgenerate
	reg [4:0] is_boxed_1op;
	reg [9:0] is_boxed_2op;
	always @(*) begin : boxed_2op
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_3
			reg signed [31:0] fmt;
			for (fmt = 0; fmt < NUM_FORMATS; fmt = fmt + 1)
				begin
					is_boxed_1op[fmt] = is_boxed_i[fmt * NUM_OPERANDS];
					is_boxed_2op[fmt * 2+:2] = is_boxed_i[(fmt * NUM_OPERANDS) + 1-:2];
				end
		end
	end
	genvar _gv_lane_2;
	localparam [0:4] fpnew_pkg_CPK_FORMATS = 5'b11000;
	function automatic [0:4] fpnew_pkg_get_conv_lane_formats;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg [31:0] lane_no;
		reg [0:4] res;
		begin
			begin : sv2v_autoblock_4
				reg [31:0] fmt;
				for (fmt = 0; fmt < fpnew_pkg_NUM_FP_FORMATS; fmt = fmt + 1)
					res[fmt] = cfg[fmt] && (((width / fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt))) > lane_no) || (fpnew_pkg_CPK_FORMATS[fmt] && (lane_no < 2)));
			end
			fpnew_pkg_get_conv_lane_formats = res;
		end
	endfunction
	function automatic [1:0] sv2v_cast_2D3A8;
		input reg [1:0] inp;
		sv2v_cast_2D3A8 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_int_width;
		input reg [1:0] ifmt;
		(* full_case, parallel_case *)
		case (ifmt)
			sv2v_cast_2D3A8(0): fpnew_pkg_int_width = 8;
			sv2v_cast_2D3A8(1): fpnew_pkg_int_width = 16;
			sv2v_cast_2D3A8(2): fpnew_pkg_int_width = 32;
			sv2v_cast_2D3A8(3): fpnew_pkg_int_width = 64;
			default: fpnew_pkg_int_width = 8;
		endcase
	endfunction
	function automatic [0:3] fpnew_pkg_get_conv_lane_int_formats;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg [0:3] icfg;
		input reg [31:0] lane_no;
		reg [0:3] res;
		reg [0:4] lanefmts;
		begin
			res = 1'sb0;
			lanefmts = fpnew_pkg_get_conv_lane_formats(width, cfg, lane_no);
			begin : sv2v_autoblock_5
				reg [31:0] ifmt;
				for (ifmt = 0; ifmt < fpnew_pkg_NUM_INT_FORMATS; ifmt = ifmt + 1)
					begin : sv2v_autoblock_6
						reg [31:0] fmt;
						for (fmt = 0; fmt < fpnew_pkg_NUM_FP_FORMATS; fmt = fmt + 1)
							res[ifmt] = res[ifmt] | ((icfg[ifmt] && lanefmts[fmt]) && (fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt)) == fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt))));
					end
			end
			fpnew_pkg_get_conv_lane_int_formats = res;
		end
	endfunction
	function automatic [0:4] fpnew_pkg_get_lane_formats;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg [31:0] lane_no;
		reg [0:4] res;
		begin
			begin : sv2v_autoblock_7
				reg [31:0] fmt;
				for (fmt = 0; fmt < fpnew_pkg_NUM_FP_FORMATS; fmt = fmt + 1)
					res[fmt] = cfg[fmt] & ((width / fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt))) > lane_no);
			end
			fpnew_pkg_get_lane_formats = res;
		end
	endfunction
	function automatic [0:3] fpnew_pkg_get_lane_int_formats;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg [0:3] icfg;
		input reg [31:0] lane_no;
		reg [0:3] res;
		reg [0:4] lanefmts;
		begin
			res = 1'sb0;
			lanefmts = fpnew_pkg_get_lane_formats(width, cfg, lane_no);
			begin : sv2v_autoblock_8
				reg [31:0] ifmt;
				for (ifmt = 0; ifmt < fpnew_pkg_NUM_INT_FORMATS; ifmt = ifmt + 1)
					begin : sv2v_autoblock_9
						reg [31:0] fmt;
						for (fmt = 0; fmt < fpnew_pkg_NUM_FP_FORMATS; fmt = fmt + 1)
							if (fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt)) == fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt)))
								res[ifmt] = res[ifmt] | (icfg[ifmt] && lanefmts[fmt]);
					end
			end
			fpnew_pkg_get_lane_int_formats = res;
		end
	endfunction
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	function automatic [4:0] sv2v_cast_D5AB9;
		input reg [4:0] inp;
		sv2v_cast_D5AB9 = inp;
	endfunction
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		for (_gv_lane_2 = 0; _gv_lane_2 < sv2v_cast_32_signed(NUM_LANES); _gv_lane_2 = _gv_lane_2 + 1) begin : gen_num_lanes
			localparam lane = _gv_lane_2;
			localparam [31:0] LANE = $unsigned(lane);
			localparam [0:4] ACTIVE_FORMATS = fpnew_pkg_get_lane_formats(Width, FpFmtConfig, LANE);
			localparam [0:3] ACTIVE_INT_FORMATS = fpnew_pkg_get_lane_int_formats(Width, FpFmtConfig, IntFmtConfig, LANE);
			localparam [31:0] MAX_WIDTH = fpnew_pkg_max_fp_width(ACTIVE_FORMATS);
			localparam [0:4] CONV_FORMATS = fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, LANE);
			localparam [0:3] CONV_INT_FORMATS = fpnew_pkg_get_conv_lane_int_formats(Width, FpFmtConfig, IntFmtConfig, LANE);
			localparam [31:0] CONV_WIDTH = fpnew_pkg_max_fp_width(CONV_FORMATS);
			localparam [0:4] LANE_FORMATS = (OpGroup == 2'd3 ? CONV_FORMATS : ACTIVE_FORMATS);
			localparam [31:0] LANE_WIDTH = (OpGroup == 2'd3 ? CONV_WIDTH : MAX_WIDTH);
			wire [LANE_WIDTH - 1:0] local_result;
			if ((lane == 0) || EnableVectors) begin : active_lane
				wire in_valid;
				wire out_valid;
				wire out_ready;
				reg [(NUM_OPERANDS * LANE_WIDTH) - 1:0] local_operands;
				wire [LANE_WIDTH - 1:0] op_result;
				wire [4:0] op_status;
				assign in_valid = in_valid_i & ((lane == 0) | vectorial_op);
				always @(*) begin : prepare_input
					if (_sv2v_0)
						;
					begin : sv2v_autoblock_10
						reg [31:0] i;
						for (i = 0; i < NUM_OPERANDS; i = i + 1)
							if (i == 2)
								local_operands[i * (OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))] = operands_i[i * Width+:Width] >> (LANE * fpnew_pkg_fp_width(dst_fmt_i));
							else
								local_operands[i * (OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))] = operands_i[i * Width+:Width] >> (LANE * fpnew_pkg_fp_width(src_fmt_i));
					end
					if (OpGroup == 2'd3) begin
						if (op_i == sv2v_cast_7BCAE(12))
							local_operands[0+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))] = operands_i[0+:Width] >> (LANE * fpnew_pkg_int_width(int_fmt_i));
						else if (op_i == sv2v_cast_7BCAE(10)) begin
							if ((vectorial_op && op_mod_i) && is_up_cast)
								local_operands[0+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))] = operands_i[0+:Width] >> ((LANE * fpnew_pkg_fp_width(src_fmt_i)) + (MAX_FP_WIDTH / 2));
						end
						else if (dst_is_cpk) begin
							if (lane == 1)
								local_operands[0+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))] = operands_i[Width + (LANE_WIDTH - 1)-:LANE_WIDTH];
						end
					end
				end
				if (OpGroup == 2'd0) begin : lane_instance
					fpnew_fma_multi_1C544_9CB9D #(
						.AuxType_AUX_BITS(AUX_BITS),
						.FpFmtConfig(LANE_FORMATS),
						.NumPipeRegs(NumPipeRegs),
						.PipeConfig(PipeConfig)
					) i_fpnew_fma_multi(
						.clk_i(clk_i),
						.rst_ni(rst_ni),
						.operands_i(local_operands),
						.is_boxed_i(is_boxed_i),
						.rnd_mode_i(rnd_mode_i),
						.op_i(op_i),
						.op_mod_i(op_mod_i),
						.src_fmt_i(src_fmt_i),
						.dst_fmt_i(dst_fmt_i),
						.tag_i(tag_i),
						.mask_i(simd_mask_i[lane]),
						.aux_i(aux_data),
						.in_valid_i(in_valid),
						.in_ready_o(lane_in_ready[lane]),
						.flush_i(flush_i),
						.result_o(op_result),
						.status_o(op_status),
						.extension_bit_o(lane_ext_bit[lane]),
						.tag_o(lane_tags[lane * 10+:10]),
						.mask_o(lane_masks[lane]),
						.aux_o(lane_aux[lane * AUX_BITS+:AUX_BITS]),
						.out_valid_o(out_valid),
						.out_ready_i(out_ready),
						.busy_o(lane_busy[lane]),
						.reg_ena_i(reg_ena_i)
					);
				end
				else if (OpGroup == 2'd1) begin : lane_instance
					if ((!PulpDivsqrt && LANE_FORMATS[0]) && (LANE_FORMATS[1:4] == {4 {1'sb0}})) begin : genblk1
						fpnew_divsqrt_th_32_0D3C3_F603E #(
							.AuxType_AUX_BITS(AUX_BITS),
							.NumPipeRegs(NumPipeRegs),
							.PipeConfig(PipeConfig)
						) i_fpnew_divsqrt_multi_th(
							.clk_i(clk_i),
							.rst_ni(rst_ni),
							.operands_i(local_operands[0+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2))))) * 2]),
							.is_boxed_i(is_boxed_2op),
							.rnd_mode_i(rnd_mode_i),
							.op_i(op_i),
							.tag_i(tag_i),
							.mask_i(simd_mask_i[lane]),
							.aux_i(aux_data),
							.in_valid_i(in_valid),
							.in_ready_o(lane_in_ready[lane]),
							.flush_i(flush_i),
							.result_o(op_result),
							.status_o(op_status),
							.extension_bit_o(lane_ext_bit[lane]),
							.tag_o(lane_tags[lane * 10+:10]),
							.mask_o(lane_masks[lane]),
							.aux_o(lane_aux[lane * AUX_BITS+:AUX_BITS]),
							.out_valid_o(out_valid),
							.out_ready_i(out_ready),
							.busy_o(lane_busy[lane]),
							.reg_ena_i(reg_ena_i)
						);
					end
					else begin : genblk1
						fpnew_divsqrt_multi_71FDB_3B5C2 #(
							.AuxType_AUX_BITS(AUX_BITS),
							.FpFmtConfig(LANE_FORMATS),
							.NumPipeRegs(NumPipeRegs),
							.PipeConfig(PipeConfig)
						) i_fpnew_divsqrt_multi(
							.clk_i(clk_i),
							.rst_ni(rst_ni),
							.operands_i(local_operands[0+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2))))) * 2]),
							.is_boxed_i(is_boxed_2op),
							.rnd_mode_i(rnd_mode_i),
							.op_i(op_i),
							.dst_fmt_i(dst_fmt_i),
							.tag_i(tag_i),
							.mask_i(simd_mask_i[lane]),
							.aux_i(aux_data),
							.vectorial_op_i(vectorial_op),
							.in_valid_i(in_valid),
							.in_ready_o(lane_in_ready[lane]),
							.divsqrt_done_o(divsqrt_done[lane]),
							.simd_synch_done_i(simd_synch_done),
							.divsqrt_ready_o(divsqrt_ready[lane]),
							.simd_synch_rdy_i(simd_synch_rdy),
							.flush_i(flush_i),
							.result_o(op_result),
							.status_o(op_status),
							.extension_bit_o(lane_ext_bit[lane]),
							.tag_o(lane_tags[lane * 10+:10]),
							.mask_o(lane_masks[lane]),
							.aux_o(lane_aux[lane * AUX_BITS+:AUX_BITS]),
							.out_valid_o(out_valid),
							.out_ready_i(out_ready),
							.busy_o(lane_busy[lane]),
							.reg_ena_i(reg_ena_i)
						);
					end
				end
				else if (OpGroup == 2'd2) begin
					;
				end
				else if (OpGroup == 2'd3) begin : lane_instance
					fpnew_cast_multi_83014_AEEB6 #(
						.AuxType_AUX_BITS(AUX_BITS),
						.FpFmtConfig(LANE_FORMATS),
						.IntFmtConfig(CONV_INT_FORMATS),
						.NumPipeRegs(NumPipeRegs),
						.PipeConfig(PipeConfig)
					) i_fpnew_cast_multi(
						.clk_i(clk_i),
						.rst_ni(rst_ni),
						.operands_i(local_operands[0+:(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))) : fpnew_pkg_max_fp_width(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))]),
						.is_boxed_i(is_boxed_1op),
						.rnd_mode_i(rnd_mode_i),
						.op_i(op_i),
						.op_mod_i(op_mod_i),
						.src_fmt_i(src_fmt_i),
						.dst_fmt_i(dst_fmt_i),
						.int_fmt_i(int_fmt_i),
						.tag_i(tag_i),
						.mask_i(simd_mask_i[lane]),
						.aux_i(aux_data),
						.in_valid_i(in_valid),
						.in_ready_o(lane_in_ready[lane]),
						.flush_i(flush_i),
						.result_o(op_result),
						.status_o(op_status),
						.extension_bit_o(lane_ext_bit[lane]),
						.tag_o(lane_tags[lane * 10+:10]),
						.mask_o(lane_masks[lane]),
						.aux_o(lane_aux[lane * AUX_BITS+:AUX_BITS]),
						.out_valid_o(out_valid),
						.out_ready_i(out_ready),
						.busy_o(lane_busy[lane]),
						.reg_ena_i(reg_ena_i)
					);
				end
				assign out_ready = out_ready_i & ((lane == 0) | result_is_vector);
				assign lane_out_valid[lane] = out_valid & ((lane == 0) | result_is_vector);
				assign local_result = (lane_out_valid[lane] | ExtRegEna ? op_result : {(OpGroup == 2'd3 ? fpnew_pkg_max_fp_width(sv2v_cast_D5AB9(fpnew_pkg_get_conv_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2))))) : fpnew_pkg_max_fp_width(sv2v_cast_D5AB9(fpnew_pkg_get_lane_formats(Width, FpFmtConfig, sv2v_cast_32($unsigned(_gv_lane_2)))))) {lane_ext_bit[0]}});
				assign lane_status[lane * 5+:5] = (lane_out_valid[lane] | ExtRegEna ? op_status : {5 {1'sb0}});
			end
			else begin : inactive_lane
				assign lane_out_valid[lane] = 1'b0;
				assign lane_in_ready[lane] = 1'b0;
				assign lane_aux[lane * AUX_BITS+:AUX_BITS] = 1'b0;
				assign lane_masks[lane] = 1'b1;
				assign lane_tags[lane * 10+:10] = 1'b0;
				assign divsqrt_done[lane] = 1'b0;
				assign divsqrt_ready[lane] = 1'b0;
				assign lane_ext_bit[lane] = 1'b1;
				assign local_result = {LANE_WIDTH {lane_ext_bit[0]}};
				assign lane_status[lane * 5+:5] = 1'sb0;
				assign lane_busy[lane] = 1'b0;
			end
			genvar _gv_fmt_2;
			for (_gv_fmt_2 = 0; _gv_fmt_2 < NUM_FORMATS; _gv_fmt_2 = _gv_fmt_2 + 1) begin : pack_fp_result
				localparam fmt = _gv_fmt_2;
				localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
				if (ACTIVE_FORMATS[fmt]) begin : genblk1
					assign fmt_slice_result[(fmt * Width) + ((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((LANE + 1) * FP_WIDTH) - 1 : ((((LANE + 1) * FP_WIDTH) - 1) + ((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((((LANE + 1) * FP_WIDTH) - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (((LANE + 1) * FP_WIDTH) - 1)) + 1)) - 1)-:((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((((LANE + 1) * FP_WIDTH) - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (((LANE + 1) * FP_WIDTH) - 1)) + 1)] = local_result[FP_WIDTH - 1:0];
				end
				else if (((LANE + 1) * FP_WIDTH) <= Width) begin : genblk1
					assign fmt_slice_result[(fmt * Width) + ((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((LANE + 1) * FP_WIDTH) - 1 : ((((LANE + 1) * FP_WIDTH) - 1) + ((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((((LANE + 1) * FP_WIDTH) - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (((LANE + 1) * FP_WIDTH) - 1)) + 1)) - 1)-:((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((((LANE + 1) * FP_WIDTH) - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (((LANE + 1) * FP_WIDTH) - 1)) + 1)] = {((((LANE + 1) * FP_WIDTH) - 1) >= (LANE * FP_WIDTH) ? ((((LANE + 1) * FP_WIDTH) - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (((LANE + 1) * FP_WIDTH) - 1)) + 1) {lane_ext_bit[LANE]}};
				end
				else if ((LANE * FP_WIDTH) < Width) begin : genblk1
					assign fmt_slice_result[(fmt * Width) + ((Width - 1) >= (LANE * FP_WIDTH) ? Width - 1 : ((Width - 1) + ((Width - 1) >= (LANE * FP_WIDTH) ? ((Width - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (Width - 1)) + 1)) - 1)-:((Width - 1) >= (LANE * FP_WIDTH) ? ((Width - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (Width - 1)) + 1)] = {((Width - 1) >= (LANE * FP_WIDTH) ? ((Width - 1) - (LANE * FP_WIDTH)) + 1 : ((LANE * FP_WIDTH) - (Width - 1)) + 1) {lane_ext_bit[LANE]}};
				end
			end
			if (OpGroup == 2'd3) begin : int_results_enabled
				genvar _gv_ifmt_1;
				for (_gv_ifmt_1 = 0; _gv_ifmt_1 < NUM_INT_FORMATS; _gv_ifmt_1 = _gv_ifmt_1 + 1) begin : pack_int_result
					localparam ifmt = _gv_ifmt_1;
					localparam [31:0] INT_WIDTH = fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt));
					if (ACTIVE_INT_FORMATS[ifmt]) begin : genblk1
						assign ifmt_slice_result[(ifmt * Width) + ((((LANE + 1) * INT_WIDTH) - 1) >= (LANE * INT_WIDTH) ? ((LANE + 1) * INT_WIDTH) - 1 : ((((LANE + 1) * INT_WIDTH) - 1) + ((((LANE + 1) * INT_WIDTH) - 1) >= (LANE * INT_WIDTH) ? ((((LANE + 1) * INT_WIDTH) - 1) - (LANE * INT_WIDTH)) + 1 : ((LANE * INT_WIDTH) - (((LANE + 1) * INT_WIDTH) - 1)) + 1)) - 1)-:((((LANE + 1) * INT_WIDTH) - 1) >= (LANE * INT_WIDTH) ? ((((LANE + 1) * INT_WIDTH) - 1) - (LANE * INT_WIDTH)) + 1 : ((LANE * INT_WIDTH) - (((LANE + 1) * INT_WIDTH) - 1)) + 1)] = local_result[INT_WIDTH - 1:0];
					end
					else if (((LANE + 1) * INT_WIDTH) <= Width) begin : genblk1
						assign ifmt_slice_result[(ifmt * Width) + ((((LANE + 1) * INT_WIDTH) - 1) >= (LANE * INT_WIDTH) ? ((LANE + 1) * INT_WIDTH) - 1 : ((((LANE + 1) * INT_WIDTH) - 1) + ((((LANE + 1) * INT_WIDTH) - 1) >= (LANE * INT_WIDTH) ? ((((LANE + 1) * INT_WIDTH) - 1) - (LANE * INT_WIDTH)) + 1 : ((LANE * INT_WIDTH) - (((LANE + 1) * INT_WIDTH) - 1)) + 1)) - 1)-:((((LANE + 1) * INT_WIDTH) - 1) >= (LANE * INT_WIDTH) ? ((((LANE + 1) * INT_WIDTH) - 1) - (LANE * INT_WIDTH)) + 1 : ((LANE * INT_WIDTH) - (((LANE + 1) * INT_WIDTH) - 1)) + 1)] = 1'sb0;
					end
					else if ((LANE * INT_WIDTH) < Width) begin : genblk1
						assign ifmt_slice_result[(ifmt * Width) + ((Width - 1) >= (LANE * INT_WIDTH) ? Width - 1 : ((Width - 1) + ((Width - 1) >= (LANE * INT_WIDTH) ? ((Width - 1) - (LANE * INT_WIDTH)) + 1 : ((LANE * INT_WIDTH) - (Width - 1)) + 1)) - 1)-:((Width - 1) >= (LANE * INT_WIDTH) ? ((Width - 1) - (LANE * INT_WIDTH)) + 1 : ((LANE * INT_WIDTH) - (Width - 1)) + 1)] = 1'sb0;
					end
				end
			end
		end
	endgenerate
	genvar _gv_fmt_3;
	generate
		for (_gv_fmt_3 = 0; _gv_fmt_3 < NUM_FORMATS; _gv_fmt_3 = _gv_fmt_3 + 1) begin : extend_fp_result
			localparam fmt = _gv_fmt_3;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			if ((NUM_LANES * FP_WIDTH) < Width) begin : genblk1
				assign fmt_slice_result[(fmt * Width) + ((Width - 1) >= (NUM_LANES * FP_WIDTH) ? Width - 1 : ((Width - 1) + ((Width - 1) >= (NUM_LANES * FP_WIDTH) ? ((Width - 1) - (NUM_LANES * FP_WIDTH)) + 1 : ((NUM_LANES * FP_WIDTH) - (Width - 1)) + 1)) - 1)-:((Width - 1) >= (NUM_LANES * FP_WIDTH) ? ((Width - 1) - (NUM_LANES * FP_WIDTH)) + 1 : ((NUM_LANES * FP_WIDTH) - (Width - 1)) + 1)] = {((Width - 1) >= (NUM_LANES * FP_WIDTH) ? ((Width - 1) - (NUM_LANES * FP_WIDTH)) + 1 : ((NUM_LANES * FP_WIDTH) - (Width - 1)) + 1) {lane_ext_bit[0]}};
			end
		end
	endgenerate
	genvar _gv_ifmt_2;
	generate
		for (_gv_ifmt_2 = 0; _gv_ifmt_2 < NUM_INT_FORMATS; _gv_ifmt_2 = _gv_ifmt_2 + 1) begin : extend_or_mute_int_result
			localparam ifmt = _gv_ifmt_2;
			if (OpGroup != 2'd3) begin : mute_int_result
				assign ifmt_slice_result[ifmt * Width+:Width] = 1'sb0;
			end
			else begin : extend_int_result
				localparam [31:0] INT_WIDTH = fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt));
				if ((NUM_LANES * INT_WIDTH) < Width) begin : genblk1
					assign ifmt_slice_result[(ifmt * Width) + ((Width - 1) >= (NUM_LANES * INT_WIDTH) ? Width - 1 : ((Width - 1) + ((Width - 1) >= (NUM_LANES * INT_WIDTH) ? ((Width - 1) - (NUM_LANES * INT_WIDTH)) + 1 : ((NUM_LANES * INT_WIDTH) - (Width - 1)) + 1)) - 1)-:((Width - 1) >= (NUM_LANES * INT_WIDTH) ? ((Width - 1) - (NUM_LANES * INT_WIDTH)) + 1 : ((NUM_LANES * INT_WIDTH) - (Width - 1)) + 1)] = 1'sb0;
				end
			end
		end
		if (OpGroup == 2'd3) begin : target_regs
			reg [(0 >= NumPipeRegs ? ((1 - NumPipeRegs) * Width) + ((NumPipeRegs * Width) - 1) : ((NumPipeRegs + 1) * Width) - 1):(0 >= NumPipeRegs ? NumPipeRegs * Width : 0)] byp_pipe_target_q;
			reg [(0 >= NumPipeRegs ? ((1 - NumPipeRegs) * 3) + ((NumPipeRegs * 3) - 1) : ((NumPipeRegs + 1) * 3) - 1):(0 >= NumPipeRegs ? NumPipeRegs * 3 : 0)] byp_pipe_aux_q;
			reg [0:NumPipeRegs] byp_pipe_valid_q;
			wire [0:NumPipeRegs] byp_pipe_ready;
			wire [Width * 1:1] sv2v_tmp_77847;
			assign sv2v_tmp_77847 = conv_target_d;
			always @(*) byp_pipe_target_q[(0 >= NumPipeRegs ? 0 : NumPipeRegs) * Width+:Width] = sv2v_tmp_77847;
			wire [3:1] sv2v_tmp_2A1F7;
			assign sv2v_tmp_2A1F7 = target_aux_d;
			always @(*) byp_pipe_aux_q[(0 >= NumPipeRegs ? 0 : NumPipeRegs) * 3+:3] = sv2v_tmp_2A1F7;
			wire [1:1] sv2v_tmp_5453C;
			assign sv2v_tmp_5453C = in_valid_i & vectorial_op;
			always @(*) byp_pipe_valid_q[0] = sv2v_tmp_5453C;
			genvar _gv_i_1;
			for (_gv_i_1 = 0; _gv_i_1 < NumPipeRegs; _gv_i_1 = _gv_i_1 + 1) begin : gen_bypass_pipeline
				localparam i = _gv_i_1;
				wire reg_ena;
				assign byp_pipe_ready[i] = byp_pipe_ready[i + 1] | ~byp_pipe_valid_q[i + 1];
				always @(posedge clk_i or negedge rst_ni)
					if (!rst_ni)
						byp_pipe_valid_q[i + 1] <= 1'b0;
					else
						byp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (byp_pipe_ready[i] ? byp_pipe_valid_q[i] : byp_pipe_valid_q[i + 1]));
				assign reg_ena = (byp_pipe_ready[i] & byp_pipe_valid_q[i]) | reg_ena_i[i];
				always @(posedge clk_i or negedge rst_ni)
					if (!rst_ni)
						byp_pipe_target_q[(0 >= NumPipeRegs ? i + 1 : NumPipeRegs - (i + 1)) * Width+:Width] <= 1'sb0;
					else
						byp_pipe_target_q[(0 >= NumPipeRegs ? i + 1 : NumPipeRegs - (i + 1)) * Width+:Width] <= (reg_ena ? byp_pipe_target_q[(0 >= NumPipeRegs ? i : NumPipeRegs - i) * Width+:Width] : byp_pipe_target_q[(0 >= NumPipeRegs ? i + 1 : NumPipeRegs - (i + 1)) * Width+:Width]);
				always @(posedge clk_i or negedge rst_ni)
					if (!rst_ni)
						byp_pipe_aux_q[(0 >= NumPipeRegs ? i + 1 : NumPipeRegs - (i + 1)) * 3+:3] <= 1'sb0;
					else
						byp_pipe_aux_q[(0 >= NumPipeRegs ? i + 1 : NumPipeRegs - (i + 1)) * 3+:3] <= (reg_ena ? byp_pipe_aux_q[(0 >= NumPipeRegs ? i : NumPipeRegs - i) * 3+:3] : byp_pipe_aux_q[(0 >= NumPipeRegs ? i + 1 : NumPipeRegs - (i + 1)) * 3+:3]);
			end
			assign byp_pipe_ready[NumPipeRegs] = out_ready_i & result_is_vector;
			assign conv_target_q = byp_pipe_target_q[(0 >= NumPipeRegs ? NumPipeRegs : NumPipeRegs - NumPipeRegs) * Width+:Width];
			assign {result_vec_op, result_is_cpk} = byp_pipe_aux_q[(0 >= NumPipeRegs ? NumPipeRegs : NumPipeRegs - NumPipeRegs) * 3+:3];
		end
		else begin : no_conv
			assign {result_vec_op, result_is_cpk} = 1'sb0;
			assign conv_target_q = 1'sb0;
		end
		if (PulpDivsqrt) begin : genblk7
			assign simd_synch_rdy = (EnableVectors ? &divsqrt_ready : divsqrt_ready[0]);
			assign simd_synch_done = (EnableVectors ? &divsqrt_done : divsqrt_done[0]);
		end
		else begin : genblk7
			assign simd_synch_rdy = 1'sb0;
			assign simd_synch_done = 1'sb0;
		end
	endgenerate
	assign {result_fmt_is_int, result_is_vector, result_fmt} = lane_aux[0+:AUX_BITS];
	assign result_o = (result_fmt_is_int ? ifmt_slice_result[result_fmt * Width+:Width] : fmt_slice_result[result_fmt * Width+:Width]);
	assign extension_bit_o = lane_ext_bit[0];
	assign tag_o = lane_tags[0+:10];
	assign busy_o = |lane_busy;
	assign out_valid_o = lane_out_valid[0];
	always @(*) begin : output_processing
		reg [4:0] temp_status;
		if (_sv2v_0)
			;
		temp_status = 1'sb0;
		begin : sv2v_autoblock_11
			reg signed [31:0] i;
			for (i = 0; i < sv2v_cast_32_signed(NUM_LANES); i = i + 1)
				temp_status = temp_status | (lane_status[i * 5+:5] & {5 {lane_masks[i]}});
		end
		status_o = temp_status;
	end
	initial _sv2v_0 = 0;
endmodule
module fpnew_fma_0C4F7 (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	tag_i,
	mask_i,
	aux_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	mask_o,
	aux_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	parameter [2:0] FpFormat = sv2v_cast_9FB13(0);
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	localparam [31:0] WIDTH = fpnew_pkg_fp_width(FpFormat);
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [(3 * WIDTH) - 1:0] operands_i;
	input wire [2:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [9:0] tag_i;
	input wire mask_i;
	input wire aux_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [WIDTH - 1:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire mask_o;
	output wire aux_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	function automatic [31:0] fpnew_pkg_exp_bits;
		input reg [2:0] fmt;
		fpnew_pkg_exp_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32];
	endfunction
	localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(FpFormat);
	function automatic [31:0] fpnew_pkg_man_bits;
		input reg [2:0] fmt;
		fpnew_pkg_man_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32];
	endfunction
	localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(FpFormat);
	function automatic [31:0] fpnew_pkg_bias;
		input reg [2:0] fmt;
		fpnew_pkg_bias = $unsigned((2 ** (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] - 1)) - 1);
	endfunction
	localparam [31:0] BIAS = fpnew_pkg_bias(FpFormat);
	localparam [31:0] PRECISION_BITS = MAN_BITS + 1;
	localparam [31:0] LOWER_SUM_WIDTH = (2 * PRECISION_BITS) + 3;
	localparam [31:0] LZC_RESULT_WIDTH = $clog2(LOWER_SUM_WIDTH);
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	localparam [31:0] EXP_WIDTH = $unsigned(fpnew_pkg_maximum(EXP_BITS + 2, LZC_RESULT_WIDTH));
	localparam [31:0] SHIFT_AMOUNT_WIDTH = $clog2((3 * PRECISION_BITS) + 5);
	localparam NUM_INP_REGS = (PipeConfig == 2'd0 ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 1) / 3 : 0));
	localparam NUM_MID_REGS = (PipeConfig == 2'd2 ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 2) / 3 : 0));
	localparam NUM_OUT_REGS = (PipeConfig == 2'd1 ? NumPipeRegs : (PipeConfig == 2'd3 ? NumPipeRegs / 3 : 0));
	reg [((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) - (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) * WIDTH) - 1) : ((((0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) * WIDTH) - 1)):((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) * WIDTH : (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) * WIDTH)] inp_pipe_operands_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_is_boxed_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_rnd_mode_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_OP_BITS) + ((NUM_INP_REGS * fpnew_pkg_OP_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_OP_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_OP_BITS : 0)] inp_pipe_op_q;
	reg [0:NUM_INP_REGS] inp_pipe_op_mod_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 10) + ((NUM_INP_REGS * 10) - 1) : ((NUM_INP_REGS + 1) * 10) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 10 : 0)] inp_pipe_tag_q;
	reg [0:NUM_INP_REGS] inp_pipe_mask_q;
	reg [0:NUM_INP_REGS] inp_pipe_aux_q;
	reg [0:NUM_INP_REGS] inp_pipe_valid_q;
	wire [0:NUM_INP_REGS] inp_pipe_ready;
	wire [3 * WIDTH:1] sv2v_tmp_B135A;
	assign sv2v_tmp_B135A = operands_i;
	always @(*) inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] = sv2v_tmp_B135A;
	wire [3:1] sv2v_tmp_15896;
	assign sv2v_tmp_15896 = is_boxed_i;
	always @(*) inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_15896;
	wire [3:1] sv2v_tmp_26D09;
	assign sv2v_tmp_26D09 = rnd_mode_i;
	always @(*) inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_26D09;
	wire [4:1] sv2v_tmp_F5BC4;
	assign sv2v_tmp_F5BC4 = op_i;
	always @(*) inp_pipe_op_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] = sv2v_tmp_F5BC4;
	wire [1:1] sv2v_tmp_42D74;
	assign sv2v_tmp_42D74 = op_mod_i;
	always @(*) inp_pipe_op_mod_q[0] = sv2v_tmp_42D74;
	wire [10:1] sv2v_tmp_1669F;
	assign sv2v_tmp_1669F = tag_i;
	always @(*) inp_pipe_tag_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 10+:10] = sv2v_tmp_1669F;
	wire [1:1] sv2v_tmp_43EE3;
	assign sv2v_tmp_43EE3 = mask_i;
	always @(*) inp_pipe_mask_q[0] = sv2v_tmp_43EE3;
	wire [1:1] sv2v_tmp_E1D93;
	assign sv2v_tmp_E1D93 = aux_i;
	always @(*) inp_pipe_aux_q[0] = sv2v_tmp_E1D93;
	wire [1:1] sv2v_tmp_9CFD6;
	assign sv2v_tmp_9CFD6 = in_valid_i;
	always @(*) inp_pipe_valid_q[0] = sv2v_tmp_9CFD6;
	assign in_ready_o = inp_pipe_ready[0];
	genvar _gv_i_2;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	generate
		for (_gv_i_2 = 0; _gv_i_2 < NUM_INP_REGS; _gv_i_2 = _gv_i_2 + 1) begin : gen_input_pipeline
			localparam i = _gv_i_2;
			wire reg_ena;
			assign inp_pipe_ready[i] = inp_pipe_ready[i + 1] | ~inp_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_valid_q[i + 1] <= 1'b0;
				else
					inp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (inp_pipe_ready[i] ? inp_pipe_valid_q[i] : inp_pipe_valid_q[i + 1]));
			assign reg_ena = (inp_pipe_ready[i] & inp_pipe_valid_q[i]) | reg_ena_i[i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] <= 1'sb0;
				else
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] <= (reg_ena ? inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] : inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 1'sb0;
				else
					inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= sv2v_cast_7BCAE(0);
				else
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= (reg_ena ? inp_pipe_op_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] : inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_mod_q[i + 1] <= 1'sb0;
				else
					inp_pipe_op_mod_q[i + 1] <= (reg_ena ? inp_pipe_op_mod_q[i] : inp_pipe_op_mod_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= (reg_ena ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 10+:10] : inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_mask_q[i + 1] <= 1'sb0;
				else
					inp_pipe_mask_q[i + 1] <= (reg_ena ? inp_pipe_mask_q[i] : inp_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_aux_q[i + 1] <= 1'b0;
				else
					inp_pipe_aux_q[i + 1] <= (reg_ena ? inp_pipe_aux_q[i] : inp_pipe_aux_q[i + 1]);
		end
	endgenerate
	wire [23:0] info_q;
	fpnew_classifier #(
		.FpFormat(FpFormat),
		.NumOperands(3)
	) i_class_inputs(
		.operands_i(inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3]),
		.is_boxed_i(inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3]),
		.info_o(info_q)
	);
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] operand_a;
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] operand_b;
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] operand_c;
	reg [7:0] info_a;
	reg [7:0] info_b;
	reg [7:0] info_c;
	localparam [0:0] fpnew_pkg_DONT_CARE = 1'b1;
	function automatic [EXP_BITS - 1:0] sv2v_cast_DBE99;
		input reg [EXP_BITS - 1:0] inp;
		sv2v_cast_DBE99 = inp;
	endfunction
	function automatic [MAN_BITS - 1:0] sv2v_cast_AD1B9;
		input reg [MAN_BITS - 1:0] inp;
		sv2v_cast_AD1B9 = inp;
	endfunction
	function automatic [EXP_BITS - 1:0] sv2v_cast_E64C3;
		input reg [EXP_BITS - 1:0] inp;
		sv2v_cast_E64C3 = inp;
	endfunction
	function automatic [MAN_BITS - 1:0] sv2v_cast_33A5C;
		input reg [MAN_BITS - 1:0] inp;
		sv2v_cast_33A5C = inp;
	endfunction
	always @(*) begin : op_select
		if (_sv2v_0)
			;
		operand_a = inp_pipe_operands_q[((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3 : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1))) * WIDTH+:WIDTH];
		operand_b = inp_pipe_operands_q[((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 1 : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - ((((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1))) * WIDTH+:WIDTH];
		operand_c = inp_pipe_operands_q[((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 2 : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - ((((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1))) * WIDTH+:WIDTH];
		info_a = info_q[0+:8];
		info_b = info_q[8+:8];
		info_c = info_q[16+:8];
		operand_c[1 + (EXP_BITS + (MAN_BITS - 1))] = operand_c[1 + (EXP_BITS + (MAN_BITS - 1))] ^ inp_pipe_op_mod_q[NUM_INP_REGS];
		(* full_case, parallel_case *)
		case (inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS])
			sv2v_cast_7BCAE(0):
				;
			sv2v_cast_7BCAE(1): operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] = ~operand_a[1 + (EXP_BITS + (MAN_BITS - 1))];
			sv2v_cast_7BCAE(2): begin
				operand_a = {1'b0, sv2v_cast_DBE99(BIAS), sv2v_cast_AD1B9(1'sb0)};
				info_a = 8'b10000001;
			end
			sv2v_cast_7BCAE(3): begin
				if (inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3] == 3'b010)
					operand_c = {1'b0, sv2v_cast_E64C3(1'sb0), sv2v_cast_AD1B9(1'sb0)};
				else
					operand_c = {1'b1, sv2v_cast_E64C3(1'sb0), sv2v_cast_AD1B9(1'sb0)};
				info_c = 8'b00100001;
			end
			default: begin
				operand_a = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
				operand_b = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
				operand_c = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
				info_a = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				info_b = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				info_c = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
			end
		endcase
	end
	wire any_operand_inf;
	wire any_operand_nan;
	wire signalling_nan;
	wire effective_subtraction;
	wire tentative_sign;
	assign any_operand_inf = |{info_a[4], info_b[4], info_c[4]};
	assign any_operand_nan = |{info_a[3], info_b[3], info_c[3]};
	assign signalling_nan = |{info_a[2], info_b[2], info_c[2]};
	assign effective_subtraction = (operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ^ operand_b[1 + (EXP_BITS + (MAN_BITS - 1))]) ^ operand_c[1 + (EXP_BITS + (MAN_BITS - 1))];
	assign tentative_sign = operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ^ operand_b[1 + (EXP_BITS + (MAN_BITS - 1))];
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] special_result;
	reg [4:0] special_status;
	reg result_is_special;
	always @(*) begin : special_cases
		if (_sv2v_0)
			;
		special_result = {1'b0, sv2v_cast_E64C3(1'sb1), sv2v_cast_33A5C(2 ** (MAN_BITS - 1))};
		special_status = 1'sb0;
		result_is_special = 1'b0;
		if ((info_a[4] && info_b[5]) || (info_a[5] && info_b[4])) begin
			result_is_special = 1'b1;
			special_status[4] = 1'b1;
		end
		else if (any_operand_nan) begin
			result_is_special = 1'b1;
			special_status[4] = signalling_nan;
		end
		else if (any_operand_inf) begin
			result_is_special = 1'b1;
			if (((info_a[4] || info_b[4]) && info_c[4]) && effective_subtraction)
				special_status[4] = 1'b1;
			else if (info_a[4] || info_b[4])
				special_result = {operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ^ operand_b[1 + (EXP_BITS + (MAN_BITS - 1))], sv2v_cast_E64C3(1'sb1), sv2v_cast_AD1B9(1'sb0)};
			else if (info_c[4])
				special_result = {operand_c[1 + (EXP_BITS + (MAN_BITS - 1))], sv2v_cast_E64C3(1'sb1), sv2v_cast_AD1B9(1'sb0)};
		end
	end
	wire signed [EXP_WIDTH - 1:0] exponent_a;
	wire signed [EXP_WIDTH - 1:0] exponent_b;
	wire signed [EXP_WIDTH - 1:0] exponent_c;
	wire signed [EXP_WIDTH - 1:0] exponent_addend;
	wire signed [EXP_WIDTH - 1:0] exponent_product;
	wire signed [EXP_WIDTH - 1:0] exponent_difference;
	wire signed [EXP_WIDTH - 1:0] tentative_exponent;
	assign exponent_a = $signed({1'b0, operand_a[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)]});
	assign exponent_b = $signed({1'b0, operand_b[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)]});
	assign exponent_c = $signed({1'b0, operand_c[EXP_BITS + (MAN_BITS - 1)-:((EXP_BITS + (MAN_BITS - 1)) >= (MAN_BITS + 0) ? ((EXP_BITS + (MAN_BITS - 1)) - (MAN_BITS + 0)) + 1 : ((MAN_BITS + 0) - (EXP_BITS + (MAN_BITS - 1))) + 1)]});
	assign exponent_addend = $signed(exponent_c + $signed({1'b0, ~info_c[7]}));
	assign exponent_product = (info_a[5] || info_b[5] ? 2 - $signed(BIAS) : $signed((((exponent_a + info_a[6]) + exponent_b) + info_b[6]) - $signed(BIAS)));
	assign exponent_difference = exponent_addend - exponent_product;
	assign tentative_exponent = (exponent_difference > 0 ? exponent_addend : exponent_product);
	reg [SHIFT_AMOUNT_WIDTH - 1:0] addend_shamt;
	always @(*) begin : addend_shift_amount
		if (_sv2v_0)
			;
		if (exponent_difference <= $signed((-2 * PRECISION_BITS) - 1))
			addend_shamt = (3 * PRECISION_BITS) + 4;
		else if (exponent_difference <= $signed(PRECISION_BITS + 2))
			addend_shamt = $unsigned(($signed(PRECISION_BITS) + 3) - exponent_difference);
		else
			addend_shamt = 0;
	end
	wire [PRECISION_BITS - 1:0] mantissa_a;
	wire [PRECISION_BITS - 1:0] mantissa_b;
	wire [PRECISION_BITS - 1:0] mantissa_c;
	wire [(2 * PRECISION_BITS) - 1:0] product;
	wire [(3 * PRECISION_BITS) + 3:0] product_shifted;
	assign mantissa_a = {info_a[7], operand_a[MAN_BITS - 1-:MAN_BITS]};
	assign mantissa_b = {info_b[7], operand_b[MAN_BITS - 1-:MAN_BITS]};
	assign mantissa_c = {info_c[7], operand_c[MAN_BITS - 1-:MAN_BITS]};
	assign product = mantissa_a * mantissa_b;
	assign product_shifted = product << 2;
	wire [(3 * PRECISION_BITS) + 3:0] addend_after_shift;
	wire [PRECISION_BITS - 1:0] addend_sticky_bits;
	wire sticky_before_add;
	wire [(3 * PRECISION_BITS) + 3:0] addend_shifted;
	wire inject_carry_in;
	assign {addend_after_shift, addend_sticky_bits} = (mantissa_c << ((3 * PRECISION_BITS) + 4)) >> addend_shamt;
	assign sticky_before_add = |addend_sticky_bits;
	assign addend_shifted = (effective_subtraction ? ~addend_after_shift : addend_after_shift);
	assign inject_carry_in = effective_subtraction & ~sticky_before_add;
	wire [(3 * PRECISION_BITS) + 4:0] sum_raw;
	wire sum_carry;
	wire [(3 * PRECISION_BITS) + 3:0] sum;
	wire final_sign;
	assign sum_raw = (product_shifted + addend_shifted) + inject_carry_in;
	assign sum_carry = sum_raw[(3 * PRECISION_BITS) + 4];
	assign sum = (effective_subtraction && ~sum_carry ? -sum_raw : sum_raw);
	assign final_sign = (effective_subtraction && (sum_carry == tentative_sign) ? 1'b1 : (effective_subtraction ? 1'b0 : tentative_sign));
	wire effective_subtraction_q;
	wire signed [EXP_WIDTH - 1:0] exponent_product_q;
	wire signed [EXP_WIDTH - 1:0] exponent_difference_q;
	wire signed [EXP_WIDTH - 1:0] tentative_exponent_q;
	wire [SHIFT_AMOUNT_WIDTH - 1:0] addend_shamt_q;
	wire sticky_before_add_q;
	wire [(3 * PRECISION_BITS) + 3:0] sum_q;
	wire final_sign_q;
	wire [2:0] rnd_mode_q;
	wire result_is_special_q;
	wire [((1 + EXP_BITS) + MAN_BITS) - 1:0] special_result_q;
	wire [4:0] special_status_q;
	reg [0:NUM_MID_REGS] mid_pipe_eff_sub_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * EXP_WIDTH) + ((NUM_MID_REGS * EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * EXP_WIDTH : 0)] mid_pipe_exp_prod_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * EXP_WIDTH) + ((NUM_MID_REGS * EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * EXP_WIDTH : 0)] mid_pipe_exp_diff_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * EXP_WIDTH) + ((NUM_MID_REGS * EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * EXP_WIDTH : 0)] mid_pipe_tent_exp_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * SHIFT_AMOUNT_WIDTH) + ((NUM_MID_REGS * SHIFT_AMOUNT_WIDTH) - 1) : ((NUM_MID_REGS + 1) * SHIFT_AMOUNT_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * SHIFT_AMOUNT_WIDTH : 0)] mid_pipe_add_shamt_q;
	reg [0:NUM_MID_REGS] mid_pipe_sticky_q;
	reg [(0 >= NUM_MID_REGS ? (((3 * PRECISION_BITS) + 3) >= 0 ? ((1 - NUM_MID_REGS) * ((3 * PRECISION_BITS) + 4)) + ((NUM_MID_REGS * ((3 * PRECISION_BITS) + 4)) - 1) : ((1 - NUM_MID_REGS) * (1 - ((3 * PRECISION_BITS) + 3))) + ((((3 * PRECISION_BITS) + 3) + (NUM_MID_REGS * (1 - ((3 * PRECISION_BITS) + 3)))) - 1)) : (((3 * PRECISION_BITS) + 3) >= 0 ? ((NUM_MID_REGS + 1) * ((3 * PRECISION_BITS) + 4)) - 1 : ((NUM_MID_REGS + 1) * (1 - ((3 * PRECISION_BITS) + 3))) + ((3 * PRECISION_BITS) + 2))):(0 >= NUM_MID_REGS ? (((3 * PRECISION_BITS) + 3) >= 0 ? NUM_MID_REGS * ((3 * PRECISION_BITS) + 4) : ((3 * PRECISION_BITS) + 3) + (NUM_MID_REGS * (1 - ((3 * PRECISION_BITS) + 3)))) : (((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3))] mid_pipe_sum_q;
	reg [0:NUM_MID_REGS] mid_pipe_final_sign_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 3) + ((NUM_MID_REGS * 3) - 1) : ((NUM_MID_REGS + 1) * 3) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 3 : 0)] mid_pipe_rnd_mode_q;
	reg [0:NUM_MID_REGS] mid_pipe_res_is_spec_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * ((1 + EXP_BITS) + MAN_BITS)) + ((NUM_MID_REGS * ((1 + EXP_BITS) + MAN_BITS)) - 1) : ((NUM_MID_REGS + 1) * ((1 + EXP_BITS) + MAN_BITS)) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * ((1 + EXP_BITS) + MAN_BITS) : 0)] mid_pipe_spec_res_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 5) + ((NUM_MID_REGS * 5) - 1) : ((NUM_MID_REGS + 1) * 5) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 5 : 0)] mid_pipe_spec_stat_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 10) + ((NUM_MID_REGS * 10) - 1) : ((NUM_MID_REGS + 1) * 10) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 10 : 0)] mid_pipe_tag_q;
	reg [0:NUM_MID_REGS] mid_pipe_mask_q;
	reg [0:NUM_MID_REGS] mid_pipe_aux_q;
	reg [0:NUM_MID_REGS] mid_pipe_valid_q;
	wire [0:NUM_MID_REGS] mid_pipe_ready;
	wire [1:1] sv2v_tmp_72F3C;
	assign sv2v_tmp_72F3C = effective_subtraction;
	always @(*) mid_pipe_eff_sub_q[0] = sv2v_tmp_72F3C;
	wire [EXP_WIDTH * 1:1] sv2v_tmp_51634;
	assign sv2v_tmp_51634 = exponent_product;
	always @(*) mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH] = sv2v_tmp_51634;
	wire [EXP_WIDTH * 1:1] sv2v_tmp_7826E;
	assign sv2v_tmp_7826E = exponent_difference;
	always @(*) mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH] = sv2v_tmp_7826E;
	wire [EXP_WIDTH * 1:1] sv2v_tmp_BEF1B;
	assign sv2v_tmp_BEF1B = tentative_exponent;
	always @(*) mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH] = sv2v_tmp_BEF1B;
	wire [SHIFT_AMOUNT_WIDTH * 1:1] sv2v_tmp_BA51C;
	assign sv2v_tmp_BA51C = addend_shamt;
	always @(*) mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] = sv2v_tmp_BA51C;
	wire [1:1] sv2v_tmp_D9513;
	assign sv2v_tmp_D9513 = sticky_before_add;
	always @(*) mid_pipe_sticky_q[0] = sv2v_tmp_D9513;
	wire [(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)) * 1:1] sv2v_tmp_6102F;
	assign sv2v_tmp_6102F = sum;
	always @(*) mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] = sv2v_tmp_6102F;
	wire [1:1] sv2v_tmp_E5D4B;
	assign sv2v_tmp_E5D4B = final_sign;
	always @(*) mid_pipe_final_sign_q[0] = sv2v_tmp_E5D4B;
	wire [3:1] sv2v_tmp_D5331;
	assign sv2v_tmp_D5331 = inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3];
	always @(*) mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 3+:3] = sv2v_tmp_D5331;
	wire [1:1] sv2v_tmp_7E156;
	assign sv2v_tmp_7E156 = result_is_special;
	always @(*) mid_pipe_res_is_spec_q[0] = sv2v_tmp_7E156;
	wire [((1 + EXP_BITS) + MAN_BITS) * 1:1] sv2v_tmp_45CEC;
	assign sv2v_tmp_45CEC = special_result;
	always @(*) mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] = sv2v_tmp_45CEC;
	wire [5:1] sv2v_tmp_06630;
	assign sv2v_tmp_06630 = special_status;
	always @(*) mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 5+:5] = sv2v_tmp_06630;
	wire [10:1] sv2v_tmp_ECDF1;
	assign sv2v_tmp_ECDF1 = inp_pipe_tag_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 10+:10];
	always @(*) mid_pipe_tag_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 10+:10] = sv2v_tmp_ECDF1;
	wire [1:1] sv2v_tmp_2E03C;
	assign sv2v_tmp_2E03C = inp_pipe_mask_q[NUM_INP_REGS];
	always @(*) mid_pipe_mask_q[0] = sv2v_tmp_2E03C;
	wire [1:1] sv2v_tmp_769AB;
	assign sv2v_tmp_769AB = inp_pipe_aux_q[NUM_INP_REGS];
	always @(*) mid_pipe_aux_q[0] = sv2v_tmp_769AB;
	wire [1:1] sv2v_tmp_3D86F;
	assign sv2v_tmp_3D86F = inp_pipe_valid_q[NUM_INP_REGS];
	always @(*) mid_pipe_valid_q[0] = sv2v_tmp_3D86F;
	assign inp_pipe_ready[NUM_INP_REGS] = mid_pipe_ready[0];
	genvar _gv_i_3;
	generate
		for (_gv_i_3 = 0; _gv_i_3 < NUM_MID_REGS; _gv_i_3 = _gv_i_3 + 1) begin : gen_inside_pipeline
			localparam i = _gv_i_3;
			wire reg_ena;
			assign mid_pipe_ready[i] = mid_pipe_ready[i + 1] | ~mid_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_valid_q[i + 1] <= 1'b0;
				else
					mid_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (mid_pipe_ready[i] ? mid_pipe_valid_q[i] : mid_pipe_valid_q[i + 1]));
			assign reg_ena = (mid_pipe_ready[i] & mid_pipe_valid_q[i]) | reg_ena_i[NUM_INP_REGS + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_eff_sub_q[i + 1] <= 1'sb0;
				else
					mid_pipe_eff_sub_q[i + 1] <= (reg_ena ? mid_pipe_eff_sub_q[i] : mid_pipe_eff_sub_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= (reg_ena ? mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * EXP_WIDTH+:EXP_WIDTH] : mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= (reg_ena ? mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * EXP_WIDTH+:EXP_WIDTH] : mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= (reg_ena ? mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * EXP_WIDTH+:EXP_WIDTH] : mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] <= 1'sb0;
				else
					mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] <= (reg_ena ? mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] : mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_sticky_q[i + 1] <= 1'sb0;
				else
					mid_pipe_sticky_q[i + 1] <= (reg_ena ? mid_pipe_sticky_q[i] : mid_pipe_sticky_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] <= 1'sb0;
				else
					mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] <= (reg_ena ? mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] : mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_final_sign_q[i + 1] <= 1'sb0;
				else
					mid_pipe_final_sign_q[i + 1] <= (reg_ena ? mid_pipe_final_sign_q[i] : mid_pipe_final_sign_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3] <= (reg_ena ? mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 3+:3] : mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_res_is_spec_q[i + 1] <= 1'sb0;
				else
					mid_pipe_res_is_spec_q[i + 1] <= (reg_ena ? mid_pipe_res_is_spec_q[i] : mid_pipe_res_is_spec_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] <= 1'sb0;
				else
					mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] <= (reg_ena ? mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] : mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 5+:5] <= (reg_ena ? mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 5+:5] : mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10] <= (reg_ena ? mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 10+:10] : mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_mask_q[i + 1] <= 1'sb0;
				else
					mid_pipe_mask_q[i + 1] <= (reg_ena ? mid_pipe_mask_q[i] : mid_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_aux_q[i + 1] <= 1'b0;
				else
					mid_pipe_aux_q[i + 1] <= (reg_ena ? mid_pipe_aux_q[i] : mid_pipe_aux_q[i + 1]);
		end
	endgenerate
	assign effective_subtraction_q = mid_pipe_eff_sub_q[NUM_MID_REGS];
	assign exponent_product_q = mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH];
	assign exponent_difference_q = mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH];
	assign tentative_exponent_q = mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH];
	assign addend_shamt_q = mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH];
	assign sticky_before_add_q = mid_pipe_sticky_q[NUM_MID_REGS];
	assign sum_q = mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))];
	assign final_sign_q = mid_pipe_final_sign_q[NUM_MID_REGS];
	assign rnd_mode_q = mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 3+:3];
	assign result_is_special_q = mid_pipe_res_is_spec_q[NUM_MID_REGS];
	assign special_result_q = mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS];
	assign special_status_q = mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 5+:5];
	wire [LOWER_SUM_WIDTH - 1:0] sum_lower;
	wire [LZC_RESULT_WIDTH - 1:0] leading_zero_count;
	wire signed [LZC_RESULT_WIDTH:0] leading_zero_count_sgn;
	wire lzc_zeroes;
	reg [SHIFT_AMOUNT_WIDTH - 1:0] norm_shamt;
	reg signed [EXP_WIDTH - 1:0] normalized_exponent;
	wire [(3 * PRECISION_BITS) + 4:0] sum_shifted;
	reg [PRECISION_BITS:0] final_mantissa;
	reg [(2 * PRECISION_BITS) + 2:0] sum_sticky_bits;
	wire sticky_after_norm;
	reg signed [EXP_WIDTH - 1:0] final_exponent;
	assign sum_lower = sum_q[LOWER_SUM_WIDTH - 1:0];
	lzc #(
		.WIDTH(LOWER_SUM_WIDTH),
		.MODE(1)
	) i_lzc(
		.in_i(sum_lower),
		.cnt_o(leading_zero_count),
		.empty_o(lzc_zeroes)
	);
	assign leading_zero_count_sgn = $signed({1'b0, leading_zero_count});
	always @(*) begin : norm_shift_amount
		if (_sv2v_0)
			;
		if ((exponent_difference_q <= 0) || (effective_subtraction_q && (exponent_difference_q <= 2))) begin
			if ((((exponent_product_q - leading_zero_count_sgn) + 1) >= 0) && !lzc_zeroes) begin
				norm_shamt = (PRECISION_BITS + 2) + leading_zero_count;
				normalized_exponent = (exponent_product_q - leading_zero_count_sgn) + 1;
			end
			else begin
				norm_shamt = $unsigned(($signed(PRECISION_BITS) + 2) + exponent_product_q);
				normalized_exponent = 0;
			end
		end
		else begin
			norm_shamt = addend_shamt_q;
			normalized_exponent = tentative_exponent_q;
		end
	end
	assign sum_shifted = sum_q << norm_shamt;
	always @(*) begin : small_norm
		if (_sv2v_0)
			;
		{final_mantissa, sum_sticky_bits} = sum_shifted;
		final_exponent = normalized_exponent;
		if (sum_shifted[(3 * PRECISION_BITS) + 4]) begin
			{final_mantissa, sum_sticky_bits} = sum_shifted >> 1;
			final_exponent = normalized_exponent + 1;
		end
		else if (sum_shifted[(3 * PRECISION_BITS) + 3])
			;
		else if (normalized_exponent > 1) begin
			{final_mantissa, sum_sticky_bits} = sum_shifted << 1;
			final_exponent = normalized_exponent - 1;
		end
		else
			final_exponent = 1'sb0;
	end
	assign sticky_after_norm = |{sum_sticky_bits} | sticky_before_add_q;
	wire pre_round_sign;
	wire [EXP_BITS - 1:0] pre_round_exponent;
	wire [MAN_BITS - 1:0] pre_round_mantissa;
	wire [(EXP_BITS + MAN_BITS) - 1:0] pre_round_abs;
	wire [1:0] round_sticky_bits;
	wire of_before_round;
	wire of_after_round;
	wire uf_before_round;
	wire uf_after_round;
	wire result_zero;
	wire rounded_sign;
	wire [(EXP_BITS + MAN_BITS) - 1:0] rounded_abs;
	assign of_before_round = final_exponent >= ((2 ** EXP_BITS) - 1);
	assign uf_before_round = final_exponent == 0;
	assign pre_round_sign = final_sign_q;
	assign pre_round_exponent = (of_before_round ? (2 ** EXP_BITS) - 2 : $unsigned(final_exponent[EXP_BITS - 1:0]));
	assign pre_round_mantissa = (of_before_round ? {MAN_BITS {1'sb1}} : final_mantissa[MAN_BITS:1]);
	assign pre_round_abs = {pre_round_exponent, pre_round_mantissa};
	assign round_sticky_bits = (of_before_round ? 2'b11 : {final_mantissa[0], sticky_after_norm});
	fpnew_rounding #(.AbsWidth(EXP_BITS + MAN_BITS)) i_fpnew_rounding(
		.abs_value_i(pre_round_abs),
		.sign_i(pre_round_sign),
		.round_sticky_bits_i(round_sticky_bits),
		.rnd_mode_i(rnd_mode_q),
		.effective_subtraction_i(effective_subtraction_q),
		.abs_rounded_o(rounded_abs),
		.sign_o(rounded_sign),
		.exact_zero_o(result_zero)
	);
	assign uf_after_round = (rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb0}}) || (((pre_round_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb0}}) && (rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == 1)) && ((round_sticky_bits != 2'b11) || (!sum_sticky_bits[(MAN_BITS * 2) + 4] && ((rnd_mode_i == 3'b000) || (rnd_mode_i == 3'b100)))));
	assign of_after_round = rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb1}};
	wire [WIDTH - 1:0] regular_result;
	wire [4:0] regular_status;
	assign regular_result = {rounded_sign, rounded_abs};
	assign regular_status[4] = 1'b0;
	assign regular_status[3] = 1'b0;
	assign regular_status[2] = of_before_round | of_after_round;
	assign regular_status[1] = uf_after_round & regular_status[0];
	assign regular_status[0] = (|round_sticky_bits | of_before_round) | of_after_round;
	wire [((1 + EXP_BITS) + MAN_BITS) - 1:0] result_d;
	wire [4:0] status_d;
	assign result_d = (result_is_special_q ? special_result_q : regular_result);
	assign status_d = (result_is_special_q ? special_status_q : regular_status);
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * ((1 + EXP_BITS) + MAN_BITS)) + ((NUM_OUT_REGS * ((1 + EXP_BITS) + MAN_BITS)) - 1) : ((NUM_OUT_REGS + 1) * ((1 + EXP_BITS) + MAN_BITS)) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * ((1 + EXP_BITS) + MAN_BITS) : 0)] out_pipe_result_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 5) + ((NUM_OUT_REGS * 5) - 1) : ((NUM_OUT_REGS + 1) * 5) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 5 : 0)] out_pipe_status_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_tag_q;
	reg [0:NUM_OUT_REGS] out_pipe_mask_q;
	reg [0:NUM_OUT_REGS] out_pipe_aux_q;
	reg [0:NUM_OUT_REGS] out_pipe_valid_q;
	wire [0:NUM_OUT_REGS] out_pipe_ready;
	wire [((1 + EXP_BITS) + MAN_BITS) * 1:1] sv2v_tmp_93831;
	assign sv2v_tmp_93831 = result_d;
	always @(*) out_pipe_result_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] = sv2v_tmp_93831;
	wire [5:1] sv2v_tmp_C58FF;
	assign sv2v_tmp_C58FF = status_d;
	always @(*) out_pipe_status_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 5+:5] = sv2v_tmp_C58FF;
	wire [10:1] sv2v_tmp_E6D46;
	assign sv2v_tmp_E6D46 = mid_pipe_tag_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 10+:10];
	always @(*) out_pipe_tag_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_E6D46;
	wire [1:1] sv2v_tmp_F68B4;
	assign sv2v_tmp_F68B4 = mid_pipe_mask_q[NUM_MID_REGS];
	always @(*) out_pipe_mask_q[0] = sv2v_tmp_F68B4;
	wire [1:1] sv2v_tmp_F447E;
	assign sv2v_tmp_F447E = mid_pipe_aux_q[NUM_MID_REGS];
	always @(*) out_pipe_aux_q[0] = sv2v_tmp_F447E;
	wire [1:1] sv2v_tmp_39CE2;
	assign sv2v_tmp_39CE2 = mid_pipe_valid_q[NUM_MID_REGS];
	always @(*) out_pipe_valid_q[0] = sv2v_tmp_39CE2;
	assign mid_pipe_ready[NUM_MID_REGS] = out_pipe_ready[0];
	genvar _gv_i_4;
	generate
		for (_gv_i_4 = 0; _gv_i_4 < NUM_OUT_REGS; _gv_i_4 = _gv_i_4 + 1) begin : gen_output_pipeline
			localparam i = _gv_i_4;
			wire reg_ena;
			assign out_pipe_ready[i] = out_pipe_ready[i + 1] | ~out_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_valid_q[i + 1] <= 1'b0;
				else
					out_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (out_pipe_ready[i] ? out_pipe_valid_q[i] : out_pipe_valid_q[i + 1]));
			assign reg_ena = (out_pipe_ready[i] & out_pipe_valid_q[i]) | reg_ena_i[(NUM_INP_REGS + NUM_MID_REGS) + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] <= 1'sb0;
				else
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] <= (reg_ena ? out_pipe_result_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] : out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= (reg_ena ? out_pipe_status_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 5+:5] : out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_mask_q[i + 1] <= 1'sb0;
				else
					out_pipe_mask_q[i + 1] <= (reg_ena ? out_pipe_mask_q[i] : out_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_aux_q[i + 1] <= 1'b0;
				else
					out_pipe_aux_q[i + 1] <= (reg_ena ? out_pipe_aux_q[i] : out_pipe_aux_q[i + 1]);
		end
	endgenerate
	assign out_pipe_ready[NUM_OUT_REGS] = out_ready_i;
	assign result_o = out_pipe_result_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS];
	assign status_o = out_pipe_status_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 5+:5];
	assign extension_bit_o = 1'b1;
	assign tag_o = out_pipe_tag_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign mask_o = out_pipe_mask_q[NUM_OUT_REGS];
	assign aux_o = out_pipe_aux_q[NUM_OUT_REGS];
	assign out_valid_o = out_pipe_valid_q[NUM_OUT_REGS];
	assign busy_o = |{inp_pipe_valid_q, mid_pipe_valid_q, out_pipe_valid_q};
	initial _sv2v_0 = 0;
endmodule
module fpnew_fma_multi_1C544_9CB9D (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	src_fmt_i,
	dst_fmt_i,
	tag_i,
	mask_i,
	aux_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	mask_o,
	aux_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	parameter [31:0] AuxType_AUX_BITS = 0;
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	parameter [0:4] FpFmtConfig = 1'sb1;
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_maximum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_max_fp_width = res;
		end
	endfunction
	localparam [31:0] WIDTH = fpnew_pkg_max_fp_width(FpFmtConfig);
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [(3 * WIDTH) - 1:0] operands_i;
	input wire [14:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [2:0] src_fmt_i;
	input wire [2:0] dst_fmt_i;
	input wire [9:0] tag_i;
	input wire mask_i;
	input wire [AuxType_AUX_BITS - 1:0] aux_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [WIDTH - 1:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire mask_o;
	output wire [AuxType_AUX_BITS - 1:0] aux_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	function automatic [31:0] fpnew_pkg_exp_bits;
		input reg [2:0] fmt;
		fpnew_pkg_exp_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32];
	endfunction
	function automatic [31:0] fpnew_pkg_man_bits;
		input reg [2:0] fmt;
		fpnew_pkg_man_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32];
	endfunction
	function automatic [63:0] fpnew_pkg_super_format;
		input reg [0:4] cfg;
		reg [63:0] res;
		begin
			res = 1'sb0;
			begin : sv2v_autoblock_2
				reg [31:0] fmt;
				for (fmt = 0; fmt < fpnew_pkg_NUM_FP_FORMATS; fmt = fmt + 1)
					if (cfg[fmt]) begin
						res[63-:32] = $unsigned(fpnew_pkg_maximum(res[63-:32], fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt))));
						res[31-:32] = $unsigned(fpnew_pkg_maximum(res[31-:32], fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt))));
					end
			end
			fpnew_pkg_super_format = res;
		end
	endfunction
	localparam [63:0] SUPER_FORMAT = fpnew_pkg_super_format(FpFmtConfig);
	localparam [31:0] SUPER_EXP_BITS = SUPER_FORMAT[63-:32];
	localparam [31:0] SUPER_MAN_BITS = SUPER_FORMAT[31-:32];
	localparam [31:0] PRECISION_BITS = SUPER_MAN_BITS + 1;
	localparam [31:0] LOWER_SUM_WIDTH = (2 * PRECISION_BITS) + 3;
	localparam [31:0] LZC_RESULT_WIDTH = $clog2(LOWER_SUM_WIDTH);
	localparam [31:0] EXP_WIDTH = fpnew_pkg_maximum(SUPER_EXP_BITS + 2, LZC_RESULT_WIDTH);
	localparam [31:0] SHIFT_AMOUNT_WIDTH = $clog2((3 * PRECISION_BITS) + 5);
	localparam NUM_INP_REGS = (PipeConfig == 2'd0 ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 1) / 3 : 0));
	localparam NUM_MID_REGS = (PipeConfig == 2'd2 ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 2) / 3 : 0));
	localparam NUM_OUT_REGS = (PipeConfig == 2'd1 ? NumPipeRegs : (PipeConfig == 2'd3 ? NumPipeRegs / 3 : 0));
	wire [(3 * WIDTH) - 1:0] operands_q;
	wire [2:0] src_fmt_q;
	wire [2:0] dst_fmt_q;
	reg [((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) - (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) * WIDTH) - 1) : ((((0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) * WIDTH) - 1)):((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) * WIDTH : (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) * WIDTH)] inp_pipe_operands_q;
	reg [((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) - (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0)) + 1) * 3) + (((0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) * 3) - 1) : ((((0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1)) + 1) * 3) + (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) * 3) - 1)):((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) * 3 : (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) * 3)] inp_pipe_is_boxed_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_rnd_mode_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_OP_BITS) + ((NUM_INP_REGS * fpnew_pkg_OP_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_OP_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_OP_BITS : 0)] inp_pipe_op_q;
	reg [0:NUM_INP_REGS] inp_pipe_op_mod_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] inp_pipe_src_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] inp_pipe_dst_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 10) + ((NUM_INP_REGS * 10) - 1) : ((NUM_INP_REGS + 1) * 10) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 10 : 0)] inp_pipe_tag_q;
	reg [0:NUM_INP_REGS] inp_pipe_mask_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * AuxType_AUX_BITS) + ((NUM_INP_REGS * AuxType_AUX_BITS) - 1) : ((NUM_INP_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * AuxType_AUX_BITS : 0)] inp_pipe_aux_q;
	reg [0:NUM_INP_REGS] inp_pipe_valid_q;
	wire [0:NUM_INP_REGS] inp_pipe_ready;
	wire [3 * WIDTH:1] sv2v_tmp_65236;
	assign sv2v_tmp_65236 = operands_i;
	always @(*) inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] = sv2v_tmp_65236;
	wire [15:1] sv2v_tmp_03F0C;
	assign sv2v_tmp_03F0C = is_boxed_i;
	always @(*) inp_pipe_is_boxed_q[3 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * NUM_FORMATS) + 4) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * NUM_FORMATS) + 4) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1)))+:15] = sv2v_tmp_03F0C;
	wire [3:1] sv2v_tmp_E41A9;
	assign sv2v_tmp_E41A9 = rnd_mode_i;
	always @(*) inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_E41A9;
	wire [4:1] sv2v_tmp_AA02B;
	assign sv2v_tmp_AA02B = op_i;
	always @(*) inp_pipe_op_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] = sv2v_tmp_AA02B;
	wire [1:1] sv2v_tmp_42D74;
	assign sv2v_tmp_42D74 = op_mod_i;
	always @(*) inp_pipe_op_mod_q[0] = sv2v_tmp_42D74;
	wire [3:1] sv2v_tmp_DA568;
	assign sv2v_tmp_DA568 = src_fmt_i;
	always @(*) inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_DA568;
	wire [3:1] sv2v_tmp_70747;
	assign sv2v_tmp_70747 = dst_fmt_i;
	always @(*) inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_70747;
	wire [10:1] sv2v_tmp_27DBA;
	assign sv2v_tmp_27DBA = tag_i;
	always @(*) inp_pipe_tag_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 10+:10] = sv2v_tmp_27DBA;
	wire [1:1] sv2v_tmp_43EE3;
	assign sv2v_tmp_43EE3 = mask_i;
	always @(*) inp_pipe_mask_q[0] = sv2v_tmp_43EE3;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_85A78;
	assign sv2v_tmp_85A78 = aux_i;
	always @(*) inp_pipe_aux_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_85A78;
	wire [1:1] sv2v_tmp_9CFD6;
	assign sv2v_tmp_9CFD6 = in_valid_i;
	always @(*) inp_pipe_valid_q[0] = sv2v_tmp_9CFD6;
	assign in_ready_o = inp_pipe_ready[0];
	genvar _gv_i_5;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [AuxType_AUX_BITS - 1:0] sv2v_cast_F912A;
		input reg [AuxType_AUX_BITS - 1:0] inp;
		sv2v_cast_F912A = inp;
	endfunction
	generate
		for (_gv_i_5 = 0; _gv_i_5 < NUM_INP_REGS; _gv_i_5 = _gv_i_5 + 1) begin : gen_input_pipeline
			localparam i = _gv_i_5;
			wire reg_ena;
			assign inp_pipe_ready[i] = inp_pipe_ready[i + 1] | ~inp_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_valid_q[i + 1] <= 1'b0;
				else
					inp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (inp_pipe_ready[i] ? inp_pipe_valid_q[i] : inp_pipe_valid_q[i + 1]));
			assign reg_ena = (inp_pipe_ready[i] & inp_pipe_valid_q[i]) | reg_ena_i[i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] <= 1'sb0;
				else
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] <= (reg_ena ? inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3] : inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_is_boxed_q[3 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS) + 4) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS) + 4) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1)))+:15] <= 1'sb0;
				else
					inp_pipe_is_boxed_q[3 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS) + 4) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS) + 4) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1)))+:15] <= (reg_ena ? inp_pipe_is_boxed_q[3 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * NUM_FORMATS) + 4) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * NUM_FORMATS) + 4) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1)))+:15] : inp_pipe_is_boxed_q[3 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS) + 4) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS) + 4) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1)))+:15]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= sv2v_cast_7BCAE(0);
				else
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= (reg_ena ? inp_pipe_op_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] : inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_mod_q[i + 1] <= 1'sb0;
				else
					inp_pipe_op_mod_q[i + 1] <= (reg_ena ? inp_pipe_op_mod_q[i] : inp_pipe_op_mod_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= (reg_ena ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 10+:10] : inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_mask_q[i + 1] <= 1'sb0;
				else
					inp_pipe_mask_q[i + 1] <= (reg_ena ? inp_pipe_mask_q[i] : inp_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign operands_q = inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 2) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3) + 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1)))+:WIDTH * 3];
	assign src_fmt_q = inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign dst_fmt_q = inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	wire [14:0] fmt_sign;
	wire signed [(15 * SUPER_EXP_BITS) - 1:0] fmt_exponent;
	wire [(15 * SUPER_MAN_BITS) - 1:0] fmt_mantissa;
	wire [119:0] info_q;
	genvar _gv_fmt_4;
	localparam [0:0] fpnew_pkg_DONT_CARE = 1'b1;
	function automatic [7:0] sv2v_cast_8;
		input reg [7:0] inp;
		sv2v_cast_8 = inp;
	endfunction
	function automatic signed [SUPER_EXP_BITS - 1:0] sv2v_cast_C9DEC_signed;
		input reg signed [SUPER_EXP_BITS - 1:0] inp;
		sv2v_cast_C9DEC_signed = inp;
	endfunction
	function automatic [SUPER_MAN_BITS - 1:0] sv2v_cast_75D45;
		input reg [SUPER_MAN_BITS - 1:0] inp;
		sv2v_cast_75D45 = inp;
	endfunction
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		for (_gv_fmt_4 = 0; _gv_fmt_4 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_4 = _gv_fmt_4 + 1) begin : fmt_init_inputs
			localparam fmt = _gv_fmt_4;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			if (FpFmtConfig[fmt]) begin : active_format
				wire [(3 * FP_WIDTH) - 1:0] trimmed_ops;
				fpnew_classifier #(
					.FpFormat(sv2v_cast_9FB13(fmt)),
					.NumOperands(3)
				) i_fpnew_classifier(
					.operands_i(trimmed_ops),
					.is_boxed_i(inp_pipe_is_boxed_q[((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) ? ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * NUM_FORMATS) + fmt : (0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0) - ((((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * NUM_FORMATS) + fmt) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1))) * 3+:3]),
					.info_o(info_q[8 * (fmt * 3)+:24])
				);
				genvar _gv_op_2;
				for (_gv_op_2 = 0; _gv_op_2 < 3; _gv_op_2 = _gv_op_2 + 1) begin : gen_operands
					localparam op = _gv_op_2;
					assign trimmed_ops[op * fpnew_pkg_fp_width(sv2v_cast_9FB13(_gv_fmt_4))+:fpnew_pkg_fp_width(sv2v_cast_9FB13(_gv_fmt_4))] = operands_q[(op * WIDTH) + (FP_WIDTH - 1)-:FP_WIDTH];
					assign fmt_sign[(fmt * 3) + op] = operands_q[(op * WIDTH) + (FP_WIDTH - 1)];
					assign fmt_exponent[((fmt * 3) + op) * SUPER_EXP_BITS+:SUPER_EXP_BITS] = $signed({1'b0, operands_q[(op * WIDTH) + MAN_BITS+:EXP_BITS]});
					assign fmt_mantissa[((fmt * 3) + op) * SUPER_MAN_BITS+:SUPER_MAN_BITS] = {info_q[(((fmt * 3) + op) * 8) + 7], operands_q[(op * WIDTH) + (MAN_BITS - 1)-:MAN_BITS]} << (SUPER_MAN_BITS - MAN_BITS);
				end
			end
			else begin : inactive_format
				assign info_q[8 * (fmt * 3)+:24] = {3 {sv2v_cast_8(fpnew_pkg_DONT_CARE)}};
				assign fmt_sign[fmt * 3+:3] = fpnew_pkg_DONT_CARE;
				assign fmt_exponent[SUPER_EXP_BITS * (fmt * 3)+:SUPER_EXP_BITS * 3] = {3 {sv2v_cast_C9DEC_signed(fpnew_pkg_DONT_CARE)}};
				assign fmt_mantissa[SUPER_MAN_BITS * (fmt * 3)+:SUPER_MAN_BITS * 3] = {3 {sv2v_cast_75D45(fpnew_pkg_DONT_CARE)}};
			end
		end
	endgenerate
	reg [((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS) - 1:0] operand_a;
	reg [((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS) - 1:0] operand_b;
	reg [((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS) - 1:0] operand_c;
	reg [7:0] info_a;
	reg [7:0] info_b;
	reg [7:0] info_c;
	function automatic [31:0] fpnew_pkg_bias;
		input reg [2:0] fmt;
		fpnew_pkg_bias = $unsigned((2 ** (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] - 1)) - 1);
	endfunction
	function automatic [SUPER_EXP_BITS - 1:0] sv2v_cast_C9DEC;
		input reg [SUPER_EXP_BITS - 1:0] inp;
		sv2v_cast_C9DEC = inp;
	endfunction
	function automatic [SUPER_MAN_BITS - 1:0] sv2v_cast_4DDC9;
		input reg [SUPER_MAN_BITS - 1:0] inp;
		sv2v_cast_4DDC9 = inp;
	endfunction
	function automatic [SUPER_EXP_BITS - 1:0] sv2v_cast_8433E;
		input reg [SUPER_EXP_BITS - 1:0] inp;
		sv2v_cast_8433E = inp;
	endfunction
	always @(*) begin : op_select
		if (_sv2v_0)
			;
		operand_a = {fmt_sign[src_fmt_q * 3], fmt_exponent[(src_fmt_q * 3) * SUPER_EXP_BITS+:SUPER_EXP_BITS], fmt_mantissa[(src_fmt_q * 3) * SUPER_MAN_BITS+:SUPER_MAN_BITS]};
		operand_b = {fmt_sign[(src_fmt_q * 3) + 1], fmt_exponent[((src_fmt_q * 3) + 1) * SUPER_EXP_BITS+:SUPER_EXP_BITS], fmt_mantissa[((src_fmt_q * 3) + 1) * SUPER_MAN_BITS+:SUPER_MAN_BITS]};
		operand_c = {fmt_sign[(dst_fmt_q * 3) + 2], fmt_exponent[((dst_fmt_q * 3) + 2) * SUPER_EXP_BITS+:SUPER_EXP_BITS], fmt_mantissa[((dst_fmt_q * 3) + 2) * SUPER_MAN_BITS+:SUPER_MAN_BITS]};
		info_a = info_q[(src_fmt_q * 3) * 8+:8];
		info_b = info_q[((src_fmt_q * 3) + 1) * 8+:8];
		info_c = info_q[((dst_fmt_q * 3) + 2) * 8+:8];
		operand_c[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))] = operand_c[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))] ^ inp_pipe_op_mod_q[NUM_INP_REGS];
		(* full_case, parallel_case *)
		case (inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS])
			sv2v_cast_7BCAE(0):
				;
			sv2v_cast_7BCAE(1): operand_a[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))] = ~operand_a[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))];
			sv2v_cast_7BCAE(2): begin
				operand_a = {1'b0, sv2v_cast_C9DEC(fpnew_pkg_bias(src_fmt_q)), sv2v_cast_4DDC9(1'sb0)};
				info_a = 8'b10000001;
			end
			sv2v_cast_7BCAE(3): begin
				if (inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3] == 3'b010)
					operand_c = {1'b0, sv2v_cast_8433E(1'sb0), sv2v_cast_4DDC9(1'sb0)};
				else
					operand_c = {1'b1, sv2v_cast_8433E(1'sb0), sv2v_cast_4DDC9(1'sb0)};
				info_c = 8'b00100001;
			end
			default: begin
				operand_a = {fpnew_pkg_DONT_CARE, sv2v_cast_C9DEC(fpnew_pkg_DONT_CARE), sv2v_cast_75D45(fpnew_pkg_DONT_CARE)};
				operand_b = {fpnew_pkg_DONT_CARE, sv2v_cast_C9DEC(fpnew_pkg_DONT_CARE), sv2v_cast_75D45(fpnew_pkg_DONT_CARE)};
				operand_c = {fpnew_pkg_DONT_CARE, sv2v_cast_C9DEC(fpnew_pkg_DONT_CARE), sv2v_cast_75D45(fpnew_pkg_DONT_CARE)};
				info_a = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				info_b = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				info_c = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
			end
		endcase
	end
	wire any_operand_inf;
	wire any_operand_nan;
	wire signalling_nan;
	wire effective_subtraction;
	wire tentative_sign;
	assign any_operand_inf = |{info_a[4], info_b[4], info_c[4]};
	assign any_operand_nan = |{info_a[3], info_b[3], info_c[3]};
	assign signalling_nan = |{info_a[2], info_b[2], info_c[2]};
	assign effective_subtraction = (operand_a[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))] ^ operand_b[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))]) ^ operand_c[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))];
	assign tentative_sign = operand_a[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))] ^ operand_b[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))];
	wire [WIDTH - 1:0] special_result;
	wire [4:0] special_status;
	wire result_is_special;
	reg [(NUM_FORMATS * WIDTH) - 1:0] fmt_special_result;
	reg [24:0] fmt_special_status;
	reg [4:0] fmt_result_is_special;
	genvar _gv_fmt_5;
	generate
		for (_gv_fmt_5 = 0; _gv_fmt_5 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_5 = _gv_fmt_5 + 1) begin : gen_special_results
			localparam fmt = _gv_fmt_5;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			localparam [EXP_BITS - 1:0] QNAN_EXPONENT = 1'sb1;
			localparam [MAN_BITS - 1:0] QNAN_MANTISSA = 2 ** (MAN_BITS - 1);
			localparam [MAN_BITS - 1:0] ZERO_MANTISSA = 1'sb0;
			if (FpFmtConfig[fmt]) begin : active_format
				always @(*) begin : special_results
					reg [FP_WIDTH - 1:0] special_res;
					if (_sv2v_0)
						;
					special_res = {1'b0, QNAN_EXPONENT, QNAN_MANTISSA};
					fmt_special_status[fmt * 5+:5] = 1'sb0;
					fmt_result_is_special[fmt] = 1'b0;
					if ((info_a[4] && info_b[5]) || (info_a[5] && info_b[4])) begin
						fmt_result_is_special[fmt] = 1'b1;
						fmt_special_status[(fmt * 5) + 4] = 1'b1;
					end
					else if (any_operand_nan) begin
						fmt_result_is_special[fmt] = 1'b1;
						fmt_special_status[(fmt * 5) + 4] = signalling_nan;
					end
					else if (any_operand_inf) begin
						fmt_result_is_special[fmt] = 1'b1;
						if (((info_a[4] || info_b[4]) && info_c[4]) && effective_subtraction)
							fmt_special_status[(fmt * 5) + 4] = 1'b1;
						else if (info_a[4] || info_b[4])
							special_res = {operand_a[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))] ^ operand_b[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))], QNAN_EXPONENT, ZERO_MANTISSA};
						else if (info_c[4])
							special_res = {operand_c[1 + (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))], QNAN_EXPONENT, ZERO_MANTISSA};
					end
					fmt_special_result[fmt * WIDTH+:WIDTH] = 1'sb1;
					fmt_special_result[(fmt * WIDTH) + (FP_WIDTH - 1)-:FP_WIDTH] = special_res;
				end
			end
			else begin : inactive_format
				wire [WIDTH * 1:1] sv2v_tmp_948B8;
				assign sv2v_tmp_948B8 = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) fmt_special_result[fmt * WIDTH+:WIDTH] = sv2v_tmp_948B8;
				wire [5:1] sv2v_tmp_0DB31;
				assign sv2v_tmp_0DB31 = 1'sb0;
				always @(*) fmt_special_status[fmt * 5+:5] = sv2v_tmp_0DB31;
				wire [1:1] sv2v_tmp_6249C;
				assign sv2v_tmp_6249C = 1'b0;
				always @(*) fmt_result_is_special[fmt] = sv2v_tmp_6249C;
			end
		end
	endgenerate
	assign result_is_special = fmt_result_is_special[dst_fmt_q];
	assign special_status = fmt_special_status[dst_fmt_q * 5+:5];
	assign special_result = fmt_special_result[dst_fmt_q * WIDTH+:WIDTH];
	wire signed [EXP_WIDTH - 1:0] exponent_a;
	wire signed [EXP_WIDTH - 1:0] exponent_b;
	wire signed [EXP_WIDTH - 1:0] exponent_c;
	wire signed [EXP_WIDTH - 1:0] exponent_addend;
	wire signed [EXP_WIDTH - 1:0] exponent_product;
	wire signed [EXP_WIDTH - 1:0] exponent_difference;
	wire signed [EXP_WIDTH - 1:0] tentative_exponent;
	assign exponent_a = $signed({1'b0, operand_a[SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)-:((SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)) >= (SUPER_MAN_BITS + 0) ? ((SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)) - (SUPER_MAN_BITS + 0)) + 1 : ((SUPER_MAN_BITS + 0) - (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))) + 1)]});
	assign exponent_b = $signed({1'b0, operand_b[SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)-:((SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)) >= (SUPER_MAN_BITS + 0) ? ((SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)) - (SUPER_MAN_BITS + 0)) + 1 : ((SUPER_MAN_BITS + 0) - (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))) + 1)]});
	assign exponent_c = $signed({1'b0, operand_c[SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)-:((SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)) >= (SUPER_MAN_BITS + 0) ? ((SUPER_EXP_BITS + (SUPER_MAN_BITS - 1)) - (SUPER_MAN_BITS + 0)) + 1 : ((SUPER_MAN_BITS + 0) - (SUPER_EXP_BITS + (SUPER_MAN_BITS - 1))) + 1)]});
	assign exponent_addend = $signed(exponent_c + $signed({1'b0, ~info_c[7]}));
	assign exponent_product = (info_a[5] || info_b[5] ? 2 - $signed(fpnew_pkg_bias(dst_fmt_q)) : $signed(((((exponent_a + info_a[6]) + exponent_b) + info_b[6]) - (2 * $signed(fpnew_pkg_bias(src_fmt_q)))) + $signed(fpnew_pkg_bias(dst_fmt_q))));
	assign exponent_difference = exponent_addend - exponent_product;
	assign tentative_exponent = (exponent_difference > 0 ? exponent_addend : exponent_product);
	reg [SHIFT_AMOUNT_WIDTH - 1:0] addend_shamt;
	always @(*) begin : addend_shift_amount
		if (_sv2v_0)
			;
		if (exponent_difference <= $signed((-2 * PRECISION_BITS) - 1))
			addend_shamt = (3 * PRECISION_BITS) + 4;
		else if (exponent_difference <= $signed(PRECISION_BITS + 2))
			addend_shamt = $unsigned(($signed(PRECISION_BITS) + 3) - exponent_difference);
		else
			addend_shamt = 0;
	end
	wire [PRECISION_BITS - 1:0] mantissa_a;
	wire [PRECISION_BITS - 1:0] mantissa_b;
	wire [PRECISION_BITS - 1:0] mantissa_c;
	wire [(2 * PRECISION_BITS) - 1:0] product;
	wire [(3 * PRECISION_BITS) + 3:0] product_shifted;
	assign mantissa_a = {info_a[7], operand_a[SUPER_MAN_BITS - 1-:SUPER_MAN_BITS]};
	assign mantissa_b = {info_b[7], operand_b[SUPER_MAN_BITS - 1-:SUPER_MAN_BITS]};
	assign mantissa_c = {info_c[7], operand_c[SUPER_MAN_BITS - 1-:SUPER_MAN_BITS]};
	assign product = mantissa_a * mantissa_b;
	assign product_shifted = product << 2;
	wire [(3 * PRECISION_BITS) + 3:0] addend_after_shift;
	wire [PRECISION_BITS - 1:0] addend_sticky_bits;
	wire sticky_before_add;
	wire [(3 * PRECISION_BITS) + 3:0] addend_shifted;
	wire inject_carry_in;
	assign {addend_after_shift, addend_sticky_bits} = (mantissa_c << ((3 * PRECISION_BITS) + 4)) >> addend_shamt;
	assign sticky_before_add = |addend_sticky_bits;
	assign addend_shifted = (effective_subtraction ? ~addend_after_shift : addend_after_shift);
	assign inject_carry_in = effective_subtraction & ~sticky_before_add;
	wire [(3 * PRECISION_BITS) + 4:0] sum_raw;
	wire sum_carry;
	wire [(3 * PRECISION_BITS) + 3:0] sum;
	wire final_sign;
	assign sum_raw = (product_shifted + addend_shifted) + inject_carry_in;
	assign sum_carry = sum_raw[(3 * PRECISION_BITS) + 4];
	assign sum = (effective_subtraction && ~sum_carry ? -sum_raw : sum_raw);
	assign final_sign = (effective_subtraction && (sum_carry == tentative_sign) ? 1'b1 : (effective_subtraction ? 1'b0 : tentative_sign));
	wire effective_subtraction_q;
	wire signed [EXP_WIDTH - 1:0] exponent_product_q;
	wire signed [EXP_WIDTH - 1:0] exponent_difference_q;
	wire signed [EXP_WIDTH - 1:0] tentative_exponent_q;
	wire [SHIFT_AMOUNT_WIDTH - 1:0] addend_shamt_q;
	wire sticky_before_add_q;
	wire [(3 * PRECISION_BITS) + 3:0] sum_q;
	wire final_sign_q;
	wire [2:0] dst_fmt_q2;
	wire [2:0] rnd_mode_q;
	wire result_is_special_q;
	wire [((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS) - 1:0] special_result_q;
	wire [4:0] special_status_q;
	reg [0:NUM_MID_REGS] mid_pipe_eff_sub_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * EXP_WIDTH) + ((NUM_MID_REGS * EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * EXP_WIDTH : 0)] mid_pipe_exp_prod_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * EXP_WIDTH) + ((NUM_MID_REGS * EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * EXP_WIDTH : 0)] mid_pipe_exp_diff_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * EXP_WIDTH) + ((NUM_MID_REGS * EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * EXP_WIDTH : 0)] mid_pipe_tent_exp_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * SHIFT_AMOUNT_WIDTH) + ((NUM_MID_REGS * SHIFT_AMOUNT_WIDTH) - 1) : ((NUM_MID_REGS + 1) * SHIFT_AMOUNT_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * SHIFT_AMOUNT_WIDTH : 0)] mid_pipe_add_shamt_q;
	reg [0:NUM_MID_REGS] mid_pipe_sticky_q;
	reg [(0 >= NUM_MID_REGS ? (((3 * PRECISION_BITS) + 3) >= 0 ? ((1 - NUM_MID_REGS) * ((3 * PRECISION_BITS) + 4)) + ((NUM_MID_REGS * ((3 * PRECISION_BITS) + 4)) - 1) : ((1 - NUM_MID_REGS) * (1 - ((3 * PRECISION_BITS) + 3))) + ((((3 * PRECISION_BITS) + 3) + (NUM_MID_REGS * (1 - ((3 * PRECISION_BITS) + 3)))) - 1)) : (((3 * PRECISION_BITS) + 3) >= 0 ? ((NUM_MID_REGS + 1) * ((3 * PRECISION_BITS) + 4)) - 1 : ((NUM_MID_REGS + 1) * (1 - ((3 * PRECISION_BITS) + 3))) + ((3 * PRECISION_BITS) + 2))):(0 >= NUM_MID_REGS ? (((3 * PRECISION_BITS) + 3) >= 0 ? NUM_MID_REGS * ((3 * PRECISION_BITS) + 4) : ((3 * PRECISION_BITS) + 3) + (NUM_MID_REGS * (1 - ((3 * PRECISION_BITS) + 3)))) : (((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3))] mid_pipe_sum_q;
	reg [0:NUM_MID_REGS] mid_pipe_final_sign_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 3) + ((NUM_MID_REGS * 3) - 1) : ((NUM_MID_REGS + 1) * 3) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 3 : 0)] mid_pipe_rnd_mode_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_MID_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_MID_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] mid_pipe_dst_fmt_q;
	reg [0:NUM_MID_REGS] mid_pipe_res_is_spec_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)) + ((NUM_MID_REGS * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)) - 1) : ((NUM_MID_REGS + 1) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS) : 0)] mid_pipe_spec_res_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 5) + ((NUM_MID_REGS * 5) - 1) : ((NUM_MID_REGS + 1) * 5) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 5 : 0)] mid_pipe_spec_stat_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 10) + ((NUM_MID_REGS * 10) - 1) : ((NUM_MID_REGS + 1) * 10) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 10 : 0)] mid_pipe_tag_q;
	reg [0:NUM_MID_REGS] mid_pipe_mask_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * AuxType_AUX_BITS) + ((NUM_MID_REGS * AuxType_AUX_BITS) - 1) : ((NUM_MID_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * AuxType_AUX_BITS : 0)] mid_pipe_aux_q;
	reg [0:NUM_MID_REGS] mid_pipe_valid_q;
	wire [0:NUM_MID_REGS] mid_pipe_ready;
	wire [1:1] sv2v_tmp_72F3C;
	assign sv2v_tmp_72F3C = effective_subtraction;
	always @(*) mid_pipe_eff_sub_q[0] = sv2v_tmp_72F3C;
	wire [EXP_WIDTH * 1:1] sv2v_tmp_33460;
	assign sv2v_tmp_33460 = exponent_product;
	always @(*) mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH] = sv2v_tmp_33460;
	wire [EXP_WIDTH * 1:1] sv2v_tmp_D58F0;
	assign sv2v_tmp_D58F0 = exponent_difference;
	always @(*) mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH] = sv2v_tmp_D58F0;
	wire [EXP_WIDTH * 1:1] sv2v_tmp_36F3A;
	assign sv2v_tmp_36F3A = tentative_exponent;
	always @(*) mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH] = sv2v_tmp_36F3A;
	wire [SHIFT_AMOUNT_WIDTH * 1:1] sv2v_tmp_670FF;
	assign sv2v_tmp_670FF = addend_shamt;
	always @(*) mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] = sv2v_tmp_670FF;
	wire [1:1] sv2v_tmp_D9513;
	assign sv2v_tmp_D9513 = sticky_before_add;
	always @(*) mid_pipe_sticky_q[0] = sv2v_tmp_D9513;
	wire [(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)) * 1:1] sv2v_tmp_7FA5A;
	assign sv2v_tmp_7FA5A = sum;
	always @(*) mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] = sv2v_tmp_7FA5A;
	wire [1:1] sv2v_tmp_E5D4B;
	assign sv2v_tmp_E5D4B = final_sign;
	always @(*) mid_pipe_final_sign_q[0] = sv2v_tmp_E5D4B;
	wire [3:1] sv2v_tmp_24A07;
	assign sv2v_tmp_24A07 = inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3];
	always @(*) mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 3+:3] = sv2v_tmp_24A07;
	wire [3:1] sv2v_tmp_B536C;
	assign sv2v_tmp_B536C = dst_fmt_q;
	always @(*) mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_B536C;
	wire [1:1] sv2v_tmp_7E156;
	assign sv2v_tmp_7E156 = result_is_special;
	always @(*) mid_pipe_res_is_spec_q[0] = sv2v_tmp_7E156;
	wire [((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS) * 1:1] sv2v_tmp_D459F;
	assign sv2v_tmp_D459F = special_result;
	always @(*) mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)+:(1 + SUPER_EXP_BITS) + SUPER_MAN_BITS] = sv2v_tmp_D459F;
	wire [5:1] sv2v_tmp_AC961;
	assign sv2v_tmp_AC961 = special_status;
	always @(*) mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 5+:5] = sv2v_tmp_AC961;
	wire [10:1] sv2v_tmp_0B7F8;
	assign sv2v_tmp_0B7F8 = inp_pipe_tag_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 10+:10];
	always @(*) mid_pipe_tag_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 10+:10] = sv2v_tmp_0B7F8;
	wire [1:1] sv2v_tmp_2E03C;
	assign sv2v_tmp_2E03C = inp_pipe_mask_q[NUM_INP_REGS];
	always @(*) mid_pipe_mask_q[0] = sv2v_tmp_2E03C;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_BC968;
	assign sv2v_tmp_BC968 = inp_pipe_aux_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	always @(*) mid_pipe_aux_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_BC968;
	wire [1:1] sv2v_tmp_3D86F;
	assign sv2v_tmp_3D86F = inp_pipe_valid_q[NUM_INP_REGS];
	always @(*) mid_pipe_valid_q[0] = sv2v_tmp_3D86F;
	assign inp_pipe_ready[NUM_INP_REGS] = mid_pipe_ready[0];
	genvar _gv_i_6;
	generate
		for (_gv_i_6 = 0; _gv_i_6 < NUM_MID_REGS; _gv_i_6 = _gv_i_6 + 1) begin : gen_inside_pipeline
			localparam i = _gv_i_6;
			wire reg_ena;
			assign mid_pipe_ready[i] = mid_pipe_ready[i + 1] | ~mid_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_valid_q[i + 1] <= 1'b0;
				else
					mid_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (mid_pipe_ready[i] ? mid_pipe_valid_q[i] : mid_pipe_valid_q[i + 1]));
			assign reg_ena = (mid_pipe_ready[i] & mid_pipe_valid_q[i]) | reg_ena_i[NUM_INP_REGS + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_eff_sub_q[i + 1] <= 1'sb0;
				else
					mid_pipe_eff_sub_q[i + 1] <= (reg_ena ? mid_pipe_eff_sub_q[i] : mid_pipe_eff_sub_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= (reg_ena ? mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * EXP_WIDTH+:EXP_WIDTH] : mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= (reg_ena ? mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * EXP_WIDTH+:EXP_WIDTH] : mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH] <= (reg_ena ? mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * EXP_WIDTH+:EXP_WIDTH] : mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * EXP_WIDTH+:EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] <= 1'sb0;
				else
					mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] <= (reg_ena ? mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH] : mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_sticky_q[i + 1] <= 1'sb0;
				else
					mid_pipe_sticky_q[i + 1] <= (reg_ena ? mid_pipe_sticky_q[i] : mid_pipe_sticky_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] <= 1'sb0;
				else
					mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] <= (reg_ena ? mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))] : mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_final_sign_q[i + 1] <= 1'sb0;
				else
					mid_pipe_final_sign_q[i + 1] <= (reg_ena ? mid_pipe_final_sign_q[i] : mid_pipe_final_sign_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3] <= (reg_ena ? mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 3+:3] : mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_res_is_spec_q[i + 1] <= 1'sb0;
				else
					mid_pipe_res_is_spec_q[i + 1] <= (reg_ena ? mid_pipe_res_is_spec_q[i] : mid_pipe_res_is_spec_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)+:(1 + SUPER_EXP_BITS) + SUPER_MAN_BITS] <= 1'sb0;
				else
					mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)+:(1 + SUPER_EXP_BITS) + SUPER_MAN_BITS] <= (reg_ena ? mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)+:(1 + SUPER_EXP_BITS) + SUPER_MAN_BITS] : mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)+:(1 + SUPER_EXP_BITS) + SUPER_MAN_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 5+:5] <= (reg_ena ? mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 5+:5] : mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10] <= (reg_ena ? mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 10+:10] : mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_mask_q[i + 1] <= 1'sb0;
				else
					mid_pipe_mask_q[i + 1] <= (reg_ena ? mid_pipe_mask_q[i] : mid_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign effective_subtraction_q = mid_pipe_eff_sub_q[NUM_MID_REGS];
	assign exponent_product_q = mid_pipe_exp_prod_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH];
	assign exponent_difference_q = mid_pipe_exp_diff_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH];
	assign tentative_exponent_q = mid_pipe_tent_exp_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * EXP_WIDTH+:EXP_WIDTH];
	assign addend_shamt_q = mid_pipe_add_shamt_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * SHIFT_AMOUNT_WIDTH+:SHIFT_AMOUNT_WIDTH];
	assign sticky_before_add_q = mid_pipe_sticky_q[NUM_MID_REGS];
	assign sum_q = mid_pipe_sum_q[(((3 * PRECISION_BITS) + 3) >= 0 ? 0 : (3 * PRECISION_BITS) + 3) + ((0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * (((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3)))+:(((3 * PRECISION_BITS) + 3) >= 0 ? (3 * PRECISION_BITS) + 4 : 1 - ((3 * PRECISION_BITS) + 3))];
	assign final_sign_q = mid_pipe_final_sign_q[NUM_MID_REGS];
	assign rnd_mode_q = mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 3+:3];
	assign dst_fmt_q2 = mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign result_is_special_q = mid_pipe_res_is_spec_q[NUM_MID_REGS];
	assign special_result_q = mid_pipe_spec_res_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * ((1 + SUPER_EXP_BITS) + SUPER_MAN_BITS)+:(1 + SUPER_EXP_BITS) + SUPER_MAN_BITS];
	assign special_status_q = mid_pipe_spec_stat_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 5+:5];
	wire [LOWER_SUM_WIDTH - 1:0] sum_lower;
	wire [LZC_RESULT_WIDTH - 1:0] leading_zero_count;
	wire signed [LZC_RESULT_WIDTH:0] leading_zero_count_sgn;
	wire lzc_zeroes;
	reg [SHIFT_AMOUNT_WIDTH - 1:0] norm_shamt;
	reg signed [EXP_WIDTH - 1:0] normalized_exponent;
	wire [(3 * PRECISION_BITS) + 4:0] sum_shifted;
	reg [PRECISION_BITS:0] final_mantissa;
	reg [(2 * PRECISION_BITS) + 2:0] sum_sticky_bits;
	wire sticky_after_norm;
	reg signed [EXP_WIDTH - 1:0] final_exponent;
	assign sum_lower = sum_q[LOWER_SUM_WIDTH - 1:0];
	lzc #(
		.WIDTH(LOWER_SUM_WIDTH),
		.MODE(1)
	) i_lzc(
		.in_i(sum_lower),
		.cnt_o(leading_zero_count),
		.empty_o(lzc_zeroes)
	);
	assign leading_zero_count_sgn = $signed({1'b0, leading_zero_count});
	always @(*) begin : norm_shift_amount
		if (_sv2v_0)
			;
		if ((exponent_difference_q <= 0) || (effective_subtraction_q && (exponent_difference_q <= 2))) begin
			if ((((exponent_product_q - leading_zero_count_sgn) + 1) >= 0) && !lzc_zeroes) begin
				norm_shamt = (PRECISION_BITS + 2) + leading_zero_count;
				normalized_exponent = (exponent_product_q - leading_zero_count_sgn) + 1;
			end
			else begin
				norm_shamt = $unsigned($signed((PRECISION_BITS + 2) + exponent_product_q));
				normalized_exponent = 0;
			end
		end
		else begin
			norm_shamt = addend_shamt_q;
			normalized_exponent = tentative_exponent_q;
		end
	end
	assign sum_shifted = sum_q << norm_shamt;
	always @(*) begin : small_norm
		if (_sv2v_0)
			;
		{final_mantissa, sum_sticky_bits} = sum_shifted;
		final_exponent = normalized_exponent;
		if (sum_shifted[(3 * PRECISION_BITS) + 4]) begin
			{final_mantissa, sum_sticky_bits} = sum_shifted >> 1;
			final_exponent = normalized_exponent + 1;
		end
		else if (sum_shifted[(3 * PRECISION_BITS) + 3])
			;
		else if (normalized_exponent > 1) begin
			{final_mantissa, sum_sticky_bits} = sum_shifted << 1;
			final_exponent = normalized_exponent - 1;
		end
		else
			final_exponent = 1'sb0;
	end
	assign sticky_after_norm = |{sum_sticky_bits} | sticky_before_add_q;
	wire pre_round_sign;
	wire [(SUPER_EXP_BITS + SUPER_MAN_BITS) - 1:0] pre_round_abs;
	wire [1:0] round_sticky_bits;
	wire of_before_round;
	wire of_after_round;
	wire uf_before_round;
	wire uf_after_round;
	wire [(NUM_FORMATS * (SUPER_EXP_BITS + SUPER_MAN_BITS)) - 1:0] fmt_pre_round_abs;
	wire [9:0] fmt_round_sticky_bits;
	reg [4:0] fmt_of_after_round;
	reg [4:0] fmt_uf_after_round;
	wire rounded_sign;
	wire [(SUPER_EXP_BITS + SUPER_MAN_BITS) - 1:0] rounded_abs;
	wire result_zero;
	assign of_before_round = final_exponent >= ((2 ** fpnew_pkg_exp_bits(dst_fmt_q2)) - 1);
	assign uf_before_round = final_exponent == 0;
	genvar _gv_fmt_6;
	generate
		for (_gv_fmt_6 = 0; _gv_fmt_6 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_6 = _gv_fmt_6 + 1) begin : gen_res_assemble
			localparam fmt = _gv_fmt_6;
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			wire [EXP_BITS - 1:0] pre_round_exponent;
			wire [MAN_BITS - 1:0] pre_round_mantissa;
			if (FpFmtConfig[fmt]) begin : active_format
				assign pre_round_exponent = (of_before_round ? (2 ** EXP_BITS) - 2 : final_exponent[EXP_BITS - 1:0]);
				assign pre_round_mantissa = (of_before_round ? {fpnew_pkg_man_bits(sv2v_cast_9FB13(_gv_fmt_6)) {1'sb1}} : final_mantissa[SUPER_MAN_BITS-:MAN_BITS]);
				assign fmt_pre_round_abs[fmt * (SUPER_EXP_BITS + SUPER_MAN_BITS)+:SUPER_EXP_BITS + SUPER_MAN_BITS] = {pre_round_exponent, pre_round_mantissa};
				assign fmt_round_sticky_bits[(fmt * 2) + 1] = final_mantissa[SUPER_MAN_BITS - MAN_BITS] | of_before_round;
				if (MAN_BITS < SUPER_MAN_BITS) begin : narrow_sticky
					assign fmt_round_sticky_bits[fmt * 2] = (|final_mantissa[(SUPER_MAN_BITS - MAN_BITS) - 1:0] | sticky_after_norm) | of_before_round;
				end
				else begin : normal_sticky
					assign fmt_round_sticky_bits[fmt * 2] = sticky_after_norm | of_before_round;
				end
			end
			else begin : inactive_format
				assign fmt_pre_round_abs[fmt * (SUPER_EXP_BITS + SUPER_MAN_BITS)+:SUPER_EXP_BITS + SUPER_MAN_BITS] = {SUPER_EXP_BITS + SUPER_MAN_BITS {fpnew_pkg_DONT_CARE}};
				assign fmt_round_sticky_bits[fmt * 2+:2] = {2 {fpnew_pkg_DONT_CARE}};
			end
		end
	endgenerate
	assign pre_round_sign = final_sign_q;
	assign pre_round_abs = fmt_pre_round_abs[dst_fmt_q2 * (SUPER_EXP_BITS + SUPER_MAN_BITS)+:SUPER_EXP_BITS + SUPER_MAN_BITS];
	assign round_sticky_bits = fmt_round_sticky_bits[dst_fmt_q2 * 2+:2];
	fpnew_rounding #(.AbsWidth(SUPER_EXP_BITS + SUPER_MAN_BITS)) i_fpnew_rounding(
		.abs_value_i(pre_round_abs),
		.sign_i(pre_round_sign),
		.round_sticky_bits_i(round_sticky_bits),
		.rnd_mode_i(rnd_mode_q),
		.effective_subtraction_i(effective_subtraction_q),
		.abs_rounded_o(rounded_abs),
		.sign_o(rounded_sign),
		.exact_zero_o(result_zero)
	);
	reg [(NUM_FORMATS * WIDTH) - 1:0] fmt_result;
	genvar _gv_fmt_7;
	generate
		for (_gv_fmt_7 = 0; _gv_fmt_7 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_7 = _gv_fmt_7 + 1) begin : gen_sign_inject
			localparam fmt = _gv_fmt_7;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			if (FpFmtConfig[fmt]) begin : active_format
				always @(*) begin : post_process
					if (_sv2v_0)
						;
					fmt_uf_after_round[fmt] = (rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb0}}) || (((pre_round_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb0}}) && (rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == 1)) && ((round_sticky_bits != 2'b11) || (!sum_sticky_bits[(MAN_BITS * 2) + 4] && ((rnd_mode_i == 3'b000) || (rnd_mode_i == 3'b100)))));
					fmt_of_after_round[fmt] = rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb1}};
					fmt_result[fmt * WIDTH+:WIDTH] = 1'sb1;
					fmt_result[(fmt * WIDTH) + (FP_WIDTH - 1)-:FP_WIDTH] = {rounded_sign, rounded_abs[(EXP_BITS + MAN_BITS) - 1:0]};
				end
			end
			else begin : inactive_format
				wire [1:1] sv2v_tmp_DD825;
				assign sv2v_tmp_DD825 = fpnew_pkg_DONT_CARE;
				always @(*) fmt_uf_after_round[fmt] = sv2v_tmp_DD825;
				wire [1:1] sv2v_tmp_358EF;
				assign sv2v_tmp_358EF = fpnew_pkg_DONT_CARE;
				always @(*) fmt_of_after_round[fmt] = sv2v_tmp_358EF;
				wire [WIDTH * 1:1] sv2v_tmp_C89CB;
				assign sv2v_tmp_C89CB = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) fmt_result[fmt * WIDTH+:WIDTH] = sv2v_tmp_C89CB;
			end
		end
	endgenerate
	assign uf_after_round = fmt_uf_after_round[dst_fmt_q2];
	assign of_after_round = fmt_of_after_round[dst_fmt_q2];
	wire [WIDTH - 1:0] regular_result;
	wire [4:0] regular_status;
	assign regular_result = fmt_result[dst_fmt_q2 * WIDTH+:WIDTH];
	assign regular_status[4] = 1'b0;
	assign regular_status[3] = 1'b0;
	assign regular_status[2] = of_before_round | of_after_round;
	assign regular_status[1] = uf_after_round & regular_status[0];
	assign regular_status[0] = (|round_sticky_bits | of_before_round) | of_after_round;
	wire [WIDTH - 1:0] result_d;
	wire [4:0] status_d;
	assign result_d = (result_is_special_q ? special_result_q : regular_result);
	assign status_d = (result_is_special_q ? special_status_q : regular_status);
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * WIDTH) + ((NUM_OUT_REGS * WIDTH) - 1) : ((NUM_OUT_REGS + 1) * WIDTH) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * WIDTH : 0)] out_pipe_result_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 5) + ((NUM_OUT_REGS * 5) - 1) : ((NUM_OUT_REGS + 1) * 5) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 5 : 0)] out_pipe_status_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_tag_q;
	reg [0:NUM_OUT_REGS] out_pipe_mask_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * AuxType_AUX_BITS) + ((NUM_OUT_REGS * AuxType_AUX_BITS) - 1) : ((NUM_OUT_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * AuxType_AUX_BITS : 0)] out_pipe_aux_q;
	reg [0:NUM_OUT_REGS] out_pipe_valid_q;
	wire [0:NUM_OUT_REGS] out_pipe_ready;
	wire [WIDTH * 1:1] sv2v_tmp_8CCB4;
	assign sv2v_tmp_8CCB4 = result_d;
	always @(*) out_pipe_result_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * WIDTH+:WIDTH] = sv2v_tmp_8CCB4;
	wire [5:1] sv2v_tmp_1B7C7;
	assign sv2v_tmp_1B7C7 = status_d;
	always @(*) out_pipe_status_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 5+:5] = sv2v_tmp_1B7C7;
	wire [10:1] sv2v_tmp_52A4D;
	assign sv2v_tmp_52A4D = mid_pipe_tag_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 10+:10];
	always @(*) out_pipe_tag_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_52A4D;
	wire [1:1] sv2v_tmp_F68B4;
	assign sv2v_tmp_F68B4 = mid_pipe_mask_q[NUM_MID_REGS];
	always @(*) out_pipe_mask_q[0] = sv2v_tmp_F68B4;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_4BAB7;
	assign sv2v_tmp_4BAB7 = mid_pipe_aux_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	always @(*) out_pipe_aux_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_4BAB7;
	wire [1:1] sv2v_tmp_39CE2;
	assign sv2v_tmp_39CE2 = mid_pipe_valid_q[NUM_MID_REGS];
	always @(*) out_pipe_valid_q[0] = sv2v_tmp_39CE2;
	assign mid_pipe_ready[NUM_MID_REGS] = out_pipe_ready[0];
	genvar _gv_i_7;
	generate
		for (_gv_i_7 = 0; _gv_i_7 < NUM_OUT_REGS; _gv_i_7 = _gv_i_7 + 1) begin : gen_output_pipeline
			localparam i = _gv_i_7;
			wire reg_ena;
			assign out_pipe_ready[i] = out_pipe_ready[i + 1] | ~out_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_valid_q[i + 1] <= 1'b0;
				else
					out_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (out_pipe_ready[i] ? out_pipe_valid_q[i] : out_pipe_valid_q[i + 1]));
			assign reg_ena = (out_pipe_ready[i] & out_pipe_valid_q[i]) | reg_ena_i[(NUM_INP_REGS + NUM_MID_REGS) + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= 1'sb0;
				else
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= (reg_ena ? out_pipe_result_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * WIDTH+:WIDTH] : out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= (reg_ena ? out_pipe_status_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 5+:5] : out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_mask_q[i + 1] <= 1'sb0;
				else
					out_pipe_mask_q[i + 1] <= (reg_ena ? out_pipe_mask_q[i] : out_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign out_pipe_ready[NUM_OUT_REGS] = out_ready_i;
	assign result_o = out_pipe_result_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * WIDTH+:WIDTH];
	assign status_o = out_pipe_status_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 5+:5];
	assign extension_bit_o = 1'b1;
	assign tag_o = out_pipe_tag_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign mask_o = out_pipe_mask_q[NUM_OUT_REGS];
	assign aux_o = out_pipe_aux_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	assign out_valid_o = out_pipe_valid_q[NUM_OUT_REGS];
	assign busy_o = |{inp_pipe_valid_q, mid_pipe_valid_q, out_pipe_valid_q};
	initial _sv2v_0 = 0;
endmodule
module fpnew_noncomp_79CB0 (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	tag_i,
	mask_i,
	aux_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	class_mask_o,
	is_class_o,
	tag_o,
	mask_o,
	aux_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	parameter [2:0] FpFormat = sv2v_cast_9FB13(0);
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	localparam [31:0] WIDTH = fpnew_pkg_fp_width(FpFormat);
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [(2 * WIDTH) - 1:0] operands_i;
	input wire [1:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [9:0] tag_i;
	input wire mask_i;
	input wire aux_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [WIDTH - 1:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] class_mask_o;
	output wire is_class_o;
	output wire [9:0] tag_o;
	output wire mask_o;
	output wire aux_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	function automatic [31:0] fpnew_pkg_exp_bits;
		input reg [2:0] fmt;
		fpnew_pkg_exp_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32];
	endfunction
	localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(FpFormat);
	function automatic [31:0] fpnew_pkg_man_bits;
		input reg [2:0] fmt;
		fpnew_pkg_man_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32];
	endfunction
	localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(FpFormat);
	localparam NUM_INP_REGS = ((PipeConfig == 2'd0) || (PipeConfig == 2'd2) ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 1) / 2 : 0));
	localparam NUM_OUT_REGS = (PipeConfig == 2'd1 ? NumPipeRegs : (PipeConfig == 2'd3 ? NumPipeRegs / 2 : 0));
	reg [((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) - (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) * WIDTH) - 1) : ((((0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) * WIDTH) - 1)):((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) * WIDTH : (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) * WIDTH)] inp_pipe_operands_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0)] inp_pipe_is_boxed_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_rnd_mode_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_OP_BITS) + ((NUM_INP_REGS * fpnew_pkg_OP_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_OP_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_OP_BITS : 0)] inp_pipe_op_q;
	reg [0:NUM_INP_REGS] inp_pipe_op_mod_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 10) + ((NUM_INP_REGS * 10) - 1) : ((NUM_INP_REGS + 1) * 10) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 10 : 0)] inp_pipe_tag_q;
	reg [0:NUM_INP_REGS] inp_pipe_mask_q;
	reg [0:NUM_INP_REGS] inp_pipe_aux_q;
	reg [0:NUM_INP_REGS] inp_pipe_valid_q;
	wire [0:NUM_INP_REGS] inp_pipe_ready;
	wire [2 * WIDTH:1] sv2v_tmp_F8807;
	assign sv2v_tmp_F8807 = operands_i;
	always @(*) inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] = sv2v_tmp_F8807;
	wire [2:1] sv2v_tmp_CD89A;
	assign sv2v_tmp_CD89A = is_boxed_i;
	always @(*) inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2+:2] = sv2v_tmp_CD89A;
	wire [3:1] sv2v_tmp_6B838;
	assign sv2v_tmp_6B838 = rnd_mode_i;
	always @(*) inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_6B838;
	wire [4:1] sv2v_tmp_D9BC9;
	assign sv2v_tmp_D9BC9 = op_i;
	always @(*) inp_pipe_op_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] = sv2v_tmp_D9BC9;
	wire [1:1] sv2v_tmp_42D74;
	assign sv2v_tmp_42D74 = op_mod_i;
	always @(*) inp_pipe_op_mod_q[0] = sv2v_tmp_42D74;
	wire [10:1] sv2v_tmp_93FC2;
	assign sv2v_tmp_93FC2 = tag_i;
	always @(*) inp_pipe_tag_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 10+:10] = sv2v_tmp_93FC2;
	wire [1:1] sv2v_tmp_43EE3;
	assign sv2v_tmp_43EE3 = mask_i;
	always @(*) inp_pipe_mask_q[0] = sv2v_tmp_43EE3;
	wire [1:1] sv2v_tmp_E1D93;
	assign sv2v_tmp_E1D93 = aux_i;
	always @(*) inp_pipe_aux_q[0] = sv2v_tmp_E1D93;
	wire [1:1] sv2v_tmp_9CFD6;
	assign sv2v_tmp_9CFD6 = in_valid_i;
	always @(*) inp_pipe_valid_q[0] = sv2v_tmp_9CFD6;
	assign in_ready_o = inp_pipe_ready[0];
	genvar _gv_i_8;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	generate
		for (_gv_i_8 = 0; _gv_i_8 < NUM_INP_REGS; _gv_i_8 = _gv_i_8 + 1) begin : gen_input_pipeline
			localparam i = _gv_i_8;
			wire reg_ena;
			assign inp_pipe_ready[i] = inp_pipe_ready[i + 1] | ~inp_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_valid_q[i + 1] <= 1'b0;
				else
					inp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (inp_pipe_ready[i] ? inp_pipe_valid_q[i] : inp_pipe_valid_q[i + 1]));
			assign reg_ena = (inp_pipe_ready[i] & inp_pipe_valid_q[i]) | reg_ena_i[i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] <= 1'sb0;
				else
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] <= (reg_ena ? inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] : inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2+:2] <= 1'sb0;
				else
					inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2+:2] <= (reg_ena ? inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2+:2] : inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2+:2]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= sv2v_cast_7BCAE(0);
				else
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= (reg_ena ? inp_pipe_op_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] : inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_mod_q[i + 1] <= 1'sb0;
				else
					inp_pipe_op_mod_q[i + 1] <= (reg_ena ? inp_pipe_op_mod_q[i] : inp_pipe_op_mod_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= (reg_ena ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 10+:10] : inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_mask_q[i + 1] <= 1'sb0;
				else
					inp_pipe_mask_q[i + 1] <= (reg_ena ? inp_pipe_mask_q[i] : inp_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_aux_q[i + 1] <= 1'b0;
				else
					inp_pipe_aux_q[i + 1] <= (reg_ena ? inp_pipe_aux_q[i] : inp_pipe_aux_q[i + 1]);
		end
	endgenerate
	wire [15:0] info_q;
	fpnew_classifier #(
		.FpFormat(FpFormat),
		.NumOperands(2)
	) i_class_a(
		.operands_i(inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2]),
		.is_boxed_i(inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2+:2]),
		.info_o(info_q)
	);
	wire [((1 + EXP_BITS) + MAN_BITS) - 1:0] operand_a;
	wire [((1 + EXP_BITS) + MAN_BITS) - 1:0] operand_b;
	wire [7:0] info_a;
	wire [7:0] info_b;
	assign operand_a = inp_pipe_operands_q[((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1))) * WIDTH+:WIDTH];
	assign operand_b = inp_pipe_operands_q[((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1 : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - ((((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1))) * WIDTH+:WIDTH];
	assign info_a = info_q[0+:8];
	assign info_b = info_q[8+:8];
	wire any_operand_inf;
	wire any_operand_nan;
	wire signalling_nan;
	assign any_operand_inf = |{info_a[4], info_b[4]};
	assign any_operand_nan = |{info_a[3], info_b[3]};
	assign signalling_nan = |{info_a[2], info_b[2]};
	wire operands_equal;
	wire operand_a_smaller;
	assign operands_equal = (operand_a == operand_b) || (info_a[5] && info_b[5]);
	assign operand_a_smaller = (operand_a < operand_b) ^ (operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] || operand_b[1 + (EXP_BITS + (MAN_BITS - 1))]);
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] sgnj_result;
	wire [4:0] sgnj_status;
	wire sgnj_extension_bit;
	localparam [0:0] fpnew_pkg_DONT_CARE = 1'b1;
	function automatic [EXP_BITS - 1:0] sv2v_cast_641B7;
		input reg [EXP_BITS - 1:0] inp;
		sv2v_cast_641B7 = inp;
	endfunction
	function automatic [MAN_BITS - 1:0] sv2v_cast_33A5C;
		input reg [MAN_BITS - 1:0] inp;
		sv2v_cast_33A5C = inp;
	endfunction
	function automatic [EXP_BITS - 1:0] sv2v_cast_DBE99;
		input reg [EXP_BITS - 1:0] inp;
		sv2v_cast_DBE99 = inp;
	endfunction
	always @(*) begin : sign_injections
		reg sign_a;
		reg sign_b;
		if (_sv2v_0)
			;
		sgnj_result = operand_a;
		if (!info_a[0])
			sgnj_result = {1'b0, sv2v_cast_641B7(1'sb1), sv2v_cast_33A5C(2 ** (MAN_BITS - 1))};
		sign_a = operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] & info_a[0];
		sign_b = operand_b[1 + (EXP_BITS + (MAN_BITS - 1))] & info_b[0];
		(* full_case, parallel_case *)
		case (inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3])
			3'b000: sgnj_result[1 + (EXP_BITS + (MAN_BITS - 1))] = sign_b;
			3'b001: sgnj_result[1 + (EXP_BITS + (MAN_BITS - 1))] = ~sign_b;
			3'b010: sgnj_result[1 + (EXP_BITS + (MAN_BITS - 1))] = sign_a ^ sign_b;
			3'b011: sgnj_result = operand_a;
			default: sgnj_result = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
		endcase
	end
	assign sgnj_status = 1'sb0;
	assign sgnj_extension_bit = (inp_pipe_op_mod_q[NUM_INP_REGS] ? sgnj_result[1 + (EXP_BITS + (MAN_BITS - 1))] : 1'b1);
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] minmax_result;
	reg [4:0] minmax_status;
	wire minmax_extension_bit;
	always @(*) begin : min_max
		if (_sv2v_0)
			;
		minmax_status = 1'sb0;
		minmax_status[4] = signalling_nan;
		if (info_a[3] && info_b[3])
			minmax_result = {1'b0, sv2v_cast_641B7(1'sb1), sv2v_cast_33A5C(2 ** (MAN_BITS - 1))};
		else if (info_a[3])
			minmax_result = operand_b;
		else if (info_b[3])
			minmax_result = operand_a;
		else
			(* full_case, parallel_case *)
			case (inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3])
				3'b000: minmax_result = (operand_a_smaller ? operand_a : operand_b);
				3'b001: minmax_result = (operand_a_smaller ? operand_b : operand_a);
				default: minmax_result = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
			endcase
	end
	assign minmax_extension_bit = 1'b1;
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] cmp_result;
	reg [4:0] cmp_status;
	wire cmp_extension_bit;
	always @(*) begin : comparisons
		if (_sv2v_0)
			;
		cmp_result = 1'sb0;
		cmp_status = 1'sb0;
		if (signalling_nan)
			cmp_status[4] = 1'b1;
		else
			(* full_case, parallel_case *)
			case (inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3])
				3'b000:
					if (any_operand_nan)
						cmp_status[4] = 1'b1;
					else
						cmp_result = (operand_a_smaller | operands_equal) ^ inp_pipe_op_mod_q[NUM_INP_REGS];
				3'b001:
					if (any_operand_nan)
						cmp_status[4] = 1'b1;
					else
						cmp_result = (operand_a_smaller & ~operands_equal) ^ inp_pipe_op_mod_q[NUM_INP_REGS];
				3'b010:
					if (any_operand_nan)
						cmp_result = inp_pipe_op_mod_q[NUM_INP_REGS];
					else
						cmp_result = operands_equal ^ inp_pipe_op_mod_q[NUM_INP_REGS];
				default: cmp_result = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
			endcase
	end
	assign cmp_extension_bit = 1'b0;
	wire [4:0] class_status;
	wire class_extension_bit;
	reg [9:0] class_mask_d;
	always @(*) begin : classify
		if (_sv2v_0)
			;
		if (info_a[7])
			class_mask_d = (operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ? 10'b0000000010 : 10'b0001000000);
		else if (info_a[6])
			class_mask_d = (operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ? 10'b0000000100 : 10'b0000100000);
		else if (info_a[5])
			class_mask_d = (operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ? 10'b0000001000 : 10'b0000010000);
		else if (info_a[4])
			class_mask_d = (operand_a[1 + (EXP_BITS + (MAN_BITS - 1))] ? 10'b0000000001 : 10'b0010000000);
		else if (info_a[3])
			class_mask_d = (info_a[2] ? 10'b0100000000 : 10'b1000000000);
		else
			class_mask_d = 10'b1000000000;
	end
	assign class_status = 1'sb0;
	assign class_extension_bit = 1'b0;
	reg [((1 + EXP_BITS) + MAN_BITS) - 1:0] result_d;
	reg [4:0] status_d;
	reg extension_bit_d;
	wire is_class_d;
	always @(*) begin : select_result
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS])
			sv2v_cast_7BCAE(6): begin
				result_d = sgnj_result;
				status_d = sgnj_status;
				extension_bit_d = sgnj_extension_bit;
			end
			sv2v_cast_7BCAE(7): begin
				result_d = minmax_result;
				status_d = minmax_status;
				extension_bit_d = minmax_extension_bit;
			end
			sv2v_cast_7BCAE(8): begin
				result_d = cmp_result;
				status_d = cmp_status;
				extension_bit_d = cmp_extension_bit;
			end
			sv2v_cast_7BCAE(9): begin
				result_d = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
				status_d = class_status;
				extension_bit_d = class_extension_bit;
			end
			default: begin
				result_d = {fpnew_pkg_DONT_CARE, sv2v_cast_DBE99(fpnew_pkg_DONT_CARE), sv2v_cast_33A5C(fpnew_pkg_DONT_CARE)};
				status_d = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				extension_bit_d = fpnew_pkg_DONT_CARE;
			end
		endcase
	end
	assign is_class_d = inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] == sv2v_cast_7BCAE(9);
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * ((1 + EXP_BITS) + MAN_BITS)) + ((NUM_OUT_REGS * ((1 + EXP_BITS) + MAN_BITS)) - 1) : ((NUM_OUT_REGS + 1) * ((1 + EXP_BITS) + MAN_BITS)) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * ((1 + EXP_BITS) + MAN_BITS) : 0)] out_pipe_result_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 5) + ((NUM_OUT_REGS * 5) - 1) : ((NUM_OUT_REGS + 1) * 5) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 5 : 0)] out_pipe_status_q;
	reg [0:NUM_OUT_REGS] out_pipe_extension_bit_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_class_mask_q;
	reg [0:NUM_OUT_REGS] out_pipe_is_class_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_tag_q;
	reg [0:NUM_OUT_REGS] out_pipe_mask_q;
	reg [0:NUM_OUT_REGS] out_pipe_aux_q;
	reg [0:NUM_OUT_REGS] out_pipe_valid_q;
	wire [0:NUM_OUT_REGS] out_pipe_ready;
	wire [((1 + EXP_BITS) + MAN_BITS) * 1:1] sv2v_tmp_BDBA0;
	assign sv2v_tmp_BDBA0 = result_d;
	always @(*) out_pipe_result_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] = sv2v_tmp_BDBA0;
	wire [5:1] sv2v_tmp_F85FB;
	assign sv2v_tmp_F85FB = status_d;
	always @(*) out_pipe_status_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 5+:5] = sv2v_tmp_F85FB;
	wire [1:1] sv2v_tmp_43031;
	assign sv2v_tmp_43031 = extension_bit_d;
	always @(*) out_pipe_extension_bit_q[0] = sv2v_tmp_43031;
	wire [10:1] sv2v_tmp_8049D;
	assign sv2v_tmp_8049D = class_mask_d;
	always @(*) out_pipe_class_mask_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_8049D;
	wire [1:1] sv2v_tmp_7DA92;
	assign sv2v_tmp_7DA92 = is_class_d;
	always @(*) out_pipe_is_class_q[0] = sv2v_tmp_7DA92;
	wire [10:1] sv2v_tmp_5F04B;
	assign sv2v_tmp_5F04B = inp_pipe_tag_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 10+:10];
	always @(*) out_pipe_tag_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_5F04B;
	wire [1:1] sv2v_tmp_A9F63;
	assign sv2v_tmp_A9F63 = inp_pipe_mask_q[NUM_INP_REGS];
	always @(*) out_pipe_mask_q[0] = sv2v_tmp_A9F63;
	wire [1:1] sv2v_tmp_024FB;
	assign sv2v_tmp_024FB = inp_pipe_aux_q[NUM_INP_REGS];
	always @(*) out_pipe_aux_q[0] = sv2v_tmp_024FB;
	wire [1:1] sv2v_tmp_23287;
	assign sv2v_tmp_23287 = inp_pipe_valid_q[NUM_INP_REGS];
	always @(*) out_pipe_valid_q[0] = sv2v_tmp_23287;
	assign inp_pipe_ready[NUM_INP_REGS] = out_pipe_ready[0];
	genvar _gv_i_9;
	generate
		for (_gv_i_9 = 0; _gv_i_9 < NUM_OUT_REGS; _gv_i_9 = _gv_i_9 + 1) begin : gen_output_pipeline
			localparam i = _gv_i_9;
			wire reg_ena;
			assign out_pipe_ready[i] = out_pipe_ready[i + 1] | ~out_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_valid_q[i + 1] <= 1'b0;
				else
					out_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (out_pipe_ready[i] ? out_pipe_valid_q[i] : out_pipe_valid_q[i + 1]));
			assign reg_ena = (out_pipe_ready[i] & out_pipe_valid_q[i]) | reg_ena_i[NUM_INP_REGS + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] <= 1'sb0;
				else
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] <= (reg_ena ? out_pipe_result_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS] : out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= (reg_ena ? out_pipe_status_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 5+:5] : out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_extension_bit_q[i + 1] <= 1'sb0;
				else
					out_pipe_extension_bit_q[i + 1] <= (reg_ena ? out_pipe_extension_bit_q[i] : out_pipe_extension_bit_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_class_mask_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b1000000000;
				else
					out_pipe_class_mask_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_class_mask_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_class_mask_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_is_class_q[i + 1] <= 1'sb0;
				else
					out_pipe_is_class_q[i + 1] <= (reg_ena ? out_pipe_is_class_q[i] : out_pipe_is_class_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_mask_q[i + 1] <= 1'sb0;
				else
					out_pipe_mask_q[i + 1] <= (reg_ena ? out_pipe_mask_q[i] : out_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_aux_q[i + 1] <= 1'b0;
				else
					out_pipe_aux_q[i + 1] <= (reg_ena ? out_pipe_aux_q[i] : out_pipe_aux_q[i + 1]);
		end
	endgenerate
	assign out_pipe_ready[NUM_OUT_REGS] = out_ready_i;
	assign result_o = out_pipe_result_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * ((1 + EXP_BITS) + MAN_BITS)+:(1 + EXP_BITS) + MAN_BITS];
	assign status_o = out_pipe_status_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 5+:5];
	assign extension_bit_o = out_pipe_extension_bit_q[NUM_OUT_REGS];
	assign class_mask_o = out_pipe_class_mask_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign is_class_o = out_pipe_is_class_q[NUM_OUT_REGS];
	assign tag_o = out_pipe_tag_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign mask_o = out_pipe_mask_q[NUM_OUT_REGS];
	assign aux_o = out_pipe_aux_q[NUM_OUT_REGS];
	assign out_valid_o = out_pipe_valid_q[NUM_OUT_REGS];
	assign busy_o = |{inp_pipe_valid_q, out_pipe_valid_q};
	initial _sv2v_0 = 0;
endmodule
module fpnew_cast_multi_83014_AEEB6 (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	src_fmt_i,
	dst_fmt_i,
	int_fmt_i,
	tag_i,
	mask_i,
	aux_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	mask_o,
	aux_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	parameter [31:0] AuxType_AUX_BITS = 0;
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	parameter [0:4] FpFmtConfig = 1'sb1;
	localparam [31:0] fpnew_pkg_NUM_INT_FORMATS = 4;
	parameter [0:3] IntFmtConfig = 1'sb1;
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_maximum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_max_fp_width = res;
		end
	endfunction
	function automatic [31:0] fpnew_pkg_max_int_width;
		input reg [0:3] cfg;
		reg [31:0] w0;
		reg [31:0] w1;
		reg [31:0] w2;
		reg [31:0] w3;
		begin
			w0 = (cfg[0] ? 8 : 0);
			w1 = (cfg[1] ? 16 : 0);
			w2 = (cfg[2] ? 32 : 0);
			w3 = (cfg[3] ? 64 : 0);
			fpnew_pkg_max_int_width = fpnew_pkg_maximum(fpnew_pkg_maximum(fpnew_pkg_maximum(w0, w1), w2), w3);
		end
	endfunction
	localparam [31:0] WIDTH = fpnew_pkg_maximum(fpnew_pkg_max_fp_width(FpFmtConfig), fpnew_pkg_max_int_width(IntFmtConfig));
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [WIDTH - 1:0] operands_i;
	input wire [4:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [2:0] src_fmt_i;
	input wire [2:0] dst_fmt_i;
	localparam [31:0] fpnew_pkg_INT_FORMAT_BITS = 2;
	input wire [1:0] int_fmt_i;
	input wire [9:0] tag_i;
	input wire mask_i;
	input wire [AuxType_AUX_BITS - 1:0] aux_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [WIDTH - 1:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire mask_o;
	output wire [AuxType_AUX_BITS - 1:0] aux_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	localparam [31:0] NUM_INT_FORMATS = fpnew_pkg_NUM_INT_FORMATS;
	localparam [31:0] MAX_INT_WIDTH = fpnew_pkg_max_int_width(IntFmtConfig);
	function automatic [31:0] fpnew_pkg_exp_bits;
		input reg [2:0] fmt;
		fpnew_pkg_exp_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32];
	endfunction
	function automatic [31:0] fpnew_pkg_man_bits;
		input reg [2:0] fmt;
		fpnew_pkg_man_bits = fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32];
	endfunction
	function automatic [63:0] fpnew_pkg_super_format;
		input reg [0:4] cfg;
		reg [63:0] res;
		begin
			res = 1'sb0;
			begin : sv2v_autoblock_2
				reg [31:0] fmt;
				for (fmt = 0; fmt < fpnew_pkg_NUM_FP_FORMATS; fmt = fmt + 1)
					if (cfg[fmt]) begin
						res[63-:32] = $unsigned(fpnew_pkg_maximum(res[63-:32], fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt))));
						res[31-:32] = $unsigned(fpnew_pkg_maximum(res[31-:32], fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt))));
					end
			end
			fpnew_pkg_super_format = res;
		end
	endfunction
	localparam [63:0] SUPER_FORMAT = fpnew_pkg_super_format(FpFmtConfig);
	localparam [31:0] SUPER_EXP_BITS = SUPER_FORMAT[63-:32];
	localparam [31:0] SUPER_MAN_BITS = SUPER_FORMAT[31-:32];
	localparam [31:0] SUPER_BIAS = (2 ** (SUPER_EXP_BITS - 1)) - 1;
	localparam [31:0] INT_MAN_WIDTH = fpnew_pkg_maximum(SUPER_MAN_BITS + 1, MAX_INT_WIDTH);
	localparam [31:0] LZC_RESULT_WIDTH = $clog2(INT_MAN_WIDTH);
	localparam [31:0] INT_EXP_WIDTH = fpnew_pkg_maximum($clog2(MAX_INT_WIDTH), fpnew_pkg_maximum(SUPER_EXP_BITS, $clog2(SUPER_BIAS + SUPER_MAN_BITS))) + 1;
	localparam NUM_INP_REGS = (PipeConfig == 2'd0 ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 1) / 3 : 0));
	localparam NUM_MID_REGS = (PipeConfig == 2'd2 ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 2) / 3 : 0));
	localparam NUM_OUT_REGS = (PipeConfig == 2'd1 ? NumPipeRegs : (PipeConfig == 2'd3 ? NumPipeRegs / 3 : 0));
	wire [WIDTH - 1:0] operands_q;
	wire [4:0] is_boxed_q;
	wire op_mod_q;
	wire [2:0] src_fmt_q;
	wire [2:0] dst_fmt_q;
	wire [1:0] int_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * WIDTH) + ((NUM_INP_REGS * WIDTH) - 1) : ((NUM_INP_REGS + 1) * WIDTH) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * WIDTH : 0)] inp_pipe_operands_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * NUM_FORMATS) + ((NUM_INP_REGS * NUM_FORMATS) - 1) : ((NUM_INP_REGS + 1) * NUM_FORMATS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * NUM_FORMATS : 0)] inp_pipe_is_boxed_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_rnd_mode_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_OP_BITS) + ((NUM_INP_REGS * fpnew_pkg_OP_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_OP_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_OP_BITS : 0)] inp_pipe_op_q;
	reg [0:NUM_INP_REGS] inp_pipe_op_mod_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] inp_pipe_src_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] inp_pipe_dst_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_INT_FORMAT_BITS) + ((NUM_INP_REGS * fpnew_pkg_INT_FORMAT_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_INT_FORMAT_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_INT_FORMAT_BITS : 0)] inp_pipe_int_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 10) + ((NUM_INP_REGS * 10) - 1) : ((NUM_INP_REGS + 1) * 10) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 10 : 0)] inp_pipe_tag_q;
	reg [0:NUM_INP_REGS] inp_pipe_mask_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * AuxType_AUX_BITS) + ((NUM_INP_REGS * AuxType_AUX_BITS) - 1) : ((NUM_INP_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * AuxType_AUX_BITS : 0)] inp_pipe_aux_q;
	reg [0:NUM_INP_REGS] inp_pipe_valid_q;
	wire [0:NUM_INP_REGS] inp_pipe_ready;
	wire [WIDTH * 1:1] sv2v_tmp_51F1E;
	assign sv2v_tmp_51F1E = operands_i;
	always @(*) inp_pipe_operands_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * WIDTH+:WIDTH] = sv2v_tmp_51F1E;
	wire [5:1] sv2v_tmp_1C07D;
	assign sv2v_tmp_1C07D = is_boxed_i;
	always @(*) inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * NUM_FORMATS+:NUM_FORMATS] = sv2v_tmp_1C07D;
	wire [3:1] sv2v_tmp_357FA;
	assign sv2v_tmp_357FA = rnd_mode_i;
	always @(*) inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_357FA;
	wire [4:1] sv2v_tmp_F9118;
	assign sv2v_tmp_F9118 = op_i;
	always @(*) inp_pipe_op_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] = sv2v_tmp_F9118;
	wire [1:1] sv2v_tmp_42D74;
	assign sv2v_tmp_42D74 = op_mod_i;
	always @(*) inp_pipe_op_mod_q[0] = sv2v_tmp_42D74;
	wire [3:1] sv2v_tmp_189D9;
	assign sv2v_tmp_189D9 = src_fmt_i;
	always @(*) inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_189D9;
	wire [3:1] sv2v_tmp_E7E22;
	assign sv2v_tmp_E7E22 = dst_fmt_i;
	always @(*) inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_E7E22;
	wire [2:1] sv2v_tmp_E89E3;
	assign sv2v_tmp_E89E3 = int_fmt_i;
	always @(*) inp_pipe_int_fmt_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] = sv2v_tmp_E89E3;
	wire [10:1] sv2v_tmp_2268D;
	assign sv2v_tmp_2268D = tag_i;
	always @(*) inp_pipe_tag_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 10+:10] = sv2v_tmp_2268D;
	wire [1:1] sv2v_tmp_43EE3;
	assign sv2v_tmp_43EE3 = mask_i;
	always @(*) inp_pipe_mask_q[0] = sv2v_tmp_43EE3;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_1DF39;
	assign sv2v_tmp_1DF39 = aux_i;
	always @(*) inp_pipe_aux_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_1DF39;
	wire [1:1] sv2v_tmp_9CFD6;
	assign sv2v_tmp_9CFD6 = in_valid_i;
	always @(*) inp_pipe_valid_q[0] = sv2v_tmp_9CFD6;
	assign in_ready_o = inp_pipe_ready[0];
	genvar _gv_i_10;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [1:0] sv2v_cast_2D3A8;
		input reg [1:0] inp;
		sv2v_cast_2D3A8 = inp;
	endfunction
	function automatic [AuxType_AUX_BITS - 1:0] sv2v_cast_F912A;
		input reg [AuxType_AUX_BITS - 1:0] inp;
		sv2v_cast_F912A = inp;
	endfunction
	generate
		for (_gv_i_10 = 0; _gv_i_10 < NUM_INP_REGS; _gv_i_10 = _gv_i_10 + 1) begin : gen_input_pipeline
			localparam i = _gv_i_10;
			wire reg_ena;
			assign inp_pipe_ready[i] = inp_pipe_ready[i + 1] | ~inp_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_valid_q[i + 1] <= 1'b0;
				else
					inp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (inp_pipe_ready[i] ? inp_pipe_valid_q[i] : inp_pipe_valid_q[i + 1]));
			assign reg_ena = (inp_pipe_ready[i] & inp_pipe_valid_q[i]) | reg_ena_i[i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_operands_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * WIDTH+:WIDTH] <= 1'sb0;
				else
					inp_pipe_operands_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * WIDTH+:WIDTH] <= (reg_ena ? inp_pipe_operands_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * WIDTH+:WIDTH] : inp_pipe_operands_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * WIDTH+:WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS+:NUM_FORMATS] <= 1'sb0;
				else
					inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS+:NUM_FORMATS] <= (reg_ena ? inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * NUM_FORMATS+:NUM_FORMATS] : inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * NUM_FORMATS+:NUM_FORMATS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= sv2v_cast_7BCAE(0);
				else
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= (reg_ena ? inp_pipe_op_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] : inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_mod_q[i + 1] <= 1'sb0;
				else
					inp_pipe_op_mod_q[i + 1] <= (reg_ena ? inp_pipe_op_mod_q[i] : inp_pipe_op_mod_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_int_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] <= sv2v_cast_2D3A8(0);
				else
					inp_pipe_int_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] <= (reg_ena ? inp_pipe_int_fmt_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] : inp_pipe_int_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= (reg_ena ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 10+:10] : inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_mask_q[i + 1] <= 1'sb0;
				else
					inp_pipe_mask_q[i + 1] <= (reg_ena ? inp_pipe_mask_q[i] : inp_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign operands_q = inp_pipe_operands_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * WIDTH+:WIDTH];
	assign is_boxed_q = inp_pipe_is_boxed_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * NUM_FORMATS+:NUM_FORMATS];
	assign op_mod_q = inp_pipe_op_mod_q[NUM_INP_REGS];
	assign src_fmt_q = inp_pipe_src_fmt_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign dst_fmt_q = inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign int_fmt_q = inp_pipe_int_fmt_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS];
	wire src_is_int;
	wire dst_is_int;
	assign src_is_int = inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] == sv2v_cast_7BCAE(12);
	assign dst_is_int = inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] == sv2v_cast_7BCAE(11);
	wire [INT_MAN_WIDTH - 1:0] encoded_mant;
	wire [4:0] fmt_sign;
	wire signed [(NUM_FORMATS * INT_EXP_WIDTH) - 1:0] fmt_exponent;
	wire [(NUM_FORMATS * INT_MAN_WIDTH) - 1:0] fmt_mantissa;
	wire signed [(NUM_FORMATS * INT_EXP_WIDTH) - 1:0] fmt_shift_compensation;
	wire [39:0] info;
	reg [(NUM_INT_FORMATS * INT_MAN_WIDTH) - 1:0] ifmt_input_val;
	wire int_sign;
	wire [INT_MAN_WIDTH - 1:0] int_value;
	wire [INT_MAN_WIDTH - 1:0] int_mantissa;
	genvar _gv_fmt_8;
	localparam [0:0] fpnew_pkg_DONT_CARE = 1'b1;
	function automatic signed [0:0] sv2v_cast_1_signed;
		input reg signed [0:0] inp;
		sv2v_cast_1_signed = inp;
	endfunction
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		for (_gv_fmt_8 = 0; _gv_fmt_8 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_8 = _gv_fmt_8 + 1) begin : fmt_init_inputs
			localparam fmt = _gv_fmt_8;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			if (FpFmtConfig[fmt]) begin : active_format
				fpnew_classifier #(
					.FpFormat(sv2v_cast_9FB13(fmt)),
					.NumOperands(1)
				) i_fpnew_classifier(
					.operands_i(operands_q[FP_WIDTH - 1:0]),
					.is_boxed_i(is_boxed_q[fmt]),
					.info_o(info[fmt * 8+:8])
				);
				assign fmt_sign[fmt] = operands_q[FP_WIDTH - 1];
				assign fmt_exponent[fmt * INT_EXP_WIDTH+:INT_EXP_WIDTH] = $signed({1'b0, operands_q[MAN_BITS+:EXP_BITS]});
				assign fmt_mantissa[fmt * INT_MAN_WIDTH+:INT_MAN_WIDTH] = {info[(fmt * 8) + 7], operands_q[MAN_BITS - 1:0]};
				assign fmt_shift_compensation[fmt * INT_EXP_WIDTH+:INT_EXP_WIDTH] = $signed((INT_MAN_WIDTH - 1) - MAN_BITS);
			end
			else begin : inactive_format
				assign info[fmt * 8+:8] = {fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE, fpnew_pkg_DONT_CARE};
				assign fmt_sign[fmt] = fpnew_pkg_DONT_CARE;
				assign fmt_exponent[fmt * INT_EXP_WIDTH+:INT_EXP_WIDTH] = {INT_EXP_WIDTH {sv2v_cast_1_signed(fpnew_pkg_DONT_CARE)}};
				assign fmt_mantissa[fmt * INT_MAN_WIDTH+:INT_MAN_WIDTH] = {INT_MAN_WIDTH {fpnew_pkg_DONT_CARE}};
				assign fmt_shift_compensation[fmt * INT_EXP_WIDTH+:INT_EXP_WIDTH] = {INT_EXP_WIDTH {sv2v_cast_1_signed(fpnew_pkg_DONT_CARE)}};
			end
		end
	endgenerate
	genvar _gv_ifmt_3;
	function automatic [31:0] fpnew_pkg_int_width;
		input reg [1:0] ifmt;
		(* full_case, parallel_case *)
		case (ifmt)
			sv2v_cast_2D3A8(0): fpnew_pkg_int_width = 8;
			sv2v_cast_2D3A8(1): fpnew_pkg_int_width = 16;
			sv2v_cast_2D3A8(2): fpnew_pkg_int_width = 32;
			sv2v_cast_2D3A8(3): fpnew_pkg_int_width = 64;
			default: fpnew_pkg_int_width = 8;
		endcase
	endfunction
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	generate
		for (_gv_ifmt_3 = 0; _gv_ifmt_3 < sv2v_cast_32_signed(NUM_INT_FORMATS); _gv_ifmt_3 = _gv_ifmt_3 + 1) begin : gen_sign_extend_int
			localparam ifmt = _gv_ifmt_3;
			localparam [31:0] INT_WIDTH = fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt));
			if (IntFmtConfig[ifmt]) begin : active_format
				always @(*) begin : sign_ext_input
					if (_sv2v_0)
						;
					ifmt_input_val[ifmt * INT_MAN_WIDTH+:INT_MAN_WIDTH] = {INT_MAN_WIDTH {sv2v_cast_1(operands_q[INT_WIDTH - 1] & ~op_mod_q)}};
					ifmt_input_val[(ifmt * INT_MAN_WIDTH) + (INT_WIDTH - 1)-:INT_WIDTH] = operands_q[INT_WIDTH - 1:0];
				end
			end
			else begin : inactive_format
				wire [INT_MAN_WIDTH * 1:1] sv2v_tmp_EDEE4;
				assign sv2v_tmp_EDEE4 = {INT_MAN_WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) ifmt_input_val[ifmt * INT_MAN_WIDTH+:INT_MAN_WIDTH] = sv2v_tmp_EDEE4;
			end
		end
	endgenerate
	assign int_value = ifmt_input_val[int_fmt_q * INT_MAN_WIDTH+:INT_MAN_WIDTH];
	assign int_sign = int_value[INT_MAN_WIDTH - 1] & ~op_mod_q;
	assign int_mantissa = (int_sign ? $unsigned(-int_value) : int_value);
	assign encoded_mant = (src_is_int ? int_mantissa : fmt_mantissa[src_fmt_q * INT_MAN_WIDTH+:INT_MAN_WIDTH]);
	wire signed [INT_EXP_WIDTH - 1:0] src_bias;
	wire signed [INT_EXP_WIDTH - 1:0] src_exp;
	wire signed [INT_EXP_WIDTH - 1:0] src_subnormal;
	wire signed [INT_EXP_WIDTH - 1:0] src_offset;
	function automatic [31:0] fpnew_pkg_bias;
		input reg [2:0] fmt;
		fpnew_pkg_bias = $unsigned((2 ** (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] - 1)) - 1);
	endfunction
	assign src_bias = $signed(fpnew_pkg_bias(src_fmt_q));
	assign src_exp = fmt_exponent[src_fmt_q * INT_EXP_WIDTH+:INT_EXP_WIDTH];
	assign src_subnormal = $signed({1'b0, info[(src_fmt_q * 8) + 6]});
	assign src_offset = fmt_shift_compensation[src_fmt_q * INT_EXP_WIDTH+:INT_EXP_WIDTH];
	wire input_sign;
	wire signed [INT_EXP_WIDTH - 1:0] input_exp;
	wire [INT_MAN_WIDTH - 1:0] input_mant;
	wire mant_is_zero;
	wire signed [INT_EXP_WIDTH - 1:0] fp_input_exp;
	wire signed [INT_EXP_WIDTH - 1:0] int_input_exp;
	wire [LZC_RESULT_WIDTH - 1:0] renorm_shamt;
	wire [LZC_RESULT_WIDTH:0] renorm_shamt_sgn;
	lzc #(
		.WIDTH(INT_MAN_WIDTH),
		.MODE(1)
	) i_lzc(
		.in_i(encoded_mant),
		.cnt_o(renorm_shamt),
		.empty_o(mant_is_zero)
	);
	assign renorm_shamt_sgn = $signed({1'b0, renorm_shamt});
	assign input_sign = (src_is_int ? int_sign : fmt_sign[src_fmt_q]);
	assign input_mant = encoded_mant << renorm_shamt;
	assign fp_input_exp = $signed((((src_exp + src_subnormal) - src_bias) - renorm_shamt_sgn) + src_offset);
	assign int_input_exp = $signed((INT_MAN_WIDTH - 1) - renorm_shamt_sgn);
	assign input_exp = (src_is_int ? int_input_exp : fp_input_exp);
	wire signed [INT_EXP_WIDTH - 1:0] destination_exp;
	assign destination_exp = input_exp + $signed(fpnew_pkg_bias(dst_fmt_q));
	wire input_sign_q;
	wire signed [INT_EXP_WIDTH - 1:0] input_exp_q;
	wire [INT_MAN_WIDTH - 1:0] input_mant_q;
	wire signed [INT_EXP_WIDTH - 1:0] destination_exp_q;
	wire src_is_int_q;
	wire dst_is_int_q;
	wire [7:0] info_q;
	wire mant_is_zero_q;
	wire op_mod_q2;
	wire [2:0] rnd_mode_q;
	wire [2:0] src_fmt_q2;
	wire [2:0] dst_fmt_q2;
	wire [1:0] int_fmt_q2;
	reg [0:NUM_MID_REGS] mid_pipe_input_sign_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * INT_EXP_WIDTH) + ((NUM_MID_REGS * INT_EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * INT_EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * INT_EXP_WIDTH : 0)] mid_pipe_input_exp_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * INT_MAN_WIDTH) + ((NUM_MID_REGS * INT_MAN_WIDTH) - 1) : ((NUM_MID_REGS + 1) * INT_MAN_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * INT_MAN_WIDTH : 0)] mid_pipe_input_mant_q;
	reg signed [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * INT_EXP_WIDTH) + ((NUM_MID_REGS * INT_EXP_WIDTH) - 1) : ((NUM_MID_REGS + 1) * INT_EXP_WIDTH) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * INT_EXP_WIDTH : 0)] mid_pipe_dest_exp_q;
	reg [0:NUM_MID_REGS] mid_pipe_src_is_int_q;
	reg [0:NUM_MID_REGS] mid_pipe_dst_is_int_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 8) + ((NUM_MID_REGS * 8) - 1) : ((NUM_MID_REGS + 1) * 8) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 8 : 0)] mid_pipe_info_q;
	reg [0:NUM_MID_REGS] mid_pipe_mant_zero_q;
	reg [0:NUM_MID_REGS] mid_pipe_op_mod_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 3) + ((NUM_MID_REGS * 3) - 1) : ((NUM_MID_REGS + 1) * 3) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 3 : 0)] mid_pipe_rnd_mode_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_MID_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_MID_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] mid_pipe_src_fmt_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_MID_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_MID_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] mid_pipe_dst_fmt_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * fpnew_pkg_INT_FORMAT_BITS) + ((NUM_MID_REGS * fpnew_pkg_INT_FORMAT_BITS) - 1) : ((NUM_MID_REGS + 1) * fpnew_pkg_INT_FORMAT_BITS) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * fpnew_pkg_INT_FORMAT_BITS : 0)] mid_pipe_int_fmt_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * 10) + ((NUM_MID_REGS * 10) - 1) : ((NUM_MID_REGS + 1) * 10) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * 10 : 0)] mid_pipe_tag_q;
	reg [0:NUM_MID_REGS] mid_pipe_mask_q;
	reg [(0 >= NUM_MID_REGS ? ((1 - NUM_MID_REGS) * AuxType_AUX_BITS) + ((NUM_MID_REGS * AuxType_AUX_BITS) - 1) : ((NUM_MID_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_MID_REGS ? NUM_MID_REGS * AuxType_AUX_BITS : 0)] mid_pipe_aux_q;
	reg [0:NUM_MID_REGS] mid_pipe_valid_q;
	wire [0:NUM_MID_REGS] mid_pipe_ready;
	wire [1:1] sv2v_tmp_F60A8;
	assign sv2v_tmp_F60A8 = input_sign;
	always @(*) mid_pipe_input_sign_q[0] = sv2v_tmp_F60A8;
	wire [INT_EXP_WIDTH * 1:1] sv2v_tmp_2635B;
	assign sv2v_tmp_2635B = input_exp;
	always @(*) mid_pipe_input_exp_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * INT_EXP_WIDTH+:INT_EXP_WIDTH] = sv2v_tmp_2635B;
	wire [INT_MAN_WIDTH * 1:1] sv2v_tmp_4E2E6;
	assign sv2v_tmp_4E2E6 = input_mant;
	always @(*) mid_pipe_input_mant_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * INT_MAN_WIDTH+:INT_MAN_WIDTH] = sv2v_tmp_4E2E6;
	wire [INT_EXP_WIDTH * 1:1] sv2v_tmp_5D87A;
	assign sv2v_tmp_5D87A = destination_exp;
	always @(*) mid_pipe_dest_exp_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * INT_EXP_WIDTH+:INT_EXP_WIDTH] = sv2v_tmp_5D87A;
	wire [1:1] sv2v_tmp_89756;
	assign sv2v_tmp_89756 = src_is_int;
	always @(*) mid_pipe_src_is_int_q[0] = sv2v_tmp_89756;
	wire [1:1] sv2v_tmp_AD70F;
	assign sv2v_tmp_AD70F = dst_is_int;
	always @(*) mid_pipe_dst_is_int_q[0] = sv2v_tmp_AD70F;
	wire [8:1] sv2v_tmp_6C4FE;
	assign sv2v_tmp_6C4FE = info[src_fmt_q * 8+:8];
	always @(*) mid_pipe_info_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 8+:8] = sv2v_tmp_6C4FE;
	wire [1:1] sv2v_tmp_5718C;
	assign sv2v_tmp_5718C = mant_is_zero;
	always @(*) mid_pipe_mant_zero_q[0] = sv2v_tmp_5718C;
	wire [1:1] sv2v_tmp_3B688;
	assign sv2v_tmp_3B688 = op_mod_q;
	always @(*) mid_pipe_op_mod_q[0] = sv2v_tmp_3B688;
	wire [3:1] sv2v_tmp_06BE2;
	assign sv2v_tmp_06BE2 = inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3];
	always @(*) mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 3+:3] = sv2v_tmp_06BE2;
	wire [3:1] sv2v_tmp_CBFB7;
	assign sv2v_tmp_CBFB7 = src_fmt_q;
	always @(*) mid_pipe_src_fmt_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_CBFB7;
	wire [3:1] sv2v_tmp_884B7;
	assign sv2v_tmp_884B7 = dst_fmt_q;
	always @(*) mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_884B7;
	wire [2:1] sv2v_tmp_A809A;
	assign sv2v_tmp_A809A = int_fmt_q;
	always @(*) mid_pipe_int_fmt_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] = sv2v_tmp_A809A;
	wire [10:1] sv2v_tmp_2D05E;
	assign sv2v_tmp_2D05E = inp_pipe_tag_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 10+:10];
	always @(*) mid_pipe_tag_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * 10+:10] = sv2v_tmp_2D05E;
	wire [1:1] sv2v_tmp_2E03C;
	assign sv2v_tmp_2E03C = inp_pipe_mask_q[NUM_INP_REGS];
	always @(*) mid_pipe_mask_q[0] = sv2v_tmp_2E03C;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_364C3;
	assign sv2v_tmp_364C3 = inp_pipe_aux_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	always @(*) mid_pipe_aux_q[(0 >= NUM_MID_REGS ? 0 : NUM_MID_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_364C3;
	wire [1:1] sv2v_tmp_3D86F;
	assign sv2v_tmp_3D86F = inp_pipe_valid_q[NUM_INP_REGS];
	always @(*) mid_pipe_valid_q[0] = sv2v_tmp_3D86F;
	assign inp_pipe_ready[NUM_INP_REGS] = mid_pipe_ready[0];
	genvar _gv_i_11;
	generate
		for (_gv_i_11 = 0; _gv_i_11 < NUM_MID_REGS; _gv_i_11 = _gv_i_11 + 1) begin : gen_inside_pipeline
			localparam i = _gv_i_11;
			wire reg_ena;
			assign mid_pipe_ready[i] = mid_pipe_ready[i + 1] | ~mid_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_valid_q[i + 1] <= 1'b0;
				else
					mid_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (mid_pipe_ready[i] ? mid_pipe_valid_q[i] : mid_pipe_valid_q[i + 1]));
			assign reg_ena = (mid_pipe_ready[i] & mid_pipe_valid_q[i]) | reg_ena_i[NUM_INP_REGS + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_input_sign_q[i + 1] <= 1'sb0;
				else
					mid_pipe_input_sign_q[i + 1] <= (reg_ena ? mid_pipe_input_sign_q[i] : mid_pipe_input_sign_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_input_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_EXP_WIDTH+:INT_EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_input_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_EXP_WIDTH+:INT_EXP_WIDTH] <= (reg_ena ? mid_pipe_input_exp_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * INT_EXP_WIDTH+:INT_EXP_WIDTH] : mid_pipe_input_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_EXP_WIDTH+:INT_EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_input_mant_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_MAN_WIDTH+:INT_MAN_WIDTH] <= 1'sb0;
				else
					mid_pipe_input_mant_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_MAN_WIDTH+:INT_MAN_WIDTH] <= (reg_ena ? mid_pipe_input_mant_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * INT_MAN_WIDTH+:INT_MAN_WIDTH] : mid_pipe_input_mant_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_MAN_WIDTH+:INT_MAN_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_dest_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_EXP_WIDTH+:INT_EXP_WIDTH] <= 1'sb0;
				else
					mid_pipe_dest_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_EXP_WIDTH+:INT_EXP_WIDTH] <= (reg_ena ? mid_pipe_dest_exp_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * INT_EXP_WIDTH+:INT_EXP_WIDTH] : mid_pipe_dest_exp_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * INT_EXP_WIDTH+:INT_EXP_WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_src_is_int_q[i + 1] <= 1'sb0;
				else
					mid_pipe_src_is_int_q[i + 1] <= (reg_ena ? mid_pipe_src_is_int_q[i] : mid_pipe_src_is_int_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_dst_is_int_q[i + 1] <= 1'sb0;
				else
					mid_pipe_dst_is_int_q[i + 1] <= (reg_ena ? mid_pipe_dst_is_int_q[i] : mid_pipe_dst_is_int_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_info_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 8+:8] <= 1'sb0;
				else
					mid_pipe_info_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 8+:8] <= (reg_ena ? mid_pipe_info_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 8+:8] : mid_pipe_info_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 8+:8]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_mant_zero_q[i + 1] <= 1'sb0;
				else
					mid_pipe_mant_zero_q[i + 1] <= (reg_ena ? mid_pipe_mant_zero_q[i] : mid_pipe_mant_zero_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_op_mod_q[i + 1] <= 1'sb0;
				else
					mid_pipe_op_mod_q[i + 1] <= (reg_ena ? mid_pipe_op_mod_q[i] : mid_pipe_op_mod_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3] <= (reg_ena ? mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 3+:3] : mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_src_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					mid_pipe_src_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? mid_pipe_src_fmt_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : mid_pipe_src_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_int_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] <= sv2v_cast_2D3A8(0);
				else
					mid_pipe_int_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] <= (reg_ena ? mid_pipe_int_fmt_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS] : mid_pipe_int_fmt_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10] <= (reg_ena ? mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * 10+:10] : mid_pipe_tag_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_mask_q[i + 1] <= 1'sb0;
				else
					mid_pipe_mask_q[i + 1] <= (reg_ena ? mid_pipe_mask_q[i] : mid_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i : NUM_MID_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : mid_pipe_aux_q[(0 >= NUM_MID_REGS ? i + 1 : NUM_MID_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign input_sign_q = mid_pipe_input_sign_q[NUM_MID_REGS];
	assign input_exp_q = mid_pipe_input_exp_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * INT_EXP_WIDTH+:INT_EXP_WIDTH];
	assign input_mant_q = mid_pipe_input_mant_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * INT_MAN_WIDTH+:INT_MAN_WIDTH];
	assign destination_exp_q = mid_pipe_dest_exp_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * INT_EXP_WIDTH+:INT_EXP_WIDTH];
	assign src_is_int_q = mid_pipe_src_is_int_q[NUM_MID_REGS];
	assign dst_is_int_q = mid_pipe_dst_is_int_q[NUM_MID_REGS];
	assign info_q = mid_pipe_info_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 8+:8];
	assign mant_is_zero_q = mid_pipe_mant_zero_q[NUM_MID_REGS];
	assign op_mod_q2 = mid_pipe_op_mod_q[NUM_MID_REGS];
	assign rnd_mode_q = mid_pipe_rnd_mode_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 3+:3];
	assign src_fmt_q2 = mid_pipe_src_fmt_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign dst_fmt_q2 = mid_pipe_dst_fmt_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign int_fmt_q2 = mid_pipe_int_fmt_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * fpnew_pkg_INT_FORMAT_BITS+:fpnew_pkg_INT_FORMAT_BITS];
	reg [INT_EXP_WIDTH - 1:0] final_exp;
	reg [2 * INT_MAN_WIDTH:0] preshift_mant;
	wire [2 * INT_MAN_WIDTH:0] destination_mant;
	wire [SUPER_MAN_BITS - 1:0] final_mant;
	wire [MAX_INT_WIDTH - 1:0] final_int;
	reg [$clog2(INT_MAN_WIDTH + 1) - 1:0] denorm_shamt;
	wire [1:0] fp_round_sticky_bits;
	wire [1:0] int_round_sticky_bits;
	wire [1:0] round_sticky_bits;
	reg of_before_round;
	reg uf_before_round;
	always @(*) begin : cast_value
		if (_sv2v_0)
			;
		final_exp = $unsigned(destination_exp_q);
		preshift_mant = 1'sb0;
		denorm_shamt = SUPER_MAN_BITS - fpnew_pkg_man_bits(dst_fmt_q2);
		of_before_round = 1'b0;
		uf_before_round = 1'b0;
		preshift_mant = input_mant_q << (INT_MAN_WIDTH + 1);
		if (dst_is_int_q) begin
			denorm_shamt = $unsigned((MAX_INT_WIDTH - 1) - input_exp_q);
			if ((input_exp_q >= $signed((fpnew_pkg_int_width(int_fmt_q2) - 1) + op_mod_q2)) && !(((!op_mod_q2 && input_sign_q) && (input_exp_q == $signed(fpnew_pkg_int_width(int_fmt_q2) - 1))) && (input_mant_q == {1'b1, {INT_MAN_WIDTH - 1 {1'b0}}}))) begin
				denorm_shamt = 1'sb0;
				of_before_round = 1'b1;
			end
			else if (input_exp_q < -1) begin
				denorm_shamt = MAX_INT_WIDTH + 1;
				uf_before_round = 1'b1;
			end
		end
		else if ((destination_exp_q >= ($signed(2 ** fpnew_pkg_exp_bits(dst_fmt_q2)) - 1)) || (~src_is_int_q && info_q[4])) begin
			final_exp = $unsigned((2 ** fpnew_pkg_exp_bits(dst_fmt_q2)) - 2);
			preshift_mant = 1'sb1;
			of_before_round = 1'b1;
		end
		else if ((destination_exp_q < 1) && (destination_exp_q >= -$signed(fpnew_pkg_man_bits(dst_fmt_q2)))) begin
			final_exp = 1'sb0;
			denorm_shamt = $unsigned((denorm_shamt + 1) - destination_exp_q);
			uf_before_round = 1'b1;
		end
		else if (destination_exp_q < -$signed(fpnew_pkg_man_bits(dst_fmt_q2))) begin
			final_exp = 1'sb0;
			denorm_shamt = $unsigned((denorm_shamt + 2) + fpnew_pkg_man_bits(dst_fmt_q2));
			uf_before_round = 1'b1;
		end
	end
	localparam NUM_FP_STICKY = ((2 * INT_MAN_WIDTH) - SUPER_MAN_BITS) - 1;
	localparam NUM_INT_STICKY = (2 * INT_MAN_WIDTH) - MAX_INT_WIDTH;
	assign destination_mant = preshift_mant >> denorm_shamt;
	assign {final_mant, fp_round_sticky_bits[1]} = destination_mant[(2 * INT_MAN_WIDTH) - 1-:SUPER_MAN_BITS + 1];
	assign {final_int, int_round_sticky_bits[1]} = destination_mant[2 * INT_MAN_WIDTH-:MAX_INT_WIDTH + 1];
	assign fp_round_sticky_bits[0] = |{destination_mant[NUM_FP_STICKY - 1:0]};
	assign int_round_sticky_bits[0] = |{destination_mant[NUM_INT_STICKY - 1:0]};
	assign round_sticky_bits = (dst_is_int_q ? int_round_sticky_bits : fp_round_sticky_bits);
	wire [WIDTH - 1:0] pre_round_abs;
	wire of_after_round;
	wire uf_after_round;
	reg [(NUM_FORMATS * WIDTH) - 1:0] fmt_pre_round_abs;
	reg [4:0] fmt_of_after_round;
	reg [4:0] fmt_uf_after_round;
	reg [(NUM_INT_FORMATS * WIDTH) - 1:0] ifmt_pre_round_abs;
	reg [3:0] ifmt_of_after_round;
	wire rounded_sign;
	wire [WIDTH - 1:0] rounded_abs;
	wire result_true_zero;
	wire [WIDTH - 1:0] rounded_int_res;
	wire rounded_int_res_zero;
	genvar _gv_fmt_9;
	generate
		for (_gv_fmt_9 = 0; _gv_fmt_9 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_9 = _gv_fmt_9 + 1) begin : gen_res_assemble
			localparam fmt = _gv_fmt_9;
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			if (FpFmtConfig[fmt]) begin : active_format
				always @(*) begin : assemble_result
					if (_sv2v_0)
						;
					fmt_pre_round_abs[fmt * WIDTH+:WIDTH] = {final_exp[EXP_BITS - 1:0], final_mant[MAN_BITS - 1:0]};
				end
			end
			else begin : inactive_format
				wire [WIDTH * 1:1] sv2v_tmp_B3A83;
				assign sv2v_tmp_B3A83 = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) fmt_pre_round_abs[fmt * WIDTH+:WIDTH] = sv2v_tmp_B3A83;
			end
		end
	endgenerate
	genvar _gv_ifmt_4;
	generate
		for (_gv_ifmt_4 = 0; _gv_ifmt_4 < sv2v_cast_32_signed(NUM_INT_FORMATS); _gv_ifmt_4 = _gv_ifmt_4 + 1) begin : gen_int_res_sign_ext
			localparam ifmt = _gv_ifmt_4;
			localparam [31:0] INT_WIDTH = fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt));
			if (IntFmtConfig[ifmt]) begin : active_format
				always @(*) begin : assemble_result
					if (_sv2v_0)
						;
					ifmt_pre_round_abs[ifmt * WIDTH+:WIDTH] = {WIDTH {final_int[INT_WIDTH - 1]}};
					ifmt_pre_round_abs[(ifmt * WIDTH) + (INT_WIDTH - 1)-:INT_WIDTH] = final_int[INT_WIDTH - 1:0];
				end
			end
			else begin : inactive_format
				wire [WIDTH * 1:1] sv2v_tmp_E5CBE;
				assign sv2v_tmp_E5CBE = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) ifmt_pre_round_abs[ifmt * WIDTH+:WIDTH] = sv2v_tmp_E5CBE;
			end
		end
	endgenerate
	assign pre_round_abs = (dst_is_int_q ? ifmt_pre_round_abs[int_fmt_q2 * WIDTH+:WIDTH] : fmt_pre_round_abs[dst_fmt_q2 * WIDTH+:WIDTH]);
	fpnew_rounding #(.AbsWidth(WIDTH)) i_fpnew_rounding(
		.abs_value_i(pre_round_abs),
		.sign_i(input_sign_q),
		.round_sticky_bits_i(round_sticky_bits),
		.rnd_mode_i(rnd_mode_q),
		.effective_subtraction_i(1'b0),
		.abs_rounded_o(rounded_abs),
		.sign_o(rounded_sign),
		.exact_zero_o(result_true_zero)
	);
	reg [(NUM_FORMATS * WIDTH) - 1:0] fmt_result;
	genvar _gv_fmt_10;
	generate
		for (_gv_fmt_10 = 0; _gv_fmt_10 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_10 = _gv_fmt_10 + 1) begin : gen_sign_inject
			localparam fmt = _gv_fmt_10;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			if (FpFmtConfig[fmt]) begin : active_format
				always @(*) begin : post_process
					if (_sv2v_0)
						;
					fmt_uf_after_round[fmt] = rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb0}};
					fmt_of_after_round[fmt] = rounded_abs[(EXP_BITS + MAN_BITS) - 1:MAN_BITS] == {(((EXP_BITS + MAN_BITS) - 1) >= MAN_BITS ? (((EXP_BITS + MAN_BITS) - 1) - MAN_BITS) + 1 : (MAN_BITS - ((EXP_BITS + MAN_BITS) - 1)) + 1) * 1 {1'sb1}};
					fmt_result[fmt * WIDTH+:WIDTH] = 1'sb1;
					fmt_result[(fmt * WIDTH) + (FP_WIDTH - 1)-:FP_WIDTH] = (src_is_int_q & mant_is_zero_q ? {FP_WIDTH * 1 {1'sb0}} : {rounded_sign, rounded_abs[(EXP_BITS + MAN_BITS) - 1:0]});
				end
			end
			else begin : inactive_format
				wire [1:1] sv2v_tmp_DD825;
				assign sv2v_tmp_DD825 = fpnew_pkg_DONT_CARE;
				always @(*) fmt_uf_after_round[fmt] = sv2v_tmp_DD825;
				wire [1:1] sv2v_tmp_358EF;
				assign sv2v_tmp_358EF = fpnew_pkg_DONT_CARE;
				always @(*) fmt_of_after_round[fmt] = sv2v_tmp_358EF;
				wire [WIDTH * 1:1] sv2v_tmp_542A8;
				assign sv2v_tmp_542A8 = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) fmt_result[fmt * WIDTH+:WIDTH] = sv2v_tmp_542A8;
			end
		end
	endgenerate
	assign rounded_int_res = (rounded_sign ? $unsigned(-rounded_abs) : rounded_abs);
	assign rounded_int_res_zero = rounded_int_res == {WIDTH {1'sb0}};
	genvar _gv_ifmt_5;
	generate
		for (_gv_ifmt_5 = 0; _gv_ifmt_5 < sv2v_cast_32_signed(NUM_INT_FORMATS); _gv_ifmt_5 = _gv_ifmt_5 + 1) begin : gen_int_overflow
			localparam ifmt = _gv_ifmt_5;
			localparam [31:0] INT_WIDTH = fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt));
			if (IntFmtConfig[ifmt]) begin : active_format
				always @(*) begin : detect_overflow
					if (_sv2v_0)
						;
					ifmt_of_after_round[ifmt] = 1'b0;
					if (!rounded_sign && (input_exp_q == $signed((INT_WIDTH - 2) + op_mod_q2)))
						ifmt_of_after_round[ifmt] = ~rounded_int_res[(INT_WIDTH - 2) + op_mod_q2];
				end
			end
			else begin : inactive_format
				wire [1:1] sv2v_tmp_264CE;
				assign sv2v_tmp_264CE = fpnew_pkg_DONT_CARE;
				always @(*) ifmt_of_after_round[ifmt] = sv2v_tmp_264CE;
			end
		end
	endgenerate
	assign uf_after_round = fmt_uf_after_round[dst_fmt_q2];
	assign of_after_round = (dst_is_int_q ? ifmt_of_after_round[int_fmt_q2] : fmt_of_after_round[dst_fmt_q2]);
	wire [WIDTH - 1:0] fp_special_result;
	wire [4:0] fp_special_status;
	wire fp_result_is_special;
	reg [(NUM_FORMATS * WIDTH) - 1:0] fmt_special_result;
	genvar _gv_fmt_11;
	generate
		for (_gv_fmt_11 = 0; _gv_fmt_11 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_11 = _gv_fmt_11 + 1) begin : gen_special_results
			localparam fmt = _gv_fmt_11;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			localparam [31:0] EXP_BITS = fpnew_pkg_exp_bits(sv2v_cast_9FB13(fmt));
			localparam [31:0] MAN_BITS = fpnew_pkg_man_bits(sv2v_cast_9FB13(fmt));
			localparam [EXP_BITS - 1:0] QNAN_EXPONENT = 1'sb1;
			localparam [MAN_BITS - 1:0] QNAN_MANTISSA = 2 ** (MAN_BITS - 1);
			if (FpFmtConfig[fmt]) begin : active_format
				always @(*) begin : special_results
					reg [FP_WIDTH - 1:0] special_res;
					if (_sv2v_0)
						;
					special_res = (info_q[5] ? input_sign_q << (FP_WIDTH - 1) : {1'b0, QNAN_EXPONENT, QNAN_MANTISSA});
					fmt_special_result[fmt * WIDTH+:WIDTH] = 1'sb1;
					fmt_special_result[(fmt * WIDTH) + (FP_WIDTH - 1)-:FP_WIDTH] = special_res;
				end
			end
			else begin : inactive_format
				wire [WIDTH * 1:1] sv2v_tmp_12E08;
				assign sv2v_tmp_12E08 = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) fmt_special_result[fmt * WIDTH+:WIDTH] = sv2v_tmp_12E08;
			end
		end
	endgenerate
	assign fp_result_is_special = ~src_is_int_q & ((info_q[5] | info_q[3]) | ~info_q[0]);
	assign fp_special_status = {info_q[2], 4'b0000};
	assign fp_special_result = fmt_special_result[dst_fmt_q2 * WIDTH+:WIDTH];
	wire [WIDTH - 1:0] int_special_result;
	wire [4:0] int_special_status;
	wire int_result_is_special;
	reg [(NUM_INT_FORMATS * WIDTH) - 1:0] ifmt_special_result;
	genvar _gv_ifmt_6;
	generate
		for (_gv_ifmt_6 = 0; _gv_ifmt_6 < sv2v_cast_32_signed(NUM_INT_FORMATS); _gv_ifmt_6 = _gv_ifmt_6 + 1) begin : gen_special_results_int
			localparam ifmt = _gv_ifmt_6;
			localparam [31:0] INT_WIDTH = fpnew_pkg_int_width(sv2v_cast_2D3A8(ifmt));
			if (IntFmtConfig[ifmt]) begin : active_format
				always @(*) begin : special_results
					reg [INT_WIDTH - 1:0] special_res;
					if (_sv2v_0)
						;
					special_res[INT_WIDTH - 2:0] = 1'sb1;
					special_res[INT_WIDTH - 1] = op_mod_q2;
					if (input_sign_q && !info_q[3])
						special_res = ~special_res;
					ifmt_special_result[ifmt * WIDTH+:WIDTH] = {WIDTH {special_res[INT_WIDTH - 1]}};
					ifmt_special_result[(ifmt * WIDTH) + (INT_WIDTH - 1)-:INT_WIDTH] = special_res;
				end
			end
			else begin : inactive_format
				wire [WIDTH * 1:1] sv2v_tmp_B2A82;
				assign sv2v_tmp_B2A82 = {WIDTH {fpnew_pkg_DONT_CARE}};
				always @(*) ifmt_special_result[ifmt * WIDTH+:WIDTH] = sv2v_tmp_B2A82;
			end
		end
	endgenerate
	assign int_result_is_special = ((((info_q[3] | info_q[4]) | of_before_round) | of_after_round) | ~info_q[0]) | ((input_sign_q & op_mod_q2) & ~rounded_int_res_zero);
	assign int_special_status = 5'b10000;
	assign int_special_result = ifmt_special_result[int_fmt_q2 * WIDTH+:WIDTH];
	wire [4:0] int_regular_status;
	wire [4:0] fp_regular_status;
	wire [WIDTH - 1:0] fp_result;
	wire [WIDTH - 1:0] int_result;
	wire [4:0] fp_status;
	wire [4:0] int_status;
	assign fp_regular_status[4] = src_is_int_q & (of_before_round | of_after_round);
	assign fp_regular_status[3] = 1'b0;
	assign fp_regular_status[2] = ~src_is_int_q & (~info_q[4] & (of_before_round | of_after_round));
	assign fp_regular_status[1] = uf_after_round & fp_regular_status[0];
	assign fp_regular_status[0] = (src_is_int_q ? |fp_round_sticky_bits : |fp_round_sticky_bits | (~info_q[4] & (of_before_round | of_after_round)));
	assign int_regular_status = {4'b0000, |int_round_sticky_bits};
	assign fp_result = (fp_result_is_special ? fp_special_result : fmt_result[dst_fmt_q2 * WIDTH+:WIDTH]);
	assign fp_status = (fp_result_is_special ? fp_special_status : fp_regular_status);
	assign int_result = (int_result_is_special ? int_special_result : rounded_int_res);
	assign int_status = (int_result_is_special ? int_special_status : int_regular_status);
	wire [WIDTH - 1:0] result_d;
	wire [4:0] status_d;
	wire extension_bit;
	assign result_d = (dst_is_int_q ? int_result : fp_result);
	assign status_d = (dst_is_int_q ? int_status : fp_status);
	assign extension_bit = (dst_is_int_q ? int_result[WIDTH - 1] : 1'b1);
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * WIDTH) + ((NUM_OUT_REGS * WIDTH) - 1) : ((NUM_OUT_REGS + 1) * WIDTH) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * WIDTH : 0)] out_pipe_result_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 5) + ((NUM_OUT_REGS * 5) - 1) : ((NUM_OUT_REGS + 1) * 5) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 5 : 0)] out_pipe_status_q;
	reg [0:NUM_OUT_REGS] out_pipe_ext_bit_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_tag_q;
	reg [0:NUM_OUT_REGS] out_pipe_mask_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * AuxType_AUX_BITS) + ((NUM_OUT_REGS * AuxType_AUX_BITS) - 1) : ((NUM_OUT_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * AuxType_AUX_BITS : 0)] out_pipe_aux_q;
	reg [0:NUM_OUT_REGS] out_pipe_valid_q;
	wire [0:NUM_OUT_REGS] out_pipe_ready;
	wire [WIDTH * 1:1] sv2v_tmp_CEC39;
	assign sv2v_tmp_CEC39 = result_d;
	always @(*) out_pipe_result_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * WIDTH+:WIDTH] = sv2v_tmp_CEC39;
	wire [5:1] sv2v_tmp_7F116;
	assign sv2v_tmp_7F116 = status_d;
	always @(*) out_pipe_status_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 5+:5] = sv2v_tmp_7F116;
	wire [1:1] sv2v_tmp_D2DFA;
	assign sv2v_tmp_D2DFA = extension_bit;
	always @(*) out_pipe_ext_bit_q[0] = sv2v_tmp_D2DFA;
	wire [10:1] sv2v_tmp_FB538;
	assign sv2v_tmp_FB538 = mid_pipe_tag_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * 10+:10];
	always @(*) out_pipe_tag_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_FB538;
	wire [1:1] sv2v_tmp_F68B4;
	assign sv2v_tmp_F68B4 = mid_pipe_mask_q[NUM_MID_REGS];
	always @(*) out_pipe_mask_q[0] = sv2v_tmp_F68B4;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_31EBD;
	assign sv2v_tmp_31EBD = mid_pipe_aux_q[(0 >= NUM_MID_REGS ? NUM_MID_REGS : NUM_MID_REGS - NUM_MID_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	always @(*) out_pipe_aux_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_31EBD;
	wire [1:1] sv2v_tmp_39CE2;
	assign sv2v_tmp_39CE2 = mid_pipe_valid_q[NUM_MID_REGS];
	always @(*) out_pipe_valid_q[0] = sv2v_tmp_39CE2;
	assign mid_pipe_ready[NUM_MID_REGS] = out_pipe_ready[0];
	genvar _gv_i_12;
	generate
		for (_gv_i_12 = 0; _gv_i_12 < NUM_OUT_REGS; _gv_i_12 = _gv_i_12 + 1) begin : gen_output_pipeline
			localparam i = _gv_i_12;
			wire reg_ena;
			assign out_pipe_ready[i] = out_pipe_ready[i + 1] | ~out_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_valid_q[i + 1] <= 1'b0;
				else
					out_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (out_pipe_ready[i] ? out_pipe_valid_q[i] : out_pipe_valid_q[i + 1]));
			assign reg_ena = (out_pipe_ready[i] & out_pipe_valid_q[i]) | reg_ena_i[(NUM_INP_REGS + NUM_MID_REGS) + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= 1'sb0;
				else
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= (reg_ena ? out_pipe_result_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * WIDTH+:WIDTH] : out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= (reg_ena ? out_pipe_status_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 5+:5] : out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_ext_bit_q[i + 1] <= 1'sb0;
				else
					out_pipe_ext_bit_q[i + 1] <= (reg_ena ? out_pipe_ext_bit_q[i] : out_pipe_ext_bit_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_mask_q[i + 1] <= 1'sb0;
				else
					out_pipe_mask_q[i + 1] <= (reg_ena ? out_pipe_mask_q[i] : out_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign out_pipe_ready[NUM_OUT_REGS] = out_ready_i;
	assign result_o = out_pipe_result_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * WIDTH+:WIDTH];
	assign status_o = out_pipe_status_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 5+:5];
	assign extension_bit_o = out_pipe_ext_bit_q[NUM_OUT_REGS];
	assign tag_o = out_pipe_tag_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign mask_o = out_pipe_mask_q[NUM_OUT_REGS];
	assign aux_o = out_pipe_aux_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	assign out_valid_o = out_pipe_valid_q[NUM_OUT_REGS];
	assign busy_o = |{inp_pipe_valid_q, mid_pipe_valid_q, out_pipe_valid_q};
	initial _sv2v_0 = 0;
endmodule
module fpnew_divsqrt_multi_71FDB_3B5C2 (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	dst_fmt_i,
	tag_i,
	mask_i,
	aux_i,
	vectorial_op_i,
	in_valid_i,
	in_ready_o,
	divsqrt_done_o,
	simd_synch_done_i,
	divsqrt_ready_o,
	simd_synch_rdy_i,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	mask_o,
	aux_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	parameter [31:0] AuxType_AUX_BITS = 0;
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	parameter [0:4] FpFmtConfig = 1'sb1;
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd1;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_maximum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_max_fp_width = res;
		end
	endfunction
	localparam [31:0] WIDTH = fpnew_pkg_max_fp_width(FpFmtConfig);
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [(2 * WIDTH) - 1:0] operands_i;
	input wire [9:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire [2:0] dst_fmt_i;
	input wire [9:0] tag_i;
	input wire mask_i;
	input wire [AuxType_AUX_BITS - 1:0] aux_i;
	input wire vectorial_op_i;
	input wire in_valid_i;
	output wire in_ready_o;
	output wire divsqrt_done_o;
	input wire simd_synch_done_i;
	output wire divsqrt_ready_o;
	input wire simd_synch_rdy_i;
	input wire flush_i;
	output wire [WIDTH - 1:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire mask_o;
	output wire [AuxType_AUX_BITS - 1:0] aux_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	localparam NUM_INP_REGS = (PipeConfig == 2'd0 ? NumPipeRegs : (PipeConfig == 2'd3 ? NumPipeRegs / 2 : 0));
	localparam NUM_OUT_REGS = ((PipeConfig == 2'd1) || (PipeConfig == 2'd2) ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 1) / 2 : 0));
	wire [(2 * WIDTH) - 1:0] operands_q;
	wire [2:0] rnd_mode_q;
	wire [3:0] op_q;
	wire [2:0] dst_fmt_q;
	wire in_valid_q;
	reg [((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) - (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) * WIDTH) - 1) : ((((0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)) + 1) * WIDTH) + (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) * WIDTH) - 1)):((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) * WIDTH : (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) * WIDTH)] inp_pipe_operands_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_rnd_mode_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_OP_BITS) + ((NUM_INP_REGS * fpnew_pkg_OP_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_OP_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_OP_BITS : 0)] inp_pipe_op_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS) + ((NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_FP_FORMAT_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_FP_FORMAT_BITS : 0)] inp_pipe_dst_fmt_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 10) + ((NUM_INP_REGS * 10) - 1) : ((NUM_INP_REGS + 1) * 10) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 10 : 0)] inp_pipe_tag_q;
	reg [0:NUM_INP_REGS] inp_pipe_mask_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * AuxType_AUX_BITS) + ((NUM_INP_REGS * AuxType_AUX_BITS) - 1) : ((NUM_INP_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * AuxType_AUX_BITS : 0)] inp_pipe_aux_q;
	reg [0:NUM_INP_REGS] inp_pipe_vec_op_q;
	reg [0:NUM_INP_REGS] inp_pipe_valid_q;
	wire [0:NUM_INP_REGS] inp_pipe_ready;
	wire [2 * WIDTH:1] sv2v_tmp_75CF9;
	assign sv2v_tmp_75CF9 = operands_i;
	always @(*) inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] = sv2v_tmp_75CF9;
	wire [3:1] sv2v_tmp_5C898;
	assign sv2v_tmp_5C898 = rnd_mode_i;
	always @(*) inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_5C898;
	wire [4:1] sv2v_tmp_A50A8;
	assign sv2v_tmp_A50A8 = op_i;
	always @(*) inp_pipe_op_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] = sv2v_tmp_A50A8;
	wire [3:1] sv2v_tmp_A35AE;
	assign sv2v_tmp_A35AE = dst_fmt_i;
	always @(*) inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] = sv2v_tmp_A35AE;
	wire [10:1] sv2v_tmp_9D621;
	assign sv2v_tmp_9D621 = tag_i;
	always @(*) inp_pipe_tag_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 10+:10] = sv2v_tmp_9D621;
	wire [1:1] sv2v_tmp_43EE3;
	assign sv2v_tmp_43EE3 = mask_i;
	always @(*) inp_pipe_mask_q[0] = sv2v_tmp_43EE3;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_66997;
	assign sv2v_tmp_66997 = aux_i;
	always @(*) inp_pipe_aux_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_66997;
	wire [1:1] sv2v_tmp_A731E;
	assign sv2v_tmp_A731E = vectorial_op_i;
	always @(*) inp_pipe_vec_op_q[0] = sv2v_tmp_A731E;
	wire [1:1] sv2v_tmp_9CFD6;
	assign sv2v_tmp_9CFD6 = in_valid_i;
	always @(*) inp_pipe_valid_q[0] = sv2v_tmp_9CFD6;
	assign in_ready_o = inp_pipe_ready[0];
	genvar _gv_i_13;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [AuxType_AUX_BITS - 1:0] sv2v_cast_F912A;
		input reg [AuxType_AUX_BITS - 1:0] inp;
		sv2v_cast_F912A = inp;
	endfunction
	generate
		for (_gv_i_13 = 0; _gv_i_13 < NUM_INP_REGS; _gv_i_13 = _gv_i_13 + 1) begin : gen_input_pipeline
			localparam i = _gv_i_13;
			wire reg_ena;
			assign inp_pipe_ready[i] = inp_pipe_ready[i + 1] | ~inp_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_valid_q[i + 1] <= 1'b0;
				else
					inp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (inp_pipe_ready[i] ? inp_pipe_valid_q[i] : inp_pipe_valid_q[i + 1]));
			assign reg_ena = (inp_pipe_ready[i] & inp_pipe_valid_q[i]) | reg_ena_i[i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] <= 1'sb0;
				else
					inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] <= (reg_ena ? inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2] : inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= sv2v_cast_7BCAE(0);
				else
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= (reg_ena ? inp_pipe_op_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] : inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= sv2v_cast_9FB13(0);
				else
					inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] <= (reg_ena ? inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS] : inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= (reg_ena ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 10+:10] : inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_mask_q[i + 1] <= 1'sb0;
				else
					inp_pipe_mask_q[i + 1] <= (reg_ena ? inp_pipe_mask_q[i] : inp_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_vec_op_q[i + 1] <= sv2v_cast_F912A(1'sb0);
				else
					inp_pipe_vec_op_q[i + 1] <= (reg_ena ? inp_pipe_vec_op_q[i] : inp_pipe_vec_op_q[i + 1]);
		end
	endgenerate
	assign operands_q = inp_pipe_operands_q[WIDTH * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:WIDTH * 2];
	assign rnd_mode_q = inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3];
	assign op_q = inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS];
	assign dst_fmt_q = inp_pipe_dst_fmt_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_FP_FORMAT_BITS+:fpnew_pkg_FP_FORMAT_BITS];
	assign in_valid_q = inp_pipe_valid_q[NUM_INP_REGS];
	reg [1:0] divsqrt_fmt;
	reg [127:0] divsqrt_operands;
	reg input_is_fp8;
	always @(*) begin : translate_fmt
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (dst_fmt_q)
			sv2v_cast_9FB13('d0): divsqrt_fmt = 2'b00;
			sv2v_cast_9FB13('d1): divsqrt_fmt = 2'b01;
			sv2v_cast_9FB13('d2): divsqrt_fmt = 2'b10;
			sv2v_cast_9FB13('d4): divsqrt_fmt = 2'b11;
			default: divsqrt_fmt = 2'b10;
		endcase
		input_is_fp8 = FpFmtConfig[sv2v_cast_9FB13('d3)] & (dst_fmt_q == sv2v_cast_9FB13('d3));
		divsqrt_operands[0+:64] = (input_is_fp8 ? operands_q[0+:WIDTH] << 8 : operands_q[0+:WIDTH]);
		divsqrt_operands[64+:64] = (input_is_fp8 ? operands_q[WIDTH+:WIDTH] << 8 : operands_q[WIDTH+:WIDTH]);
	end
	reg in_ready;
	wire div_valid;
	wire sqrt_valid;
	wire unit_ready;
	wire unit_done;
	reg unit_done_q;
	wire op_starting;
	reg out_valid;
	wire out_ready;
	reg unit_busy;
	wire simd_synch_done;
	reg [1:0] state_q;
	reg [1:0] state_d;
	assign div_valid = ((in_valid_q & (op_q == sv2v_cast_7BCAE(4))) & in_ready) & ~flush_i;
	assign sqrt_valid = ((in_valid_q & (op_q != sv2v_cast_7BCAE(4))) & in_ready) & ~flush_i;
	assign op_starting = div_valid | sqrt_valid;
	reg result_is_fp8_q;
	reg [9:0] result_tag_q;
	reg result_mask_q;
	reg [AuxType_AUX_BITS - 1:0] result_aux_q;
	reg result_vec_op_q;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_is_fp8_q <= 1'sb0;
		else
			result_is_fp8_q <= (op_starting ? input_is_fp8 : result_is_fp8_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_tag_q <= 1'sb0;
		else
			result_tag_q <= (op_starting ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 10+:10] : result_tag_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_mask_q <= 1'sb0;
		else
			result_mask_q <= (op_starting ? inp_pipe_mask_q[NUM_INP_REGS] : result_mask_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_aux_q <= 1'sb0;
		else
			result_aux_q <= (op_starting ? inp_pipe_aux_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : result_aux_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_vec_op_q <= 1'sb0;
		else
			result_vec_op_q <= (op_starting ? inp_pipe_vec_op_q[NUM_INP_REGS] : result_vec_op_q);
	assign simd_synch_done = simd_synch_done_i || ~result_vec_op_q;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			unit_done_q <= 1'b0;
		else
			unit_done_q <= (simd_synch_done ? 1'b0 : (unit_done ? unit_done : unit_done_q));
	assign divsqrt_done_o = (unit_done_q | unit_done) & result_vec_op_q;
	assign divsqrt_ready_o = in_ready;
	assign inp_pipe_ready[NUM_INP_REGS] = (result_vec_op_q ? simd_synch_rdy_i : in_ready);
	always @(*) begin : flag_fsm
		if (_sv2v_0)
			;
		in_ready = 1'b0;
		out_valid = 1'b0;
		unit_busy = 1'b0;
		state_d = state_q;
		(* full_case, parallel_case *)
		case (state_q)
			2'd0: begin
				in_ready = 1'b1;
				if (in_valid_q && unit_ready)
					state_d = 2'd1;
			end
			2'd1: begin
				unit_busy = 1'b1;
				if (simd_synch_done_i || (~result_vec_op_q && unit_done)) begin
					out_valid = 1'b1;
					if (out_ready) begin
						state_d = 2'd0;
						in_ready = 1'b1;
						if (in_valid_q && unit_ready)
							state_d = 2'd1;
					end
					else
						state_d = 2'd2;
				end
			end
			2'd2: begin
				unit_busy = 1'b1;
				out_valid = 1'b1;
				if (out_ready) begin
					state_d = 2'd0;
					if (in_valid_q && unit_ready) begin
						in_ready = 1'b1;
						state_d = 2'd1;
					end
				end
			end
			default: state_d = 2'd0;
		endcase
		if (flush_i) begin
			unit_busy = 1'b0;
			out_valid = 1'b0;
			state_d = 2'd0;
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			state_q <= 2'd0;
		else
			state_q <= state_d;
	wire [63:0] unit_result;
	wire [WIDTH - 1:0] adjusted_result;
	reg [WIDTH - 1:0] held_result_q;
	wire [4:0] unit_status;
	reg [4:0] held_status_q;
	wire hold_en;
	localparam [5:0] sv2v_uu_i_divsqrt_lei_ext_Precision_ctl_SI_0 = 1'sb0;
	div_sqrt_top_mvp i_divsqrt_lei(
		.Clk_CI(clk_i),
		.Rst_RBI(rst_ni),
		.Div_start_SI(div_valid),
		.Sqrt_start_SI(sqrt_valid),
		.Operand_a_DI(divsqrt_operands[0+:64]),
		.Operand_b_DI(divsqrt_operands[64+:64]),
		.RM_SI(rnd_mode_q),
		.Precision_ctl_SI(sv2v_uu_i_divsqrt_lei_ext_Precision_ctl_SI_0),
		.Format_sel_SI(divsqrt_fmt),
		.Kill_SI(flush_i),
		.Result_DO(unit_result),
		.Fflags_SO(unit_status),
		.Ready_SO(unit_ready),
		.Done_SO(unit_done)
	);
	assign adjusted_result = (result_is_fp8_q ? unit_result >> 8 : unit_result);
	assign hold_en = (unit_done & (~simd_synch_done_i | ~out_ready)) & ~(~result_vec_op_q & out_ready);
	always @(posedge clk_i) held_result_q <= (hold_en ? adjusted_result : held_result_q);
	always @(posedge clk_i) held_status_q <= (hold_en ? unit_status : held_status_q);
	wire [WIDTH - 1:0] result_d;
	wire [4:0] status_d;
	assign result_d = (unit_done_q ? held_result_q : adjusted_result);
	assign status_d = (unit_done_q ? held_status_q : unit_status);
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * WIDTH) + ((NUM_OUT_REGS * WIDTH) - 1) : ((NUM_OUT_REGS + 1) * WIDTH) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * WIDTH : 0)] out_pipe_result_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 5) + ((NUM_OUT_REGS * 5) - 1) : ((NUM_OUT_REGS + 1) * 5) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 5 : 0)] out_pipe_status_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_tag_q;
	reg [0:NUM_OUT_REGS] out_pipe_mask_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * AuxType_AUX_BITS) + ((NUM_OUT_REGS * AuxType_AUX_BITS) - 1) : ((NUM_OUT_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * AuxType_AUX_BITS : 0)] out_pipe_aux_q;
	reg [0:NUM_OUT_REGS] out_pipe_valid_q;
	wire [0:NUM_OUT_REGS] out_pipe_ready;
	wire [WIDTH * 1:1] sv2v_tmp_E3453;
	assign sv2v_tmp_E3453 = result_d;
	always @(*) out_pipe_result_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * WIDTH+:WIDTH] = sv2v_tmp_E3453;
	wire [5:1] sv2v_tmp_B38F3;
	assign sv2v_tmp_B38F3 = status_d;
	always @(*) out_pipe_status_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 5+:5] = sv2v_tmp_B38F3;
	wire [10:1] sv2v_tmp_CA803;
	assign sv2v_tmp_CA803 = result_tag_q;
	always @(*) out_pipe_tag_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_CA803;
	wire [1:1] sv2v_tmp_1AD5F;
	assign sv2v_tmp_1AD5F = result_mask_q;
	always @(*) out_pipe_mask_q[0] = sv2v_tmp_1AD5F;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_E7F36;
	assign sv2v_tmp_E7F36 = result_aux_q;
	always @(*) out_pipe_aux_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_E7F36;
	wire [1:1] sv2v_tmp_000CD;
	assign sv2v_tmp_000CD = out_valid;
	always @(*) out_pipe_valid_q[0] = sv2v_tmp_000CD;
	assign out_ready = out_pipe_ready[0];
	genvar _gv_i_14;
	generate
		for (_gv_i_14 = 0; _gv_i_14 < NUM_OUT_REGS; _gv_i_14 = _gv_i_14 + 1) begin : gen_output_pipeline
			localparam i = _gv_i_14;
			wire reg_ena;
			assign out_pipe_ready[i] = out_pipe_ready[i + 1] | ~out_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_valid_q[i + 1] <= 1'b0;
				else
					out_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (out_pipe_ready[i] ? out_pipe_valid_q[i] : out_pipe_valid_q[i + 1]));
			assign reg_ena = (out_pipe_ready[i] & out_pipe_valid_q[i]) | reg_ena_i[NUM_INP_REGS + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= 1'sb0;
				else
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= (reg_ena ? out_pipe_result_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * WIDTH+:WIDTH] : out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= (reg_ena ? out_pipe_status_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 5+:5] : out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_mask_q[i + 1] <= 1'sb0;
				else
					out_pipe_mask_q[i + 1] <= (reg_ena ? out_pipe_mask_q[i] : out_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign out_pipe_ready[NUM_OUT_REGS] = out_ready_i;
	assign result_o = out_pipe_result_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * WIDTH+:WIDTH];
	assign status_o = out_pipe_status_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 5+:5];
	assign extension_bit_o = 1'b1;
	assign tag_o = out_pipe_tag_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign mask_o = out_pipe_mask_q[NUM_OUT_REGS];
	assign aux_o = out_pipe_aux_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	assign out_valid_o = out_pipe_valid_q[NUM_OUT_REGS];
	assign busy_o = |{inp_pipe_valid_q, unit_busy, out_pipe_valid_q};
	initial _sv2v_0 = 0;
endmodule
module fpnew_divsqrt_th_32_0D3C3_F603E (
	clk_i,
	rst_ni,
	operands_i,
	is_boxed_i,
	rnd_mode_i,
	op_i,
	tag_i,
	mask_i,
	aux_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	extension_bit_o,
	tag_o,
	mask_o,
	aux_o,
	out_valid_o,
	out_ready_i,
	busy_o,
	reg_ena_i
);
	parameter [31:0] AuxType_AUX_BITS = 0;
	reg _sv2v_0;
	parameter [31:0] NumPipeRegs = 0;
	parameter [1:0] PipeConfig = 2'd0;
	localparam [31:0] WIDTH = 32;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	localparam [31:0] ExtRegEnaWidth = (NumPipeRegs == 0 ? 1 : NumPipeRegs);
	input wire clk_i;
	input wire rst_ni;
	input wire [63:0] operands_i;
	input wire [9:0] is_boxed_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire [9:0] tag_i;
	input wire mask_i;
	input wire [AuxType_AUX_BITS - 1:0] aux_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [31:0] result_o;
	output wire [4:0] status_o;
	output wire extension_bit_o;
	output wire [9:0] tag_o;
	output wire mask_o;
	output wire [AuxType_AUX_BITS - 1:0] aux_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	input wire [ExtRegEnaWidth - 1:0] reg_ena_i;
	localparam NUM_INP_REGS = (PipeConfig == 2'd0 ? NumPipeRegs : (PipeConfig == 2'd3 ? NumPipeRegs / 2 : 0));
	localparam NUM_OUT_REGS = ((PipeConfig == 2'd1) || (PipeConfig == 2'd2) ? NumPipeRegs : (PipeConfig == 2'd3 ? (NumPipeRegs + 1) / 2 : 0));
	wire [63:0] operands_q;
	wire [2:0] rnd_mode_q;
	wire [3:0] op_q;
	wire in_valid_q;
	reg [((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) - (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0)) + 1) * 32) + (((0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) * 32) - 1) : ((((0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)) + 1) * 32) + (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) * 32) - 1)):((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) * 32 : (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) * 32)] inp_pipe_operands_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 3) + ((NUM_INP_REGS * 3) - 1) : ((NUM_INP_REGS + 1) * 3) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 3 : 0)] inp_pipe_rnd_mode_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * fpnew_pkg_OP_BITS) + ((NUM_INP_REGS * fpnew_pkg_OP_BITS) - 1) : ((NUM_INP_REGS + 1) * fpnew_pkg_OP_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * fpnew_pkg_OP_BITS : 0)] inp_pipe_op_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 10) + ((NUM_INP_REGS * 10) - 1) : ((NUM_INP_REGS + 1) * 10) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * 10 : 0)] inp_pipe_tag_q;
	reg [0:NUM_INP_REGS] inp_pipe_mask_q;
	reg [(0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * AuxType_AUX_BITS) + ((NUM_INP_REGS * AuxType_AUX_BITS) - 1) : ((NUM_INP_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_INP_REGS ? NUM_INP_REGS * AuxType_AUX_BITS : 0)] inp_pipe_aux_q;
	reg [0:NUM_INP_REGS] inp_pipe_valid_q;
	reg [0:NUM_INP_REGS] inp_pipe_ready;
	wire [64:1] sv2v_tmp_6F60A;
	assign sv2v_tmp_6F60A = operands_i;
	always @(*) inp_pipe_operands_q[32 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:64] = sv2v_tmp_6F60A;
	wire [3:1] sv2v_tmp_D397D;
	assign sv2v_tmp_D397D = rnd_mode_i;
	always @(*) inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 3+:3] = sv2v_tmp_D397D;
	wire [4:1] sv2v_tmp_C61AC;
	assign sv2v_tmp_C61AC = op_i;
	always @(*) inp_pipe_op_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] = sv2v_tmp_C61AC;
	wire [10:1] sv2v_tmp_BBE84;
	assign sv2v_tmp_BBE84 = tag_i;
	always @(*) inp_pipe_tag_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * 10+:10] = sv2v_tmp_BBE84;
	wire [1:1] sv2v_tmp_43EE3;
	assign sv2v_tmp_43EE3 = mask_i;
	always @(*) inp_pipe_mask_q[0] = sv2v_tmp_43EE3;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_9066B;
	assign sv2v_tmp_9066B = aux_i;
	always @(*) inp_pipe_aux_q[(0 >= NUM_INP_REGS ? 0 : NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_9066B;
	wire [1:1] sv2v_tmp_9CFD6;
	assign sv2v_tmp_9CFD6 = in_valid_i;
	always @(*) inp_pipe_valid_q[0] = sv2v_tmp_9CFD6;
	assign in_ready_o = inp_pipe_ready[0];
	genvar _gv_i_15;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [AuxType_AUX_BITS - 1:0] sv2v_cast_F912A;
		input reg [AuxType_AUX_BITS - 1:0] inp;
		sv2v_cast_F912A = inp;
	endfunction
	generate
		for (_gv_i_15 = 0; _gv_i_15 < NUM_INP_REGS; _gv_i_15 = _gv_i_15 + 1) begin : gen_input_pipeline
			localparam i = _gv_i_15;
			wire reg_ena;
			wire [1:1] sv2v_tmp_BD88A;
			assign sv2v_tmp_BD88A = inp_pipe_ready[i + 1] | ~inp_pipe_valid_q[i + 1];
			always @(*) inp_pipe_ready[i] = sv2v_tmp_BD88A;
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_valid_q[i + 1] <= 1'b0;
				else
					inp_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (inp_pipe_ready[i] ? inp_pipe_valid_q[i] : inp_pipe_valid_q[i + 1]));
			assign reg_ena = (inp_pipe_ready[i] & inp_pipe_valid_q[i]) | reg_ena_i[i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_operands_q[32 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:64] <= 1'sb0;
				else
					inp_pipe_operands_q[32 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:64] <= (reg_ena ? inp_pipe_operands_q[32 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2 : ((0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:64] : inp_pipe_operands_q[32 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2 : ((0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:64]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= 3'b000;
				else
					inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3] <= (reg_ena ? inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 3+:3] : inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 3+:3]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= sv2v_cast_7BCAE(0);
				else
					inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] <= (reg_ena ? inp_pipe_op_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS] : inp_pipe_op_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10] <= (reg_ena ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * 10+:10] : inp_pipe_tag_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_mask_q[i + 1] <= 1'sb0;
				else
					inp_pipe_mask_q[i + 1] <= (reg_ena ? inp_pipe_mask_q[i] : inp_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i : NUM_INP_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : inp_pipe_aux_q[(0 >= NUM_INP_REGS ? i + 1 : NUM_INP_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign operands_q = inp_pipe_operands_q[32 * ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? ((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) : (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) - (((0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1) >= (0 >= NUM_INP_REGS ? NUM_INP_REGS * 2 : 0) ? (0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2 : ((0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 2) + 1) - (0 >= NUM_INP_REGS ? ((1 - NUM_INP_REGS) * 2) + ((NUM_INP_REGS * 2) - 1) : ((NUM_INP_REGS + 1) * 2) - 1)))+:64];
	assign rnd_mode_q = inp_pipe_rnd_mode_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 3+:3];
	assign op_q = inp_pipe_op_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * fpnew_pkg_OP_BITS+:fpnew_pkg_OP_BITS];
	assign in_valid_q = inp_pipe_valid_q[NUM_INP_REGS];
	reg in_ready;
	wire div_op;
	wire sqrt_op;
	reg unit_ready_q;
	reg unit_done;
	wire op_starting;
	reg out_valid;
	wire out_ready;
	reg hold_result;
	reg data_is_held;
	reg unit_busy;
	reg [1:0] state_q;
	reg [1:0] state_d;
	assign div_op = ((in_valid_q & (op_q == sv2v_cast_7BCAE(4))) & in_ready) & ~flush_i;
	assign sqrt_op = ((in_valid_q & (op_q == sv2v_cast_7BCAE(5))) & in_ready) & ~flush_i;
	assign op_starting = div_op | sqrt_op;
	wire fdsu_fpu_ex1_stall;
	reg fdsu_fpu_ex1_stall_q;
	wire div_op_d;
	reg div_op_q;
	wire sqrt_op_d;
	reg sqrt_op_q;
	assign div_op_d = (fdsu_fpu_ex1_stall ? div_op : 1'b0);
	assign sqrt_op_d = (fdsu_fpu_ex1_stall ? sqrt_op : 1'b0);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			fdsu_fpu_ex1_stall_q <= 1'sb0;
		else
			fdsu_fpu_ex1_stall_q <= fdsu_fpu_ex1_stall;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			div_op_q <= 1'sb0;
		else
			div_op_q <= div_op_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			sqrt_op_q <= 1'sb0;
		else
			sqrt_op_q <= sqrt_op_d;
	always @(*) begin : flag_fsm
		if (_sv2v_0)
			;
		in_ready = 1'b0;
		out_valid = 1'b0;
		hold_result = 1'b0;
		data_is_held = 1'b0;
		unit_busy = 1'b0;
		state_d = state_q;
		inp_pipe_ready[NUM_INP_REGS] = unit_ready_q;
		(* full_case, parallel_case *)
		case (state_q)
			2'd0: begin
				in_ready = unit_ready_q;
				if (in_valid_q && unit_ready_q) begin
					inp_pipe_ready[NUM_INP_REGS] = unit_ready_q && !fdsu_fpu_ex1_stall;
					state_d = 2'd1;
				end
			end
			2'd1: begin
				inp_pipe_ready[NUM_INP_REGS] = fdsu_fpu_ex1_stall_q;
				unit_busy = 1'b1;
				if (unit_done) begin
					out_valid = 1'b1;
					if (out_ready) begin
						state_d = 2'd0;
						if (in_valid_q && unit_ready_q) begin
							in_ready = 1'b1;
							state_d = 2'd1;
						end
					end
					else begin
						hold_result = 1'b1;
						state_d = 2'd2;
					end
				end
			end
			2'd2: begin
				unit_busy = 1'b1;
				data_is_held = 1'b1;
				out_valid = 1'b1;
				if (out_ready) begin
					state_d = 2'd0;
					if (in_valid_q && unit_ready_q) begin
						in_ready = 1'b1;
						state_d = 2'd1;
					end
				end
			end
			default: state_d = 2'd0;
		endcase
		if (flush_i) begin
			unit_busy = 1'b0;
			out_valid = 1'b0;
			state_d = 2'd0;
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			state_q <= 2'd0;
		else
			state_q <= state_d;
	reg [9:0] result_tag_q;
	reg [AuxType_AUX_BITS - 1:0] result_aux_q;
	reg result_mask_q;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_tag_q <= 1'sb0;
		else
			result_tag_q <= (op_starting ? inp_pipe_tag_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * 10+:10] : result_tag_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_mask_q <= 1'sb0;
		else
			result_mask_q <= (op_starting ? inp_pipe_mask_q[NUM_INP_REGS] : result_mask_q);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			result_aux_q <= 1'sb0;
		else
			result_aux_q <= (op_starting ? inp_pipe_aux_q[(0 >= NUM_INP_REGS ? NUM_INP_REGS : NUM_INP_REGS - NUM_INP_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : result_aux_q);
	reg [31:0] unit_result;
	reg [31:0] held_result_q;
	reg [4:0] unit_status;
	reg [4:0] held_status_q;
	reg ctrl_fdsu_ex1_sel;
	wire fdsu_fpu_ex1_cmplt;
	wire [4:0] fdsu_fpu_ex1_fflags;
	wire [7:0] fdsu_fpu_ex1_special_sel;
	wire [3:0] fdsu_fpu_ex1_special_sign;
	wire fdsu_fpu_no_op;
	reg [2:0] idu_fpu_ex1_eu_sel;
	wire [31:0] fdsu_frbus_data;
	wire [4:0] fdsu_frbus_fflags;
	wire fdsu_frbus_wb_vld;
	wire [31:0] dp_frbus_ex2_data;
	wire [4:0] dp_frbus_ex2_fflags;
	wire [2:0] dp_xx_ex1_cnan;
	wire [2:0] dp_xx_ex1_id;
	wire [2:0] dp_xx_ex1_inf;
	wire [2:0] dp_xx_ex1_norm;
	wire [2:0] dp_xx_ex1_qnan;
	wire [2:0] dp_xx_ex1_snan;
	wire [2:0] dp_xx_ex1_zero;
	wire ex2_inst_wb;
	wire ex2_inst_wb_vld_d;
	reg ex2_inst_wb_vld_q;
	wire [31:0] fpu_idu_fwd_data;
	wire [4:0] fpu_idu_fwd_fflags;
	wire fpu_idu_fwd_vld;
	reg unit_ready_d;
	always @(*) begin
		if (_sv2v_0)
			;
		if (op_starting && unit_ready_q) begin
			if (ex2_inst_wb && ex2_inst_wb_vld_q)
				unit_ready_d = 1'b1;
			else
				unit_ready_d = 1'b0;
		end
		else if (fpu_idu_fwd_vld | flush_i)
			unit_ready_d = 1'b1;
		else
			unit_ready_d = unit_ready_q;
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			unit_ready_q <= 1'b1;
		else
			unit_ready_q <= unit_ready_d;
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_fdsu_ex1_sel = 1'b0;
		idu_fpu_ex1_eu_sel = 3'h0;
		if (op_starting) begin
			ctrl_fdsu_ex1_sel = 1'b1;
			idu_fpu_ex1_eu_sel = 3'h4;
		end
		else if (fdsu_fpu_ex1_stall_q) begin
			ctrl_fdsu_ex1_sel = 1'b1;
			idu_fpu_ex1_eu_sel = 3'h4;
		end
		else begin
			ctrl_fdsu_ex1_sel = 1'b0;
			idu_fpu_ex1_eu_sel = 3'h0;
		end
	end
	pa_fdsu_top i_divsqrt_thead(
		.cp0_fpu_icg_en(1'b0),
		.cp0_fpu_xx_dqnan(1'b0),
		.cp0_yy_clk_en(1'b1),
		.cpurst_b(rst_ni),
		.ctrl_fdsu_ex1_sel(ctrl_fdsu_ex1_sel),
		.ctrl_xx_ex1_cmplt_dp(ctrl_fdsu_ex1_sel),
		.ctrl_xx_ex1_inst_vld(ctrl_fdsu_ex1_sel),
		.ctrl_xx_ex1_stall(fdsu_fpu_ex1_stall),
		.ctrl_xx_ex1_warm_up(1'b0),
		.ctrl_xx_ex2_warm_up(1'b0),
		.ctrl_xx_ex3_warm_up(1'b0),
		.dp_xx_ex1_cnan(dp_xx_ex1_cnan),
		.dp_xx_ex1_id(dp_xx_ex1_id),
		.dp_xx_ex1_inf(dp_xx_ex1_inf),
		.dp_xx_ex1_qnan(dp_xx_ex1_qnan),
		.dp_xx_ex1_rm(rnd_mode_q),
		.dp_xx_ex1_snan(dp_xx_ex1_snan),
		.dp_xx_ex1_zero(dp_xx_ex1_zero),
		.fdsu_fpu_debug_info(),
		.fdsu_fpu_ex1_cmplt(fdsu_fpu_ex1_cmplt),
		.fdsu_fpu_ex1_cmplt_dp(),
		.fdsu_fpu_ex1_fflags(fdsu_fpu_ex1_fflags),
		.fdsu_fpu_ex1_special_sel(fdsu_fpu_ex1_special_sel),
		.fdsu_fpu_ex1_special_sign(fdsu_fpu_ex1_special_sign),
		.fdsu_fpu_ex1_stall(fdsu_fpu_ex1_stall),
		.fdsu_fpu_no_op(fdsu_fpu_no_op),
		.fdsu_frbus_data(fdsu_frbus_data),
		.fdsu_frbus_fflags(fdsu_frbus_fflags),
		.fdsu_frbus_freg(),
		.fdsu_frbus_wb_vld(fdsu_frbus_wb_vld),
		.forever_cpuclk(clk_i),
		.frbus_fdsu_wb_grant(fdsu_frbus_wb_vld),
		.idu_fpu_ex1_dst_freg(5'h0f),
		.idu_fpu_ex1_eu_sel(idu_fpu_ex1_eu_sel),
		.idu_fpu_ex1_func({8'b00000000, div_op | div_op_q, sqrt_op | sqrt_op_q}),
		.idu_fpu_ex1_srcf0(operands_q[31-:32]),
		.idu_fpu_ex1_srcf1(operands_q[63-:32]),
		.pad_yy_icg_scan_en(1'b0),
		.rtu_xx_ex1_cancel(1'b0),
		.rtu_xx_ex2_cancel(1'b0),
		.rtu_yy_xx_async_flush(flush_i),
		.rtu_yy_xx_flush(1'b0)
	);
	pa_fpu_dp x_pa_fpu_dp(
		.cp0_fpu_icg_en(1'b0),
		.cp0_fpu_xx_rm(rnd_mode_q),
		.cp0_yy_clk_en(1'b1),
		.ctrl_xx_ex1_inst_vld(ctrl_fdsu_ex1_sel),
		.ctrl_xx_ex1_stall(1'b0),
		.ctrl_xx_ex1_warm_up(1'b0),
		.dp_frbus_ex2_data(dp_frbus_ex2_data),
		.dp_frbus_ex2_fflags(dp_frbus_ex2_fflags),
		.dp_xx_ex1_cnan(dp_xx_ex1_cnan),
		.dp_xx_ex1_id(dp_xx_ex1_id),
		.dp_xx_ex1_inf(dp_xx_ex1_inf),
		.dp_xx_ex1_norm(dp_xx_ex1_norm),
		.dp_xx_ex1_qnan(dp_xx_ex1_qnan),
		.dp_xx_ex1_snan(dp_xx_ex1_snan),
		.dp_xx_ex1_zero(dp_xx_ex1_zero),
		.ex2_inst_wb(ex2_inst_wb),
		.fdsu_fpu_ex1_fflags(fdsu_fpu_ex1_fflags),
		.fdsu_fpu_ex1_special_sel(fdsu_fpu_ex1_special_sel),
		.fdsu_fpu_ex1_special_sign(fdsu_fpu_ex1_special_sign),
		.forever_cpuclk(clk_i),
		.idu_fpu_ex1_eu_sel(idu_fpu_ex1_eu_sel),
		.idu_fpu_ex1_func({8'b00000000, div_op, sqrt_op}),
		.idu_fpu_ex1_gateclk_vld(fdsu_fpu_ex1_cmplt),
		.idu_fpu_ex1_rm(rnd_mode_q),
		.idu_fpu_ex1_srcf0(operands_q[31-:32]),
		.idu_fpu_ex1_srcf1(operands_q[63-:32]),
		.idu_fpu_ex1_srcf2(1'sb0),
		.pad_yy_icg_scan_en(1'b0)
	);
	assign ex2_inst_wb_vld_d = ctrl_fdsu_ex1_sel;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			ex2_inst_wb_vld_q <= 1'sb0;
		else
			ex2_inst_wb_vld_q <= ex2_inst_wb_vld_d;
	pa_fpu_frbus x_pa_fpu_frbus(
		.ctrl_frbus_ex2_wb_req(ex2_inst_wb & ex2_inst_wb_vld_q),
		.dp_frbus_ex2_data(dp_frbus_ex2_data),
		.dp_frbus_ex2_fflags(dp_frbus_ex2_fflags),
		.fdsu_frbus_data(fdsu_frbus_data),
		.fdsu_frbus_fflags(fdsu_frbus_fflags),
		.fdsu_frbus_wb_vld(fdsu_frbus_wb_vld),
		.fpu_idu_fwd_data(fpu_idu_fwd_data),
		.fpu_idu_fwd_fflags(fpu_idu_fwd_fflags),
		.fpu_idu_fwd_vld(fpu_idu_fwd_vld)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		unit_result[31:0] = fpu_idu_fwd_data[31:0];
		unit_status[4:0] = fpu_idu_fwd_fflags[4:0];
		unit_done = fpu_idu_fwd_vld;
	end
	always @(posedge clk_i) held_result_q <= (hold_result ? unit_result : held_result_q);
	always @(posedge clk_i) held_status_q <= (hold_result ? unit_status : held_status_q);
	wire [31:0] result_d;
	wire [4:0] status_d;
	assign result_d = (data_is_held ? held_result_q : unit_result);
	assign status_d = (data_is_held ? held_status_q : unit_status);
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * WIDTH) + ((NUM_OUT_REGS * WIDTH) - 1) : ((NUM_OUT_REGS + 1) * WIDTH) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * WIDTH : 0)] out_pipe_result_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 5) + ((NUM_OUT_REGS * 5) - 1) : ((NUM_OUT_REGS + 1) * 5) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 5 : 0)] out_pipe_status_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * 10) + ((NUM_OUT_REGS * 10) - 1) : ((NUM_OUT_REGS + 1) * 10) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * 10 : 0)] out_pipe_tag_q;
	reg [(0 >= NUM_OUT_REGS ? ((1 - NUM_OUT_REGS) * AuxType_AUX_BITS) + ((NUM_OUT_REGS * AuxType_AUX_BITS) - 1) : ((NUM_OUT_REGS + 1) * AuxType_AUX_BITS) - 1):(0 >= NUM_OUT_REGS ? NUM_OUT_REGS * AuxType_AUX_BITS : 0)] out_pipe_aux_q;
	reg [0:NUM_OUT_REGS] out_pipe_mask_q;
	reg [0:NUM_OUT_REGS] out_pipe_valid_q;
	wire [0:NUM_OUT_REGS] out_pipe_ready;
	wire [32:1] sv2v_tmp_252A0;
	assign sv2v_tmp_252A0 = result_d;
	always @(*) out_pipe_result_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * WIDTH+:WIDTH] = sv2v_tmp_252A0;
	wire [5:1] sv2v_tmp_C3491;
	assign sv2v_tmp_C3491 = status_d;
	always @(*) out_pipe_status_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 5+:5] = sv2v_tmp_C3491;
	wire [10:1] sv2v_tmp_0DC4F;
	assign sv2v_tmp_0DC4F = result_tag_q;
	always @(*) out_pipe_tag_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * 10+:10] = sv2v_tmp_0DC4F;
	wire [1:1] sv2v_tmp_1AD5F;
	assign sv2v_tmp_1AD5F = result_mask_q;
	always @(*) out_pipe_mask_q[0] = sv2v_tmp_1AD5F;
	wire [AuxType_AUX_BITS * 1:1] sv2v_tmp_B5B9C;
	assign sv2v_tmp_B5B9C = result_aux_q;
	always @(*) out_pipe_aux_q[(0 >= NUM_OUT_REGS ? 0 : NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS] = sv2v_tmp_B5B9C;
	wire [1:1] sv2v_tmp_000CD;
	assign sv2v_tmp_000CD = out_valid;
	always @(*) out_pipe_valid_q[0] = sv2v_tmp_000CD;
	assign out_ready = out_pipe_ready[0];
	genvar _gv_i_16;
	generate
		for (_gv_i_16 = 0; _gv_i_16 < NUM_OUT_REGS; _gv_i_16 = _gv_i_16 + 1) begin : gen_output_pipeline
			localparam i = _gv_i_16;
			wire reg_ena;
			assign out_pipe_ready[i] = out_pipe_ready[i + 1] | ~out_pipe_valid_q[i + 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_valid_q[i + 1] <= 1'b0;
				else
					out_pipe_valid_q[i + 1] <= (flush_i ? 1'b0 : (out_pipe_ready[i] ? out_pipe_valid_q[i] : out_pipe_valid_q[i + 1]));
			assign reg_ena = (out_pipe_ready[i] & out_pipe_valid_q[i]) | reg_ena_i[NUM_INP_REGS + i];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= 1'sb0;
				else
					out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH] <= (reg_ena ? out_pipe_result_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * WIDTH+:WIDTH] : out_pipe_result_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * WIDTH+:WIDTH]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= 1'sb0;
				else
					out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5] <= (reg_ena ? out_pipe_status_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 5+:5] : out_pipe_status_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 5+:5]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= 10'b0000000000;
				else
					out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10] <= (reg_ena ? out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * 10+:10] : out_pipe_tag_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * 10+:10]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_mask_q[i + 1] <= 1'sb0;
				else
					out_pipe_mask_q[i + 1] <= (reg_ena ? out_pipe_mask_q[i] : out_pipe_mask_q[i + 1]);
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni)
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= sv2v_cast_F912A(1'sb0);
				else
					out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS] <= (reg_ena ? out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i : NUM_OUT_REGS - i) * AuxType_AUX_BITS+:AuxType_AUX_BITS] : out_pipe_aux_q[(0 >= NUM_OUT_REGS ? i + 1 : NUM_OUT_REGS - (i + 1)) * AuxType_AUX_BITS+:AuxType_AUX_BITS]);
		end
	endgenerate
	assign out_pipe_ready[NUM_OUT_REGS] = out_ready_i;
	assign result_o = out_pipe_result_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * WIDTH+:WIDTH];
	assign status_o = out_pipe_status_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 5+:5];
	assign extension_bit_o = 1'b1;
	assign tag_o = out_pipe_tag_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * 10+:10];
	assign mask_o = out_pipe_mask_q[NUM_OUT_REGS];
	assign aux_o = out_pipe_aux_q[(0 >= NUM_OUT_REGS ? NUM_OUT_REGS : NUM_OUT_REGS - NUM_OUT_REGS) * AuxType_AUX_BITS+:AuxType_AUX_BITS];
	assign out_valid_o = out_pipe_valid_q[NUM_OUT_REGS];
	assign busy_o = |{inp_pipe_valid_q, unit_busy, out_pipe_valid_q};
	initial _sv2v_0 = 0;
endmodule
module fpnew_top_2591D (
	clk_i,
	rst_ni,
	operands_i,
	rnd_mode_i,
	op_i,
	op_mod_i,
	src_fmt_i,
	dst_fmt_i,
	int_fmt_i,
	vectorial_op_i,
	tag_i,
	simd_mask_i,
	in_valid_i,
	in_ready_o,
	flush_i,
	result_o,
	status_o,
	tag_o,
	out_valid_o,
	out_ready_i,
	busy_o
);
	reg _sv2v_0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_NUM_INT_FORMATS = 4;
	localparam [42:0] fpnew_pkg_RV64D_Xsflt = 43'h000000207ff;
	parameter [42:0] Features = fpnew_pkg_RV64D_Xsflt;
	localparam [31:0] fpnew_pkg_NUM_OPGROUPS = 4;
	function automatic [159:0] sv2v_cast_A9CF0;
		input reg [159:0] inp;
		sv2v_cast_A9CF0 = inp;
	endfunction
	function automatic [((32'd4 * 32'd5) * 32) - 1:0] sv2v_cast_9CB06;
		input reg [((32'd4 * 32'd5) * 32) - 1:0] inp;
		sv2v_cast_9CB06 = inp;
	endfunction
	function automatic [((32'd4 * 32'd5) * 2) - 1:0] sv2v_cast_2DA10;
		input reg [((32'd4 * 32'd5) * 2) - 1:0] inp;
		sv2v_cast_2DA10 = inp;
	endfunction
	localparam [(((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 32) + ((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2)) + 1:0] fpnew_pkg_DEFAULT_NOREGS = {sv2v_cast_9CB06({fpnew_pkg_NUM_OPGROUPS {sv2v_cast_A9CF0(0)}}), sv2v_cast_2DA10({{fpnew_pkg_NUM_FP_FORMATS {2'd1}}, {fpnew_pkg_NUM_FP_FORMATS {2'd2}}, {fpnew_pkg_NUM_FP_FORMATS {2'd1}}, {fpnew_pkg_NUM_FP_FORMATS {2'd2}}}), 2'd0};
	parameter [(((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 32) + ((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2)) + 1:0] Implementation = fpnew_pkg_DEFAULT_NOREGS;
	parameter [0:0] PulpDivsqrt = 1'b1;
	parameter [31:0] TrueSIMDClass = 0;
	parameter [31:0] EnableSIMDMask = 0;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	localparam [319:0] fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	function automatic [31:0] fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		fpnew_pkg_fp_width = (fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_maximum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_max_fp_width = res;
		end
	endfunction
	function automatic signed [31:0] fpnew_pkg_minimum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		fpnew_pkg_minimum = (a < b ? a : b);
	endfunction
	function automatic [31:0] fpnew_pkg_min_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = fpnew_pkg_max_fp_width(cfg);
			begin : sv2v_autoblock_2
				reg [31:0] i;
				for (i = 0; i < fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(fpnew_pkg_minimum(res, fpnew_pkg_fp_width(sv2v_cast_9FB13(i))));
			end
			fpnew_pkg_min_fp_width = res;
		end
	endfunction
	function automatic [31:0] fpnew_pkg_max_num_lanes;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg vec;
		fpnew_pkg_max_num_lanes = (vec ? width / fpnew_pkg_min_fp_width(cfg) : 1);
	endfunction
	localparam [31:0] NumLanes = fpnew_pkg_max_num_lanes(Features[42-:32], Features[8-:5], Features[10]);
	localparam [31:0] WIDTH = Features[42-:32];
	localparam [31:0] NUM_OPERANDS = 3;
	input wire clk_i;
	input wire rst_ni;
	input wire [(NUM_OPERANDS * WIDTH) - 1:0] operands_i;
	input wire [2:0] rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	input wire [3:0] op_i;
	input wire op_mod_i;
	input wire [2:0] src_fmt_i;
	input wire [2:0] dst_fmt_i;
	localparam [31:0] fpnew_pkg_INT_FORMAT_BITS = 2;
	input wire [1:0] int_fmt_i;
	input wire vectorial_op_i;
	input wire [9:0] tag_i;
	input wire [NumLanes - 1:0] simd_mask_i;
	input wire in_valid_i;
	output wire in_ready_o;
	input wire flush_i;
	output wire [WIDTH - 1:0] result_o;
	output wire [4:0] status_o;
	output wire [9:0] tag_o;
	output wire out_valid_o;
	input wire out_ready_i;
	output wire busy_o;
	localparam [31:0] NUM_OPGROUPS = fpnew_pkg_NUM_OPGROUPS;
	localparam [31:0] NUM_FORMATS = fpnew_pkg_NUM_FP_FORMATS;
	wire [3:0] opgrp_in_ready;
	wire [3:0] opgrp_out_valid;
	wire [3:0] opgrp_out_ready;
	wire [3:0] opgrp_ext;
	wire [3:0] opgrp_busy;
	wire [((WIDTH + 14) >= 0 ? (4 * (WIDTH + 15)) - 1 : (4 * (1 - (WIDTH + 14))) + (WIDTH + 13)):((WIDTH + 14) >= 0 ? 0 : WIDTH + 14)] opgrp_outputs;
	wire [(NUM_FORMATS * NUM_OPERANDS) - 1:0] is_boxed;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [1:0] fpnew_pkg_get_opgroup;
		input reg [3:0] op;
		(* full_case, parallel_case *)
		case (op)
			sv2v_cast_7BCAE(0), sv2v_cast_7BCAE(1), sv2v_cast_7BCAE(2), sv2v_cast_7BCAE(3): fpnew_pkg_get_opgroup = 2'd0;
			sv2v_cast_7BCAE(4), sv2v_cast_7BCAE(5): fpnew_pkg_get_opgroup = 2'd1;
			sv2v_cast_7BCAE(6), sv2v_cast_7BCAE(7), sv2v_cast_7BCAE(8), sv2v_cast_7BCAE(9): fpnew_pkg_get_opgroup = 2'd2;
			sv2v_cast_7BCAE(10), sv2v_cast_7BCAE(11), sv2v_cast_7BCAE(12), sv2v_cast_7BCAE(13), sv2v_cast_7BCAE(14): fpnew_pkg_get_opgroup = 2'd3;
			default: fpnew_pkg_get_opgroup = 2'd2;
		endcase
	endfunction
	assign in_ready_o = in_valid_i & opgrp_in_ready[fpnew_pkg_get_opgroup(op_i)];
	genvar _gv_fmt_12;
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		for (_gv_fmt_12 = 0; _gv_fmt_12 < sv2v_cast_32_signed(NUM_FORMATS); _gv_fmt_12 = _gv_fmt_12 + 1) begin : gen_nanbox_check
			localparam fmt = _gv_fmt_12;
			localparam [31:0] FP_WIDTH = fpnew_pkg_fp_width(sv2v_cast_9FB13(fmt));
			if (Features[9] && (FP_WIDTH < WIDTH)) begin : check
				genvar _gv_op_3;
				for (_gv_op_3 = 0; _gv_op_3 < sv2v_cast_32_signed(NUM_OPERANDS); _gv_op_3 = _gv_op_3 + 1) begin : operands
					localparam op = _gv_op_3;
					assign is_boxed[(fmt * NUM_OPERANDS) + op] = (!vectorial_op_i ? operands_i[(op * WIDTH) + ((WIDTH - 1) >= FP_WIDTH ? WIDTH - 1 : ((WIDTH - 1) + ((WIDTH - 1) >= FP_WIDTH ? ((WIDTH - 1) - FP_WIDTH) + 1 : (FP_WIDTH - (WIDTH - 1)) + 1)) - 1)-:((WIDTH - 1) >= FP_WIDTH ? ((WIDTH - 1) - FP_WIDTH) + 1 : (FP_WIDTH - (WIDTH - 1)) + 1)] == {((WIDTH - 1) >= FP_WIDTH ? ((WIDTH - 1) - FP_WIDTH) + 1 : (FP_WIDTH - (WIDTH - 1)) + 1) * 1 {1'sb1}} : 1'b1);
				end
			end
			else begin : no_check
				assign is_boxed[fmt * NUM_OPERANDS+:NUM_OPERANDS] = 1'sb1;
			end
		end
	endgenerate
	wire [NumLanes - 1:0] simd_mask;
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	assign simd_mask = simd_mask_i | ~{NumLanes {sv2v_cast_1(EnableSIMDMask)}};
	genvar _gv_opgrp_1;
	function automatic [31:0] fpnew_pkg_num_operands;
		input reg [1:0] grp;
		(* full_case, parallel_case *)
		case (grp)
			2'd0: fpnew_pkg_num_operands = 3;
			2'd1: fpnew_pkg_num_operands = 2;
			2'd2: fpnew_pkg_num_operands = 2;
			2'd3: fpnew_pkg_num_operands = 3;
			default: fpnew_pkg_num_operands = 0;
		endcase
	endfunction
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	generate
		for (_gv_opgrp_1 = 0; _gv_opgrp_1 < sv2v_cast_32_signed(NUM_OPGROUPS); _gv_opgrp_1 = _gv_opgrp_1 + 1) begin : gen_operation_groups
			localparam opgrp = _gv_opgrp_1;
			localparam [31:0] NUM_OPS = fpnew_pkg_num_operands(sv2v_cast_2(opgrp));
			wire in_valid;
			reg [(NUM_FORMATS * NUM_OPS) - 1:0] input_boxed;
			assign in_valid = in_valid_i & (fpnew_pkg_get_opgroup(op_i) == sv2v_cast_2(opgrp));
			always @(*) begin : slice_inputs
				if (_sv2v_0)
					;
				begin : sv2v_autoblock_3
					reg [31:0] fmt;
					for (fmt = 0; fmt < NUM_FORMATS; fmt = fmt + 1)
						input_boxed[fmt * fpnew_pkg_num_operands(sv2v_cast_2(_gv_opgrp_1))+:fpnew_pkg_num_operands(sv2v_cast_2(_gv_opgrp_1))] = is_boxed[(fmt * NUM_OPERANDS) + (NUM_OPS - 1)-:NUM_OPS];
				end
			end
			fpnew_opgroup_block_7726B #(
				.OpGroup(sv2v_cast_2(opgrp)),
				.Width(WIDTH),
				.EnableVectors(Features[10]),
				.PulpDivsqrt(PulpDivsqrt),
				.FpFmtMask(Features[8-:5]),
				.IntFmtMask(Features[3-:fpnew_pkg_NUM_INT_FORMATS]),
				.FmtPipeRegs(Implementation[(((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 32) + (((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2) + 1)) - ((((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 32) - 1) - (32 * ((3 - opgrp) * fpnew_pkg_NUM_FP_FORMATS)))+:160]),
				.FmtUnitTypes(Implementation[(((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2) + 1) - ((((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2) - 1) - (2 * ((3 - opgrp) * fpnew_pkg_NUM_FP_FORMATS)))+:10]),
				.PipeConfig(Implementation[1-:2]),
				.TrueSIMDClass(TrueSIMDClass)
			) i_opgroup_block(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.operands_i(operands_i[WIDTH * ((NUM_OPS - 1) - (NUM_OPS - 1))+:WIDTH * NUM_OPS]),
				.is_boxed_i(input_boxed),
				.rnd_mode_i(rnd_mode_i),
				.op_i(op_i),
				.op_mod_i(op_mod_i),
				.src_fmt_i(src_fmt_i),
				.dst_fmt_i(dst_fmt_i),
				.int_fmt_i(int_fmt_i),
				.vectorial_op_i(vectorial_op_i),
				.tag_i(tag_i),
				.simd_mask_i(simd_mask),
				.in_valid_i(in_valid),
				.in_ready_o(opgrp_in_ready[opgrp]),
				.flush_i(flush_i),
				.result_o(opgrp_outputs[((WIDTH + 14) >= 0 ? (opgrp * ((WIDTH + 14) >= 0 ? WIDTH + 15 : 1 - (WIDTH + 14))) + ((WIDTH + 14) >= 0 ? WIDTH + 14 : (WIDTH + 14) - (WIDTH + 14)) : (((opgrp * ((WIDTH + 14) >= 0 ? WIDTH + 15 : 1 - (WIDTH + 14))) + ((WIDTH + 14) >= 0 ? WIDTH + 14 : (WIDTH + 14) - (WIDTH + 14))) + ((WIDTH + 14) >= 15 ? WIDTH + 0 : 16 - (WIDTH + 14))) - 1)-:((WIDTH + 14) >= 15 ? WIDTH + 0 : 16 - (WIDTH + 14))]),
				.status_o(opgrp_outputs[((WIDTH + 14) >= 0 ? (opgrp * ((WIDTH + 14) >= 0 ? WIDTH + 15 : 1 - (WIDTH + 14))) + ((WIDTH + 14) >= 0 ? 14 : WIDTH + 0) : ((opgrp * ((WIDTH + 14) >= 0 ? WIDTH + 15 : 1 - (WIDTH + 14))) + ((WIDTH + 14) >= 0 ? 14 : WIDTH + 0)) + 4)-:5]),
				.extension_bit_o(opgrp_ext[opgrp]),
				.tag_o(opgrp_outputs[((WIDTH + 14) >= 0 ? (opgrp * ((WIDTH + 14) >= 0 ? WIDTH + 15 : 1 - (WIDTH + 14))) + ((WIDTH + 14) >= 0 ? 9 : WIDTH + 5) : ((opgrp * ((WIDTH + 14) >= 0 ? WIDTH + 15 : 1 - (WIDTH + 14))) + ((WIDTH + 14) >= 0 ? 9 : WIDTH + 5)) + 9)-:10]),
				.out_valid_o(opgrp_out_valid[opgrp]),
				.out_ready_i(opgrp_out_ready[opgrp]),
				.busy_o(opgrp_busy[opgrp])
			);
		end
	endgenerate
	wire [WIDTH + 14:0] arbiter_output;
	localparam [31:0] sv2v_uu_i_arbiter_NumIn = NUM_OPGROUPS;
	localparam [31:0] sv2v_uu_i_arbiter_IdxWidth = $unsigned(2);
	localparam [sv2v_uu_i_arbiter_IdxWidth - 1:0] sv2v_uu_i_arbiter_ext_rr_i_0 = 1'sb0;
	rr_arb_tree_E7A03_DC67B #(
		.DataType_WIDTH(WIDTH),
		.NumIn(NUM_OPGROUPS),
		.AxiVldRdy(1'b1)
	) i_arbiter(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.flush_i(flush_i),
		.rr_i(sv2v_uu_i_arbiter_ext_rr_i_0),
		.req_i(opgrp_out_valid),
		.gnt_o(opgrp_out_ready),
		.data_i(opgrp_outputs),
		.gnt_i(out_ready_i),
		.req_o(out_valid_o),
		.data_o(arbiter_output),
		.idx_o()
	);
	assign result_o = arbiter_output[WIDTH + 14-:((WIDTH + 14) >= 15 ? WIDTH + 0 : 16 - (WIDTH + 14))];
	assign status_o = arbiter_output[14-:5];
	assign tag_o = arbiter_output[9-:10];
	assign busy_o = |opgrp_busy;
	initial _sv2v_0 = 0;
endmodule
module control_mvp (
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Start_SI,
	Kill_SI,
	Special_case_SBI,
	Special_case_dly_SBI,
	Precision_ctl_SI,
	Format_sel_SI,
	Numerator_DI,
	Exp_num_DI,
	Denominator_DI,
	Exp_den_DI,
	Div_start_dly_SO,
	Sqrt_start_dly_SO,
	Div_enable_SO,
	Sqrt_enable_SO,
	Full_precision_SO,
	FP32_SO,
	FP64_SO,
	FP16_SO,
	FP16ALT_SO,
	Ready_SO,
	Done_SO,
	Mant_result_prenorm_DO,
	Exp_result_prenorm_DO
);
	reg _sv2v_0;
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	input wire Start_SI;
	input wire Kill_SI;
	input wire Special_case_SBI;
	input wire Special_case_dly_SBI;
	localparam defs_div_sqrt_mvp_C_PC = 6;
	input wire [5:0] Precision_ctl_SI;
	input wire [1:0] Format_sel_SI;
	localparam defs_div_sqrt_mvp_C_MANT_FP64 = 52;
	input wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Numerator_DI;
	localparam defs_div_sqrt_mvp_C_EXP_FP64 = 11;
	input wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_num_DI;
	input wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Denominator_DI;
	input wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_den_DI;
	output wire Div_start_dly_SO;
	output wire Sqrt_start_dly_SO;
	output reg Div_enable_SO;
	output reg Sqrt_enable_SO;
	output wire Full_precision_SO;
	output wire FP32_SO;
	output wire FP64_SO;
	output wire FP16_SO;
	output wire FP16ALT_SO;
	output reg Ready_SO;
	output reg Done_SO;
	output reg [56:0] Mant_result_prenorm_DO;
	output wire [12:0] Exp_result_prenorm_DO;
	reg [57:0] Partial_remainder_DN;
	reg [57:0] Partial_remainder_DP;
	reg [56:0] Quotient_DP;
	wire [53:0] Numerator_se_D;
	wire [53:0] Denominator_se_D;
	reg [53:0] Denominator_se_DB;
	assign Numerator_se_D = {1'b0, Numerator_DI};
	assign Denominator_se_D = {1'b0, Denominator_DI};
	localparam defs_div_sqrt_mvp_C_MANT_FP16 = 10;
	localparam defs_div_sqrt_mvp_C_MANT_FP16ALT = 7;
	localparam defs_div_sqrt_mvp_C_MANT_FP32 = 23;
	always @(*) begin
		if (_sv2v_0)
			;
		if (FP32_SO)
			Denominator_se_DB = {~Denominator_se_D[53:29], {29 {1'b0}}};
		else if (FP64_SO)
			Denominator_se_DB = ~Denominator_se_D;
		else if (FP16_SO)
			Denominator_se_DB = {~Denominator_se_D[53:42], {42 {1'b0}}};
		else
			Denominator_se_DB = {~Denominator_se_D[53:45], {45 {1'b0}}};
	end
	wire [53:0] Mant_D_sqrt_Norm;
	assign Mant_D_sqrt_Norm = (Exp_num_DI[0] ? {1'b0, Numerator_DI} : {Numerator_DI, 1'b0});
	reg [1:0] Format_sel_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Format_sel_S <= 'b0;
		else if (Start_SI && Ready_SO)
			Format_sel_S <= Format_sel_SI;
		else
			Format_sel_S <= Format_sel_S;
	assign FP32_SO = Format_sel_S == 2'b00;
	assign FP64_SO = Format_sel_S == 2'b01;
	assign FP16_SO = Format_sel_S == 2'b10;
	assign FP16ALT_SO = Format_sel_S == 2'b11;
	reg [5:0] Precision_ctl_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Precision_ctl_S <= 'b0;
		else if (Start_SI && Ready_SO)
			Precision_ctl_S <= Precision_ctl_SI;
		else
			Precision_ctl_S <= Precision_ctl_S;
	assign Full_precision_SO = Precision_ctl_S == 6'h00;
	reg [5:0] State_ctl_S;
	wire [5:0] State_Two_iteration_unit_S;
	wire [5:0] State_Four_iteration_unit_S;
	assign State_Two_iteration_unit_S = Precision_ctl_S[5:1];
	assign State_Four_iteration_unit_S = Precision_ctl_S[5:2];
	localparam defs_div_sqrt_mvp_Iteration_unit_num_S = 2'b10;
	always @(*) begin
		if (_sv2v_0)
			;
		case (defs_div_sqrt_mvp_Iteration_unit_num_S)
			2'b00:
				case (Format_sel_S)
					2'b00:
						if (Full_precision_SO)
							State_ctl_S = 6'h1b;
						else
							State_ctl_S = Precision_ctl_S;
					2'b01:
						if (Full_precision_SO)
							State_ctl_S = 6'h38;
						else
							State_ctl_S = Precision_ctl_S;
					2'b10:
						if (Full_precision_SO)
							State_ctl_S = 6'h0e;
						else
							State_ctl_S = Precision_ctl_S;
					2'b11:
						if (Full_precision_SO)
							State_ctl_S = 6'h0b;
						else
							State_ctl_S = Precision_ctl_S;
				endcase
			2'b01:
				case (Format_sel_S)
					2'b00:
						if (Full_precision_SO)
							State_ctl_S = 6'h0d;
						else
							State_ctl_S = State_Two_iteration_unit_S;
					2'b01:
						if (Full_precision_SO)
							State_ctl_S = 6'h1b;
						else
							State_ctl_S = State_Two_iteration_unit_S;
					2'b10:
						if (Full_precision_SO)
							State_ctl_S = 6'h06;
						else
							State_ctl_S = State_Two_iteration_unit_S;
					2'b11:
						if (Full_precision_SO)
							State_ctl_S = 6'h05;
						else
							State_ctl_S = State_Two_iteration_unit_S;
				endcase
			2'b10:
				case (Format_sel_S)
					2'b00:
						case (Precision_ctl_S)
							6'h00: State_ctl_S = 6'h08;
							6'h06, 6'h07, 6'h08: State_ctl_S = 6'h02;
							6'h09, 6'h0a, 6'h0b: State_ctl_S = 6'h03;
							6'h0c, 6'h0d, 6'h0e: State_ctl_S = 6'h04;
							6'h0f, 6'h10, 6'h11: State_ctl_S = 6'h05;
							6'h12, 6'h13, 6'h14: State_ctl_S = 6'h06;
							6'h15, 6'h16, 6'h17: State_ctl_S = 6'h07;
							default: State_ctl_S = 6'h08;
						endcase
					2'b01:
						case (Precision_ctl_S)
							6'h00: State_ctl_S = 6'h12;
							6'h06, 6'h07, 6'h08: State_ctl_S = 6'h02;
							6'h09, 6'h0a, 6'h0b: State_ctl_S = 6'h03;
							6'h0c, 6'h0d, 6'h0e: State_ctl_S = 6'h04;
							6'h0f, 6'h10, 6'h11: State_ctl_S = 6'h05;
							6'h12, 6'h13, 6'h14: State_ctl_S = 6'h06;
							6'h15, 6'h16, 6'h17: State_ctl_S = 6'h07;
							6'h18, 6'h19, 6'h1a: State_ctl_S = 6'h08;
							6'h1b, 6'h1c, 6'h1d: State_ctl_S = 6'h09;
							6'h1e, 6'h1f, 6'h20: State_ctl_S = 6'h0a;
							6'h21, 6'h22, 6'h23: State_ctl_S = 6'h0b;
							6'h24, 6'h25, 6'h26: State_ctl_S = 6'h0c;
							6'h27, 6'h28, 6'h29: State_ctl_S = 6'h0d;
							6'h2a, 6'h2b, 6'h2c: State_ctl_S = 6'h0e;
							6'h2d, 6'h2e, 6'h2f: State_ctl_S = 6'h0f;
							6'h30, 6'h31, 6'h32: State_ctl_S = 6'h10;
							6'h33, 6'h34, 6'h35: State_ctl_S = 6'h11;
							default: State_ctl_S = 6'h12;
						endcase
					2'b10:
						case (Precision_ctl_S)
							6'h00: State_ctl_S = 6'h04;
							6'h06, 6'h07, 6'h08: State_ctl_S = 6'h02;
							6'h09, 6'h0a, 6'h0b: State_ctl_S = 6'h03;
							default: State_ctl_S = 6'h04;
						endcase
					2'b11:
						case (Precision_ctl_S)
							6'h00: State_ctl_S = 6'h03;
							6'h06, 6'h07, 6'h08: State_ctl_S = 6'h02;
							default: State_ctl_S = 6'h03;
						endcase
				endcase
			2'b11:
				case (Format_sel_S)
					2'b00:
						if (Full_precision_SO)
							State_ctl_S = 6'h06;
						else
							State_ctl_S = State_Four_iteration_unit_S;
					2'b01:
						if (Full_precision_SO)
							State_ctl_S = 6'h0d;
						else
							State_ctl_S = State_Four_iteration_unit_S;
					2'b10:
						if (Full_precision_SO)
							State_ctl_S = 6'h03;
						else
							State_ctl_S = State_Four_iteration_unit_S;
					2'b11:
						if (Full_precision_SO)
							State_ctl_S = 6'h02;
						else
							State_ctl_S = State_Four_iteration_unit_S;
				endcase
		endcase
	end
	reg Div_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Div_start_dly_S <= 1'b0;
		else if (Div_start_SI && Ready_SO)
			Div_start_dly_S <= 1'b1;
		else
			Div_start_dly_S <= 1'b0;
	assign Div_start_dly_SO = Div_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Div_enable_SO <= 1'b0;
		else if (Kill_SI)
			Div_enable_SO <= 1'b0;
		else if (Div_start_SI && Ready_SO)
			Div_enable_SO <= 1'b1;
		else if (Done_SO)
			Div_enable_SO <= 1'b0;
		else
			Div_enable_SO <= Div_enable_SO;
	reg Sqrt_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Sqrt_start_dly_S <= 1'b0;
		else if (Sqrt_start_SI && Ready_SO)
			Sqrt_start_dly_S <= 1'b1;
		else
			Sqrt_start_dly_S <= 1'b0;
	assign Sqrt_start_dly_SO = Sqrt_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Sqrt_enable_SO <= 1'b0;
		else if (Kill_SI)
			Sqrt_enable_SO <= 1'b0;
		else if (Sqrt_start_SI && Ready_SO)
			Sqrt_enable_SO <= 1'b1;
		else if (Done_SO)
			Sqrt_enable_SO <= 1'b0;
		else
			Sqrt_enable_SO <= Sqrt_enable_SO;
	reg [5:0] Crtl_cnt_S;
	wire Start_dly_S;
	assign Start_dly_S = Div_start_dly_S | Sqrt_start_dly_S;
	wire Fsm_enable_S;
	assign Fsm_enable_S = ((Start_dly_S | (|Crtl_cnt_S)) && ~Kill_SI) && Special_case_dly_SBI;
	wire Final_state_S;
	assign Final_state_S = Crtl_cnt_S == State_ctl_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Crtl_cnt_S <= 1'sb0;
		else if (Final_state_S | Kill_SI)
			Crtl_cnt_S <= 1'sb0;
		else if (Fsm_enable_S)
			Crtl_cnt_S <= Crtl_cnt_S + 1;
		else
			Crtl_cnt_S <= 1'sb0;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Done_SO <= 1'b0;
		else if (Start_SI && Ready_SO) begin
			if (~Special_case_SBI)
				Done_SO <= 1'b1;
			else
				Done_SO <= 1'b0;
		end
		else if (Final_state_S)
			Done_SO <= 1'b1;
		else
			Done_SO <= 1'b0;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Ready_SO <= 1'b1;
		else if (Start_SI && Ready_SO) begin
			if (~Special_case_SBI)
				Ready_SO <= 1'b1;
			else
				Ready_SO <= 1'b0;
		end
		else if (Final_state_S | Kill_SI)
			Ready_SO <= 1'b1;
		else
			Ready_SO <= Ready_SO;
	wire Qcnt_one_0;
	wire Qcnt_one_1;
	wire [1:0] Qcnt_one_2;
	wire [2:0] Qcnt_one_3;
	wire [3:0] Qcnt_one_4;
	wire [4:0] Qcnt_one_5;
	wire [5:0] Qcnt_one_6;
	wire [6:0] Qcnt_one_7;
	wire [7:0] Qcnt_one_8;
	wire [8:0] Qcnt_one_9;
	wire [9:0] Qcnt_one_10;
	wire [10:0] Qcnt_one_11;
	wire [11:0] Qcnt_one_12;
	wire [12:0] Qcnt_one_13;
	wire [13:0] Qcnt_one_14;
	wire [14:0] Qcnt_one_15;
	wire [15:0] Qcnt_one_16;
	wire [16:0] Qcnt_one_17;
	wire [17:0] Qcnt_one_18;
	wire [18:0] Qcnt_one_19;
	wire [19:0] Qcnt_one_20;
	wire [20:0] Qcnt_one_21;
	wire [21:0] Qcnt_one_22;
	wire [22:0] Qcnt_one_23;
	wire [23:0] Qcnt_one_24;
	wire [24:0] Qcnt_one_25;
	wire [25:0] Qcnt_one_26;
	wire [26:0] Qcnt_one_27;
	wire [27:0] Qcnt_one_28;
	wire [28:0] Qcnt_one_29;
	wire [29:0] Qcnt_one_30;
	wire [30:0] Qcnt_one_31;
	wire [31:0] Qcnt_one_32;
	wire [32:0] Qcnt_one_33;
	wire [33:0] Qcnt_one_34;
	wire [34:0] Qcnt_one_35;
	wire [35:0] Qcnt_one_36;
	wire [36:0] Qcnt_one_37;
	wire [37:0] Qcnt_one_38;
	wire [38:0] Qcnt_one_39;
	wire [39:0] Qcnt_one_40;
	wire [40:0] Qcnt_one_41;
	wire [41:0] Qcnt_one_42;
	wire [42:0] Qcnt_one_43;
	wire [43:0] Qcnt_one_44;
	wire [44:0] Qcnt_one_45;
	wire [45:0] Qcnt_one_46;
	wire [46:0] Qcnt_one_47;
	wire [47:0] Qcnt_one_48;
	wire [48:0] Qcnt_one_49;
	wire [49:0] Qcnt_one_50;
	wire [50:0] Qcnt_one_51;
	wire [51:0] Qcnt_one_52;
	wire [52:0] Qcnt_one_53;
	wire [53:0] Qcnt_one_54;
	wire [54:0] Qcnt_one_55;
	wire [55:0] Qcnt_one_56;
	wire [56:0] Qcnt_one_57;
	wire [57:0] Qcnt_one_58;
	wire [58:0] Qcnt_one_59;
	wire [59:0] Qcnt_one_60;
	wire [1:0] Qcnt_two_0;
	wire [2:0] Qcnt_two_1;
	wire [4:0] Qcnt_two_2;
	wire [6:0] Qcnt_two_3;
	wire [8:0] Qcnt_two_4;
	wire [10:0] Qcnt_two_5;
	wire [12:0] Qcnt_two_6;
	wire [14:0] Qcnt_two_7;
	wire [16:0] Qcnt_two_8;
	wire [18:0] Qcnt_two_9;
	wire [20:0] Qcnt_two_10;
	wire [22:0] Qcnt_two_11;
	wire [24:0] Qcnt_two_12;
	wire [26:0] Qcnt_two_13;
	wire [28:0] Qcnt_two_14;
	wire [30:0] Qcnt_two_15;
	wire [32:0] Qcnt_two_16;
	wire [34:0] Qcnt_two_17;
	wire [36:0] Qcnt_two_18;
	wire [38:0] Qcnt_two_19;
	wire [40:0] Qcnt_two_20;
	wire [42:0] Qcnt_two_21;
	wire [44:0] Qcnt_two_22;
	wire [46:0] Qcnt_two_23;
	wire [48:0] Qcnt_two_24;
	wire [50:0] Qcnt_two_25;
	wire [52:0] Qcnt_two_26;
	wire [54:0] Qcnt_two_27;
	wire [56:0] Qcnt_two_28;
	wire [2:0] Qcnt_three_0;
	wire [4:0] Qcnt_three_1;
	wire [7:0] Qcnt_three_2;
	wire [10:0] Qcnt_three_3;
	wire [13:0] Qcnt_three_4;
	wire [16:0] Qcnt_three_5;
	wire [19:0] Qcnt_three_6;
	wire [22:0] Qcnt_three_7;
	wire [25:0] Qcnt_three_8;
	wire [28:0] Qcnt_three_9;
	wire [31:0] Qcnt_three_10;
	wire [34:0] Qcnt_three_11;
	wire [37:0] Qcnt_three_12;
	wire [40:0] Qcnt_three_13;
	wire [43:0] Qcnt_three_14;
	wire [46:0] Qcnt_three_15;
	wire [49:0] Qcnt_three_16;
	wire [52:0] Qcnt_three_17;
	wire [55:0] Qcnt_three_18;
	wire [58:0] Qcnt_three_19;
	wire [61:0] Qcnt_three_20;
	wire [3:0] Qcnt_four_0;
	wire [6:0] Qcnt_four_1;
	wire [10:0] Qcnt_four_2;
	wire [14:0] Qcnt_four_3;
	wire [18:0] Qcnt_four_4;
	wire [22:0] Qcnt_four_5;
	wire [26:0] Qcnt_four_6;
	wire [30:0] Qcnt_four_7;
	wire [34:0] Qcnt_four_8;
	wire [38:0] Qcnt_four_9;
	wire [42:0] Qcnt_four_10;
	wire [46:0] Qcnt_four_11;
	wire [50:0] Qcnt_four_12;
	wire [54:0] Qcnt_four_13;
	wire [58:0] Qcnt_four_14;
	wire [57:0] Sqrt_R0;
	reg [57:0] Sqrt_Q0;
	reg [57:0] Q_sqrt0;
	reg [57:0] Q_sqrt_com_0;
	wire [57:0] Sqrt_R1;
	reg [57:0] Sqrt_Q1;
	reg [57:0] Q_sqrt1;
	reg [57:0] Q_sqrt_com_1;
	wire [57:0] Sqrt_R2;
	reg [57:0] Sqrt_Q2;
	reg [57:0] Q_sqrt2;
	reg [57:0] Q_sqrt_com_2;
	wire [57:0] Sqrt_R3;
	reg [57:0] Sqrt_Q3;
	reg [57:0] Q_sqrt3;
	reg [57:0] Q_sqrt_com_3;
	wire [57:0] Sqrt_R4;
	reg [1:0] Sqrt_DI [3:0];
	wire [1:0] Sqrt_DO [3:0];
	wire Sqrt_carry_DO;
	wire [57:0] Iteration_cell_a_D [3:0];
	wire [57:0] Iteration_cell_b_D [3:0];
	wire [57:0] Iteration_cell_a_BMASK_D [3:0];
	wire [57:0] Iteration_cell_b_BMASK_D [3:0];
	wire Iteration_cell_carry_D [3:0];
	wire [57:0] Iteration_cell_sum_D [3:0];
	wire [57:0] Iteration_cell_sum_AMASK_D [3:0];
	reg [3:0] Sqrt_quotinent_S;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Format_sel_S)
			2'b00: begin
				Sqrt_quotinent_S = {~Iteration_cell_sum_AMASK_D[0][28], ~Iteration_cell_sum_AMASK_D[1][28], ~Iteration_cell_sum_AMASK_D[2][28], ~Iteration_cell_sum_AMASK_D[3][28]};
				Q_sqrt_com_0 = {{29 {1'b0}}, ~Q_sqrt0[28:0]};
				Q_sqrt_com_1 = {{29 {1'b0}}, ~Q_sqrt1[28:0]};
				Q_sqrt_com_2 = {{29 {1'b0}}, ~Q_sqrt2[28:0]};
				Q_sqrt_com_3 = {{29 {1'b0}}, ~Q_sqrt3[28:0]};
			end
			2'b01: begin
				Sqrt_quotinent_S = {Iteration_cell_carry_D[0], Iteration_cell_carry_D[1], Iteration_cell_carry_D[2], Iteration_cell_carry_D[3]};
				Q_sqrt_com_0 = ~Q_sqrt0;
				Q_sqrt_com_1 = ~Q_sqrt1;
				Q_sqrt_com_2 = ~Q_sqrt2;
				Q_sqrt_com_3 = ~Q_sqrt3;
			end
			2'b10: begin
				Sqrt_quotinent_S = {~Iteration_cell_sum_AMASK_D[0][15], ~Iteration_cell_sum_AMASK_D[1][15], ~Iteration_cell_sum_AMASK_D[2][15], ~Iteration_cell_sum_AMASK_D[3][15]};
				Q_sqrt_com_0 = {{42 {1'b0}}, ~Q_sqrt0[15:0]};
				Q_sqrt_com_1 = {{42 {1'b0}}, ~Q_sqrt1[15:0]};
				Q_sqrt_com_2 = {{42 {1'b0}}, ~Q_sqrt2[15:0]};
				Q_sqrt_com_3 = {{42 {1'b0}}, ~Q_sqrt3[15:0]};
			end
			2'b11: begin
				Sqrt_quotinent_S = {~Iteration_cell_sum_AMASK_D[0][12], ~Iteration_cell_sum_AMASK_D[1][12], ~Iteration_cell_sum_AMASK_D[2][12], ~Iteration_cell_sum_AMASK_D[3][12]};
				Q_sqrt_com_0 = {{45 {1'b0}}, ~Q_sqrt0[12:0]};
				Q_sqrt_com_1 = {{45 {1'b0}}, ~Q_sqrt1[12:0]};
				Q_sqrt_com_2 = {{45 {1'b0}}, ~Q_sqrt2[12:0]};
				Q_sqrt_com_3 = {{45 {1'b0}}, ~Q_sqrt3[12:0]};
			end
		endcase
	end
	assign Qcnt_one_0 = 1'b0;
	assign Qcnt_one_1 = {Quotient_DP[0]};
	assign Qcnt_one_2 = {Quotient_DP[1:0]};
	assign Qcnt_one_3 = {Quotient_DP[2:0]};
	assign Qcnt_one_4 = {Quotient_DP[3:0]};
	assign Qcnt_one_5 = {Quotient_DP[4:0]};
	assign Qcnt_one_6 = {Quotient_DP[5:0]};
	assign Qcnt_one_7 = {Quotient_DP[6:0]};
	assign Qcnt_one_8 = {Quotient_DP[7:0]};
	assign Qcnt_one_9 = {Quotient_DP[8:0]};
	assign Qcnt_one_10 = {Quotient_DP[9:0]};
	assign Qcnt_one_11 = {Quotient_DP[10:0]};
	assign Qcnt_one_12 = {Quotient_DP[11:0]};
	assign Qcnt_one_13 = {Quotient_DP[12:0]};
	assign Qcnt_one_14 = {Quotient_DP[13:0]};
	assign Qcnt_one_15 = {Quotient_DP[14:0]};
	assign Qcnt_one_16 = {Quotient_DP[15:0]};
	assign Qcnt_one_17 = {Quotient_DP[16:0]};
	assign Qcnt_one_18 = {Quotient_DP[17:0]};
	assign Qcnt_one_19 = {Quotient_DP[18:0]};
	assign Qcnt_one_20 = {Quotient_DP[19:0]};
	assign Qcnt_one_21 = {Quotient_DP[20:0]};
	assign Qcnt_one_22 = {Quotient_DP[21:0]};
	assign Qcnt_one_23 = {Quotient_DP[22:0]};
	assign Qcnt_one_24 = {Quotient_DP[23:0]};
	assign Qcnt_one_25 = {Quotient_DP[24:0]};
	assign Qcnt_one_26 = {Quotient_DP[25:0]};
	assign Qcnt_one_27 = {Quotient_DP[26:0]};
	assign Qcnt_one_28 = {Quotient_DP[27:0]};
	assign Qcnt_one_29 = {Quotient_DP[28:0]};
	assign Qcnt_one_30 = {Quotient_DP[29:0]};
	assign Qcnt_one_31 = {Quotient_DP[30:0]};
	assign Qcnt_one_32 = {Quotient_DP[31:0]};
	assign Qcnt_one_33 = {Quotient_DP[32:0]};
	assign Qcnt_one_34 = {Quotient_DP[33:0]};
	assign Qcnt_one_35 = {Quotient_DP[34:0]};
	assign Qcnt_one_36 = {Quotient_DP[35:0]};
	assign Qcnt_one_37 = {Quotient_DP[36:0]};
	assign Qcnt_one_38 = {Quotient_DP[37:0]};
	assign Qcnt_one_39 = {Quotient_DP[38:0]};
	assign Qcnt_one_40 = {Quotient_DP[39:0]};
	assign Qcnt_one_41 = {Quotient_DP[40:0]};
	assign Qcnt_one_42 = {Quotient_DP[41:0]};
	assign Qcnt_one_43 = {Quotient_DP[42:0]};
	assign Qcnt_one_44 = {Quotient_DP[43:0]};
	assign Qcnt_one_45 = {Quotient_DP[44:0]};
	assign Qcnt_one_46 = {Quotient_DP[45:0]};
	assign Qcnt_one_47 = {Quotient_DP[46:0]};
	assign Qcnt_one_48 = {Quotient_DP[47:0]};
	assign Qcnt_one_49 = {Quotient_DP[48:0]};
	assign Qcnt_one_50 = {Quotient_DP[49:0]};
	assign Qcnt_one_51 = {Quotient_DP[50:0]};
	assign Qcnt_one_52 = {Quotient_DP[51:0]};
	assign Qcnt_one_53 = {Quotient_DP[52:0]};
	assign Qcnt_one_54 = {Quotient_DP[53:0]};
	assign Qcnt_one_55 = {Quotient_DP[54:0]};
	assign Qcnt_one_56 = {Quotient_DP[55:0]};
	assign Qcnt_one_57 = {Quotient_DP[56:0]};
	assign Qcnt_two_0 = {1'b0, Sqrt_quotinent_S[3]};
	assign Qcnt_two_1 = {Quotient_DP[1:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_2 = {Quotient_DP[3:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_3 = {Quotient_DP[5:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_4 = {Quotient_DP[7:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_5 = {Quotient_DP[9:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_6 = {Quotient_DP[11:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_7 = {Quotient_DP[13:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_8 = {Quotient_DP[15:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_9 = {Quotient_DP[17:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_10 = {Quotient_DP[19:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_11 = {Quotient_DP[21:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_12 = {Quotient_DP[23:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_13 = {Quotient_DP[25:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_14 = {Quotient_DP[27:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_15 = {Quotient_DP[29:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_16 = {Quotient_DP[31:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_17 = {Quotient_DP[33:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_18 = {Quotient_DP[35:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_19 = {Quotient_DP[37:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_20 = {Quotient_DP[39:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_21 = {Quotient_DP[41:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_22 = {Quotient_DP[43:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_23 = {Quotient_DP[45:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_24 = {Quotient_DP[47:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_25 = {Quotient_DP[49:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_26 = {Quotient_DP[51:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_27 = {Quotient_DP[53:0], Sqrt_quotinent_S[3]};
	assign Qcnt_two_28 = {Quotient_DP[55:0], Sqrt_quotinent_S[3]};
	assign Qcnt_three_0 = {1'b0, Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_1 = {Quotient_DP[2:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_2 = {Quotient_DP[5:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_3 = {Quotient_DP[8:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_4 = {Quotient_DP[11:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_5 = {Quotient_DP[14:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_6 = {Quotient_DP[17:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_7 = {Quotient_DP[20:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_8 = {Quotient_DP[23:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_9 = {Quotient_DP[26:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_10 = {Quotient_DP[29:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_11 = {Quotient_DP[32:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_12 = {Quotient_DP[35:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_13 = {Quotient_DP[38:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_14 = {Quotient_DP[41:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_15 = {Quotient_DP[44:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_16 = {Quotient_DP[47:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_17 = {Quotient_DP[50:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_18 = {Quotient_DP[53:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_three_19 = {Quotient_DP[56:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2]};
	assign Qcnt_four_0 = {1'b0, Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_1 = {Quotient_DP[3:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_2 = {Quotient_DP[7:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_3 = {Quotient_DP[11:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_4 = {Quotient_DP[15:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_5 = {Quotient_DP[19:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_6 = {Quotient_DP[23:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_7 = {Quotient_DP[27:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_8 = {Quotient_DP[31:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_9 = {Quotient_DP[35:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_10 = {Quotient_DP[39:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_11 = {Quotient_DP[43:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_12 = {Quotient_DP[47:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_13 = {Quotient_DP[51:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	assign Qcnt_four_14 = {Quotient_DP[55:0], Sqrt_quotinent_S[3], Sqrt_quotinent_S[2], Sqrt_quotinent_S[1]};
	always @(*) begin
		if (_sv2v_0)
			;
		case (defs_div_sqrt_mvp_Iteration_unit_num_S)
			2'b00:
				case (Crtl_cnt_S)
					6'b000000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_one_0};
						Sqrt_Q0 = Q_sqrt_com_0;
					end
					6'b000001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_one_1};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b000010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[49:48];
						Q_sqrt0 = {{56 {1'b0}}, Qcnt_one_2};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b000011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[47:46];
						Q_sqrt0 = {{55 {1'b0}}, Qcnt_one_3};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b000100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[45:44];
						Q_sqrt0 = {{54 {1'b0}}, Qcnt_one_4};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b000101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[43:42];
						Q_sqrt0 = {{53 {1'b0}}, Qcnt_one_5};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b000110: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[41:40];
						Q_sqrt0 = {{defs_div_sqrt_mvp_C_MANT_FP64 {1'b0}}, Qcnt_one_6};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b000111: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[39:38];
						Q_sqrt0 = {{51 {1'b0}}, Qcnt_one_7};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[37:36];
						Q_sqrt0 = {{50 {1'b0}}, Qcnt_one_8};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[35:34];
						Q_sqrt0 = {{49 {1'b0}}, Qcnt_one_9};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[33:32];
						Q_sqrt0 = {{48 {1'b0}}, Qcnt_one_10};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[31:30];
						Q_sqrt0 = {{47 {1'b0}}, Qcnt_one_11};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[29:28];
						Q_sqrt0 = {{46 {1'b0}}, Qcnt_one_12};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[27:26];
						Q_sqrt0 = {{45 {1'b0}}, Qcnt_one_13};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001110: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[25:24];
						Q_sqrt0 = {{44 {1'b0}}, Qcnt_one_14};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b001111: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[23:22];
						Q_sqrt0 = {{43 {1'b0}}, Qcnt_one_15};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[21:20];
						Q_sqrt0 = {{42 {1'b0}}, Qcnt_one_16};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[19:18];
						Q_sqrt0 = {{41 {1'b0}}, Qcnt_one_17};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[17:16];
						Q_sqrt0 = {{40 {1'b0}}, Qcnt_one_18};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[15:14];
						Q_sqrt0 = {{39 {1'b0}}, Qcnt_one_19};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[13:12];
						Q_sqrt0 = {{38 {1'b0}}, Qcnt_one_20};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[11:10];
						Q_sqrt0 = {{37 {1'b0}}, Qcnt_one_21};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010110: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[9:8];
						Q_sqrt0 = {{36 {1'b0}}, Qcnt_one_22};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b010111: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[7:6];
						Q_sqrt0 = {{35 {1'b0}}, Qcnt_one_23};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[5:4];
						Q_sqrt0 = {{34 {1'b0}}, Qcnt_one_24};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[3:2];
						Q_sqrt0 = {{33 {1'b0}}, Qcnt_one_25};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[1:0];
						Q_sqrt0 = {{32 {1'b0}}, Qcnt_one_26};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{31 {1'b0}}, Qcnt_one_27};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{30 {1'b0}}, Qcnt_one_28};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{29 {1'b0}}, Qcnt_one_29};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{28 {1'b0}}, Qcnt_one_30};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b011111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{27 {1'b0}}, Qcnt_one_31};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{26 {1'b0}}, Qcnt_one_32};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{25 {1'b0}}, Qcnt_one_33};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{24 {1'b0}}, Qcnt_one_34};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{23 {1'b0}}, Qcnt_one_35};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{22 {1'b0}}, Qcnt_one_36};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{21 {1'b0}}, Qcnt_one_37};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{20 {1'b0}}, Qcnt_one_38};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b100111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{19 {1'b0}}, Qcnt_one_39};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{18 {1'b0}}, Qcnt_one_40};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{17 {1'b0}}, Qcnt_one_41};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{16 {1'b0}}, Qcnt_one_42};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{15 {1'b0}}, Qcnt_one_43};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{14 {1'b0}}, Qcnt_one_44};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{13 {1'b0}}, Qcnt_one_45};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{12 {1'b0}}, Qcnt_one_46};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b101111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{11 {1'b0}}, Qcnt_one_47};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{10 {1'b0}}, Qcnt_one_48};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{9 {1'b0}}, Qcnt_one_49};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{8 {1'b0}}, Qcnt_one_50};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{7 {1'b0}}, Qcnt_one_51};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{6 {1'b0}}, Qcnt_one_52};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{5 {1'b0}}, Qcnt_one_53};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{4 {1'b0}}, Qcnt_one_54};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b110111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{3 {1'b0}}, Qcnt_one_55};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					6'b111000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{2 {1'b0}}, Qcnt_one_56};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
					end
					default: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = 1'sb0;
						Sqrt_Q0 = 1'sb0;
					end
				endcase
			2'b01:
				case (Crtl_cnt_S)
					6'b000000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_two_0[1]};
						Sqrt_Q0 = Q_sqrt_com_0;
						Sqrt_DI[1] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt1 = {{56 {1'b0}}, Qcnt_two_0[1:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[49:48];
						Q_sqrt0 = {{56 {1'b0}}, Qcnt_two_1[2:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[47:46];
						Q_sqrt1 = {{55 {1'b0}}, Qcnt_two_1[2:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[45:44];
						Q_sqrt0 = {{54 {1'b0}}, Qcnt_two_2[4:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[43:42];
						Q_sqrt1 = {{53 {1'b0}}, Qcnt_two_2[4:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[41:40];
						Q_sqrt0 = {{defs_div_sqrt_mvp_C_MANT_FP64 {1'b0}}, Qcnt_two_3[6:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[39:38];
						Q_sqrt1 = {{51 {1'b0}}, Qcnt_two_3[6:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[37:36];
						Q_sqrt0 = {{50 {1'b0}}, Qcnt_two_4[8:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[35:34];
						Q_sqrt1 = {{49 {1'b0}}, Qcnt_two_4[8:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[33:32];
						Q_sqrt0 = {{48 {1'b0}}, Qcnt_two_5[10:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[31:30];
						Q_sqrt1 = {{47 {1'b0}}, Qcnt_two_5[10:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000110: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[29:28];
						Q_sqrt0 = {{46 {1'b0}}, Qcnt_two_6[12:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[27:26];
						Q_sqrt1 = {{45 {1'b0}}, Qcnt_two_6[12:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b000111: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[25:24];
						Q_sqrt0 = {{44 {1'b0}}, Qcnt_two_7[14:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[23:22];
						Q_sqrt1 = {{43 {1'b0}}, Qcnt_two_7[14:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[21:20];
						Q_sqrt0 = {{42 {1'b0}}, Qcnt_two_8[16:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[19:18];
						Q_sqrt1 = {{41 {1'b0}}, Qcnt_two_8[16:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[17:16];
						Q_sqrt0 = {{40 {1'b0}}, Qcnt_two_9[18:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[15:14];
						Q_sqrt1 = {{39 {1'b0}}, Qcnt_two_9[18:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[13:12];
						Q_sqrt0 = {{38 {1'b0}}, Qcnt_two_10[20:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[11:10];
						Q_sqrt1 = {{37 {1'b0}}, Qcnt_two_10[20:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[9:8];
						Q_sqrt0 = {{36 {1'b0}}, Qcnt_two_11[22:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[7:6];
						Q_sqrt1 = {{35 {1'b0}}, Qcnt_two_11[22:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[5:4];
						Q_sqrt0 = {{34 {1'b0}}, Qcnt_two_12[24:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[3:2];
						Q_sqrt1 = {{33 {1'b0}}, Qcnt_two_12[24:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[1:0];
						Q_sqrt0 = {{32 {1'b0}}, Qcnt_two_13[26:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{31 {1'b0}}, Qcnt_two_13[26:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{30 {1'b0}}, Qcnt_two_14[28:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{29 {1'b0}}, Qcnt_two_14[28:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b001111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{28 {1'b0}}, Qcnt_two_15[30:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{27 {1'b0}}, Qcnt_two_15[30:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{26 {1'b0}}, Qcnt_two_16[32:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{25 {1'b0}}, Qcnt_two_16[32:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{24 {1'b0}}, Qcnt_two_17[34:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{23 {1'b0}}, Qcnt_two_17[34:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{22 {1'b0}}, Qcnt_two_18[36:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{21 {1'b0}}, Qcnt_two_18[36:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{20 {1'b0}}, Qcnt_two_19[38:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{19 {1'b0}}, Qcnt_two_19[38:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{18 {1'b0}}, Qcnt_two_20[40:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{17 {1'b0}}, Qcnt_two_20[40:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{16 {1'b0}}, Qcnt_two_21[42:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{15 {1'b0}}, Qcnt_two_21[42:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{14 {1'b0}}, Qcnt_two_22[44:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{13 {1'b0}}, Qcnt_two_22[44:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b010111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{12 {1'b0}}, Qcnt_two_23[46:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{11 {1'b0}}, Qcnt_two_23[46:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b011000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{10 {1'b0}}, Qcnt_two_24[48:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{9 {1'b0}}, Qcnt_two_24[48:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b011001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{8 {1'b0}}, Qcnt_two_25[50:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{7 {1'b0}}, Qcnt_two_25[50:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b011010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{6 {1'b0}}, Qcnt_two_26[52:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{5 {1'b0}}, Qcnt_two_26[52:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b011011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{4 {1'b0}}, Qcnt_two_27[54:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{3 {1'b0}}, Qcnt_two_27[54:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					6'b011100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{2 {1'b0}}, Qcnt_two_28[56:1]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {1'b0, Qcnt_two_28[56:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
					default: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_two_0[1]};
						Sqrt_Q0 = Q_sqrt_com_0;
						Sqrt_DI[1] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt1 = {{56 {1'b0}}, Qcnt_two_0[1:0]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
					end
				endcase
			2'b10:
				case (Crtl_cnt_S)
					6'b000000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_three_0[2]};
						Sqrt_Q0 = Q_sqrt_com_0;
						Sqrt_DI[1] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt1 = {{56 {1'b0}}, Qcnt_three_0[2:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[49:48];
						Q_sqrt2 = {{55 {1'b0}}, Qcnt_three_0[2:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[47:46];
						Q_sqrt0 = {{54 {1'b0}}, Qcnt_three_1[4:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[45:44];
						Q_sqrt1 = {{53 {1'b0}}, Qcnt_three_1[4:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[43:42];
						Q_sqrt2 = {{defs_div_sqrt_mvp_C_MANT_FP64 {1'b0}}, Qcnt_three_1[4:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[41:40];
						Q_sqrt0 = {{51 {1'b0}}, Qcnt_three_2[7:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[39:38];
						Q_sqrt1 = {{50 {1'b0}}, Qcnt_three_2[7:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[37:36];
						Q_sqrt2 = {{49 {1'b0}}, Qcnt_three_2[7:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[35:34];
						Q_sqrt0 = {{48 {1'b0}}, Qcnt_three_3[10:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[33:32];
						Q_sqrt1 = {{47 {1'b0}}, Qcnt_three_3[10:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[31:30];
						Q_sqrt2 = {{46 {1'b0}}, Qcnt_three_3[10:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[29:28];
						Q_sqrt0 = {{45 {1'b0}}, Qcnt_three_4[13:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[27:26];
						Q_sqrt1 = {{44 {1'b0}}, Qcnt_three_4[13:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[25:24];
						Q_sqrt2 = {{43 {1'b0}}, Qcnt_three_4[13:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[23:22];
						Q_sqrt0 = {{42 {1'b0}}, Qcnt_three_5[16:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[21:20];
						Q_sqrt1 = {{41 {1'b0}}, Qcnt_three_5[16:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[19:18];
						Q_sqrt2 = {{40 {1'b0}}, Qcnt_three_5[16:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000110: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[17:16];
						Q_sqrt0 = {{39 {1'b0}}, Qcnt_three_6[19:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[15:14];
						Q_sqrt1 = {{38 {1'b0}}, Qcnt_three_6[19:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[13:12];
						Q_sqrt2 = {{37 {1'b0}}, Qcnt_three_6[19:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b000111: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[11:10];
						Q_sqrt0 = {{36 {1'b0}}, Qcnt_three_7[22:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[9:8];
						Q_sqrt1 = {{35 {1'b0}}, Qcnt_three_7[22:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[7:6];
						Q_sqrt2 = {{34 {1'b0}}, Qcnt_three_7[22:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[5:4];
						Q_sqrt0 = {{33 {1'b0}}, Qcnt_three_8[25:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[3:2];
						Q_sqrt1 = {{32 {1'b0}}, Qcnt_three_8[25:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[1:0];
						Q_sqrt2 = {{31 {1'b0}}, Qcnt_three_8[25:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{30 {1'b0}}, Qcnt_three_9[28:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{29 {1'b0}}, Qcnt_three_9[28:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{28 {1'b0}}, Qcnt_three_9[28:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{27 {1'b0}}, Qcnt_three_10[31:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{26 {1'b0}}, Qcnt_three_10[31:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{25 {1'b0}}, Qcnt_three_10[31:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{24 {1'b0}}, Qcnt_three_11[34:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{23 {1'b0}}, Qcnt_three_11[34:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{22 {1'b0}}, Qcnt_three_11[34:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{21 {1'b0}}, Qcnt_three_12[37:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{20 {1'b0}}, Qcnt_three_12[37:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{19 {1'b0}}, Qcnt_three_12[37:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{18 {1'b0}}, Qcnt_three_13[40:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{17 {1'b0}}, Qcnt_three_13[40:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{16 {1'b0}}, Qcnt_three_13[40:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001110: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{15 {1'b0}}, Qcnt_three_14[43:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{14 {1'b0}}, Qcnt_three_14[43:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{13 {1'b0}}, Qcnt_three_14[43:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b001111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{12 {1'b0}}, Qcnt_three_15[46:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{11 {1'b0}}, Qcnt_three_15[46:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{10 {1'b0}}, Qcnt_three_15[46:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b010000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{9 {1'b0}}, Qcnt_three_16[49:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{8 {1'b0}}, Qcnt_three_16[49:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{7 {1'b0}}, Qcnt_three_16[49:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b010001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{6 {1'b0}}, Qcnt_three_17[52:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{5 {1'b0}}, Qcnt_three_17[52:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{4 {1'b0}}, Qcnt_three_17[52:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					6'b010010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{3 {1'b0}}, Qcnt_three_18[55:2]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{2 {1'b0}}, Qcnt_three_18[55:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {1'b0, Qcnt_three_18[55:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
					default: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_three_0[2]};
						Sqrt_Q0 = Q_sqrt_com_0;
						Sqrt_DI[1] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt1 = {{56 {1'b0}}, Qcnt_three_0[2:1]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[49:48];
						Q_sqrt2 = {{55 {1'b0}}, Qcnt_three_0[2:0]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
					end
				endcase
			2'b11:
				case (Crtl_cnt_S)
					6'b000000: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_four_0[3]};
						Sqrt_Q0 = Q_sqrt_com_0;
						Sqrt_DI[1] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt1 = {{56 {1'b0}}, Qcnt_four_0[3:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[49:48];
						Q_sqrt2 = {{55 {1'b0}}, Qcnt_four_0[3:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[47:46];
						Q_sqrt3 = {{54 {1'b0}}, Qcnt_four_0[3:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000001: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[45:44];
						Q_sqrt0 = {{53 {1'b0}}, Qcnt_four_1[6:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[43:42];
						Q_sqrt1 = {{defs_div_sqrt_mvp_C_MANT_FP64 {1'b0}}, Qcnt_four_1[6:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[41:40];
						Q_sqrt2 = {{51 {1'b0}}, Qcnt_four_1[6:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[39:38];
						Q_sqrt3 = {{50 {1'b0}}, Qcnt_four_1[6:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000010: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[37:36];
						Q_sqrt0 = {{49 {1'b0}}, Qcnt_four_2[10:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[35:34];
						Q_sqrt1 = {{48 {1'b0}}, Qcnt_four_2[10:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[33:32];
						Q_sqrt2 = {{47 {1'b0}}, Qcnt_four_2[10:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[31:30];
						Q_sqrt3 = {{46 {1'b0}}, Qcnt_four_2[10:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000011: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[29:28];
						Q_sqrt0 = {{45 {1'b0}}, Qcnt_four_3[14:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[27:26];
						Q_sqrt1 = {{44 {1'b0}}, Qcnt_four_3[14:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[25:24];
						Q_sqrt2 = {{43 {1'b0}}, Qcnt_four_3[14:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[23:22];
						Q_sqrt3 = {{42 {1'b0}}, Qcnt_four_3[14:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000100: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[21:20];
						Q_sqrt0 = {{41 {1'b0}}, Qcnt_four_4[18:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[19:18];
						Q_sqrt1 = {{40 {1'b0}}, Qcnt_four_4[18:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[17:16];
						Q_sqrt2 = {{39 {1'b0}}, Qcnt_four_4[18:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[15:14];
						Q_sqrt3 = {{38 {1'b0}}, Qcnt_four_4[18:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000101: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[13:12];
						Q_sqrt0 = {{37 {1'b0}}, Qcnt_four_5[22:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[11:10];
						Q_sqrt1 = {{36 {1'b0}}, Qcnt_four_5[22:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[9:8];
						Q_sqrt2 = {{35 {1'b0}}, Qcnt_four_5[22:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[7:6];
						Q_sqrt3 = {{34 {1'b0}}, Qcnt_four_5[22:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000110: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[5:4];
						Q_sqrt0 = {{33 {1'b0}}, Qcnt_four_6[26:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = Mant_D_sqrt_Norm[3:2];
						Q_sqrt1 = {{32 {1'b0}}, Qcnt_four_6[26:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[1:0];
						Q_sqrt2 = {{31 {1'b0}}, Qcnt_four_6[26:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{30 {1'b0}}, Qcnt_four_6[26:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b000111: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{29 {1'b0}}, Qcnt_four_7[30:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{28 {1'b0}}, Qcnt_four_7[30:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{27 {1'b0}}, Qcnt_four_7[30:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{26 {1'b0}}, Qcnt_four_7[30:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b001000: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{25 {1'b0}}, Qcnt_four_8[34:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{24 {1'b0}}, Qcnt_four_8[34:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{23 {1'b0}}, Qcnt_four_8[34:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{22 {1'b0}}, Qcnt_four_8[34:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b001001: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{21 {1'b0}}, Qcnt_four_9[38:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{20 {1'b0}}, Qcnt_four_9[38:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{19 {1'b0}}, Qcnt_four_9[38:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{18 {1'b0}}, Qcnt_four_9[38:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b001010: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{17 {1'b0}}, Qcnt_four_10[42:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{16 {1'b0}}, Qcnt_four_10[42:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{15 {1'b0}}, Qcnt_four_10[42:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{14 {1'b0}}, Qcnt_four_10[42:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b001011: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{13 {1'b0}}, Qcnt_four_11[46:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{12 {1'b0}}, Qcnt_four_11[46:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{11 {1'b0}}, Qcnt_four_11[46:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{10 {1'b0}}, Qcnt_four_11[46:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b001100: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{9 {1'b0}}, Qcnt_four_12[50:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{8 {1'b0}}, Qcnt_four_12[50:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{7 {1'b0}}, Qcnt_four_12[50:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{6 {1'b0}}, Qcnt_four_12[50:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					6'b001101: begin
						Sqrt_DI[0] = 2'b00;
						Q_sqrt0 = {{5 {1'b0}}, Qcnt_four_13[54:3]};
						Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
						Sqrt_DI[1] = 2'b00;
						Q_sqrt1 = {{4 {1'b0}}, Qcnt_four_13[54:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = 2'b00;
						Q_sqrt2 = {{3 {1'b0}}, Qcnt_four_13[54:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = 2'b00;
						Q_sqrt3 = {{2 {1'b0}}, Qcnt_four_13[54:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
					default: begin
						Sqrt_DI[0] = Mant_D_sqrt_Norm[53:defs_div_sqrt_mvp_C_MANT_FP64];
						Q_sqrt0 = {{57 {1'b0}}, Qcnt_four_0[3]};
						Sqrt_Q0 = Q_sqrt_com_0;
						Sqrt_DI[1] = Mant_D_sqrt_Norm[51:50];
						Q_sqrt1 = {{56 {1'b0}}, Qcnt_four_0[3:2]};
						Sqrt_Q1 = (Sqrt_quotinent_S[3] ? Q_sqrt_com_1 : Q_sqrt1);
						Sqrt_DI[2] = Mant_D_sqrt_Norm[49:48];
						Q_sqrt2 = {{55 {1'b0}}, Qcnt_four_0[3:1]};
						Sqrt_Q2 = (Sqrt_quotinent_S[2] ? Q_sqrt_com_2 : Q_sqrt2);
						Sqrt_DI[3] = Mant_D_sqrt_Norm[47:46];
						Q_sqrt3 = {{54 {1'b0}}, Qcnt_four_0[3:0]};
						Sqrt_Q3 = (Sqrt_quotinent_S[1] ? Q_sqrt_com_3 : Q_sqrt3);
					end
				endcase
		endcase
	end
	assign Sqrt_R0 = (Sqrt_start_dly_S ? {58 {1'sb0}} : {Partial_remainder_DP[57:0]});
	assign Sqrt_R1 = {Iteration_cell_sum_AMASK_D[0][57], Iteration_cell_sum_AMASK_D[0][54:0], Sqrt_DO[0]};
	assign Sqrt_R2 = {Iteration_cell_sum_AMASK_D[1][57], Iteration_cell_sum_AMASK_D[1][54:0], Sqrt_DO[1]};
	assign Sqrt_R3 = {Iteration_cell_sum_AMASK_D[2][57], Iteration_cell_sum_AMASK_D[2][54:0], Sqrt_DO[2]};
	assign Sqrt_R4 = {Iteration_cell_sum_AMASK_D[3][57], Iteration_cell_sum_AMASK_D[3][54:0], Sqrt_DO[3]};
	wire [57:0] Denominator_se_format_DB;
	assign Denominator_se_format_DB = {Denominator_se_DB[53:45], (FP16ALT_SO ? FP16ALT_SO : Denominator_se_DB[44]), Denominator_se_DB[43:42], (FP16_SO ? FP16_SO : Denominator_se_DB[41]), Denominator_se_DB[40:29], (FP32_SO ? FP32_SO : Denominator_se_DB[28]), Denominator_se_DB[27:0], FP64_SO, 3'b000};
	wire [57:0] First_iteration_cell_div_a_D;
	wire [57:0] First_iteration_cell_div_b_D;
	wire Sel_b_for_first_S;
	assign First_iteration_cell_div_a_D = (Div_start_dly_S ? {Numerator_se_D[53:45], (FP16ALT_SO ? FP16ALT_SO : Numerator_se_D[44]), Numerator_se_D[43:42], (FP16_SO ? FP16_SO : Numerator_se_D[41]), Numerator_se_D[40:29], (FP32_SO ? FP32_SO : Numerator_se_D[28]), Numerator_se_D[27:0], FP64_SO, 3'b000} : {Partial_remainder_DP[56:48], (FP16ALT_SO ? Quotient_DP[0] : Partial_remainder_DP[47]), Partial_remainder_DP[46:45], (FP16_SO ? Quotient_DP[0] : Partial_remainder_DP[44]), Partial_remainder_DP[43:32], (FP32_SO ? Quotient_DP[0] : Partial_remainder_DP[31]), Partial_remainder_DP[30:3], FP64_SO && Quotient_DP[0], 3'b000});
	assign Sel_b_for_first_S = (Div_start_dly_S ? 1 : Quotient_DP[0]);
	assign First_iteration_cell_div_b_D = (Sel_b_for_first_S ? Denominator_se_format_DB : {Denominator_se_D, 4'b0000});
	assign Iteration_cell_a_BMASK_D[0] = (Sqrt_enable_SO ? Sqrt_R0 : {First_iteration_cell_div_a_D});
	assign Iteration_cell_b_BMASK_D[0] = (Sqrt_enable_SO ? Sqrt_Q0 : {First_iteration_cell_div_b_D});
	wire [57:0] Sec_iteration_cell_div_a_D;
	wire [57:0] Sec_iteration_cell_div_b_D;
	wire Sel_b_for_sec_S;
	generate
		if (|defs_div_sqrt_mvp_Iteration_unit_num_S) begin : genblk1
			assign Sel_b_for_sec_S = ~Iteration_cell_sum_AMASK_D[0][57];
			assign Sec_iteration_cell_div_a_D = {Iteration_cell_sum_AMASK_D[0][56:48], (FP16ALT_SO ? Sel_b_for_sec_S : Iteration_cell_sum_AMASK_D[0][47]), Iteration_cell_sum_AMASK_D[0][46:45], (FP16_SO ? Sel_b_for_sec_S : Iteration_cell_sum_AMASK_D[0][44]), Iteration_cell_sum_AMASK_D[0][43:32], (FP32_SO ? Sel_b_for_sec_S : Iteration_cell_sum_AMASK_D[0][31]), Iteration_cell_sum_AMASK_D[0][30:3], FP64_SO && Sel_b_for_sec_S, 3'b000};
			assign Sec_iteration_cell_div_b_D = (Sel_b_for_sec_S ? Denominator_se_format_DB : {Denominator_se_D, 4'b0000});
			assign Iteration_cell_a_BMASK_D[1] = (Sqrt_enable_SO ? Sqrt_R1 : {Sec_iteration_cell_div_a_D});
			assign Iteration_cell_b_BMASK_D[1] = (Sqrt_enable_SO ? Sqrt_Q1 : {Sec_iteration_cell_div_b_D});
		end
	endgenerate
	wire [57:0] Thi_iteration_cell_div_a_D;
	wire [57:0] Thi_iteration_cell_div_b_D;
	wire Sel_b_for_thi_S;
	generate
		if (1'd1 | 1'd0) begin : genblk2
			assign Sel_b_for_thi_S = ~Iteration_cell_sum_AMASK_D[1][57];
			assign Thi_iteration_cell_div_a_D = {Iteration_cell_sum_AMASK_D[1][56:48], (FP16ALT_SO ? Sel_b_for_thi_S : Iteration_cell_sum_AMASK_D[1][47]), Iteration_cell_sum_AMASK_D[1][46:45], (FP16_SO ? Sel_b_for_thi_S : Iteration_cell_sum_AMASK_D[1][44]), Iteration_cell_sum_AMASK_D[1][43:32], (FP32_SO ? Sel_b_for_thi_S : Iteration_cell_sum_AMASK_D[1][31]), Iteration_cell_sum_AMASK_D[1][30:3], FP64_SO && Sel_b_for_thi_S, 3'b000};
			assign Thi_iteration_cell_div_b_D = (Sel_b_for_thi_S ? Denominator_se_format_DB : {Denominator_se_D, 4'b0000});
			assign Iteration_cell_a_BMASK_D[2] = (Sqrt_enable_SO ? Sqrt_R2 : {Thi_iteration_cell_div_a_D});
			assign Iteration_cell_b_BMASK_D[2] = (Sqrt_enable_SO ? Sqrt_Q2 : {Thi_iteration_cell_div_b_D});
		end
	endgenerate
	wire [57:0] Fou_iteration_cell_div_a_D;
	wire [57:0] Fou_iteration_cell_div_b_D;
	wire Sel_b_for_fou_S;
	wire [57:0] Mask_bits_ctl_S;
	assign Mask_bits_ctl_S = 58'h3ffffffffffffff;
	wire Div_enable_SI [3:0];
	wire Div_start_dly_SI [3:0];
	wire Sqrt_enable_SI [3:0];
	genvar _gv_i_17;
	genvar _gv_j_1;
	generate
		for (_gv_i_17 = 0; _gv_i_17 <= defs_div_sqrt_mvp_Iteration_unit_num_S; _gv_i_17 = _gv_i_17 + 1) begin : genblk4
			localparam i = _gv_i_17;
			for (_gv_j_1 = 0; _gv_j_1 <= 57; _gv_j_1 = _gv_j_1 + 1) begin : genblk1
				localparam j = _gv_j_1;
				assign Iteration_cell_a_D[i][j] = Mask_bits_ctl_S[j] && Iteration_cell_a_BMASK_D[i][j];
				assign Iteration_cell_b_D[i][j] = Mask_bits_ctl_S[j] && Iteration_cell_b_BMASK_D[i][j];
				assign Iteration_cell_sum_AMASK_D[i][j] = Mask_bits_ctl_S[j] && Iteration_cell_sum_D[i][j];
			end
			assign Div_enable_SI[i] = Div_enable_SO;
			assign Div_start_dly_SI[i] = Div_start_dly_S;
			assign Sqrt_enable_SI[i] = Sqrt_enable_SO;
			iteration_div_sqrt_mvp #(.WIDTH(58)) iteration_div_sqrt(
				.A_DI(Iteration_cell_a_D[i]),
				.B_DI(Iteration_cell_b_D[i]),
				.Div_enable_SI(Div_enable_SI[i]),
				.Div_start_dly_SI(Div_start_dly_SI[i]),
				.Sqrt_enable_SI(Sqrt_enable_SI[i]),
				.D_DI(Sqrt_DI[i]),
				.D_DO(Sqrt_DO[i]),
				.Sum_DO(Iteration_cell_sum_D[i]),
				.Carry_out_DO(Iteration_cell_carry_D[i])
			);
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		case (defs_div_sqrt_mvp_Iteration_unit_num_S)
			2'b00:
				if (Fsm_enable_S)
					Partial_remainder_DN = (Sqrt_enable_SO ? Sqrt_R1 : Iteration_cell_sum_AMASK_D[0]);
				else
					Partial_remainder_DN = Partial_remainder_DP;
			2'b01:
				if (Fsm_enable_S)
					Partial_remainder_DN = (Sqrt_enable_SO ? Sqrt_R2 : Iteration_cell_sum_AMASK_D[1]);
				else
					Partial_remainder_DN = Partial_remainder_DP;
			2'b10:
				if (Fsm_enable_S)
					Partial_remainder_DN = (Sqrt_enable_SO ? Sqrt_R3 : Iteration_cell_sum_AMASK_D[2]);
				else
					Partial_remainder_DN = Partial_remainder_DP;
			2'b11:
				if (Fsm_enable_S)
					Partial_remainder_DN = (Sqrt_enable_SO ? Sqrt_R4 : Iteration_cell_sum_AMASK_D[3]);
				else
					Partial_remainder_DN = Partial_remainder_DP;
		endcase
	end
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Partial_remainder_DP <= 1'sb0;
		else
			Partial_remainder_DP <= Partial_remainder_DN;
	reg [56:0] Quotient_DN;
	always @(*) begin
		if (_sv2v_0)
			;
		case (defs_div_sqrt_mvp_Iteration_unit_num_S)
			2'b00:
				if (Fsm_enable_S)
					Quotient_DN = (Sqrt_enable_SO ? {Quotient_DP[55:0], Sqrt_quotinent_S[3]} : {Quotient_DP[55:0], Iteration_cell_carry_D[0]});
				else
					Quotient_DN = Quotient_DP;
			2'b01:
				if (Fsm_enable_S)
					Quotient_DN = (Sqrt_enable_SO ? {Quotient_DP[54:0], Sqrt_quotinent_S[3:2]} : {Quotient_DP[54:0], Iteration_cell_carry_D[0], Iteration_cell_carry_D[1]});
				else
					Quotient_DN = Quotient_DP;
			2'b10:
				if (Fsm_enable_S)
					Quotient_DN = (Sqrt_enable_SO ? {Quotient_DP[53:0], Sqrt_quotinent_S[3:1]} : {Quotient_DP[53:0], Iteration_cell_carry_D[0], Iteration_cell_carry_D[1], Iteration_cell_carry_D[2]});
				else
					Quotient_DN = Quotient_DP;
			2'b11:
				if (Fsm_enable_S)
					Quotient_DN = (Sqrt_enable_SO ? {Quotient_DP[defs_div_sqrt_mvp_C_MANT_FP64:0], Sqrt_quotinent_S} : {Quotient_DP[defs_div_sqrt_mvp_C_MANT_FP64:0], Iteration_cell_carry_D[0], Iteration_cell_carry_D[1], Iteration_cell_carry_D[2], Iteration_cell_carry_D[3]});
				else
					Quotient_DN = Quotient_DP;
		endcase
	end
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Quotient_DP <= 1'sb0;
		else
			Quotient_DP <= Quotient_DN;
	generate
		if (1) begin : genblk7
			always @(*) begin
				if (_sv2v_0)
					;
				case (Format_sel_S)
					2'b00:
						case (Precision_ctl_S)
							6'h00: Mant_result_prenorm_DO = {Quotient_DP[26:0], {30 {1'b0}}};
							6'h17, 6'h16, 6'h15: Mant_result_prenorm_DO = {Quotient_DP[defs_div_sqrt_mvp_C_MANT_FP32:0], {33 {1'b0}}};
							6'h14, 6'h13, 6'h12: Mant_result_prenorm_DO = {Quotient_DP[20:0], {36 {1'b0}}};
							6'h11, 6'h10, 6'h0f: Mant_result_prenorm_DO = {Quotient_DP[17:0], {39 {1'b0}}};
							6'h0e, 6'h0d, 6'h0c: Mant_result_prenorm_DO = {Quotient_DP[14:0], {42 {1'b0}}};
							6'h0b, 6'h0a, 6'h09: Mant_result_prenorm_DO = {Quotient_DP[11:0], {45 {1'b0}}};
							6'h08, 6'h07, 6'h06: Mant_result_prenorm_DO = {Quotient_DP[8:0], {48 {1'b0}}};
							default: Mant_result_prenorm_DO = {Quotient_DP[26:0], {30 {1'b0}}};
						endcase
					2'b01:
						case (Precision_ctl_S)
							6'h00: Mant_result_prenorm_DO = Quotient_DP[56:0];
							6'h34, 6'h33: Mant_result_prenorm_DO = {Quotient_DP[53:1], {4 {1'b0}}};
							6'h32, 6'h31, 6'h30: Mant_result_prenorm_DO = {Quotient_DP[50:0], {6 {1'b0}}};
							6'h2f, 6'h2e, 6'h2d: Mant_result_prenorm_DO = {Quotient_DP[47:0], {9 {1'b0}}};
							6'h2c, 6'h2b, 6'h2a: Mant_result_prenorm_DO = {Quotient_DP[44:0], {12 {1'b0}}};
							6'h29, 6'h28, 6'h27: Mant_result_prenorm_DO = {Quotient_DP[41:0], {15 {1'b0}}};
							6'h26, 6'h25, 6'h24: Mant_result_prenorm_DO = {Quotient_DP[38:0], {18 {1'b0}}};
							6'h23, 6'h22, 6'h21: Mant_result_prenorm_DO = {Quotient_DP[35:0], {21 {1'b0}}};
							6'h20, 6'h1f, 6'h1e: Mant_result_prenorm_DO = {Quotient_DP[32:0], {24 {1'b0}}};
							6'h1d, 6'h1c, 6'h1b: Mant_result_prenorm_DO = {Quotient_DP[29:0], {27 {1'b0}}};
							6'h1a, 6'h19, 6'h18: Mant_result_prenorm_DO = {Quotient_DP[26:0], {30 {1'b0}}};
							6'h17, 6'h16, 6'h15: Mant_result_prenorm_DO = {Quotient_DP[23:0], {33 {1'b0}}};
							6'h14, 6'h13, 6'h12: Mant_result_prenorm_DO = {Quotient_DP[20:0], {36 {1'b0}}};
							6'h11, 6'h10, 6'h0f: Mant_result_prenorm_DO = {Quotient_DP[17:0], {39 {1'b0}}};
							6'h0e, 6'h0d, 6'h0c: Mant_result_prenorm_DO = {Quotient_DP[14:0], {42 {1'b0}}};
							6'h0b, 6'h0a, 6'h09: Mant_result_prenorm_DO = {Quotient_DP[11:0], {45 {1'b0}}};
							6'h08, 6'h07, 6'h06: Mant_result_prenorm_DO = {Quotient_DP[8:0], {48 {1'b0}}};
							default: Mant_result_prenorm_DO = Quotient_DP[56:0];
						endcase
					2'b10:
						case (Precision_ctl_S)
							6'b000000: Mant_result_prenorm_DO = {Quotient_DP[14:0], {42 {1'b0}}};
							6'h0a, 6'h09: Mant_result_prenorm_DO = {Quotient_DP[11:1], {46 {1'b0}}};
							6'h08, 6'h07, 6'h06: Mant_result_prenorm_DO = {Quotient_DP[8:0], {48 {1'b0}}};
							default: Mant_result_prenorm_DO = {Quotient_DP[14:0], {42 {1'b0}}};
						endcase
					2'b11:
						case (Precision_ctl_S)
							6'b000000: Mant_result_prenorm_DO = {Quotient_DP[11:0], {45 {1'b0}}};
							6'h07, 6'h06: Mant_result_prenorm_DO = {Quotient_DP[8:1], {49 {1'b0}}};
							default: Mant_result_prenorm_DO = {Quotient_DP[11:0], {45 {1'b0}}};
						endcase
				endcase
			end
		end
	endgenerate
	wire [12:0] Exp_result_prenorm_DN;
	reg [12:0] Exp_result_prenorm_DP;
	wire [12:0] Exp_add_a_D;
	wire [12:0] Exp_add_b_D;
	wire [12:0] Exp_add_c_D;
	integer C_BIAS_AONE;
	integer C_HALF_BIAS;
	localparam defs_div_sqrt_mvp_C_BIAS_AONE_FP16 = 5'h10;
	localparam defs_div_sqrt_mvp_C_BIAS_AONE_FP16ALT = 8'h80;
	localparam defs_div_sqrt_mvp_C_BIAS_AONE_FP32 = 8'h80;
	localparam defs_div_sqrt_mvp_C_BIAS_AONE_FP64 = 11'h400;
	localparam defs_div_sqrt_mvp_C_HALF_BIAS_FP16 = 7;
	localparam defs_div_sqrt_mvp_C_HALF_BIAS_FP16ALT = 63;
	localparam defs_div_sqrt_mvp_C_HALF_BIAS_FP32 = 63;
	localparam defs_div_sqrt_mvp_C_HALF_BIAS_FP64 = 511;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Format_sel_S)
			2'b00: begin
				C_BIAS_AONE = defs_div_sqrt_mvp_C_BIAS_AONE_FP32;
				C_HALF_BIAS = defs_div_sqrt_mvp_C_HALF_BIAS_FP32;
			end
			2'b01: begin
				C_BIAS_AONE = defs_div_sqrt_mvp_C_BIAS_AONE_FP64;
				C_HALF_BIAS = defs_div_sqrt_mvp_C_HALF_BIAS_FP64;
			end
			2'b10: begin
				C_BIAS_AONE = defs_div_sqrt_mvp_C_BIAS_AONE_FP16;
				C_HALF_BIAS = defs_div_sqrt_mvp_C_HALF_BIAS_FP16;
			end
			2'b11: begin
				C_BIAS_AONE = defs_div_sqrt_mvp_C_BIAS_AONE_FP16ALT;
				C_HALF_BIAS = defs_div_sqrt_mvp_C_HALF_BIAS_FP16ALT;
			end
		endcase
	end
	assign Exp_add_a_D = {(Sqrt_start_dly_S ? {Exp_num_DI[defs_div_sqrt_mvp_C_EXP_FP64], Exp_num_DI[defs_div_sqrt_mvp_C_EXP_FP64], Exp_num_DI[defs_div_sqrt_mvp_C_EXP_FP64], Exp_num_DI[defs_div_sqrt_mvp_C_EXP_FP64:1]} : {Exp_num_DI[defs_div_sqrt_mvp_C_EXP_FP64], Exp_num_DI[defs_div_sqrt_mvp_C_EXP_FP64], Exp_num_DI})};
	localparam defs_div_sqrt_mvp_C_EXP_ZERO_FP64 = 11'h000;
	assign Exp_add_b_D = {(Sqrt_start_dly_S ? {1'b0, defs_div_sqrt_mvp_C_EXP_ZERO_FP64, Exp_num_DI[0]} : {~Exp_den_DI[defs_div_sqrt_mvp_C_EXP_FP64], ~Exp_den_DI[defs_div_sqrt_mvp_C_EXP_FP64], ~Exp_den_DI})};
	assign Exp_add_c_D = {(Div_start_dly_S ? {C_BIAS_AONE} : {C_HALF_BIAS})};
	assign Exp_result_prenorm_DN = (Start_dly_S ? {(Exp_add_a_D + Exp_add_b_D) + Exp_add_c_D} : Exp_result_prenorm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Exp_result_prenorm_DP <= 1'sb0;
		else
			Exp_result_prenorm_DP <= Exp_result_prenorm_DN;
	assign Exp_result_prenorm_DO = Exp_result_prenorm_DP;
	initial _sv2v_0 = 0;
endmodule
module preprocess_mvp (
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Ready_SI,
	Operand_a_DI,
	Operand_b_DI,
	RM_SI,
	Format_sel_SI,
	Start_SO,
	Exp_a_DO_norm,
	Exp_b_DO_norm,
	Mant_a_DO_norm,
	Mant_b_DO_norm,
	RM_dly_SO,
	Sign_z_DO,
	Inf_a_SO,
	Inf_b_SO,
	Zero_a_SO,
	Zero_b_SO,
	NaN_a_SO,
	NaN_b_SO,
	SNaN_SO,
	Special_case_SBO,
	Special_case_dly_SBO
);
	reg _sv2v_0;
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	input wire Ready_SI;
	localparam defs_div_sqrt_mvp_C_OP_FP64 = 64;
	input wire [63:0] Operand_a_DI;
	input wire [63:0] Operand_b_DI;
	localparam defs_div_sqrt_mvp_C_RM = 3;
	input wire [2:0] RM_SI;
	localparam defs_div_sqrt_mvp_C_FS = 2;
	input wire [1:0] Format_sel_SI;
	output wire Start_SO;
	localparam defs_div_sqrt_mvp_C_EXP_FP64 = 11;
	output wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_a_DO_norm;
	output wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_b_DO_norm;
	localparam defs_div_sqrt_mvp_C_MANT_FP64 = 52;
	output wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_a_DO_norm;
	output wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_b_DO_norm;
	output wire [2:0] RM_dly_SO;
	output wire Sign_z_DO;
	output wire Inf_a_SO;
	output wire Inf_b_SO;
	output wire Zero_a_SO;
	output wire Zero_b_SO;
	output wire NaN_a_SO;
	output wire NaN_b_SO;
	output wire SNaN_SO;
	output wire Special_case_SBO;
	output reg Special_case_dly_SBO;
	wire Hb_a_D;
	wire Hb_b_D;
	reg [10:0] Exp_a_D;
	reg [10:0] Exp_b_D;
	reg [51:0] Mant_a_NonH_D;
	reg [51:0] Mant_b_NonH_D;
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_a_D;
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_b_D;
	reg Sign_a_D;
	reg Sign_b_D;
	wire Start_S;
	localparam defs_div_sqrt_mvp_C_MANT_FP16 = 10;
	localparam defs_div_sqrt_mvp_C_MANT_FP16ALT = 7;
	localparam defs_div_sqrt_mvp_C_MANT_FP32 = 23;
	localparam defs_div_sqrt_mvp_C_OP_FP16 = 16;
	localparam defs_div_sqrt_mvp_C_OP_FP16ALT = 16;
	localparam defs_div_sqrt_mvp_C_OP_FP32 = 32;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Format_sel_SI)
			2'b00: begin
				Sign_a_D = Operand_a_DI[31];
				Sign_b_D = Operand_b_DI[31];
				Exp_a_D = {3'h0, Operand_a_DI[30:defs_div_sqrt_mvp_C_MANT_FP32]};
				Exp_b_D = {3'h0, Operand_b_DI[30:defs_div_sqrt_mvp_C_MANT_FP32]};
				Mant_a_NonH_D = {Operand_a_DI[22:0], 29'h00000000};
				Mant_b_NonH_D = {Operand_b_DI[22:0], 29'h00000000};
			end
			2'b01: begin
				Sign_a_D = Operand_a_DI[63];
				Sign_b_D = Operand_b_DI[63];
				Exp_a_D = Operand_a_DI[62:defs_div_sqrt_mvp_C_MANT_FP64];
				Exp_b_D = Operand_b_DI[62:defs_div_sqrt_mvp_C_MANT_FP64];
				Mant_a_NonH_D = Operand_a_DI[51:0];
				Mant_b_NonH_D = Operand_b_DI[51:0];
			end
			2'b10: begin
				Sign_a_D = Operand_a_DI[15];
				Sign_b_D = Operand_b_DI[15];
				Exp_a_D = {6'h00, Operand_a_DI[14:defs_div_sqrt_mvp_C_MANT_FP16]};
				Exp_b_D = {6'h00, Operand_b_DI[14:defs_div_sqrt_mvp_C_MANT_FP16]};
				Mant_a_NonH_D = {Operand_a_DI[9:0], 42'h00000000000};
				Mant_b_NonH_D = {Operand_b_DI[9:0], 42'h00000000000};
			end
			2'b11: begin
				Sign_a_D = Operand_a_DI[15];
				Sign_b_D = Operand_b_DI[15];
				Exp_a_D = {3'h0, Operand_a_DI[14:defs_div_sqrt_mvp_C_MANT_FP16ALT]};
				Exp_b_D = {3'h0, Operand_b_DI[14:defs_div_sqrt_mvp_C_MANT_FP16ALT]};
				Mant_a_NonH_D = {Operand_a_DI[6:0], 45'h000000000000};
				Mant_b_NonH_D = {Operand_b_DI[6:0], 45'h000000000000};
			end
		endcase
	end
	assign Mant_a_D = {Hb_a_D, Mant_a_NonH_D};
	assign Mant_b_D = {Hb_b_D, Mant_b_NonH_D};
	assign Hb_a_D = |Exp_a_D;
	assign Hb_b_D = |Exp_b_D;
	assign Start_S = Div_start_SI | Sqrt_start_SI;
	reg Mant_a_prenorm_zero_S;
	reg Mant_b_prenorm_zero_S;
	wire Exp_a_prenorm_zero_S;
	wire Exp_b_prenorm_zero_S;
	assign Exp_a_prenorm_zero_S = ~Hb_a_D;
	assign Exp_b_prenorm_zero_S = ~Hb_b_D;
	reg Exp_a_prenorm_Inf_NaN_S;
	reg Exp_b_prenorm_Inf_NaN_S;
	wire Mant_a_prenorm_QNaN_S;
	wire Mant_a_prenorm_SNaN_S;
	wire Mant_b_prenorm_QNaN_S;
	wire Mant_b_prenorm_SNaN_S;
	assign Mant_a_prenorm_QNaN_S = Mant_a_NonH_D[51] && ~(|Mant_a_NonH_D[50:0]);
	assign Mant_a_prenorm_SNaN_S = ~Mant_a_NonH_D[51] && |Mant_a_NonH_D[50:0];
	assign Mant_b_prenorm_QNaN_S = Mant_b_NonH_D[51] && ~(|Mant_b_NonH_D[50:0]);
	assign Mant_b_prenorm_SNaN_S = ~Mant_b_NonH_D[51] && |Mant_b_NonH_D[50:0];
	localparam defs_div_sqrt_mvp_C_EXP_INF_FP16 = 5'h1f;
	localparam defs_div_sqrt_mvp_C_EXP_INF_FP16ALT = 8'hff;
	localparam defs_div_sqrt_mvp_C_EXP_INF_FP32 = 8'hff;
	localparam defs_div_sqrt_mvp_C_EXP_INF_FP64 = 11'h7ff;
	localparam defs_div_sqrt_mvp_C_MANT_ZERO_FP16 = 10'h000;
	localparam defs_div_sqrt_mvp_C_MANT_ZERO_FP16ALT = 7'h00;
	localparam defs_div_sqrt_mvp_C_MANT_ZERO_FP32 = 23'h000000;
	localparam defs_div_sqrt_mvp_C_MANT_ZERO_FP64 = 52'h0000000000000;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Format_sel_SI)
			2'b00: begin
				Mant_a_prenorm_zero_S = Operand_a_DI[22:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP32;
				Mant_b_prenorm_zero_S = Operand_b_DI[22:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP32;
				Exp_a_prenorm_Inf_NaN_S = Operand_a_DI[30:defs_div_sqrt_mvp_C_MANT_FP32] == defs_div_sqrt_mvp_C_EXP_INF_FP32;
				Exp_b_prenorm_Inf_NaN_S = Operand_b_DI[30:defs_div_sqrt_mvp_C_MANT_FP32] == defs_div_sqrt_mvp_C_EXP_INF_FP32;
			end
			2'b01: begin
				Mant_a_prenorm_zero_S = Operand_a_DI[51:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP64;
				Mant_b_prenorm_zero_S = Operand_b_DI[51:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP64;
				Exp_a_prenorm_Inf_NaN_S = Operand_a_DI[62:defs_div_sqrt_mvp_C_MANT_FP64] == defs_div_sqrt_mvp_C_EXP_INF_FP64;
				Exp_b_prenorm_Inf_NaN_S = Operand_b_DI[62:defs_div_sqrt_mvp_C_MANT_FP64] == defs_div_sqrt_mvp_C_EXP_INF_FP64;
			end
			2'b10: begin
				Mant_a_prenorm_zero_S = Operand_a_DI[9:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP16;
				Mant_b_prenorm_zero_S = Operand_b_DI[9:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP16;
				Exp_a_prenorm_Inf_NaN_S = Operand_a_DI[14:defs_div_sqrt_mvp_C_MANT_FP16] == defs_div_sqrt_mvp_C_EXP_INF_FP16;
				Exp_b_prenorm_Inf_NaN_S = Operand_b_DI[14:defs_div_sqrt_mvp_C_MANT_FP16] == defs_div_sqrt_mvp_C_EXP_INF_FP16;
			end
			2'b11: begin
				Mant_a_prenorm_zero_S = Operand_a_DI[6:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP16ALT;
				Mant_b_prenorm_zero_S = Operand_b_DI[6:0] == defs_div_sqrt_mvp_C_MANT_ZERO_FP16ALT;
				Exp_a_prenorm_Inf_NaN_S = Operand_a_DI[14:defs_div_sqrt_mvp_C_MANT_FP16ALT] == defs_div_sqrt_mvp_C_EXP_INF_FP16ALT;
				Exp_b_prenorm_Inf_NaN_S = Operand_b_DI[14:defs_div_sqrt_mvp_C_MANT_FP16ALT] == defs_div_sqrt_mvp_C_EXP_INF_FP16ALT;
			end
		endcase
	end
	wire Zero_a_SN;
	reg Zero_a_SP;
	wire Zero_b_SN;
	reg Zero_b_SP;
	wire Inf_a_SN;
	reg Inf_a_SP;
	wire Inf_b_SN;
	reg Inf_b_SP;
	wire NaN_a_SN;
	reg NaN_a_SP;
	wire NaN_b_SN;
	reg NaN_b_SP;
	wire SNaN_SN;
	reg SNaN_SP;
	assign Zero_a_SN = (Start_S && Ready_SI ? Exp_a_prenorm_zero_S && Mant_a_prenorm_zero_S : Zero_a_SP);
	assign Zero_b_SN = (Start_S && Ready_SI ? Exp_b_prenorm_zero_S && Mant_b_prenorm_zero_S : Zero_b_SP);
	assign Inf_a_SN = (Start_S && Ready_SI ? Exp_a_prenorm_Inf_NaN_S && Mant_a_prenorm_zero_S : Inf_a_SP);
	assign Inf_b_SN = (Start_S && Ready_SI ? Exp_b_prenorm_Inf_NaN_S && Mant_b_prenorm_zero_S : Inf_b_SP);
	assign NaN_a_SN = (Start_S && Ready_SI ? Exp_a_prenorm_Inf_NaN_S && ~Mant_a_prenorm_zero_S : NaN_a_SP);
	assign NaN_b_SN = (Start_S && Ready_SI ? Exp_b_prenorm_Inf_NaN_S && ~Mant_b_prenorm_zero_S : NaN_b_SP);
	assign SNaN_SN = (Start_S && Ready_SI ? (Mant_a_prenorm_SNaN_S && NaN_a_SN) | (Mant_b_prenorm_SNaN_S && NaN_b_SN) : SNaN_SP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI) begin
			Zero_a_SP <= 1'sb0;
			Zero_b_SP <= 1'sb0;
			Inf_a_SP <= 1'sb0;
			Inf_b_SP <= 1'sb0;
			NaN_a_SP <= 1'sb0;
			NaN_b_SP <= 1'sb0;
			SNaN_SP <= 1'sb0;
		end
		else begin
			Inf_a_SP <= Inf_a_SN;
			Inf_b_SP <= Inf_b_SN;
			Zero_a_SP <= Zero_a_SN;
			Zero_b_SP <= Zero_b_SN;
			NaN_a_SP <= NaN_a_SN;
			NaN_b_SP <= NaN_b_SN;
			SNaN_SP <= SNaN_SN;
		end
	assign Special_case_SBO = ~{(Div_start_SI ? ((((Zero_a_SN | Zero_b_SN) | Inf_a_SN) | Inf_b_SN) | NaN_a_SN) | NaN_b_SN : ((Zero_a_SN | Inf_a_SN) | NaN_a_SN) | Sign_a_D)} && (Start_S && Ready_SI);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Special_case_dly_SBO <= 1'sb0;
		else if (Start_S && Ready_SI)
			Special_case_dly_SBO <= Special_case_SBO;
		else if (Special_case_dly_SBO)
			Special_case_dly_SBO <= 1'b1;
		else
			Special_case_dly_SBO <= 1'sb0;
	reg Sign_z_DN;
	reg Sign_z_DP;
	always @(*) begin
		if (_sv2v_0)
			;
		if (Div_start_SI && Ready_SI)
			Sign_z_DN = Sign_a_D ^ Sign_b_D;
		else if (Sqrt_start_SI && Ready_SI)
			Sign_z_DN = Sign_a_D;
		else
			Sign_z_DN = Sign_z_DP;
	end
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Sign_z_DP <= 1'sb0;
		else
			Sign_z_DP <= Sign_z_DN;
	reg [2:0] RM_DN;
	reg [2:0] RM_DP;
	always @(*) begin
		if (_sv2v_0)
			;
		if (Start_S && Ready_SI)
			RM_DN = RM_SI;
		else
			RM_DN = RM_DP;
	end
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			RM_DP <= 1'sb0;
		else
			RM_DP <= RM_DN;
	assign RM_dly_SO = RM_DP;
	wire [5:0] Mant_leadingOne_a;
	wire [5:0] Mant_leadingOne_b;
	wire Mant_zero_S_a;
	wire Mant_zero_S_b;
	lzc #(
		.WIDTH(53),
		.MODE(1)
	) LOD_Ua(
		.in_i(Mant_a_D),
		.cnt_o(Mant_leadingOne_a),
		.empty_o(Mant_zero_S_a)
	);
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_a_norm_DN;
	reg [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_a_norm_DP;
	assign Mant_a_norm_DN = (Start_S && Ready_SI ? Mant_a_D << Mant_leadingOne_a : Mant_a_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Mant_a_norm_DP <= 1'sb0;
		else
			Mant_a_norm_DP <= Mant_a_norm_DN;
	wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_a_norm_DN;
	reg [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_a_norm_DP;
	assign Exp_a_norm_DN = (Start_S && Ready_SI ? (Exp_a_D - Mant_leadingOne_a) + |Mant_leadingOne_a : Exp_a_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Exp_a_norm_DP <= 1'sb0;
		else
			Exp_a_norm_DP <= Exp_a_norm_DN;
	lzc #(
		.WIDTH(53),
		.MODE(1)
	) LOD_Ub(
		.in_i(Mant_b_D),
		.cnt_o(Mant_leadingOne_b),
		.empty_o(Mant_zero_S_b)
	);
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_b_norm_DN;
	reg [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_b_norm_DP;
	assign Mant_b_norm_DN = (Start_S && Ready_SI ? Mant_b_D << Mant_leadingOne_b : Mant_b_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Mant_b_norm_DP <= 1'sb0;
		else
			Mant_b_norm_DP <= Mant_b_norm_DN;
	wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_b_norm_DN;
	reg [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_b_norm_DP;
	assign Exp_b_norm_DN = (Start_S && Ready_SI ? (Exp_b_D - Mant_leadingOne_b) + |Mant_leadingOne_b : Exp_b_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Exp_b_norm_DP <= 1'sb0;
		else
			Exp_b_norm_DP <= Exp_b_norm_DN;
	assign Start_SO = Start_S;
	assign Exp_a_DO_norm = Exp_a_norm_DP;
	assign Exp_b_DO_norm = Exp_b_norm_DP;
	assign Mant_a_DO_norm = Mant_a_norm_DP;
	assign Mant_b_DO_norm = Mant_b_norm_DP;
	assign Sign_z_DO = Sign_z_DP;
	assign Inf_a_SO = Inf_a_SP;
	assign Inf_b_SO = Inf_b_SP;
	assign Zero_a_SO = Zero_a_SP;
	assign Zero_b_SO = Zero_b_SP;
	assign NaN_a_SO = NaN_a_SP;
	assign NaN_b_SO = NaN_b_SP;
	assign SNaN_SO = SNaN_SP;
	initial _sv2v_0 = 0;
endmodule
module iteration_div_sqrt_mvp (
	A_DI,
	B_DI,
	Div_enable_SI,
	Div_start_dly_SI,
	Sqrt_enable_SI,
	D_DI,
	D_DO,
	Sum_DO,
	Carry_out_DO
);
	parameter WIDTH = 25;
	input wire [WIDTH - 1:0] A_DI;
	input wire [WIDTH - 1:0] B_DI;
	input wire Div_enable_SI;
	input wire Div_start_dly_SI;
	input wire Sqrt_enable_SI;
	input wire [1:0] D_DI;
	output wire [1:0] D_DO;
	output wire [WIDTH - 1:0] Sum_DO;
	output wire Carry_out_DO;
	wire D_carry_D;
	wire Sqrt_cin_D;
	wire Cin_D;
	assign D_DO[0] = ~D_DI[0];
	assign D_DO[1] = ~(D_DI[1] ^ D_DI[0]);
	assign D_carry_D = D_DI[1] | D_DI[0];
	assign Sqrt_cin_D = Sqrt_enable_SI && D_carry_D;
	assign Cin_D = (Div_enable_SI ? 1'b0 : Sqrt_cin_D);
	assign {Carry_out_DO, Sum_DO} = (A_DI + B_DI) + Cin_D;
endmodule
module norm_div_sqrt_mvp (
	Mant_in_DI,
	Exp_in_DI,
	Sign_in_DI,
	Div_enable_SI,
	Sqrt_enable_SI,
	Inf_a_SI,
	Inf_b_SI,
	Zero_a_SI,
	Zero_b_SI,
	NaN_a_SI,
	NaN_b_SI,
	SNaN_SI,
	RM_SI,
	Full_precision_SI,
	FP32_SI,
	FP64_SI,
	FP16_SI,
	FP16ALT_SI,
	Result_DO,
	Fflags_SO
);
	reg _sv2v_0;
	localparam defs_div_sqrt_mvp_C_MANT_FP64 = 52;
	input wire [56:0] Mant_in_DI;
	localparam defs_div_sqrt_mvp_C_EXP_FP64 = 11;
	input wire signed [12:0] Exp_in_DI;
	input wire Sign_in_DI;
	input wire Div_enable_SI;
	input wire Sqrt_enable_SI;
	input wire Inf_a_SI;
	input wire Inf_b_SI;
	input wire Zero_a_SI;
	input wire Zero_b_SI;
	input wire NaN_a_SI;
	input wire NaN_b_SI;
	input wire SNaN_SI;
	localparam defs_div_sqrt_mvp_C_RM = 3;
	input wire [2:0] RM_SI;
	input wire Full_precision_SI;
	input wire FP32_SI;
	input wire FP64_SI;
	input wire FP16_SI;
	input wire FP16ALT_SI;
	output reg [63:0] Result_DO;
	output wire [4:0] Fflags_SO;
	reg Sign_res_D;
	reg NV_OP_S;
	reg Exp_OF_S;
	reg Exp_UF_S;
	reg Div_Zero_S;
	wire In_Exact_S;
	reg [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_res_norm_D;
	reg [10:0] Exp_res_norm_D;
	wire [12:0] Exp_Max_RS_FP64_D;
	localparam defs_div_sqrt_mvp_C_EXP_FP32 = 8;
	wire [9:0] Exp_Max_RS_FP32_D;
	localparam defs_div_sqrt_mvp_C_EXP_FP16 = 5;
	wire [6:0] Exp_Max_RS_FP16_D;
	localparam defs_div_sqrt_mvp_C_EXP_FP16ALT = 8;
	wire [9:0] Exp_Max_RS_FP16ALT_D;
	assign Exp_Max_RS_FP64_D = (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP64:0] + defs_div_sqrt_mvp_C_MANT_FP64) + 1;
	localparam defs_div_sqrt_mvp_C_MANT_FP32 = 23;
	assign Exp_Max_RS_FP32_D = (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP32:0] + defs_div_sqrt_mvp_C_MANT_FP32) + 1;
	localparam defs_div_sqrt_mvp_C_MANT_FP16 = 10;
	assign Exp_Max_RS_FP16_D = (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP16:0] + defs_div_sqrt_mvp_C_MANT_FP16) + 1;
	localparam defs_div_sqrt_mvp_C_MANT_FP16ALT = 7;
	assign Exp_Max_RS_FP16ALT_D = (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP16ALT:0] + defs_div_sqrt_mvp_C_MANT_FP16ALT) + 1;
	wire [12:0] Num_RS_D;
	assign Num_RS_D = ~Exp_in_DI + 2;
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_RS_D;
	wire [56:0] Mant_forsticky_D;
	assign {Mant_RS_D, Mant_forsticky_D} = {Mant_in_DI, {53 {1'b0}}} >> Num_RS_D;
	wire [12:0] Exp_subOne_D;
	assign Exp_subOne_D = Exp_in_DI - 1;
	reg [1:0] Mant_lower_D;
	reg Mant_sticky_bit_D;
	reg [56:0] Mant_forround_D;
	localparam defs_div_sqrt_mvp_C_EXP_ONE_FP64 = 13'h0001;
	localparam defs_div_sqrt_mvp_C_MANT_NAN_FP64 = 52'h8000000000000;
	always @(*) begin
		if (_sv2v_0)
			;
		if (NaN_a_SI) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = {1'b0, defs_div_sqrt_mvp_C_MANT_NAN_FP64};
			Exp_res_norm_D = 1'sb1;
			Mant_forround_D = 1'sb0;
			Sign_res_D = 1'b0;
			NV_OP_S = SNaN_SI;
		end
		else if (NaN_b_SI) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = {1'b0, defs_div_sqrt_mvp_C_MANT_NAN_FP64};
			Exp_res_norm_D = 1'sb1;
			Mant_forround_D = 1'sb0;
			Sign_res_D = 1'b0;
			NV_OP_S = SNaN_SI;
		end
		else if (Inf_a_SI) begin
			if (Div_enable_SI && Inf_b_SI) begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = {1'b0, defs_div_sqrt_mvp_C_MANT_NAN_FP64};
				Exp_res_norm_D = 1'sb1;
				Mant_forround_D = 1'sb0;
				Sign_res_D = 1'b0;
				NV_OP_S = 1'b1;
			end
			else if (Sqrt_enable_SI && Sign_in_DI) begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = {1'b0, defs_div_sqrt_mvp_C_MANT_NAN_FP64};
				Exp_res_norm_D = 1'sb1;
				Mant_forround_D = 1'sb0;
				Sign_res_D = 1'b0;
				NV_OP_S = 1'b1;
			end
			else begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b1;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_forround_D = 1'sb0;
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
		end
		else if (Div_enable_SI && Inf_b_SI) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b1;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb0;
			Mant_forround_D = 1'sb0;
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
		else if (Zero_a_SI) begin
			if (Div_enable_SI && Zero_b_SI) begin
				Div_Zero_S = 1'b1;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = {1'b0, defs_div_sqrt_mvp_C_MANT_NAN_FP64};
				Exp_res_norm_D = 1'sb1;
				Mant_forround_D = 1'sb0;
				Sign_res_D = 1'b0;
				NV_OP_S = 1'b1;
			end
			else begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb0;
				Mant_forround_D = 1'sb0;
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
		end
		else if (Div_enable_SI && Zero_b_SI) begin
			Div_Zero_S = 1'b1;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb1;
			Mant_forround_D = 1'sb0;
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
		else if (Sign_in_DI && Sqrt_enable_SI) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = {1'b0, defs_div_sqrt_mvp_C_MANT_NAN_FP64};
			Exp_res_norm_D = 1'sb1;
			Mant_forround_D = 1'sb0;
			Sign_res_D = 1'b0;
			NV_OP_S = 1'b1;
		end
		else if (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP64:0] == {12 {1'sb0}}) begin
			if (Mant_in_DI != {57 {1'sb0}}) begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b1;
				Mant_res_norm_D = {1'b0, Mant_in_DI[56:5]};
				Exp_res_norm_D = 1'sb0;
				Mant_forround_D = {Mant_in_DI[4:0], {defs_div_sqrt_mvp_C_MANT_FP64 {1'b0}}};
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
			else begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb0;
				Mant_forround_D = 1'sb0;
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
		end
		else if ((Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP64:0] == defs_div_sqrt_mvp_C_EXP_ONE_FP64) && ~Mant_in_DI[56]) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b1;
			Mant_res_norm_D = Mant_in_DI[56:4];
			Exp_res_norm_D = 1'sb0;
			Mant_forround_D = {Mant_in_DI[3:0], {53 {1'b0}}};
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
		else if (Exp_in_DI[12]) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b1;
			Mant_res_norm_D = {Mant_RS_D[defs_div_sqrt_mvp_C_MANT_FP64:0]};
			Exp_res_norm_D = 1'sb0;
			Mant_forround_D = {Mant_forsticky_D[56:0]};
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
		else if ((((Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP32] && FP32_SI) | (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP64] && FP64_SI)) | (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP16] && FP16_SI)) | (Exp_in_DI[defs_div_sqrt_mvp_C_EXP_FP16ALT] && FP16ALT_SI)) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b1;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb1;
			Mant_forround_D = 1'sb0;
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
		else if (((((Exp_in_DI[7:0] == {8 {1'sb1}}) && FP32_SI) | ((Exp_in_DI[10:0] == {11 {1'sb1}}) && FP64_SI)) | ((Exp_in_DI[4:0] == {5 {1'sb1}}) && FP16_SI)) | ((Exp_in_DI[7:0] == {8 {1'sb1}}) && FP16ALT_SI)) begin
			if (~Mant_in_DI[56]) begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b0;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = Mant_in_DI[55:3];
				Exp_res_norm_D = Exp_subOne_D;
				Mant_forround_D = {Mant_in_DI[2:0], {54 {1'b0}}};
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
			else if (Mant_in_DI != {57 {1'sb0}}) begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b1;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_forround_D = 1'sb0;
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
			else begin
				Div_Zero_S = 1'b0;
				Exp_OF_S = 1'b1;
				Exp_UF_S = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_forround_D = 1'sb0;
				Sign_res_D = Sign_in_DI;
				NV_OP_S = 1'b0;
			end
		end
		else if (Mant_in_DI[56]) begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = Mant_in_DI[56:4];
			Exp_res_norm_D = Exp_in_DI[10:0];
			Mant_forround_D = {Mant_in_DI[3:0], {53 {1'b0}}};
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
		else begin
			Div_Zero_S = 1'b0;
			Exp_OF_S = 1'b0;
			Exp_UF_S = 1'b0;
			Mant_res_norm_D = Mant_in_DI[55:3];
			Exp_res_norm_D = Exp_subOne_D;
			Mant_forround_D = {Mant_in_DI[2:0], {54 {1'b0}}};
			Sign_res_D = Sign_in_DI;
			NV_OP_S = 1'b0;
		end
	end
	reg [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_upper_D;
	wire [53:0] Mant_upperRounded_D;
	reg Mant_roundUp_S;
	wire Mant_rounded_S;
	always @(*) begin
		if (_sv2v_0)
			;
		if (FP32_SI) begin
			Mant_upper_D = {Mant_res_norm_D[defs_div_sqrt_mvp_C_MANT_FP64:29], {29 {1'b0}}};
			Mant_lower_D = Mant_res_norm_D[28:27];
			Mant_sticky_bit_D = |Mant_res_norm_D[26:0];
		end
		else if (FP64_SI) begin
			Mant_upper_D = Mant_res_norm_D[defs_div_sqrt_mvp_C_MANT_FP64:0];
			Mant_lower_D = Mant_forround_D[56:55];
			Mant_sticky_bit_D = |Mant_forround_D[55:0];
		end
		else if (FP16_SI) begin
			Mant_upper_D = {Mant_res_norm_D[defs_div_sqrt_mvp_C_MANT_FP64:42], {42 {1'b0}}};
			Mant_lower_D = Mant_res_norm_D[41:40];
			Mant_sticky_bit_D = |Mant_res_norm_D[39:30];
		end
		else begin
			Mant_upper_D = {Mant_res_norm_D[defs_div_sqrt_mvp_C_MANT_FP64:45], {45 {1'b0}}};
			Mant_lower_D = Mant_res_norm_D[44:43];
			Mant_sticky_bit_D = |Mant_res_norm_D[42:30];
		end
	end
	assign Mant_rounded_S = |Mant_lower_D | Mant_sticky_bit_D;
	localparam defs_div_sqrt_mvp_C_RM_MINUSINF = 3'h3;
	localparam defs_div_sqrt_mvp_C_RM_NEAREST = 3'h0;
	localparam defs_div_sqrt_mvp_C_RM_PLUSINF = 3'h2;
	localparam defs_div_sqrt_mvp_C_RM_TRUNC = 3'h1;
	always @(*) begin
		if (_sv2v_0)
			;
		Mant_roundUp_S = 1'b0;
		case (RM_SI)
			defs_div_sqrt_mvp_C_RM_NEAREST: Mant_roundUp_S = Mant_lower_D[1] && ((Mant_lower_D[0] | Mant_sticky_bit_D) | ((((FP32_SI && Mant_upper_D[29]) | (FP64_SI && Mant_upper_D[0])) | (FP16_SI && Mant_upper_D[42])) | (FP16ALT_SI && Mant_upper_D[45])));
			defs_div_sqrt_mvp_C_RM_TRUNC: Mant_roundUp_S = 0;
			defs_div_sqrt_mvp_C_RM_PLUSINF: Mant_roundUp_S = Mant_rounded_S & ~Sign_in_DI;
			defs_div_sqrt_mvp_C_RM_MINUSINF: Mant_roundUp_S = Mant_rounded_S & Sign_in_DI;
			default: Mant_roundUp_S = 0;
		endcase
	end
	wire Mant_renorm_S;
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_roundUp_Vector_S;
	assign Mant_roundUp_Vector_S = {7'h00, FP16ALT_SI && Mant_roundUp_S, 2'h0, FP16_SI && Mant_roundUp_S, 12'h000, FP32_SI && Mant_roundUp_S, 28'h0000000, FP64_SI && Mant_roundUp_S};
	assign Mant_upperRounded_D = Mant_upper_D + Mant_roundUp_Vector_S;
	assign Mant_renorm_S = Mant_upperRounded_D[53];
	wire [51:0] Mant_res_round_D;
	wire [10:0] Exp_res_round_D;
	assign Mant_res_round_D = (Mant_renorm_S ? Mant_upperRounded_D[defs_div_sqrt_mvp_C_MANT_FP64:1] : Mant_upperRounded_D[51:0]);
	assign Exp_res_round_D = Exp_res_norm_D + Mant_renorm_S;
	wire [51:0] Mant_before_format_ctl_D;
	wire [10:0] Exp_before_format_ctl_D;
	assign Mant_before_format_ctl_D = (Full_precision_SI ? Mant_res_round_D : Mant_res_norm_D);
	assign Exp_before_format_ctl_D = (Full_precision_SI ? Exp_res_round_D : Exp_res_norm_D);
	always @(*) begin
		if (_sv2v_0)
			;
		if (FP32_SI)
			Result_DO = {32'hffffffff, Sign_res_D, Exp_before_format_ctl_D[7:0], Mant_before_format_ctl_D[51:29]};
		else if (FP64_SI)
			Result_DO = {Sign_res_D, Exp_before_format_ctl_D[10:0], Mant_before_format_ctl_D[51:0]};
		else if (FP16_SI)
			Result_DO = {48'hffffffffffff, Sign_res_D, Exp_before_format_ctl_D[4:0], Mant_before_format_ctl_D[51:42]};
		else
			Result_DO = {48'hffffffffffff, Sign_res_D, Exp_before_format_ctl_D[7:0], Mant_before_format_ctl_D[51:45]};
	end
	assign In_Exact_S = ~Full_precision_SI | Mant_rounded_S;
	assign Fflags_SO = {NV_OP_S, Div_Zero_S, Exp_OF_S, Exp_UF_S, In_Exact_S};
	initial _sv2v_0 = 0;
endmodule
module nrbd_nrsc_mvp (
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Start_SI,
	Kill_SI,
	Special_case_SBI,
	Special_case_dly_SBI,
	Precision_ctl_SI,
	Format_sel_SI,
	Mant_a_DI,
	Mant_b_DI,
	Exp_a_DI,
	Exp_b_DI,
	Div_enable_SO,
	Sqrt_enable_SO,
	Full_precision_SO,
	FP32_SO,
	FP64_SO,
	FP16_SO,
	FP16ALT_SO,
	Ready_SO,
	Done_SO,
	Mant_z_DO,
	Exp_z_DO
);
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	input wire Start_SI;
	input wire Kill_SI;
	input wire Special_case_SBI;
	input wire Special_case_dly_SBI;
	localparam defs_div_sqrt_mvp_C_PC = 6;
	input wire [5:0] Precision_ctl_SI;
	input wire [1:0] Format_sel_SI;
	localparam defs_div_sqrt_mvp_C_MANT_FP64 = 52;
	input wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_a_DI;
	input wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_b_DI;
	localparam defs_div_sqrt_mvp_C_EXP_FP64 = 11;
	input wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_a_DI;
	input wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_b_DI;
	output wire Div_enable_SO;
	output wire Sqrt_enable_SO;
	output wire Full_precision_SO;
	output wire FP32_SO;
	output wire FP64_SO;
	output wire FP16_SO;
	output wire FP16ALT_SO;
	output wire Ready_SO;
	output wire Done_SO;
	output wire [56:0] Mant_z_DO;
	output wire [12:0] Exp_z_DO;
	wire Div_start_dly_S;
	wire Sqrt_start_dly_S;
	control_mvp control_U0(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Div_start_SI(Div_start_SI),
		.Sqrt_start_SI(Sqrt_start_SI),
		.Start_SI(Start_SI),
		.Kill_SI(Kill_SI),
		.Special_case_SBI(Special_case_SBI),
		.Special_case_dly_SBI(Special_case_dly_SBI),
		.Precision_ctl_SI(Precision_ctl_SI),
		.Format_sel_SI(Format_sel_SI),
		.Numerator_DI(Mant_a_DI),
		.Exp_num_DI(Exp_a_DI),
		.Denominator_DI(Mant_b_DI),
		.Exp_den_DI(Exp_b_DI),
		.Div_start_dly_SO(Div_start_dly_S),
		.Sqrt_start_dly_SO(Sqrt_start_dly_S),
		.Div_enable_SO(Div_enable_SO),
		.Sqrt_enable_SO(Sqrt_enable_SO),
		.Full_precision_SO(Full_precision_SO),
		.FP32_SO(FP32_SO),
		.FP64_SO(FP64_SO),
		.FP16_SO(FP16_SO),
		.FP16ALT_SO(FP16ALT_SO),
		.Ready_SO(Ready_SO),
		.Done_SO(Done_SO),
		.Mant_result_prenorm_DO(Mant_z_DO),
		.Exp_result_prenorm_DO(Exp_z_DO)
	);
endmodule
module div_sqrt_top_mvp (
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Operand_a_DI,
	Operand_b_DI,
	RM_SI,
	Precision_ctl_SI,
	Format_sel_SI,
	Kill_SI,
	Result_DO,
	Fflags_SO,
	Ready_SO,
	Done_SO
);
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	localparam defs_div_sqrt_mvp_C_OP_FP64 = 64;
	input wire [63:0] Operand_a_DI;
	input wire [63:0] Operand_b_DI;
	localparam defs_div_sqrt_mvp_C_RM = 3;
	input wire [2:0] RM_SI;
	localparam defs_div_sqrt_mvp_C_PC = 6;
	input wire [5:0] Precision_ctl_SI;
	localparam defs_div_sqrt_mvp_C_FS = 2;
	input wire [1:0] Format_sel_SI;
	input wire Kill_SI;
	output wire [63:0] Result_DO;
	output wire [4:0] Fflags_SO;
	output wire Ready_SO;
	output wire Done_SO;
	localparam defs_div_sqrt_mvp_C_EXP_FP64 = 11;
	wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_a_D;
	wire [defs_div_sqrt_mvp_C_EXP_FP64:0] Exp_b_D;
	localparam defs_div_sqrt_mvp_C_MANT_FP64 = 52;
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_a_D;
	wire [defs_div_sqrt_mvp_C_MANT_FP64:0] Mant_b_D;
	wire [12:0] Exp_z_D;
	wire [56:0] Mant_z_D;
	wire Sign_z_D;
	wire Start_S;
	wire [2:0] RM_dly_S;
	wire Div_enable_S;
	wire Sqrt_enable_S;
	wire Inf_a_S;
	wire Inf_b_S;
	wire Zero_a_S;
	wire Zero_b_S;
	wire NaN_a_S;
	wire NaN_b_S;
	wire SNaN_S;
	wire Special_case_SB;
	wire Special_case_dly_SB;
	wire Full_precision_S;
	wire FP32_S;
	wire FP64_S;
	wire FP16_S;
	wire FP16ALT_S;
	preprocess_mvp preprocess_U0(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Div_start_SI(Div_start_SI),
		.Sqrt_start_SI(Sqrt_start_SI),
		.Ready_SI(Ready_SO),
		.Operand_a_DI(Operand_a_DI),
		.Operand_b_DI(Operand_b_DI),
		.RM_SI(RM_SI),
		.Format_sel_SI(Format_sel_SI),
		.Start_SO(Start_S),
		.Exp_a_DO_norm(Exp_a_D),
		.Exp_b_DO_norm(Exp_b_D),
		.Mant_a_DO_norm(Mant_a_D),
		.Mant_b_DO_norm(Mant_b_D),
		.RM_dly_SO(RM_dly_S),
		.Sign_z_DO(Sign_z_D),
		.Inf_a_SO(Inf_a_S),
		.Inf_b_SO(Inf_b_S),
		.Zero_a_SO(Zero_a_S),
		.Zero_b_SO(Zero_b_S),
		.NaN_a_SO(NaN_a_S),
		.NaN_b_SO(NaN_b_S),
		.SNaN_SO(SNaN_S),
		.Special_case_SBO(Special_case_SB),
		.Special_case_dly_SBO(Special_case_dly_SB)
	);
	nrbd_nrsc_mvp nrbd_nrsc_U0(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Div_start_SI(Div_start_SI),
		.Sqrt_start_SI(Sqrt_start_SI),
		.Start_SI(Start_S),
		.Kill_SI(Kill_SI),
		.Special_case_SBI(Special_case_SB),
		.Special_case_dly_SBI(Special_case_dly_SB),
		.Div_enable_SO(Div_enable_S),
		.Sqrt_enable_SO(Sqrt_enable_S),
		.Precision_ctl_SI(Precision_ctl_SI),
		.Format_sel_SI(Format_sel_SI),
		.Exp_a_DI(Exp_a_D),
		.Exp_b_DI(Exp_b_D),
		.Mant_a_DI(Mant_a_D),
		.Mant_b_DI(Mant_b_D),
		.Full_precision_SO(Full_precision_S),
		.FP32_SO(FP32_S),
		.FP64_SO(FP64_S),
		.FP16_SO(FP16_S),
		.FP16ALT_SO(FP16ALT_S),
		.Ready_SO(Ready_SO),
		.Done_SO(Done_SO),
		.Exp_z_DO(Exp_z_D),
		.Mant_z_DO(Mant_z_D)
	);
	norm_div_sqrt_mvp fpu_norm_U0(
		.Mant_in_DI(Mant_z_D),
		.Exp_in_DI(Exp_z_D),
		.Sign_in_DI(Sign_z_D),
		.Div_enable_SI(Div_enable_S),
		.Sqrt_enable_SI(Sqrt_enable_S),
		.Inf_a_SI(Inf_a_S),
		.Inf_b_SI(Inf_b_S),
		.Zero_a_SI(Zero_a_S),
		.Zero_b_SI(Zero_b_S),
		.NaN_a_SI(NaN_a_S),
		.NaN_b_SI(NaN_b_S),
		.SNaN_SI(SNaN_S),
		.RM_SI(RM_dly_S),
		.Full_precision_SI(Full_precision_S),
		.FP32_SI(FP32_S),
		.FP64_SI(FP64_S),
		.FP16_SI(FP16_S),
		.FP16ALT_SI(FP16ALT_S),
		.Result_DO(Result_DO),
		.Fflags_SO(Fflags_SO)
	);
endmodule
module lzc (
	in_i,
	cnt_o,
	empty_o
);
	reg _sv2v_0;
	parameter [31:0] WIDTH = 2;
	parameter [0:0] MODE = 1'b0;
	function automatic [31:0] cf_math_pkg_idx_width;
		input reg [31:0] num_idx;
		cf_math_pkg_idx_width = (num_idx > 32'd1 ? $unsigned($clog2(num_idx)) : 32'd1);
	endfunction
	parameter [31:0] CNT_WIDTH = cf_math_pkg_idx_width(WIDTH);
	input wire [WIDTH - 1:0] in_i;
	output wire [CNT_WIDTH - 1:0] cnt_o;
	output wire empty_o;
	generate
		if (WIDTH == 1) begin : gen_degenerate_lzc
			assign cnt_o[0] = !in_i[0];
			assign empty_o = !in_i[0];
		end
		else begin : gen_lzc
			localparam [31:0] NumLevels = $clog2(WIDTH);
			wire [(WIDTH * NumLevels) - 1:0] index_lut;
			wire [(2 ** NumLevels) - 1:0] sel_nodes;
			wire [((2 ** NumLevels) * NumLevels) - 1:0] index_nodes;
			reg [WIDTH - 1:0] in_tmp;
			always @(*) begin : flip_vector
				if (_sv2v_0)
					;
				begin : sv2v_autoblock_1
					reg [31:0] i;
					for (i = 0; i < WIDTH; i = i + 1)
						in_tmp[i] = (MODE ? in_i[(WIDTH - 1) - i] : in_i[i]);
				end
			end
			genvar _gv_j_2;
			for (_gv_j_2 = 0; $unsigned(_gv_j_2) < WIDTH; _gv_j_2 = _gv_j_2 + 1) begin : g_index_lut
				localparam j = _gv_j_2;
				function automatic [NumLevels - 1:0] sv2v_cast_CD1FF;
					input reg [NumLevels - 1:0] inp;
					sv2v_cast_CD1FF = inp;
				endfunction
				assign index_lut[j * NumLevels+:NumLevels] = sv2v_cast_CD1FF($unsigned(j));
			end
			genvar _gv_level_1;
			for (_gv_level_1 = 0; $unsigned(_gv_level_1) < NumLevels; _gv_level_1 = _gv_level_1 + 1) begin : g_levels
				localparam level = _gv_level_1;
				if ($unsigned(level) == (NumLevels - 1)) begin : g_last_level
					genvar _gv_k_1;
					for (_gv_k_1 = 0; _gv_k_1 < (2 ** level); _gv_k_1 = _gv_k_1 + 1) begin : g_level
						localparam k = _gv_k_1;
						if (($unsigned(k) * 2) < (WIDTH - 1)) begin : g_reduce
							assign sel_nodes[((2 ** level) - 1) + k] = in_tmp[k * 2] | in_tmp[(k * 2) + 1];
							assign index_nodes[(((2 ** level) - 1) + k) * NumLevels+:NumLevels] = (in_tmp[k * 2] == 1'b1 ? index_lut[(k * 2) * NumLevels+:NumLevels] : index_lut[((k * 2) + 1) * NumLevels+:NumLevels]);
						end
						if (($unsigned(k) * 2) == (WIDTH - 1)) begin : g_base
							assign sel_nodes[((2 ** level) - 1) + k] = in_tmp[k * 2];
							assign index_nodes[(((2 ** level) - 1) + k) * NumLevels+:NumLevels] = index_lut[(k * 2) * NumLevels+:NumLevels];
						end
						if (($unsigned(k) * 2) > (WIDTH - 1)) begin : g_out_of_range
							assign sel_nodes[((2 ** level) - 1) + k] = 1'b0;
							assign index_nodes[(((2 ** level) - 1) + k) * NumLevels+:NumLevels] = 1'sb0;
						end
					end
				end
				else begin : g_not_last_level
					genvar _gv_l_1;
					for (_gv_l_1 = 0; _gv_l_1 < (2 ** level); _gv_l_1 = _gv_l_1 + 1) begin : g_level
						localparam l = _gv_l_1;
						assign sel_nodes[((2 ** level) - 1) + l] = sel_nodes[((2 ** (level + 1)) - 1) + (l * 2)] | sel_nodes[(((2 ** (level + 1)) - 1) + (l * 2)) + 1];
						assign index_nodes[(((2 ** level) - 1) + l) * NumLevels+:NumLevels] = (sel_nodes[((2 ** (level + 1)) - 1) + (l * 2)] == 1'b1 ? index_nodes[(((2 ** (level + 1)) - 1) + (l * 2)) * NumLevels+:NumLevels] : index_nodes[((((2 ** (level + 1)) - 1) + (l * 2)) + 1) * NumLevels+:NumLevels]);
					end
				end
			end
			assign cnt_o = (NumLevels > $unsigned(0) ? index_nodes[0+:NumLevels] : {$clog2(WIDTH) {1'b0}});
			assign empty_o = (NumLevels > $unsigned(0) ? ~sel_nodes[0] : ~(|in_i));
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
module rr_arb_tree_664D9_329E6 (
	clk_i,
	rst_ni,
	flush_i,
	rr_i,
	req_i,
	gnt_o,
	data_i,
	req_o,
	gnt_i,
	data_o,
	idx_o
);
	parameter [31:0] DataType_Width = 0;
	parameter [31:0] NumIn = 64;
	parameter [31:0] DataWidth = 32;
	parameter [0:0] ExtPrio = 1'b0;
	parameter [0:0] AxiVldRdy = 1'b0;
	parameter [0:0] LockIn = 1'b0;
	parameter [0:0] FairArb = 1'b1;
	parameter [31:0] IdxWidth = (NumIn > 32'd1 ? $unsigned($clog2(NumIn)) : 32'd1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire [IdxWidth - 1:0] rr_i;
	input wire [NumIn - 1:0] req_i;
	output wire [NumIn - 1:0] gnt_o;
	input wire [((DataType_Width + 15) >= 0 ? (NumIn * (DataType_Width + 16)) - 1 : (NumIn * (1 - (DataType_Width + 15))) + (DataType_Width + 14)):((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15)] data_i;
	output wire req_o;
	input wire gnt_i;
	output wire [DataType_Width + 15:0] data_o;
	output wire [IdxWidth - 1:0] idx_o;
	function automatic [IdxWidth - 1:0] sv2v_cast_BCC4E;
		input reg [IdxWidth - 1:0] inp;
		sv2v_cast_BCC4E = inp;
	endfunction
	function automatic [((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)) - 1:0] sv2v_cast_414AF;
		input reg [((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)) - 1:0] inp;
		sv2v_cast_414AF = inp;
	endfunction
	generate
		if (NumIn == $unsigned(1)) begin : gen_pass_through
			assign req_o = req_i[0];
			assign gnt_o[0] = gnt_i;
			assign data_o = data_i[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + 0+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))];
			assign idx_o = 1'sb0;
		end
		else begin : gen_arbiter
			localparam [31:0] NumLevels = $unsigned($clog2(NumIn));
			wire [(((2 ** NumLevels) - 2) >= 0 ? (((2 ** NumLevels) - 1) * IdxWidth) - 1 : ((3 - (2 ** NumLevels)) * IdxWidth) + ((((2 ** NumLevels) - 2) * IdxWidth) - 1)):(((2 ** NumLevels) - 2) >= 0 ? 0 : ((2 ** NumLevels) - 2) * IdxWidth)] index_nodes;
			wire [(((2 ** NumLevels) - 2) >= 0 ? ((DataType_Width + 15) >= 0 ? (((2 ** NumLevels) - 1) * (DataType_Width + 16)) - 1 : (((2 ** NumLevels) - 1) * (1 - (DataType_Width + 15))) + (DataType_Width + 14)) : ((DataType_Width + 15) >= 0 ? ((3 - (2 ** NumLevels)) * (DataType_Width + 16)) + ((((2 ** NumLevels) - 2) * (DataType_Width + 16)) - 1) : ((3 - (2 ** NumLevels)) * (1 - (DataType_Width + 15))) + (((DataType_Width + 15) + (((2 ** NumLevels) - 2) * (1 - (DataType_Width + 15)))) - 1))):(((2 ** NumLevels) - 2) >= 0 ? ((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) : ((DataType_Width + 15) >= 0 ? ((2 ** NumLevels) - 2) * (DataType_Width + 16) : (DataType_Width + 15) + (((2 ** NumLevels) - 2) * (1 - (DataType_Width + 15)))))] data_nodes;
			wire [(2 ** NumLevels) - 2:0] gnt_nodes;
			wire [(2 ** NumLevels) - 2:0] req_nodes;
			reg [IdxWidth - 1:0] rr_q;
			wire [NumIn - 1:0] req_d;
			assign req_o = req_nodes[0];
			assign data_o = data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? 0 : (2 ** NumLevels) - 2) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))];
			assign idx_o = index_nodes[(((2 ** NumLevels) - 2) >= 0 ? 0 : (2 ** NumLevels) - 2) * IdxWidth+:IdxWidth];
			if (ExtPrio) begin : gen_ext_rr
				wire [IdxWidth:1] sv2v_tmp_B41BF;
				assign sv2v_tmp_B41BF = rr_i;
				always @(*) rr_q = sv2v_tmp_B41BF;
				assign req_d = req_i;
			end
			else begin : gen_int_rr
				wire [IdxWidth - 1:0] rr_d;
				if (LockIn) begin : gen_lock
					wire lock_d;
					reg lock_q;
					reg [NumIn - 1:0] req_q;
					assign lock_d = req_o & ~gnt_i;
					assign req_d = (lock_q ? req_q : req_i);
					always @(posedge clk_i or negedge rst_ni) begin : p_lock_reg
						if (!rst_ni)
							lock_q <= 1'sb0;
						else if (flush_i)
							lock_q <= 1'sb0;
						else
							lock_q <= lock_d;
					end
					always @(posedge clk_i or negedge rst_ni) begin : p_req_regs
						if (!rst_ni)
							req_q <= 1'sb0;
						else if (flush_i)
							req_q <= 1'sb0;
						else
							req_q <= req_d;
					end
				end
				else begin : gen_no_lock
					assign req_d = req_i;
				end
				if (FairArb) begin : gen_fair_arb
					wire [NumIn - 1:0] upper_mask;
					wire [NumIn - 1:0] lower_mask;
					wire [IdxWidth - 1:0] upper_idx;
					wire [IdxWidth - 1:0] lower_idx;
					wire [IdxWidth - 1:0] next_idx;
					wire upper_empty;
					wire lower_empty;
					genvar _gv_i_18;
					for (_gv_i_18 = 0; _gv_i_18 < NumIn; _gv_i_18 = _gv_i_18 + 1) begin : gen_mask
						localparam i = _gv_i_18;
						assign upper_mask[i] = (i > rr_q ? req_d[i] : 1'b0);
						assign lower_mask[i] = (i <= rr_q ? req_d[i] : 1'b0);
					end
					lzc #(
						.WIDTH(NumIn),
						.MODE(1'b0)
					) i_lzc_upper(
						.in_i(upper_mask),
						.cnt_o(upper_idx),
						.empty_o(upper_empty)
					);
					lzc #(
						.WIDTH(NumIn),
						.MODE(1'b0)
					) i_lzc_lower(
						.in_i(lower_mask),
						.cnt_o(lower_idx),
						.empty_o()
					);
					assign next_idx = (upper_empty ? lower_idx : upper_idx);
					assign rr_d = (gnt_i && req_o ? next_idx : rr_q);
				end
				else begin : gen_unfair_arb
					assign rr_d = (gnt_i && req_o ? (rr_q == sv2v_cast_BCC4E(NumIn - 1) ? {IdxWidth {1'sb0}} : rr_q + 1'b1) : rr_q);
				end
				always @(posedge clk_i or negedge rst_ni) begin : p_rr_regs
					if (!rst_ni)
						rr_q <= 1'sb0;
					else if (flush_i)
						rr_q <= 1'sb0;
					else
						rr_q <= rr_d;
				end
			end
			assign gnt_nodes[0] = gnt_i;
			genvar _gv_level_2;
			for (_gv_level_2 = 0; $unsigned(_gv_level_2) < NumLevels; _gv_level_2 = _gv_level_2 + 1) begin : gen_levels
				localparam level = _gv_level_2;
				genvar _gv_l_2;
				for (_gv_l_2 = 0; _gv_l_2 < (2 ** level); _gv_l_2 = _gv_l_2 + 1) begin : gen_level
					localparam l = _gv_l_2;
					wire sel;
					localparam [31:0] Idx0 = ((2 ** level) - 1) + l;
					localparam [31:0] Idx1 = ((2 ** (level + 1)) - 1) + (l * 2);
					if ($unsigned(level) == (NumLevels - 1)) begin : gen_first_level
						if (($unsigned(l) * 2) < (NumIn - 1)) begin : gen_reduce
							assign req_nodes[Idx0] = req_d[l * 2] | req_d[(l * 2) + 1];
							assign sel = ~req_d[l * 2] | (req_d[(l * 2) + 1] & rr_q[(NumLevels - 1) - level]);
							assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = sv2v_cast_BCC4E(sel);
							assign data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))] = (sel ? data_i[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + (((l * 2) + 1) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))] : data_i[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((l * 2) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))]);
							assign gnt_o[l * 2] = (gnt_nodes[Idx0] & (AxiVldRdy | req_d[l * 2])) & ~sel;
							assign gnt_o[(l * 2) + 1] = (gnt_nodes[Idx0] & (AxiVldRdy | req_d[(l * 2) + 1])) & sel;
						end
						if (($unsigned(l) * 2) == (NumIn - 1)) begin : gen_first
							assign req_nodes[Idx0] = req_d[l * 2];
							assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = 1'sb0;
							assign data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))] = data_i[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((l * 2) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))];
							assign gnt_o[l * 2] = gnt_nodes[Idx0] & (AxiVldRdy | req_d[l * 2]);
						end
						if (($unsigned(l) * 2) > (NumIn - 1)) begin : gen_out_of_range
							assign req_nodes[Idx0] = 1'b0;
							assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = sv2v_cast_BCC4E(1'sb0);
							assign data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))] = sv2v_cast_414AF(1'sb0);
						end
					end
					else begin : gen_other_levels
						assign req_nodes[Idx0] = req_nodes[Idx1] | req_nodes[Idx1 + 1];
						assign sel = ~req_nodes[Idx1] | (req_nodes[Idx1 + 1] & rr_q[(NumLevels - 1) - level]);
						assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = (sel ? sv2v_cast_BCC4E({1'b1, index_nodes[((((2 ** NumLevels) - 2) >= 0 ? Idx1 + 1 : ((2 ** NumLevels) - 2) - (Idx1 + 1)) * IdxWidth) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 2 : (((NumLevels - $unsigned(level)) - 2) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))) - 1)-:(((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))]}) : sv2v_cast_BCC4E({1'b0, index_nodes[((((2 ** NumLevels) - 2) >= 0 ? Idx1 : ((2 ** NumLevels) - 2) - Idx1) * IdxWidth) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 2 : (((NumLevels - $unsigned(level)) - 2) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))) - 1)-:(((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))]}));
						assign data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))] = (sel ? data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? Idx1 + 1 : ((2 ** NumLevels) - 2) - (Idx1 + 1)) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))] : data_nodes[((DataType_Width + 15) >= 0 ? 0 : DataType_Width + 15) + ((((2 ** NumLevels) - 2) >= 0 ? Idx1 : ((2 ** NumLevels) - 2) - Idx1) * ((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15)))+:((DataType_Width + 15) >= 0 ? DataType_Width + 16 : 1 - (DataType_Width + 15))]);
						assign gnt_nodes[Idx1] = gnt_nodes[Idx0] & ~sel;
						assign gnt_nodes[Idx1 + 1] = gnt_nodes[Idx0] & sel;
					end
				end
			end
		end
	endgenerate
endmodule
module rr_arb_tree_E7A03_DC67B (
	clk_i,
	rst_ni,
	flush_i,
	rr_i,
	req_i,
	gnt_o,
	data_i,
	req_o,
	gnt_i,
	data_o,
	idx_o
);
	parameter [31:0] DataType_WIDTH = 0;
	parameter [31:0] NumIn = 64;
	parameter [31:0] DataWidth = 32;
	parameter [0:0] ExtPrio = 1'b0;
	parameter [0:0] AxiVldRdy = 1'b0;
	parameter [0:0] LockIn = 1'b0;
	parameter [0:0] FairArb = 1'b1;
	parameter [31:0] IdxWidth = (NumIn > 32'd1 ? $unsigned($clog2(NumIn)) : 32'd1);
	input wire clk_i;
	input wire rst_ni;
	input wire flush_i;
	input wire [IdxWidth - 1:0] rr_i;
	input wire [NumIn - 1:0] req_i;
	output wire [NumIn - 1:0] gnt_o;
	input wire [((DataType_WIDTH + 14) >= 0 ? (NumIn * (DataType_WIDTH + 15)) - 1 : (NumIn * (1 - (DataType_WIDTH + 14))) + (DataType_WIDTH + 13)):((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14)] data_i;
	output wire req_o;
	input wire gnt_i;
	output wire [DataType_WIDTH + 14:0] data_o;
	output wire [IdxWidth - 1:0] idx_o;
	function automatic [IdxWidth - 1:0] sv2v_cast_BCC4E;
		input reg [IdxWidth - 1:0] inp;
		sv2v_cast_BCC4E = inp;
	endfunction
	function automatic [((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)) - 1:0] sv2v_cast_F835E;
		input reg [((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)) - 1:0] inp;
		sv2v_cast_F835E = inp;
	endfunction
	generate
		if (NumIn == $unsigned(1)) begin : gen_pass_through
			assign req_o = req_i[0];
			assign gnt_o[0] = gnt_i;
			assign data_o = data_i[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + 0+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))];
			assign idx_o = 1'sb0;
		end
		else begin : gen_arbiter
			localparam [31:0] NumLevels = $unsigned($clog2(NumIn));
			wire [(((2 ** NumLevels) - 2) >= 0 ? (((2 ** NumLevels) - 1) * IdxWidth) - 1 : ((3 - (2 ** NumLevels)) * IdxWidth) + ((((2 ** NumLevels) - 2) * IdxWidth) - 1)):(((2 ** NumLevels) - 2) >= 0 ? 0 : ((2 ** NumLevels) - 2) * IdxWidth)] index_nodes;
			wire [(((2 ** NumLevels) - 2) >= 0 ? ((DataType_WIDTH + 14) >= 0 ? (((2 ** NumLevels) - 1) * (DataType_WIDTH + 15)) - 1 : (((2 ** NumLevels) - 1) * (1 - (DataType_WIDTH + 14))) + (DataType_WIDTH + 13)) : ((DataType_WIDTH + 14) >= 0 ? ((3 - (2 ** NumLevels)) * (DataType_WIDTH + 15)) + ((((2 ** NumLevels) - 2) * (DataType_WIDTH + 15)) - 1) : ((3 - (2 ** NumLevels)) * (1 - (DataType_WIDTH + 14))) + (((DataType_WIDTH + 14) + (((2 ** NumLevels) - 2) * (1 - (DataType_WIDTH + 14)))) - 1))):(((2 ** NumLevels) - 2) >= 0 ? ((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) : ((DataType_WIDTH + 14) >= 0 ? ((2 ** NumLevels) - 2) * (DataType_WIDTH + 15) : (DataType_WIDTH + 14) + (((2 ** NumLevels) - 2) * (1 - (DataType_WIDTH + 14)))))] data_nodes;
			wire [(2 ** NumLevels) - 2:0] gnt_nodes;
			wire [(2 ** NumLevels) - 2:0] req_nodes;
			reg [IdxWidth - 1:0] rr_q;
			wire [NumIn - 1:0] req_d;
			assign req_o = req_nodes[0];
			assign data_o = data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? 0 : (2 ** NumLevels) - 2) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))];
			assign idx_o = index_nodes[(((2 ** NumLevels) - 2) >= 0 ? 0 : (2 ** NumLevels) - 2) * IdxWidth+:IdxWidth];
			if (ExtPrio) begin : gen_ext_rr
				wire [IdxWidth:1] sv2v_tmp_B41BF;
				assign sv2v_tmp_B41BF = rr_i;
				always @(*) rr_q = sv2v_tmp_B41BF;
				assign req_d = req_i;
			end
			else begin : gen_int_rr
				wire [IdxWidth - 1:0] rr_d;
				if (LockIn) begin : gen_lock
					wire lock_d;
					reg lock_q;
					reg [NumIn - 1:0] req_q;
					assign lock_d = req_o & ~gnt_i;
					assign req_d = (lock_q ? req_q : req_i);
					always @(posedge clk_i or negedge rst_ni) begin : p_lock_reg
						if (!rst_ni)
							lock_q <= 1'sb0;
						else if (flush_i)
							lock_q <= 1'sb0;
						else
							lock_q <= lock_d;
					end
					always @(posedge clk_i or negedge rst_ni) begin : p_req_regs
						if (!rst_ni)
							req_q <= 1'sb0;
						else if (flush_i)
							req_q <= 1'sb0;
						else
							req_q <= req_d;
					end
				end
				else begin : gen_no_lock
					assign req_d = req_i;
				end
				if (FairArb) begin : gen_fair_arb
					wire [NumIn - 1:0] upper_mask;
					wire [NumIn - 1:0] lower_mask;
					wire [IdxWidth - 1:0] upper_idx;
					wire [IdxWidth - 1:0] lower_idx;
					wire [IdxWidth - 1:0] next_idx;
					wire upper_empty;
					wire lower_empty;
					genvar _gv_i_18;
					for (_gv_i_18 = 0; _gv_i_18 < NumIn; _gv_i_18 = _gv_i_18 + 1) begin : gen_mask
						localparam i = _gv_i_18;
						assign upper_mask[i] = (i > rr_q ? req_d[i] : 1'b0);
						assign lower_mask[i] = (i <= rr_q ? req_d[i] : 1'b0);
					end
					lzc #(
						.WIDTH(NumIn),
						.MODE(1'b0)
					) i_lzc_upper(
						.in_i(upper_mask),
						.cnt_o(upper_idx),
						.empty_o(upper_empty)
					);
					lzc #(
						.WIDTH(NumIn),
						.MODE(1'b0)
					) i_lzc_lower(
						.in_i(lower_mask),
						.cnt_o(lower_idx),
						.empty_o()
					);
					assign next_idx = (upper_empty ? lower_idx : upper_idx);
					assign rr_d = (gnt_i && req_o ? next_idx : rr_q);
				end
				else begin : gen_unfair_arb
					assign rr_d = (gnt_i && req_o ? (rr_q == sv2v_cast_BCC4E(NumIn - 1) ? {IdxWidth {1'sb0}} : rr_q + 1'b1) : rr_q);
				end
				always @(posedge clk_i or negedge rst_ni) begin : p_rr_regs
					if (!rst_ni)
						rr_q <= 1'sb0;
					else if (flush_i)
						rr_q <= 1'sb0;
					else
						rr_q <= rr_d;
				end
			end
			assign gnt_nodes[0] = gnt_i;
			genvar _gv_level_2;
			for (_gv_level_2 = 0; $unsigned(_gv_level_2) < NumLevels; _gv_level_2 = _gv_level_2 + 1) begin : gen_levels
				localparam level = _gv_level_2;
				genvar _gv_l_2;
				for (_gv_l_2 = 0; _gv_l_2 < (2 ** level); _gv_l_2 = _gv_l_2 + 1) begin : gen_level
					localparam l = _gv_l_2;
					wire sel;
					localparam [31:0] Idx0 = ((2 ** level) - 1) + l;
					localparam [31:0] Idx1 = ((2 ** (level + 1)) - 1) + (l * 2);
					if ($unsigned(level) == (NumLevels - 1)) begin : gen_first_level
						if (($unsigned(l) * 2) < (NumIn - 1)) begin : gen_reduce
							assign req_nodes[Idx0] = req_d[l * 2] | req_d[(l * 2) + 1];
							assign sel = ~req_d[l * 2] | (req_d[(l * 2) + 1] & rr_q[(NumLevels - 1) - level]);
							assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = sv2v_cast_BCC4E(sel);
							assign data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))] = (sel ? data_i[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + (((l * 2) + 1) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))] : data_i[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((l * 2) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))]);
							assign gnt_o[l * 2] = (gnt_nodes[Idx0] & (AxiVldRdy | req_d[l * 2])) & ~sel;
							assign gnt_o[(l * 2) + 1] = (gnt_nodes[Idx0] & (AxiVldRdy | req_d[(l * 2) + 1])) & sel;
						end
						if (($unsigned(l) * 2) == (NumIn - 1)) begin : gen_first
							assign req_nodes[Idx0] = req_d[l * 2];
							assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = 1'sb0;
							assign data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))] = data_i[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((l * 2) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))];
							assign gnt_o[l * 2] = gnt_nodes[Idx0] & (AxiVldRdy | req_d[l * 2]);
						end
						if (($unsigned(l) * 2) > (NumIn - 1)) begin : gen_out_of_range
							assign req_nodes[Idx0] = 1'b0;
							assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = sv2v_cast_BCC4E(1'sb0);
							assign data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))] = sv2v_cast_F835E(1'sb0);
						end
					end
					else begin : gen_other_levels
						assign req_nodes[Idx0] = req_nodes[Idx1] | req_nodes[Idx1 + 1];
						assign sel = ~req_nodes[Idx1] | (req_nodes[Idx1 + 1] & rr_q[(NumLevels - 1) - level]);
						assign index_nodes[(((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * IdxWidth+:IdxWidth] = (sel ? sv2v_cast_BCC4E({1'b1, index_nodes[((((2 ** NumLevels) - 2) >= 0 ? Idx1 + 1 : ((2 ** NumLevels) - 2) - (Idx1 + 1)) * IdxWidth) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 2 : (((NumLevels - $unsigned(level)) - 2) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))) - 1)-:(((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))]}) : sv2v_cast_BCC4E({1'b0, index_nodes[((((2 ** NumLevels) - 2) >= 0 ? Idx1 : ((2 ** NumLevels) - 2) - Idx1) * IdxWidth) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 2 : (((NumLevels - $unsigned(level)) - 2) + (((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))) - 1)-:(((NumLevels - $unsigned(level)) - 2) >= 0 ? (NumLevels - $unsigned(level)) - 1 : 3 - (NumLevels - $unsigned(level)))]}));
						assign data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? Idx0 : ((2 ** NumLevels) - 2) - Idx0) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))] = (sel ? data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? Idx1 + 1 : ((2 ** NumLevels) - 2) - (Idx1 + 1)) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))] : data_nodes[((DataType_WIDTH + 14) >= 0 ? 0 : DataType_WIDTH + 14) + ((((2 ** NumLevels) - 2) >= 0 ? Idx1 : ((2 ** NumLevels) - 2) - Idx1) * ((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14)))+:((DataType_WIDTH + 14) >= 0 ? DataType_WIDTH + 15 : 1 - (DataType_WIDTH + 14))]);
						assign gnt_nodes[Idx1] = gnt_nodes[Idx0] & ~sel;
						assign gnt_nodes[Idx1 + 1] = gnt_nodes[Idx0] & sel;
					end
				end
			end
		end
	endgenerate
endmodule
module fpu_ss_compressed_predecoder (
	prd_req_i,
	prd_rsp_o
);
	reg _sv2v_0;
	input wire [15:0] prd_req_i;
	output reg [32:0] prd_rsp_o;
	localparam [15:0] fpu_ss_instr_pkg_C_FLW = 16'b011zzzzzzzzzzz00;
	localparam [15:0] fpu_ss_instr_pkg_C_FLWSP = 16'b011zzzzzzzzzzz10;
	localparam [15:0] fpu_ss_instr_pkg_C_FSW = 16'b111zzzzzzzzzzz00;
	localparam [15:0] fpu_ss_instr_pkg_C_FSWSP = 16'b111zzzzzzzzzzz10;
	always @(*) begin
		if (_sv2v_0)
			;
		prd_rsp_o[32] = 1'b0;
		prd_rsp_o[31-:32] = 1'sb0;
		(* full_case, parallel_case *)
		casez (prd_req_i[15-:16])
			fpu_ss_instr_pkg_C_FLW: begin
				prd_rsp_o[32] = 1'b1;
				prd_rsp_o[31-:32] = {5'b00000, prd_req_i[5], prd_req_i[12:10], prd_req_i[6], 4'b0001, prd_req_i[9:7], 5'b01001, prd_req_i[4:2], 7'b0000111};
			end
			fpu_ss_instr_pkg_C_FLWSP: begin
				prd_rsp_o[32] = 1'b1;
				prd_rsp_o[31-:32] = {4'b0000, prd_req_i[3:2], prd_req_i[12], prd_req_i[6:4], 10'h012, prd_req_i[11:7], 7'b0000111};
			end
			fpu_ss_instr_pkg_C_FSW: begin
				prd_rsp_o[32] = 1'b1;
				prd_rsp_o[31-:32] = {5'b00000, prd_req_i[5], prd_req_i[12], 2'b01, prd_req_i[4:2], 2'b01, prd_req_i[9:7], 3'b010, prd_req_i[11:10], prd_req_i[6], 9'b000100111};
			end
			fpu_ss_instr_pkg_C_FSWSP: begin
				prd_rsp_o[32] = 1'b1;
				prd_rsp_o[31-:32] = {4'b0000, prd_req_i[8:7], prd_req_i[12], prd_req_i[6:2], 8'h12, prd_req_i[11:9], 9'b000100111};
			end
			default: begin
				prd_rsp_o[32] = 1'b0;
				prd_rsp_o[31-:32] = 1'sb0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module fpu_ss_predecoder (
	prd_req_i,
	prd_rsp_o
);
	reg _sv2v_0;
	parameter signed [31:0] NumInstr = 1;
	parameter [(NumInstr * 70) - 1:0] OffloadInstr = 'd0;
	input wire [31:0] prd_req_i;
	output reg [5:0] prd_rsp_o;
	wire [(NumInstr * 6) - 1:0] instr_rsp;
	wire [NumInstr - 1:0] instr_sel;
	genvar _gv_i_19;
	generate
		for (_gv_i_19 = 0; _gv_i_19 < NumInstr; _gv_i_19 = _gv_i_19 + 1) begin : gen_predecoder_selector
			localparam i = _gv_i_19;
			assign instr_sel[i] = (OffloadInstr[(((NumInstr - 1) - i) * 70) + 37-:32] & prd_req_i[31-:32]) == OffloadInstr[(((NumInstr - 1) - i) * 70) + 69-:32];
		end
	endgenerate
	genvar _gv_i_20;
	generate
		for (_gv_i_20 = 0; _gv_i_20 < NumInstr; _gv_i_20 = _gv_i_20 + 1) begin : gen_predecoder_mux
			localparam i = _gv_i_20;
			assign instr_rsp[(i * 6) + 5] = (instr_sel[i] ? OffloadInstr[(((NumInstr - 1) - i) * 70) + 5] : 1'b0);
			assign instr_rsp[(i * 6) + 3] = (instr_sel[i] ? OffloadInstr[(((NumInstr - 1) - i) * 70) + 3] : 1'b0);
			assign instr_rsp[(i * 6) + 4] = (instr_sel[i] ? OffloadInstr[(((NumInstr - 1) - i) * 70) + 4] : 1'b0);
			assign instr_rsp[(i * 6) + 2-:3] = (instr_sel[i] ? OffloadInstr[(((NumInstr - 1) - i) * 70) + 2-:3] : {3 {1'sb0}});
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		prd_rsp_o[5] = 1'b0;
		prd_rsp_o[3] = 1'b0;
		prd_rsp_o[4] = 1'sb0;
		prd_rsp_o[2-:3] = 1'sb0;
		begin : sv2v_autoblock_1
			reg [31:0] i;
			for (i = 0; i < NumInstr; i = i + 1)
				begin
					prd_rsp_o[5] = prd_rsp_o[5] | instr_rsp[(i * 6) + 5];
					prd_rsp_o[3] = prd_rsp_o[3] | instr_rsp[(i * 6) + 3];
					prd_rsp_o[4] = prd_rsp_o[4] | instr_rsp[(i * 6) + 4];
					prd_rsp_o[2-:3] = prd_rsp_o[2-:3] | instr_rsp[(i * 6) + 2-:3];
				end
		end
	end
	initial _sv2v_0 = 0;
endmodule
module fpu_ss_decoder (
	instr_i,
	fpu_rnd_mode_i,
	fpu_op_o,
	op_select_o,
	fpu_rnd_mode_o,
	set_dyn_rm_o,
	src_fmt_o,
	dst_fmt_o,
	int_fmt_o,
	rd_is_fp_o,
	vectorial_op_o,
	op_mode_o,
	use_fpu_o,
	is_store_o,
	is_load_o,
	ls_size_o
);
	reg _sv2v_0;
	parameter PULP_ZFINX = 0;
	input wire [31:0] instr_i;
	input wire [2:0] fpu_rnd_mode_i;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	output reg [3:0] fpu_op_o;
	output reg [8:0] op_select_o;
	output reg [2:0] fpu_rnd_mode_o;
	output reg set_dyn_rm_o;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	output reg [2:0] src_fmt_o;
	output reg [2:0] dst_fmt_o;
	localparam [31:0] fpnew_pkg_NUM_INT_FORMATS = 4;
	localparam [31:0] fpnew_pkg_INT_FORMAT_BITS = 2;
	output reg [1:0] int_fmt_o;
	output wire rd_is_fp_o;
	output reg vectorial_op_o;
	output reg op_mode_o;
	output reg use_fpu_o;
	output reg is_store_o;
	output reg is_load_o;
	output reg [1:0] ls_size_o;
	reg rd_is_fp_dec;
	assign rd_is_fp_o = (PULP_ZFINX ? 1'b0 : rd_is_fp_dec);
	localparam [31:0] fpu_ss_instr_pkg_FADD_S = 32'b0000000zzzzzzzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FCLASS_S = 32'b111000000000zzzzz001zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FCVT_S_W = 32'b110100000000zzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FCVT_S_WU = 32'b110100000001zzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FCVT_WU_S = 32'b110000000001zzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FCVT_W_S = 32'b110000000000zzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FDIV_S = 32'b0001100zzzzzzzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FEQ_S = 32'b1010000zzzzzzzzzz010zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FLE_S = 32'b1010000zzzzzzzzzz000zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FLT_S = 32'b1010000zzzzzzzzzz001zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FLW = 32'bzzzzzzzzzzzzzzzzz010zzzzz0000111;
	localparam [31:0] fpu_ss_instr_pkg_FMADD_S = 32'bzzzzz00zzzzzzzzzzzzzzzzzz1000011;
	localparam [31:0] fpu_ss_instr_pkg_FMAX_S = 32'b0010100zzzzzzzzzz001zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FMIN_S = 32'b0010100zzzzzzzzzz000zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FMSUB_S = 32'bzzzzz00zzzzzzzzzzzzzzzzzz1000111;
	localparam [31:0] fpu_ss_instr_pkg_FMUL_S = 32'b0001000zzzzzzzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FMV_W_X = 32'b111100000000zzzzz000zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FMV_X_W = 32'b111000000000zzzzz000zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FNMADD_S = 32'bzzzzz00zzzzzzzzzzzzzzzzzz1001111;
	localparam [31:0] fpu_ss_instr_pkg_FNMSUB_S = 32'bzzzzz00zzzzzzzzzzzzzzzzzz1001011;
	localparam [31:0] fpu_ss_instr_pkg_FSGNJN_S = 32'b0010000zzzzzzzzzz001zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FSGNJX_S = 32'b0010000zzzzzzzzzz010zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FSGNJ_S = 32'b0010000zzzzzzzzzz000zzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FSQRT_S = 32'b010110000000zzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FSUB_S = 32'b0000100zzzzzzzzzzzzzzzzzz1010011;
	localparam [31:0] fpu_ss_instr_pkg_FSW = 32'bzzzzzzzzzzzzzzzzz010zzzzz0100111;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [1:0] sv2v_cast_2D3A8;
		input reg [1:0] inp;
		sv2v_cast_2D3A8 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		fpu_op_o = sv2v_cast_7BCAE(2);
		use_fpu_o = 1'b1;
		fpu_rnd_mode_o = (instr_i[14:12] == 3'b111 ? fpu_rnd_mode_i : instr_i[14:12]);
		set_dyn_rm_o = 1'b0;
		src_fmt_o = sv2v_cast_9FB13('d0);
		dst_fmt_o = sv2v_cast_9FB13('d0);
		int_fmt_o = sv2v_cast_2D3A8(2);
		op_select_o[0+:3] = 3'd0;
		op_select_o[3+:3] = 3'd0;
		op_select_o[6+:3] = 3'd0;
		vectorial_op_o = 1'b0;
		op_mode_o = 1'b0;
		is_store_o = 1'b0;
		is_load_o = 1'b0;
		ls_size_o = 2'b10;
		rd_is_fp_dec = 1'b1;
		(* full_case, parallel_case *)
		casez (instr_i)
			fpu_ss_instr_pkg_FADD_S: begin
				fpu_op_o = sv2v_cast_7BCAE(2);
				op_select_o[3+:3] = 3'd2;
				op_select_o[6+:3] = 3'd3;
			end
			fpu_ss_instr_pkg_FSUB_S: begin
				fpu_op_o = sv2v_cast_7BCAE(2);
				op_select_o[3+:3] = 3'd2;
				op_select_o[6+:3] = 3'd3;
				op_mode_o = 1'b1;
			end
			fpu_ss_instr_pkg_FMUL_S: begin
				fpu_op_o = sv2v_cast_7BCAE(3);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
			end
			fpu_ss_instr_pkg_FDIV_S: begin
				fpu_op_o = sv2v_cast_7BCAE(4);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
			end
			fpu_ss_instr_pkg_FSGNJ_S, fpu_ss_instr_pkg_FSGNJN_S, fpu_ss_instr_pkg_FSGNJX_S: begin
				fpu_op_o = sv2v_cast_7BCAE(6);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
			end
			fpu_ss_instr_pkg_FMIN_S, fpu_ss_instr_pkg_FMAX_S: begin
				fpu_op_o = sv2v_cast_7BCAE(7);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
			end
			fpu_ss_instr_pkg_FSQRT_S: begin
				fpu_op_o = sv2v_cast_7BCAE(5);
				op_select_o[0+:3] = 3'd2;
			end
			fpu_ss_instr_pkg_FMADD_S: begin
				fpu_op_o = sv2v_cast_7BCAE(0);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
				op_select_o[6+:3] = 3'd4;
			end
			fpu_ss_instr_pkg_FMSUB_S: begin
				fpu_op_o = sv2v_cast_7BCAE(0);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
				op_select_o[6+:3] = 3'd4;
				op_mode_o = 1'b1;
			end
			fpu_ss_instr_pkg_FNMSUB_S: begin
				fpu_op_o = sv2v_cast_7BCAE(1);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
				op_select_o[6+:3] = 3'd4;
			end
			fpu_ss_instr_pkg_FNMADD_S: begin
				fpu_op_o = sv2v_cast_7BCAE(1);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
				op_select_o[6+:3] = 3'd4;
				op_mode_o = 1'b1;
			end
			fpu_ss_instr_pkg_FLE_S, fpu_ss_instr_pkg_FLT_S, fpu_ss_instr_pkg_FEQ_S: begin
				fpu_op_o = sv2v_cast_7BCAE(8);
				op_select_o[0+:3] = 3'd2;
				op_select_o[3+:3] = 3'd3;
				src_fmt_o = sv2v_cast_9FB13('d0);
				dst_fmt_o = sv2v_cast_9FB13('d0);
				rd_is_fp_dec = 1'b0;
			end
			fpu_ss_instr_pkg_FCLASS_S: begin
				fpu_op_o = sv2v_cast_7BCAE(9);
				op_select_o[0+:3] = 3'd2;
				fpu_rnd_mode_o = 3'b000;
				src_fmt_o = sv2v_cast_9FB13('d0);
				dst_fmt_o = sv2v_cast_9FB13('d0);
				rd_is_fp_dec = 1'b0;
			end
			fpu_ss_instr_pkg_FCVT_W_S, fpu_ss_instr_pkg_FCVT_WU_S: begin
				fpu_op_o = sv2v_cast_7BCAE(11);
				op_select_o[0+:3] = 3'd2;
				src_fmt_o = sv2v_cast_9FB13('d0);
				dst_fmt_o = sv2v_cast_9FB13('d0);
				rd_is_fp_dec = 1'b0;
				if ((instr_i | 32'b00000000000011111111111110000000) == 32'b11000000000111111111111111010011)
					op_mode_o = 1'b1;
			end
			fpu_ss_instr_pkg_FMV_X_W: begin
				fpu_op_o = sv2v_cast_7BCAE(6);
				fpu_rnd_mode_o = 3'b011;
				src_fmt_o = sv2v_cast_9FB13('d0);
				dst_fmt_o = sv2v_cast_9FB13('d0);
				op_mode_o = 1'b1;
				op_select_o[0+:3] = 3'd2;
				rd_is_fp_dec = 1'b0;
			end
			fpu_ss_instr_pkg_FMV_W_X: begin
				fpu_op_o = sv2v_cast_7BCAE(6);
				op_select_o[0+:3] = 3'd1;
				fpu_rnd_mode_o = 3'b011;
				src_fmt_o = sv2v_cast_9FB13('d0);
				dst_fmt_o = sv2v_cast_9FB13('d0);
			end
			fpu_ss_instr_pkg_FCVT_S_W, fpu_ss_instr_pkg_FCVT_S_WU: begin
				fpu_op_o = sv2v_cast_7BCAE(12);
				op_select_o[0+:3] = 3'd1;
				dst_fmt_o = sv2v_cast_9FB13('d0);
				if ((instr_i | 32'b00000000000011111111111110000000) == 32'b11010000000111111111111111010011)
					op_mode_o = 1'b1;
			end
			fpu_ss_instr_pkg_FLW: begin
				is_load_o = 1'b1;
				use_fpu_o = 1'b0;
			end
			fpu_ss_instr_pkg_FSW: begin
				is_store_o = 1'b1;
				op_select_o[3+:3] = 3'd3;
				use_fpu_o = 1'b0;
				rd_is_fp_dec = 1'b0;
			end
			default: begin
				use_fpu_o = 1'b0;
				rd_is_fp_dec = 1'b0;
			end
		endcase
		if (set_dyn_rm_o)
			fpu_rnd_mode_o = fpu_rnd_mode_i;
	end
	initial _sv2v_0 = 0;
endmodule
module fpu_ss_csr (
	clk_i,
	rst_ni,
	instr_i,
	csr_data_i,
	fpu_status_i,
	in_buf_pop_valid_i,
	fpu_out_valid_i,
	csr_id_i,
	csr_rdata_o,
	frm_o,
	csr_wb_o,
	csr_wb_addr_o,
	csr_wb_id_o,
	csr_instr_o
);
	reg _sv2v_0;
	input wire clk_i;
	input wire rst_ni;
	input wire [31:0] instr_i;
	input wire [31:0] csr_data_i;
	input wire [4:0] fpu_status_i;
	input wire in_buf_pop_valid_i;
	input wire fpu_out_valid_i;
	input wire [3:0] csr_id_i;
	output reg [31:0] csr_rdata_o;
	output wire [2:0] frm_o;
	output reg csr_wb_o;
	output wire [4:0] csr_wb_addr_o;
	output reg [3:0] csr_wb_id_o;
	output reg csr_instr_o;
	reg [31:0] fcsr_d;
	reg [31:0] fcsr_q;
	reg [31:0] instr_q;
	assign frm_o = fcsr_q[7:5];
	assign csr_wb_addr_o = instr_q[11:7];
	always @(posedge clk_i or negedge rst_ni) begin : proc_instr_q
		if (~rst_ni) begin
			instr_q <= 1'sb0;
			csr_wb_id_o <= 1'sb0;
		end
		else if (in_buf_pop_valid_i) begin
			csr_wb_id_o <= csr_id_i;
			instr_q <= instr_i;
		end
		else
			instr_q <= 1'sb0;
	end
	localparam [31:0] fpu_ss_instr_pkg_CSRRS_FRCSR = 32'b000000000011zzzzz010zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRS_FRFLAGS = 32'b000000000001zzzzz010zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRS_FRRM = 32'b000000000010zzzzz010zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRWI_FSFLAGSI = 32'b000000000001zzzzz101zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRWI_FSRMI = 32'b000000000010zzzzz101zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRW_FSCSR = 32'b000000000011zzzzz001zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRW_FSFLAGS = 32'b000000000001zzzzz001zzzzz1110011;
	localparam [31:0] fpu_ss_instr_pkg_CSRRW_FSRM = 32'b000000000010zzzzz001zzzzz1110011;
	always @(*) begin
		if (_sv2v_0)
			;
		fcsr_d = fcsr_q;
		csr_wb_o = 1'b0;
		csr_rdata_o = 1'sb0;
		csr_instr_o = 1'b1;
		(* full_case, parallel_case *)
		casez (instr_q)
			fpu_ss_instr_pkg_CSRRW_FSCSR: begin
				fcsr_d = csr_data_i;
				csr_wb_o = 1'b1;
				csr_rdata_o = fcsr_q;
			end
			fpu_ss_instr_pkg_CSRRS_FRCSR: begin
				csr_wb_o = 1'b1;
				csr_rdata_o = fcsr_q;
			end
			fpu_ss_instr_pkg_CSRRW_FSRM: begin
				fcsr_d[7:5] = csr_data_i[2:0];
				csr_wb_o = 1'b1;
				csr_rdata_o = {29'b00000000000000000000000000000, fcsr_q[7:5]};
			end
			fpu_ss_instr_pkg_CSRRS_FRRM: begin
				csr_wb_o = 1'b1;
				csr_rdata_o = {29'b00000000000000000000000000000, fcsr_q[7:5]};
			end
			fpu_ss_instr_pkg_CSRRWI_FSRMI: fcsr_d[7:5] = instr_i[17:15];
			fpu_ss_instr_pkg_CSRRW_FSFLAGS: begin
				fcsr_d[4:0] = csr_data_i[4:0];
				csr_wb_o = 1'b1;
				csr_rdata_o = {27'b000000000000000000000000000, fcsr_q[4:0]};
			end
			fpu_ss_instr_pkg_CSRRS_FRFLAGS: begin
				csr_wb_o = 1'b1;
				csr_rdata_o = {27'b000000000000000000000000000, fcsr_q[4:0]};
			end
			fpu_ss_instr_pkg_CSRRWI_FSFLAGSI: fcsr_d[4:0] = instr_i[19:15];
			default: begin
				if (fpu_out_valid_i)
					fcsr_d = {fcsr_q[31:5], fpu_status_i[4], fpu_status_i[3], fpu_status_i[2], fpu_status_i[1], fpu_status_i[0]};
				else
					fcsr_d = fcsr_q;
				csr_wb_o = 1'b0;
				csr_rdata_o = 1'sb0;
				csr_instr_o = 1'b0;
			end
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni)
			fcsr_q <= 1'sb0;
		else
			fcsr_q <= fcsr_d;
	initial _sv2v_0 = 0;
endmodule
module fpu_ss_controller (
	clk_i,
	rst_ni,
	in_buf_push_ready_i,
	prd_rsp_use_rs_i,
	x_issue_req_rs_valid_i,
	x_issue_ready_o,
	x_commit_valid_i,
	x_commit_i,
	in_buf_pop_valid_i,
	in_buf_pop_ready_o,
	rd_is_fp_i,
	fpr_wb_addr_i,
	rd_i,
	fpr_we_o,
	fpu_out_id_i,
	rd_in_is_fp_i,
	rs1_i,
	rs2_i,
	rs3_i,
	fpu_fwd_o,
	lsu_fwd_o,
	op_select_i,
	dep_rs_o,
	dep_rd_o,
	x_issue_ready_i,
	is_load_i,
	is_store_i,
	x_mem_valid_o,
	x_mem_ready_i,
	x_mem_req_id_i,
	x_mem_req_we_o,
	x_mem_req_spec_o,
	x_mem_req_last_o,
	mem_push_valid_o,
	mem_push_ready_i,
	mem_pop_ready_o,
	mem_pop_data_i,
	x_mem_result_valid_i,
	use_fpu_i,
	fpu_in_valid_o,
	fpu_in_ready_i,
	fpu_in_id_i,
	fpu_out_valid_i,
	fpu_out_ready_o,
	x_result_ready_i,
	x_result_valid_o,
	csr_instr_i
);
	reg _sv2v_0;
	parameter PULP_ZFINX = 0;
	parameter INPUT_BUFFER_DEPTH = 0;
	parameter OUT_OF_ORDER = 1;
	parameter FORWARDING = 1;
	input wire clk_i;
	input wire rst_ni;
	input wire in_buf_push_ready_i;
	input wire [2:0] prd_rsp_use_rs_i;
	input wire [2:0] x_issue_req_rs_valid_i;
	output reg x_issue_ready_o;
	input wire x_commit_valid_i;
	localparam signed [31:0] fpu_ss_pkg_X_ID_WIDTH = 4;
	input wire [4:0] x_commit_i;
	input wire in_buf_pop_valid_i;
	output reg in_buf_pop_ready_o;
	input wire rd_is_fp_i;
	input wire [4:0] fpr_wb_addr_i;
	input wire [4:0] rd_i;
	output reg fpr_we_o;
	input wire [3:0] fpu_out_id_i;
	input wire rd_in_is_fp_i;
	input wire [4:0] rs1_i;
	input wire [4:0] rs2_i;
	input wire [4:0] rs3_i;
	output reg [2:0] fpu_fwd_o;
	output reg [2:0] lsu_fwd_o;
	input wire [8:0] op_select_i;
	output wire dep_rs_o;
	output wire dep_rd_o;
	input wire x_issue_ready_i;
	input wire is_load_i;
	input wire is_store_i;
	output reg x_mem_valid_o;
	input wire x_mem_ready_i;
	input wire [3:0] x_mem_req_id_i;
	output reg x_mem_req_we_o;
	output wire x_mem_req_spec_o;
	output reg x_mem_req_last_o;
	output wire mem_push_valid_o;
	input wire mem_push_ready_i;
	output wire mem_pop_ready_o;
	input wire [9:0] mem_pop_data_i;
	input wire x_mem_result_valid_i;
	input wire use_fpu_i;
	output reg fpu_in_valid_o;
	input wire fpu_in_ready_i;
	input wire [3:0] fpu_in_id_i;
	input wire fpu_out_valid_i;
	output wire fpu_out_ready_o;
	input wire x_result_ready_i;
	output reg x_result_valid_o;
	input wire csr_instr_i;
	reg [2:0] valid_operands;
	wire dep_rs1;
	wire dep_rs2;
	wire dep_rs1_add;
	wire dep_rs2_add;
	wire dep_rs3;
	wire x_result_hs;
	wire x_mem_req_hs;
	reg instr_inflight_d;
	reg instr_inflight_q;
	reg instr_offloaded_d;
	reg instr_offloaded_q;
	reg [31:0] rd_scoreboard_d;
	reg [31:0] rd_scoreboard_q;
	reg [15:0] id_scoreboard_d;
	reg [15:0] id_scoreboard_q;
	always @(*) begin
		if (_sv2v_0)
			;
		x_issue_ready_o = 1'b0;
		if (((((prd_rsp_use_rs_i[0] & x_issue_req_rs_valid_i[0]) | !prd_rsp_use_rs_i[0]) & ((prd_rsp_use_rs_i[1] & x_issue_req_rs_valid_i[1]) | !prd_rsp_use_rs_i[1])) & ((prd_rsp_use_rs_i[2] & x_issue_req_rs_valid_i[2]) | !prd_rsp_use_rs_i[2])) & in_buf_push_ready_i)
			x_issue_ready_o = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		in_buf_pop_ready_o = 1'b0;
		if (((fpu_in_valid_o & fpu_in_ready_i) | (x_result_hs & csr_instr_i)) | x_mem_req_hs)
			in_buf_pop_ready_o = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		fpr_we_o = 1'b0;
		if (((fpu_out_valid_i & fpu_out_ready_o) & rd_is_fp_i) | ((mem_pop_data_i[0] & x_mem_result_valid_i) & ~PULP_ZFINX))
			fpr_we_o = 1'b1;
	end
	assign dep_rs1 = (rd_scoreboard_q[rs1_i] & in_buf_pop_valid_i) & (op_select_i[0+:3] == 3'd2);
	assign dep_rs1_add = (rd_scoreboard_q[rs2_i] & in_buf_pop_valid_i) & (op_select_i[3+:3] == 3'd2);
	assign dep_rs2 = (rd_scoreboard_q[rs2_i] & in_buf_pop_valid_i) & (op_select_i[3+:3] == 3'd3);
	assign dep_rs2_add = (rd_scoreboard_q[rs3_i] & in_buf_pop_valid_i) & (op_select_i[6+:3] == 3'd3);
	assign dep_rs3 = (rd_scoreboard_q[rs3_i] & in_buf_pop_valid_i) & (op_select_i[6+:3] == 3'd4);
	assign dep_rs_o = ((((dep_rs1 & ~(fpu_fwd_o[0] | lsu_fwd_o[0])) | (dep_rs1_add & ~(fpu_fwd_o[1] | lsu_fwd_o[1]))) | (dep_rs2 & ~(fpu_fwd_o[1] | lsu_fwd_o[1]))) | (dep_rs2_add & ~(fpu_fwd_o[2] | lsu_fwd_o[2]))) | (dep_rs3 & ~(fpu_fwd_o[2] | lsu_fwd_o[2]));
	assign dep_rd_o = (rd_scoreboard_q[rd_i] & rd_in_is_fp_i) & ~((((fpu_out_valid_i & fpu_out_ready_o) | x_mem_result_valid_i) & fpr_we_o) & (fpr_wb_addr_i == rd_i));
	always @(*) begin
		if (_sv2v_0)
			;
		fpu_fwd_o[0] = 1'b0;
		fpu_fwd_o[1] = 1'b0;
		fpu_fwd_o[2] = 1'b0;
		lsu_fwd_o[0] = 1'b0;
		lsu_fwd_o[1] = 1'b0;
		lsu_fwd_o[2] = 1'b0;
		if (FORWARDING) begin
			valid_operands[0] = op_select_i[0+:3] == 3'd2;
			valid_operands[1] = (op_select_i[3+:3] == 3'd2) | (op_select_i[3+:3] == 3'd3);
			valid_operands[2] = (op_select_i[6+:3] == 3'd3) | (op_select_i[6+:3] == 3'd4);
			fpu_fwd_o[0] = (((valid_operands[0] & fpu_out_valid_i) & fpu_out_ready_o) & rd_is_fp_i) & (rs1_i == fpr_wb_addr_i);
			fpu_fwd_o[1] = (((valid_operands[1] & fpu_out_valid_i) & fpu_out_ready_o) & rd_is_fp_i) & (rs2_i == fpr_wb_addr_i);
			fpu_fwd_o[2] = (((valid_operands[2] & fpu_out_valid_i) & fpu_out_ready_o) & rd_is_fp_i) & (rs3_i == fpr_wb_addr_i);
			lsu_fwd_o[0] = ((valid_operands[0] & x_mem_result_valid_i) & mem_pop_data_i[0]) & (rs1_i == mem_pop_data_i[5-:5]);
			lsu_fwd_o[1] = ((valid_operands[1] & x_mem_result_valid_i) & mem_pop_data_i[0]) & (rs2_i == mem_pop_data_i[5-:5]);
			lsu_fwd_o[2] = ((valid_operands[2] & x_mem_result_valid_i) & mem_pop_data_i[0]) & (rs3_i == mem_pop_data_i[5-:5]);
		end
	end
	assign x_mem_req_hs = x_mem_valid_o & x_mem_ready_i;
	assign x_mem_req_spec_o = 1'b0;
	assign mem_push_valid_o = x_mem_req_hs;
	assign mem_pop_ready_o = x_mem_result_valid_i;
	always @(*) begin
		if (_sv2v_0)
			;
		x_mem_valid_o = 1'b0;
		if (((((((is_load_i | is_store_i) & ~dep_rs_o) & ~dep_rd_o) & in_buf_pop_valid_i) & mem_push_ready_i) & (x_issue_ready_i | INPUT_BUFFER_DEPTH)) & (id_scoreboard_q[x_mem_req_id_i] | ((x_commit_valid_i & (x_commit_i[4-:4] == x_mem_req_id_i)) & ~x_commit_i[0])))
			x_mem_valid_o = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_mem_req_we_o = 1'b0;
		if (is_store_i)
			x_mem_req_we_o = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_mem_req_last_o = 1'b0;
		if (x_mem_valid_o)
			x_mem_req_last_o = 1'b1;
	end
	assign fpu_out_ready_o = ~x_mem_result_valid_i;
	always @(*) begin
		if (_sv2v_0)
			;
		fpu_in_valid_o = 1'b0;
		if ((((((use_fpu_i & in_buf_pop_valid_i) & (id_scoreboard_q[fpu_in_id_i] | (((x_commit_i[4-:4] == fpu_in_id_i) & ~x_commit_i[0]) & x_commit_valid_i))) & ~dep_rs_o) & ~dep_rd_o) & (x_issue_ready_i | ~PULP_ZFINX)) & OUT_OF_ORDER)
			fpu_in_valid_o = 1'b1;
		else if ((((((use_fpu_i & in_buf_pop_valid_i) & (id_scoreboard_q[fpu_in_id_i] | (((x_commit_i[4-:4] == fpu_in_id_i) & ~x_commit_i[0]) & x_commit_valid_i))) & ~dep_rs_o) & ~dep_rd_o) & (fpu_out_valid_i | ~instr_inflight_q)) & ~OUT_OF_ORDER)
			fpu_in_valid_o = 1'b1;
	end
	assign x_result_hs = x_result_ready_i & x_result_valid_o;
	always @(*) begin
		if (_sv2v_0)
			;
		x_result_valid_o = 1'b0;
		if ((fpu_out_valid_i | csr_instr_i) | x_mem_result_valid_i)
			x_result_valid_o = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		instr_inflight_d = instr_inflight_q;
		if ((fpu_out_valid_i & fpu_out_ready_o) & ~fpu_in_valid_o)
			instr_inflight_d = 1'b0;
		else if (fpu_in_valid_o)
			instr_inflight_d = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		instr_offloaded_d = instr_offloaded_q;
		if (in_buf_pop_valid_i & x_mem_req_hs)
			instr_offloaded_d = 1'b1;
		else if (x_mem_result_valid_i)
			instr_offloaded_d = 1'b0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		rd_scoreboard_d = rd_scoreboard_q;
		if (((fpu_in_valid_o & fpu_in_ready_i) & rd_in_is_fp_i) | ((x_mem_req_hs & is_load_i) & in_buf_pop_valid_i))
			rd_scoreboard_d[rd_i] = 1'b1;
		if ((fpu_out_ready_o & fpu_out_valid_i) & ~((fpu_in_valid_o & fpu_in_ready_i) & (fpr_wb_addr_i == rd_i)))
			rd_scoreboard_d[fpr_wb_addr_i] = 1'b0;
		else if ((x_mem_result_valid_i & mem_pop_data_i[0]) & ~(((fpu_in_valid_o & fpu_in_ready_i) & rd_in_is_fp_i) & (mem_pop_data_i[5-:5] == rd_i)))
			rd_scoreboard_d[mem_pop_data_i[5-:5]] = 1'b0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		id_scoreboard_d = id_scoreboard_q;
		if (x_commit_valid_i & ~x_commit_i[0])
			id_scoreboard_d[x_commit_i[4-:4]] = 1'b1;
		if (fpu_out_ready_o & fpu_out_valid_i)
			id_scoreboard_d[fpu_out_id_i] = 1'b0;
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni) begin
			instr_inflight_q <= 1'b0;
			instr_offloaded_q <= 1'b0;
			rd_scoreboard_q <= 1'sb0;
			id_scoreboard_q <= 1'sb0;
		end
		else begin
			instr_inflight_q <= instr_inflight_d;
			instr_offloaded_q <= instr_offloaded_d;
			rd_scoreboard_q <= rd_scoreboard_d;
			id_scoreboard_q <= id_scoreboard_d;
		end
	initial _sv2v_0 = 0;
endmodule
module fpu_ss_regfile (
	clk_i,
	rst_ni,
	raddr_i,
	rdata_o,
	waddr_i,
	wdata_i,
	we_i
);
	reg _sv2v_0;
	input wire clk_i;
	input wire rst_ni;
	input wire [14:0] raddr_i;
	output wire [95:0] rdata_o;
	input wire [4:0] waddr_i;
	input wire [31:0] wdata_i;
	input wire we_i;
	localparam [31:0] NumWords = 32;
	reg [1023:0] mem;
	reg [31:0] we_dec;
	always @(*) begin : we_decoder
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg [31:0] i;
			for (i = 0; i < NumWords; i = i + 1)
				if (waddr_i == i[4:0])
					we_dec[i] = we_i;
				else
					we_dec[i] = 1'b0;
		end
	end
	genvar _gv_i_21;
	generate
		for (_gv_i_21 = 0; _gv_i_21 < NumWords; _gv_i_21 = _gv_i_21 + 1) begin : register_write_behavioral
			localparam i = _gv_i_21;
			always @(posedge clk_i or negedge rst_ni)
				if (~rst_ni)
					mem[i * 32+:32] <= 1'sb0;
				else if (we_dec[i])
					mem[i * 32+:32] <= wdata_i;
		end
	endgenerate
	genvar _gv_i_22;
	generate
		for (_gv_i_22 = 0; _gv_i_22 < 3; _gv_i_22 = _gv_i_22 + 1) begin : gen_read_port
			localparam i = _gv_i_22;
			assign rdata_o[i * 32+:32] = mem[raddr_i[i * 5+:5] * 32+:32];
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
module fpu_ss (
	clk_i,
	rst_ni,
	x_compressed_valid_i,
	x_compressed_ready_o,
	x_compressed_req_i,
	x_compressed_resp_o,
	x_issue_valid_i,
	x_issue_ready_o,
	x_issue_req_i,
	x_issue_resp_o,
	x_commit_valid_i,
	x_commit_i,
	x_mem_valid_o,
	x_mem_ready_i,
	x_mem_req_o,
	x_mem_resp_i,
	x_mem_result_valid_i,
	x_mem_result_i,
	x_result_valid_o,
	x_result_ready_i,
	x_result_o
);
	reg _sv2v_0;
	parameter PULP_ZFINX = 0;
	parameter INPUT_BUFFER_DEPTH = 0;
	parameter OUT_OF_ORDER = 1;
	parameter FORWARDING = 1;
	parameter [0:0] PulpDivsqrt = 1'b0;
	localparam [31:0] fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] fpnew_pkg_NUM_INT_FORMATS = 4;
	localparam [0:0] fpu_ss_pkg_C_RVD = 1'b0;
	localparam [0:0] fpu_ss_pkg_C_RVF = 1'b1;
	localparam [0:0] fpu_ss_pkg_C_XF16 = 1'b0;
	localparam [0:0] fpu_ss_pkg_C_XF16ALT = 1'b0;
	localparam [0:0] fpu_ss_pkg_C_XF8 = 1'b0;
	localparam fpu_ss_pkg_C_FLEN = (fpu_ss_pkg_C_RVD ? 64 : (fpu_ss_pkg_C_RVF ? 32 : (fpu_ss_pkg_C_XF16 ? 16 : (fpu_ss_pkg_C_XF16ALT ? 16 : (fpu_ss_pkg_C_XF8 ? 8 : 0)))));
	localparam [0:0] fpu_ss_pkg_C_XFVEC = 1'b0;
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	localparam [42:0] fpu_ss_pkg_FPU_FEATURES = {sv2v_cast_32(fpu_ss_pkg_C_FLEN), fpu_ss_pkg_C_XFVEC, 1'b0, sv2v_cast_5({fpu_ss_pkg_C_RVF, fpu_ss_pkg_C_RVD, fpu_ss_pkg_C_XF16, fpu_ss_pkg_C_XF8, fpu_ss_pkg_C_XF16ALT}), 4'h2};
	parameter [42:0] FPU_FEATURES = fpu_ss_pkg_FPU_FEATURES;
	localparam [31:0] fpnew_pkg_NUM_OPGROUPS = 4;
	localparam [31:0] fpu_ss_pkg_C_LAT_CONV = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_DIVSQRT = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_FP16 = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_FP16ALT = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_FP32 = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_FP64 = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_FP8 = 'd1;
	localparam [31:0] fpu_ss_pkg_C_LAT_NONCOMP = 'd1;
	function automatic [((32'd4 * 32'd5) * 32) - 1:0] sv2v_cast_9CB06;
		input reg [((32'd4 * 32'd5) * 32) - 1:0] inp;
		sv2v_cast_9CB06 = inp;
	endfunction
	function automatic [((32'd4 * 32'd5) * 2) - 1:0] sv2v_cast_2DA10;
		input reg [((32'd4 * 32'd5) * 2) - 1:0] inp;
		sv2v_cast_2DA10 = inp;
	endfunction
	localparam [(((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 32) + ((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2)) + 1:0] fpu_ss_pkg_FPU_IMPLEMENTATION = {sv2v_cast_9CB06({fpu_ss_pkg_C_LAT_FP32, fpu_ss_pkg_C_LAT_FP64, fpu_ss_pkg_C_LAT_FP16, fpu_ss_pkg_C_LAT_FP8, fpu_ss_pkg_C_LAT_FP16ALT, {fpnew_pkg_NUM_FP_FORMATS {fpu_ss_pkg_C_LAT_DIVSQRT}}, {fpnew_pkg_NUM_FP_FORMATS {fpu_ss_pkg_C_LAT_NONCOMP}}, {fpnew_pkg_NUM_FP_FORMATS {fpu_ss_pkg_C_LAT_CONV}}}), sv2v_cast_2DA10({{fpnew_pkg_NUM_FP_FORMATS {2'd2}}, {fpnew_pkg_NUM_FP_FORMATS {2'd2}}, {fpnew_pkg_NUM_FP_FORMATS {2'd1}}, {fpnew_pkg_NUM_FP_FORMATS {2'd2}}}), 2'd0};
	parameter [(((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 32) + ((fpnew_pkg_NUM_OPGROUPS * fpnew_pkg_NUM_FP_FORMATS) * 2)) + 1:0] FPU_IMPLEMENTATION = fpu_ss_pkg_FPU_IMPLEMENTATION;
	input wire clk_i;
	input wire rst_ni;
	input wire x_compressed_valid_i;
	output wire x_compressed_ready_o;
	localparam signed [31:0] fpu_ss_pkg_X_ID_WIDTH = 4;
	input wire [21:0] x_compressed_req_i;
	output wire [32:0] x_compressed_resp_o;
	input wire x_issue_valid_i;
	output wire x_issue_ready_o;
	localparam signed [31:0] fpu_ss_pkg_X_NUM_RS = 3;
	localparam signed [31:0] fpu_ss_pkg_X_RFR_WIDTH = 32;
	input wire [((38 + (fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH)) + fpu_ss_pkg_X_NUM_RS) + 6:0] x_issue_req_i;
	output wire [8:0] x_issue_resp_o;
	input wire x_commit_valid_i;
	input wire [4:0] x_commit_i;
	output wire x_mem_valid_o;
	input wire x_mem_ready_i;
	localparam signed [31:0] fpu_ss_pkg_X_MEM_WIDTH = 32;
	output reg [81:0] x_mem_req_o;
	input wire [7:0] x_mem_resp_i;
	input wire x_mem_result_valid_i;
	input wire [(fpu_ss_pkg_X_ID_WIDTH + fpu_ss_pkg_X_MEM_WIDTH) + 1:0] x_mem_result_i;
	output wire x_result_valid_o;
	input wire x_result_ready_i;
	localparam signed [31:0] fpu_ss_pkg_XLEN = 32;
	localparam signed [31:0] fpu_ss_pkg_X_RFW_WIDTH = 32;
	output reg [(((fpu_ss_pkg_X_ID_WIDTH + fpu_ss_pkg_X_RFW_WIDTH) + 5) + (fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN)) + 17:0] x_result_o;
	localparam [31:0] fpu_ss_prd_f_pkg_NumInstr = 34;
	localparam [31:0] NUM_INSTR = fpu_ss_prd_f_pkg_NumInstr;
	localparam [2379:0] fpu_ss_prd_f_pkg_OffloadInstr = 2380'b1000000000011100000000000000000111000001111111110001000000000000000000100000001001110000000000000000011100000111111111000100000000000000000000000001000011000001100000000000000000011111111000000000000000000000000000000100011100000110000000000000000001111111100000000000000000000000000000010010110000011000000000000000000111111110000000000000000000000000000001001111000001100000000000000000011111111000000000000000000000000000000101001111111110000000000000000001111111100000000010000000000000000000010100111111111000000000000000000111111110000000010000000000000000000001010011111111100000000000000000011111111000000001100000000000000000000101001111111110000000000000000001111111100000010110000000000000000000010100111111111111110000000000000111111110000000100000000000000000000001010011111111100000000001110000011111111000000010000000000000000100000101001111111110000000000111000001111111100000001000000000000000100000010100111111111000000000011100000111111110000000101000000000000000000001010011111111100000000001110000011111111000000010100000000000000100000101001111111110000000000111000001111111100000110000000000000000000000010100111111111111110000000000000111111110100011000000000100000000000001010011111111111111000000000000011111111010001110000000000000000000000101001111111111111100000111000001111111101000101000000000000000100000010100111111111000000000011100000111111110100010100000000000000001000001010011111111100000000001110000011111111010001010000000000000000000000101001111111110000000000111000001111111101000111000000000000000010000010100111111111111110000011100000111111110100011010000000000000000000001010011111111111111000000000000011111111000011101000000010000000000000101001111111111111100000000000001111111100001111100000000000000000000010100111111111111110000011100000111111110000100000000001100000001000001110011111111111111000001110000011111111010010000000000110000001000000111001111111111111100000111000001111111101001000000000010000000010000011100111111111111110000011100000111111110100100000000001000000010000001110011111111111111000001110000011111111010010000000000100000010100000111001111111111111100000111000001111111101000000000000001000000010000011100111111111111110000011100000111111110100100000000000100000010000001110011111111111111000001110000011111111010010000000000010000010100000111001111111111111100000111000001111111101000;
	localparam [2379:0] OFFLOAD_INSTR = fpu_ss_prd_f_pkg_OffloadInstr;
	wire [15:0] comp_prd_req;
	wire [32:0] comp_prd_rsp;
	wire [31:0] prd_req;
	wire [5:0] prd_rsp;
	wire in_buf_push_ready;
	wire x_issue_ready;
	wire [133:0] in_buf_push_data;
	wire [133:0] in_buf_pop_data;
	wire in_buf_push_valid;
	wire in_buf_pop_valid;
	wire in_buf_pop_ready;
	localparam [31:0] fpnew_pkg_OP_BITS = 4;
	wire [3:0] fpu_op;
	wire [8:0] op_select_dec;
	reg [8:0] op_select;
	wire [2:0] fpu_rnd_mode;
	wire set_dyn_rm;
	localparam [31:0] fpnew_pkg_FP_FORMAT_BITS = 3;
	wire [2:0] src_fmt;
	wire [2:0] dst_fmt;
	localparam [31:0] fpnew_pkg_INT_FORMAT_BITS = 2;
	wire [1:0] int_fmt;
	wire rd_is_fp;
	wire csr_instr;
	wire vectorial_op;
	wire op_mode;
	wire use_fpu;
	wire is_store;
	wire is_load;
	wire [1:0] ls_size;
	wire [2:0] fpu_fwd;
	wire [2:0] lsu_fwd;
	wire dep_rs;
	wire dep_rd;
	wire [31:0] instr;
	reg [95:0] fpu_operands_dec;
	reg [95:0] fpu_operands;
	wire [95:0] int_operands;
	wire [95:0] fpr_operands;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [4:0] rs3;
	wire [4:0] rd;
	reg [31:0] offset;
	reg [14:0] fpr_raddr;
	reg [4:0] fpr_wb_addr;
	reg [31:0] fpr_wb_data;
	wire fpr_we;
	wire mem_push_valid;
	wire mem_push_ready;
	wire mem_pop_valid;
	wire mem_pop_ready;
	wire [9:0] mem_push_data;
	wire [9:0] mem_pop_data;
	wire csr_wb;
	wire [31:0] csr_rdata;
	wire [4:0] csr_wb_addr;
	wire [3:0] csr_wb_id;
	wire [2:0] frm;
	wire [9:0] fpu_tag_in;
	wire [9:0] fpu_tag_out;
	wire fpu_in_valid;
	wire fpu_in_ready;
	wire fpu_out_valid;
	wire fpu_out_ready;
	wire [31:0] fpu_result;
	wire fpu_busy;
	wire [4:0] fpu_status;
	assign x_compressed_ready_o = x_compressed_valid_i;
	assign comp_prd_req[15-:16] = x_compressed_req_i[21-:16];
	assign x_compressed_resp_o[32-:32] = comp_prd_rsp[31-:32];
	assign x_compressed_resp_o[0] = comp_prd_rsp[32];
	assign prd_req[31-:32] = x_issue_req_i[34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))-:((38 + ((32'sd3 * 32'sd32) + 9)) >= (6 + ((32'sd3 * 32'sd32) + 10)) ? ((34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) - (2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)))) + 1 : ((2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10))) - (34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)))) + 1)];
	assign x_issue_resp_o[8] = prd_rsp[5];
	assign x_issue_resp_o[7] = prd_rsp[3];
	assign x_issue_resp_o[6] = 1'sb0;
	assign x_issue_resp_o[5-:3] = 1'sb0;
	assign x_issue_resp_o[2] = prd_rsp[4];
	assign x_issue_resp_o[1] = 1'sb0;
	assign x_issue_resp_o[0] = 1'sb0;
	assign in_buf_push_valid = (x_issue_valid_i & x_issue_ready_o) & x_issue_resp_o[8];
	assign in_buf_push_data[133-:96] = x_issue_req_i[(fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9-:(((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9) >= 10 ? fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH : 11 - ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))];
	assign in_buf_push_data[37-:32] = x_issue_req_i[34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))-:((38 + ((32'sd3 * 32'sd32) + 9)) >= (6 + ((32'sd3 * 32'sd32) + 10)) ? ((34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) - (2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)))) + 1 : ((2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10))) - (34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)))) + 1)];
	assign in_buf_push_data[5-:4] = x_issue_req_i[fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)-:((fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)) >= ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10) ? ((fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)) - ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)) + 1 : (((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10) - (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) + 1)];
	assign in_buf_push_data[1-:2] = x_issue_req_i[2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))-:((6 + ((32'sd3 * 32'sd32) + 9)) >= (32'sd4 + ((32'sd3 * 32'sd32) + 10)) ? ((2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) - (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10))) + 1 : ((fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)) - (2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)))) + 1)];
	assign instr = in_buf_pop_data[37-:32];
	assign int_operands[0+:32] = in_buf_pop_data[38+:32];
	assign int_operands[32+:32] = in_buf_pop_data[70+:32];
	assign int_operands[64+:32] = in_buf_pop_data[102+:32];
	assign rs1 = instr[19:15];
	assign rs2 = instr[24:20];
	assign rs3 = instr[31:27];
	assign rd = instr[11:7];
	assign fpu_tag_in[9-:5] = rd;
	assign fpu_tag_in[4] = rd_is_fp;
	assign fpu_tag_in[3-:4] = in_buf_pop_data[5-:4];
	assign mem_push_data[9-:4] = in_buf_pop_data[5-:4];
	assign mem_push_data[5-:5] = rd;
	assign mem_push_data[0] = is_load;
	wire [2:1] sv2v_tmp_4C824;
	assign sv2v_tmp_4C824 = in_buf_pop_data[1-:2];
	always @(*) x_mem_req_o[45-:2] = sv2v_tmp_4C824;
	wire [3:1] sv2v_tmp_44BE9;
	assign sv2v_tmp_44BE9 = instr[14:12];
	always @(*) x_mem_req_o[42-:3] = sv2v_tmp_44BE9;
	wire [4:1] sv2v_tmp_FEEC2;
	assign sv2v_tmp_FEEC2 = in_buf_pop_data[5-:4];
	always @(*) x_mem_req_o[81-:4] = sv2v_tmp_FEEC2;
	always @(*) begin
		if (_sv2v_0)
			;
		x_mem_req_o[33-:32] = fpr_operands[32+:32];
		if (fpu_fwd[1])
			x_mem_req_o[33-:32] = fpu_result;
		else if (lsu_fwd[1])
			x_mem_req_o[33-:32] = x_mem_result_i[33-:32];
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if (~x_mem_req_o[43]) begin
			offset = sv2v_cast_32($unsigned(instr[31:20]));
			if (instr[31])
				offset = {20'b11111111111111111111, instr[31:20]};
		end
		else begin
			offset = sv2v_cast_32($unsigned({instr[31:25], instr[11:7]}));
			if (instr[31])
				offset = {20'b11111111111111111111, instr[31:25], instr[11:7]};
		end
		x_mem_req_o[77-:32] = int_operands[0+:32] + offset;
	end
	fpu_ss_compressed_predecoder fpu_ss_compressed_predecoder_i(
		.prd_req_i(comp_prd_req),
		.prd_rsp_o(comp_prd_rsp)
	);
	fpu_ss_predecoder #(
		.NumInstr(NUM_INSTR),
		.OffloadInstr(OFFLOAD_INSTR)
	) fpu_ss_predecoder_i(
		.prd_req_i(prd_req),
		.prd_rsp_o(prd_rsp)
	);
	generate
		if (INPUT_BUFFER_DEPTH > 0) begin : gen_input_stream_fifo
			stream_fifo_D7DC4 #(
				.FALL_THROUGH(1),
				.DATA_WIDTH(32),
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
			assign x_issue_ready_o = x_issue_ready;
		end
		else begin : gen_no_input_stream_fifo
			assign in_buf_pop_data = in_buf_push_data;
			assign x_issue_ready_o = (x_issue_ready & ~dep_rs) & ~dep_rd;
			assign in_buf_push_ready = 1'b1;
			assign in_buf_pop_valid = x_issue_valid_i;
		end
	endgenerate
	fpu_ss_decoder #(.PULP_ZFINX(PULP_ZFINX)) fpu_ss_decoder_i(
		.instr_i(instr),
		.fpu_rnd_mode_i(frm),
		.fpu_op_o(fpu_op),
		.op_select_o(op_select_dec),
		.fpu_rnd_mode_o(fpu_rnd_mode),
		.set_dyn_rm_o(set_dyn_rm),
		.src_fmt_o(src_fmt),
		.dst_fmt_o(dst_fmt),
		.int_fmt_o(int_fmt),
		.rd_is_fp_o(rd_is_fp),
		.vectorial_op_o(vectorial_op),
		.op_mode_o(op_mode),
		.use_fpu_o(use_fpu),
		.is_store_o(is_store),
		.is_load_o(is_load),
		.ls_size_o(ls_size)
	);
	stream_fifo_6C171 #(
		.FALL_THROUGH(0),
		.DATA_WIDTH(32),
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
		.valid_o(mem_pop_valid),
		.ready_i(mem_pop_ready)
	);
	fpu_ss_csr fpu_ss_csr_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.instr_i(instr),
		.csr_data_i(int_operands[0+:32]),
		.fpu_status_i(fpu_status),
		.in_buf_pop_valid_i(in_buf_pop_valid),
		.fpu_out_valid_i(fpu_out_valid),
		.csr_id_i(in_buf_pop_data[5-:4]),
		.csr_rdata_o(csr_rdata),
		.frm_o(frm),
		.csr_wb_o(csr_wb),
		.csr_wb_addr_o(csr_wb_addr),
		.csr_wb_id_o(csr_wb_id),
		.csr_instr_o(csr_instr)
	);
	wire [1:1] sv2v_tmp_fpu_ss_controller_i_x_mem_req_we_o;
	always @(*) x_mem_req_o[43] = sv2v_tmp_fpu_ss_controller_i_x_mem_req_we_o;
	wire [1:1] sv2v_tmp_fpu_ss_controller_i_x_mem_req_spec_o;
	always @(*) x_mem_req_o[0] = sv2v_tmp_fpu_ss_controller_i_x_mem_req_spec_o;
	wire [1:1] sv2v_tmp_fpu_ss_controller_i_x_mem_req_last_o;
	always @(*) x_mem_req_o[1] = sv2v_tmp_fpu_ss_controller_i_x_mem_req_last_o;
	fpu_ss_controller #(
		.PULP_ZFINX(PULP_ZFINX),
		.INPUT_BUFFER_DEPTH(INPUT_BUFFER_DEPTH),
		.OUT_OF_ORDER(OUT_OF_ORDER),
		.FORWARDING(FORWARDING)
	) fpu_ss_controller_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.in_buf_push_ready_i(in_buf_push_ready),
		.prd_rsp_use_rs_i(prd_rsp[2-:3]),
		.x_issue_req_rs_valid_i(x_issue_req_i[9-:3]),
		.x_issue_ready_o(x_issue_ready),
		.x_commit_valid_i(x_commit_valid_i),
		.x_commit_i(x_commit_i),
		.in_buf_pop_valid_i(in_buf_pop_valid),
		.in_buf_pop_ready_o(in_buf_pop_ready),
		.rd_is_fp_i(fpu_tag_out[4]),
		.fpr_wb_addr_i(fpr_wb_addr),
		.rd_i(rd),
		.fpr_we_o(fpr_we),
		.fpu_out_id_i(fpu_tag_out[3-:4]),
		.rd_in_is_fp_i(rd_is_fp),
		.rs1_i(fpr_raddr[0+:5]),
		.rs2_i(fpr_raddr[5+:5]),
		.rs3_i(fpr_raddr[10+:5]),
		.fpu_fwd_o(fpu_fwd),
		.lsu_fwd_o(lsu_fwd),
		.op_select_i(op_select),
		.dep_rs_o(dep_rs),
		.dep_rd_o(dep_rd),
		.x_issue_ready_i(x_issue_ready_o),
		.is_load_i(is_load),
		.is_store_i(is_store),
		.x_mem_valid_o(x_mem_valid_o),
		.x_mem_ready_i(x_mem_ready_i),
		.x_mem_req_id_i(x_mem_req_o[81-:4]),
		.x_mem_req_we_o(sv2v_tmp_fpu_ss_controller_i_x_mem_req_we_o),
		.x_mem_req_spec_o(sv2v_tmp_fpu_ss_controller_i_x_mem_req_spec_o),
		.x_mem_req_last_o(sv2v_tmp_fpu_ss_controller_i_x_mem_req_last_o),
		.mem_push_valid_o(mem_push_valid),
		.mem_push_ready_i(mem_push_ready),
		.mem_pop_ready_o(mem_pop_ready),
		.mem_pop_data_i(mem_pop_data),
		.x_mem_result_valid_i(x_mem_result_valid_i),
		.fpu_in_valid_o(fpu_in_valid),
		.fpu_in_ready_i(fpu_in_ready),
		.use_fpu_i(use_fpu),
		.fpu_in_id_i(in_buf_pop_data[5-:4]),
		.fpu_out_valid_i(fpu_out_valid),
		.fpu_out_ready_o(fpu_out_ready),
		.x_result_ready_i(x_result_ready_i),
		.x_result_valid_o(x_result_valid_o),
		.csr_instr_i(csr_instr)
	);
	generate
		if (!PULP_ZFINX) begin : gen_fp_register_file
			always @(*) begin
				if (_sv2v_0)
					;
				fpr_raddr[0+:5] = rs1;
				fpr_raddr[5+:5] = rs2;
				fpr_raddr[10+:5] = rs3;
				(* full_case, parallel_case *)
				case (op_select_dec[3+:3])
					3'd2: fpr_raddr[5+:5] = rs1;
					default:
						;
				endcase
				(* full_case, parallel_case *)
				case (op_select_dec[6+:3])
					3'd3, 3'd5: fpr_raddr[10+:5] = rs2;
					3'd6: fpr_raddr[10+:5] = rd;
					default:
						;
				endcase
			end
			always @(*) begin
				if (_sv2v_0)
					;
				fpr_wb_data = fpu_result;
				if (x_mem_result_valid_i)
					fpr_wb_data = x_mem_result_i[33-:32];
			end
			always @(*) begin
				if (_sv2v_0)
					;
				fpr_wb_addr = fpu_tag_out[9-:5];
				if (x_mem_result_valid_i)
					fpr_wb_addr = mem_pop_data[5-:5];
				else if (~use_fpu & ~fpu_out_valid)
					fpr_wb_addr = rd;
			end
			fpu_ss_regfile fpu_ss_regfile_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.raddr_i(fpr_raddr),
				.rdata_o(fpr_operands),
				.waddr_i(fpr_wb_addr),
				.wdata_i(fpr_wb_data),
				.we_i(fpr_we)
			);
		end
		else begin : gen_no_fp_register_file
			assign fpr_operands = int_operands;
		end
	endgenerate
	genvar _gv_i_23;
	generate
		for (_gv_i_23 = 0; _gv_i_23 < 3; _gv_i_23 = _gv_i_23 + 1) begin : genblk3
			localparam i = _gv_i_23;
			always @(*) begin
				if (_sv2v_0)
					;
				op_select[i * 3+:3] = op_select_dec[i * 3+:3];
				if (PULP_ZFINX)
					(* full_case, parallel_case *)
					case (op_select_dec[i * 3+:3])
						3'd0, 3'd1: op_select[i * 3+:3] = op_select_dec[i * 3+:3];
						3'd2, 3'd3, 3'd5, 3'd4, 3'd6: op_select[i * 3+:3] = 3'd1;
					endcase
			end
		end
	endgenerate
	genvar _gv_i_24;
	function automatic [3:0] sv2v_cast_7BCAE;
		input reg [3:0] inp;
		sv2v_cast_7BCAE = inp;
	endfunction
	function automatic [2:0] sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_cast_9FB13 = inp;
	endfunction
	generate
		for (_gv_i_24 = 0; _gv_i_24 < 3; _gv_i_24 = _gv_i_24 + 1) begin : gen_operand_select
			localparam i = _gv_i_24;
			always @(*) begin
				if (_sv2v_0)
					;
				(* full_case, parallel_case *)
				case (op_select[i * 3+:3])
					3'd0: fpu_operands_dec[i * 32+:32] = 1'sb1;
					3'd1: begin
						fpu_operands_dec[i * 32+:32] = int_operands[i * 32+:32];
						if (fpu_fwd[i])
							fpu_operands_dec[i * 32+:32] = fpu_result;
					end
					3'd2, 3'd3, 3'd5, 3'd4, 3'd6: begin
						fpu_operands_dec[i * 32+:32] = fpr_operands[i * 32+:32];
						if (fpu_fwd[i] & (fpu_op != sv2v_cast_7BCAE(2)))
							fpu_operands_dec[i * 32+:32] = fpu_result;
						else if (lsu_fwd[i] & (fpu_op != sv2v_cast_7BCAE(2)))
							fpu_operands_dec[i * 32+:32] = x_mem_result_i[33-:32];
						if (op_select[i * 3+:3] == 3'd5)
							(* full_case, parallel_case *)
							case (src_fmt)
								sv2v_cast_9FB13('d0): fpu_operands_dec[i * 32+:32] = {fpu_operands_dec[(i * 32) + 31-:32]};
								sv2v_cast_9FB13('d2), sv2v_cast_9FB13('d4): fpu_operands_dec[i * 32+:32] = {2 {fpu_operands_dec[(i * 32) + 15-:16]}};
								sv2v_cast_9FB13('d3): fpu_operands_dec[i * 32+:32] = {4 {fpu_operands_dec[(i * 32) + 7-:8]}};
								default: fpu_operands_dec[i * 32+:32] = fpu_operands_dec[(i * 32) + 31-:32];
							endcase
					end
					default: fpu_operands_dec[i * 32+:32] = 1'sb0;
				endcase
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		fpu_operands = fpu_operands_dec;
		if (PULP_ZFINX) begin
			if (op_select_dec[3+:3] == 3'd2)
				fpu_operands[32+:32] = int_operands[0+:32];
			if (op_select_dec[6+:3] == 3'd3)
				fpu_operands[64+:32] = int_operands[32+:32];
		end
		else begin
			if ((lsu_fwd[1] & (fpu_op == sv2v_cast_7BCAE(2))) & use_fpu)
				fpu_operands[32+:32] = x_mem_result_i[33-:32];
			if ((lsu_fwd[2] & (fpu_op == sv2v_cast_7BCAE(2))) & use_fpu)
				fpu_operands[64+:32] = x_mem_result_i[33-:32];
			if ((fpu_fwd[1] & (fpu_op == sv2v_cast_7BCAE(2))) & use_fpu)
				fpu_operands[32+:32] = fpu_result;
			if ((fpu_fwd[2] & (fpu_op == sv2v_cast_7BCAE(2))) & use_fpu)
				fpu_operands[64+:32] = fpu_result;
		end
	end
	function automatic [1:0] sv2v_cast_2D3A8;
		input reg [1:0] inp;
		sv2v_cast_2D3A8 = inp;
	endfunction
	localparam [42:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_RV64D_Xsflt = 43'h000000207ff;
	localparam [42:0] sv2v_uu_i_fpnew_bulk_Features = FPU_FEATURES;
	localparam [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_NUM_FP_FORMATS = 5;
	localparam [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_NUM_INT_FORMATS = 4;
	localparam [319:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_FP_ENCODINGS = 320'h8000000170000000b00000034000000050000000a00000005000000020000000800000007;
	localparam [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_FP_FORMAT_BITS = 3;
	function automatic [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_fp_width;
		input reg [2:0] fmt;
		sv2v_uu_i_fpnew_bulk_fpnew_pkg_fp_width = (sv2v_uu_i_fpnew_bulk_fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 63-:32] + sv2v_uu_i_fpnew_bulk_fpnew_pkg_FP_ENCODINGS[((4 - fmt) * 64) + 31-:32]) + 1;
	endfunction
	function automatic signed [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_maximum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		sv2v_uu_i_fpnew_bulk_fpnew_pkg_maximum = (a > b ? a : b);
	endfunction
	function automatic [2:0] sv2v_uu_i_fpnew_bulk_sv2v_cast_9FB13;
		input reg [2:0] inp;
		sv2v_uu_i_fpnew_bulk_sv2v_cast_9FB13 = inp;
	endfunction
	function automatic [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_max_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = 0;
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < sv2v_uu_i_fpnew_bulk_fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(sv2v_uu_i_fpnew_bulk_fpnew_pkg_maximum(res, sv2v_uu_i_fpnew_bulk_fpnew_pkg_fp_width(sv2v_uu_i_fpnew_bulk_sv2v_cast_9FB13(i))));
			end
			sv2v_uu_i_fpnew_bulk_fpnew_pkg_max_fp_width = res;
		end
	endfunction
	function automatic signed [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_minimum;
		input reg signed [31:0] a;
		input reg signed [31:0] b;
		sv2v_uu_i_fpnew_bulk_fpnew_pkg_minimum = (a < b ? a : b);
	endfunction
	function automatic [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_min_fp_width;
		input reg [0:4] cfg;
		reg [31:0] res;
		begin
			res = sv2v_uu_i_fpnew_bulk_fpnew_pkg_max_fp_width(cfg);
			begin : sv2v_autoblock_2
				reg [31:0] i;
				for (i = 0; i < sv2v_uu_i_fpnew_bulk_fpnew_pkg_NUM_FP_FORMATS; i = i + 1)
					if (cfg[i])
						res = $unsigned(sv2v_uu_i_fpnew_bulk_fpnew_pkg_minimum(res, sv2v_uu_i_fpnew_bulk_fpnew_pkg_fp_width(sv2v_uu_i_fpnew_bulk_sv2v_cast_9FB13(i))));
			end
			sv2v_uu_i_fpnew_bulk_fpnew_pkg_min_fp_width = res;
		end
	endfunction
	function automatic [31:0] sv2v_uu_i_fpnew_bulk_fpnew_pkg_max_num_lanes;
		input reg [31:0] width;
		input reg [0:4] cfg;
		input reg vec;
		sv2v_uu_i_fpnew_bulk_fpnew_pkg_max_num_lanes = (vec ? width / sv2v_uu_i_fpnew_bulk_fpnew_pkg_min_fp_width(cfg) : 1);
	endfunction
	localparam [31:0] sv2v_uu_i_fpnew_bulk_NumLanes = sv2v_uu_i_fpnew_bulk_fpnew_pkg_max_num_lanes(sv2v_uu_i_fpnew_bulk_Features[42-:32], sv2v_uu_i_fpnew_bulk_Features[8-:5], sv2v_uu_i_fpnew_bulk_Features[10]);
	localparam [sv2v_uu_i_fpnew_bulk_NumLanes - 1:0] sv2v_uu_i_fpnew_bulk_ext_simd_mask_i_0 = 1'sb0;
	fpnew_top_2591D #(
		.PulpDivsqrt(PulpDivsqrt),
		.Features(FPU_FEATURES),
		.Implementation(FPU_IMPLEMENTATION)
	) i_fpnew_bulk(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.operands_i(fpu_operands),
		.rnd_mode_i(fpu_rnd_mode),
		.op_i(sv2v_cast_7BCAE(fpu_op)),
		.op_mod_i(op_mode),
		.src_fmt_i(sv2v_cast_9FB13(src_fmt)),
		.dst_fmt_i(sv2v_cast_9FB13(dst_fmt)),
		.int_fmt_i(sv2v_cast_2D3A8(int_fmt)),
		.vectorial_op_i(vectorial_op),
		.tag_i(fpu_tag_in),
		.simd_mask_i(sv2v_uu_i_fpnew_bulk_ext_simd_mask_i_0),
		.in_valid_i(fpu_in_valid),
		.in_ready_o(fpu_in_ready),
		.flush_i(1'b0),
		.result_o(fpu_result),
		.status_o(fpu_status),
		.tag_o(fpu_tag_out),
		.out_valid_o(fpu_out_valid),
		.out_ready_i(fpu_out_ready),
		.busy_o(fpu_busy)
	);
	wire [1:1] sv2v_tmp_2715B;
	assign sv2v_tmp_2715B = 1'b0;
	always @(*) x_result_o[8] = sv2v_tmp_2715B;
	wire [6:1] sv2v_tmp_7A551;
	assign sv2v_tmp_7A551 = 1'sb0;
	always @(*) x_result_o[7-:6] = sv2v_tmp_7A551;
	always @(*) begin
		if (_sv2v_0)
			;
		x_result_o[fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))-:((37 + ((32'sd32 / 32'sd32) + 17)) >= (5 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) + 1 : ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) + 1)] = fpu_result;
		if (((csr_wb & ~fpu_out_valid) & csr_wb) & ~fpu_out_valid)
			x_result_o[fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))-:((37 + ((32'sd32 / 32'sd32) + 17)) >= (5 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) + 1 : ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) + 1)] = sv2v_cast_32($unsigned(csr_wb_addr));
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_result_o[5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)-:((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) >= ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) ? ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) + 1 : (((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) + 1)] = 1'sb0;
		x_result_o[fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)))) + 1 : ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) - (fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))))) + 1)] = 1'sb0;
		if ((fpu_out_valid & x_result_valid_o) & x_result_ready_i) begin
			x_result_o[5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)-:((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) >= ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) ? ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) + 1 : (((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) + 1)] = fpu_tag_out[9-:5];
			x_result_o[fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)))) + 1 : ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) - (fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))))) + 1)] = fpu_tag_out[3-:4];
		end
		else if ((x_result_valid_o & x_result_ready_i) & ~fpu_out_valid) begin
			x_result_o[5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)-:((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) >= ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) ? ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) + 1 : (((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) + 1)] = csr_wb_addr;
			x_result_o[fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)))) + 1 : ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) - (fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))))) + 1)] = csr_wb_id;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_result_o[(fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17-:(((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17) >= 18 ? (fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 0 : 19 - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))] = 1'b0;
		if ((fpu_out_valid & ~fpu_tag_out[4]) | csr_wb)
			x_result_o[(fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17-:(((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17) >= 18 ? (fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 0 : 19 - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))] = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_result_o[11-:3] = 1'sb0;
		x_result_o[17-:6] = 1'sb0;
		if (((fpu_out_valid & x_result_valid_o) & x_result_ready_i) & fpu_tag_out[4]) begin
			x_result_o[11-:3] = 3'b010;
			x_result_o[17-:6] = 6'b001100;
		end
	end
	initial _sv2v_0 = 0;
endmodule
module fpu_ss_wrapper (
	clk_i,
	rst_ni,
	s_xif_issue_valid,
	s_xif_issue_req_instr,
	s_xif_issue_req_mode,
	s_xif_issue_req_id,
	s_xif_issue_req_rs_0,
	s_xif_issue_req_rs_1,
	s_xif_issue_req_rs_2,
	s_xif_issue_req_rs_valid,
	s_xif_issue_ready,
	s_xif_issue_resp_accept,
	s_xif_issue_resp_writeback,
	s_xif_issue_resp_dualwrite,
	s_xif_issue_resp_dualread,
	s_xif_issue_resp_loadstore,
	s_xif_issue_resp_exc,
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
	input wire [31:0] s_xif_issue_req_rs_2;
	input wire [2:0] s_xif_issue_req_rs_valid;
	output wire s_xif_issue_ready;
	output wire s_xif_issue_resp_accept;
	output wire s_xif_issue_resp_writeback;
	output wire s_xif_issue_resp_dualwrite;
	output wire [2:0] s_xif_issue_resp_dualread;
	output wire s_xif_issue_resp_loadstore;
	output wire s_xif_issue_resp_exc;
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
	wire x_compressed_ready_o;
	wire [32:0] x_compressed_resp_o;
	wire [8:0] x_issue_resp_o;
	wire x_issue_ready_o;
	wire x_mem_valid_o;
	localparam signed [31:0] fpu_ss_pkg_X_ID_WIDTH = 4;
	localparam signed [31:0] fpu_ss_pkg_X_MEM_WIDTH = 32;
	wire [81:0] x_mem_req_o;
	wire x_result_valid_o;
	localparam signed [31:0] fpu_ss_pkg_XLEN = 32;
	localparam signed [31:0] fpu_ss_pkg_X_RFW_WIDTH = 32;
	wire [(((fpu_ss_pkg_X_ID_WIDTH + fpu_ss_pkg_X_RFW_WIDTH) + 5) + (fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN)) + 17:0] x_result_o;
	assign s_xif_issue_ready = x_issue_ready_o;
	assign s_xif_issue_resp_accept = x_issue_resp_o[8];
	assign s_xif_issue_resp_writeback = x_issue_resp_o[7];
	assign s_xif_issue_resp_dualwrite = x_issue_resp_o[6];
	assign s_xif_issue_resp_dualread = x_issue_resp_o[5-:3];
	assign s_xif_issue_resp_loadstore = x_issue_resp_o[2];
	assign s_xif_issue_resp_exc = x_issue_resp_o[0];
	assign s_xif_mem_valid = x_mem_valid_o;
	assign s_xif_mem_req_id = x_mem_req_o[81-:4];
	assign s_xif_mem_req_addr = x_mem_req_o[77-:32];
	assign s_xif_mem_req_mode = x_mem_req_o[45-:2];
	assign s_xif_mem_req_we = x_mem_req_o[43];
	assign s_xif_mem_req_size = x_mem_req_o[42-:3];
	assign s_xif_mem_req_be = x_mem_req_o[39-:4];
	assign s_xif_mem_req_wdata = x_mem_req_o[33-:32];
	assign s_xif_mem_req_last = x_mem_req_o[1];
	wire [7:0] x_mem_resp;
	assign x_mem_resp[7] = s_xif_mem_resp_exc;
	assign x_mem_resp[6-:6] = s_xif_mem_resp_exccode;
	assign x_mem_resp[0] = 1'b0;
	wire [(fpu_ss_pkg_X_ID_WIDTH + fpu_ss_pkg_X_MEM_WIDTH) + 1:0] x_mem_result;
	assign x_mem_result[37-:4] = s_xif_mem_result_id;
	assign x_mem_result[33-:32] = s_xif_mem_result_rdata;
	assign x_mem_result[1] = s_xif_mem_result_err;
	assign x_mem_result[0] = 1'b0;
	assign s_xif_result_valid = x_result_valid_o;
	assign s_xif_result_id = x_result_o[fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))-:((41 + ((32'sd32 / 32'sd32) + 17)) >= (37 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)))) + 1 : ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) - (fpu_ss_pkg_X_ID_WIDTH + (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))))) + 1)];
	assign s_xif_result_data = x_result_o[fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))-:((37 + ((32'sd32 / 32'sd32) + 17)) >= (5 + ((32'sd32 / 32'sd32) + 18)) ? ((fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18))) + 1 : ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) - (fpu_ss_pkg_X_RFW_WIDTH + (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)))) + 1)];
	assign s_xif_result_rd = x_result_o[5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)-:((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) >= ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) ? ((5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17)) - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18)) + 1 : (((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 18) - (5 + ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))) + 1)];
	assign s_xif_result_we = |x_result_o[(fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17-:(((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17) >= 18 ? (fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 0 : 19 - ((fpu_ss_pkg_X_RFW_WIDTH / fpu_ss_pkg_XLEN) + 17))];
	assign s_xif_result_exc = x_result_o[8];
	assign s_xif_result_exccode = x_result_o[7-:6];
	localparam signed [31:0] fpu_ss_pkg_X_NUM_RS = 3;
	localparam signed [31:0] fpu_ss_pkg_X_RFR_WIDTH = 32;
	wire [((38 + (fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH)) + fpu_ss_pkg_X_NUM_RS) + 6:0] x_issue_req;
	assign x_issue_req[34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))-:((38 + ((32'sd3 * 32'sd32) + 9)) >= (6 + ((32'sd3 * 32'sd32) + 10)) ? ((34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) - (2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)))) + 1 : ((2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10))) - (34 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)))) + 1)] = s_xif_issue_req_instr;
	assign x_issue_req[2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))-:((6 + ((32'sd3 * 32'sd32) + 9)) >= (32'sd4 + ((32'sd3 * 32'sd32) + 10)) ? ((2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) - (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10))) + 1 : ((fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)) - (2 + (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)))) + 1)] = s_xif_issue_req_mode;
	assign x_issue_req[fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)-:((fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)) >= ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10) ? ((fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9)) - ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10)) + 1 : (((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 10) - (fpu_ss_pkg_X_ID_WIDTH + ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))) + 1)] = s_xif_issue_req_id;
	assign x_issue_req[(fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9-:(((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9) >= 10 ? fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH : 11 - ((fpu_ss_pkg_X_NUM_RS * fpu_ss_pkg_X_RFR_WIDTH) + 9))] = {s_xif_issue_req_rs_2, s_xif_issue_req_rs_1, s_xif_issue_req_rs_0};
	assign x_issue_req[9-:3] = s_xif_issue_req_rs_valid;
	assign x_issue_req[6-:6] = 6'h00;
	assign x_issue_req[0] = 1'b0;
	wire [4:0] x_commit;
	assign x_commit[4-:4] = s_xif_commit_id;
	assign x_commit[0] = s_xif_commit_kill;
	localparam signed [31:0] sv2v_uu_fpu_ss_i_fpu_ss_pkg_X_ID_WIDTH = 4;
	localparam [21:0] sv2v_uu_fpu_ss_i_ext_x_compressed_req_i_0 = 1'sb0;
	fpu_ss #(
		.PULP_ZFINX(1),
		.INPUT_BUFFER_DEPTH(2),
		.OUT_OF_ORDER(1),
		.FORWARDING(1),
		.PulpDivsqrt(1'b1)
	) fpu_ss_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.x_compressed_valid_i(1'b0),
		.x_compressed_req_i(sv2v_uu_fpu_ss_i_ext_x_compressed_req_i_0),
		.x_compressed_ready_o(x_compressed_ready_o),
		.x_compressed_resp_o(x_compressed_resp_o),
		.x_issue_valid_i(s_xif_issue_valid),
		.x_issue_ready_o(x_issue_ready_o),
		.x_issue_req_i(x_issue_req),
		.x_issue_resp_o(x_issue_resp_o),
		.x_commit_valid_i(s_xif_commit_valid),
		.x_commit_i(x_commit),
		.x_mem_valid_o(x_mem_valid_o),
		.x_mem_ready_i(s_xif_mem_ready),
		.x_mem_req_o(x_mem_req_o),
		.x_mem_resp_i(x_mem_resp),
		.x_mem_result_valid_i(s_xif_mem_result_valid),
		.x_mem_result_i(x_mem_result),
		.x_result_valid_o(x_result_valid_o),
		.x_result_ready_i(s_xif_result_ready),
		.x_result_o(x_result_o)
	);
endmodule