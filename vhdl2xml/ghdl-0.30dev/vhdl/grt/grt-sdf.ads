--  GHDL Run Time (GRT) - SDF parser.
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
with Grt.Types; use Grt.Types;

package Grt.Sdf is
   type Edge_Type is
     (
      Edge_Error,
      Edge_None,
      Edge_Posedge,
      Edge_Negedge,
      Edge_01,
      Edge_10,
      Edge_0z,
      Edge_Z1,
      Edge_1z,
      Edge_Z0
     );

   type Timing_Generic_Kind is
     (
      Delay_Port,
      --Delay_Interconnect,
      --Delay_Device,

      --  Simple condition
      Delay_Iopath,
      Timingcheck_Width,
      Timingcheck_Period,

      --  Full condition
      Timingcheck_Setup,
      Timingcheck_Hold,
      Timingcheck_Recovery,
      Timingcheck_Skew,
      Timingcheck_Nochange,
      Timingcheck_Setuphold
     );

   subtype Timing_Generic_Simple_Condition is Timing_Generic_Kind
     range Delay_Iopath .. Timingcheck_Period;

   subtype Timing_Generic_Full_Condition is Timing_Generic_Kind
     range Timingcheck_Setup .. Timingcheck_Setuphold;

   type Sdf_Version_Type is
     (
      Sdf_2_1,
      Sdf_Version_Unknown,
      Sdf_Version_Bad
     );

   Read_Size : constant Natural := 4096;
   Buf_Size : constant Natural := Read_Size + 1024 + 1;

   Invalid_Dnumber : constant Ghdl_I32 := -1;

   type Port_Spec_Type is record
      --  Port identifier.
      Name : String (1 .. 128);
      Name_Len : Natural;

      --  Left and Right range.
      --  If L = R = Invalid_Dnumber, this is a simple scalar port.
      --  If R = Invalid_Dnumber, this is a scalar port (from a vector)
      --  Otherwise, this is a bus port.
      L, R : Ghdl_I32;

   -- Cond : String (1 .. 1024);
   -- Cond_Len : Natural;

      Edge : Edge_Type;
   end record;

   type Port_Spec_Array_Type is array (Natural range <>) of Port_Spec_Type;

   type Ghdl_I64_Array is array (1 .. 12) of Ghdl_I64;
   type Boolean_Array is array (1 .. 12) of Boolean;

   type Sdf_Context_Type is record
      --  Version of the SDF file.
      Version : Sdf_Version_Type;

      --  Timescale; 1 corresponds to 1 ps.
      --  Default is 1000 (1 ns).
      Timescale : Natural;

      Kind : Timing_Generic_Kind;

      --  Cell type.
      Celltype : String (1 .. 128);
      Celltype_Len : Natural;

      --  Current port.
      Port_Num : Natural;
      Ports : Port_Spec_Array_Type (1 .. 2);

      --  timing spec.
      Timing : Ghdl_I64_Array;
      Timing_Set : Boolean_Array;
      Timing_Nbr : Natural;
   end record;

   --  Which value is extracted.
   type Mtm_Type is (Minimum, Typical, Maximum);
   Sdf_Mtm : Mtm_Type := Typical;

   function Parse_Sdf_File (Filename : String) return Boolean;
end Grt.Sdf;
