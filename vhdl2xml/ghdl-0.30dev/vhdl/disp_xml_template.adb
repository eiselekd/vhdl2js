--  Node displaying (for debugging).
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
with Types; use Types;
with Ada.Text_IO; use Ada.Text_IO;
with Name_Table;
with Iirs_Utils; use Iirs_Utils;
with Tokens;
with Errorout;
with Files_Map;
--with PSL.Dump_Tree;
--with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Disp_Xml is



   procedure Disp_Tab (Tab: Natural) is
      Blanks : constant String (1 .. Tab) := (others => ' ');
   begin
      Put (Blanks);
   end Disp_Tab;
   pragma Unreferenced (Disp_Tab);

   function Disp_Iir_Address (Node: Iir) return U_String
   is
      Res : String (1 .. 10);
      Hex_Digits : constant array (Int32 range 0 .. 15) of Character
        := "0123456789abcdef";
      N : Int32 := Int32 (Node);
   begin
      for I in reverse 2 .. 9 loop
         Res (I) := Hex_Digits (N mod 16);
         N := N / 16;
      end loop;
      Res (1) := '[';
      Res (10) := ']';
      return + (Res);
   end Disp_Iir_Address;

   function Inc_Tab (Tab: Natural) return Natural is
   begin
      return Tab + 4;
   end Inc_Tab;
   pragma Unreferenced (Inc_Tab);

   -- For iir.

   function Disp_Xml_Flat (p : Xml_Node_Acc; N: U_String; Tree: Iir)
                           return Xml_Node_Acc;

   procedure Disp_Xml_List
     (p : Xml_Node_Acc; N: U_String; Tree_List: Iir_List;
      Flat_Decl : Boolean := False)
   is
      El: Iir;
      Idx : Int32 := 0;
      L : Xml_Node_Acc;
   begin
      if Tree_List = Null_Iir_List then
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"null-list"));
      elsif Tree_List = Iir_List_All then
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"list-all"));
      elsif Tree_List = Iir_List_Others then
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"list-others"));
      else
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"list"));
         for I in Natural loop
            El := Get_Nth_Element (Tree_List, I);
            exit when El = Null_Iir;
            Disp_Xml (L, + ("idx-" & Int32'Image(Idx)), El, Flat_Decl);
            Idx := Idx + 1;
         end loop;
      end if;
      AddAttr (L, +"pos", N );
   end Disp_Xml_List;

   procedure Disp_Xml_Chain
     (p : Xml_Node_Acc; V: U_String; Tree_Chain: Iir;
      Flat_Decl : Boolean := False)
   is
      El: Iir;
      Idx : Int32 := 0;
      L : Xml_Node_Acc;
   begin
      L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"chain"));
      El := Tree_Chain;
      while El /= Null_Iir loop
         Disp_Xml (L, + ("idx-" & Int32'Image(Idx)), El, Flat_Decl);
         El := Get_Chain (El);
         Idx := Idx + 1;
      end loop;
      AddAttr (L, +"pos", V );
   end Disp_Xml_Chain;

   procedure Disp_Xml_Flat_Chain (p : Xml_Node_Acc; V: U_String;
          Tree_Chain: Iir)
   is
      El: Iir;
      Idx : Int32 := 0;
      e:Xml_Node_Acc;
      L : Xml_Node_Acc;
      pragma Unreferenced (e);
   begin
      El := Tree_Chain;
      L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"chain"));
      while El /= Null_Iir loop
         e := Disp_Xml_Flat (L, + ("idx-" & Int32'Image(Idx)), El);
         El := Get_Chain (El);
         Idx := Idx + 1;
      end loop;
      AddAttr (L, +"pos", V );
   end Disp_Xml_Flat_Chain;

   procedure Disp_Xml_List_Flat (p : Xml_Node_Acc; V: U_String;
            Tree_List: Iir_List)
   is
      Idx : Int32 := 0;
      El: Iir;
      L : Xml_Node_Acc;
      e:Xml_Node_Acc;
      pragma Unreferenced (e);
   begin
      if Tree_List = Null_Iir_List then
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"null-list"));
      elsif Tree_List = Iir_List_All then
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"list-all"));
      elsif Tree_List = Iir_List_Others then
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"list-others"));
      else
         L := Xml_Node_Acc(Create_Xml_Node_Pretty(p,+"list"));
         for I in Natural loop
            El := Get_Nth_Element (Tree_List, I);
            exit when El = Null_Iir;
            e:=Disp_Xml_Flat (L,+ ("idx-" & Int32'Image(Idx)),El);
            Idx := Idx + 1;
         end loop;
      end if;
      AddAttr (L, +"pos", V );
   end Disp_Xml_List_Flat;

   function Disp_Ident (Ident: Name_Id) return U_String is
      use Name_Table;
   begin
      if Ident /= Null_Identifier then
         Image (Ident);
         return + (" '" & Name_Buffer (1 .. Name_Length) & ''');
      else
         return + (" <anonymous>");
      end if;
   end Disp_Ident;

   function Disp_Xml_Flat (p : Xml_Node_Acc; N: U_String; Tree: Iir)
                           return Xml_Node_Acc
   is
      procedure Disp_Identifier (Identifying: Iir)
      is
         Ident : Name_Id;
         pragma Unreferenced (Ident);
      begin
         if Identifying /= Null_Iir then
            Ident := Get_Identifier (Identifying);
            --Put_Line(- Disp_Ident (Ident));
         else
            null;--New_Line;
         end if;
      end Disp_Identifier;

      procedure Disp_Decl_Ident
      is
         A_Type: Iir;
      begin
         A_Type := Get_Type_Declarator (Tree);
         if A_Type /= Null_Iir then
            Disp_Identifier (A_Type);
         else
            --Put_Line (" <unnamed>");
            return;
         end if;
      end Disp_Decl_Ident;
      pragma Unreferenced (Disp_Decl_Ident);
      typ : U_String := + "<skip>";
      val, iir : U_String;
      e : Xml_Node_Acc := null;
   begin
      --Put_Line(-N);
      iir := Disp_Iir_Address (Tree);
      val := + "";
      if Tree = Null_Iir then
         typ := + ("NULL");
      else
         case Get_Kind (Tree) is
@typ@
         end case;
      end if;

      e := Xml_Node_Acc(Create_Xml_Node_Pretty(p,typ));
      AddAttr (e, +"pos", N );
      AddAttr (e, +"id", iir );
      if Length(val) /= 0 then
         AddAttr (e, +"val", val );
      end if;
      return e;
   end Disp_Xml_Flat;

   function Disp_Staticness (Static: Iir_Staticness) return U_String is
   begin
      case Static is
         when Unknown =>
            return (+"???");
         when None =>
            return (+"none");
         when Globally =>
            return (+"global");
         when Locally =>
            return (+"local");
      end case;
   end Disp_Staticness;

   function Disp_Flag (Bool : Boolean) return U_String is
   begin
      if Bool then
         return (+"true");
      else
         return (+"false");
      end if;
   end Disp_Flag;

   function Disp_Expr_Staticness (Expr: Iir) return U_String is
      pragma Unreferenced (Expr);
   begin
      return +"expr";
      --Put (" expr: ");
      --Disp_Staticness (Get_Expr_Staticness (Expr));
      --New_Line;
   end Disp_Expr_Staticness;

   function Disp_Type_Staticness (Atype: Iir) return U_String is
      pragma Unreferenced (Atype);
   begin
      return +"type";
      --Put (" type: ");
      --Disp_Staticness (Get_Type_Staticness (Atype));
      --New_Line;
   end Disp_Type_Staticness;

   function Disp_Name_Staticness (Expr: Iir) return U_String  is
      pragma Unreferenced (Expr);
   begin
      return +"name";
      --Put (" expr: ");
      --Disp_Staticness (Get_Expr_Staticness (Expr));
      --Put (", name: ");
      --Disp_Staticness (Get_Name_Staticness (Expr));
      --New_Line;
   end Disp_Name_Staticness;

   function Disp_Choice_Staticness (Expr: Iir) return U_String  is
      pragma Unreferenced (Expr);
   begin
      return +"choice";
      --Put (" choice: ");
      --Disp_Staticness (Get_Choice_Staticness (Expr));
      --New_Line;
   end Disp_Choice_Staticness;

   function Disp_Type_Resolved_Flag (Atype : Iir) return U_String is
   begin
      if Get_Resolved_Flag (Atype) then
         return (+"resolved");
      else
         return +"";
      end if;
   end Disp_Type_Resolved_Flag;

   function Disp_Lexical_Layout (Decl : Iir) return U_String
   is
      pragma Unreferenced (Decl);
      V : Iir_Lexical_Layout_Type;
      pragma Unreferenced (V);
   begin
      return +"layout";
      --  V := Get_Lexical_Layout (Decl);
      --  if (V and Iir_Lexical_Has_Mode) /= 0 then
      --     Put (" +mode");
      --  end if;
      --  if (V and Iir_Lexical_Has_Class) /= 0 then
      --     Put (" +class");
      --  end if;
      --  if (V and Iir_Lexical_Has_Type) /= 0 then
      --     Put (" +type");
      --  end if;
      --  New_Line;
   end Disp_Lexical_Layout;

   function Disp_Purity_State (State : Iir_Pure_State) return U_String
   is
   begin
      case State is
         when Pure =>
            return (+" pure");
         when Impure =>
            return (+" impure");
         when Maybe_Impure =>
            return (+" maybe_impure");
         when Unknown =>
            return (+" unknown");
      end case;
   end Disp_Purity_State;

   function Disp_State (State : Tri_State_Type) return U_String
   is
   begin
      case State is
         when True =>
            return (+" true");
         when False =>
            return (+" false");
         when Unknown =>
            return (+" unknown");
      end case;
   end Disp_State;

   function Disp_Depth (Depth : Iir_Int32) return U_String is
   begin
      return + (Iir_Int32'Image (Depth));
   end Disp_Depth;

   procedure flag(P : in Xml_Node_Acc; N : U_String; V: U_String) is
   begin
      AddAttr(P,N,V);
   end flag;

   procedure Disp_Xml (p : Xml_Node_Acc; V: U_String;
                        Tree: Iir;
                        Flat_Decl: Boolean := false) is
      --Ntab: constant Natural := 0; --Inc_Tab (Tab);
      Kind : Iir_Kind;

      procedure Header (Str: String; Nl: Boolean := true) is
      pragma Unreferenced (Str);
      begin
         null;
--         Disp_Tab (Ntab);
--         if Nl then
--            New_Line;
--         end if;
      end Header;

      procedure Disp_Label (p : Xml_Node_Acc; Tree: Iir) is
         Label : Name_Id;
         pragma Unreferenced (p);
      begin
         Label := Get_Label (Tree);
         if Label /= Null_Identifier then
            Header ("label: "  & Name_Table.Image (Label));
         else
            Header ("label: -");
         end if;
      end Disp_Label;

      e : Xml_Node_Acc;
      child : Xml_Node_Acc := null;
      pragma Unreferenced (child);
   begin
      e := Disp_Xml_Flat (p,V,Tree);
      if Tree = Null_Iir then
         return;
      end if;

      if Get_Location (Tree) /= Location_Nil then
         AddAttr(e,+"loc", + Errorout.Get_Location_Str (Get_Location (Tree)));
      end if;

      Kind := Get_Kind (Tree);
      case Kind is
@disp@
      end case;
   end Disp_Xml;

   --  procedure Disp_Xml_For_Psl (N : Int32) is
   --  begin
   --     Disp_Xml_Flat (Iir (N), 1);
   --  end Disp_Xml_For_Psl;
end Disp_Xml;
