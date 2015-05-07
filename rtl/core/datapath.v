/**
 *  datapath.v - Microcoded Accumulator CPU
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

module datapath(
		/* regular inputs */
		input wire		[ 7 : 0]		immediate,		/* instruction predicate */
		input wire		[ 7 : 0]		mdr_in,			/* memory data register input */
		/* toplevel signals */
		input wire						clk,			/* clock signal */
		input wire						res,			/* reset signal */
		/* control signals */
		input wire		[ 1 : 0]		ac_source,		/* accumulator source */
		input wire						write_ac,		/* write accumulator */
		input wire						mar_source,		/* memory address register source */
		input wire						write_mar,		/* write memory address register */
		input wire		[ 1 : 0]		mdr_source,		/* memory data register source */
		input wire						write_mdr,		/* write memory data register */
		input wire						write_flags,	/* write flags register */
		input wire		[ 1 : 0]		pc_source,		/* program counter source */
		input wire						write_pc,		/* write program counter */
		input wire		[ 2 : 0]		ALU_op_select,	/* ALU operand source */
		input wire		[`ALUCTLW - 1: 0]	ALUctl,		/* ALU control signal bus */
		/* output signals */
		output wire		[ 7 : 0]			mar_out,	/* memory address */
		output wire		[ 7 : 0]			mdr_out,	/* data */
		output wire		[ 7 : 0]			pc_out,		/* program counter */
		output wire		[`FWIDTH - 1 : 0]	flags		/* ALU flags */
    );
	
	/* internal signals */
	wire [ 7 : 0] ALU_feedback,						/* ALU output and feedback path */
			pc_next,								/* next program counter */
			ac_out,									/* accumulator data output */
			ac_in,									/* accumulator data input */
			alu_operand,							/* second ALU operand */
			mar_data,								/* memory address register data source */
			mdr_data;								/* memory data register data source */
	
	wire [`FWIDTH - 1 : 0] flags_out;				/* flags */
	
	/* program counter jump select
	 * pc_source:
	 *  00: regular execution
	 *  01: direct jump
	 *  10: indirect jump
	 *  11: jump with offset
	 * rationale:
	 *  mechanism allows for implementation of both direct jumps
	 *  and indirect jumps.
	 */
	mux4 #(.WIDTH(8)) pc_mux (
			.in0(pc_out + 8'b1),
			.in1(immediate),
			.in2(ac_out),
			.in3(pc_out + ac_out),
			.sel(pc_source),
			.mux_out(pc_next)
		);

	/* program counter register */
	ff_d #(.WIDTH(8)) pc (
			.D(pc_next),
			.en(write_pc),
			.clk(clk),
			.res(res),
			.Q(pc_out)
		);
	
	/* flags register
	 * rationale:
	 *  keep ALU flags for new operations/CPU status
	 */
	ff_d #(.WIDTH(`FWIDTH)) flags_register (
			.D(flags_out),
			.en(write_flags),
			.clk(clk),
			.res(res),
			.Q(flags)
		);

	/* accumulator input select:
	 * ac_source:
	 *  00: store value in memory address register
	 *  01: store value in memory data register
	 *  10: store result from ALU into accumulator
	 *  11: store immediate into accumulator
	 * rationale:
	 *  mechanism allows for accumulator behaviour and for loading
	 *  a numeric constant into accumulator.
	 */
	mux4 #(.WIDTH(8)) ac_mux (
			.in0(mar_out),
			.in1(mdr_out),
			.in2(ALU_feedback),
			.in3(immediate),
			.sel(ac_source),
			.mux_out(ac_in)
		);
	/* accumulator register */
	ff_d #(.WIDTH(8)) ac (
			.D(ac_in),
			.en(write_ac),
			.clk(clk),
			.res(res),
			.Q(ac_out)
		);
	
	/* memory address register data source select
	 * mar_source:
	 *  1: use source from immediate constant
	 *  0: use source from accumulator register
	 * rationale:
	 *  allows for both direct and indirect addressing of memory data
	 */
	assign mar_data = mar_source ? immediate : ac_out;
	
	/* memory address register */
	ff_d #(.WIDTH(8)) mar (
			.D(mar_data),
			.en(write_mar),
			.clk(clk),
			.res(res),
			.Q(mar_out)
		);
	
	/* memory data register data source select
	 * mdr_source:
	 *  00: the constant 0
	 *  01: memory bus value
	 *	10: immediate value
	 *  11: accumulator register
	 * rationale:
	 *  allows for both direct and indirect
	 *   addressing of memory data
	 *  allows to easily clear a memory address
	 */
	mux4 #(.WIDTH(8)) mdr_mux (
			.in0(8'b0),
			.in1(mdr_in),
			.in2(immediate),
			.in3(ac_out),
			.sel(mdr_source),
			.mux_out(mdr_data)
		);
	
	/* memory data register */
	ff_d #(.WIDTH(8)) mdr (
			.D(mdr_data),
			.en(write_mdr),
			.clk(clk),
			.res(res),
			.Q(mdr_out)
		);
	
	/* ALU operand source select
	 * ALU_op_select:
	 *  000: the constant 0
	 *  001: the constant 1
	 *  010: the constant 2
	 *  011: the constant -1
	 *  100: the constant -2
	 *  101: accumulator register
	 *  110: immediate constant
	 *  111: memory data register
	 * rationale:
	 *  allows for the ease of implementation of
	 *   arithmetic/logic instructions
	 */
	mux8 #(.WIDTH(8)) ALU_op_mux (
			.in0(8'b0),
			.in1(8'b01),
			.in2(8'b10),
			.in3(8'hff),
			.in4(8'hfe),
			.in5(ac_out),
			.in6(immediate),
			.in7(mdr_out),
			.sel(ALU_op_select),
			.mux_out(alu_operand)
		);
	
	/* ALU */
	ALU alu0 (
			.op1(ac_out),
			.op2(alu_operand),
			.ctl(ALUctl),
			.flags_in(flags),
			.result(ALU_feedback),
			.flags_out(flags_out)
		);
endmodule
`include "aluundefs.v"
/* vim: set ts=4 tw=79 syntax=verilog */
