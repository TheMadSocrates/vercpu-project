/**
 *  sseg_driver.v - Microcoded Accumulator CPU
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

/* seven segment display driver */
module sseg_driver(
		input wire		[ 3 : 0]	digit,		/* digit to show */
		input wire		[ 1 : 0]	sel,		/* place to show */
		output reg		[ 3 : 0]	anode,		/* common anode enable */
		output reg		[ 6 : 0]	cathode		/* cathode enable */
    );

	/* decode anode enable signal */
	always @(sel) begin
		case(sel)
			2'b00:	anode = 4'b1110;
			2'b01:	anode = 4'b1101;
			2'b10:	anode = 4'b1011;
			2'b11:	anode = 4'b0111;
		endcase
	end
	
	/* decode digit into 7-segment driver output */
	always @(digit) begin
		case(digit)			/*   ABCDEFG */
			4'h0:	cathode = 7'b0000001;
			4'h1:	cathode = 7'b1001111;
			4'h2:	cathode = 7'b0010010;
			4'h3:	cathode = 7'b0000110;
			4'h4:	cathode = 7'b1001100;
			4'h5:	cathode = 7'b0100100;
			4'h6:	cathode = 7'b0100000;
			4'h7:	cathode = 7'b0001111;
			4'h8:	cathode = 7'b0000000;
			4'h9:	cathode = 7'b0000100;
			4'ha:	cathode = 7'b0001000;
			4'hb:	cathode = 7'b1100000;
			4'hc:	cathode = 7'b0110001;
			4'hd:	cathode = 7'b1000010;
			4'he:	cathode = 7'b0110000;
			4'hf:	cathode = 7'b0111000;
		endcase
	end

endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
