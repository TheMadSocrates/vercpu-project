/**
 *  insn_out.v - Microcoded Accumulator CPU
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

/* instruction output driver */
module insn_out(
		input wire		[15 : 0]	insn,
		input wire					clk,
		input wire					res,
		output wire		[ 3 : 0]	anode,
		output wire		[ 6 : 0]	cathode
	);

	/* internal frequency scaler parameter */
	parameter MSB = 16;
	
	reg [MSB : 0] counter;
	reg [ 3 : 0] nibble;
	
	/* seven segment display driver instance */
	sseg_driver ssgd0 (
			.digit(nibble),					/* digit to show */
			.sel(counter[MSB:MSB - 1]),		/* digit selection */
			.anode(anode),					/* decoded common anode enable */
			.cathode(cathode)				/* decoded seven segment cathode */
		);
	
	/* internal counter */
	always @(posedge clk) begin
		if(res) counter <= {(MSB+1){1'b0}};
		else counter <= counter + 1'b1;
	end
	
	/* nibble multiplexing */
	always @(counter[MSB:MSB - 1] or insn) begin
		case(counter[MSB:MSB - 1])
			2'b00:	nibble = insn[ 3 : 0];
			2'b01:	nibble = insn[ 7 : 4];
			2'b10:	nibble = insn[11 : 8];
			2'b11:	nibble = insn[15 :12];
		endcase
	end

endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
