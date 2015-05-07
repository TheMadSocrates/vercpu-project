/**
 *  controller_unit_tb.v - Microcoded Accumulator CPU
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

module controller_unit_tb;

	/* input signals */
	reg [7:0] opcode;
	reg clk;
	reg res;

	/* output signals */
	wire [1:0] ac_source;
	wire write_ac;
	wire mar_source;
	wire write_mar;
	wire [1:0] mdr_source;
	wire write_mdr;
	wire write_flags;
	wire [1:0] pc_source;
	wire write_pc;
	wire write_ir;
	wire write_mem;
	wire [2:0] ALU_op_select;
	wire [2:0] ALUctl;

	/* unit under testing */
	controller_unit uut (
			.opcode(opcode), 
			.clk(clk), 
			.res(res), 
			.ac_source(ac_source), 
			.write_ac(write_ac), 
			.mar_source(mar_source), 
			.write_mar(write_mar), 
			.mdr_source(mdr_source), 
			.write_mdr(write_mdr), 
			.write_flags(write_flags), 
			.pc_source(pc_source), 
			.write_pc(write_pc), 
			.write_ir(write_ir),
			.write_mem(write_mem),
			.ALU_op_select(ALU_op_select), 
			.ALUctl(ALUctl)
		);

	initial begin
		/* initialize signals */
		opcode = 8'h03;
		clk = 0;
		res = 1;

		$dumpfile("controller_unit.vcd");
		$dumpvars;

		/* release reset */
		#100	res = 0;
		
		/* finish simulation */
		#1000	$finish;
	end
	
	always
		#50		clk = ~clk;
      
endmodule

/* vim: set ts=4 tw=79 syntax=verilog */
