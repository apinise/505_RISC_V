//////////////////////////////////////////////////////////////// 
// Engineer: Evan Apinis
// 
// Module Name: core.sv
// Project Name: RV32I 
// Description: 
// 
// RV32I hart datapath excluding memory modules
// 
//
// Revision 0.01 - File Created
// 
////////////////////////////////////////////////////////////////

module core #(
  parameter DWIDTH = 32
)(
  // Global clock and reset
  input   logic               Clk_Core,     // Core Clk
  input   logic               Rst_Core_N,   // Core Clk Rst
  // Instruction memory interface
  input   logic [31:0]        Instruction,  // Instruction from mem
  output  logic [DWIDTH-1:0]  Program_Count // Program count for mem address
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

// REGISTER FILE NETS
// Nets for register read data
logic [DWIDTH-1:0]  reg_read_data_1;
logic [DWIDTH-1:0]  reg_read_data_2;
// Nets for register read addr
logic [4:0]         reg_read_addr_1;
logic [4:0]         reg_read_addr_2;
// Nets for register write
logic [DWIDTH-1:0]  reg_write_data;
logic [4:0]         reg_write_addr;
// Nets for register write enable
logic               reg_wr_en;

// ALU NETS
// Nets for alu input data from muxs
logic [DWIDTH-1:0]  alu_input_a;
logic [DWIDTH-1:0]  alu_input_b;
// Nets for general purpose alu signals
logic [DWIDTH-1:0]  alu_output;
logic [3:0]         alu_opcode;
logic               alu_zero_flag;

// PROGRAM COUNTER NETS
// Nets for program counter signals
logic [DWIDTH-1:0] program_count;
logic [DWIDTH-1:0] program_count_offset;
logic [DWIDTH-1:0] program_count_imm;

// Nets for mux control signals
logic       mux_pc_sel;
logic       mux_alu_a_sel;
logic       mux_alu_b_sel;
logic [1:0] mux_wb_sel;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

// Control Logic
ctrl_logic ctrl_logic (
  .Instruction    (Instruction),    // Instruct from mem
  .ALU_Opcode     (alu_opcode),     // ALU Opcode to alu
  .Reg_Wr_En      (reg_wr_en),      // Reg write enable to reg
  .PC_Sel         (mux_pc_sel),     // PC Mux selection
  .ALU_Input_A_Sel(mux_alu_a_sel),  // ALU input a selection
  .ALU_Input_B_Sel(mux_alu_b_sel),  // ALU input b selection
  .Reg_WB_Sel     (mux_wb_sel)      // Reg write back mux selection
);

// ALU
alu #(
  .DWIDTH(DWIDTH)
)
alu
(
  .ALU_In_A     (alu_input_a),  // ALU input a from mux
  .ALU_In_B     (alu_input_b),  // ALU input b from mux
  .ALU_OP       (alu_opcode),   // ALU opcode from ctrl logic
  .ALU_Out      (alu_output),   // ALU output to write back mux, data mem, pc mux
  .ALU_Zero_Flag(alu_zero_flag) // ALU zero flag
);

// Program Counter
program_counter_top #(
  .DWIDTH(DWIDTH)
)
program_counter_top (
  .Clk_Core         (Clk_Core),
  .Rst_Core_N       (Rst_Core_N),
  .PC_Sel           (mux_pc_sel),           // Program counter load selection
  .Program_Count_Imm(program_count_imm),    // ALU value to load to pc
  .Program_Count_Off(program_count_offset), // PC+4 value to load to pc
  .Program_Count    (Program_Count)         // Current pc to instruct mem, and alu input a mux
);

// Register File
register_file register_file (
  .Clk_Core         (Clk_Core),
  .Rst_Core_N       (Rst_Core_N),
  .Read_Addr_Port_1 (reg_read_addr_1),  // Reg read addr 1 from instruction
  .Read_Data_Port_1 (reg_read_data_1),  // Reg read data 1 to alu input a mux
  .Read_Addr_Port_2 (reg_read_addr_2),  // Reg read addr 2 from instruction
  .Read_Data_Port_2 (reg_read_data_2),  // Reg read data 2 to alu input b mux
  .Write_Addr_Port_1(reg_write_addr),   // Reg write addr from instruction
  .Write_Data_Port_1(reg_write_data),   // Reg write data from writeback mux
  .Wr_En            (reg_wr_en)         // Reg write ctrl from ctrl logic
);

// Multiplexers for alu inputs
mux2to1 #(
  .DWIDTH(DWIDTH)
)
alu_in_a_mux (
  .Mux_In_A (reg_read_data_1),  // Reg data
  .Mux_In_B (program_count),    // Current PC
  .Input_Sel(mux_alu_a_sel),
  .Mux_Out  (alu_input_a)
);

mux2to1 #(
  .DWIDTH(DWIDTH)
)
alu_in_b_mux (
  .Mux_In_A (reg_read_data_2),  // Reg data
  .Mux_In_B (32'd0),            // Immediate gen value
  .Input_Sel(mux_alu_b_sel),
  .Mux_Out  (alu_input_b)
);

// Multiplexer for data write back
mux3to1 #(
  .DWIDTH(DWIDTH)
)
write_back_mux (
  .Mux_In_A (32'd0),                // Data mem value
  .Mux_In_B (alu_output),           // ALU output value
  .Mux_In_C (program_count_offset), // PC+4 value
  .Input_Sel(mux_wb_sel),           // Writeback selection from ctrl logic
  .Mux_Out  (reg_write_data)        // Writeback data to reg data port
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Register assignments
assign reg_read_addr_1  = Instruction[19:15];
assign reg_read_addr_2  = Instruction[24:20];
assign reg_write_addr   = Instruction[11:7];

// Program counter assignments
assign program_count      = Program_Count;
assign program_count_imm  = alu_output;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
core #(
  .DWIDTH()
)
core (
  .Clk_Core(),
  .Rst_Core_N(),
  .Instruction(),
  .Program_Count()
);
*/
endmodule