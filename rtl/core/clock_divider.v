/**
 *  clock_divider.v - Microcoded Accumulator CPU
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

module clock_divider(
		input wire					clk,
		input wire					res,
		input wire		[ 1 : 0]	prescaler,
		output wire					clk_out
    );

	reg 					clk_div;
	reg [ 2**16 - 1 : 0 ]	counter;
	reg [ 2**16 - 1 : 0 ]	counter2;
	
	assign clk_out = clk_div;
	
	always @(prescaler or clk or counter or counter2) begin
		case(prescaler)
			2'b00:	clk_div = clk;
			2'b01:	clk_div = counter[0];
			2'b10:	clk_div = counter[2**16 - 1];
			2'b11:	clk_div = counter2[2**8 - 1];
		endcase
	end

	always @(posedge clk) begin
		if(res) begin
			counter <= {(2**22 - 1){1'b0}};
			counter2 <= {(2**22 - 1){1'b0}};
		end
		else counter <= counter + 1'b1;
	end
	
	always @(counter[2**16 - 1])
		counter2 <= counter2 + 1'b1;
	

endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
