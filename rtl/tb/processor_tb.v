/**
 *  processor_tb.v - Microcoded Accumulator CPU
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

module processor_tb;

	/* inputs */
	reg clk;
	reg res;
	reg [15:0] instruction_in;
	reg [7:0] mdr_in;
	
	/* SRAM block */
	reg [7 : 0] memory [255 : 0];

	/* outputs */
	wire [7:0] pc_out;
	wire [7:0] mdr_out;
	wire [7:0] mar_out;
	wire write_mem;

	/* unit under testing */
	processor uut (
			.clk(clk), 
			.res(res), 
			.instruction_in(instruction_in), 
			.mdr_in(mdr_in), 
			.pc_out(pc_out), 
			.mdr_out(mdr_out), 
			.mar_out(mar_out), 
			.write_mem(write_mem)
		);

	initial begin
		/* initialize inputs */
		clk = 0;
		res = 1;

		/* release reset signal */
		#100	res = 0;

		/* finish simulation */
	end
	
	/* clock */
	always
		#10		clk = ~clk;
	
	/* data memory subsystem emulation */
	always @(posedge clk) begin
		if(write_mem)
			memory[mar_out] <= mdr_out;
			mdr_in <= memory[mar_out];
	end

	/* ROM subsystem emulation */
	always @(pc_out) begin
		case(pc_out)
			8'h00:	instruction_in = 16'h7f00;	/* start:	ldi 0 */
			8'h01:	instruction_in = 16'h0100;	/* 			sto 0x00 */
			8'h02:	instruction_in = 16'h0101;	/* 			sto 0x01 */
			8'h03:	instruction_in = 16'h7200;	/* loop:	inc */
			8'h04:	instruction_in = 16'h730a;	/* 			cmpi 0x0a */
			8'h05:	instruction_in = 16'h0aff;	/* 			jz end */
			8'h06:	instruction_in = 16'h0101;	/* 			sto 0x01 */
			8'h07:	instruction_in = 16'h0000;	/* 			add 0x00 */
			8'h08:	instruction_in = 16'h0100;	/* 			sto 0x00 */
			8'h09:	instruction_in = 16'h0201;	/* 			lo 0x01	*/
			8'h0a:	instruction_in = 16'h0303;	/* 			jmp loop */
			default:
				begin
					instruction_in = 16'hffff;	/* end: 	halt */
					$finish;
				end
		endcase
	end
      
endmodule

/* vim: set ts=4 tw=79 syntax=verilog */
