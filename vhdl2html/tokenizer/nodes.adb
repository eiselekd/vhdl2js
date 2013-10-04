--  Internal node type and operations.
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
--  along with GHDL; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.
with GNAT.Table;
--with Ada.Text_IO; use Ada.Text_IO;

package body Nodes is
   --  Suppress the access check of the table base.  This is really safe to
   --  suppress this check because the table base cannot be null.
   pragma Suppress (Access_Check);

   --  Suppress the index check on the table.
   --  Could be done during non-debug, since this may catch errors (reading
   --  Null_Node or Error_Node).
   --pragma Suppress (Index_Check);

   --  Suppress discriminant checks on the table.  Relatively safe, since
   --  iirs do their own checks.
   pragma Suppress (Discriminant_Check);

   package Nodet is new GNAT.Table
     (Table_Component_Type => Node_Record,
      Table_Index_Type => Node_Type,
      Table_Low_Bound => 2,
      Table_Initial => 1024,
      Table_Increment => 100);

   function Get_Last_Node return Node_Type is
   begin
      return Nodet.Last;
   end Get_Last_Node;

   Free_Chain : Node_Type := Null_Node;

   --  Just to have the default value.
   pragma Warnings (Off);
   Init_Short  : Node_Record (Format_Short);
   Init_Medium : Node_Record (Format_Medium);
   Init_Fp     : Node_Record (Format_Fp);
   Init_Int    : Node_Record (Format_Int);
   pragma Warnings (On);

   function Create_Node (Format : Format_Type) return Node_Type
   is
      Res : Node_Type;
   begin
      if Format = Format_Medium then
         --  Allocate a first node.
         Nodet.Increment_Last;
         Res := Nodet.Last;
         --  Check alignment.
         if Res mod 2 = 1 then
            Set_Field1 (Res, Free_Chain);
            Free_Chain := Res;
            Nodet.Increment_Last;
            Res := Nodet.Last;
         end if;
         --  Allocate the second node.
         Nodet.Increment_Last;
         Nodet.Table (Res) := Init_Medium;
         Nodet.Table (Res + 1) := Init_Medium;
      else
         --  Check from free pool
         if Free_Chain = Null_Node then
            Nodet.Increment_Last;
            Res := Nodet.Last;
         else
            Res := Free_Chain;
            Free_Chain := Get_Field1 (Res);
         end if;
         case Format is
            when Format_Short =>
               Nodet.Table (Res) := Init_Short;
            when Format_Medium =>
               raise Program_Error;
            when Format_Fp =>
               Nodet.Table (Res) := Init_Fp;
            when Format_Int =>
               Nodet.Table (Res) := Init_Int;
         end case;
      end if;
      return Res;
   end Create_Node;

   procedure Free_Node (N : Node_Type)
   is
   begin
      if N /= Null_Node then
         Set_Nkind (N, 0);
         Set_Field1 (N, Free_Chain);
         Free_Chain := N;
         if Nodet.Table (N).Format = Format_Medium then
            Set_Field1 (N + 1, Free_Chain);
            Free_Chain := N + 1;
         end if;
      end if;
   end Free_Node;

   function Get_Nkind (N : Node_Type) return Kind_Type is
   begin
      return Nodet.Table (N).Kind;
   end Get_Nkind;

   procedure Set_Nkind (N : Node_Type; Kind : Kind_Type) is
   begin
      Nodet.Table (N).Kind := Kind;
   end Set_Nkind;


   procedure Set_Location (N : Node_Type; Location: Location_Type) is
   begin
      Nodet.Table (N).Location := Location;
   end Set_Location;

   function Get_Location (N: Node_Type) return Location_Type is
   begin
      --Put_Line(Integer'Image(Integer(N)));
      return Nodet.Table (N).Location;
   end Get_Location;


   procedure Set_Field0 (N : Node_Type; V : Node_Type) is
   begin
      Nodet.Table (N).Field0 := V;
   end Set_Field0;

   function Get_Field0 (N : Node_Type) return Node_Type is
   begin
      return Nodet.Table (N).Field0;
   end Get_Field0;


   function Get_Field1 (N : Node_Type) return Node_Type is
   begin
      return Nodet.Table (N).Field1;
   end Get_Field1;

   procedure Set_Field1 (N : Node_Type; V : Node_Type) is
   begin
      Nodet.Table (N).Field1 := V;
   end Set_Field1;

   function Get_Field2 (N : Node_Type) return Node_Type is
   begin
      return Nodet.Table (N).Field2;
   end Get_Field2;

   procedure Set_Field2 (N : Node_Type; V : Node_Type) is
   begin
      Nodet.Table (N).Field2 := V;
   end Set_Field2;

   function Get_Field3 (N : Node_Type) return Node_Type is
   begin
      return Nodet.Table (N).Field3;
   end Get_Field3;

   procedure Set_Field3 (N : Node_Type; V : Node_Type) is
   begin
      Nodet.Table (N).Field3 := V;
   end Set_Field3;

   function Get_Field4 (N : Node_Type) return Node_Type is
   begin
      return Nodet.Table (N).Field4;
   end Get_Field4;

   procedure Set_Field4 (N : Node_Type; V : Node_Type) is
   begin
      Nodet.Table (N).Field4 := V;
   end Set_Field4;

   function Get_Field5 (N : Node_Type) return Node_Type is
   begin
      return Nodet.Table (N).Field5;
   end Get_Field5;

   procedure Set_Field5 (N : Node_Type; V : Node_Type) is
   begin
      Nodet.Table (N).Field5 := V;
   end Set_Field5;

   function Get_Field6 (N: Node_Type) return Node_Type is
   begin
      return Node_Type (Nodet.Table (N + 1).Location);
   end Get_Field6;

   procedure Set_Field6 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Location := Location_Type (Val);
   end Set_Field6;

   function Get_Field7 (N: Node_Type) return Node_Type is
   begin
      return Nodet.Table (N + 1).Field0;
   end Get_Field7;

   procedure Set_Field7 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Field0 := Val;
   end Set_Field7;

   function Get_Field8 (N: Node_Type) return Node_Type is
   begin
      return Nodet.Table (N + 1).Field1;
   end Get_Field8;

   procedure Set_Field8 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Field1 := Val;
   end Set_Field8;

   function Get_Field9 (N: Node_Type) return Node_Type is
   begin
      return Nodet.Table (N + 1).Field2;
   end Get_Field9;

   procedure Set_Field9 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Field2 := Val;
   end Set_Field9;

   function Get_Field10 (N: Node_Type) return Node_Type is
   begin
      return Nodet.Table (N + 1).Field3;
   end Get_Field10;

   procedure Set_Field10 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Field3 := Val;
   end Set_Field10;

   function Get_Field11 (N: Node_Type) return Node_Type is
   begin
      return Nodet.Table (N + 1).Field4;
   end Get_Field11;

   procedure Set_Field11 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Field4 := Val;
   end Set_Field11;

   function Get_Field12 (N: Node_Type) return Node_Type is
   begin
      return Nodet.Table (N + 1).Field5;
   end Get_Field12;

   procedure Set_Field12 (N: Node_Type; Val: Node_Type) is
   begin
      Nodet.Table (N + 1).Field5 := Val;
   end Set_Field12;


   function Get_Flag1 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag1;
   end Get_Flag1;

   procedure Set_Flag1 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag1 := V;
   end Set_Flag1;

   function Get_Flag2 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag2;
   end Get_Flag2;

   procedure Set_Flag2 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag2 := V;
   end Set_Flag2;

   function Get_Flag3 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag3;
   end Get_Flag3;

   procedure Set_Flag3 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag3 := V;
   end Set_Flag3;

   function Get_Flag4 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag4;
   end Get_Flag4;

   procedure Set_Flag4 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag4 := V;
   end Set_Flag4;

   function Get_Flag5 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag5;
   end Get_Flag5;

   procedure Set_Flag5 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag5 := V;
   end Set_Flag5;

   function Get_Flag6 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag6;
   end Get_Flag6;

   procedure Set_Flag6 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag6 := V;
   end Set_Flag6;

   function Get_Flag7 (N : Node_Type) return Boolean is
   begin
      return Nodet.Table (N).Flag7;
   end Get_Flag7;

   procedure Set_Flag7 (N : Node_Type; V : Boolean) is
   begin
      Nodet.Table (N).Flag7 := V;
   end Set_Flag7;


   function Get_State1 (N : Node_Type) return Bit2_Type is
   begin
      return Nodet.Table (N).State1;
   end Get_State1;

   procedure Set_State1 (N : Node_Type; V : Bit2_Type) is
   begin
      Nodet.Table (N).State1 := V;
   end Set_State1;

   function Get_State2 (N : Node_Type) return Bit2_Type is
   begin
      return Nodet.Table (N).State2;
   end Get_State2;

   procedure Set_State2 (N : Node_Type; V : Bit2_Type) is
   begin
      Nodet.Table (N).State2 := V;
   end Set_State2;

   function Get_State3 (N : Node_Type) return Bit2_Type is
   begin
      return Nodet.Table (N + 1).State1;
   end Get_State3;

   procedure Set_State3 (N : Node_Type; V : Bit2_Type) is
   begin
      Nodet.Table (N + 1).State1 := V;
   end Set_State3;

   function Get_State4 (N : Node_Type) return Bit2_Type is
   begin
      return Nodet.Table (N + 1).State2;
   end Get_State4;

   procedure Set_State4 (N : Node_Type; V : Bit2_Type) is
   begin
      Nodet.Table (N + 1).State2 := V;
   end Set_State4;


   function Get_Odigit1 (N : Node_Type) return Bit3_Type is
   begin
      return Nodet.Table (N).Odigit1;
   end Get_Odigit1;

   procedure Set_Odigit1 (N : Node_Type; V : Bit3_Type) is
   begin
      Nodet.Table (N).Odigit1 := V;
   end Set_Odigit1;

   function Get_Odigit2 (N : Node_Type) return Bit3_Type is
   begin
      return Nodet.Table (N + 1).Odigit1;
   end Get_Odigit2;

   procedure Set_Odigit2 (N : Node_Type; V : Bit3_Type) is
   begin
      Nodet.Table (N + 1).Odigit1 := V;
   end Set_Odigit2;


   function Get_Fp64 (N : Node_Type) return Iir_Fp64 is
   begin
      return Nodet.Table (N).Fp64;
   end Get_Fp64;

   procedure Set_Fp64 (N : Node_Type; V : Iir_Fp64) is
   begin
      Nodet.Table (N).Fp64 := V;
   end Set_Fp64;


   function Get_Int64 (N : Node_Type) return Iir_Int64 is
   begin
      return Nodet.Table (N).Int64;
   end Get_Int64;

   procedure Set_Int64 (N : Node_Type; V : Iir_Int64) is
   begin
      Nodet.Table (N).Int64 := V;
   end Set_Int64;

   procedure Initialize is
   begin
      Nodet.Free;
      Nodet.Init;
   end Initialize;
end Nodes;
