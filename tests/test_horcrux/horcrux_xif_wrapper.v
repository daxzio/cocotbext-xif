module sampler (
	data_i,
	index_i,
	insn_i,
	result_o
);
	reg _sv2v_0;
	input wire [31:0] data_i;
	input wire [31:0] index_i;
	input wire [6:0] insn_i;
	output reg [31:0] result_o;
	localparam [22:0] Q_MLDSA = 23'd8380417;
	localparam [17:0] GAMMA1 = 18'd131072;
	reg [2:0] eta;
	reg [5:0] stride;
	reg [31:0] mask;
	reg [31:0] sh_a;
	reg [31:0] sh_b;
	reg [31:0] a_bits;
	reg [31:0] b_bits;
	reg signed [7:0] cbd_diff;
	reg [4:0] j_masked;
	reg [31:0] cbd_result;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (insn_i)
			7'b0001100: eta = 3'd1;
			7'b0001101: eta = 3'd2;
			7'b0001110: eta = 3'd3;
			7'b0001111: eta = 3'd4;
			default: eta = 3'd0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		j_masked = index_i[4:0];
		stride = {eta, 1'b0};
		mask = (32'h00000001 << eta) - 32'h00000001;
		sh_a = j_masked * stride;
		sh_b = sh_a + {29'b00000000000000000000000000000, eta};
		a_bits = (data_i >> sh_a) & mask;
		b_bits = (data_i >> sh_b) & mask;
		cbd_diff = $signed(a_bits[7:0]) - $signed(b_bits[7:0]);
		cbd_result = $signed(cbd_diff);
	end
	wire [22:0] rej_uniform_t;
	wire rej_uniform_valid;
	wire [31:0] rej_uniform_result;
	assign rej_uniform_t = data_i[22:0];
	assign rej_uniform_valid = rej_uniform_t < Q_MLDSA;
	assign rej_uniform_result = (rej_uniform_valid ? {9'b100000000, rej_uniform_t} : 32'd0);
	wire [3:0] rej_eta_nibble;
	wire rej_eta_nibble_sel;
	wire rej_eta2_valid;
	wire rej_eta4_valid;
	wire [31:0] rej_eta2_result;
	wire [31:0] rej_eta4_result;
	wire [13:0] rej_eta2_mult;
	wire [3:0] rej_eta2_div5;
	wire [4:0] rej_eta2_mod5_sub;
	wire [3:0] rej_eta2_mod5;
	wire signed [2:0] rej_eta2_coeff;
	wire signed [3:0] rej_eta4_coeff;
	assign rej_eta_nibble_sel = index_i[0];
	assign rej_eta_nibble = (rej_eta_nibble_sel ? data_i[7:4] : data_i[3:0]);
	assign rej_eta2_mult = 12'd205 * {8'b00000000, rej_eta_nibble};
	assign rej_eta2_div5 = rej_eta2_mult[13:10];
	assign rej_eta2_mod5_sub = rej_eta2_div5 * 4'd5;
	assign rej_eta2_mod5 = rej_eta_nibble - rej_eta2_mod5_sub[3:0];
	assign rej_eta2_coeff = 3'sd2 - $signed({1'b0, rej_eta2_mod5[2:0]});
	assign rej_eta2_valid = rej_eta_nibble < 4'd15;
	assign rej_eta2_result = (rej_eta2_valid ? {1'b1, {28 {rej_eta2_coeff[2]}}, rej_eta2_coeff} : 32'd0);
	assign rej_eta4_coeff = 4'sd4 - $signed({1'b0, rej_eta_nibble[2:0]});
	assign rej_eta4_valid = rej_eta_nibble < 4'd9;
	assign rej_eta4_result = (rej_eta4_valid ? {1'b1, {27 {rej_eta4_coeff[3]}}, rej_eta4_coeff} : 32'd0);
	reg [17:0] unpack_z_raw;
	wire signed [31:0] unpack_z_result;
	wire [1:0] unpack_z_sel;
	assign unpack_z_sel = index_i[1:0];
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (unpack_z_sel)
			2'd0: unpack_z_raw = data_i[17:0];
			2'd1: unpack_z_raw = data_i[19:2];
			2'd2: unpack_z_raw = data_i[21:4];
			2'd3: unpack_z_raw = data_i[23:6];
			default: unpack_z_raw = 18'd0;
		endcase
	end
	assign unpack_z_result = $signed({14'b00000000000000, GAMMA1}) - $signed({14'b00000000000000, unpack_z_raw});
	always @(*) begin
		if (_sv2v_0)
			;
		result_o = 32'd0;
		(* full_case, parallel_case *)
		case (insn_i)
			7'b0001100, 7'b0001101, 7'b0001110, 7'b0001111: result_o = cbd_result;
			7'b1001000: result_o = rej_uniform_result;
			7'b1001001: result_o = rej_eta2_result;
			7'b1001010: result_o = rej_eta4_result;
			7'b1001011: result_o = unpack_z_result;
			default: result_o = 32'd0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module keccak_cu (
	clk_i,
	rst_ni,
	start_i,
	ready_dp_i,
	start_dp_o,
	status_d,
	keccak_intr
);
	reg _sv2v_0;
	input wire clk_i;
	input wire rst_ni;
	input wire start_i;
	input wire ready_dp_i;
	output reg start_dp_o;
	output reg status_d;
	output reg keccak_intr;
	parameter wait_start = 0;
	parameter do_permutation = 1;
	parameter permutation_finished = 2;
	reg [4:0] counter;
	reg [1:0] State;
	reg [1:0] State_next;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			State <= wait_start;
			counter <= 0;
		end
		else begin
			if (State_next == do_permutation)
				counter <= counter + 1;
			else
				counter <= 0;
			State <= State_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		case (State)
			wait_start: begin
				keccak_intr = 0;
				status_d = 0;
				if (start_i && ready_dp_i) begin
					start_dp_o = 1;
					State_next = do_permutation;
				end
				else begin
					start_dp_o = 0;
					State_next = wait_start;
				end
			end
			do_permutation: begin
				start_dp_o = 0;
				status_d = 0;
				keccak_intr = 0;
				if (counter == 24)
					State_next = permutation_finished;
				else
					State_next = do_permutation;
			end
			permutation_finished: begin
				start_dp_o = 0;
				status_d = 1;
				keccak_intr = 1;
				State_next = wait_start;
			end
			default: begin
				start_dp_o = 0;
				status_d = 0;
				keccak_intr = 0;
				State_next = wait_start;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module keccak_dp (
	clk,
	rst_n,
	start_i,
	Din,
	ready_o,
	Dout
);
	input clk;
	input rst_n;
	input start_i;
	input [1599:0] Din;
	output wire ready_o;
	output wire [1599:0] Dout;
	localparam signed [31:0] pkg_keccak_NUM_PLANE = 5;
	localparam signed [31:0] pkg_keccak_NUM_SHEET = 5;
	localparam [31:0] pkg_keccak_KEC_N = 64;
	reg [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] reg_data;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] round_in;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] round_out;
	reg [4:0] counter_nr_rounds;
	wire [7:0] round_constant_signal;
	reg compute_permutation;
	reg permutation_computed;
	keccak_round round_map(
		.Round_in(round_in),
		.Round_constant_signal(round_constant_signal),
		.Round_out(round_out)
	);
	keccak_round_constants_gen round_constants_gen(
		.round_number(counter_nr_rounds),
		.round_constant_signal_out(round_constant_signal)
	);
	genvar _gv_y_1;
	genvar _gv_x_1;
	genvar _gv_i_1;
	generate
		for (_gv_y_1 = 0; _gv_y_1 < 5; _gv_y_1 = _gv_y_1 + 1) begin : g_y
			localparam y = _gv_y_1;
			for (_gv_x_1 = 0; _gv_x_1 < 5; _gv_x_1 = _gv_x_1 + 1) begin : g_x
				localparam x = _gv_x_1;
				for (_gv_i_1 = 0; _gv_i_1 < 64; _gv_i_1 = _gv_i_1 + 1) begin : g_bit
					localparam i = _gv_i_1;
					assign Dout[((320 * y) + (64 * x)) + i] = reg_data[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i];
				end
			end
		end
	endgenerate
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			reg_data <= 1'sb0;
			counter_nr_rounds <= 1'sb0;
			permutation_computed <= 1'b1;
			compute_permutation <= 1'b0;
		end
		else if (start_i) begin
			reg_data <= 1'sb0;
			counter_nr_rounds <= 1'sb0;
			compute_permutation <= 1'b1;
			permutation_computed <= 1'b1;
		end
		else if (compute_permutation && permutation_computed) begin
			counter_nr_rounds <= 5'b00001;
			permutation_computed <= 1'b0;
			reg_data <= round_out;
		end
		else begin
			if ((counter_nr_rounds < 24) && !permutation_computed) begin
				counter_nr_rounds <= counter_nr_rounds + 1'b1;
				reg_data <= round_out;
			end
			if (counter_nr_rounds == 23) begin
				permutation_computed <= 1'b1;
				compute_permutation <= 1'b0;
				counter_nr_rounds <= 1'sb0;
			end
		end
	generate
		for (_gv_y_1 = 0; _gv_y_1 < 5; _gv_y_1 = _gv_y_1 + 1) begin : g_y2
			localparam y = _gv_y_1;
			for (_gv_x_1 = 0; _gv_x_1 < 5; _gv_x_1 = _gv_x_1 + 1) begin : g_x2
				localparam x = _gv_x_1;
				for (_gv_i_1 = 0; _gv_i_1 < 64; _gv_i_1 = _gv_i_1 + 1) begin : g_bit2
					localparam i = _gv_i_1;
					assign round_in[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] = reg_data[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] ^ (Din[((320 * y) + (64 * x)) + i] & permutation_computed);
				end
			end
		end
	endgenerate
	assign ready_o = permutation_computed;
endmodule
module keccak_round_constants_gen (
	round_number,
	round_constant_signal_out
);
	reg _sv2v_0;
	input [4:0] round_number;
	output reg [7:0] round_constant_signal_out;
	always @(*) begin
		if (_sv2v_0)
			;
		case (round_number)
			5'b00000: round_constant_signal_out = 8'h01;
			5'b00001: round_constant_signal_out = 8'h32;
			5'b00010: round_constant_signal_out = 8'hba;
			5'b00011: round_constant_signal_out = 8'he0;
			5'b00100: round_constant_signal_out = 8'h3b;
			5'b00101: round_constant_signal_out = 8'h41;
			5'b00110: round_constant_signal_out = 8'hf1;
			5'b00111: round_constant_signal_out = 8'ha9;
			5'b01000: round_constant_signal_out = 8'h1a;
			5'b01001: round_constant_signal_out = 8'h18;
			5'b01010: round_constant_signal_out = 8'h69;
			5'b01011: round_constant_signal_out = 8'h4a;
			5'b01100: round_constant_signal_out = 8'h7b;
			5'b01101: round_constant_signal_out = 8'h9b;
			5'b01110: round_constant_signal_out = 8'hb9;
			5'b01111: round_constant_signal_out = 8'ha3;
			5'b10000: round_constant_signal_out = 8'ha2;
			5'b10001: round_constant_signal_out = 8'h90;
			5'b10010: round_constant_signal_out = 8'h2a;
			5'b10011: round_constant_signal_out = 8'hca;
			5'b10100: round_constant_signal_out = 8'hf1;
			5'b10101: round_constant_signal_out = 8'hb0;
			5'b10110: round_constant_signal_out = 8'h41;
			5'b10111: round_constant_signal_out = 8'he8;
			default: round_constant_signal_out = 1'sb0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module keccak_round (
	Round_in,
	Round_constant_signal,
	Round_out
);
	reg _sv2v_0;
	localparam signed [31:0] pkg_keccak_NUM_PLANE = 5;
	localparam signed [31:0] pkg_keccak_NUM_SHEET = 5;
	localparam [31:0] pkg_keccak_KEC_N = 64;
	input wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] Round_in;
	input [7:0] Round_constant_signal;
	output wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] Round_out;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] theta_in;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] theta_out;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] pi_in;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] pi_out;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] rho_in;
	reg [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] rho_out;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] chi_in;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] chi_out;
	wire [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] iota_in;
	reg [((pkg_keccak_NUM_PLANE * pkg_keccak_NUM_SHEET) * 64) - 1:0] iota_out;
	wire [(pkg_keccak_NUM_SHEET * pkg_keccak_KEC_N) - 1:0] sum_sheet;
	assign theta_in = Round_in;
	assign pi_in = rho_out;
	assign rho_in = theta_out;
	assign chi_in = pi_out;
	assign iota_in = chi_out;
	assign Round_out = iota_out;
	genvar _gv_y_2;
	genvar _gv_x_2;
	genvar _gv_i_2;
	generate
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk1
			localparam y = _gv_y_2;
			for (_gv_x_2 = 0; _gv_x_2 <= 2; _gv_x_2 = _gv_x_2 + 1) begin : genblk1
				localparam x = _gv_x_2;
				for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
					localparam i = _gv_i_2;
					assign chi_out[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] = chi_in[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] ^ (~chi_in[(((y * pkg_keccak_NUM_SHEET) + (x + 1)) * 64) + i] & chi_in[(((y * pkg_keccak_NUM_SHEET) + (x + 2)) * 64) + i]);
				end
			end
		end
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk2
			localparam y = _gv_y_2;
			for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
				localparam i = _gv_i_2;
				assign chi_out[(((y * pkg_keccak_NUM_SHEET) + 3) * 64) + i] = chi_in[(((y * pkg_keccak_NUM_SHEET) + 3) * 64) + i] ^ (~chi_in[(((y * pkg_keccak_NUM_SHEET) + 4) * 64) + i] & chi_in[((y * pkg_keccak_NUM_SHEET) * 64) + i]);
			end
		end
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk3
			localparam y = _gv_y_2;
			for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
				localparam i = _gv_i_2;
				assign chi_out[(((y * pkg_keccak_NUM_SHEET) + 4) * 64) + i] = chi_in[(((y * pkg_keccak_NUM_SHEET) + 4) * 64) + i] ^ (~chi_in[((y * pkg_keccak_NUM_SHEET) * 64) + i] & chi_in[(((y * pkg_keccak_NUM_SHEET) + 1) * 64) + i]);
			end
		end
		for (_gv_x_2 = 0; _gv_x_2 <= 4; _gv_x_2 = _gv_x_2 + 1) begin : genblk4
			localparam x = _gv_x_2;
			for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
				localparam i = _gv_i_2;
				assign sum_sheet[(x * pkg_keccak_KEC_N) + i] = (((theta_in[((0 + x) * 64) + i] ^ theta_in[((pkg_keccak_NUM_SHEET + x) * 64) + i]) ^ theta_in[((10 + x) * 64) + i]) ^ theta_in[((15 + x) * 64) + i]) ^ theta_in[((20 + x) * 64) + i];
			end
		end
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk5
			localparam y = _gv_y_2;
			for (_gv_x_2 = 1; _gv_x_2 <= 3; _gv_x_2 = _gv_x_2 + 1) begin : genblk1
				localparam x = _gv_x_2;
				assign theta_out[((y * pkg_keccak_NUM_SHEET) + x) * 64] = (theta_in[((y * pkg_keccak_NUM_SHEET) + x) * 64] ^ sum_sheet[(x - 1) * pkg_keccak_KEC_N]) ^ sum_sheet[((x + 1) * pkg_keccak_KEC_N) + 63];
				for (_gv_i_2 = 1; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
					localparam i = _gv_i_2;
					assign theta_out[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] = (theta_in[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] ^ sum_sheet[((x - 1) * pkg_keccak_KEC_N) + i]) ^ sum_sheet[((x + 1) * pkg_keccak_KEC_N) + (i - 1)];
				end
			end
		end
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk6
			localparam y = _gv_y_2;
			assign theta_out[(y * pkg_keccak_NUM_SHEET) * 64] = (theta_in[(y * pkg_keccak_NUM_SHEET) * 64] ^ sum_sheet[256]) ^ sum_sheet[127];
			for (_gv_i_2 = 1; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
				localparam i = _gv_i_2;
				assign theta_out[((y * pkg_keccak_NUM_SHEET) * 64) + i] = (theta_in[((y * pkg_keccak_NUM_SHEET) * 64) + i] ^ sum_sheet[256 + i]) ^ sum_sheet[pkg_keccak_KEC_N + (i - 1)];
			end
		end
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk7
			localparam y = _gv_y_2;
			assign theta_out[((y * pkg_keccak_NUM_SHEET) + 4) * 64] = (theta_in[((y * pkg_keccak_NUM_SHEET) + 4) * 64] ^ sum_sheet[192]) ^ sum_sheet[63];
			for (_gv_i_2 = 1; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
				localparam i = _gv_i_2;
				assign theta_out[(((y * pkg_keccak_NUM_SHEET) + 4) * 64) + i] = (theta_in[(((y * pkg_keccak_NUM_SHEET) + 4) * 64) + i] ^ sum_sheet[192 + i]) ^ sum_sheet[i - 1];
			end
		end
		for (_gv_y_2 = 0; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk8
			localparam y = _gv_y_2;
			for (_gv_x_2 = 0; _gv_x_2 <= 4; _gv_x_2 = _gv_x_2 + 1) begin : genblk1
				localparam x = _gv_x_2;
				for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
					localparam i = _gv_i_2;
					assign pi_out[((((((2 * x) + (3 * y)) % 5) * pkg_keccak_NUM_SHEET) + (0 + (1 * y))) * 64) + i] = pi_in[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i];
				end
			end
		end
	endgenerate
	function automatic signed [31:0] pkg_keccak_ABS;
		input reg signed [31:0] numberIn;
		pkg_keccak_ABS = (numberIn < 0 ? -numberIn : numberIn);
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] ri;
			for (ri = 0; ri < pkg_keccak_KEC_N; ri = ri + 1)
				begin
					rho_out[0 + ri] = rho_in[0 + ri];
					rho_out[64 + ri] = rho_in[64 + pkg_keccak_ABS((ri - 1) % pkg_keccak_KEC_N)];
					rho_out[128 + ri] = rho_in[128 + pkg_keccak_ABS((ri - 62) % pkg_keccak_KEC_N)];
					rho_out[192 + ri] = rho_in[192 + pkg_keccak_ABS((ri - 28) % pkg_keccak_KEC_N)];
					rho_out[256 + ri] = rho_in[256 + pkg_keccak_ABS((ri - 27) % pkg_keccak_KEC_N)];
					rho_out[320 + ri] = rho_in[320 + pkg_keccak_ABS((ri - 36) % pkg_keccak_KEC_N)];
					rho_out[384 + ri] = rho_in[384 + pkg_keccak_ABS((ri - 44) % pkg_keccak_KEC_N)];
					rho_out[448 + ri] = rho_in[448 + pkg_keccak_ABS((ri - 6) % pkg_keccak_KEC_N)];
					rho_out[512 + ri] = rho_in[512 + pkg_keccak_ABS((ri - 55) % pkg_keccak_KEC_N)];
					rho_out[576 + ri] = rho_in[576 + pkg_keccak_ABS((ri - 20) % pkg_keccak_KEC_N)];
					rho_out[640 + ri] = rho_in[640 + pkg_keccak_ABS((ri - 3) % pkg_keccak_KEC_N)];
					rho_out[704 + ri] = rho_in[704 + pkg_keccak_ABS((ri - 10) % pkg_keccak_KEC_N)];
					rho_out[768 + ri] = rho_in[768 + pkg_keccak_ABS((ri - 43) % pkg_keccak_KEC_N)];
					rho_out[832 + ri] = rho_in[832 + pkg_keccak_ABS((ri - 25) % pkg_keccak_KEC_N)];
					rho_out[896 + ri] = rho_in[896 + pkg_keccak_ABS((ri - 39) % pkg_keccak_KEC_N)];
					rho_out[960 + ri] = rho_in[960 + pkg_keccak_ABS((ri - 41) % pkg_keccak_KEC_N)];
					rho_out[1024 + ri] = rho_in[1024 + pkg_keccak_ABS((ri - 45) % pkg_keccak_KEC_N)];
					rho_out[1088 + ri] = rho_in[1088 + pkg_keccak_ABS((ri - 15) % pkg_keccak_KEC_N)];
					rho_out[1152 + ri] = rho_in[1152 + pkg_keccak_ABS((ri - 21) % pkg_keccak_KEC_N)];
					rho_out[1216 + ri] = rho_in[1216 + pkg_keccak_ABS((ri - 8) % pkg_keccak_KEC_N)];
					rho_out[1280 + ri] = rho_in[1280 + pkg_keccak_ABS((ri - 18) % pkg_keccak_KEC_N)];
					rho_out[1344 + ri] = rho_in[1344 + pkg_keccak_ABS((ri - 2) % pkg_keccak_KEC_N)];
					rho_out[1408 + ri] = rho_in[1408 + pkg_keccak_ABS((ri - 61) % pkg_keccak_KEC_N)];
					rho_out[1472 + ri] = rho_in[1472 + pkg_keccak_ABS((ri - 56) % pkg_keccak_KEC_N)];
					rho_out[1536 + ri] = rho_in[1536 + pkg_keccak_ABS((ri - 14) % pkg_keccak_KEC_N)];
				end
		end
	end
	generate
		for (_gv_y_2 = 1; _gv_y_2 <= 4; _gv_y_2 = _gv_y_2 + 1) begin : genblk9
			localparam y = _gv_y_2;
			for (_gv_x_2 = 0; _gv_x_2 <= 4; _gv_x_2 = _gv_x_2 + 1) begin : genblk1
				localparam x = _gv_x_2;
				for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
					localparam i = _gv_i_2;
					wire [1:1] sv2v_tmp_E12D7;
					assign sv2v_tmp_E12D7 = iota_in[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i];
					always @(*) iota_out[(((y * pkg_keccak_NUM_SHEET) + x) * 64) + i] = sv2v_tmp_E12D7;
				end
			end
		end
		for (_gv_x_2 = 1; _gv_x_2 <= 4; _gv_x_2 = _gv_x_2 + 1) begin : genblk10
			localparam x = _gv_x_2;
			for (_gv_i_2 = 0; _gv_i_2 <= 63; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
				localparam i = _gv_i_2;
				wire [1:1] sv2v_tmp_C3775;
				assign sv2v_tmp_C3775 = iota_in[((0 + x) * 64) + i];
				always @(*) iota_out[((0 + x) * 64) + i] = sv2v_tmp_C3775;
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		iota_out[0+:64] = iota_in[0+:64];
		iota_out[0] = iota_in[0] ^ Round_constant_signal[0];
		iota_out[1] = iota_in[1] ^ Round_constant_signal[1];
		iota_out[2] = iota_in[2] ^ Round_constant_signal[2];
		iota_out[3] = iota_in[3] ^ Round_constant_signal[3];
		iota_out[7] = iota_in[7] ^ Round_constant_signal[4];
		iota_out[15] = iota_in[15] ^ Round_constant_signal[5];
		iota_out[31] = iota_in[31] ^ Round_constant_signal[6];
		iota_out[63] = iota_in[63] ^ Round_constant_signal[7];
	end
	initial _sv2v_0 = 0;
endmodule
module keccak_f (
	clk,
	rst_n,
	start_i,
	Din,
	Dout,
	status_d,
	keccak_intr
);
	input clk;
	input rst_n;
	input start_i;
	input [1599:0] Din;
	output wire [1599:0] Dout;
	output wire status_d;
	output wire keccak_intr;
	wire permutation_finish;
	wire start_dp;
	keccak_dp u_dp(
		.clk(clk),
		.rst_n(rst_n),
		.start_i(start_dp),
		.Din(Din),
		.ready_o(permutation_finish),
		.Dout(Dout)
	);
	keccak_cu u_cu(
		.clk_i(clk),
		.rst_ni(rst_n),
		.start_i(start_i),
		.ready_dp_i(permutation_finish),
		.start_dp_o(start_dp),
		.status_d(status_d),
		.keccak_intr(keccak_intr)
	);
endmodule
module horcrux_register (
	clk_i,
	rst_ni,
	horcrux_register_in0_i,
	horcrux_register_in1_i,
	horcrux_register_enable_i,
	horcrux_register_xor_enable_i,
	horcrux_register_init_i,
	horcrux_register_wb_enable_i,
	horcrux_register_wb_data_i,
	horcrux_register_index_i,
	horcrux_register_o
);
	reg _sv2v_0;
	parameter [31:0] NUM_VARIABLES = 50;
	parameter [31:0] VARIABLE_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire [31:0] horcrux_register_in0_i;
	input wire [31:0] horcrux_register_in1_i;
	input wire horcrux_register_enable_i;
	input wire horcrux_register_xor_enable_i;
	input wire horcrux_register_init_i;
	input wire horcrux_register_wb_enable_i;
	input wire [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] horcrux_register_wb_data_i;
	input wire [5:0] horcrux_register_index_i;
	output reg [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] horcrux_register_o;
	reg [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] register_array;
	function automatic [VARIABLE_WIDTH - 1:0] sv2v_cast_27CB1;
		input reg [VARIABLE_WIDTH - 1:0] inp;
		sv2v_cast_27CB1 = inp;
	endfunction
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			register_array <= {NUM_VARIABLES {sv2v_cast_27CB1(1'sb0)}};
		else if (horcrux_register_init_i)
			register_array <= {NUM_VARIABLES {sv2v_cast_27CB1(1'sb0)}};
		else if (horcrux_register_wb_enable_i) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < NUM_VARIABLES; i = i + 1)
				register_array[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] <= horcrux_register_wb_data_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
		end
		else if (horcrux_register_enable_i) begin
			register_array[((NUM_VARIABLES - 1) - horcrux_register_index_i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] <= horcrux_register_in0_i;
			register_array[((NUM_VARIABLES - 1) - (horcrux_register_index_i + 1)) * VARIABLE_WIDTH+:VARIABLE_WIDTH] <= horcrux_register_in1_i;
		end
		else if (horcrux_register_xor_enable_i) begin
			register_array[((NUM_VARIABLES - 1) - horcrux_register_index_i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] <= register_array[((NUM_VARIABLES - 1) - horcrux_register_index_i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] ^ horcrux_register_in0_i;
			register_array[((NUM_VARIABLES - 1) - (horcrux_register_index_i + 1)) * VARIABLE_WIDTH+:VARIABLE_WIDTH] <= register_array[((NUM_VARIABLES - 1) - (horcrux_register_index_i + 1)) * VARIABLE_WIDTH+:VARIABLE_WIDTH] ^ horcrux_register_in1_i;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		horcrux_register_o = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < NUM_VARIABLES; i = i + 1)
				horcrux_register_o[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] = register_array[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
		end
	end
	initial _sv2v_0 = 0;
endmodule
module unified_mul_32x32 (
	a_i,
	b_i,
	carryless_mode_i,
	prod_o
);
	reg _sv2v_0;
	input wire [31:0] a_i;
	input wire [31:0] b_i;
	input wire carryless_mode_i;
	output reg [63:0] prod_o;
	reg [63:0] accumulator;
	reg [63:0] partial_products [31:0];
	function automatic signed [63:0] sv2v_cast_64_signed;
		input reg signed [63:0] inp;
		sv2v_cast_64_signed = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		accumulator = 1'sb0;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				begin
					if (a_i[i]) begin
						if (carryless_mode_i)
							partial_products[i] = {32'b00000000000000000000000000000000, b_i} << i;
						else
							partial_products[i] = sv2v_cast_64_signed($signed(b_i)) << i;
					end
					else
						partial_products[i] = 1'sb0;
					if (carryless_mode_i)
						accumulator = accumulator ^ partial_products[i];
					else if (i < 31)
						accumulator = accumulator + partial_products[i];
					else
						accumulator = accumulator - partial_products[i];
				end
		end
		prod_o = accumulator;
	end
	initial _sv2v_0 = 0;
endmodule
module shared_multiplication_logic (
	op_a_i,
	op_b_i,
	modp_p_i,
	modp_p0i_i,
	mode_i,
	res_lo_o,
	res_hi_o
);
	reg _sv2v_0;
	input wire [31:0] op_a_i;
	input wire [31:0] op_b_i;
	input wire [31:0] modp_p_i;
	input wire [31:0] modp_p0i_i;
	input wire [2:0] mode_i;
	output reg [31:0] res_lo_o;
	output reg [31:0] res_hi_o;
	localparam [31:0] KEM_Q = 32'd3329;
	localparam [15:0] KEM_QINV = 16'hf301;
	localparam [31:0] DSA_Q = 32'd8380417;
	localparam [31:0] DSA_QINV = 32'd58728449;
	localparam [31:0] FALCON_Q = 32'd12289;
	localparam [15:0] FAL_Q0I = 16'd12287;
	localparam [2:0] MODE_DSA_MONT = 3'd0;
	localparam [2:0] MODE_KEM_MONT = 3'd1;
	localparam [2:0] MODE_FAL_MONT = 3'd2;
	localparam [2:0] MODE_HQC_RAW = 3'd4;
	localparam [2:0] MODE_DSA_RED32 = 3'd5;
	localparam [2:0] MODE_MODP_MONT = 3'd6;
	wire [63:0] full_prod;
	unified_mul_32x32 u_primary_mul(
		.a_i(op_a_i),
		.b_i(op_b_i),
		.carryless_mode_i(mode_i == MODE_HQC_RAW),
		.prod_o(full_prod)
	);
	reg [31:0] stage_a_op1;
	reg [31:0] stage_a_op2;
	wire [63:0] stage_a_result;
	reg [31:0] t_value;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_KEM_MONT: stage_a_op1 = {16'b0000000000000000, full_prod[15:0]};
			MODE_DSA_MONT: stage_a_op1 = full_prod[31:0];
			MODE_FAL_MONT: stage_a_op1 = full_prod[31:0];
			MODE_MODP_MONT: stage_a_op1 = {1'b0, full_prod[30:0]};
			default: stage_a_op1 = 1'sb0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_KEM_MONT: stage_a_op2 = {16'b0000000000000000, KEM_QINV};
			MODE_DSA_MONT: stage_a_op2 = DSA_QINV;
			MODE_FAL_MONT: stage_a_op2 = {16'b0000000000000000, FAL_Q0I};
			MODE_MODP_MONT: stage_a_op2 = modp_p0i_i;
			default: stage_a_op2 = 1'sb0;
		endcase
	end
	assign stage_a_result = stage_a_op1 * stage_a_op2;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_KEM_MONT: t_value = {{16 {stage_a_result[15]}}, stage_a_result[15:0]};
			MODE_DSA_MONT: t_value = stage_a_result[31:0];
			MODE_FAL_MONT: t_value = {16'b0000000000000000, stage_a_result[15:0]};
			MODE_MODP_MONT: t_value = {1'b0, stage_a_result[30:0]};
			default: t_value = 1'sb0;
		endcase
	end
	reg [31:0] stage_b_op1;
	reg [31:0] stage_b_op2;
	wire signed [63:0] stage_b_result;
	wire signed [31:0] reduce32_t;
	assign reduce32_t = ($signed(op_a_i) + 32'sd4194304) >>> 23;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_DSA_RED32: stage_b_op1 = reduce32_t;
			MODE_FAL_MONT: stage_b_op1 = t_value;
			MODE_MODP_MONT: stage_b_op1 = t_value;
			default: stage_b_op1 = t_value;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_KEM_MONT: stage_b_op2 = KEM_Q;
			MODE_DSA_MONT: stage_b_op2 = DSA_Q;
			MODE_FAL_MONT: stage_b_op2 = FALCON_Q;
			MODE_MODP_MONT: stage_b_op2 = modp_p_i;
			MODE_DSA_RED32: stage_b_op2 = DSA_Q;
			default: stage_b_op2 = 1'sb0;
		endcase
	end
	assign stage_b_result = $signed({{32 {stage_b_op1[31]}}, stage_b_op1}) * $signed({{32 {1'b0}}, stage_b_op2});
	wire [63:0] modp_tp;
	assign modp_tp = {32'b00000000000000000000000000000000, t_value} * {32'b00000000000000000000000000000000, modp_p_i};
	reg signed [63:0] minuend;
	wire signed [63:0] subtrahend;
	wire signed [63:0] difference;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_DSA_RED32: minuend = $signed({{32 {op_a_i[31]}}, op_a_i});
			default: minuend = $signed(full_prod);
		endcase
	end
	assign subtrahend = stage_b_result;
	assign difference = minuend - subtrahend;
	wire [31:0] falcon_w;
	wire [31:0] falcon_sum;
	wire [31:0] falcon_shifted;
	wire [31:0] falcon_final;
	wire [63:0] modp_sum;
	wire [31:0] modp_shifted;
	wire [31:0] modp_sub;
	wire [31:0] modp_final;
	assign falcon_w = stage_b_result[31:0];
	assign falcon_sum = full_prod[31:0] + falcon_w;
	assign falcon_shifted = falcon_sum >> 16;
	assign falcon_final = (falcon_shifted >= FALCON_Q ? falcon_shifted - FALCON_Q : falcon_shifted);
	wire [63:0] modp_z;
	assign modp_z = {2'b00, full_prod[61:0]};
	assign modp_sum = modp_z + modp_tp;
	assign modp_shifted = modp_sum[62:31];
	assign modp_sub = modp_shifted[31:0] - modp_p_i;
	assign modp_final = modp_sub + (modp_p_i & {32 {modp_sub[31]}});
	always @(*) begin
		if (_sv2v_0)
			;
		res_lo_o = 1'sb0;
		res_hi_o = 1'sb0;
		(* full_case, parallel_case *)
		case (mode_i)
			MODE_KEM_MONT: res_lo_o = difference[47:16];
			MODE_DSA_MONT: res_lo_o = difference[63:32];
			MODE_FAL_MONT: res_lo_o = falcon_final;
			MODE_HQC_RAW: begin
				res_lo_o = full_prod[31:0];
				res_hi_o = full_prod[63:32];
			end
			MODE_MODP_MONT: begin
				res_lo_o = modp_final;
				res_hi_o = 32'b00000000000000000000000000000000;
			end
			MODE_DSA_RED32: res_lo_o = difference[31:0];
			default: res_lo_o = full_prod[31:0];
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module fpr (
	clk_i,
	rst_ni,
	data1_i,
	data2_i,
	data3_i,
	insn_i,
	result_o,
	result_hi_o
);
	reg _sv2v_0;
	input wire clk_i;
	input wire rst_ni;
	input wire [31:0] data1_i;
	input wire [31:0] data2_i;
	input wire [31:0] data3_i;
	input wire [6:0] insn_i;
	output reg [31:0] result_o;
	output reg [31:0] result_hi_o;
	reg fpr_s_reg;
	reg [31:0] fpr_e_reg;
	reg [31:0] fpr_hi_reg;
	wire [63:0] fpr_result_full;
	wire [63:0] fpr_norm64_m_in;
	wire [31:0] fpr_norm64_e_in;
	reg [6:0] fpr_norm64_lzc;
	wire [5:0] fpr_norm64_shamt;
	wire [63:0] fpr_norm64_m_out;
	wire [31:0] fpr_norm64_e_out;
	reg [31:0] fpr_norm64_m_hi_reg;
	reg [31:0] fpr_norm64_e_reg;
	function automatic [63:0] fpr_pack64;
		input reg s_i;
		input reg [31:0] e_i;
		input reg [63:0] m_i;
		reg [63:0] x;
		reg [63:0] m;
		reg [31:0] e;
		reg [31:0] t;
		reg [31:0] f;
		reg [31:0] neg_t;
		begin
			m = m_i;
			e = e_i + 32'd1076;
			t = e >> 31;
			m = m & ({32'b00000000000000000000000000000000, t} - 64'd1);
			t = m[63:54];
			neg_t = ~t + 32'd1;
			e = e & neg_t;
			x = ({63'b000000000000000000000000000000000000000000000000000000000000000, s_i} << 63) | (m >> 2);
			x = x + ({32'b00000000000000000000000000000000, e} << 52);
			f = {29'b00000000000000000000000000000, m[2:0]};
			x = x + ((32'h000000c8 >> f) & 32'h00000001);
			fpr_pack64 = x;
		end
	endfunction
	function automatic signed [6:0] sv2v_cast_7_signed;
		input reg signed [6:0] inp;
		sv2v_cast_7_signed = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		fpr_norm64_lzc = 7'd64;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 63; i >= 0; i = i - 1)
				if (fpr_norm64_m_in[i] && (fpr_norm64_lzc == 7'd64))
					fpr_norm64_lzc = sv2v_cast_7_signed(63 - i);
		end
	end
	assign fpr_result_full = fpr_pack64(fpr_s_reg, fpr_e_reg, {data2_i, data1_i});
	assign fpr_norm64_m_in = {data2_i, data1_i};
	assign fpr_norm64_e_in = data3_i;
	assign fpr_norm64_shamt = (fpr_norm64_lzc == 7'd64 ? 6'd63 : fpr_norm64_lzc[5:0]);
	assign fpr_norm64_m_out = fpr_norm64_m_in << fpr_norm64_shamt;
	assign fpr_norm64_e_out = fpr_norm64_e_in - {26'b00000000000000000000000000, fpr_norm64_shamt};
	always @(*) begin
		if (_sv2v_0)
			;
		result_o = 32'b00000000000000000000000000000000;
		result_hi_o = 32'b00000000000000000000000000000000;
		case (insn_i)
			7'b0110100: result_o = 32'b00000000000000000000000000000000;
			7'b0110101: begin
				result_o = fpr_result_full[31:0];
				result_hi_o = fpr_result_full[63:32];
			end
			7'b0110110: result_o = fpr_hi_reg;
			7'b0110111: result_o = fpr_norm64_m_out[31:0];
			7'b0111000: result_o = fpr_norm64_m_hi_reg;
			7'b0111001: result_o = fpr_norm64_e_reg;
			default: begin
				result_o = 32'b00000000000000000000000000000000;
				result_hi_o = 32'b00000000000000000000000000000000;
			end
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			fpr_s_reg <= 1'b0;
			fpr_e_reg <= 1'sb0;
			fpr_hi_reg <= 1'sb0;
			fpr_norm64_m_hi_reg <= 1'sb0;
			fpr_norm64_e_reg <= 1'sb0;
		end
		else
			case (insn_i)
				7'b0110100: begin
					fpr_s_reg <= data1_i[0];
					fpr_e_reg <= data2_i;
				end
				7'b0110101: fpr_hi_reg <= fpr_result_full[63:32];
				7'b0110111: begin
					fpr_norm64_m_hi_reg <= fpr_norm64_m_out[63:32];
					fpr_norm64_e_reg <= fpr_norm64_e_out;
				end
				default:
					;
			endcase
	initial _sv2v_0 = 0;
endmodule
module multiplier_tree (
	clk_i,
	rst_ni,
	multiplier_tree1_i,
	multiplier_tree2_i,
	multiplier_tree3_i,
	insn_i,
	result_o,
	result_hi_o
);
	reg _sv2v_0;
	input wire clk_i;
	input wire rst_ni;
	input wire [31:0] multiplier_tree1_i;
	input wire [31:0] multiplier_tree2_i;
	input wire [31:0] multiplier_tree3_i;
	input wire [6:0] insn_i;
	output reg [31:0] result_o;
	output reg [31:0] result_hi_o;
	reg [31:0] a1_reg;
	reg [31:0] b1_reg;
	reg [31:0] reg_A;
	reg [31:0] reg_B;
	reg [31:0] mul_op_a;
	reg [31:0] mul_op_b;
	wire [31:0] mul_res_lo;
	wire [31:0] mul_res_hi;
	reg [2:0] mul_mode;
	wire [31:0] modp_p0i;
	reg [31:0] barrett_input;
	wire [31:0] barrett_result;
	wire [31:0] gf_reduce_result;
	wire [11:0] gf_pass1;
	wire [11:0] gf_pass2;
	wire [7:0] gf_mod1;
	wire [7:0] gf_mod2;
	wire [31:0] compare_u32_result;
	wire [31:0] cmp_v1_minus_v2;
	wire [31:0] cmp_v2_minus_v1;
	function automatic [31:0] modp_p0i_lookup;
		input reg [31:0] p;
		(* full_case, parallel_case *)
		case (p)
			32'd2147473409: modp_p0i_lookup = 32'd2042615807;
			32'd2147389441: modp_p0i_lookup = 32'd1862176767;
			32'd2147387393: modp_p0i_lookup = 32'd1472104447;
			32'd2147377153: modp_p0i_lookup = 32'd1543397375;
			default: modp_p0i_lookup = 32'd0;
		endcase
	endfunction
	function automatic signed [5:0] sv2v_cast_6_signed;
		input reg signed [5:0] inp;
		sv2v_cast_6_signed = inp;
	endfunction
	function automatic [5:0] ctz32;
		input reg [31:0] x;
		reg [5:0] cnt;
		begin
			cnt = 6'd32;
			begin : sv2v_autoblock_1
				reg signed [31:0] i;
				for (i = 31; i >= 0; i = i - 1)
					if (x[i])
						cnt = sv2v_cast_6_signed(i);
			end
			ctz32 = cnt;
		end
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		mul_op_a = multiplier_tree3_i;
		mul_op_b = multiplier_tree2_i;
		mul_mode = 3'd0;
		barrett_input = 1'sb0;
		case (insn_i)
			7'b0110011: begin
				mul_mode = 3'd6;
				mul_op_a = multiplier_tree1_i;
				mul_op_b = multiplier_tree2_i;
			end
			7'b0011011: begin
				mul_mode = 3'd1;
				mul_op_b = multiplier_tree2_i;
			end
			7'b0011100: begin
				mul_mode = 3'd1;
				barrett_input = {{16 {multiplier_tree1_i[15]}}, multiplier_tree1_i[15:0]} + {{16 {multiplier_tree2_i[15]}}, multiplier_tree2_i[15:0]};
				mul_op_b = $signed(multiplier_tree2_i[15:0]) - $signed(multiplier_tree1_i[15:0]);
			end
			7'b0101110: begin
				mul_mode = 3'd2;
				mul_op_b = multiplier_tree2_i;
			end
			7'b0101111: begin
				mul_mode = 3'd2;
				mul_op_b = (multiplier_tree1_i[15:0] >= multiplier_tree2_i[15:0] ? {16'b0000000000000000, multiplier_tree1_i[15:0] - multiplier_tree2_i[15:0]} : {16'b0000000000000000, (multiplier_tree1_i[15:0] - multiplier_tree2_i[15:0]) + 16'd12289});
			end
			7'b0010001: barrett_input = multiplier_tree1_i;
			7'b0011010, 7'b0111010, 7'b0111011: barrett_input = multiplier_tree1_i;
			7'b0100100: mul_mode = 3'd0;
			7'b0100110: begin
				mul_mode = 3'd0;
				mul_op_b = multiplier_tree1_i - multiplier_tree2_i;
			end
			7'b0011101, 7'b0011110, 7'b0011111: begin
				mul_mode = (insn_i == 7'b0011111 ? 3'd0 : (insn_i == 7'b0011110 ? 3'd1 : 3'd2));
				mul_op_a = multiplier_tree1_i;
				mul_op_b = multiplier_tree2_i;
			end
			7'b0100000: begin
				mul_mode = 3'd4;
				mul_op_a = multiplier_tree1_i;
				mul_op_b = multiplier_tree2_i;
			end
			7'b0100001: begin
				mul_mode = 3'd4;
				mul_op_a = multiplier_tree1_i;
				mul_op_b = multiplier_tree2_i;
			end
			7'b0100010: begin
				mul_mode = 3'd4;
				mul_op_a = multiplier_tree1_i ^ a1_reg;
				mul_op_b = multiplier_tree2_i ^ b1_reg;
			end
			7'b0100011: begin
				mul_mode = 3'd4;
				mul_op_a = {24'b000000000000000000000000, multiplier_tree1_i[7:0]};
				mul_op_b = {24'b000000000000000000000000, multiplier_tree2_i[7:0]};
			end
			7'b0101001: begin
				mul_mode = 3'd5;
				mul_op_a = multiplier_tree1_i;
			end
			default: mul_mode = 3'd0;
		endcase
	end
	assign modp_p0i = modp_p0i_lookup(multiplier_tree3_i);
	barrett kyber_barrett_inst(
		.a(barrett_input),
		.b(multiplier_tree2_i),
		.insn_i(insn_i),
		.result(barrett_result)
	);
	assign gf_mod1 = multiplier_tree1_i[15:8];
	assign gf_pass1 = ((({4'b0000, multiplier_tree1_i[7:0]} ^ {4'b0000, gf_mod1}) ^ {2'b00, gf_mod1, 2'b00}) ^ {1'b0, gf_mod1, 3'b000}) ^ {gf_mod1, 4'b0000};
	assign gf_mod2 = {4'b0000, gf_pass1[11:8]};
	assign gf_pass2 = ((({4'b0000, gf_pass1[7:0]} ^ {4'b0000, gf_mod2}) ^ {2'b00, gf_mod2, 2'b00}) ^ {1'b0, gf_mod2, 3'b000}) ^ {gf_mod2, 4'b0000};
	assign gf_reduce_result = {24'b000000000000000000000000, gf_pass2[7:0]};
	assign cmp_v1_minus_v2 = multiplier_tree1_i - multiplier_tree2_i;
	assign cmp_v2_minus_v1 = multiplier_tree2_i - multiplier_tree1_i;
	assign compare_u32_result = 32'd1 ^ {31'b0000000000000000000000000000000, (cmp_v1_minus_v2 | cmp_v2_minus_v1) >> 31};
	shared_multiplication_logic u_shared_mul(
		.op_a_i(mul_op_a),
		.op_b_i(mul_op_b),
		.modp_p_i(multiplier_tree3_i),
		.modp_p0i_i(modp_p0i),
		.mode_i(mul_mode),
		.res_lo_o(mul_res_lo),
		.res_hi_o(mul_res_hi)
	);
	localparam [16:0] FALCON_Q = 17'd12289;
	reg [15:0] a;
	reg [15:0] b;
	reg [15:0] t;
	reg [15:0] temp_result_a;
	reg [15:0] temp_result_b;
	reg signed [16:0] falcon_a_plus_t;
	reg signed [16:0] falcon_a_minus_t;
	reg signed [16:0] falcon_a_plus_b;
	reg signed [16:0] falcon_a_minus_b;
	reg [15:0] falcon_res_a;
	reg [15:0] falcon_res_b;
	reg [15:0] falcon_intt_res_a;
	reg [15:0] falcon_intt_res_b;
	function automatic [15:0] sv2v_cast_16;
		input reg [15:0] inp;
		sv2v_cast_16 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		result_o = mul_res_lo;
		result_hi_o = mul_res_hi;
		a = 16'sd0;
		b = 16'sd0;
		t = 16'sd0;
		temp_result_a = 16'sd0;
		temp_result_b = 16'sd0;
		falcon_a_plus_t = 17'sd0;
		falcon_a_minus_t = 17'sd0;
		falcon_a_plus_b = 17'sd0;
		falcon_a_minus_b = 17'sd0;
		falcon_res_a = 16'sd0;
		falcon_res_b = 16'sd0;
		falcon_intt_res_a = 16'sd0;
		falcon_intt_res_b = 16'sd0;
		case (insn_i)
			7'b0011011: begin
				a = multiplier_tree1_i[15:0];
				t = mul_res_lo[15:0];
				temp_result_a = a + t;
				temp_result_b = a - t;
				result_o = {temp_result_b, temp_result_a};
			end
			7'b0011100: result_o = {mul_res_lo[15:0], sv2v_cast_16(barrett_result)};
			7'b0101110: begin
				a = multiplier_tree1_i[15:0];
				t = mul_res_lo[15:0];
				falcon_a_plus_t = ($signed({1'b0, a}) + $signed({1'b0, t})) - $signed(FALCON_Q);
				falcon_res_a = (falcon_a_plus_t[16] ? falcon_a_plus_t[15:0] + FALCON_Q[15:0] : falcon_a_plus_t[15:0]);
				falcon_a_minus_t = $signed({1'b0, a}) - $signed({1'b0, t});
				falcon_res_b = (falcon_a_minus_t[16] ? falcon_a_minus_t[15:0] + FALCON_Q[15:0] : falcon_a_minus_t[15:0]);
				result_o = {falcon_res_b, falcon_res_a};
			end
			7'b0101111: begin
				a = multiplier_tree1_i[15:0];
				b = multiplier_tree2_i[15:0];
				falcon_a_plus_b = ($signed({1'b0, a}) + $signed({1'b0, b})) - $signed(FALCON_Q);
				falcon_intt_res_a = (falcon_a_plus_b[16] ? falcon_a_plus_b[15:0] + FALCON_Q[15:0] : falcon_a_plus_b[15:0]);
				falcon_intt_res_b = mul_res_lo[15:0];
				result_o = {falcon_intt_res_b, falcon_intt_res_a};
			end
			7'b0010001, 7'b0011010, 7'b0111010, 7'b0111011: result_o = barrett_result;
			7'b0100100: begin
				result_o = multiplier_tree1_i + mul_res_lo;
				result_hi_o = multiplier_tree1_i - mul_res_lo;
			end
			7'b0100101: result_o = reg_A;
			7'b0100110: begin
				result_o = multiplier_tree1_i + multiplier_tree2_i;
				result_hi_o = mul_res_lo;
			end
			7'b0100111: result_o = reg_A;
			7'b0011101, 7'b0011110, 7'b0011111: begin
				result_o = mul_res_lo;
				result_hi_o = mul_res_hi;
			end
			7'b0110011: begin
				result_o = mul_res_lo;
				result_hi_o = 32'b00000000000000000000000000000000;
			end
			7'b0100000: begin
				result_o = mul_res_lo;
				result_hi_o = mul_res_hi;
			end
			7'b0100001: begin
				result_o = mul_res_hi;
				result_hi_o = mul_res_lo;
			end
			7'b0100010: begin
				result_o = mul_res_lo ^ reg_A;
				result_hi_o = mul_res_hi ^ reg_B;
			end
			7'b0101000: result_o = reg_A;
			7'b0101001: result_o = mul_res_lo;
			7'b1111000: result_o = gf_reduce_result;
			7'b1111001: result_o = compare_u32_result;
			default: begin
				result_o = mul_res_lo;
				result_hi_o = mul_res_hi;
			end
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			a1_reg <= 1'sb0;
			b1_reg <= 1'sb0;
			reg_A <= 1'sb0;
			reg_B <= 1'sb0;
		end
		else
			case (insn_i)
				7'b0100000: begin
					reg_A <= mul_res_lo ^ mul_res_hi;
					reg_B <= mul_res_hi;
				end
				7'b0100001: begin
					a1_reg <= multiplier_tree1_i;
					b1_reg <= multiplier_tree2_i;
					reg_A <= mul_res_lo ^ reg_A;
					reg_B <= (mul_res_lo ^ mul_res_hi) ^ reg_B;
				end
				7'b0100010: reg_A <= mul_res_hi ^ reg_B;
				7'b0100100: reg_A <= result_hi_o;
				7'b0100110: reg_A <= result_hi_o;
				default:
					;
			endcase
	initial _sv2v_0 = 0;
endmodule
module barrett (
	a,
	b,
	insn_i,
	result
);
	reg _sv2v_0;
	input wire signed [31:0] a;
	input wire signed [31:0] b;
	input wire [6:0] insn_i;
	output reg signed [31:0] result;
	localparam signed [31:0] Q_kyber = 32'sd3329;
	localparam signed [31:0] Q_kyber_half = 32'sd1665;
	localparam [31:0] HQC1_N = 32'd17669;
	localparam [31:0] HQC3_N = 32'd35851;
	localparam [31:0] HQC5_N = 32'd57637;
	reg signed [31:0] t1;
	reg signed [31:0] t2;
	reg signed [31:0] t3;
	reg signed [31:0] t4;
	reg signed [31:0] t5;
	reg signed [31:0] t6;
	reg signed [31:0] t7;
	reg signed [31:0] t8;
	reg signed [31:0] t9;
	reg signed [31:0] ta;
	reg signed [31:0] tb;
	reg signed [31:0] m_kyber;
	reg signed [31:0] z_kyber;
	reg [31:0] hqc_x;
	reg [31:0] hqc_q;
	reg [31:0] hqc_r;
	reg [63:0] hqc_mu_sum;
	reg [31:0] hqc_n_sum;
	function automatic [63:0] sv2v_cast_64;
		input reg [63:0] inp;
		sv2v_cast_64 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		result = 1'sb0;
		t1 = 1'sb0;
		t2 = 1'sb0;
		t3 = 1'sb0;
		t4 = 1'sb0;
		t5 = 1'sb0;
		t6 = 1'sb0;
		t7 = 1'sb0;
		t8 = 1'sb0;
		t9 = 1'sb0;
		ta = 1'sb0;
		tb = 1'sb0;
		m_kyber = 1'sb0;
		z_kyber = 1'sb0;
		hqc_x = $unsigned(a);
		hqc_q = 1'sb0;
		hqc_r = 1'sb0;
		hqc_mu_sum = 1'sb0;
		hqc_n_sum = 1'sb0;
		(* full_case, parallel_case *)
		case (insn_i)
			7'b0011100, 7'b0010001: begin
				t1 = a;
				t2 = a << 1;
				t3 = a << 2;
				t4 = a << 3;
				t5 = a << 5;
				t6 = a << 7;
				t7 = a << 8;
				t8 = a << 9;
				t9 = a << 12;
				ta = (((((((t1 + t2) + t3) + t4) + t5) + t6) + t7) + t8) + t9;
				tb = ta >>> 24;
				m_kyber = (((tb << 11) + (tb << 10)) + (tb << 8)) + tb;
				z_kyber = a - m_kyber;
				if (z_kyber >= Q_kyber_half)
					z_kyber = z_kyber - Q_kyber;
				result = z_kyber;
			end
			7'b0011010: begin
				hqc_mu_sum = ((((((((((sv2v_cast_64(hqc_x) << 17) + (sv2v_cast_64(hqc_x) << 16)) + (sv2v_cast_64(hqc_x) << 15)) + (sv2v_cast_64(hqc_x) << 13)) + (sv2v_cast_64(hqc_x) << 12)) + (sv2v_cast_64(hqc_x) << 10)) + (sv2v_cast_64(hqc_x) << 8)) + (sv2v_cast_64(hqc_x) << 7)) + (sv2v_cast_64(hqc_x) << 2)) + (sv2v_cast_64(hqc_x) << 1)) + sv2v_cast_64(hqc_x);
				hqc_q = hqc_mu_sum[63:32];
				hqc_n_sum = ((((hqc_q << 14) + (hqc_q << 10)) + (hqc_q << 8)) + (hqc_q << 2)) + hqc_q;
				hqc_r = hqc_x - hqc_n_sum;
				if (hqc_r >= HQC1_N)
					hqc_r = hqc_r - HQC1_N;
				result = $signed(hqc_r);
			end
			7'b0111010: begin
				hqc_mu_sum = ((((((((((sv2v_cast_64(hqc_x) << 16) + (sv2v_cast_64(hqc_x) << 15)) + (sv2v_cast_64(hqc_x) << 14)) + (sv2v_cast_64(hqc_x) << 12)) + (sv2v_cast_64(hqc_x) << 9)) + (sv2v_cast_64(hqc_x) << 8)) + (sv2v_cast_64(hqc_x) << 7)) + (sv2v_cast_64(hqc_x) << 6)) + (sv2v_cast_64(hqc_x) << 5)) + (sv2v_cast_64(hqc_x) << 4)) + (sv2v_cast_64(hqc_x) << 3);
				hqc_q = hqc_mu_sum[63:32];
				hqc_n_sum = (((((hqc_q << 15) + (hqc_q << 11)) + (hqc_q << 10)) + (hqc_q << 3)) + (hqc_q << 1)) + hqc_q;
				hqc_r = hqc_x - hqc_n_sum;
				if (hqc_r >= HQC3_N)
					hqc_r = hqc_r - HQC3_N;
				result = $signed(hqc_r);
			end
			7'b0111011: begin
				hqc_mu_sum = ((((((sv2v_cast_64(hqc_x) << 16) + (sv2v_cast_64(hqc_x) << 13)) + (sv2v_cast_64(hqc_x) << 9)) + (sv2v_cast_64(hqc_x) << 8)) + (sv2v_cast_64(hqc_x) << 4)) + (sv2v_cast_64(hqc_x) << 2)) + sv2v_cast_64(hqc_x);
				hqc_q = hqc_mu_sum[63:32];
				hqc_n_sum = ((((((hqc_q << 15) + (hqc_q << 14)) + (hqc_q << 13)) + (hqc_q << 8)) + (hqc_q << 5)) + (hqc_q << 2)) + hqc_q;
				hqc_r = hqc_x - hqc_n_sum;
				if (hqc_r >= HQC5_N)
					hqc_r = hqc_r - HQC5_N;
				result = $signed(hqc_r);
			end
			default: result = 1'sb0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module chain_lengths (
	clk_i,
	rst_ni,
	register_array_i,
	insn_i,
	store_index_i,
	store_result_o,
	cl_active_o
);
	reg _sv2v_0;
	parameter [31:0] NUM_VARIABLES = 50;
	parameter [31:0] VARIABLE_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] register_array_i;
	input wire [6:0] insn_i;
	input wire [3:0] store_index_i;
	output wire [31:0] store_result_o;
	output wire cl_active_o;
	reg [31:0] result_regs [0:8];
	reg cl_active_reg;
	reg [3:0] nibbles [0:63];
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] r;
			for (r = 0; r < 8; r = r + 1)
				begin
					nibbles[(8 * r) + 0] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 7-:4];
					nibbles[(8 * r) + 1] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 3-:4];
					nibbles[(8 * r) + 2] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 15-:4];
					nibbles[(8 * r) + 3] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 11-:4];
					nibbles[(8 * r) + 4] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 23-:4];
					nibbles[(8 * r) + 5] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 19-:4];
					nibbles[(8 * r) + 6] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 31-:4];
					nibbles[(8 * r) + 7] = register_array_i[(((NUM_VARIABLES - 1) - r) * VARIABLE_WIDTH) + 27-:4];
				end
		end
	end
	reg [9:0] csum_128f;
	reg [9:0] csum_192f;
	reg [9:0] csum_256f;
	function automatic [9:0] sv2v_cast_10;
		input reg [9:0] inp;
		sv2v_cast_10 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		csum_128f = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				csum_128f = csum_128f + (10'd15 - sv2v_cast_10(nibbles[i]));
		end
		csum_192f = 1'sb0;
		begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 0; i < 48; i = i + 1)
				csum_192f = csum_192f + (10'd15 - sv2v_cast_10(nibbles[i]));
		end
		csum_256f = 1'sb0;
		begin : sv2v_autoblock_4
			reg signed [31:0] i;
			for (i = 0; i < 64; i = i + 1)
				csum_256f = csum_256f + (10'd15 - sv2v_cast_10(nibbles[i]));
		end
	end
	wire [15:0] csum_shifted_128f;
	wire [15:0] csum_shifted_192f;
	wire [15:0] csum_shifted_256f;
	assign csum_shifted_128f = {6'b000000, csum_128f} << 4;
	assign csum_shifted_192f = {6'b000000, csum_192f} << 4;
	assign csum_shifted_256f = {6'b000000, csum_256f} << 4;
	wire [3:0] csum_nib_128f [0:2];
	wire [3:0] csum_nib_192f [0:2];
	wire [3:0] csum_nib_256f [0:2];
	assign csum_nib_128f[0] = csum_shifted_128f[15:12];
	assign csum_nib_128f[1] = csum_shifted_128f[11:8];
	assign csum_nib_128f[2] = csum_shifted_128f[7:4];
	assign csum_nib_192f[0] = csum_shifted_192f[15:12];
	assign csum_nib_192f[1] = csum_shifted_192f[11:8];
	assign csum_nib_192f[2] = csum_shifted_192f[7:4];
	assign csum_nib_256f[0] = csum_shifted_256f[15:12];
	assign csum_nib_256f[1] = csum_shifted_256f[11:8];
	assign csum_nib_256f[2] = csum_shifted_256f[7:4];
	reg [31:0] packed_msg [0:7];
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_5
			reg signed [31:0] w;
			for (w = 0; w < 8; w = w + 1)
				packed_msg[w] = {nibbles[(8 * w) + 0], nibbles[(8 * w) + 1], nibbles[(8 * w) + 2], nibbles[(8 * w) + 3], nibbles[(8 * w) + 4], nibbles[(8 * w) + 5], nibbles[(8 * w) + 6], nibbles[(8 * w) + 7]};
		end
	end
	wire [31:0] csum_word_128f;
	wire [31:0] csum_word_192f;
	wire [31:0] csum_word_256f;
	assign csum_word_128f = {csum_nib_128f[0], csum_nib_128f[1], csum_nib_128f[2], 20'b00000000000000000000};
	assign csum_word_192f = {csum_nib_192f[0], csum_nib_192f[1], csum_nib_192f[2], 20'b00000000000000000000};
	assign csum_word_256f = {csum_nib_256f[0], csum_nib_256f[1], csum_nib_256f[2], 20'b00000000000000000000};
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			begin : sv2v_autoblock_6
				reg signed [31:0] i;
				for (i = 0; i < 9; i = i + 1)
					result_regs[i] <= 1'sb0;
			end
			cl_active_reg <= 1'b0;
		end
		else
			case (insn_i)
				7'b0101010: begin
					result_regs[0] <= packed_msg[0];
					result_regs[1] <= packed_msg[1];
					result_regs[2] <= packed_msg[2];
					result_regs[3] <= packed_msg[3];
					result_regs[4] <= csum_word_128f;
					result_regs[5] <= 1'sb0;
					result_regs[6] <= 1'sb0;
					result_regs[7] <= 1'sb0;
					result_regs[8] <= 1'sb0;
					cl_active_reg <= 1'b1;
				end
				7'b0101011: begin
					result_regs[0] <= packed_msg[0];
					result_regs[1] <= packed_msg[1];
					result_regs[2] <= packed_msg[2];
					result_regs[3] <= packed_msg[3];
					result_regs[4] <= packed_msg[4];
					result_regs[5] <= packed_msg[5];
					result_regs[6] <= csum_word_192f;
					result_regs[7] <= 1'sb0;
					result_regs[8] <= 1'sb0;
					cl_active_reg <= 1'b1;
				end
				7'b0101100: begin
					result_regs[0] <= packed_msg[0];
					result_regs[1] <= packed_msg[1];
					result_regs[2] <= packed_msg[2];
					result_regs[3] <= packed_msg[3];
					result_regs[4] <= packed_msg[4];
					result_regs[5] <= packed_msg[5];
					result_regs[6] <= packed_msg[6];
					result_regs[7] <= packed_msg[7];
					result_regs[8] <= csum_word_256f;
					cl_active_reg <= 1'b1;
				end
				7'b0000001, 7'b0000110, 7'b0110000, 7'b0110001, 7'b0110010, 7'b0111100, 7'b0111101, 7'b0111110, 7'b0111111, 7'b1000000, 7'b1000001: cl_active_reg <= 1'b0;
				default:
					;
			endcase
	assign store_result_o = (cl_active_reg ? result_regs[store_index_i] : 32'h00000000);
	assign cl_active_o = cl_active_reg;
	initial _sv2v_0 = 0;
endmodule
module sphincs_ops (
	clk_i,
	rst_ni,
	register_array_i,
	insn_i,
	simple_mode_i,
	keccak_done_i,
	keccak_result_i,
	sphincs_start_keccak_o,
	sphincs_keccak_input_o,
	sphincs_wb_enable_o,
	sphincs_wb_data_o,
	sphincs_active_o,
	sphincs_done_o
);
	reg _sv2v_0;
	parameter [31:0] NUM_VARIABLES = 50;
	parameter [31:0] VARIABLE_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] register_array_i;
	input wire [6:0] insn_i;
	input wire simple_mode_i;
	input wire keccak_done_i;
	input wire [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] keccak_result_i;
	output wire sphincs_start_keccak_o;
	output wire [1599:0] sphincs_keccak_input_o;
	output wire sphincs_wb_enable_o;
	output reg [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] sphincs_wb_data_o;
	output wire sphincs_active_o;
	output wire sphincs_done_o;
	localparam [31:0] SPX_ADDR_BYTES = 32;
	localparam [31:0] SHAKE256_RATE = 136;
	reg [1:0] op_type_q;
	reg [1:0] op_type_d;
	reg [1:0] sec_level_q;
	reg [1:0] sec_level_d;
	reg simple_q;
	reg simple_d;
	reg [2:0] state_q;
	reg [2:0] state_d;
	reg [255:0] pub_seed;
	reg [255:0] addr;
	reg [255:0] input_block1;
	reg [255:0] input_block2;
	reg [511:0] bitmask_reg;
	reg [511:0] masked_input;
	reg [1599:0] keccak_state;
	reg is_any_launch;
	wire is_thash;
	always @(*) begin
		if (_sv2v_0)
			;
		pub_seed = 1'sb0;
		addr = 1'sb0;
		input_block1 = 1'sb0;
		input_block2 = 1'sb0;
		case (sec_level_q)
			2'b00: begin
				pub_seed[127:0] = {register_array_i[(NUM_VARIABLES - 4) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 3) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 2) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 1) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				addr = {register_array_i[(NUM_VARIABLES - 12) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 11) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 10) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 9) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 8) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 7) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 6) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 5) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				input_block1[127:0] = {register_array_i[(NUM_VARIABLES - 16) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 15) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 14) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 13) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				input_block2[127:0] = {register_array_i[(NUM_VARIABLES - 20) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 19) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 18) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 17) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
			end
			2'b01: begin
				pub_seed[191:0] = {register_array_i[(NUM_VARIABLES - 6) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 5) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 4) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 3) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 2) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 1) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				addr = {register_array_i[(NUM_VARIABLES - 14) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 13) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 12) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 11) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 10) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 9) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 8) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 7) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				input_block1[191:0] = {register_array_i[(NUM_VARIABLES - 20) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 19) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 18) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 17) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 16) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 15) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				input_block2[191:0] = {register_array_i[(NUM_VARIABLES - 26) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 25) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 24) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 23) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 22) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 21) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
			end
			2'b10: begin
				pub_seed = {register_array_i[(NUM_VARIABLES - 8) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 7) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 6) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 5) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 4) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 3) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 2) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 1) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				addr = {register_array_i[(NUM_VARIABLES - 16) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 15) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 14) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 13) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 12) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 11) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 10) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 9) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				input_block1 = {register_array_i[(NUM_VARIABLES - 24) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 23) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 22) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 21) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 20) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 19) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 18) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 17) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
				input_block2 = {register_array_i[(NUM_VARIABLES - 32) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 31) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 30) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 29) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 28) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 27) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 26) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array_i[(NUM_VARIABLES - 25) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
			end
			default:
				;
		endcase
	end
	assign is_thash = (op_type_q == 2'b10) || (op_type_q == 2'b11);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			op_type_q <= 2'b00;
			sec_level_q <= 2'b00;
			simple_q <= 1'b0;
		end
		else begin
			op_type_q <= op_type_d;
			sec_level_q <= sec_level_d;
			simple_q <= simple_d;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		op_type_d = op_type_q;
		sec_level_d = sec_level_q;
		simple_d = simple_q;
		is_any_launch = 1'b0;
		if (state_q == 3'd0)
			case (insn_i)
				7'b0110000: begin
					op_type_d = 2'b10;
					sec_level_d = 2'b00;
					simple_d = simple_mode_i;
					is_any_launch = 1'b1;
				end
				7'b0110001: begin
					op_type_d = 2'b11;
					sec_level_d = 2'b00;
					simple_d = simple_mode_i;
					is_any_launch = 1'b1;
				end
				7'b0110010: begin
					op_type_d = 2'b01;
					sec_level_d = 2'b00;
					simple_d = 1'b0;
					is_any_launch = 1'b1;
				end
				7'b0111100: begin
					op_type_d = 2'b10;
					sec_level_d = 2'b01;
					simple_d = simple_mode_i;
					is_any_launch = 1'b1;
				end
				7'b0111101: begin
					op_type_d = 2'b11;
					sec_level_d = 2'b01;
					simple_d = simple_mode_i;
					is_any_launch = 1'b1;
				end
				7'b0111110: begin
					op_type_d = 2'b10;
					sec_level_d = 2'b10;
					simple_d = simple_mode_i;
					is_any_launch = 1'b1;
				end
				7'b0111111: begin
					op_type_d = 2'b11;
					sec_level_d = 2'b10;
					simple_d = simple_mode_i;
					is_any_launch = 1'b1;
				end
				7'b1000000: begin
					op_type_d = 2'b01;
					sec_level_d = 2'b01;
					simple_d = 1'b0;
					is_any_launch = 1'b1;
				end
				7'b1000001: begin
					op_type_d = 2'b01;
					sec_level_d = 2'b10;
					simple_d = 1'b0;
					is_any_launch = 1'b1;
				end
				default: begin
					op_type_d = 2'b00;
					is_any_launch = 1'b0;
				end
			endcase
		else if (state_d == 3'd0) begin
			op_type_d = 2'b00;
			simple_d = 1'b0;
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			bitmask_reg <= 1'sb0;
		else if ((((state_q == 3'd2) && keccak_done_i) && is_thash) && !simple_q) begin
			bitmask_reg <= 1'sb0;
			case (sec_level_q)
				2'b00:
					if (op_type_q == 2'b11) begin : sv2v_autoblock_1
						reg signed [31:0] i;
						for (i = 0; i < 8; i = i + 1)
							bitmask_reg[i * 32+:32] <= keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
					end
					else begin : sv2v_autoblock_2
						reg signed [31:0] i;
						for (i = 0; i < 4; i = i + 1)
							bitmask_reg[i * 32+:32] <= keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
					end
				2'b01:
					if (op_type_q == 2'b11) begin : sv2v_autoblock_3
						reg signed [31:0] i;
						for (i = 0; i < 12; i = i + 1)
							bitmask_reg[i * 32+:32] <= keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
					end
					else begin : sv2v_autoblock_4
						reg signed [31:0] i;
						for (i = 0; i < 6; i = i + 1)
							bitmask_reg[i * 32+:32] <= keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
					end
				2'b10:
					if (op_type_q == 2'b11) begin : sv2v_autoblock_5
						reg signed [31:0] i;
						for (i = 0; i < 16; i = i + 1)
							bitmask_reg[i * 32+:32] <= keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
					end
					else begin : sv2v_autoblock_6
						reg signed [31:0] i;
						for (i = 0; i < 8; i = i + 1)
							bitmask_reg[i * 32+:32] <= keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
					end
				default:
					;
			endcase
		end
	always @(*) begin : sv2v_autoblock_7
		reg [511:0] payload_packed;
		if (_sv2v_0)
			;
		payload_packed = 1'sb0;
		if (op_type_q == 2'b11)
			case (sec_level_q)
				2'b00: payload_packed[255:0] = {input_block2[127:0], input_block1[127:0]};
				2'b01: payload_packed[383:0] = {input_block2[191:0], input_block1[191:0]};
				2'b10: payload_packed[511:0] = {input_block2[255:0], input_block1[255:0]};
				default: payload_packed[255:0] = {input_block2[127:0], input_block1[127:0]};
			endcase
		else
			case (sec_level_q)
				2'b00: payload_packed[127:0] = input_block1[127:0];
				2'b01: payload_packed[191:0] = input_block1[191:0];
				2'b10: payload_packed[255:0] = input_block1[255:0];
				default: payload_packed[127:0] = input_block1[127:0];
			endcase
		masked_input = payload_packed ^ bitmask_reg;
	end
	reg [1087:0] rate_1_128;
	reg [1087:0] rate_1_192;
	reg [1087:0] rate_1_256;
	reg [1087:0] rate_2_128;
	reg [1087:0] rate_2_192;
	reg [1087:0] rate_2_256;
	reg [1087:0] rate_portion_1;
	reg [1087:0] rate_portion_2;
	wire [1599:0] state_1;
	wire [1599:0] state_2;
	always @(*) begin
		if (_sv2v_0)
			;
		rate_1_128 = 1'sb0;
		rate_1_128[127:0] = pub_seed[127:0];
		rate_1_128[383:128] = addr;
		if (!simple_q && (op_type_q != 2'b01))
			rate_1_128[391:384] = 8'h1f;
		else if (op_type_q == 2'b11) begin
			rate_1_128[511:384] = input_block1[127:0];
			rate_1_128[639:512] = input_block2[127:0];
			rate_1_128[647:640] = 8'h1f;
		end
		else begin
			rate_1_128[511:384] = input_block1[127:0];
			rate_1_128[519:512] = 8'h1f;
		end
		rate_1_128[1087:1080] = 8'h80;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		rate_1_192 = 1'sb0;
		rate_1_192[191:0] = pub_seed[191:0];
		rate_1_192[447:192] = addr;
		if (!simple_q && (op_type_q != 2'b01))
			rate_1_192[455:448] = 8'h1f;
		else if (op_type_q == 2'b11) begin
			rate_1_192[639:448] = input_block1[191:0];
			rate_1_192[831:640] = input_block2[191:0];
			rate_1_192[839:832] = 8'h1f;
		end
		else begin
			rate_1_192[639:448] = input_block1[191:0];
			rate_1_192[647:640] = 8'h1f;
		end
		rate_1_192[1087:1080] = 8'h80;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		rate_1_256 = 1'sb0;
		rate_1_256[255:0] = pub_seed;
		rate_1_256[511:256] = addr;
		if (!simple_q && (op_type_q != 2'b01))
			rate_1_256[519:512] = 8'h1f;
		else if (op_type_q == 2'b11) begin
			rate_1_256[767:512] = input_block1;
			rate_1_256[1023:768] = input_block2;
			rate_1_256[1031:1024] = 8'h1f;
		end
		else begin
			rate_1_256[767:512] = input_block1;
			rate_1_256[775:768] = 8'h1f;
		end
		rate_1_256[1087:1080] = 8'h80;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (sec_level_q)
			2'b00: rate_portion_1 = rate_1_128;
			2'b01: rate_portion_1 = rate_1_192;
			2'b10: rate_portion_1 = rate_1_256;
			default: rate_portion_1 = rate_1_128;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		rate_2_128 = 1'sb0;
		rate_2_128[127:0] = pub_seed[127:0];
		rate_2_128[383:128] = addr;
		if (op_type_q == 2'b11) begin
			rate_2_128[639:384] = masked_input[255:0];
			rate_2_128[647:640] = 8'h1f;
		end
		else begin
			rate_2_128[511:384] = masked_input[127:0];
			rate_2_128[519:512] = 8'h1f;
		end
		rate_2_128[1087:1080] = 8'h80;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		rate_2_192 = 1'sb0;
		rate_2_192[191:0] = pub_seed[191:0];
		rate_2_192[447:192] = addr;
		if (op_type_q == 2'b11) begin
			rate_2_192[831:448] = masked_input[383:0];
			rate_2_192[839:832] = 8'h1f;
		end
		else begin
			rate_2_192[639:448] = masked_input[191:0];
			rate_2_192[647:640] = 8'h1f;
		end
		rate_2_192[1087:1080] = 8'h80;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		rate_2_256 = 1'sb0;
		rate_2_256[255:0] = pub_seed;
		rate_2_256[511:256] = addr;
		if (op_type_q == 2'b11) begin
			rate_2_256[1023:512] = masked_input[511:0];
			rate_2_256[1031:1024] = 8'h1f;
		end
		else begin
			rate_2_256[767:512] = masked_input[255:0];
			rate_2_256[775:768] = 8'h1f;
		end
		rate_2_256[1087:1080] = 8'h80;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (sec_level_q)
			2'b00: rate_portion_2 = rate_2_128;
			2'b01: rate_portion_2 = rate_2_192;
			2'b10: rate_portion_2 = rate_2_256;
			default: rate_portion_2 = rate_2_128;
		endcase
	end
	assign state_1 = {512'b0, rate_portion_1};
	assign state_2 = {512'b0, rate_portion_2};
	always @(*) begin
		if (_sv2v_0)
			;
		case (state_q)
			3'd1, 3'd2: keccak_state = state_1;
			3'd3, 3'd4: keccak_state = state_2;
			default: keccak_state = 1'sb0;
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			state_q <= 3'd0;
		else
			state_q <= state_d;
	always @(*) begin
		if (_sv2v_0)
			;
		state_d = state_q;
		case (state_q)
			3'd0:
				if (is_any_launch)
					state_d = 3'd1;
			3'd1: state_d = 3'd2;
			3'd2:
				if (keccak_done_i) begin
					if ((op_type_q == 2'b01) || simple_q)
						state_d = 3'd5;
					else
						state_d = 3'd3;
				end
			3'd3: state_d = 3'd4;
			3'd4:
				if (keccak_done_i)
					state_d = 3'd5;
			3'd5: state_d = 3'd0;
			default: state_d = 3'd0;
		endcase
	end
	assign sphincs_active_o = state_q != 3'd0;
	assign sphincs_start_keccak_o = (state_q == 3'd1) || (state_q == 3'd3);
	assign sphincs_keccak_input_o = keccak_state;
	assign sphincs_done_o = state_q == 3'd5;
	assign sphincs_wb_enable_o = state_q == 3'd5;
	always @(*) begin
		if (_sv2v_0)
			;
		sphincs_wb_data_o = register_array_i;
		case (sec_level_q)
			2'b00: begin : sv2v_autoblock_8
				reg signed [31:0] i;
				for (i = 0; i < 4; i = i + 1)
					sphincs_wb_data_o[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] = keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
			end
			2'b01: begin : sv2v_autoblock_9
				reg signed [31:0] i;
				for (i = 0; i < 6; i = i + 1)
					sphincs_wb_data_o[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] = keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
			end
			2'b10: begin : sv2v_autoblock_10
				reg signed [31:0] i;
				for (i = 0; i < 8; i = i + 1)
					sphincs_wb_data_o[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] = keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
			end
			default: begin : sv2v_autoblock_11
				reg signed [31:0] i;
				for (i = 0; i < 4; i = i + 1)
					sphincs_wb_data_o[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] = keccak_result_i[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH];
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module horcrux (
	clk_i,
	rst_ni,
	rs_values_i,
	insn_i,
	start_keccak_i,
	done_keccak_o,
	done_sphincs_o,
	rd_values_o
);
	reg _sv2v_0;
	parameter [31:0] NUM_VARIABLES = 50;
	parameter [31:0] VARIABLE_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire [95:0] rs_values_i;
	input wire [6:0] insn_i;
	input wire start_keccak_i;
	output wire done_keccak_o;
	output wire done_sphincs_o;
	output wire [31:0] rd_values_o;
	reg [31:0] out;
	wire [31:0] a1;
	wire [31:0] b1;
	wire [31:0] c1;
	wire horcrux_register_enable_i;
	wire [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] register_array;
	reg [1599:0] keccak_input;
	wire [1599:0] keccak_result;
	wire keccak_status;
	wire KSTART;
	reg [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] keccak_register_array;
	wire horcrux_register_xor_enable;
	wire horcrux_register_init;
	reg keccak_wb_pending;
	wire keccak_writeback;
	wire sphincs_start_keccak;
	wire [1599:0] sphincs_keccak_input;
	wire sphincs_wb_enable;
	wire [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] sphincs_wb_data;
	wire sphincs_active;
	wire sphincs_done;
	assign a1 = rs_values_i[95-:32];
	assign b1 = rs_values_i[63-:32];
	assign c1 = rs_values_i[31-:32];
	assign horcrux_register_enable_i = insn_i == 7'b0000011;
	assign horcrux_register_xor_enable = insn_i == 7'b0000100;
	assign horcrux_register_init = insn_i == 7'b0000110;
	assign KSTART = start_keccak_i | sphincs_start_keccak;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			keccak_wb_pending <= 1'b0;
		else if (insn_i == 7'b0000101)
			keccak_wb_pending <= 1'b1;
		else if (done_keccak_o)
			keccak_wb_pending <= 1'b0;
	assign keccak_writeback = done_keccak_o & keccak_wb_pending;
	wire combined_wb_enable;
	reg [(NUM_VARIABLES * VARIABLE_WIDTH) - 1:0] combined_wb_data;
	assign combined_wb_enable = keccak_writeback | sphincs_wb_enable;
	always @(*) begin
		if (_sv2v_0)
			;
		if (sphincs_wb_enable)
			combined_wb_data = sphincs_wb_data;
		else
			combined_wb_data = keccak_register_array;
	end
	horcrux_register #(
		.NUM_VARIABLES(NUM_VARIABLES),
		.VARIABLE_WIDTH(VARIABLE_WIDTH)
	) horcrux_register_inst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.horcrux_register_in0_i(a1),
		.horcrux_register_in1_i(b1),
		.horcrux_register_enable_i(horcrux_register_enable_i),
		.horcrux_register_xor_enable_i(horcrux_register_xor_enable),
		.horcrux_register_init_i(horcrux_register_init),
		.horcrux_register_wb_enable_i(combined_wb_enable),
		.horcrux_register_wb_data_i(combined_wb_data),
		.horcrux_register_index_i(c1[5:0]),
		.horcrux_register_o(register_array)
	);
	wire [1599:0] register_array_flat;
	assign register_array_flat = {register_array[(NUM_VARIABLES - 51) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 50) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 49) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 48) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 47) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 46) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 45) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 44) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 43) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 42) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 41) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 40) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 39) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 38) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 37) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 36) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 35) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 34) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 33) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 32) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 31) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 30) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 29) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 28) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 27) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 26) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 25) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 24) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 23) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 22) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 21) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 20) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 19) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 18) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 17) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 16) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 15) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 14) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 13) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 12) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 11) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 10) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 9) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 8) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 7) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 6) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 5) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 4) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 3) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 2) * VARIABLE_WIDTH+:VARIABLE_WIDTH], register_array[(NUM_VARIABLES - 1) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
	always @(*) begin
		if (_sv2v_0)
			;
		if (sphincs_active)
			keccak_input = sphincs_keccak_input;
		else
			keccak_input = register_array_flat;
	end
	keccak_f keccak_i(
		.clk(clk_i),
		.rst_n(rst_ni),
		.start_i(KSTART),
		.Din(keccak_input),
		.Dout(keccak_result),
		.status_d(keccak_status),
		.keccak_intr(done_keccak_o)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < NUM_VARIABLES; i = i + 1)
				keccak_register_array[((NUM_VARIABLES - 1) - i) * VARIABLE_WIDTH+:VARIABLE_WIDTH] = keccak_result[i * VARIABLE_WIDTH+:VARIABLE_WIDTH];
		end
	end
	wire [31:0] cl_store_result;
	wire cl_active;
	chain_lengths #(
		.NUM_VARIABLES(NUM_VARIABLES),
		.VARIABLE_WIDTH(VARIABLE_WIDTH)
	) chain_lengths_inst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.register_array_i(register_array),
		.insn_i(insn_i),
		.store_index_i(a1[3:0]),
		.store_result_o(cl_store_result),
		.cl_active_o(cl_active)
	);
	sphincs_ops #(
		.NUM_VARIABLES(NUM_VARIABLES),
		.VARIABLE_WIDTH(VARIABLE_WIDTH)
	) sphincs_ops_inst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.register_array_i(register_array),
		.insn_i(insn_i),
		.simple_mode_i(|b1),
		.keccak_done_i(done_keccak_o),
		.keccak_result_i(keccak_register_array),
		.sphincs_start_keccak_o(sphincs_start_keccak),
		.sphincs_keccak_input_o(sphincs_keccak_input),
		.sphincs_wb_enable_o(sphincs_wb_enable),
		.sphincs_wb_data_o(sphincs_wb_data),
		.sphincs_active_o(sphincs_active),
		.sphincs_done_o(sphincs_done)
	);
	wire [31:0] sampler_result;
	sampler sampler_inst(
		.data_i(a1),
		.index_i(b1),
		.insn_i(insn_i),
		.result_o(sampler_result)
	);
	wire [31:0] fpr_result;
	wire [31:0] fpr_result_hi;
	fpr fpr_inst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.data1_i(a1),
		.data2_i(b1),
		.data3_i(c1),
		.insn_i(insn_i),
		.result_o(fpr_result),
		.result_hi_o(fpr_result_hi)
	);
	wire [31:0] multiplier_tree_result;
	wire [31:0] multiplier_tree_result_hi;
	multiplier_tree multiplier_tree_inst(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.multiplier_tree1_i(a1),
		.multiplier_tree2_i(b1),
		.multiplier_tree3_i(c1),
		.insn_i(insn_i),
		.result_o(multiplier_tree_result),
		.result_hi_o(multiplier_tree_result_hi)
	);
	wire [5:0] rd3_word0_idx;
	wire [5:0] rd3_word1_idx;
	wire [1:0] rd3_byte_pos;
	wire [63:0] rd3_window;
	wire [63:0] rd3_window_shifted;
	wire [31:0] OP_KREAD3_result;
	assign rd3_byte_pos = a1[1:0];
	assign rd3_word0_idx = a1[7:2];
	assign rd3_word1_idx = a1[7:2] + {5'b00000, |a1[1:0]};
	assign rd3_window = {keccak_register_array[((NUM_VARIABLES - 1) - rd3_word1_idx) * VARIABLE_WIDTH+:VARIABLE_WIDTH], keccak_register_array[((NUM_VARIABLES - 1) - rd3_word0_idx) * VARIABLE_WIDTH+:VARIABLE_WIDTH]};
	assign rd3_window_shifted = rd3_window >> ({4'b0000, rd3_byte_pos} * 4'd8);
	assign OP_KREAD3_result = {8'b00000000, rd3_window_shifted[23:0]};
	always @(*) begin
		if (_sv2v_0)
			;
		out[31-:32] = 1'sb0;
		case (insn_i)
			7'b0000000: out[31-:32] = 1'sb0;
			7'b0001100, 7'b0001101, 7'b0001110, 7'b0001111, 7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011: out[31-:32] = sampler_result;
			7'b0000010: out[31-:32] = (cl_active ? cl_store_result : keccak_register_array[((NUM_VARIABLES - 1) - a1) * VARIABLE_WIDTH+:VARIABLE_WIDTH]);
			7'b0101101: out[31-:32] = OP_KREAD3_result;
			7'b0110100, 7'b0110101, 7'b0110110, 7'b0110111, 7'b0111000, 7'b0111001: out[31-:32] = fpr_result;
			7'b0011011, 7'b0010001, 7'b0011010, 7'b0111010, 7'b0111011, 7'b0011100, 7'b0011101, 7'b0011110, 7'b0011111, 7'b0100000, 7'b0100001, 7'b0100010, 7'b0100011, 7'b0100100, 7'b0100101, 7'b0100110, 7'b0100111, 7'b0101000, 7'b0101001, 7'b0101110, 7'b0101111, 7'b0110011, 7'b1111000, 7'b1111001: out[31-:32] = multiplier_tree_result;
			default: out[31-:32] = 1'sb0;
		endcase
	end
	assign rd_values_o[31-:32] = out[31-:32];
	assign done_sphincs_o = sphincs_done;
	initial _sv2v_0 = 0;
endmodule
module horcrux_xif_wrapper (
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
	localparam _param_8228B_X_NUM_RS = 3;
	generate
		if (1) begin : ext_if
			localparam [31:0] X_NUM_RS = _param_8228B_X_NUM_RS;
			localparam [31:0] X_ID_WIDTH = 4;
			localparam [31:0] X_MEM_WIDTH = 32;
			localparam [31:0] X_RFR_WIDTH = 32;
			localparam [31:0] X_RFW_WIDTH = 32;
			localparam [31:0] X_MISA = 1'sb0;
			localparam [1:0] X_ECS_XS = 1'sb0;
			localparam signed [31:0] XLEN = 32;
			localparam signed [31:0] FLEN = 32;
			wire compressed_valid;
			wire compressed_ready;
			wire [21:0] compressed_req;
			wire [32:0] compressed_resp;
			wire issue_valid;
			reg issue_ready;
			wire [((38 + (X_NUM_RS * X_RFR_WIDTH)) + X_NUM_RS) + 6:0] issue_req;
			reg [8:0] issue_resp;
			wire commit_valid;
			wire [4:0] commit;
			wire mem_valid;
			wire mem_ready;
			wire [81:0] mem_req;
			wire [7:0] mem_resp;
			wire mem_result_valid;
			wire [(X_ID_WIDTH + X_MEM_WIDTH) + 1:0] mem_result;
			reg result_valid;
			wire result_ready;
			reg [(((X_ID_WIDTH + X_RFW_WIDTH) + 5) + (X_RFW_WIDTH / XLEN)) + 17:0] result;
		end
	endgenerate
	assign ext_if.issue_valid = s_xif_issue_valid;
	assign s_xif_issue_ready = ext_if.issue_ready;
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	assign ext_if.issue_req[38 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))-:((38 + ((sv2v_cast_32(3) * 32'd32) + (sv2v_cast_32(3) + 6))) >= (6 + ((sv2v_cast_32(3) * 32'd32) + (sv2v_cast_32(3) + 7))) ? ((38 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) - (6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)))) + 1 : ((6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7))) - (38 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)))) + 1)] = s_xif_issue_req_instr;
	assign ext_if.issue_req[6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))-:((6 + ((sv2v_cast_32(3) * 32'd32) + (sv2v_cast_32(3) + 6))) >= (32'd4 + ((sv2v_cast_32(3) * 32'd32) + (sv2v_cast_32(3) + 7))) ? ((6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) - (32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)))) + 1 : ((32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7))) - (6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)))) + 1)] = s_xif_issue_req_mode;
	assign ext_if.issue_req[32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))-:((32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) >= ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)) ? ((32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7))) + 1 : (((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)) - (32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)))) + 1)] = s_xif_issue_req_id;
	assign ext_if.issue_req[((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) - 1)+:32'd32] = s_xif_issue_req_rs_0;
	assign ext_if.issue_req[((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) - 33)+:32'd32] = s_xif_issue_req_rs_1;
	assign ext_if.issue_req[((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) - 65)+:32'd32] = s_xif_issue_req_rs_2;
	assign ext_if.issue_req[sv2v_cast_32(_param_8228B_X_NUM_RS) + 6-:((sv2v_cast_32(_param_8228B_X_NUM_RS) + 6) >= 7 ? sv2v_cast_32(_param_8228B_X_NUM_RS) + 0 : 8 - (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))] = s_xif_issue_req_rs_valid;
	assign ext_if.issue_req[6-:6] = 1'sb0;
	assign ext_if.issue_req[0] = 1'sb0;
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
	assign ext_if.mem_result_valid = s_xif_mem_result_valid;
	assign ext_if.mem_result[37-:4] = s_xif_mem_result_id;
	assign ext_if.mem_result[33-:32] = s_xif_mem_result_rdata;
	assign ext_if.mem_result[1] = s_xif_mem_result_err;
	assign s_xif_result_valid = ext_if.result_valid;
	assign ext_if.result_ready = s_xif_result_ready;
	assign s_xif_result_id = ext_if.result[41 + ((32'd32 / 32'sd32) + 17)-:((41 + ((32'd32 / 32'sd32) + 17)) >= (37 + ((32'd32 / 32'sd32) + 18)) ? ((41 + ((32'd32 / 32'sd32) + 17)) - (37 + ((32'd32 / 32'sd32) + 18))) + 1 : ((37 + ((32'd32 / 32'sd32) + 18)) - (41 + ((32'd32 / 32'sd32) + 17))) + 1)];
	assign s_xif_result_data = ext_if.result[37 + ((32'd32 / 32'sd32) + 17)-:((37 + ((32'd32 / 32'sd32) + 17)) >= (5 + ((32'd32 / 32'sd32) + 18)) ? ((37 + ((32'd32 / 32'sd32) + 17)) - (5 + ((32'd32 / 32'sd32) + 18))) + 1 : ((5 + ((32'd32 / 32'sd32) + 18)) - (37 + ((32'd32 / 32'sd32) + 17))) + 1)];
	assign s_xif_result_rd = ext_if.result[5 + ((32'd32 / 32'sd32) + 17)-:((5 + ((32'd32 / 32'sd32) + 17)) >= ((32'd32 / 32'sd32) + 18) ? ((5 + ((32'd32 / 32'sd32) + 17)) - ((32'd32 / 32'sd32) + 18)) + 1 : (((32'd32 / 32'sd32) + 18) - (5 + ((32'd32 / 32'sd32) + 17))) + 1)];
	assign s_xif_result_we = ext_if.result[(32'd32 / 32'sd32) + 17-:(((32'd32 / 32'sd32) + 17) >= 18 ? (32'd32 / 32'sd32) + 0 : 19 - ((32'd32 / 32'sd32) + 17))];
	assign s_xif_result_exc = ext_if.result[8];
	assign s_xif_result_exccode = ext_if.result[7-:6];
	assign ext_if.compressed_valid = 1'b0;
	assign ext_if.compressed_req = 1'sb0;
	generate
		if (1) begin : coproc_wrapper_i
			wire clk_i;
			wire rst_ni;
			if (1) begin : horcrux_top_i
				wire clk_i;
				wire rst_ni;
				wire [95:0] rs_values;
				wire [31:0] rd_values;
				wire [6:0] select_insn;
				wire [4:0] rd_idex;
				reg [4:0] rd_excom;
				wire [3:0] id_idex;
				reg [3:0] id_excom;
				wire save_rd;
				wire done;
				wire OP_KSTART;
				wire keccak_done_o;
				wire sphincs_done_o;
				assign horcrux_xif_wrapper.ext_if.compressed_ready = 1'sb0;
				assign horcrux_xif_wrapper.ext_if.compressed_resp = 1'sb0;
				assign horcrux_xif_wrapper.ext_if.mem_valid = 1'sb0;
				assign horcrux_xif_wrapper.ext_if.mem_req = 1'sb0;
				if (1) begin : id_stage_i
					reg _sv2v_0;
					wire clk_i;
					wire rst_ni;
					wire keccak_done_i;
					wire sphincs_done_i;
					reg [95:0] rs_values_o;
					reg [4:0] rd_o;
					reg [3:0] id_o;
					reg [6:0] select_insn_o;
					wire save_rd_o;
					wire done_o;
					reg [1:0] state_q;
					reg [1:0] state_d;
					reg state_keccak;
					reg state_sphincs;
					wire [31:0] instruction;
					reg [95:0] rs_values;
					reg [6:0] select_insn;
					localparam [31:0] horcrux_pkg_NbInstr = 57;
					wire [56:0] sel;
					reg sample_in;
					reg save_rd;
					wire result_reg_en;
					reg done;
					assign instruction = horcrux_xif_wrapper.ext_if.issue_req[38 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))-:((38 + ((sv2v_cast_32(3) * 32'd32) + (sv2v_cast_32(3) + 6))) >= (6 + ((sv2v_cast_32(3) * 32'd32) + (sv2v_cast_32(3) + 7))) ? ((38 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) - (6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)))) + 1 : ((6 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7))) - (38 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)))) + 1)];
					genvar _gv_i_3;
					localparam [4787:0] horcrux_pkg_CoproInstr = 4788'b1100000000000010000011010110000011000000000011100000111111110111000001110000101000000000000000000010000011010110000011000000000011100000111111110111000000110000001000111100000000001110000001110111111111000000000011100000111111111110000001010000101000000100000000000010000011010110000011000000000011100000111111110111000010010000001000001000000000000010000011010110000011000000000011100000111111110111000010110000001000111000000000001110000001110111111111000000000011100000111111110000000011010000001000000000000000001110000001110111111111000000000011100000111111111110000110010000111000000100000000001110000001110111111111000000000011100000111111111110000110110000111000001000000000001110000001110111111111000000000011100000111111111110000111010000111000001100000000001110000001110111111111000000000011100000111111111110000111110000111000010100000000001110000001110111111111000000000011100000111111111110001000110000010101100000000000001110000001110111111111000000000011100000111111111001001101010000010101100100000000001110000001110111111111000000000011100000111111111001011101010000010101101000000000001110000001110111111111000000000011100000111111111001011101110000010000000000000000001110000011010110000011000000000011100000111111111111001101110000110000000100000000001110000011010110000011000000000011100000111111111111001110010000110000001000000000001110000011010110000011000000000011100000111111111111010010010000110000001100000000001110000011010110000011000000000011100000111111111111010011010000110000000000000000001100000011010110000011000000000011100000111111111111010111010000110000000100000000001100000011010110000011000000000011100000111111111111010111110000110001000000000000001110000001110111111111000000000011100000111111111110001110110000110001000100000000001110000001110111111111000000000011100000111111111110001111010000110001001000000000001110000001110111111111000000000011100000111111111110001111110000110001001100000000001110000001110111111111000000000011100000111111111110010000010000110001010000000000001110000001110111111111000000000011100000111111111110010000110000110001010100000000001110000001110111111111000000000011100000111111111110010001010000110001011000000000001110000001110111111111000000000011100000111111111110010001110000110001011100000000001110000001110111111111000000000011100000111111111110010010110000110001100000000000001110000001110111111111000000000011100000111111111110010011110000110001100100000000001110000001110111111111000000000011100000111111111110010100010000110001101000000000001110000001110111111111000000000011100000111111111110010100110000110000001000000000001100000011010110000011000000000011100000111111111111011001110000110011001100000000001110000001110111111111000000000011100000111111111110011010010000110011010000000000001110000001110111111111000000000011100000111111111110011010110000110011010100000000001110000001110111111111000000000011100000111111111000011011010000110000001100000000001100000011010110000011000000000011100000111111111111011011110000110011011000000000001110000001110111111111000000000011100000111111111000011100010000110011011100000000001110000001110111111111000000000011100000111111111000011100110000110001101100000000001110000001110111111111000000000011100000111111110000010101010001000001110000000000001110000001110111111111000000000011100000111111110000010101110001000001110100000000001110000001110111111111000000000011100000111111110000010110010001000000110100000000001110000001110111111111000000000011100000111111111100010110110000101011000000000000001110000001110111111111000000000011100000111111110010011000000001001011000100000000001110000001110111111111000000000011100000111111110010011000100001001011001000000000001110000001110111111111000000000011100000111111110000011001000001001011110000000000001110000001110111111111000000000011100000111111110010011110000001001011110100000000001110000001110111111111000000000011100000111111110010011110100001001011111000000000001110000001110111111111000000000011100000111111110010011111000001001011111100000000001110000001110111111111000000000011100000111111110010011111100001001100000000000000001110000001110111111111000000000011100000111111110000100000000001001100000100000000001110000001110111111111000000000011100000111111110000100000100001001111100000000000001110000001110111111111000000000011100000111111111001111100010000110111100100000000001110000001110111111111000000000011100000111111111011111100110000110100100000000000001110000001110111111111000000000011100000111111111001100100010001010100100100000000001110000001110111111111000000000011100000111111111011100100110001010100101000000000001110000001110111111111000000000011100000111111111011100101010001010100101100000000001110000001110111111111000000000011100000111111111011100101110001010;
					for (_gv_i_3 = 0; _gv_i_3 < horcrux_pkg_NbInstr; _gv_i_3 = _gv_i_3 + 1) begin : gen_predecoder_selector
						localparam i = _gv_i_3;
						assign sel[i] = (horcrux_pkg_CoproInstr[((56 - i) * 84) + 51-:32] & instruction) == horcrux_pkg_CoproInstr[((56 - i) * 84) + 83-:32];
					end
					always @(*) begin
						if (_sv2v_0)
							;
						state_d = state_q;
						case (state_q)
							2'd0:
								if (state_sphincs)
									state_d = 2'd2;
								else if (state_keccak)
									state_d = 2'd1;
								else
									state_d = 2'd0;
							2'd1:
								if (keccak_done_i)
									state_d = 2'd0;
							2'd2:
								if (sphincs_done_i)
									state_d = 2'd0;
							default: state_d = 2'd0;
						endcase
					end
					always @(*) begin
						if (_sv2v_0)
							;
						horcrux_xif_wrapper.ext_if.issue_resp[2] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[1] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[0] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[8] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[7] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[5-:3] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[6] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[2] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[1] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_resp[0] = 1'sb0;
						horcrux_xif_wrapper.ext_if.issue_ready = 1'sb0;
						sample_in = 1'sb0;
						select_insn = 7'b0000000;
						save_rd = 1'sb0;
						rs_values = 1'sb0;
						rd_o = 1'sb0;
						id_o = 1'sb0;
						begin : sv2v_autoblock_1
							reg [31:0] i;
							for (i = 0; i < horcrux_pkg_NbInstr; i = i + 1)
								if (sel[i] && horcrux_xif_wrapper.ext_if.issue_valid) begin
									horcrux_xif_wrapper.ext_if.issue_ready = 1'b1;
									horcrux_xif_wrapper.ext_if.issue_resp[8] = horcrux_pkg_CoproInstr[((56 - i) * 84) + 19];
									horcrux_xif_wrapper.ext_if.issue_resp[7] = horcrux_pkg_CoproInstr[((56 - i) * 84) + 18];
									horcrux_xif_wrapper.ext_if.issue_resp[5-:3] = horcrux_pkg_CoproInstr[((56 - i) * 84) + 17];
									sample_in = 1'b1;
									select_insn = horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7];
									save_rd = 1'b1;
									rs_values[95-:32] = horcrux_xif_wrapper.ext_if.issue_req[((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) - 1)+:32'd32];
									rs_values[63-:32] = horcrux_xif_wrapper.ext_if.issue_req[((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) - 33)+:32'd32];
									rs_values[31-:32] = horcrux_xif_wrapper.ext_if.issue_req[((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) - 65)+:32'd32];
									rd_o = instruction[11-:5];
									id_o = horcrux_xif_wrapper.ext_if.issue_req[32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))-:((32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) >= ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)) ? ((32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6))) - ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7))) + 1 : (((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 7)) - (32'd4 + ((sv2v_cast_32(_param_8228B_X_NUM_RS) * 32'd32) + (sv2v_cast_32(_param_8228B_X_NUM_RS) + 6)))) + 1)];
								end
						end
					end
					reg done_d;
					reg state_keccak_d;
					reg state_sphincs_d;
					always @(*) begin
						if (_sv2v_0)
							;
						done_d = 1'b0;
						state_keccak_d = 1'b0;
						state_sphincs_d = 1'b0;
						if (horcrux_xif_wrapper.ext_if.issue_valid) begin : sv2v_autoblock_2
							reg [31:0] i;
							for (i = 0; i < horcrux_pkg_NbInstr; i = i + 1)
								if (sel[i]) begin
									if (((((((((horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0110000) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0110001)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0110010)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0111100)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0111101)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0111110)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0111111)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b1000000)) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b1000001)) begin
										done_d = 1'b0;
										state_sphincs_d = 1'b1;
									end
									else if ((horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0000001) || (horcrux_pkg_CoproInstr[((56 - i) * 84) + 14-:7] == 7'b0000101)) begin
										done_d = 1'b0;
										state_keccak_d = 1'b1;
									end
									else
										done_d = horcrux_pkg_CoproInstr[((56 - i) * 84) + 7];
								end
						end
					end
					always @(posedge clk_i or negedge rst_ni) begin : pipe_reg_ID_EX
						if (~rst_ni) begin
							state_q <= 2'd0;
							rs_values_o <= 1'sb0;
							select_insn_o <= 7'b0000000;
							done <= 1'sb0;
							state_keccak <= 1'sb0;
							state_sphincs <= 1'sb0;
						end
						else begin
							state_q <= state_d;
							rs_values_o <= rs_values;
							select_insn_o <= select_insn;
							done <= done_d;
							state_keccak <= state_keccak_d;
							state_sphincs <= state_sphincs_d;
						end
					end
					assign save_rd_o = save_rd;
					assign done_o = (done | ((state_q == 2'd2) && sphincs_done_i)) | ((state_q == 2'd1) && keccak_done_i);
					initial _sv2v_0 = 0;
				end
				assign id_stage_i.clk_i = clk_i;
				assign id_stage_i.rst_ni = rst_ni;
				assign id_stage_i.keccak_done_i = keccak_done_o;
				assign id_stage_i.sphincs_done_i = sphincs_done_o;
				assign rs_values = id_stage_i.rs_values_o;
				assign rd_idex = id_stage_i.rd_o;
				assign id_idex = id_stage_i.id_o;
				assign select_insn = id_stage_i.select_insn_o;
				assign save_rd = id_stage_i.save_rd_o;
				assign done = id_stage_i.done_o;
				assign OP_KSTART = (select_insn == 7'b0000001) || (select_insn == 7'b0000101);
				horcrux #(
					.NUM_VARIABLES(50),
					.VARIABLE_WIDTH(32)
				) i_horcrux(
					.clk_i(clk_i),
					.rst_ni(rst_ni),
					.rs_values_i(rs_values),
					.insn_i(select_insn),
					.start_keccak_i(OP_KSTART),
					.done_keccak_o(keccak_done_o),
					.done_sphincs_o(sphincs_done_o),
					.rd_values_o(rd_values)
				);
				always @(posedge clk_i or negedge rst_ni)
					if (~rst_ni) begin
						rd_excom <= 1'sb0;
						id_excom <= 1'sb0;
					end
					else if (save_rd) begin
						rd_excom <= rd_idex;
						id_excom <= id_idex;
					end
					else begin
						rd_excom <= rd_excom;
						id_excom <= id_excom;
					end
				if (1) begin : commit_stage_i
					reg _sv2v_0;
					wire clk_i;
					wire rst_ni;
					wire [4:0] rd_i;
					wire [3:0] id_i;
					wire [31:0] result_i;
					wire done_i;
					always @(*) begin
						if (_sv2v_0)
							;
						horcrux_xif_wrapper.ext_if.result_valid = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[(32'd32 / 32'sd32) + 17-:(((32'd32 / 32'sd32) + 17) >= 18 ? (32'd32 / 32'sd32) + 0 : 19 - ((32'd32 / 32'sd32) + 17))] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[5 + ((32'd32 / 32'sd32) + 17)-:((5 + ((32'd32 / 32'sd32) + 17)) >= ((32'd32 / 32'sd32) + 18) ? ((5 + ((32'd32 / 32'sd32) + 17)) - ((32'd32 / 32'sd32) + 18)) + 1 : (((32'd32 / 32'sd32) + 18) - (5 + ((32'd32 / 32'sd32) + 17))) + 1)] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[41 + ((32'd32 / 32'sd32) + 17)-:((41 + ((32'd32 / 32'sd32) + 17)) >= (37 + ((32'd32 / 32'sd32) + 18)) ? ((41 + ((32'd32 / 32'sd32) + 17)) - (37 + ((32'd32 / 32'sd32) + 18))) + 1 : ((37 + ((32'd32 / 32'sd32) + 18)) - (41 + ((32'd32 / 32'sd32) + 17))) + 1)] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[17-:6] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[8] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[11-:3] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[7-:6] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[1] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[0] = 1'sb0;
						horcrux_xif_wrapper.ext_if.result[37 + ((32'd32 / 32'sd32) + 17)-:((37 + ((32'd32 / 32'sd32) + 17)) >= (5 + ((32'd32 / 32'sd32) + 18)) ? ((37 + ((32'd32 / 32'sd32) + 17)) - (5 + ((32'd32 / 32'sd32) + 18))) + 1 : ((5 + ((32'd32 / 32'sd32) + 18)) - (37 + ((32'd32 / 32'sd32) + 17))) + 1)] = result_i[31-:32];
						if (done_i) begin
							horcrux_xif_wrapper.ext_if.result_valid = 1'sb1;
							horcrux_xif_wrapper.ext_if.result[(32'd32 / 32'sd32) + 17-:(((32'd32 / 32'sd32) + 17) >= 18 ? (32'd32 / 32'sd32) + 0 : 19 - ((32'd32 / 32'sd32) + 17))] = done_i;
							horcrux_xif_wrapper.ext_if.result[5 + ((32'd32 / 32'sd32) + 17)-:((5 + ((32'd32 / 32'sd32) + 17)) >= ((32'd32 / 32'sd32) + 18) ? ((5 + ((32'd32 / 32'sd32) + 17)) - ((32'd32 / 32'sd32) + 18)) + 1 : (((32'd32 / 32'sd32) + 18) - (5 + ((32'd32 / 32'sd32) + 17))) + 1)] = rd_i;
							horcrux_xif_wrapper.ext_if.result[41 + ((32'd32 / 32'sd32) + 17)-:((41 + ((32'd32 / 32'sd32) + 17)) >= (37 + ((32'd32 / 32'sd32) + 18)) ? ((41 + ((32'd32 / 32'sd32) + 17)) - (37 + ((32'd32 / 32'sd32) + 18))) + 1 : ((37 + ((32'd32 / 32'sd32) + 18)) - (41 + ((32'd32 / 32'sd32) + 17))) + 1)] = id_i;
						end
					end
					initial _sv2v_0 = 0;
				end
				assign commit_stage_i.clk_i = clk_i;
				assign commit_stage_i.rst_ni = rst_ni;
				assign commit_stage_i.rd_i = rd_excom;
				assign commit_stage_i.id_i = id_excom;
				assign commit_stage_i.result_i = rd_values;
				assign commit_stage_i.done_i = done;
			end
			assign horcrux_top_i.clk_i = clk_i;
			assign horcrux_top_i.rst_ni = rst_ni;
		end
	endgenerate
	assign coproc_wrapper_i.clk_i = clk_i;
	assign coproc_wrapper_i.rst_ni = rst_ni;
endmodule