/**
 *  controller_unit.v - Microcoded Accumulator CPU
 *  Copyright (C) 2015  Orlando Arias, David Mascenik
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
`timescale 1ns / 1ps

`include "microcodedefs.v"
`include "aludefs.v"

module controller_unit(
		/* input signals */
		input wire		[ 7 : 0]			opcode,		/* opcode byte */
		input wire		[`FWIDTH - 1 : 0]	flags,		/* ALU flags */
		input wire							clk,		/* clock signal */
		input wire							res,		/* reset signal */
		/* output signals */
		output wire		[1 : 0]				ac_source,	/* accumulator source */
		output wire							write_ac,	/* write accumulator */
		output wire							mar_source,	/* memory address register source */
		output wire							write_mar,	/* write memory address register */
		output wire		[1 : 0]				mdr_source,	/* memory data register source */
		output wire							write_mdr,	/* write memory data register */
		output wire							write_flags,/* write flags register */
		output wire		[ 1 : 0]			pc_source,	/* program counter source */
		output wire							write_pc,	/* write program counter */
		output wire							write_ir,	/* write instruction register */
		output wire							write_mem,	/* write memory */
		output wire		[ 2 : 0]			ALU_op_select,	/* ALU operator */
		output wire		[`ALUCTLW - 1: 0]	ALUctl		/* ALU control signal bus */
    );

	/* internal signals */
	wire [`MCROM_WIDTH - 1 : 0] mc_word;
	wire [`OFFSET_WIDTH - 1 : 0] offset, rom_offset_next, op_decoder_out;
	wire [ 1 : 0] offset_next_select;

	
	/* instance the decoder complex */
	decoder_complex idec0 (
			.opcode(opcode),
			.flags(flags),
			.op_decoder_out(op_decoder_out)
		);
	
	/* instance the microcode rom */
	microcode_rom rom0 (
			.clk(clk),
			.offset(offset),
			.mc_word(mc_word)
		);
	
	/* select the next address in the microcode ROM */
	mux4 #(.WIDTH(`OFFSET_WIDTH)) mux0(
			.in0(op_decoder_out),		/* decoder complex output */
			.in1(rom_offset_next),		/* offset from ROM */ 
			.in2(`OFFSET_WIDTH'b0),		/* start of ROM */
			.in3(`OFFSET_WIDTH'b0),		/* start of ROM */
			.sel(offset_next_select),	/* next ROM address selection */
			.mux_out(offset)			/* next offset on microcode ROM */
		);

	/* control signals assignment */
	assign offset_next_select 	= {res, res ? 1'b1 : mc_word[`OFFSET_NEXT_SEL]};
	assign rom_offset_next		= mc_word[`OFFSET_NEXT];
	assign ac_source 			= mc_word[`AC_SOURCE];
	assign write_ac 			= mc_word[`WRITE_AC];
	assign mar_source 			= mc_word[`MAR_SOURCE];
	assign write_mar 			= mc_word[`WRITE_MAR];
	assign mdr_source 			= mc_word[`MDR_SOURCE];
	assign write_mdr 			= mc_word[`WRITE_MDR];
	assign write_flags 			= mc_word[`WRITE_FLAGS];
	assign pc_source 			= mc_word[`PC_SOURCE];
	assign write_pc 			= mc_word[`WRITE_PC];
	assign write_ir				= mc_word[`WRITE_IR];
	assign write_mem			= mc_word[`WRITE_MEM];
	assign ALU_op_select 		= mc_word[`ALU_OP_SELECT];
	assign ALUctl 				= mc_word[`ALUCTL];
endmodule

`include "microcodeundefs.v"
`include "aluundefs.v"
/* vim: set ts=4 tw=79 syntax=verilog */
