/**
 *  memory_decoder.v - Microcoded Accumulator CPU
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

/* memory decoder unit */
module memory_decoder(
		input wire		[ 7 : 0]	address,		/* address input */
		input wire		[ 7 : 0]	data_in,		/* data input */
		input wire		[ 7 : 0]	switch_in,		/* I/O switch input */
		input wire					clk,			/* clock */
		input wire					res,			/* reset */
		input wire					write_enable,	/* memory write enable */
		output wire		[ 7 : 0]	LED_status,		/* I/O LED output */
		output wire		[ 7 : 0]	data_out		/* memory data output */
    );

	/* internal wires and registers */
	wire	[ 7 : 0]	memory_data_out;
	wire		[ 7 : 0]	switch_data_out;
	
	wire mem_write_enable, LED_write_enable;
	
	/* mask write to address 0xff for LED usage */
	assign mem_write_enable = write_enable & (~&address);
	/* sram block */
	sram sram0 (
			.address(address),
			.data_in(data_in),
			.clk(clk),
			.write_enable(mem_write_enable),
			.data_out(memory_data_out)
		);
	
	/* decode LED address */
	assign LED_write_enable = write_enable & (&address);
	/* LED output driver flip flop */
	ff_d #(.WIDTH(8)) led_driver0 (
			.D(data_in),
			.en(LED_write_enable),
			.clk(clk),
			.res(res),
			.Q(LED_status)
		);
	
	/* switch input driver flip flop */
	ff_d #(.WIDTH(8)) switch_driver0 (
			.D(switch_in),
			.en(1'b1),
			.clk(clk),
			.res(res),
			.Q(switch_data_out)
		);
	
	/* decode read address */
	assign data_out = (~&address) ? memory_data_out : switch_data_out;
	
endmodule
/* vim: set ts=4 tw=79 syntax=verilog */
