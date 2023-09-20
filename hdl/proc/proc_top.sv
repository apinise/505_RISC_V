//////////////////////////////////////////////////////////////// 
// Engineer: Evan Apinis
// 
// Module Name: proc_top.sv
// Project Name: RV32I 
// Description: 
// 
// RV32I processor top file including hart datapath and
// memory modules
//
// Revision 0.01 - File Created
// 
////////////////////////////////////////////////////////////////

module proc_top #(
  parameter DWIDTH = 32
)(
  input logic Clk_Core,
  input logic Rst_Core_N,
  output logic [15:0] Addr
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic Clk_Core_g;
logic Clk_Core_N;
logic clk_enable;

// Instruction Mem Interface Nets
logic [DWIDTH-1:0]  program_count;
logic [31:0]        instruction;

// Data Mem Interface Nets
logic [DWIDTH-1:0]  data_mem_address;
logic [DWIDTH-1:0]  data_mem_read;
logic [DWIDTH-1:0]  data_mem_write;
logic [3:0]         data_mem_write_ctrl;
logic               data_mem_read_ctrl;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

core core_1 (
  .Clk_Core       (Clk_Core),
  .Rst_Core_N     (Rst_Core_N),
  .Instruction    (instruction),
  .Program_Count  (program_count),
  .Mem_Data_Read  (data_mem_read),
  .Mem_Data_Write (data_mem_write),
  .Mem_Data_Addr  (data_mem_address),
  .Mem_Read_Ctrl  (data_mem_read_ctrl),
  .Mem_Write_Ctrl (data_mem_write_ctrl),
  .Clk_Enable     (clk_enable)
);

instruct_mem instruct_mem (
  .Clk_Core       (Clk_Core),
  .Rst_Core_N     (Rst_Core_N),
  .Program_Count  (program_count),
  .Instruction    (instruction)
);

data_mem data_mem (
  .Clk_Core         (Clk_Core_N),
  .Read_Ctrl        (data_mem_read_ctrl),
  .Write_Ctrl       (data_mem_write_ctrl),
  .Mem_Data_Address (data_mem_address),
  .Mem_Data_Write   (data_mem_write),
  .Mem_Data_Read    (data_mem_read)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

assign Clk_Core_N = ~Clk_Core;
assign Addr = data_mem_address[15:0];

always_comb begin
  if (clk_enable) begin
    Clk_Core_g  = Clk_Core;
  end
  else begin
    Clk_Core_g = 1'b0;
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
proc_top #(
  .DWIDTH()
)
proc_top (
  .Clk_Core(),
  .Rst_Core_N()
);
*/

endmodule