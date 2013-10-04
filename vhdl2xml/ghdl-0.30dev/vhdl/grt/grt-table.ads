--  GHDL Run Time (GRT) - Resizable array
--  Copyright (C) 2008 Tristan Gingold
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

generic
   type Table_Component_Type is private;
   type Table_Index_Type     is range <>;

   Table_Low_Bound : Table_Index_Type;
   Table_Initial   : Positive;

package Grt.Table is
   pragma Elaborate_Body;

   type Table_Type is
     array (Table_Index_Type range <>) of Table_Component_Type;
   subtype Fat_Table_Type is
     Table_Type (Table_Low_Bound .. Table_Index_Type'Last);

   --  Thin pointer.
   type Table_Ptr is access all Fat_Table_Type;

   --  The table itself.
   Table : aliased Table_Ptr := null;

   --  Get the high bound.
   function Last return Table_Index_Type;
   pragma Inline (Last);

   --  Get the low bound.
   First : constant Table_Index_Type := Table_Low_Bound;

   --  Increase the length by 1.
   procedure Increment_Last;
   pragma Inline (Increment_Last);

   --  Decrease the length by 1.
   procedure Decrement_Last;
   pragma Inline (Decrement_Last);

   --  Set the last bound.
   procedure Set_Last (New_Val : Table_Index_Type);

   --  Release extra memory.
   procedure Release;

   --  Free all the memory used by the table.
   --  The table won't be useable anymore.
   procedure Free;

   --  Append a new element.
   procedure Append (New_Val : Table_Component_Type);
   pragma Inline (Append);
end Grt.Table;
