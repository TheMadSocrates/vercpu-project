/**
 *  aludefs.v - Microcoded Accumulator CPU
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

/* flags register width */
`define FWIDTH			4

/* CPU flags */
`define ZERO_FLAG		0
`define CARRY_FLAG		1
`define NEGATIVE_FLAG	2
`define OVERFLOW_FLAG	3

/* ALU control bus width */
`define ALUCTLW			3

/* Microcode ROM offset width */
`define MC_OFFSET_WIDTH	6
/* vim: set ts=4 tw=79 syntax=verilog */
