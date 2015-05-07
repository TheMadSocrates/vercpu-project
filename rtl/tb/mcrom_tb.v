/**
 *  mcrom_tb.v - Microcoded Accumulator CPU
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

module mcrom_tb;

	/* input and signals */
	reg [ 5 : 0] offset;
	reg clk;

	/* output */
	wire [`MCROM_WIDTH - 1 : 0] mc_word;

	/* unit under testing */
	microcode_rom uut (
			.offset(offset), 
			.mc_word(mc_word)
		);

	initial begin
		/* initialize signals */
		offset = 0;
		clk = 0;
		/* end simulation after 1000 ticks */
		#1000	$finish;
	end

	always
		#50		clk = ~clk;
	
	always @(posedge clk)
		offset = offset + 1;
		
endmodule

/* vim: set ts=4 tw=79 syntax=verilog */
