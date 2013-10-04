--  GHDL Run Time (GRT) - statistics.
--  Copyright (C) 2002, 2003, 2004, 2005 Tristan Gingold
--
--  GHDL is free software; you can redistribute it and/or modify it under
--  the terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 2, or (at your option) any later
--  version.
--
--  GHDL is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or
--  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with GCC; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.

package Grt.Stats is
   --  Entry points to gather statistics.
   procedure Start_Elaboration;
   procedure Start_Order;

   --  Time in user processes.
   procedure Start_Processes;


   --  Time in next time computation.
   procedure Start_Next_Time;


   --  Time in signals update.
   procedure Start_Update;


   --  Time in process resume
   procedure Start_Resume;


   procedure End_Simulation;

   --  Disp all statistics.
   procedure Disp_Stats;
end Grt.Stats;



