/**
 *  processor.v - Microcoded Accumulator CPU
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
`include "aludefs.v"
module processor(
		/* inputs */
		input wire					clk,			/* clock */
		input wire					res,			/* reset */
		input wire		[15 : 0]	instruction_in,	/* instruction word */
		input wire		[ 7 : 0]	mdr_in,			/* memory data input */
		/* outputs */
		output wire		[ 7 : 0]	pc_out,			/* program counter */
		output wire		[ 7 : 0]	mdr_out,		/* memory data output */
		output wire		[ 7 : 0]	mar_out,		/* memory address */
		output wire					write_mem		/* memory write enable */
    );

	/* internal signals */
	wire	[15 : 0]	instruction;	/* instruction register output */
	wire	[`FWIDTH - 1 : 0] flags;	/* ALU flags register */
	wire 	[ 7 : 0] 	opcode,			/* intruction opcode */
						immediate;		/* instruction immediate constant */
	wire	[ 1 : 0]	ac_source;		/* accumulator register source */
	wire 				write_ac,		/* write accumulator register */
						mar_source,		/* memory address register source */
						write_mar;		/* write memory address register */
	wire	[ 1 : 0]	mdr_source;		/* memory data register source */
	wire				write_mdr,		/* write memory data register */
						write_flags;	/* write flags register */
	wire	[ 1 : 0]	pc_source;		/* program counter register source */
	wire				write_pc,		/* write program counter register */
						write_ir;		/* write instruction register */
	wire	[ 2 : 0]	ALU_op_select;	/* ALU operator select */
	wire	[`ALUCTLW - 1 : 0] ALUctl;	/* ALU control signal bus */
	
	
	assign opcode = instruction[15 : 8];
	assign immediate = instruction[ 7 : 0];

	/* instruction register */
	ff_d #(.WIDTH(16)) ir (
			.D(instruction_in),
			.en(write_ir),
			.clk(clk),
			.res(res),
			.Q(instruction)
		);

	/* control unit */
	controller_unit cr0 (
			/* inputs */
			.opcode(opcode),
			.flags(flags),
			.clk(clk),
			.res(res),
			/* outputs */
			.ac_source(ac_source),
			.write_ac(write_ac),
			.mar_source(mar_source),
			.write_mar(write_mar),
			.mdr_source(mdr_source),
			.write_mdr(write_mdr),
			.write_flags(write_flags),
			.pc_source(pc_source),
			.write_pc(write_pc),
			.write_ir(write_ir),
			.write_mem(write_mem),
			.ALU_op_select(ALU_op_select),
			.ALUctl(ALUctl)
		);
		
	/* datapath */
	datapath dp0 (
			.immediate(immediate),
			.mdr_in(mdr_in),
			.clk(clk),
			.res(res),
			.ac_source(ac_source),
			.write_ac(write_ac),
			.mar_source(mar_source),
			.write_mar(write_mar),
			.mdr_source(mdr_source),
			.write_mdr(write_mdr),
			.write_flags(write_flags),
			.pc_source(pc_source),
			.write_pc(write_pc),
			.ALU_op_select(ALU_op_select),
			.ALUctl(ALUctl),
			.mar_out(mar_out),
			.mdr_out(mdr_out),
			.pc_out(pc_out),
			.flags(flags)
		);
endmodule
`include "aluundefs.v"
/* vim: set ts=4 tw=79 syntax=verilog */
