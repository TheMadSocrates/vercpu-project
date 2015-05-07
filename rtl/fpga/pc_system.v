/**
 *  pc_system.v - Microcoded Accumulator CPU
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

module pc_system(
		input wire		[ 7 : 0]	switch_in,
		input wire					button,
		input wire					clk,
		input wire					res,
		output wire 	[ 7 : 0]	LED_status,
		output wire		[ 3 : 0]	anode,
		output wire		[ 6 : 0]	cathode
    );
	
	/* clock divider */
	wire clk_div;
	
	/* processor signals */
	wire [ 7 : 0] pc_out, mar_out, mdr_in, mdr_out;
	wire [15 : 0] instruction_in;

	/* direct board clock */
	assign clk_div = clk;
	
	/* clock divider */
	/*clock_divider clk_div0 (
			.clk(clk),
			.res(res),
			.prescaler(2'b10),
			.clk_out(clk_div)
		);*/
	
	/* clock generator */
	/*clk_gen clk0(
			.button(button),
			.clk(clk),
			.res(res),
			.clk_div(clk_div)
		);
	*/

	/* debug unit
	 *  show instruction in 7-segment display
	 */
	insn_out debug_unit0 (
			.insn(instruction_in),
			.clk(clk),
			.res(res),
			.anode(anode),
			.cathode(cathode)
		);

	/* memory decoder unit */
	memory_decoder md0 (
			.address(mar_out),
			.data_in(mdr_out),
			.switch_in(switch_in),
			.clk(clk_div),
			.res(res),
			.write_enable(write_mem),
			.LED_status(LED_status),
			.data_out(mdr_in)
		);
	
	/* the processor */
	processor core0 (
			.clk(clk_div), 
			.res(res), 
			.instruction_in(instruction_in), 
			.mdr_in(mdr_in), 
			.pc_out(pc_out), 
			.mdr_out(mdr_out), 
			.mar_out(mar_out), 
			.write_mem(write_mem)
		);
	
	/* program memory subsystem */
	progmem prom0 (
			.pc(pc_out),
			.instruction(instruction_in)
		);

endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
