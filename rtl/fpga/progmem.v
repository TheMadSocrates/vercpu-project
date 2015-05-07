/**
 *  progmem.v - Microcoded Accumulator CPU
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

/* program memory */
module progmem(
		input wire		[ 7 : 0]	pc,
		output reg		[15 : 0]	instruction
    );

	/* ROM subsystem emulation */
	always @(pc) begin
		case(pc)
			8'h00:	instruction = 16'h7f00;	/* start:	ldi 0 */
			8'h01:	instruction = 16'h0100;	/* 			sto 0x00 */
			8'h02:	instruction = 16'h0101;	/* 			sto 0x01 */
			8'h03:	instruction = 16'h7200;	/* loop:	inc */
			8'h04:	instruction = 16'h74ff;	/* 			cmp 0xff */
			8'h05:	instruction = 16'h0a0c;	/* 			jz loop_e */
			8'h06:	instruction = 16'h0101;	/* 			sto 0x01 */
			8'h07:	instruction = 16'h0000;	/* 			add 0x00 */
			8'h08:	instruction = 16'h0100;	/* 			sto 0x00 */
			8'h09:	instruction = 16'h01ff;	/*			sto 0xff */
			8'h0a:	instruction = 16'h0201;	/* 			lo 0x01	*/
			8'h0b:	instruction = 16'h0303;	/* 			jmp loop */
			8'h0c:	instruction = 16'h030c;	/* self:	jmp self */
			default:
				begin
					instruction = 16'hffff;	/* end: 	halt */
				end
		endcase
	end

endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
