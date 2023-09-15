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

// Nets for register read data
logic [DWIDTH-1:0] reg_read_data_1;
logic [DWIDTH-1:0] reg_read_data_2;

// Nets for alu input data from muxs
logic [DWIDTH-1:0] alu_input_a;
logic [DWIDTH-1:0] alu_input_b;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

alu #(
  .DWIDTH(DWIDTH)
)
alu
(
  .ALU_In_A     (alu_input_a),
  .ALU_In_B     (alu_input_b),
  .ALU_OP       (),
  .ALU_Out      (),
  .ALU_Zero_Flag()
);

program_counter #(
  .DWIDTH(DWIDTH)
)
program_counter (
  .Clk_Core         (Clk_Core),
  .Rst_Core_N       (Rst_Core_N),
  .PC_Sel           (),
  .Program_Count_Imm(),
  .Program_Count_Off(),
  .Program_Count    (Program_Count)
);

register_file (
  .Clk_Core         (Clk_Core),
  .Rst_Core_N       (Rst_Core_N),
  .Read_Addr_Port_1 (),
  .Read_Data_Port_1 (reg_read_data_1),
  .Read_Addr_Port_2 (),
  .Read_Data_Port_2 (reg_read_data_2),
  .Write_Addr_Port_1(),
  .Write_Data_Port_1(),
  .Wr_En            ()
);

// Multiplexers for alu inputs
mux2to1 #(
  .DWIDTH(DWIDTH)
)
alu_in_a_mux (
  .Mux_In_A(reg_read_data_1),
  .Mux_In_B(),
  .Input_Sel(),
  .Mux_Out(alu_input_a)
);

mux2to1 #(
  .DWIDTH(DWIDTH)
)
alu_in_b_mux (
  .Mux_In_A(reg_read_data_2),
  .Mux_In_B(),
  .Input_Sel(),
  .Mux_Out(alu_input_b)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

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