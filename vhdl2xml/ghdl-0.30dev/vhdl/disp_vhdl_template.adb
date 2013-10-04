--  VHDL regeneration from internal nodes.
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


-- Disp an iir tree.
-- Try to be as pretty as possible, and to keep line numbers and positions
-- of the identifiers.
with Ada.Text_IO; use Ada.Text_IO;
with Std_Package;
with Flags; use Flags;
with Errorout; use Errorout;
with Iirs_Utils; use Iirs_Utils;
with Types; use Types;
with Name_Table;
with Std_Names;
with Tokens;
with PSL.Nodes;
--with PSL.Prints;
with PSL.NFAs;

package body disp_xml_vhdl is

   --  Disp the name of DECL.
   procedure Disp_Name_Of (Decl: Iir);

   Indentation: constant Count := 2;

   -- If set, disp after a string literal the type enclosed into brackets.
   Disp_String_Literal_Type: constant Boolean := False;

   -- If set, disp position number of associations
   --Disp_Position_Number: constant Boolean := False;

--    procedure Disp_Tab (Tab: Natural) is
--       Blanks : String (1 .. Tab) := (others => ' ');
--    begin
--       Put (Blanks);
--    end Disp_Tab;

   procedure Disp_Type (A_Type: Iir);

   procedure Disp_Expression (Expr: Iir);
   procedure Disp_Concurrent_Statement (Stmt: Iir);
   procedure Disp_Concurrent_Statement_Chain
      (Parent: Iir; Indent : Count);
   procedure Disp_Declaration_Chain
     (Parent : Iir; Indent: Count);
   procedure Disp_Process_Statement (Process: Iir);
   procedure Disp_Sequential_Statements (First : Iir);
   procedure Disp_Choice (Choice: in out Iir);
   procedure Disp_Association_Chain (Chain : Iir);
   procedure Disp_Block_Configuration
     (Block: Iir_Block_Configuration; Indent: Count);
   procedure Disp_Subprogram_Declaration (Subprg: Iir);
   procedure Disp_Binding_Indication
     (Bind : Iir; Indent : Count);
   procedure Disp_Subtype_Indication (Def : Iir;
                                      Full_Decl : Boolean := False);
   procedure Disp_Int64 (Val: Iir_Int64);
   --procedure Disp_Int32 (Val: Iir_Int32);
   procedure Disp_Fp64 (Val: Iir_Fp64);

   procedure ChangeTag (E: X; Tree : in Iir) is
   begin
      case Get_Kind (Tree) is
@typ@
      end case;
   end ChangeTag;

   ------------- str -----------
   procedure SetId (Nxml:X;Node:Iir) is
      Res : String (1 .. 10);
      Hex_Digits : constant array (Int32 range 0 .. 15) of Character
        := "0123456789abcdef";
      N : Int32 := Int32 (Node);
      pragma Unreferenced (Res);
   begin
      for I in reverse 2 .. 9 loop
         Res (I) := Hex_Digits (N mod 16);
         N := N / 16;
      end loop;
      Res (1) := '[';
      Res (10) := ']';
      AddAttr(Nxml,+"iir",+(Integer'Image(Integer(Node)))); --Res
      if Node /= 0 then
         if  Get_Location (Node) /= Location_Nil then
            AddAttr(Nxml,+"loc",
            + Errorout.Get_Location_Str (Get_Location (Node)));
         end if;
      end if;
   end SetId;

   function Str_Ident (Id: Name_Id) return U_String is
   begin
      return +(Name_Table.Image (Id));
   end Str_Ident;

   function Str_Identifier (Node : Iir) return U_String is
      Ident : Name_Id;
   begin
      Ident := Get_Identifier (Node);
      if Ident /= Null_Identifier then
         return Str_Ident (Ident);
      else
         return +("<anonymous>");
      end if;
   end Str_Identifier;

   function Str_Label (Node : Iir) return U_String is
      Ident : Name_Id;
   begin
      Ident := Get_Label (Node);
      if Ident /= Null_Identifier then
         return Str_Ident (Ident);
      else
         return + ("<anonymous>");
      end if;
   end Str_Label;

   function Str_Entity_Kind (Tok : Tokens.Token_Type) return U_String is
   begin
      return + (Tokens.Image (Tok));
   end Str_Entity_Kind;

   function Str_Character_Literal(
             Lit: Iir_Character_Literal) return U_String is
   begin
      return + (''' & Name_Table.Get_Character (Get_Identifier (Lit)) & ''');
   end Str_Character_Literal;
   pragma Unreferenced (Str_Character_Literal);

   function Str_Function_Name (Func: Iir) return U_String is
      use Name_Table;
      use Std_Names;
      Id: Name_Id;
   begin
      Id := Get_Identifier (Func);
      case Id is
         when Name_Id_Operators
           | Name_Word_Operators
           | Name_Xnor
           | Name_Shift_Operators =>
            return +("""" & Image (Id) & """");
         when others =>
            return Str_Ident (Id);
      end case;
   end Str_Function_Name;

   --  Disp the name of DECL.
   function Str_Name_Of (Decl: Iir) return U_String is
   begin
      case Get_Kind (Decl) is
         when Iir_Kind_Component_Declaration
           | Iir_Kind_Entity_Declaration
           | Iir_Kind_Architecture_Declaration
           | Iir_Kind_Constant_Interface_Declaration
           | Iir_Kind_Signal_Interface_Declaration
           | Iir_Kind_Variable_Interface_Declaration
           | Iir_Kind_File_Interface_Declaration
           | Iir_Kind_Constant_Declaration
           | Iir_Kind_Signal_Declaration
           | Iir_Kind_Guard_Signal_Declaration
           | Iir_Kind_Variable_Declaration
           | Iir_Kind_Configuration_Declaration
           | Iir_Kind_Type_Declaration
           | Iir_Kind_File_Declaration
           | Iir_Kind_Subtype_Declaration
           | Iir_Kind_Element_Declaration
           | Iir_Kind_Record_Element_Constraint
           | Iir_Kind_Package_Declaration
           | Iir_Kind_Object_Alias_Declaration
           | Iir_Kind_Non_Object_Alias_Declaration
           | Iir_Kind_Iterator_Declaration
           | Iir_Kind_Library_Declaration
           | Iir_Kind_Unit_Declaration =>
            return Str_Identifier (Decl);
         when Iir_Kind_Anonymous_Type_Declaration =>
            return ((+'<') & Str_Ident (Get_Identifier (Decl)) & (+'>'));
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            return Str_Function_Name (Decl);
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            return Str_Identifier (Decl);
         when Iir_Kind_Physical_Subtype_Definition
           | Iir_Kind_Enumeration_Type_Definition =>
            return Str_Identifier (Get_Type_Declarator (Decl));
         when Iir_Kind_Component_Instantiation_Statement =>
            return Str_Ident (Get_Label (Decl));
         when Iir_Kind_Design_Unit =>
            return Str_Name_Of (Get_Library_Unit (Decl));
         when Iir_Kind_Enumeration_Literal
           | Iir_Kind_Simple_Name =>
            return Str_Identifier (Decl);
         when Iir_Kind_Block_Statement
           | Iir_Kind_Generate_Statement =>
            return Str_Label (Decl);
         when others =>
            Error_Kind ("disp_name_of", Decl);
            return +("<error>");
      end case;
   end Str_Name_Of;

   function Str_Name (Name: Iir) return U_String is
   begin
      case Get_Kind (Name) is
         when Iir_Kind_Selected_By_All_Name =>
            return (Str_Name (Get_Prefix (Name)) & (+".all"));
         when Iir_Kind_Dereference =>
            return (Str_Name (Get_Prefix (Name)) & (+".all")) ;
         when Iir_Kind_Simple_Name =>
            return +(Iirs_Utils.Image_Identifier (Name));
         when Iir_Kind_Selected_Name =>
            return (Str_Name (Get_Prefix (Name)) & (+".")
            & Str_Ident (Get_Suffix_Identifier (Name)));
         when Iir_Kind_Type_Declaration
           | Iir_Kind_Enumeration_Literal
           | Iir_Kind_Implicit_Function_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration
           | Iir_Kind_Variable_Declaration
           | Iir_Kind_Function_Declaration
           | Iir_Kind_Procedure_Declaration =>
            return Str_Name_Of (Name);
         when others =>
            Error_Kind ("disp_name", Name);
            return +("<error>");
      end case;
   end Str_Name;

   function Str_Mode (Mode: Iir_Mode) return U_String is
   begin
      case Mode is
         when Iir_In_Mode =>
            return +("in ");
         when Iir_Out_Mode =>
            return +("out ");
         when Iir_Inout_Mode =>
            return +("inout ");
         when Iir_Buffer_Mode =>
            return +("buffer ");
         when Iir_Linkage_Mode =>
            return +("linkage ");
         when Iir_Unknown_Mode =>
            return +("<unknown> ");
      end case;
   end Str_Mode;

   function Str_Signal_Kind (Kind: Iir_Signal_Kind) return U_String is
   begin
      case Kind is
         when Iir_No_Signal_Kind =>
            return +("");
         when Iir_Register_Kind =>
            return +(" register");
         when Iir_Bus_Kind =>
            return +(" bus");
      end case;
   end Str_Signal_Kind;

   function Str_String_Literal (Str : Iir) return U_String is
      Ptr : String_Fat_Acc;
      Len : Int32;
   begin
      Ptr := Get_String_Fat_Acc (Str);
      Len := Get_String_Length (Str);
      return + (String (Ptr (1 .. Len)));
   end Str_String_Literal;

   function Str_Int64 (Val: Iir_Int64) return U_String is
      Str: constant String := Iir_Int64'Image (Val);
   begin
      if Str(Str'First) = ' ' then
         return + (Str (Str'First + 1 .. Str'Last));
      else
         return + (Str);
      end if;
   end Str_Int64;

   function Str_Fp64 (Val: Iir_Fp64) return U_String is
      Str: constant String := Iir_Fp64'Image (Val);
   begin
      if Str(Str'First) = ' ' then
         return + (Str (Str'First + 1 .. Str'Last));
      else
         return + (Str);
      end if;
   end Str_Fp64;

   -- pragma Unreferenced (Str_Signal_Kind);
   ------------- /str -----------


   procedure Disp_Ident (Id: Name_Id) is
   begin
      Put (Name_Table.Image (Id) );
   end Disp_Ident;

   procedure Disp_Identifier (Node : Iir) is
      Ident : Name_Id;
   begin
      Ident := Get_Identifier (Node);
      if Ident /= Null_Identifier then
         Disp_Ident (Ident);
      else
         Put ("<anonymous>");
      end if;
   end Disp_Identifier;

   procedure Disp_Label (Node : Iir) is
      Ident : Name_Id;
   begin
      Ident := Get_Label (Node);
      if Ident /= Null_Identifier then
         Disp_Ident (Ident);
      else
         Put ("<anonymous>");
      end if;
   end Disp_Label;

   procedure Disp_Character_Literal (Lit: Iir_Character_Literal) is
   begin
      Put (''' & Name_Table.Get_Character (Get_Identifier (Lit)) & ''');
   end Disp_Character_Literal;

   procedure Disp_Function_Name (Func: Iir)
   is
      use Name_Table;
      use Std_Names;
      Id: Name_Id;
   begin
      Id := Get_Identifier (Func);
      case Id is
         when Name_Id_Operators
           | Name_Word_Operators
           | Name_Xnor
           | Name_Shift_Operators =>
            Put ("""");
            Put (Image (Id));
            Put ("""");
         when others =>
            Disp_Ident (Id);
      end case;
   end Disp_Function_Name;

   --  Disp the name of DECL.
   procedure Disp_Name_Of (Decl: Iir) is
   begin
      case Get_Kind (Decl) is
         when Iir_Kind_Component_Declaration
           | Iir_Kind_Entity_Declaration
           | Iir_Kind_Architecture_Declaration
           | Iir_Kind_Constant_Interface_Declaration
           | Iir_Kind_Signal_Interface_Declaration
           | Iir_Kind_Variable_Interface_Declaration
           | Iir_Kind_File_Interface_Declaration
           | Iir_Kind_Constant_Declaration
           | Iir_Kind_Signal_Declaration
           | Iir_Kind_Guard_Signal_Declaration
           | Iir_Kind_Variable_Declaration
           | Iir_Kind_Configuration_Declaration
           | Iir_Kind_Type_Declaration
           | Iir_Kind_File_Declaration
           | Iir_Kind_Subtype_Declaration
           | Iir_Kind_Element_Declaration
           | Iir_Kind_Record_Element_Constraint
           | Iir_Kind_Package_Declaration
           | Iir_Kind_Object_Alias_Declaration
           | Iir_Kind_Non_Object_Alias_Declaration
           | Iir_Kind_Iterator_Declaration
           | Iir_Kind_Library_Declaration
           | Iir_Kind_Unit_Declaration =>
            Disp_Identifier (Decl);
         when Iir_Kind_Anonymous_Type_Declaration =>
            Put ('<');
            Disp_Ident (Get_Identifier (Decl));
            Put ('>');
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            Disp_Function_Name (Decl);
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            Disp_Identifier (Decl);
         when Iir_Kind_Physical_Subtype_Definition
           | Iir_Kind_Enumeration_Type_Definition =>
            Disp_Identifier (Get_Type_Declarator (Decl));
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Ident (Get_Label (Decl));
         when Iir_Kind_Design_Unit =>
            Disp_Name_Of (Get_Library_Unit (Decl));
         when Iir_Kind_Enumeration_Literal
           | Iir_Kind_Simple_Name =>
            Disp_Identifier (Decl);
         when Iir_Kind_Block_Statement
           | Iir_Kind_Generate_Statement =>
            Disp_Label (Decl);
         when others =>
            Error_Kind ("disp_name_of", Decl);
      end case;
   end Disp_Name_Of;


   procedure Disp_Range (Decl: Iir) is
   begin
      if Get_Kind (Decl) = Iir_Kind_Range_Expression then
         Disp_Expression (Get_Left_Limit (Decl)); -- p:l
         if Get_Direction (Decl) = Iir_To then
            Put (" to "); -- f:dir
         else
            Put (" downto "); -- f:dir
         end if;
         Disp_Expression (Get_Right_Limit (Decl)); -- p:r
      else
         if (Get_Kind(Decl) = Iir_Kind_Range_Array_Attribute) then
            Disp_Expression(Get_Prefix(Decl)); -- p:prefix
            Put ("'range "); -- f:typ
         else
            Disp_Subtype_Indication (Decl); -- reent:1
         end if;
         -- Disp_Subtype_Indication (Decl);
         --  Disp_Name_Of (Get_Type_Declarator (Decl));
      end if;
   end Disp_Range;

   procedure Disp_Name (Name: Iir) is
   begin
      case Get_Kind (Name) is
         when Iir_Kind_Selected_By_All_Name =>
            Disp_Name (Get_Prefix (Name));
            Put (".all");
         when Iir_Kind_Dereference =>
            Disp_Name (Get_Prefix (Name));
            Put (".all");
         when Iir_Kind_Simple_Name =>
            Put (Iirs_Utils.Image_Identifier (Name));
         when Iir_Kind_Selected_Name =>
            Disp_Name (Get_Prefix (Name));
            Put (".");
            Disp_Ident (Get_Suffix_Identifier (Name));
         when Iir_Kind_Type_Declaration
           | Iir_Kind_Enumeration_Literal
           | Iir_Kind_Implicit_Function_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration
           | Iir_Kind_Variable_Declaration
           | Iir_Kind_Function_Declaration
           | Iir_Kind_Procedure_Declaration =>
            Disp_Name_Of (Name);
         when others =>
            Error_Kind ("disp_name", Name);
      end case;
   end Disp_Name;

   procedure Disp_Use_Clause (Clause: Iir_Use_Clause) is
   begin
      Put ("use ");
      Disp_Name (Get_Selected_Name (Clause)); -- f:n
      Put_Line (";");
   end Disp_Use_Clause;

   -- Disp the resolution function (if any) of type definition DEF.
   procedure Disp_Resolution_Function (Subtype_Def: Iir)
   is
      procedure Inner (P:X;Pos:U_String;Def : Iir)
      is
         Decl: Iir;
         N: constant X := X(Create_Xml_Node_Pretty(P,Pos));
      begin
         if Get_Kind (Def) in Iir_Kinds_Subtype_Definition then
            Decl := Get_Resolution_Function (Def);
            if Decl /= Null_Iir then
               Disp_Name (Decl); -- f:n
            else
               case Get_Kind (Def) is
                  when Iir_Kind_Array_Subtype_Definition =>
                     Put ('(');
                     Inner (N,+"inner",Get_Element_Subtype (Def));
                     Put (')');
                  when others =>
                     Error_Kind ("disp_resolution_function", Def);
               end case;
            end if;
         end if;
      end Inner;

   begin
      if Get_Resolved_Flag (Subtype_Def) then
         Inner (N,+"inner",Subtype_Def);
         Put (' ');
      end if;
   end Disp_Resolution_Function;

   procedure Disp_Integer_Subtype_Definition
     (Def: Iir_Integer_Subtype_Definition)
   is
      Base_Type: Iir_Integer_Type_Definition;
      Decl: Iir;
   begin
      if Def /= Std_Package.Universal_Integer_Subtype_Definition then
         Base_Type := Get_Base_Type (Def);
         Decl := Get_Type_Declarator (Base_Type);
         if Base_Type /= Std_Package.Universal_Integer_Subtype_Definition
           and then Def /= Decl
         then
            Disp_Name_Of (Decl); -- f:n
            Put (" ");
         end if;
      end if;
      Disp_Resolution_Function (Def);
      Put ("range ");
      Disp_Expression (Get_Range_Constraint (Def));
      Put (";");
   end Disp_Integer_Subtype_Definition;

   procedure Disp_Floating_Subtype_Definition
     (Def: Iir_Floating_Subtype_Definition)
   is
      Base_Type: Iir_Floating_Type_Definition;
      Decl: Iir;
   begin
      if Def /= Std_Package.Universal_Real_Subtype_Definition then
         Base_Type := Get_Base_Type (Def);
         Decl := Get_Type_Declarator (Base_Type);
         if Base_Type /= Std_Package.Universal_Real_Subtype_Definition
           and then Def /= Decl
         then
            Disp_Name_Of (Decl); -- f:n
            Put (" ");
         end if;
      end if;
      Disp_Resolution_Function (Def); --p:res
      Put ("range ");
      Disp_Expression (Get_Range_Constraint (Def)); --p:range
      Put (";");
   end Disp_Floating_Subtype_Definition;

   procedure Disp_Element_Constraint
     (Def : Iir; Type_Mark : Iir);

   procedure Disp_Array_Element_Constraint (Def : Iir; Type_Mark : Iir)
   is
      Index : Iir;
      Def_El : Iir;
      Tm_El : Iir;
      Has_Index : Boolean;
      Has_Own_Element_Subtype : Boolean;
      Ec : X;
   begin
      Has_Index := Get_Index_Constraint_Flag (Def);
      Def_El := Get_Element_Subtype (Def);
      Tm_El := Get_Element_Subtype (Type_Mark);
      Has_Own_Element_Subtype := Def_El /= Tm_El;

      if not Has_Index and not Has_Own_Element_Subtype then
         return;
      end if;

      Put (" (");
      if Has_Index then
         for I in Natural loop  -- chain:[v=Ec|n=arrrange]
            Index := Get_Nth_Element (Get_Index_Subtype_List (Def), I);
            exit when Index = Null_Iir; --exitchain:Ec
            if I /= 0 then
               Put (", ");
            end if;
            Disp_Range (Index); -- p:range
         end loop;
      else
         Put ("open");
      end if;
      Put (")");

      if Has_Own_Element_Subtype
        and then Get_Kind (Def_El) in Iir_Kinds_Composite_Type_Definition
      then
         Put ("ownsubtype"); --f:ownsubtype
         Disp_Element_Constraint (Def_El, Tm_El); --reent:1
      end if;
   end Disp_Array_Element_Constraint;

   procedure Disp_Record_Element_Constraint (Def : Iir)
   is
      El_List : constant Iir_List := Get_Elements_Declaration_List (Def);
      El : Iir;
      Has_El : Boolean := False;
      Ec : X;
   begin
      for I in Natural loop -- chain:[v=Ec|n=Enumeration]
         El := Get_Nth_Element (El_List, I);
         exit when El = Null_Iir; --exitchain:Ec
         if Get_Kind (El) = Iir_Kind_Record_Element_Constraint
           and then Get_Parent (El) = Def
         then
            if Has_El then
               Put (", ");
            else
               Put ("(");
               Has_El := True;
            end if;
            Disp_Name_Of (El); -- f:n
            Disp_Element_Constraint (Get_Type (El),
                                     Get_Base_Type (Get_Type (El)));
         end if;
      end loop;
      if Has_El then
         Put (")");
      end if;
   end Disp_Record_Element_Constraint;

   procedure Disp_Element_Constraint (Def : Iir; Type_Mark : Iir) is
   begin
      case Get_Kind (Def) is
         when Iir_Kind_Record_Subtype_Definition =>
            Disp_Record_Element_Constraint (Def); --reent:1
         when Iir_Kind_Array_Subtype_Definition =>
            Disp_Array_Element_Constraint (Def, Type_Mark); --reent:1
         when others =>
            Error_Kind ("disp_element_constraint", Def);
      end case;
   end Disp_Element_Constraint;

   procedure Disp_Subtype_Indication (Def : Iir; Full_Decl : Boolean := False)
   is
      Type_Mark : Iir;
      Base_Type : Iir;
      Decl : Iir;
   begin
      Decl := Get_Type_Declarator (Def);
      if not Full_Decl and then Decl /= Null_Iir then
         Disp_Name_Of (Decl); -- f:n
         return;
      end if;

      -- Resolution function name.
      Disp_Resolution_Function (Def); -- p:res

      -- type mark.
      Type_Mark := Get_Type_Mark (Def);
      if Type_Mark /= Null_Iir then
         Decl := Get_Type_Declarator (Type_Mark);
         Disp_Name_Of (Decl); -- f:typmark
      end if;

      Base_Type := Get_Base_Type (Def);
      case Get_Kind (Base_Type) is
         when Iir_Kind_Integer_Type_Definition
           | Iir_Kind_Enumeration_Type_Definition
           | Iir_Kind_Floating_Type_Definition
           | Iir_Kind_Physical_Type_Definition =>
            if Type_Mark = Null_Iir
              or else Get_Range_Constraint (Def)
              /= Get_Range_Constraint (Type_Mark)
            then
               if Type_Mark /= Null_Iir then
                  Put (" range ");
               end if;
               Disp_Expression (Get_Range_Constraint (Def));
            end if;
         when Iir_Kind_Array_Type_Definition =>
            Disp_Array_Element_Constraint (Def, Type_Mark); -- p:array
         when Iir_Kind_Record_Type_Definition =>
            Disp_Record_Element_Constraint (Def); -- p:record
         when others =>
            Error_Kind ("disp_subtype_indication", Base_Type);
      end case;
   end Disp_Subtype_Indication;

   procedure Disp_Enumeration_Type_Definition
     (Def: Iir_Enumeration_Type_Definition)
   is
      Len : Count;
      Start_Col: Count;
      Decl: Name_Id;
      A_Lit: Iir; --Enumeration_Literal_Acc;
      pragma Unreferenced (Start_Col);
      Ec : X;
   begin
      for I in Natural loop -- chain:[v=Ec|n=Enumeration]
         A_Lit := Get_Nth_Element (Get_Enumeration_Literal_List (Def), I);
         exit when A_Lit = Null_Iir; --exitchain:Ec
         if I = Natural'first then
            Put ("(");
            Start_Col := Col;
         else
            Put (", ");
         end if;
         Decl := Get_Identifier (A_Lit);
         if Name_Table.Is_Character (Decl) then
            Len := 3;
         else
            Len := Count (Name_Table.Get_Name_Length (Decl));
         end if;
         if Col + Len + 2 > Line_Length then
            New_Line;
            Set_Col (Start_Col);
         end if;
         Disp_Name_Of (A_Lit); -- f:n
      end loop;
      Put (");");
   end Disp_Enumeration_Type_Definition;

   procedure Disp_Enumeration_Subtype_Definition
     (Def: Iir_Enumeration_Subtype_Definition)
   is
   begin
      Disp_Resolution_Function (Def);
      Put ("range ");
      Disp_Range (Def);
      Put (";");
   end Disp_Enumeration_Subtype_Definition;

   procedure Disp_Array_Subtype_Definition
     (Def: Iir_Array_Subtype_Definition)
   is
      Index: Iir;
      Ec : X;
   begin
      Disp_Resolution_Function (Def);

      Put ("array (");
      for I in Natural loop -- chain:[v=Ec|n=arrrange]
         Index := Get_Nth_Element (Get_Index_Subtype_List (Def), I);
         exit when Index = Null_Iir; --exitchain:Ec
         if I /= 0 then
            Put (", ");
         end if;
         Disp_Subtype_Indication (Index); --p:range
      end loop;
      Put (") of ");
      Disp_Subtype_Indication (Get_Element_Subtype (Def)); --p:typ
   end Disp_Array_Subtype_Definition;

   procedure Disp_Array_Type_Definition (Def: Iir_Array_Type_Definition) is
      Index: Iir;
      Ec : X;
   begin
      Put ("array (");
      for I in Natural loop -- chain:[v=Ec|n=arrrange]
         Index := Get_Nth_Element (Get_Index_Subtype_List (Def), I);
         exit when Index = Null_Iir; --exitchain:Ec
         if I /= 0 then
            Put (", ");
         end if;
         Disp_Subtype_Indication (Index); --p:range
         Put (" range <>");
      end loop;
      Put (") of ");
      Disp_Type (Get_Element_Subtype (Def)); --p:typ
      Put (";");
   end Disp_Array_Type_Definition;

   procedure Disp_Physical_Literal (Lit: Iir) is
   begin
      case Get_Kind (Lit) is
         when Iir_Kind_Physical_Int_Literal =>
            Disp_Int64 (Get_Value (Lit)); -- f:v
         when Iir_Kind_Physical_Fp_Literal =>
            Disp_Fp64 (Get_Fp_Value (Lit)); -- f:v
         when others =>
            Error_Kind ("disp_physical_literal", Lit);
      end case;
      Put (' ');
      Disp_Identifier (Get_Unit_Name (Lit)); -- f:unit
   end Disp_Physical_Literal;

   procedure Disp_Physical_Subtype_Definition
     (Def: Iir_Physical_Subtype_Definition; Indent: Count)
   is
      Base_Type: Iir;
      Unit: Iir_Unit_Declaration;
      Ec : X;
      pragma Unreferenced (Indent);
   begin
      Disp_Resolution_Function (Def);
      Put ("range ");
      Disp_Expression (Get_Range_Constraint (Def));
      Base_Type := Get_Base_Type (Def);
      if Get_Type_Declarator (Base_Type) = Get_Type_Declarator (Def) then
         Put_Line (" units");
         Set_Col (Indent + Indentation);
         Unit := Get_Unit_Chain (Base_Type);
         Disp_Identifier (Unit); -- f:nunit
         Put_Line (";");
         Unit := Get_Chain (Unit);
         while Unit /= Null_Iir loop -- chain:[v=Ec|n=unit]
            Set_Col (Indent + Indentation);
            Disp_Identifier (Unit); -- f:n
            Put (" = ");
            Disp_Physical_Literal (Get_Physical_Literal (Unit));
            Put_Line (";");
            Unit := Get_Chain (Unit);
         end loop;
         Set_Col (Indent);
         Put ("end units;");
      end if;
   end Disp_Physical_Subtype_Definition;

   procedure Disp_Record_Type_Definition
     (Def: Iir_Record_Type_Definition; Indent: Count)
   is
      List : Iir_List;
      El: Iir_Element_Declaration;
      pragma Unreferenced (Indent);
      Ec : X;
   begin
      Put_Line ("record");
      Set_Col (Indent);
      Put_Line ("begin");
      List := Get_Elements_Declaration_List (Def);
      for I in Natural loop -- chain:[v=Ec|n=entry]
         El := Get_Nth_Element (List, I);
         exit when El = Null_Iir; --exitchain:Ec
         Set_Col (Indent + Indentation);
         Disp_Identifier (El); -- f:n
         Put (" : ");
         Disp_Subtype_Indication (Get_Type (El));
         Put_Line (";");
      end loop;
      Set_Col (Indent);
      Put ("end record;");
   end Disp_Record_Type_Definition;

   procedure Disp_Designator_List (List: Iir_List) is
      El: Iir;
   begin
      if List = Null_Iir_List then
         return;
      end if;
      for I in Natural loop
         El := Get_Nth_Element (List, I);
         exit when El = Null_Iir;
         if I > 0 then
            Put (", ");
         end if;
         Disp_Expression (El);
         --Disp_Text_Literal (El);
      end loop;
   end Disp_Designator_List;

   -- Display the full definition of a type, ie the sequence that can create
   -- such a type.
   procedure Disp_Type_Definition (Decl: in Iir; Indent: Count) is
   begin
      case Get_Kind (Decl) is
         when Iir_Kind_Enumeration_Type_Definition =>
            Disp_Enumeration_Type_Definition (Decl);
         when Iir_Kind_Enumeration_Subtype_Definition =>
            Disp_Enumeration_Subtype_Definition (Decl);
         when Iir_Kind_Integer_Subtype_Definition =>
            Disp_Integer_Subtype_Definition (Decl);
         when Iir_Kind_Floating_Subtype_Definition =>
            Disp_Floating_Subtype_Definition (Decl);
         when Iir_Kind_Array_Type_Definition =>
            Disp_Array_Type_Definition (Decl);
         when Iir_Kind_Array_Subtype_Definition =>
            Disp_Array_Subtype_Definition (Decl);
         when Iir_Kind_Physical_Subtype_Definition =>
            Disp_Physical_Subtype_Definition (Decl, Indent);
         when Iir_Kind_Record_Type_Definition =>
            Disp_Record_Type_Definition (Decl, Indent);
         when Iir_Kind_Access_Type_Definition =>
            Put ("access"); --f:typ
            Disp_Subtype_Indication (Get_Designated_Type (Decl));
            Put (';');
         when Iir_Kind_File_Type_Definition =>
            Put ("file of ");
            Disp_Subtype_Indication (Get_Type_Mark (Decl));
            Put (';');
         when Iir_Kind_Protected_Type_Declaration =>
            Put_Line ("protected");
            Disp_Declaration_Chain (Decl, Indent + Indentation);
            Set_Col (Indent);
            Put ("end protected;");
         when Iir_Kind_Integer_Type_Definition =>
            Put ("<integer base type>");
         when Iir_Kind_Floating_Type_Definition =>
            Put ("<floating base type>");
         when Iir_Kind_Physical_Type_Definition =>
            Put ("<physical base type>");
         when others =>
            Error_Kind ("disp_type_definition", Decl);
      end case;
   end Disp_Type_Definition;

   procedure Disp_Type_Declaration (Decl: Iir_Type_Declaration)
   is
      Indent: Count;
      Def : Iir;
   begin
      Indent := Col;
      Put ("type ");
      Disp_Name_Of (Decl); -- f:n
      Def := Get_Type (Decl);
      if Def = Null_Iir
        or else Get_Kind (Def) = Iir_Kind_Incomplete_Type_Definition
      then
         Put_Line (";");
      else
         Put (" is ");
         Disp_Type_Definition (Def, Indent);
         New_Line;
      end if;
   end Disp_Type_Declaration;

   procedure Disp_Anonymous_Type_Declaration
     (Decl: Iir_Anonymous_Type_Declaration)
   is
      Indent: Count;
      Def : Iir;
      Ec : X;
   begin
      Indent := Col;
      Put ("-- type ");
      Disp_Name_Of (Decl); -- f:n
      Put (" is ");
      Def := Get_Type (Decl);
      Disp_Type_Definition (Def, Indent);
      if Get_Kind (Def) = Iir_Kind_Physical_Type_Definition then
         declare
            Unit : Iir_Unit_Declaration;
         begin
            Put_Line (" units");
            Set_Col (Indent);
            Put ("--   ");
            Unit := Get_Unit_Chain (Def);
            Disp_Identifier (Unit); -- f:nunit
            Put_Line (";");
            Unit := Get_Chain (Unit);
            while Unit /= Null_Iir loop -- chain:[v=Ec|n=unit]
               Set_Col (Indent);
               Put ("--   ");
               Disp_Identifier (Unit); -- f:n
               Put (" = ");
               Disp_Physical_Literal (Get_Physical_Literal (Unit));
               Put_Line (";");
               Unit := Get_Chain (Unit);
            end loop;
            Set_Col (Indent);
            Put ("-- end units;");
         end;
      end if;
      New_Line;
   end Disp_Anonymous_Type_Declaration;

   procedure Disp_Subtype_Declaration (Decl: in Iir_Subtype_Declaration) is
   begin
      Put ("subtype ");
      Disp_Name_Of (Decl); --f:n
      Put (" is ");
      Disp_Subtype_Indication (Get_Type (Decl), True);
      Put_Line (";");
   end Disp_Subtype_Declaration;

   procedure Disp_Type (A_Type: Iir)
   is
      Decl: Iir;
   begin
      Decl := Get_Type_Declarator (A_Type);
      if Decl /= Null_Iir then
         Disp_Name_Of (Decl); -- f:n
      else
         case Get_Kind (A_Type) is
            when Iir_Kind_Enumeration_Type_Definition
              | Iir_Kind_Integer_Type_Definition =>
               raise Program_Error;
            when Iir_Kind_Integer_Subtype_Definition
              | Iir_Kind_Enumeration_Subtype_Definition =>
               Disp_Subtype_Indication (A_Type);
            when Iir_Kind_Array_Subtype_Definition =>
               Disp_Subtype_Indication (A_Type);
            when others =>
               Error_Kind ("disp_type", A_Type);
         end case;
      end if;
   end Disp_Type;

   procedure Disp_Mode (Mode: Iir_Mode) is
   begin
      case Mode is
         when Iir_In_Mode =>
            Put ("in ");
         when Iir_Out_Mode =>
            Put ("out ");
         when Iir_Inout_Mode =>
            Put ("inout ");
         when Iir_Buffer_Mode =>
            Put ("buffer ");
         when Iir_Linkage_Mode =>
            Put ("linkage ");
         when Iir_Unknown_Mode =>
            Put ("<unknown> ");
      end case;
   end Disp_Mode;
   pragma Unreferenced (Disp_Mode);

   procedure Disp_Signal_Kind (Kind: Iir_Signal_Kind) is
   begin
      case Kind is
         when Iir_No_Signal_Kind =>
            null;
         when Iir_Register_Kind =>
            Put (" register");
         when Iir_Bus_Kind =>
            Put (" bus");
      end case;
   end Disp_Signal_Kind;
   pragma Unreferenced (Disp_Signal_Kind);

   procedure Disp_Interface_Declaration (Inter: Iir)
   is
      Default: Iir;
   begin
      case Get_Kind (Inter) is
         when Iir_Kind_Signal_Interface_Declaration =>
            Put ("signal ");
         when Iir_Kind_Variable_Interface_Declaration =>
            Put ("variable ");
         when Iir_Kind_Constant_Interface_Declaration =>
            Put ("constant ");
         when Iir_Kind_File_Interface_Declaration =>
            Put ("file ");
         when others =>
            Error_Kind ("disp_interface_declaration", Inter);
      end case;
      Disp_Name_Of (Inter); -- f:n
      Put (": ");
      Disp_Mode (Get_Mode (Inter)); --f:mode
      Disp_Type (Get_Type (Inter));
      if Get_Kind (Inter) = Iir_Kind_Signal_Interface_Declaration then
         Disp_Signal_Kind (Get_Signal_Kind (Inter)); -- f:sigkind
      end if;
      Default := Get_Default_Value (Inter);
      if Default /= Null_Iir then
         Put (" := ");
         Disp_Expression (Default);
      end if;
   end Disp_Interface_Declaration;

   procedure Disp_Interface_Chain (Chain: Iir; Str: String)
   is
      Inter: Iir;
      Start: Count;
      pragma Unreferenced (Start);
      pragma Unreferenced (Str);
   begin
      if Chain = Null_Iir then
         return;
      end if;
      Put (" (");
      Start := Col;
      Inter := Chain;
      while Inter /= Null_Iir loop
         Set_Col (Start);
         Disp_Interface_Declaration (Inter);
         if Get_Chain (Inter) /= Null_Iir then
            Put ("; ");
         else
            Put (')');
            Put (Str); -- nop:1
         end if;
         Inter := Get_Chain (Inter);
      end loop;
   end Disp_Interface_Chain;

   procedure Disp_Ports (Parent : Iir) is
   begin
      Put ("port");
      Disp_Interface_Chain (Get_Port_Chain (Parent), ";");
   end Disp_Ports;

   procedure Disp_Generics (Parent : Iir) is
   begin
      Put ("generic");
      Disp_Interface_Chain (Get_Generic_Chain (Parent), ";");
   end Disp_Generics;

   procedure Disp_Entity_Declaration (Decl: Iir_Entity_Declaration) is
      Start: Count;
   begin
      Start := Col;
      Put ("entity ");
      Disp_Name_Of (Decl); --f:n
      Put_Line (" is");
      if Get_Generic_Chain (Decl) /= Null_Iir then
         Set_Col (Start + Indentation);
         Disp_Generics (Decl);
      end if;
      if Get_Port_Chain (Decl) /= Null_Iir then
         Set_Col (Start + Indentation);
         Disp_Ports (Decl);
      end if;
      Disp_Declaration_Chain (Decl, Start + Indentation);
      if Get_Concurrent_Statement_Chain (Decl) /= Null_Iir then
         Set_Col (Start);
         Put_Line ("begin");
         Disp_Concurrent_Statement_Chain (Decl, Start + Indentation);
      end if;
      Set_Col (Start);
      Put_Line ("end entity;");
   end Disp_Entity_Declaration;

   procedure Disp_Component_Declaration (Decl: Iir_Component_Declaration)
   is
      Indent: Count;
      pragma Unreferenced (Indent);
   begin
      Indent := Col;
      Put ("component ");
      Disp_Name_Of (Decl); -- f:n
      if Get_Generic_Chain (Decl) /= Null_Iir then
         Set_Col (Indent + Indentation);
         Disp_Generics (Decl);
      end if;
      if Get_Port_Chain (Decl) /= Null_Iir then
         Set_Col (Indent + Indentation);
         Disp_Ports (Decl);
      end if;
      Set_Col (Indent);
      Put ("end component;");
   end Disp_Component_Declaration;

   procedure Disp_Concurrent_Statement_Chain (Parent : Iir; Indent : Count)
   is
      El: Iir;
      pragma Unreferenced (Indent);
   begin
      El := Get_Concurrent_Statement_Chain (Parent);
      while El /= Null_Iir loop
         Set_Col (Indent);
         Disp_Concurrent_Statement (El);
         El := Get_Chain (El);
      end loop;
   end Disp_Concurrent_Statement_Chain;

   procedure Disp_Architecture_Declaration (Arch: Iir_Architecture_Declaration)
   is
      Start: Count;
   begin
      Start := Col;
      Put ("architecture ");
      Disp_Name_Of (Arch); -- f:n
      Put (" of ");
      Disp_Name_Of (Get_Entity (Arch)); -- f:of
      Put_Line (" is");
      Disp_Declaration_Chain (Arch, Start + Indentation);
      Set_Col (Start);
      Put_Line ("begin");
      Disp_Concurrent_Statement_Chain (Arch, Start + Indentation);
      Set_Col (Start);
      Put_Line ("end;");
   end Disp_Architecture_Declaration;

   procedure Disp_Object_Alias_Declaration (Decl: Iir_Object_Alias_Declaration)
   is
   begin
      Put ("alias ");
      Disp_Name_Of (Decl); -- f:n
      Put (": ");
      Disp_Type (Get_Type (Decl));
      Put (" is ");
      Disp_Expression (Get_Name (Decl));
      Put_Line (";");
   end Disp_Object_Alias_Declaration;

   procedure Disp_Non_Object_Alias_Declaration
     (Decl: Iir_Non_Object_Alias_Declaration)
   is
   begin
      Put ("alias ");
      Disp_Function_Name (Decl); -- f:n
      Put (" is ");
      Disp_Name (Get_Name (Decl)); -- f:alias
      Put_Line (";");
   end Disp_Non_Object_Alias_Declaration;

   procedure Disp_File_Declaration (Decl: Iir_File_Declaration) is
      Expr: Iir;
   begin
      Put ("file ");
      Disp_Name_Of (Decl); -- f:n
      Put (": ");
      Disp_Type (Get_Type (Decl));
      if Vhdl_Std = Vhdl_87 then
         Put (" is ");
         Disp_Mode (Get_Mode (Decl)); --f:mode
         Disp_Expression (Get_File_Logical_Name (Decl));
      else
         Expr := Get_File_Open_Kind (Decl);
         if Expr /= Null_Iir then
            Put (" open ");
            Disp_Expression (Expr);
         end if;
         Expr := Get_File_Logical_Name (Decl);
         if Expr /= Null_Iir then
            Put (" is ");
            Disp_Expression (Expr);
         end if;
      end if;
      Put (';');
   end Disp_File_Declaration;

   procedure Disp_Object_Declaration (Decl: Iir) is
   begin
      case Get_Kind (Decl) is
         when Iir_Kind_Variable_Declaration =>
            if Get_Shared_Flag (Decl) then
               Put ("shared ");
            end if;
            Put ("variable "); --f:typ
         when Iir_Kind_Constant_Declaration =>
            Put ("constant "); --f:typ
         when Iir_Kind_Signal_Declaration =>
            Put ("signal "); --f:typ
         when Iir_Kind_Object_Alias_Declaration =>
            Disp_Object_Alias_Declaration (Decl); --s:[typ=alias]
            return;
         when Iir_Kind_File_Declaration =>
            Disp_File_Declaration (Decl); --s:[typ=file]
            return;
         when others =>
            raise Internal_Error;
      end case;
      Disp_Name_Of (Decl); -- f:n
      Put (": ");
      Disp_Type (Get_Type (Decl));
      if Get_Kind (Decl) = Iir_Kind_Signal_Declaration then
         Disp_Signal_Kind (Get_Signal_Kind (Decl));  -- f:sigkind
      end if;

      if Get_Default_Value (Decl) /= Null_Iir then
         Put (" := ");
         Disp_Expression (Get_Default_Value (Decl));
      end if;
      Put_Line (";");
   end Disp_Object_Declaration;

   procedure Disp_Subprogram_Declaration (Subprg: Iir) is
   begin
      case Get_Kind (Subprg) is
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            Put ("function "); --f:typ
            Disp_Function_Name (Subprg);  -- f:n
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            Put ("procedure "); --f:typ
            Disp_Identifier (Subprg);  -- f:n
         when others =>
            raise Internal_Error;
      end case;

      Disp_Interface_Chain (Get_Interface_Declaration_Chain (Subprg), "");

      case Get_Kind (Subprg) is
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            Put (" return ");
            Disp_Type (Get_Return_Type (Subprg)); --p:rtyp
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            null;
         when others =>
            raise Internal_Error;
      end case;
   end Disp_Subprogram_Declaration;

   procedure Disp_Subprogram_Body (Subprg : Iir)
   is
      Decl : Iir;
      Indent : Count;
   begin
      Decl := Get_Subprogram_Specification (Subprg);
      Indent := Col;
      if Get_Chain (Decl) /= Subprg then
         Disp_Subprogram_Declaration (Decl);
      end if;
      Put_Line ("is");
      Set_Col (Indent);
      Disp_Declaration_Chain (Subprg, Indent + Indentation); -- p:decl
      Set_Col (Indent);
      Put_Line ("begin");
      Set_Col (Indent + Indentation);
      Disp_Sequential_Statements (Get_Sequential_Statement_Chain (Subprg)); -- p:b
      Set_Col (Indent);
      Put_Line ("end;");
      New_Line;
   end Disp_Subprogram_Body;

   procedure Disp_Instantiation_List (Insts: Iir_List) is
      El : Iir;
      Ec : X;
   begin
      if Insts = Iir_List_All then
         Put ("all"); --f:typ
      elsif Insts = Iir_List_Others then
         Put ("others"); --f:typ
      else
         for I in Natural loop -- chain:[v=Ec|n=instantiation]
            El := Get_Nth_Element (Insts, I);
            exit when El = Null_Iir; --exitchain:Ec
            if I /= Natural'First then
               Put (", ");
            end if;
            Disp_Name_Of (El); --f:n
         end loop;
      end if;
   end Disp_Instantiation_List;

   procedure Disp_Configuration_Specification
     (Spec : Iir_Configuration_Specification)
   is
      Indent : Count;
   begin
      Indent := Col;
      Put ("for ");
      Disp_Instantiation_List (Get_Instantiation_List (Spec));
      Put (": ");
      Disp_Name_Of (Get_Component_Name (Spec)); -- f:n
      New_Line;
      Disp_Binding_Indication (Get_Binding_Indication (Spec),
                               Indent + Indentation);
      Put_Line (";");
   end Disp_Configuration_Specification;

   procedure Disp_Disconnection_Specification
     (Dis : Iir_Disconnection_Specification)
   is
   begin
      Put ("disconnect ");
      Disp_Instantiation_List (Get_Signal_List (Dis));
      Put (": ");
      Disp_Subtype_Indication (Get_Type (Dis));
      Put (" after ");
      Disp_Expression (Get_Expression (Dis));
      Put_Line (";");
   end Disp_Disconnection_Specification;

   procedure Disp_Attribute_Declaration (Attr : Iir_Attribute_Declaration)
   is
   begin
      Put ("attribute ");
      Disp_Identifier (Attr); -- f:n
      Put (": ");
      Disp_Type (Get_Type (Attr));
      Put_Line (";");
   end Disp_Attribute_Declaration;

   procedure Disp_Entity_Kind (Tok : Tokens.Token_Type) is
   begin
      Put (Tokens.Image (Tok));
   end Disp_Entity_Kind;
   pragma Unreferenced (Disp_Entity_Kind);
   procedure Disp_Entity_Name_List (List : Iir_List)
   is
      El : Iir;
      Ec : X;
   begin
      for I in Natural loop -- chain:[v=Ec|n=Name]
         El := Get_Nth_Element (List, I);
         exit when El = Null_Iir; --exitchain:Ec
         if I /= 0 then
            Put (", ");
         end if;
         Disp_Name_Of (El); -- f:n
      end loop;
   end Disp_Entity_Name_List;

   procedure Disp_Attribute_Specification (Attr : Iir_Attribute_Specification)
   is
   begin
      Put ("attribute ");
      Disp_Identifier (Get_Attribute_Designator (Attr)); -- f:n
      Put (" of ");
      Disp_Entity_Name_List (Get_Entity_Name_List (Attr));
      Put (": ");
      Disp_Entity_Kind (Get_Entity_Class (Attr)); --f:kind
      Put (" is ");
      Disp_Expression (Get_Expression (Attr));
      Put_Line (";");
   end Disp_Attribute_Specification;

   procedure Disp_Protected_Type_Body
     (Bod : Iir_Protected_Type_Body; Indent : Count)
   is
   begin
      Put ("type ");
      Disp_Identifier (Bod); -- f:n
      Put (" is protected body");
      New_Line;
      Disp_Declaration_Chain (Bod, Indent + Indentation);
      Set_Col (Indent);
      Put_Line ("end protected body;");
   end Disp_Protected_Type_Body;

   procedure Disp_Declaration_Chain (Parent : Iir; Indent: Count)
   is
      Decl: Iir;
   begin
      Decl := Get_Declaration_Chain (Parent);
      while Decl /= Null_Iir loop
         Set_Col (Indent);
         case Get_Kind (Decl) is
            when Iir_Kind_Type_Declaration =>
               Disp_Type_Declaration (Decl);
            when Iir_Kind_Anonymous_Type_Declaration =>
               Disp_Anonymous_Type_Declaration (Decl);
            when Iir_Kind_Subtype_Declaration =>
               Disp_Subtype_Declaration (Decl);
            when Iir_Kind_Use_Clause =>
               Disp_Use_Clause (Decl);
            when Iir_Kind_Component_Declaration =>
               Disp_Component_Declaration (Decl);
            when Iir_Kinds_Object_Declaration =>
               Disp_Object_Declaration (Decl);
            when Iir_Kind_Non_Object_Alias_Declaration =>
               Disp_Non_Object_Alias_Declaration (Decl);
            when Iir_Kind_Implicit_Function_Declaration
              | Iir_Kind_Implicit_Procedure_Declaration =>
               Disp_Subprogram_Declaration (Decl);
               Put_Line (";");
            when Iir_Kind_Function_Declaration
              | Iir_Kind_Procedure_Declaration =>
               Disp_Subprogram_Declaration (Decl);
               if Get_Subprogram_Body (Decl) = Null_Iir
                 or else Get_Subprogram_Body (Decl) /= Get_Chain (Decl)
               then
                  Put_Line (";");
               end if;
            when Iir_Kind_Function_Body
              | Iir_Kind_Procedure_Body =>
               Disp_Subprogram_Body (Decl);
            when Iir_Kind_Protected_Type_Body =>
               Disp_Protected_Type_Body (Decl, Indent);
            when Iir_Kind_Configuration_Specification =>
               Disp_Configuration_Specification (Decl);
            when Iir_Kind_Disconnection_Specification =>
               Disp_Disconnection_Specification (Decl);
            when Iir_Kind_Attribute_Declaration =>
               Disp_Attribute_Declaration (Decl);
            when Iir_Kind_Attribute_Specification =>
               Disp_Attribute_Specification (Decl);
            when Iir_Kinds_Signal_Attribute =>
               null;
            when others =>
               Error_Kind ("disp_declaration_chain", Decl);
         end case;
         Decl := Get_Chain (Decl);
      end loop;
   end Disp_Declaration_Chain;

   procedure Disp_Waveform (Chain : Iir_Waveform_Element)
   is
      We: Iir_Waveform_Element;
      Val : Iir;
      Ec : X;
   begin
      if Chain = Null_Iir then
         Put ("null after {disconnection_time}");
         return;
      end if;
      We := Chain;
      while We /= Null_Iir loop -- chain:[v=Ec|n=waveelem]
         if We /= Chain then
            Put (", ");
         end if;
         Val := Get_We_Value (We);
         Disp_Expression (Val);
         if Get_Time (We) /= Null_Iir then
            Put (" after "); -- f:at
            Disp_Expression (Get_Time (We));
         end if;
         We := Get_Chain (We);
      end loop;
   end Disp_Waveform;

   procedure Disp_Delay_Mechanism (Stmt: Iir) is
      Expr: Iir;
   begin
      case Get_Delay_Mechanism (Stmt) is
         when Iir_Transport_Delay =>
            Put ("transport ");
         when Iir_Inertial_Delay =>
            Expr := Get_Reject_Time_Expression (Stmt);
            if Expr /= Null_Iir then
               Put ("reject ");
               Disp_Expression (Expr);
               Put (" inertial ");
            end if;
      end case;
   end Disp_Delay_Mechanism;

   procedure Disp_Signal_Assignment (Stmt: Iir) is
   begin
      Disp_Expression (Get_Target (Stmt));
      Put (" <= ");
      Disp_Delay_Mechanism (Stmt);
      Disp_Waveform (Get_Waveform_Chain (Stmt));
      Put_Line (";");
   end Disp_Signal_Assignment;

   procedure Disp_Variable_Assignment (Stmt: Iir) is
   begin
      Disp_Expression (Get_Target (Stmt));
      Put (" := ");
      Disp_Expression (Get_Expression (Stmt));
      Put_Line (";");
   end Disp_Variable_Assignment;

   --  procedure Disp_Label (Label: Name_Id) is
   --  begin
   --     if Label /= Null_Identifier then
   --        Disp_Ident (Label);
   --        Put (": ");
   --     end if;
   --  end Disp_Label;

   procedure Disp_Concurrent_Selected_Signal_Assignment (Stmt: Iir)
   is
      Indent: Count;
      Assoc: Iir;
      Assoc_Chain : Iir;
      pragma Unreferenced (Indent);
   begin
      Indent := Col;
      Set_Col (Indent);
      Disp_Label ( (Stmt)); -- f:lab
      Put ("with ");
      Disp_Expression (Get_Expression (Stmt));
      Put (" select ");
      Disp_Expression (Get_Target (Stmt));
      Put (" <= ");
      if Get_Guard (Stmt) /= Null_Iir then
         Put ("guarded ");
      end if;
      Disp_Delay_Mechanism (Stmt);
      Assoc_Chain := Get_Selected_Waveform_Chain (Stmt);
      Assoc := Assoc_Chain;
      while Assoc /= Null_Iir loop
         if Assoc /= Assoc_Chain then
            Put_Line (",");
         end if;
         Set_Col (Indent + Indentation);
         Disp_Waveform (Get_Associated (Assoc));
         Put (" when ");
         Disp_Choice (Assoc);
      end loop;
      Put_Line (";");
   end Disp_Concurrent_Selected_Signal_Assignment;

   procedure Disp_Concurrent_Conditional_Signal_Assignment (Stmt: Iir)
   is
      Indent: Count;
      Cond_Wf : Iir_Conditional_Waveform;
      Expr : Iir;
      pragma Unreferenced (Indent);
   begin
      Disp_Label ( (Stmt)); -- f:lab
      Disp_Expression (Get_Target (Stmt));
      Put (" <= ");
      if Get_Guard (Stmt) /= Null_Iir then
         Put ("guarded ");
      end if;
      Disp_Delay_Mechanism (Stmt);
      Indent := Col;
      Set_Col (Indent);
      Cond_Wf := Get_Conditional_Waveform_Chain (Stmt);
      while Cond_Wf /= Null_Iir loop
         Disp_Waveform (Get_Waveform_Chain (Cond_Wf));
         Expr := Get_Condition (Cond_Wf);
         if Expr /= Null_Iir then
            Put (" when ");
            Disp_Expression (Expr);
            Put_Line (" else");
            Set_Col (Indent);
         end if;
         Cond_Wf := Get_Chain (Cond_Wf);
      end loop;

      Put_Line (";");
   end Disp_Concurrent_Conditional_Signal_Assignment;

   procedure Disp_Assertion_Statement (Stmt: Iir) is
      Start: Count;
      Expr: Iir;
      pragma Unreferenced (Start);
   begin
      Start := Col;
      if Get_Kind (Stmt) = Iir_Kind_Concurrent_Assertion_Statement then
         Disp_Label ( (Stmt)); -- f:lab
      end if;
      Put ("assert ");
      Disp_Expression (Get_Assertion_Condition (Stmt));
      Expr := Get_Report_Expression (Stmt);
      if Expr /= Null_Iir then
         Set_Col (Start + Indentation);
         Put ("report ");
         Disp_Expression (Expr);
      end if;
      Expr := Get_Severity_Expression (Stmt);
      if Expr /= Null_Iir then
         Set_Col (Start + Indentation);
         Put ("severity ");
         Disp_Expression (Expr);
      end if;
      Put_Line (";");
   end Disp_Assertion_Statement;

   procedure Disp_Report_Statement (Stmt: Iir)
   is
      Start: Count;
      Expr: Iir;
      pragma Unreferenced (Start);
   begin
      Start := Col;
      Put ("report ");
      Expr := Get_Report_Expression (Stmt);
      Disp_Expression (Expr);
      Expr := Get_Severity_Expression (Stmt);
      if Expr /= Null_Iir then
         Set_Col (Start + Indentation);
         Put ("severity ");
         Disp_Expression (Expr);
      end if;
      Put_Line (";");
   end Disp_Report_Statement;

   procedure Disp_Dyadic_Operator (Expr: Iir) is
   begin
      Put ("(");
      Disp_Expression (Get_Left (Expr));  -- p:l
      Put (' ' & Name_Table.Image (Iirs_Utils.Get_Operator_Name (Expr)) & ' '); -- f:op
      Disp_Expression (Get_Right (Expr)); -- p:r
      Put (")");
   end Disp_Dyadic_Operator;

   procedure Disp_Monadic_Operator (Expr: Iir) is
   begin
      Put (Name_Table.Image (Iirs_Utils.Get_Operator_Name (Expr))); -- f:op
      Put (" (");
      Disp_Expression (Get_Operand (Expr)); -- p:u
      Put (")");
   end Disp_Monadic_Operator;

   procedure Disp_Case_Statement (Stmt: Iir_Case_Statement)
   is
      Indent: Count;
      Assoc: Iir;
      Sel_Stmt : Iir;
      Ec : X;
      pragma Unreferenced (Indent);
   begin
      Indent := Col;
      Put ("case ");
      Disp_Expression (Get_Expression (Stmt)); -- p:e
      Put_Line (" is");
      Assoc := Get_Case_Statement_Alternative_Chain (Stmt);
      while Assoc /= Null_Iir loop -- chain:[v=Ec|n=Choice]
         Set_Col (Indent + Indentation);
         Put ("when ");
         Sel_Stmt := Get_Associated (Assoc);
         Disp_Choice (Assoc); -- p:v
         Put_Line (" =>");
         Set_Col (Indent + 2 * Indentation);
         Disp_Sequential_Statements (Sel_Stmt); -- p:b
      end loop;
      Set_Col (Indent);
      Put_Line ("end case;");
   end Disp_Case_Statement;

   procedure Disp_Wait_Statement (Stmt: Iir_Wait_Statement) is
      List: Iir_List;
      Expr: Iir;
   begin
      Put ("wait");
      List := Get_Sensitivity_List (Stmt);
      if List /= Null_Iir_List then
         Put (" on ");
         Disp_Designator_List (List);
      end if;
      Expr := Get_Condition_Clause (Stmt);
      if Expr /= Null_Iir then
         Put (" until ");
         Disp_Expression (Expr);
      end if;
      Expr := Get_Timeout_Clause (Stmt);
      if Expr /= Null_Iir then
         Put (" for ");
         Disp_Expression (Expr);
      end if;
      Put_Line (";");
   end Disp_Wait_Statement;

   procedure Disp_If_Statement (Stmt: Iir_If_Statement) is
      Clause: Iir;
      Expr: Iir;
      Start: Count;
      Ec : X;
      pragma Unreferenced (Start);
   begin
      Start := Col; -- open:[v=Ec|n=clause]
      Put ("if "); -- f:ctyp
      Clause := Stmt;
      Disp_Expression (Get_Condition (Clause)); -- p:e
      Put_Line (" then");
      while Clause /= Null_Iir loop -- none
         Set_Col (Start + Indentation);
         Disp_Sequential_Statements (Get_Sequential_Statement_Chain (Clause)); -- p:b
         Clause := Get_Else_Clause (Clause);
         exit when Clause = Null_Iir;
         Expr := Get_Condition (Clause); -- reopen:[v=Ec|n=clause]
         Set_Col (Start);
         if Expr /= Null_Iir then
            Put ("elsif "); -- f:ctyp
            Disp_Expression (Expr); -- p:e
            Put_Line (" then");
         else
            Put_Line ("else"); -- f:ctyp
         end if;
      end loop;
      Set_Col (Start); --close:clause
      Put_Line ("end if;");
   end Disp_If_Statement;

   procedure Disp_Iterator (Iterator: Iir) is
   begin
      Disp_Subtype_Indication (Iterator);
   end Disp_Iterator;

   procedure Disp_Parameter_Specification
     (Iterator : Iir_Iterator_Declaration) is
   begin
      Disp_Identifier (Iterator); -- f:n
      Put (" in ");
      Disp_Iterator (Get_Type (Iterator));
   end Disp_Parameter_Specification;

   procedure Disp_Procedure_Call (Call : Iir)
   is
      Obj : Iir;
   begin
      Obj := Get_Method_Object (Call);
      if Obj /= Null_Iir then
         Disp_Name (Obj); -- f:obj
         Put ('.');
      end if;
      Disp_Identifier (Get_Implementation (Call)); -- f:n
      Put (' ');
      Disp_Association_Chain (Get_Parameter_Association_Chain (Call));
      Put_Line (";");
   end Disp_Procedure_Call;

   procedure Disp_Sequential_Statements (First : Iir)
   is
      Stmt: Iir;
      Start: Count;
      Ec : X;
      pragma Unreferenced (Start);
   begin
      Start := Col;
      Stmt := First;
      while Stmt /= Null_Iir loop
         Set_Col (Start);
         case Get_Kind (Stmt) is
            when Iir_Kind_Null_Statement =>
               Put_Line ("null;");
            when Iir_Kind_If_Statement =>
               Disp_If_Statement (Stmt);
            when Iir_Kind_For_Loop_Statement =>
               Put ("for "); -- open:[v=Ec|n=loop],f:typ
               Disp_Parameter_Specification(Get_Iterator_Scheme(Stmt));--p:param
               Put_Line (" loop");
               Set_Col (Start + Indentation);
               Disp_Sequential_Statements(Get_Sequential_Statement_Chain (Stmt));
               Set_Col (Start);
               Put_Line ("end loop;"); --close:loop
            when Iir_Kind_While_Loop_Statement =>
               Put ("while"); -- open:[v=Ec|n=while],f:typ
               if Get_Condition (Stmt) /= Null_Iir then
                  Put ("while ");
                  Disp_Expression (Get_Condition (Stmt)); -- p:param
                  Put (" ");
               end if;
               Put_Line ("loop");
               Set_Col (Start + Indentation);
               Disp_Sequential_Statements(Get_Sequential_Statement_Chain (Stmt));
               Set_Col (Start);
               Put_Line ("end loop;"); --close:while
            when Iir_Kind_Signal_Assignment_Statement =>
               Disp_Signal_Assignment (Stmt);
            when Iir_Kind_Variable_Assignment_Statement =>
               Disp_Variable_Assignment (Stmt);
            when Iir_Kind_Assertion_Statement =>
               Disp_Assertion_Statement (Stmt);
            when Iir_Kind_Report_Statement =>
               Disp_Report_Statement (Stmt);
            when Iir_Kind_Return_Statement =>
               if Get_Expression (Stmt) /= Null_Iir then-- open:[v=Ec|n=return]
                  Put ("return ");
                  Disp_Expression (Get_Expression (Stmt));
                  Put_Line (";");
               else
                  Put_Line ("return;");
               end if; --close:loop
            when Iir_Kind_Case_Statement =>
               Disp_Case_Statement (Stmt);
            when Iir_Kind_Wait_Statement =>
               Disp_Wait_Statement (Stmt);
            when Iir_Kind_Procedure_Call_Statement =>
               Disp_Procedure_Call (Get_Procedure_Call (Stmt));
            when Iir_Kind_Exit_Statement
              | Iir_Kind_Next_Statement =>
               if Get_Kind (Stmt) = Iir_Kind_Exit_Statement then
                  Put ("exit"); -- open:[v=Ec|n=break],f:typ
               else
                  Put ("next"); -- open:[v=Ec|n=break],f:typ
               end if;
               -- FIXME: label.
               if Get_Condition (Stmt) /= Null_Iir then
                  Put (" when ");
                  Disp_Expression (Get_Condition (Stmt));
               end if;
               Put_Line (";"); --close:loop

            when others =>
               Error_Kind ("disp_sequential_statements", Stmt);
         end case;
         Stmt := Get_Chain (Stmt);
      end loop;
   end Disp_Sequential_Statements;

   procedure Disp_Process_Statement (Process: Iir)
   is
      Start: Count;
   begin
      Start := Col;
      Disp_Label ( (Process)); -- f:lab

      Put ("process ");
      if Get_Kind (Process) = Iir_Kind_Sensitized_Process_Statement then
         Put ("(");
         Disp_Designator_List (Get_Sensitivity_List (Process));
         Put (")");
      end if;
      if Vhdl_Std >= Vhdl_93 then
         Put_Line (" is");
      else
         New_Line;
      end if;
      Disp_Declaration_Chain (Process, Start + Indentation);
      Set_Col (Start);
      Put_Line ("begin");
      Set_Col (Start + Indentation);
      Disp_Sequential_Statements (Get_Sequential_Statement_Chain (Process));
      Set_Col (Start);
      Put_Line ("end process;");
   end Disp_Process_Statement;

   procedure Disp_Association_Chain (Chain : Iir)
   is
      El: Iir;
      Formal: Iir;
      Need_Comma : Boolean;
      Conv : Iir;
      Ec : X;
   begin
      if Chain = Null_Iir then
         return;
      end if;
      Put ("(");
      Need_Comma := False;

      El := Chain;
      while El /= Null_Iir loop -- chain:[v=Ec|n=Association]
         if Get_Kind (El) /= Iir_Kind_Association_Element_By_Individual then
            if Need_Comma then
               Put (", ");
            end if;
            if Get_Kind (El) = Iir_Kind_Association_Element_By_Expression then
               Conv := Get_Out_Conversion (El);
               if Conv /= Null_Iir then
                  Disp_Function_Name (Conv); -- f:from
                  Put (" (");
               end if;
            else
               Conv := Null_Iir;
            end if;
            Formal := Get_Formal (El);
            if Formal /= Null_Iir then
               Disp_Expression (Formal);
               if Conv /= Null_Iir then
                  Put (")");
               end if;
               Put (" => ");
            end if;
            if Get_Kind (El) = Iir_Kind_Association_Element_Open then
               Put ("open");
            else
               Conv := Get_In_Conversion (El);
               if Conv /= Null_Iir then
                  Disp_Function_Name (Conv); -- f:to
                  Put (" (");
               end if;
               Disp_Expression (Get_Actual (El));
               if Conv /= Null_Iir then
                  Put (")");
               end if;
            end if;
            Need_Comma := True;
         end if;
         El := Get_Chain (El);
      end loop;
      Put (")");
   end Disp_Association_Chain;

   procedure Disp_Generic_Map_Aspect (Parent : Iir) is
   begin
      Put ("generic map ");
      Disp_Association_Chain (Get_Generic_Map_Aspect_Chain (Parent));
   end Disp_Generic_Map_Aspect;

   procedure Disp_Port_Map_Aspect (Parent : Iir) is
   begin
      Put ("port map ");
      Disp_Association_Chain (Get_Port_Map_Aspect_Chain (Parent));
   end Disp_Port_Map_Aspect;

   procedure Disp_Entity_Aspect (Aspect : Iir) is
      Arch : Iir;
   begin
      case Get_Kind (Aspect) is -- rename:Aspect,flags:[typ=aspect]
         when Iir_Kind_Entity_Aspect_Entity =>
            Put ("entity ");
            Disp_Name_Of (Get_Entity (Aspect)); -- f:n
            Arch := Get_Architecture (Aspect);
            if Arch /= Null_Iir then
               Put (" (");
               Disp_Name_Of (Arch); -- f:arch
               Put (")");
            end if;
         when Iir_Kind_Entity_Aspect_Configuration =>
            Put ("configuration ");
            Disp_Name_Of (Get_Configuration (Aspect)); -- f:n
         when Iir_Kind_Entity_Aspect_Open =>
            Put ("open");
         when others =>
            Error_Kind ("disp_entity_aspect", Aspect);
      end case;
   end Disp_Entity_Aspect;

   procedure Disp_Component_Instantiation_Statement
     (Stmt: Iir_Component_Instantiation_Statement)
   is
      Component: Iir;
      Alist: Iir;
   begin
      Disp_Label ( (Stmt)); -- f:lab
      Component := Get_Instantiated_Unit (Stmt);
      if Get_Kind (Component) = Iir_Kind_Component_Declaration then
         Disp_Name_Of (Component); -- f:n
      else
         Disp_Entity_Aspect (Component);
      end if;
      Alist := Get_Generic_Map_Aspect_Chain (Stmt);
      if Alist /= Null_Iir then
         Put (" ");
         Disp_Generic_Map_Aspect (Stmt);
      end if;
      Alist := Get_Port_Map_Aspect_Chain (Stmt);
      if Alist /= Null_Iir then
         Put (" ");
         Disp_Port_Map_Aspect (Stmt);
      end if;
      Put (";");
   end Disp_Component_Instantiation_Statement;

   procedure Disp_Function_Call (Expr: Iir_Function_Call) is
   begin
      Disp_Function_Name (Get_Implementation (Expr)); -- f:n
      Disp_Association_Chain (Get_Parameter_Association_Chain (Expr));
   end Disp_Function_Call;

   procedure Disp_Indexed_Name (Indexed: Iir)
   is
      List : Iir_List;
      El: Iir;
      Ec : X;
   begin
      Disp_Expression (Get_Prefix (Indexed));
      Put (" (");
      List := Get_Index_List (Indexed);
      for I in Natural loop -- chain:[v=Ec|n=Name]
         El := Get_Nth_Element (List, I);
         exit when El = Null_Iir; --exitchain:Ec
         if I /= 0 then
            Put (", ");
         end if;
         Disp_Expression (El);
      end loop;
      Put (")");
   end Disp_Indexed_Name;

   procedure Disp_Choice (Choice: in out Iir) is
      Ec : X;
   begin
      loop -- chain:[v=Ec|n=Choice]
         case Get_Kind (Choice) is
            when Iir_Kind_Choice_By_Others =>
               Put ("others"); -- f:val
            when Iir_Kind_Choice_By_None =>
               null;
            when Iir_Kind_Choice_By_Expression =>
               Disp_Expression (Get_Expression (Choice));
            when Iir_Kind_Choice_By_Range =>
               Disp_Range (Get_Expression (Choice));
            when Iir_Kind_Choice_By_Name =>
               Disp_Name_Of (Get_Name (Choice)); -- f:val
            when others =>
               Error_Kind ("disp_choice", Choice);
         end case;
         Choice := Get_Chain (Choice);
         exit when Choice = Null_Iir;
         exit when Get_Same_Alternative_Flag (Choice) = False;
         --exit when Choice = Null_Iir;
         Put (" | ");
      end loop;
   end Disp_Choice;

   procedure Disp_Aggregate (Aggr: Iir_Aggregate)
   is
      Indent: Count;
      Assoc: Iir;
      Expr : Iir;
      Ec : X;
      pragma Unreferenced (Indent);
   begin
      Put ("(");
      Indent := Col;
      Assoc := Get_Association_Choices_Chain (Aggr);
      loop -- chain:[v=Ec|n=AggE]
         Expr := Get_Associated (Assoc);
         if Get_Kind (Assoc) /= Iir_Kind_Choice_By_None then
            Disp_Choice (Assoc);
            Put (" => ");
         else
            Assoc := Get_Chain (Assoc);
         end if;
         if Get_Kind (Expr) = Iir_Kind_Aggregate
           or else Get_Kind (Expr) = Iir_Kind_String_Literal then
            Set_Col (Indent);
         end if;
         Disp_Expression (Expr);
         exit when Assoc = Null_Iir;
         Put (", ");
      end loop;
      Put (")");
   end Disp_Aggregate;

   procedure Disp_Simple_Aggregate (Aggr: Iir_Simple_Aggregate)
   is
      List : Iir_List;
      El : Iir;
      First : Boolean := True;
      Ec : X;
   begin
      Put ("(");
      List := Get_Simple_Aggregate_List (Aggr);
      for I in Natural loop -- chain:[v=Ec|n=AggE]
         El := Get_Nth_Element (List, I);
         exit when El = Null_Iir; --exitchain:Ec
         if First then
            First := False;
         else
            Put (", ");
         end if;
         Disp_Expression (El);
      end loop;
      Put (")");
   end Disp_Simple_Aggregate;

   procedure Disp_Parametered_Attribute (Name : String; Expr : Iir)
   is
      Param : Iir;
      Pfx : Iir;
   begin
      Pfx := Get_Prefix (Expr);
      case Get_Kind (Pfx) is
         when Iir_Kind_Type_Declaration
           | Iir_Kind_Subtype_Declaration =>
            Disp_Name_Of (Pfx); -- f:n
         when others =>
            Disp_Expression (Pfx);
      end case;
      Put ("'");
      Put (Name); -- f:attribute
      Param := Get_Parameter (Expr);
      if Param /= Null_Iir then
         Put (" (");
         Disp_Expression (Param);
         Put (")");
      end if;
   end Disp_Parametered_Attribute;

   procedure Disp_String_Literal (Str : Iir)
   is
      Ptr : String_Fat_Acc;
      Len : Int32;
   begin
      Ptr := Get_String_Fat_Acc (Str);
      Len := Get_String_Length (Str);
      Put (String (Ptr (1 .. Len)));
   end Disp_String_Literal;
   pragma Unreferenced (Disp_String_Literal);

   procedure Disp_Expression (Expr: Iir)
   is
      Orig : Iir;
   begin
      case Get_Kind (Expr) is -- rename:Expr,flags:[typ=expr]
         when Iir_Kind_Integer_Literal =>
            Orig := Get_Literal_Origin (Expr);
            if Orig /= Null_Iir then
               Disp_Expression (Orig); --reent:1
            else
               Disp_Int64 (Get_Value (Expr)); -- f:val
            end if;
         when Iir_Kind_Floating_Point_Literal =>
            Orig := Get_Literal_Origin (Expr);
            if Orig /= Null_Iir then
               Disp_Expression (Orig); --reent:1
            else
               Disp_Fp64 (Get_Fp_Value (Expr)); -- f:val
            end if;
         when Iir_Kind_String_Literal =>
            Put (""""); -- nop:1
            Disp_String_Literal (Expr); -- f:val
            Put (""""); -- nop:1
            if Disp_String_Literal_Type or Flags.List_Verbose then
               Put ("[type: ");
               Disp_Type (Get_Type (Expr));
               Put ("]");
            end if;
         when Iir_Kind_Bit_String_Literal =>
            if False then
               case Get_Bit_String_Base (Expr) is
                  when Base_2 =>
                     Put ('B');
                  when Base_8 =>
                     Put ('O');
                  when Base_16 =>
                     Put ('X');
               end case;
            end if;
            Put ("B"""); -- nop:1
            Disp_String_Literal (Expr); -- f:val
            Put (""""); -- nop:1
         when Iir_Kind_Physical_Fp_Literal
           | Iir_Kind_Physical_Int_Literal =>
            Orig := Get_Literal_Origin (Expr);
            if Orig /= Null_Iir then
               Disp_Expression (Orig);
            else
               Disp_Physical_Literal (Expr); -- f:val
            end if;
         when Iir_Kind_Unit_Declaration =>
            Disp_Name_Of (Expr); -- f:val
         when Iir_Kind_Enumeration_Literal =>
            Disp_Name_Of (Expr); -- f:val
         when Iir_Kind_Object_Alias_Declaration =>
            Disp_Name_Of (Expr); -- f:val
         when Iir_Kind_Aggregate =>
            Disp_Aggregate (Expr); --reent:1
         when Iir_Kind_Null_Literal =>
            Put ("null");
         when Iir_Kind_Simple_Aggregate =>
            Disp_Simple_Aggregate (Expr); --reent:1

         when Iir_Kind_Element_Declaration =>
            Disp_Name_Of (Expr); -- f:val

         when Iir_Kind_Signal_Interface_Declaration
           | Iir_Kind_Signal_Declaration
           | Iir_Kind_Guard_Signal_Declaration
           | Iir_Kind_Variable_Declaration
           | Iir_Kind_Variable_Interface_Declaration
           | Iir_Kind_Constant_Declaration
           | Iir_Kind_Constant_Interface_Declaration
           | Iir_Kind_File_Declaration
           | Iir_Kind_File_Interface_Declaration
           | Iir_Kind_Iterator_Declaration =>
            Disp_Name_Of (Expr); -- f:val
            return;

         when Iir_Kind_Simple_Name =>
            Disp_Name (Expr); -- f:val

         when Iir_Kinds_Dyadic_Operator =>
            Disp_Dyadic_Operator (Expr); --reent:1
         when Iir_Kinds_Monadic_Operator =>
            Disp_Monadic_Operator (Expr); --reent:1
         when Iir_Kind_Function_Call =>
            Disp_Function_Call (Expr); --reent:1
         when Iir_Kind_Type_Conversion =>
            Disp_Type (Get_Type (Expr));
            Put (" (");
            Disp_Expression (Get_Expression (Expr));
            Put (")");
         when Iir_Kind_Qualified_Expression =>
            Disp_Type (Get_Type_Mark (Expr));
            Put ("'(");
            Disp_Expression (Get_Expression (Expr));
            Put (")");
         when Iir_Kind_Allocator_By_Expression =>
            Put ("new ");
            Disp_Expression (Get_Expression (Expr));
         when Iir_Kind_Allocator_By_Subtype =>
            Put ("new ");
            Disp_Subtype_Indication (Get_Expression (Expr));

         when Iir_Kind_Indexed_Name =>
            Disp_Indexed_Name (Expr); --reent:1
         when Iir_Kind_Slice_Name =>
            Disp_Expression (Get_Prefix (Expr));
            Put (" (");
            Disp_Range (Get_Suffix (Expr));
            Put (")");
         when Iir_Kind_Selected_Element =>
            Disp_Expression (Get_Prefix (Expr));
            Put (".");
            Disp_Name_Of (Get_Selected_Element (Expr)); -- f:elem
         when Iir_Kind_Implicit_Dereference =>
            Disp_Expression (Get_Prefix (Expr));
         when Iir_Kind_Dereference =>
            Disp_Expression (Get_Prefix (Expr));
            Put (".all");

         when Iir_Kind_Left_Type_Attribute =>
            Put ("'left");-- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Right_Type_Attribute =>
            Put ("'right");-- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_High_Type_Attribute =>
            Put ("'high");-- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Low_Type_Attribute =>
            Put ("'low");-- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1

         when Iir_Kind_Stable_Attribute =>
            Disp_Parametered_Attribute ("stable", Expr); --reent:1
         when Iir_Kind_Delayed_Attribute =>
            Disp_Parametered_Attribute ("delayed", Expr); --reent:1
         when Iir_Kind_Transaction_Attribute =>
            Put ("'transaction"); -- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Event_Attribute =>
            Put ("'event"); -- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Active_Attribute =>
            Put ("'active"); -- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Last_Value_Attribute =>
            Put ("'last_value"); -- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Last_Event_Attribute =>
            Put ("'last_event"); -- f:attribute
            Disp_Expression (Get_Prefix (Expr)); --reent:1

         when Iir_Kind_Pos_Attribute =>
            Disp_Parametered_Attribute ("pos", Expr); --reent:1
         when Iir_Kind_Val_Attribute =>
            Disp_Parametered_Attribute ("val", Expr); --reent:1
         when Iir_Kind_Succ_Attribute =>
            Disp_Parametered_Attribute ("succ", Expr); --reent:1
         when Iir_Kind_Pred_Attribute =>
            Disp_Parametered_Attribute ("pred", Expr); --reent:1

         when Iir_Kind_Length_Array_Attribute =>
            Disp_Parametered_Attribute ("length", Expr); --reent:1
         when Iir_Kind_Range_Array_Attribute =>
            Disp_Parametered_Attribute ("range", Expr); --reent:1
         when Iir_Kind_Reverse_Range_Array_Attribute =>
            Disp_Parametered_Attribute ("reverse_range", Expr); --reent:1
         when Iir_Kind_Left_Array_Attribute =>
            Disp_Parametered_Attribute ("left", Expr); --reent:1
         when Iir_Kind_Right_Array_Attribute =>
            Disp_Parametered_Attribute ("right", Expr); --reent:1
         when Iir_Kind_Low_Array_Attribute =>
            Disp_Parametered_Attribute ("low", Expr); --reent:1
         when Iir_Kind_High_Array_Attribute =>
            Disp_Parametered_Attribute ("high", Expr); --reent:1
         when Iir_Kind_Ascending_Array_Attribute =>
            Disp_Parametered_Attribute ("ascending", Expr); --reent:1

         when Iir_Kind_Image_Attribute =>
            Disp_Parametered_Attribute ("image", Expr); --reent:1
         when Iir_Kind_Simple_Name_Attribute =>
            Disp_Name_Of (Get_Prefix (Expr)); -- f:n
            Put ("'simple_name"); -- f:attribute
         when Iir_Kind_Instance_Name_Attribute =>
            Disp_Name_Of (Get_Prefix (Expr)); -- f:n
            Put ("'instance_name"); -- f:attribute
         when Iir_Kind_Path_Name_Attribute =>
            Disp_Name_Of (Get_Prefix (Expr)); -- f:n
            Put ("'path_name"); -- f:attribute

         when Iir_Kind_Selected_By_All_Name =>
            Disp_Expression (Get_Prefix (Expr));
            Put ("");
            return;
         when Iir_Kind_Selected_Name =>
            Disp_Expression (Get_Named_Entity (Expr)); --reent:1

         when Iir_Kinds_Type_And_Subtype_Definition =>
            Disp_Type (Expr); --reent:1

         when Iir_Kind_Proxy =>
            Disp_Expression (Get_Proxy (Expr));

         when Iir_Kind_Range_Expression =>
            Disp_Range (Expr); --reent:1
         when Iir_Kind_Subtype_Declaration =>
            Disp_Name_Of (Expr); -- f:n

         when others =>
            Error_Kind ("disp_expression", Expr);
      end case;
   end Disp_Expression;

   --  procedure Disp_PSL_HDL_Expr
   -- (NPSL : PSL.Nodes.HDL_Node) is
   --  begin
   --     Disp_Expression (Iir (NPSL));
   --  end Disp_PSL_HDL_Expr;

   procedure Disp_Psl_Expression (Expr : PSL_Node) is
      pragma Unreferenced (Expr);
   begin
      Put_Line("Error Psl not supported\n");
      --PSL.Prints.HDL_Expr_Printer := Disp_PSL_HDL_Expr'Access;
      --PSL.Prints.Print_Property (Expr);
   end Disp_Psl_Expression;

   procedure Disp_Block_Header (Header : Iir_Block_Header; Indent: Count)
   is
      Chain : Iir;
      pragma Unreferenced (Indent);
   begin
      if Header = Null_Iir then
         return;
      end if;
      Chain := Get_Generic_Chain (Header);
      if Chain /= Null_Iir then
         Set_Col (Indent + Indentation);
         Disp_Generics (Header);
         Chain := Get_Generic_Map_Aspect_Chain (Header);
         if Chain /= Null_Iir then
            Set_Col (Indent + Indentation);
            Disp_Generic_Map_Aspect (Header);
            Put_Line (";");
         end if;
      end if;
      Chain := Get_Port_Chain (Header);
      if Chain /= Null_Iir then
         Set_Col (Indent + Indentation);
         Disp_Ports (Header);
         Chain := Get_Port_Map_Aspect_Chain (Header);
         if Chain /= Null_Iir then
            Set_Col (Indent + Indentation);
            Disp_Port_Map_Aspect (Header);
            Put_Line (";");
         end if;
      end if;
   end Disp_Block_Header;

   procedure Disp_Block_Statement (Block: Iir_Block_Statement)
   is
      Indent: Count;
      Sensitivity: Iir_List;
      Guard : Iir_Guard_Signal_Declaration;
   begin
      Indent := Col;
      Disp_Label ( (Block)); -- f:lab
      Put ("block");
      Guard := Get_Guard_Decl (Block);
      if Guard /= Null_Iir then
         Put (" (");
         Disp_Expression (Get_Guard_Expression (Guard));
         Put_Line (")");
         Sensitivity := Get_Guard_Sensitivity_List (Guard);
         if Sensitivity /= Null_Iir_List then
            Set_Col (Indent + Indentation);
            Put ("-- guard sensitivity list ");
            Disp_Designator_List (Sensitivity);
         end if;
      else
         New_Line;
      end if;
      Disp_Block_Header (Get_Block_Header (Block),
                         Indent + Indentation);
      Disp_Declaration_Chain (Block, Indent + Indentation);
      Set_Col (Indent);
      Put_Line ("begin");
      Disp_Concurrent_Statement_Chain (Block, Indent + Indentation);
      Set_Col (Indent);
      Put_Line ("end;");
   end Disp_Block_Statement;

   procedure Disp_Generate_Statement (Stmt : Iir_Generate_Statement)
   is
      Indent : Count;
      Scheme : Iir;
   begin
      Indent := Col;
      Disp_Label ( (Stmt)); -- f:lab
      Scheme := Get_Generation_Scheme (Stmt);
      case Get_Kind (Scheme) is
         when Iir_Kind_Iterator_Declaration =>
            Put ("for ");
            Disp_Parameter_Specification (Scheme);
         when others =>
            Put ("if ");
            Disp_Expression (Scheme);
      end case;
      Put_Line (" generate");
      Disp_Declaration_Chain (Stmt, Indent);
      Set_Col (Indent);
      Put_Line ("begin");
      Disp_Concurrent_Statement_Chain (Stmt, Indent + Indentation);
      Set_Col (Indent);
      Put_Line ("end generate;");
   end Disp_Generate_Statement;

   procedure Disp_Psl_Default_Clock (Stmt : Iir) is
   begin
      Put ("--psl default clock is ");
      Disp_Psl_Expression (Get_Psl_Boolean (Stmt));
      Put_Line (";");
   end Disp_Psl_Default_Clock;

   procedure Disp_Psl_Assert_Statement (Stmt : Iir)
   is
      use PSL.NFAs;
      use PSL.Nodes;

      procedure Disp_State (S : NFA_State) is
         Str : constant String := Int32'Image (Get_State_Label (S));
      begin
         Put (Str (2 .. Str'Last));
      end Disp_State;

      NPSL : NFA;
      S : NFA_State;
      E : NFA_Edge;
   begin
      Put ("--psl assert ");
      Disp_Psl_Expression (Get_Psl_Property (Stmt));
      Put_Line (";");
      NPSL := Get_PSL_NFA (Stmt);
      if True and then NPSL /= No_NFA then
         S := Get_First_State (NPSL);
         while S /= No_State loop
            E := Get_First_Src_Edge (S);
            while E /= No_Edge loop
               Put ("-- ");
               Disp_State (S);
               Put (" -> ");
               Disp_State (Get_Edge_Dest (E));
               Put (": ");
               Disp_Psl_Expression (Get_Edge_Expr (E));
               New_Line;
               E := Get_Next_Src_Edge (E);
            end loop;
            S := Get_Next_State (S);
         end loop;
      end if;
   end Disp_Psl_Assert_Statement;

   procedure Disp_Concurrent_Statement (Stmt: Iir) is
   begin
      case Get_Kind (Stmt) is -- rename:Stmt,flags:[typ=concur]
         when Iir_Kind_Concurrent_Conditional_Signal_Assignment =>
            Disp_Concurrent_Conditional_Signal_Assignment (Stmt);-- reent:1
         when Iir_Kind_Concurrent_Selected_Signal_Assignment =>
            Disp_Concurrent_Selected_Signal_Assignment (Stmt);-- reent:1
         when Iir_Kind_Sensitized_Process_Statement
           | Iir_Kind_Process_Statement =>
            Disp_Process_Statement (Stmt);
         when Iir_Kind_Concurrent_Assertion_Statement =>
            Disp_Assertion_Statement (Stmt);
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Component_Instantiation_Statement (Stmt); -- reent:1
         when Iir_Kind_Concurrent_Procedure_Call_Statement =>
            Disp_Procedure_Call (Get_Procedure_Call (Stmt));
         when Iir_Kind_Block_Statement =>
            Disp_Block_Statement (Stmt);
         when Iir_Kind_Generate_Statement =>
            Disp_Generate_Statement (Stmt);-- reent:1
         when Iir_Kind_Psl_Default_Clock =>
            Disp_Psl_Default_Clock (Stmt);
         when Iir_Kind_Psl_Assert_Statement =>
            Disp_Psl_Assert_Statement (Stmt);
         when others =>
            Error_Kind ("disp_concurrent_statement", Stmt);
      end case;
   end Disp_Concurrent_Statement;

   procedure Disp_Package_Declaration (Decl: Iir_Package_Declaration) is
   begin
      Put ("package ");
      Disp_Identifier (Decl); -- f:n
      Put_Line (" is");
      Disp_Declaration_Chain (Decl, Col + Indentation);
      Put_Line ("end;");
   end Disp_Package_Declaration;

   procedure Disp_Package_Body (Decl: Iir)
   is
   begin
      Put ("package body ");
      Disp_Identifier (Decl); -- f:n
      Put_Line (" is");
      Disp_Declaration_Chain (Decl, Col + Indentation);
      Put_Line ("end;");
   end Disp_Package_Body;

   procedure Disp_Binding_Indication (Bind : Iir; Indent : Count)
   is
      El : Iir;
      pragma Unreferenced (Indent);
   begin
      El := Get_Entity_Aspect (Bind);
      if El /= Null_Iir then
         Set_Col (Indent);
         Put ("use ");
         Disp_Entity_Aspect (El);
      end if;
      El := Get_Generic_Map_Aspect_Chain (Bind);
      if El /= Null_Iir then
         Set_Col (Indent);
         Disp_Generic_Map_Aspect (Bind);
      end if;
      El := Get_Port_Map_Aspect_Chain (Bind);
      if El /= Null_Iir then
         Set_Col (Indent);
         Disp_Port_Map_Aspect (Bind);
      end if;
   end Disp_Binding_Indication;

   procedure Disp_Component_Configuration
     (Conf : Iir_Component_Configuration; Indent : Count)
   is
      Block : Iir_Block_Configuration;
      Binding : Iir;
   begin
      Set_Col (Indent);
      Put ("for ");
      Disp_Instantiation_List (Get_Instantiation_List (Conf));
      Put(" : ");
      Disp_Name_Of (Get_Component_Name (Conf)); -- f:n
      New_Line;
      Binding := Get_Binding_Indication (Conf);
      if Binding /= Null_Iir then
         Disp_Binding_Indication (Binding, Indent + Indentation);
      end if;
      Block := Get_Block_Configuration (Conf);
      if Block /= Null_Iir then
         Disp_Block_Configuration (Block, Indent + Indentation);
      end if;
      Set_Col (Indent);
      Put_Line ("end for;");
   end Disp_Component_Configuration;

   procedure Disp_Configuration_Items
     (Conf : Iir_Block_Configuration; Indent : Count)
   is
      El : Iir;
   begin
      El := Get_Configuration_Item_Chain (Conf);
      while El /= Null_Iir loop
         case Get_Kind (El) is
            when Iir_Kind_Block_Configuration =>
               Disp_Block_Configuration (El, Indent);
            when Iir_Kind_Component_Configuration =>
               Disp_Component_Configuration (El, Indent);
            when Iir_Kind_Configuration_Specification =>
               --  This may be created by canon.
               Set_Col (Indent);
               Disp_Configuration_Specification (El);
               Set_Col (Indent);
               Put_Line ("end for;");
            when others =>
               Error_Kind ("disp_configuration_item_list", El);
         end case;
         El := Get_Chain (El);
      end loop;
   end Disp_Configuration_Items;

   procedure Disp_Block_Configuration
     (Block: Iir_Block_Configuration; Indent: Count)
   is
      Spec : Iir;
   begin
      Set_Col (Indent);
      Put ("for ");
      Spec := Get_Block_Specification (Block);
      case Get_Kind (Spec) is
         when Iir_Kind_Block_Statement
           | Iir_Kind_Generate_Statement
           | Iir_Kind_Architecture_Declaration =>
            Disp_Name_Of (Spec); -- f:n
         when Iir_Kind_Indexed_Name =>
            Disp_Name_Of (Get_Prefix (Spec)); -- f:prefix
            Put (" (");
            Disp_Expression (Get_First_Element (Get_Index_List (Spec)));
            Put (")");
         when Iir_Kind_Selected_Name =>
            Disp_Name_Of (Get_Prefix (Spec)); -- f:prefix
            Put (" (");
            Put (Iirs_Utils.Image_Identifier (Spec)); -- f:n
            Put (")");
         when Iir_Kind_Slice_Name =>
            Disp_Name_Of (Get_Prefix (Spec)); -- f:prefix
            Put (" (");
            Disp_Range (Get_Suffix (Spec));
            Put (")");
         when others =>
            Error_Kind ("disp_block_configuration", Spec);
      end case;
      New_Line;
      Disp_Declaration_Chain (Block, Indent + Indentation);
      Disp_Configuration_Items (Block, Indent + Indentation);
      Set_Col (Indent);
      Put_Line ("end for;");
   end Disp_Block_Configuration;

   procedure Disp_Configuration_Declaration
     (Decl: Iir_Configuration_Declaration)
   is
   begin
      Put ("configuration ");
      Disp_Name_Of (Decl); -- f:n
      Put (" of ");
      Disp_Name_Of (Get_Entity (Decl)); --f:of
      Put_Line (" is");
      Disp_Declaration_Chain (Decl, Col);
      Disp_Block_Configuration (Get_Block_Configuration (Decl),
                                Col + Indentation);
      Put_Line ("end;");
   end Disp_Configuration_Declaration;

   procedure Disp_Design_Unit (Unit: Iir_Design_Unit)
   is
      Decl: Iir;
      Indent: Count;
      pragma Unreferenced (Indent);
   begin
      Indent := Col;
      Decl := Get_Context_Items (Unit);
      while Decl /= Null_Iir loop
         Set_Col (Indent);
         case Get_Kind (Decl) is
            when Iir_Kind_Use_Clause =>
               Disp_Use_Clause (Decl);
            when Iir_Kind_Library_Clause =>
               Put ("library ");
               Disp_Identifier (Decl); -- f:n
               Put_Line (";");
            when others =>
               Error_Kind ("disp_design_unit1", Decl);
         end case;
         Decl := Get_Chain (Decl);
      end loop;

      Decl := Get_Library_Unit (Unit);
      Set_Col (Indent);
      case Get_Kind (Decl) is
         when Iir_Kind_Entity_Declaration =>
            Disp_Entity_Declaration (Decl);
         when Iir_Kind_Architecture_Declaration =>
            Disp_Architecture_Declaration (Decl);
         when Iir_Kind_Package_Declaration =>
            Disp_Package_Declaration (Decl);
         when Iir_Kind_Package_Body =>
            Disp_Package_Body (Decl);
         when Iir_Kind_Configuration_Declaration =>
            Disp_Configuration_Declaration (Decl);
         when others =>
            Error_Kind ("disp_design_unit2", Decl);
      end case;
      New_Line (2);
   end Disp_Design_Unit;

   procedure Disp_Xml_Vhdl (An_Iir: Iir) is
   begin
      --Set_Line_Length (80);
      -- Put (Count'Image (Line_Length));
      case Get_Kind (An_Iir) is
         when Iir_Kind_Design_Unit =>
            Disp_Design_Unit (An_Iir);
         when Iir_Kind_Character_Literal =>
            Disp_Character_Literal (An_Iir);
         when Iir_Kind_Enumeration_Type_Definition =>
            Disp_Enumeration_Type_Definition (An_Iir);
         when Iir_Kind_Enumeration_Subtype_Definition =>
            Disp_Enumeration_Subtype_Definition (An_Iir);
         when Iir_Kind_Concurrent_Conditional_Signal_Assignment =>
            Disp_Concurrent_Conditional_Signal_Assignment (An_Iir);
         when Iir_Kinds_Dyadic_Operator =>
            Disp_Dyadic_Operator (An_Iir);
         when Iir_Kind_Signal_Interface_Declaration
           | Iir_Kind_Signal_Declaration
           | Iir_Kind_Object_Alias_Declaration =>
            Disp_Name_Of (An_Iir); -- f:n
         when Iir_Kind_Enumeration_Literal =>
            Disp_Identifier (An_Iir); -- f:n
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Component_Instantiation_Statement (An_Iir);
         when Iir_Kind_Integer_Subtype_Definition =>
            Disp_Integer_Subtype_Definition (An_Iir);
         when Iir_Kind_Array_Subtype_Definition =>
            Disp_Array_Subtype_Definition (An_Iir);
         when Iir_Kind_Array_Type_Definition =>
            Disp_Array_Type_Definition (An_Iir);
         when Iir_Kind_Package_Declaration =>
            Disp_Package_Declaration (An_Iir);
         when Iir_Kind_Wait_Statement =>
            Disp_Wait_Statement (An_Iir);
         when Iir_Kind_Selected_Name
           | Iir_Kind_Selected_Element
           | Iir_Kind_Indexed_Name
           | Iir_Kind_Slice_Name =>
            Disp_Expression (An_Iir);
         when others =>
            Error_Kind ("disp", An_Iir);
      end case;
   end Disp_Xml_Vhdl;
   function NewN(P:X;Pos:U_String) return X is
      N : X;
   begin
      N := X(Create_Xml_Node_Pretty(P,+"undef"));
      AddAttr(N,+"pos",Pos);
      return N;
   end NewN;
   procedure Disp_Int64 (Val: Iir_Int64)
   is
      Str: constant String := Iir_Int64'Image (Val);
   begin
      if Str(Str'First) = ' ' then
         Put (Str (Str'First + 1 .. Str'Last));
      else
         Put (Str);
      end if;
   end Disp_Int64;
   pragma Unreferenced (Disp_Int64);

   --  procedure Disp_Int32 (Val: Iir_Int32)
   --  is
   --     Str: constant String := Iir_Int32'Image (Val);
   --  begin
   --     if Str(Str'First) = ' ' then
   --        Put (Str (Str'First + 1 .. Str'Last));
   --     else
   --        Put (Str);
   --     end if;
   --  end Disp_Int32;

   procedure Disp_Fp64 (Val: Iir_Fp64)
   is
      Str: constant String := Iir_Fp64'Image (Val);
   begin
      if Str(Str'First) = ' ' then
         Put (Str (Str'First + 1 .. Str'Last));
      else
         Put (Str);
      end if;
   end Disp_Fp64;
   pragma Unreferenced (Disp_Fp64);

end disp_xml_vhdl;
