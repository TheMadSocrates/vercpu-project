/**
 *  microcode_rom.v - Microcoded Accumulator CPU
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

module microcode_rom(
		input wire								clk,		/* clock input */
		input wire		[`OFFSET_WIDTH - 1 : 0]	offset,		/* ROM address */
		output reg		[`MCROM_WIDTH - 1 : 0]	mc_word		/* ROM word output */
    );

	always @(posedge clk) begin
		case(offset)
			/* fetch */
			`OFFSET_WIDTH'h00:
				mc_word = `MCROM_WIDTH'b1_000001_xxx_xxx_0_0_1_0_xx_0_xx_0_x_0_xx;
			/* decode */
			`OFFSET_WIDTH'h01:
				mc_word = `MCROM_WIDTH'b0_xxxxxx_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			/* clear accumulator register */
			`OFFSET_WIDTH'h02:
				mc_word = `MCROM_WIDTH'b1_000000_110_101_0_1_0_1_00_0_xx_0_x_1_10;
			/* load immediate into accumulator */
			`OFFSET_WIDTH'h03:
				mc_word = `MCROM_WIDTH'b1_000000_xxx_xxx_0_0_0_1_00_0_xx_0_x_1_11;
			/* load from immediate memory address into accumulator */
			`OFFSET_WIDTH'h04:
				mc_word = `MCROM_WIDTH'b1_000101_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h05:
				mc_word = `MCROM_WIDTH'b1_000110_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h06:
				mc_word = `MCROM_WIDTH'b1_000111_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h07:
				mc_word = `MCROM_WIDTH'b1_000000_xxx_xxx_0_0_0_1_00_0_xx_0_x_1_01;
			/* store from accumulator into immediate memory address */
			`OFFSET_WIDTH'h08:
				mc_word = `MCROM_WIDTH'b1_001001_xxx_xxx_0_0_0_0_xx_1_11_1_1_0_xx;
			`OFFSET_WIDTH'h09:
				mc_word = `MCROM_WIDTH'b1_000000_xxx_xxx_1_0_0_1_00_0_xx_0_x_0_xx;
			/* add from immediate memory address into accumulator */
			`OFFSET_WIDTH'h0a:
				mc_word = `MCROM_WIDTH'b1_001011_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h0b:
				mc_word = `MCROM_WIDTH'b1_001100_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h0c:
				mc_word = `MCROM_WIDTH'b1_001101_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h0d:
				mc_word = `MCROM_WIDTH'b1_000000_000_111_0_1_0_1_00_0_xx_0_x_1_10;
			/* absolute branch to immediate address or conditional branch taken */
			`OFFSET_WIDTH'h0e:
				mc_word = `MCROM_WIDTH'b1_000000_xxx_xxx_0_0_0_1_01_0_xx_0_x_0_xx;
			/* conditional branch not taken */
			`OFFSET_WIDTH'h0f:
				mc_word = `MCROM_WIDTH'b1_000000_xxx_xxx_0_0_0_1_00_0_xx_0_x_0_xx;
			/* increment accumulator */
			`OFFSET_WIDTH'h10:
				mc_word = `MCROM_WIDTH'b1_000000_000_001_0_1_0_1_00_0_xx_0_x_1_10;
			/* compare with immediate constant */
			`OFFSET_WIDTH'h11:
				mc_word = `MCROM_WIDTH'b1_000000_010_110_0_1_0_1_00_0_xx_0_x_0_xx;
			/* compare with value at immediate address */
			`OFFSET_WIDTH'h12:
				mc_word = `MCROM_WIDTH'b1_010011_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h13:
				mc_word = `MCROM_WIDTH'b1_010100_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h14:
				mc_word = `MCROM_WIDTH'b1_010101_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h15:
				mc_word = `MCROM_WIDTH'b1_000000_010_111_0_1_0_1_00_0_xx_0_x_0_xx;
			/* subtract from immediate memory address into accumulator */
			`OFFSET_WIDTH'h16:
				mc_word = `MCROM_WIDTH'b1_010111_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h17:
				mc_word = `MCROM_WIDTH'b1_011000_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h18:
				mc_word = `MCROM_WIDTH'b1_011001_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h19:
				mc_word = `MCROM_WIDTH'b1_000000_010_111_0_1_0_1_00_0_xx_0_x_1_10;
			/* exclusive OR from immediate memory address into accumulator */
			`OFFSET_WIDTH'h1a:
				mc_word = `MCROM_WIDTH'b1_011011_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h1b:
				mc_word = `MCROM_WIDTH'b1_011100_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h1c:
				mc_word = `MCROM_WIDTH'b1_011101_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h1d:
				mc_word = `MCROM_WIDTH'b1_000000_110_111_0_1_0_1_00_0_xx_0_x_1_10;
			/* NOR from immediate memory address into accumulator */
			`OFFSET_WIDTH'h1e:
				mc_word = `MCROM_WIDTH'b1_011111_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h1f:
				mc_word = `MCROM_WIDTH'b1_100000_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h20:
				mc_word = `MCROM_WIDTH'b1_100001_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h21:
				mc_word = `MCROM_WIDTH'b1_000000_101_111_0_1_0_1_00_0_xx_0_x_1_10;
			/* NAND from immediate memory address into accumulator */
			`OFFSET_WIDTH'h22:
				mc_word = `MCROM_WIDTH'b1_100011_xxx_xxx_0_0_0_0_xx_0_xx_1_1_0_xx;
			`OFFSET_WIDTH'h23:
				mc_word = `MCROM_WIDTH'b1_100100_xxx_xxx_0_0_0_0_xx_0_xx_0_x_0_xx;
			`OFFSET_WIDTH'h24:
				mc_word = `MCROM_WIDTH'b1_100101_xxx_xxx_0_0_0_0_xx_1_01_0_x_0_xx;
			`OFFSET_WIDTH'h25:
				mc_word = `MCROM_WIDTH'b1_000000_100_111_0_1_0_1_00_0_xx_0_x_1_10;
			/* add immediate into accumulator */
			`OFFSET_WIDTH'h26:
				mc_word = `MCROM_WIDTH'b1_000000_000_110_0_1_0_1_00_0_xx_0_x_1_10;
			/* invert accumulator */
			`OFFSET_WIDTH'h27:
				mc_word = `MCROM_WIDTH'b1_000000_110_011_0_1_0_1_00_0_xx_0_x_1_10;
			/* shift right arithmetic accumulator */
			`OFFSET_WIDTH'h28:
				mc_word = `MCROM_WIDTH'b1_000000_111_101_0_1_0_1_00_0_xx_0_x_1_10;
			/* shift left arithmetic accumulator */
			`OFFSET_WIDTH'h29:
				mc_word = `MCROM_WIDTH'b1_000000_000_101_0_1_0_1_00_0_xx_0_x_1_10;
			/* halt condition */
			default:
				mc_word = {{(`OFFSET_WIDTH+1){1'b1}},
							{(`MCROM_WIDTH - `OFFSET_WIDTH - 1){1'b0}}};
		endcase
	end
endmodule

`include "microcodeundefs.v"
/* vim: set ts=4 tw=79 syntax=verilog */
