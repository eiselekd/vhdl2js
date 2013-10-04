--  GHDL Run Time (GRT) -  Well known RTI types.
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
with Grt.Rtis; use Grt.Rtis;

--  This package allow access to RTIs of some types.
--  This is used to recognize some VHDL logic types.
--  This is also used by grt.signals to set types of some implicit signals
--   (such as 'stable or 'transation).

package Grt.Rtis_Types is
   --  RTIs for some logic types.
   Std_Standard_Bit_RTI_Ptr : Ghdl_Rti_Access;

   Std_Standard_Boolean_RTI_Ptr : Ghdl_Rti_Access;

   --  std_ulogic.
   --  A VHDL may not contain ieee.std_logic_1164 package.  So, this RTI
   --  must be dynamicaly searched.
   Ieee_Std_Logic_1164_Std_Ulogic_RTI_Ptr : Ghdl_Rti_Access := null;

   --  Search RTI for types.
   --  If a type is not found, its RTI is set to null.
   --  If this procedure has already been called, then this is a noop.
   procedure Search_Types_RTI;
private
   --  These are set either by grt.rtis_binding or by ghdlrun.
   --  This is not very clean...
   pragma Import (C, Std_Standard_Bit_RTI_Ptr,
                  "std__standard__bit__RTI_ptr");

   pragma Import (C, Std_Standard_Boolean_RTI_Ptr,
                  "std__standard__boolean__RTI_ptr");
end Grt.Rtis_Types;
