/**
 *  ff_d.v - Microcoded Accumulator CPU
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

module ff_d #(parameter WIDTH=8) (
		input wire		[WIDTH - 1 : 0]	D,		/* data input */
		input wire						en,		/* enable */
		input wire						clk,	/* clock */
		input wire						res,	/* synchronous active high reset */
		output wire		[WIDTH - 1 : 0]	Q		/* output */
    );
	
	reg [WIDTH - 1 : 0] storage;
	assign Q = storage;
	
	always @(posedge clk) begin
		if(res)									/* handle synchronous reset */
			storage <= {WIDTH{1'b0}};
		else if(en)								/* handle save data */
			storage <= D;
	end
endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
