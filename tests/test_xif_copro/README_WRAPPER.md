# XIF Coprocessor Wrapper Interface

## Overview

The `xif_copro_wrapper` exposes the CV-X-IF interface as individual Verilog vectors instead of using SystemVerilog interfaces. This makes it easy to use with CocoTB and other testbenches.

## Interface Signals

### Clock and Reset
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `clk_i` | Input | 1 | Clock |
| `rst_ni` | Input | 1 | Active-low reset |

### Issue Interface (CPU → Coprocessor)
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `s_xif_issue_valid` | Input | 1 | Issue handshake valid |
| `s_xif_issue_ready` | Output | 1 | Issue handshake ready |
| `s_xif_issue_req_instr` | Input | 32 | Instruction to execute |
| `s_xif_issue_req_mode` | Input | 2 | Privilege mode (11=Machine) |
| `s_xif_issue_req_id` | Input | 4 | Transaction ID |
| `s_xif_issue_req_rs_0` | Input | 32 | Source register rs1 value |
| `s_xif_issue_req_rs_1` | Input | 32 | Source register rs2 value |
| `s_xif_issue_req_rs_valid` | Input | 2 | Which source registers are valid |
| `s_xif_issue_resp_accept` | Output | 1 | Instruction accepted |
| `s_xif_issue_resp_writeback` | Output | 1 | Will write back to rd |
| `s_xif_issue_resp_loadstore` | Output | 1 | Is load/store instruction |
| `s_xif_issue_resp_exc` | Output | 1 | Can cause exception |

### Commit Interface (CPU → Coprocessor)
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `s_xif_commit_valid` | Input | 1 | Commit valid |
| `s_xif_commit_id` | Input | 4 | Transaction ID to commit |
| `s_xif_commit_kill` | Input | 1 | Kill the instruction (1) or commit (0) |

### Memory Request Interface (Coprocessor → CPU)
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `s_xif_mem_valid` | Output | 1 | Memory request valid |
| `s_xif_mem_ready` | Input | 1 | Memory ready |
| `s_xif_mem_req_id` | Output | 4 | Transaction ID |
| `s_xif_mem_req_addr` | Output | 32 | Memory address |
| `s_xif_mem_req_we` | Output | 1 | Write enable (1=store, 0=load) |
| `s_xif_mem_req_size` | Output | 3 | Transfer size |
| `s_xif_mem_req_be` | Output | 4 | Byte enables |
| `s_xif_mem_req_wdata` | Output | 32 | Write data |
| `s_xif_mem_resp_exc` | Input | 1 | Memory exception occurred |

### Memory Result Interface (CPU → Coprocessor)
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `s_xif_mem_result_valid` | Input | 1 | Memory result valid |
| `s_xif_mem_result_id` | Input | 4 | Transaction ID |
| `s_xif_mem_result_rdata` | Input | 32 | Read data |
| `s_xif_mem_result_err` | Input | 1 | Bus error occurred |

### Result Interface (Coprocessor → CPU)
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `s_xif_result_valid` | Output | 1 | Result valid |
| `s_xif_result_ready` | Input | 1 | Ready to accept result |
| `s_xif_result_id` | Output | 4 | Transaction ID |
| `s_xif_result_data` | Output | 32 | Result data to write to rd |
| `s_xif_result_rd` | Output | 5 | Destination register |
| `s_xif_result_we` | Output | 1 | Write enable |
| `s_xif_result_exc` | Output | 1 | Exception occurred |
| `s_xif_result_exccode` | Output | 6 | Exception code |

## BITREV Instruction Encoding

For the bit reversal instruction:
- **Opcode**: `0x2B` (7 bits: `0101011`)
- **funct3**: `0x7` (3 bits: `111`)
- **funct7**: `0x02` (7 bits: `0000010`)
- **Format**: `funct7[31:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | rd[11:7] | opcode[6:0]`

Example: `BITREV x10, x5` = `0x00A3BF2B`

## Usage Example (CocoTB)

```python
# Build BITREV instruction
def build_bitrev_instr(rd, rs1):
    return (0x02 << 25) | (0x0 << 20) | (rs1 << 15) | (0x7 << 12) | (rd << 7) | 0x2B

# Send instruction
dut.s_xif_issue_valid.value = 1
dut.s_xif_issue_req_instr.value = build_bitrev_instr(rd=10, rs1=5)
dut.s_xif_issue_req_id.value = 1
dut.s_xif_issue_req_rs_0.value = 0xDEADBEEF  # Input value
dut.s_xif_issue_req_rs_valid.value = 0x1     # rs1 valid

# Wait for ready
while not dut.s_xif_issue_ready.value:
    await RisingEdge(dut.clk_i)

# Commit
dut.s_xif_commit_valid.value = 1
dut.s_xif_commit_id.value = 1
dut.s_xif_commit_kill.value = 0

# Wait for result
while not dut.s_xif_result_valid.value:
    await RisingEdge(dut.clk_i)

result = dut.s_xif_result_data.value  # 0xF77DB57B (reversed)
```

## Protocol Flow

1. **Issue**: CPU sends instruction with `s_xif_issue_valid` and waits for `s_xif_issue_ready`
2. **Accept**: Coprocessor responds with `s_xif_issue_resp_accept` if it can execute
3. **Commit**: CPU commits with `s_xif_commit_valid` (or kills with `s_xif_commit_kill=1`)
4. **Execute**: Coprocessor executes the instruction
5. **Result**: Coprocessor returns result via `s_xif_result_valid`/`s_xif_result_ready` handshake

## Simple Test Sequence

For non-memory instructions like BITREV:

1. Assert `rst_ni=0`, wait, then `rst_ni=1`
2. Set `s_xif_result_ready=1` (always ready to receive)
3. Set `s_xif_mem_ready=1` (memory ready if needed)
4. Send instruction via issue interface
5. Commit the instruction
6. Wait for result
7. Read result data

See `test_xif_example.py` for a complete working example.
