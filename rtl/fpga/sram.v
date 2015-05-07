/**
 *  sram.v - Microcoded Accumulator CPU
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

/* Xilinx BRAM module creation */
module sram(
		input wire		[ 7 : 0]	address,		/* address bus */
		input wire		[ 7 : 0]	data_in,		/* data input bus */
		input wire					clk,			/* clock */
		input wire					write_enable,	/* memory write enable */
		output reg		[ 7 : 0]	data_out		/* data output bus */
    );

	/* 255x8 SRAM block */
	reg [ 7 : 0] memory [255 : 0];
	
	/* Xilinx BRAM module generation */
	always @(posedge clk) begin
		if(write_enable)
			memory[address] <= data_in;
		data_out <= memory[address];
	end

endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
