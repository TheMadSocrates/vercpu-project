/**
 *  microcodedefs.v - Microcoded Accumulator CPU
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

`include "aludefs.v"
/* microcode ROM width */
`define MCROM_WIDTH		27
`define OFFSET_WIDTH 	6 /* number of bits in microcode offset */
/* microcode ROM word layout */

`define AC_SOURCE		1:0				/* accumulator source */
`define WRITE_AC		2				/* enable write to accumulator */
`define MAR_SOURCE		3				/* memory address register source */
`define WRITE_MAR		4				/* enable write to memory address register */
`define MDR_SOURCE		6:5				/* memory data register source */
`define WRITE_MDR		7				/* enable write to memory data register */
`define PC_SOURCE		9:8				/* program counter register source */
`define WRITE_PC		10				/* enable write to program counter register */
`define WRITE_IR		11				/* enable write to instruction register */
`define WRITE_FLAGS		12				/* enable write to flags register */
`define WRITE_MEM		13				/* enable write to memory */
`define ALU_OP_SELECT	16:14			/* ALU operand selection */
`define ALUCTL		(16 + `ALUCTLW):17	/* ALU control */

/* offset of next microcode address */
`define OFFSET_NEXT		(`MCROM_WIDTH - 2):(`MCROM_WIDTH - `OFFSET_WIDTH - 1)
/* offset selection */
`define OFFSET_NEXT_SEL	(`MCROM_WIDTH - 1)

`include "aluundefs.v"/* vim: set ts=4 tw=79 syntax=verilog */
