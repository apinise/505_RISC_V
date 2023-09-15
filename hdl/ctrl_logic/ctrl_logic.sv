//////////////////////////////////////////////////////////////// 
// Engineer: Evan Apinis
// 
// Module Name: ctrl_logic.sv
// Project Name: RV32I 
// Description: 
// 
// Control logic for RV32I to decode instructions and control
// datapathing.
//
// Revision 0.01 - File Created
// 
////////////////////////////////////////////////////////////////

module ctrl_logic (
  input   logic [31:0]  Instruction,
  // ALU control signal
  output  logic [3:0]   ALU_Opcode,
  // Register control signal
  output  logic         Reg_Wr_En,
  // Mux control signals
  output  logic         PC_Sel,
  output  logic         ALU_Input_A_Sel,
  output  logic         ALU_Input_B_Sel,
  output  logic [1:0]   Reg_WB_Sel
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

// OPCODES
localparam OPCODE_ALU_R 	  = 7'b0110011; //Register types
localparam OPCODE_ALU_IMM_I = 7'b0010011; //Immediate types
localparam OPCODE_LW 		    = 7'b0000011; //Load word types
localparam OPCODE_SW 		    = 7'b0100011; //Store word types
localparam OPCODE_BRANCH 	  = 7'b1100011; //Branch types
localparam OPCODE_JALR 		  = 7'b1100111;
localparam OPCODE_JAL 		  = 7'b1101111;
localparam OPCODE_LUI 		  = 7'b0110111;
localparam OPCODE_AUIPC 	  = 7'b0010111;

// Decoded ALU OPCODES
localparam ALU_OP_ADD 	= 4'd0;
localparam ALU_OP_SUB 	= 4'd1;
localparam ALU_OP_SLL 	= 4'd2;
localparam ALU_OP_SLT 	= 4'd3;
localparam ALU_OP_SLTU 	= 4'd4;
localparam ALU_OP_XOR 	= 4'd5;
localparam ALU_OP_SRL 	= 4'd6;
localparam ALU_OP_SRA 	= 4'd7;
localparam ALU_OP_OR 	  = 4'd8;
localparam ALU_OP_AND 	= 4'd9;

// LW_RW Instruction OPCODES 
localparam LB_OP_LOAD 	= 3'd0;
localparam LH_OP_LOAD 	= 3'd1;
localparam LW_OP_LOAD 	= 3'd2;
localparam LBU_OP_LOAD 	= 3'd3;
localparam LHU_OP_LOAD 	= 3'd4;
localparam SB_OP_STORE 	= 3'd5;
localparam SH_OP_STORE 	= 3'd6;
localparam SW_OP_STORE 	= 3'd7;

// R Type Instruction ALU OPCODES
localparam ADD_SUB 	= 3'b000;
localparam SLL 		  = 3'b001;
localparam SLT 		  = 3'b010;
localparam SLTU 	  = 3'b011;
localparam XOR 		  = 3'b100;
localparam SRL_SRA 	= 3'b101;
localparam OR 		  = 3'b110;
localparam AND 		  = 3'b111;

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

// R Type Encoded Instructions
logic [6:0] instruct_funct7;
logic [2:0] instruct_funct3;

// OPCODE
logic [6:0] instruct_opcode;

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_comb begin

  // Reset Regs
  ALU_Opcode      = '0;
  Reg_Wr_En       = '0;
  PC_Sel          = '0;
  ALU_Input_A_Sel = '0;
  ALU_Input_B_Sel = '0;
  Reg_WB_Sel      = '0;
  
  // Set Regs to Instruct Values
  instruct_opcode = Instruction[6:0];
  instruct_funct7 = Instruction[31:25];
  instruct_funct3 = Instruction[14:12];
  
  casez(instruct_opcode)
    OPCODE_ALU_R: begin
      Reg_Wr_En       = 1'b1;   // Emable write to register
      PC_Sel          = 1'b0;   // Set new program count as PC+4
      ALU_Input_A_Sel = 1'b0;   // Use register value as ALU input
      ALU_Input_B_Sel = 1'b0;   // Use register value as ALU input
      Reg_WB_Sel      = 2'b01;  // Write back ALU data to Register
      casez(instruct_funct3)
        ADD_SUB:  ALU_Opcode = (instruct_funct7[5] == 1'b1) ? ALU_OP_SUB : ALU_OP_ADD;
        SLL:      ALU_Opcode = ALU_OP_SLL;
        SLT:      ALU_Opcode = ALU_OP_SLT;
        SLTU:     ALU_Opcode = ALU_OP_SLTU;
        XOR:      ALU_Opcode = ALU_OP_XOR;
        SRL_SRA:  ALU_Opcode = (instruct_funct7[5] == 1'b1) ? ALU_OP_SRA : ALU_OP_SRL;
        OR:       ALU_Opcode = ALU_OP_OR;
        AND:      ALU_Opcode = ALU_OP_AND;
      endcase
    end
    default: begin
      $display("Illegal OPCODE");
    end
  endcase
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
ctrl_logic ctrl_logic (
  .Instruction(),
  .ALU_Opcode(),
  .Reg_Wr_En(),
  .PC_Sel(),
  .ALU_Input_A_Sel(),
  .ALU_Input_B_Sel(),
  .Reg_WB_Sel()
);
*/
endmodule