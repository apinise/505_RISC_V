//////////////////////////////////////////////////////////////// 
// Engineer: Evan Apinis
// 
// Module Name: instruct_mem.sv
// Project Name: RV32I 
// Description: 
// 
// Instruction memory for RV32I hart
// 
//
// Revision 0.01 - File Created
// 
////////////////////////////////////////////////////////////////

module instruct_mem #(
  parameter DWIDTH = 32,
  parameter MEM_SIZE = 16384 // Mem size in words
)(
  input   logic               Clk_Core,
  input   logic               Rst_Core_N,
  input   logic [DWIDTH-1:0]  Program_Count,
  output  logic [31:0]        Instruction
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

localparam ADDR_SIZE = $clog2(MEM_SIZE); // Parameterized address size based on mem size in words

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [31:0] instr_mem [0:MEM_SIZE-1];  // Create BRAM
logic [ADDR_SIZE-1:0] 	rom_addr;	      // Read address net

integer i;

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

assign rom_addr = Program_Count[ADDR_SIZE+1:2]; // Assign effective address range
assign Instruction = instr_mem[rom_addr];       //Asynchronous read from instruct mem

initial begin
  for (i=0; i<MEM_SIZE; i++) begin //Fill Instruct with 0 before writing from file
    instr_mem[i] = '0;
	end
  $readmemh("../../../../../../project/mem_files/instruct_file_r.txt", instr_mem); //read hex from instruct file
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
instruct_mem #(
  .DWIDTH()
  .MEM_SIZE(16384)
)
instruct_mem (
  .Clk_Core(),
  .Rst_Core_N(),
  .Program_Count(),
  .Instruction()
);
*/

endmodule