--  GHDL Run Time (GRT) -  'name* subprograms.
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
--with Grt.Errors; use Grt.Errors;
with Ada.Unchecked_Conversion;
with System.Storage_Elements; --  Work around GNAT bug.
pragma Unreferenced (System.Storage_Elements);
with Grt.Processes; use Grt.Processes;
with Grt.Rtis_Addr; use Grt.Rtis_Addr;
with Grt.Rtis_Utils; use Grt.Rtis_Utils;
with Grt.Vstrings; use Grt.Vstrings;

package body Grt.Names is
   function To_Str_String_Boundp is new Ada.Unchecked_Conversion
     (Source => System.Address, Target => Std_String_Boundp);

   function To_Std_String_Basep is new Ada.Unchecked_Conversion
     (Source => String_Ptr, Target => Std_String_Basep);

   function To_Std_String_Basep is new Ada.Unchecked_Conversion
     (Source => System.Address, Target => Std_String_Basep);

   procedure Get_Name (Res : Std_String_Ptr;
                       Ctxt : Rti_Context;
                       Name : Ghdl_Str_Len_Ptr;
                       Is_Path : Boolean)
   is
      procedure Memcpy (Dst : Address; Src : Address; Len : Integer);
      pragma Import (C, Memcpy);

      Bounds : Std_String_Boundp;
      Len : Natural;

      Rstr : Rstring;
      R_Len : Natural;
   begin
      if Ctxt.Block /= null then
         Prepend (Rstr, ':');
         Get_Path_Name (Rstr, Ctxt, ':', not Is_Path);
         R_Len := Length (Rstr);
         Len := R_Len + Name.Len;
      else
         Len := Name.Len;
      end if;

      Bounds := To_Str_String_Boundp
        (Ghdl_Stack2_Allocate (Std_String_Bound'Size / System.Storage_Unit));
      Bounds.Dim_1.Left := 1;
      Bounds.Dim_1.Right := Ghdl_I32 (Len);
      Bounds.Dim_1.Dir := Dir_To;
      Bounds.Dim_1.Length := Ghdl_Index_Type (Len);
      Res.Bounds := Bounds;
      if Ctxt.Block /= null then
         Res.Base := To_Std_String_Basep
           (Ghdl_Stack2_Allocate (Ghdl_Index_Type (Len)));
         Memcpy (Res.Base (0)'Address, Get_Address (Rstr), R_Len);
         Memcpy (Res.Base (Ghdl_Index_Type (R_Len))'Address,
                 Name.Str (1)'Address,
                 Name.Len);
         Free (Rstr);
      else
         Res.Base := To_Std_String_Basep (Name.Str);
      end if;
   end Get_Name;

   procedure Ghdl_Get_Path_Name (Res : Std_String_Ptr;
                                 Ctxt : Ghdl_Rti_Access;
                                 Base : Address;
                                 Name : Ghdl_Str_Len_Ptr)
   is
   begin
      Get_Name (Res, (Base, Ctxt), Name, True);
   end Ghdl_Get_Path_Name;

   procedure Ghdl_Get_Instance_Name (Res : Std_String_Ptr;
                                     Ctxt : Ghdl_Rti_Access;
                                     Base : Address;
                                     Name : Ghdl_Str_Len_Ptr)
   is
   begin
      Get_Name (Res, (Base, Ctxt), Name, False);
   end Ghdl_Get_Instance_Name;

end Grt.Names;
