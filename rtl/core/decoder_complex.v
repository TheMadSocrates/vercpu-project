/**
 *  decoder_complex.v - Microcoded Accumulator CPU
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

module decoder_complex(
		input wire	[ 7 : 0]					opcode,			/* opcode */
		input wire	[`FWIDTH - 1 : 0]			flags,			/* ALU flags */
		output reg	[`MC_OFFSET_WIDTH - 1 : 0]	op_decoder_out	/* microcode offset */
	);

	always @(*) begin
		case(opcode)
			/* add from immediate memory address into accumulator */
			8'h00:	op_decoder_out = `MC_OFFSET_WIDTH'h0a;
			/* store from accumulator into immediate address */
			8'h01:	op_decoder_out = `MC_OFFSET_WIDTH'h08;
			/* load from immediate address into accumulator */
			8'h02:	op_decoder_out = `MC_OFFSET_WIDTH'h04;
			/* absolute branch to immediate address */
			8'h03:	op_decoder_out = `MC_OFFSET_WIDTH'h0e;
			/* jump if negative */
			8'h04:	op_decoder_out =
							flags[`NEGATIVE_FLAG] ?
								`MC_OFFSET_WIDTH'h0e
								: `MC_OFFSET_WIDTH'h0f;
			/* subtract from immediate memory address into accumulator */
			8'h05:	op_decoder_out = `MC_OFFSET_WIDTH'h16;
			/* exclusive OR from immediate memory address into accumulator */ 
			8'h06:	op_decoder_out = `MC_OFFSET_WIDTH'h1a;
			/* NOR from immediate memory address into accumulator */
			8'h07:	op_decoder_out = `MC_OFFSET_WIDTH'h1e;
			/* NAND from immediate memory address into accumulator */
			8'h08:	op_decoder_out = `MC_OFFSET_WIDTH'h22;
			/* jump if positive */
			8'h09:	op_decoder_out =
							flags[`NEGATIVE_FLAG] ?
								`MC_OFFSET_WIDTH'h0f
								: `MC_OFFSET_WIDTH'h0e;
			/* jump if zero */
			8'h0a:	op_decoder_out =
							flags[`ZERO_FLAG] ?
								`MC_OFFSET_WIDTH'h0e
								: `MC_OFFSET_WIDTH'h0f;
			/* add immediate into accumulator */
			8'h0b:	op_decoder_out = `MC_OFFSET_WIDTH'h26;
			/* accumulator arithmetic shift left */
			8'h0d:	op_decoder_out = `MC_OFFSET_WIDTH'h29;
			/* accumulator arithmetic shift right */
			8'h0e:	op_decoder_out = `MC_OFFSET_WIDTH'h28;
			/* jump if carry set */
			8'h70:	op_decoder_out =
							flags[`CARRY_FLAG] ?
								`MC_OFFSET_WIDTH'h0e
								: `MC_OFFSET_WIDTH'h0f;
			/* jump if overflow set */
			8'h71:	op_decoder_out =
							flags[`OVERFLOW_FLAG] ?
								`MC_OFFSET_WIDTH'h0e
								: `MC_OFFSET_WIDTH'h0f;
			/* increment accumulator */
			8'h72:	op_decoder_out = `MC_OFFSET_WIDTH'h10;
			/* compare with immediate constant */
			8'h73:	op_decoder_out = `MC_OFFSET_WIDTH'h11;
			/* compare with value at immediate address */
			8'h74:	op_decoder_out = `MC_OFFSET_WIDTH'h12;
			/* invert accumulator */
			8'h75:	op_decoder_out = `MC_OFFSET_WIDTH'h27;
			/* clear accumulator register */
			8'h7e:	op_decoder_out = `MC_OFFSET_WIDTH'h02;
			/* load immediate into accumulator register */
			8'h7f:	op_decoder_out = `MC_OFFSET_WIDTH'h03;
			default:op_decoder_out = {`MC_OFFSET_WIDTH{1'b1}};
		endcase
	end
endmodule

`include "aluundefs.v"
/* vim: set ts=4 tw=79 syntax=verilog */
