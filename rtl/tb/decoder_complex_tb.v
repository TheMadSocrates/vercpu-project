/**
 *  decoder_complex_tb.v - Microcoded Accumulator CPU
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

module decoder_complex_tb;
	/* inputs and control signals */
	reg [7:0] opcode;
	reg clk;

	/* output signal */
	wire [5:0] rom_offset;

	/* unit under testing */
	decoder_complex uut (
			.opcode(opcode), 
			.rom_offset(rom_offset)
		);

	initial begin
		/* signal initialization */
		opcode = 0;
		clk = 0;

		/* finish simulation */
		#1000	$finish;
	end
	
	always
		#50		clk = ~clk;

	always @(posedge clk)
		opcode = opcode + 1'b1;

endmodule

/* vim: set ts=4 tw=79 syntax=verilog */
