/**
 *  mux.v - Microcoded Accumulator CPU
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

module mux4 #(parameter WIDTH=8) (
		input wire	[WIDTH - 1 : 0]		in0,		/* multiplexer input 0 */
		input wire	[WIDTH - 1 : 0]		in1,		/* multiplexer input 1 */
		input wire	[WIDTH - 1 : 0]		in2,		/* multiplexer input 2 */
		input wire	[WIDTH - 1 : 0]		in3,		/* multiplexer input 3 */
		input wire	[ 1: 0]				sel,		/* select lines */
		output reg	[WIDTH - 1 : 0]		mux_out		/* multiplexer output */
	);
	
	always @(*) begin
		case(sel)
			2'b00:		mux_out = in0;
			2'b01:		mux_out = in1;
			2'b10:		mux_out = in2;
			2'b11:		mux_out = in3;
		endcase
	end
endmodule

module mux8 #(parameter WIDTH=8) (
		input wire	[WIDTH - 1 : 0]		in0,		/* multiplexer input 0 */
		input wire	[WIDTH - 1 : 0]		in1,		/* multiplexer input 1 */
		input wire	[WIDTH - 1 : 0]		in2,		/* multiplexer input 2 */
		input wire	[WIDTH - 1 : 0]		in3,		/* multiplexer input 3 */
		input wire	[WIDTH - 1 : 0]		in4,		/* multiplexer input 4 */
		input wire	[WIDTH - 1 : 0]		in5,		/* multiplexer input 5 */
		input wire	[WIDTH - 1 : 0]		in6,		/* multiplexer input 6 */
		input wire	[WIDTH - 1 : 0]		in7,		/* multiplexer input 7 */
		input wire	[ 2: 0]				sel,		/* select lines */
		output reg	[WIDTH - 1 : 0]		mux_out		/* multiplexer output */
	);

	always @(*) begin
		case(sel)
			3'b000:		mux_out = in0;
			3'b001:		mux_out = in1;
			3'b010:		mux_out = in2;
			3'b011:		mux_out = in3;
			3'b100:		mux_out = in4;
			3'b101:		mux_out = in5;
			3'b110:		mux_out = in6;
			3'b111:		mux_out = in7;
		endcase
	end
endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
