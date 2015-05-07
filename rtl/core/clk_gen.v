/**
 *  clk_gen.v - Microcoded Accumulator CPU
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:29:34 04/26/2015 
// Design Name: 
// Module Name:    clk_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_gen(
		input wire				button,
		input wire				clk,
		input wire				res,
		output wire				clk_div
    );

	reg [3 : 0] ripple;
	assign clk_div = &ripple;
	
	always @(posedge clk) begin
		if(res)
			ripple <= 4'b0;
		else begin
			ripple[0] <= button;
			ripple[1] <= ripple[0];
			ripple[2] <= ripple[1];
			ripple[3] <= ripple[2];
		end
	end
endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
