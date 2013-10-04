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
   procedure Disp_Name_Of (P,N:X;Decl: Iir);

   Indentation: constant Count := 2;

   -- If set, disp after a string literal the type enclosed into brackets.
   Disp_String_Literal_Type: constant Boolean := False;

   -- If set, disp position number of associations
   --Disp_Position_Number: constant Boolean := False;

--    procedure Disp_Tab (N,NewN(N,+"-"),Tab: Natural) is
--       Blanks : String (1 .. Tab) := (others => ' ');
--    begin
--       Put (Blanks);
--    end Disp_Tab;

   procedure Disp_Type (P,N:X;A_Type: Iir);

   procedure Disp_Expression (P,N:X;Expr: Iir);
   procedure Disp_Concurrent_Statement (P,N:X;Stmt: Iir);
   procedure Disp_Concurrent_Statement_Chain
      (P,N:X;Parent: Iir; Indent : Count);
   procedure Disp_Declaration_Chain
     (P,N:X;Parent : Iir; Indent: Count);
   procedure Disp_Process_Statement (P,N:X;Process: Iir);
   procedure Disp_Sequential_Statements (P,N:X;First : Iir);
   procedure Disp_Choice (P,N:X;Choice: in out Iir);
   procedure Disp_Association_Chain (P,N:X;Chain : Iir);
   procedure Disp_Block_Configuration
     (P,N:X;Block: Iir_Block_Configuration; Indent: Count);
   procedure Disp_Subprogram_Declaration (P,N:X;Subprg: Iir);
   procedure Disp_Binding_Indication
     (P,N:X;Bind : Iir; Indent : Count);
   procedure Disp_Subtype_Indication (P,N:X;Def : Iir;
                                      Full_Decl : Boolean := False);
   procedure Disp_Int64 (P,N:X;Val: Iir_Int64);
   --procedure Disp_Int32 (N,NewN(N,+"-"),Val: Iir_Int32);
   procedure Disp_Fp64 (P,N:X;Val: Iir_Fp64);

   procedure ChangeTag (E: X; Tree : in Iir) is
   begin
      case Get_Kind (Tree) is
         when Iir_Kind_Design_File =>
            SetTag(E.all,+"design_file");
         when Iir_Kind_Design_Unit =>
            SetTag(E.all, +"design_unit");
         when Iir_Kind_Use_Clause =>
            SetTag(E.all,+"use_clause");
         when Iir_Kind_Slice_Name =>
            SetTag(E.all,+"slice_name");
         when Iir_Kind_Library_Clause =>
            SetTag(E.all, +"library_clause");
         when Iir_Kind_Library_Declaration =>
            SetTag(E.all, +"library_declaration");
         when Iir_Kind_Proxy =>
            SetTag(E.all,+"proxy");
         when Iir_Kind_Allocator_By_Expression =>
            SetTag(E.all,+"allocator_by_expression");
         when Iir_Kind_Selected_Name =>
            SetTag(E.all,+"selected_name");
         when Iir_Kind_Implicit_Dereference =>
            SetTag(E.all,+"implicit_dereference");
         when Iir_Kind_Selected_Element =>
            SetTag(E.all,+"selected_element");
         when Iir_Kind_Waveform_Element =>
            SetTag(E.all,+"waveform_element");
         when Iir_Kind_Type_Conversion =>
            SetTag(E.all,+"type_conversion");
         when Iir_Kind_Qualified_Expression =>
            SetTag(E.all,+"qualified_expression");
         when Iir_Kind_Package_Declaration =>
            SetTag(E.all, +"package_declaration");
         when Iir_Kind_Package_Body =>
            SetTag(E.all, +"package_body");
         when Iir_Kind_Entity_Declaration =>
            SetTag(E.all, +"entity_declaration");
         when Iir_Kind_Architecture_Declaration =>
            SetTag(E.all, +"architecture_declaration");
         when Iir_Kind_Configuration_Declaration =>
            SetTag(E.all, +"configuration_declaration");
         when Iir_Kind_Function_Declaration =>
            SetTag(E.all, +"function_declaration");
         when Iir_Kind_Function_Body =>
            SetTag(E.all,+"function_body");
         when Iir_Kind_Procedure_Declaration =>
            SetTag(E.all, +"procedure_declaration");
         when Iir_Kind_Procedure_Body =>
            SetTag(E.all,+"procedure_body");
         when Iir_Kind_Object_Alias_Declaration =>
            SetTag(E.all, +"object_alias_declaration");
         when Iir_Kind_Non_Object_Alias_Declaration =>
            SetTag(E.all, +"non_object_alias_declaration");
         when Iir_Kind_Signal_Interface_Declaration =>
            SetTag(E.all, +"signal_interface_declaration");
         when Iir_Kind_Signal_Declaration =>
            SetTag(E.all, +"signal_declaration");
         when Iir_Kind_Variable_Interface_Declaration =>
            SetTag(E.all, +"variable_interface_declaration");
         when Iir_Kind_Variable_Declaration =>
            SetTag(E.all,+"variable_declaration");
         when Iir_Kind_Constant_Interface_Declaration =>
            SetTag(E.all, +"constant_interface_declaration");
         when Iir_Kind_Constant_Declaration =>
            SetTag(E.all, +"constant_declaration");
         when Iir_Kind_Iterator_Declaration =>
            SetTag(E.all, +"iterator_declaration");
         when Iir_Kind_File_Interface_Declaration =>
            SetTag(E.all, +"file_interface_declaration");
         when Iir_Kind_File_Declaration =>
            SetTag(E.all, +"file_declaration");
         when Iir_Kind_Type_Declaration =>
            SetTag(E.all, +"type_declaration");
         when Iir_Kind_Anonymous_Type_Declaration =>
            SetTag(E.all, +"anonymous_type_declaration");
         when Iir_Kind_Subtype_Declaration =>
            SetTag(E.all, +"subtype_declaration");
         when Iir_Kind_Component_Declaration =>
            SetTag(E.all, +"component_declaration");
         when Iir_Kind_Element_Declaration =>
            SetTag(E.all, +"element_declaration");
         when Iir_Kind_Record_Element_Constraint =>
            SetTag(E.all, +"record_element_constraint");
         when Iir_Kind_Attribute_Declaration =>
            SetTag(E.all, +"attribute_declaration");
         when Iir_Kind_Group_Template_Declaration =>
            SetTag(E.all, +"group_template_declaration");
         when Iir_Kind_Group_Declaration =>
            SetTag(E.all, +"group_declaration");
         when Iir_Kind_Psl_Declaration =>
            SetTag(E.all, +"psl_declaration");
         when Iir_Kind_Psl_Expression =>
            SetTag(E.all,+"psl_expression");
         when Iir_Kind_Enumeration_Type_Definition =>
            SetTag(E.all, +"enumeration_type_definition");
         when Iir_Kind_Enumeration_Subtype_Definition =>
            SetTag(E.all, +"enumeration_subtype_definition");
         when Iir_Kind_Integer_Subtype_Definition =>
            SetTag(E.all, +"integer_subtype_definition");
         when Iir_Kind_Integer_Type_Definition =>
            SetTag(E.all, +"integer_type_definition");
         when Iir_Kind_Floating_Subtype_Definition =>
            SetTag(E.all, +"floating_subtype_definition");
         when Iir_Kind_Floating_Type_Definition =>
            SetTag(E.all, +"floating_type_definition");
         when Iir_Kind_Array_Subtype_Definition =>
            SetTag(E.all, +"array_subtype_definition");
         when Iir_Kind_Array_Type_Definition =>
            SetTag(E.all, +"array_type_definition");
         when Iir_Kind_Record_Type_Definition =>
            SetTag(E.all, +"record_type_definition");
         when Iir_Kind_Access_Type_Definition =>
            SetTag(E.all, +"access_type_definition");
         when Iir_Kind_File_Type_Definition =>
            SetTag(E.all, +"file_type_definition");
         when Iir_Kind_Subtype_Definition =>
            SetTag(E.all,+"subtype_definition");
         when Iir_Kind_Physical_Type_Definition =>
            SetTag(E.all, +"physical_type_definition");
         when Iir_Kind_Physical_Subtype_Definition =>
            SetTag(E.all,+"physical_subtype_definition");
         when Iir_Kind_Simple_Name =>
            SetTag(E.all, +"simple_name");
         when Iir_Kind_Operator_Symbol =>
            SetTag(E.all,+"operator_symbol");
         when Iir_Kind_Null_Literal =>
            SetTag(E.all,+"null_literal");
         when Iir_Kind_Physical_Int_Literal =>
            SetTag(E.all,+"physical_int_literal");
         when Iir_Kind_Bit_String_Literal =>
            SetTag(E.all,+"bitstring_literal");
         when Iir_Kind_Physical_Fp_Literal =>
            SetTag(E.all,+"physical_fp_literal");
         when Iir_Kind_Component_Instantiation_Statement =>
            SetTag(E.all, +"component_instantiation_statement");
         when Iir_Kind_Block_Statement =>
            SetTag(E.all, +"block_statement");
         when Iir_Kind_Sensitized_Process_Statement =>
            SetTag(E.all, +"sensitized_process_statement");
         when Iir_Kind_Process_Statement =>
            SetTag(E.all, +"process_statement");
         when Iir_Kind_Case_Statement =>
            SetTag(E.all,+"case_statement");
         when Iir_Kind_If_Statement =>
            SetTag(E.all,+"if_statement");
         when Iir_Kind_Elsif =>
            SetTag(E.all,+"elsif");
         when Iir_Kind_For_Loop_Statement =>
            SetTag(E.all,+"for_loop_statement");
         when Iir_Kind_While_Loop_Statement =>
            SetTag(E.all,+"while_loop_statement");
         when Iir_Kind_Exit_Statement =>
            SetTag(E.all,+"exit_statement");
         when Iir_Kind_Next_Statement =>
            SetTag(E.all,+"next_statement");
         when Iir_Kind_Wait_Statement =>
            SetTag(E.all,+"wait_statement");
         when Iir_Kind_Assertion_Statement =>
            SetTag(E.all,+"assertion_statement");
         when Iir_Kind_Variable_Assignment_Statement =>
            SetTag(E.all,+"variable_assignment_statement");
         when Iir_Kind_Signal_Assignment_Statement =>
            SetTag(E.all,+"signal_assignment_statement");
         when Iir_Kind_Concurrent_Assertion_Statement =>
            SetTag(E.all,+"concurrent_assertion_statement");
         when Iir_Kind_Procedure_Call_Statement =>
            SetTag(E.all,+"procedure_call_statement");
         when Iir_Kind_Concurrent_Procedure_Call_Statement =>
            SetTag(E.all,+"concurrent_procedure_call_statement");
         when Iir_Kind_Return_Statement =>
            SetTag(E.all,+"return_statement");
         when Iir_Kind_Null_Statement =>
            SetTag(E.all,+"null_statement");
         when Iir_Kind_Enumeration_Literal =>
            SetTag(E.all, +"enumeration_literal");
         when Iir_Kind_Character_Literal =>
            SetTag(E.all,+"character_literal");
         when Iir_Kind_Integer_Literal =>
            SetTag(E.all,+"integer_literal");
            AddAttr(E,+"val",+ Iir_Int64'Image (Get_Value (Tree)));
         when Iir_Kind_Floating_Point_Literal =>
            SetTag(E.all,+"floating_point_literal");
            AddAttr(E,+"val",+ Iir_Fp64'Image (Get_Fp_Value (Tree)));
         when Iir_Kind_String_Literal =>
            SetTag(E.all,+"string_literal");
            AddAttr(E,+"val",+ Image_String_Lit (Tree));
         when Iir_Kind_Unit_Declaration =>
            SetTag(E.all, +"physical_unit");
         when Iir_Kind_Entity_Class =>
            SetTag(E.all,+"entity_class");
            AddAttr(E,+"val",+ Tokens.Image (Get_Entity_Class (Tree)) );
         when Iir_Kind_Attribute_Name =>
            SetTag(E.all, +"attribute_name");
         when Iir_Kind_Implicit_Function_Declaration =>
            SetTag(E.all, +"implicit_function_declaration");
         when Iir_Kind_Implicit_Procedure_Declaration =>
            SetTag(E.all, +"implicit_procedure_declaration");
         when others =>
            SetTag(E.all,+Iir_Kind'Image (Get_Kind (Tree)));

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
      return + (''' & Name_Table.Get_Character (Get_Identifier (Lit)) & ''')
;
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


   procedure Disp_Ident (P,N:X;Id: Name_Id) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"ident");
      Put (Name_Table.Image (Id) );
   end Disp_Ident;

   procedure Disp_Identifier (P,N:X;Node : Iir) is
      pragma Unreferenced (P);
      Ident : Name_Id;
   begin
      SetId(N,Node);
      SetTag(N.all,+"identifier");
      Ident := Get_Identifier (Node);
      if Ident /= Null_Identifier then
         Disp_Ident (N,NewN(N,+"-"),Ident);
      else
         null;--         Put ("<anonymous>");
      end if;
   end Disp_Identifier;

   procedure Disp_Label (P,N:X;Node : Iir) is
      pragma Unreferenced (P);
      Ident : Name_Id;
   begin
      SetId(N,Node);
      SetTag(N.all,+"label");
      Ident := Get_Label (Node);
      if Ident /= Null_Identifier then
         Disp_Ident (N,NewN(N,+"-"),Ident);
      else
         null;--         Put ("<anonymous>");
      end if;
   end Disp_Label;

   procedure Disp_Character_Literal (P,N:X;Lit: Iir_Character_Literal) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"character_literal");
      Put (''' & Name_Table.Get_Character (Get_Identifier (Lit)) & ''');
   end Disp_Character_Literal;

   procedure Disp_Function_Name (P,N:X;Func: Iir)
   is
      pragma Unreferenced (P);
      use Name_Table;
      use Std_Names;
      Id: Name_Id;
   begin
      SetId(N,Func);
      SetTag(N.all,+"function_name");
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
            Disp_Ident (N,NewN(N,+"-"),Id);
      end case;
   end Disp_Function_Name;

   --  Disp the name of DECL.
   procedure Disp_Name_Of (P,N:X;Decl: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Decl);
      SetTag(N.all,+"name_of");
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
            Disp_Identifier (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Anonymous_Type_Declaration =>
            null;--            Put ('<');
            Disp_Ident (N,NewN(N,+"-"),Get_Identifier (Decl));
            null;--            Put ('>');
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            Disp_Function_Name (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            Disp_Identifier (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Physical_Subtype_Definition
           | Iir_Kind_Enumeration_Type_Definition =>
            Disp_Identifier (N,NewN(N,+"-"),Get_Type_Declarator (Decl));
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Ident (N,NewN(N,+"-"),Get_Label (Decl));
         when Iir_Kind_Design_Unit =>
            Disp_Name_Of (N,NewN(N,+"-"),Get_Library_Unit (Decl));
         when Iir_Kind_Enumeration_Literal
           | Iir_Kind_Simple_Name =>
            Disp_Identifier (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Block_Statement
           | Iir_Kind_Generate_Statement =>
            Disp_Label (N,NewN(N,+"-"),Decl);
         when others =>
            Error_Kind ("disp_name_of", Decl);
      end case;
   end Disp_Name_Of;


   procedure Disp_Range (P,N:X;Decl: Iir) is
   begin
      SetId(N,Decl);
      SetTag(N.all,+"range");
      if Get_Kind (Decl) = Iir_Kind_Range_Expression then
         Disp_Expression (N,NewN(N,+"l"),Get_Left_Limit (Decl)); -- p:l
         if Get_Direction (Decl) = Iir_To then
            AddAttr(N,+"dir",+(" to"));
         else
            AddAttr(N,+"dir",+(" downto"));
         end if;
         Disp_Expression (N,NewN(N,+"r"),Get_Right_Limit (Decl)); -- p:r
      else
         if (Get_Kind(Decl) = Iir_Kind_Range_Array_Attribute) then
            Disp_Expression(N,NewN(N,+"prefix"),Get_Prefix(Decl))
; -- p:prefix
            AddAttr(N,+"typ",+("'range"));
         else
            Disp_Subtype_Indication (P,N,Decl); -- reent:1
         end if;
         -- Disp_Subtype_Indication (N,NewN(N,+"-"),Decl);
         --  Disp_Name_Of (N,NewN(N,+"-"),Get_Type_Declarator (Decl));
      end if;
   end Disp_Range;

   procedure Disp_Name (P,N:X;Name: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Name);
      SetTag(N.all,+"name");
      case Get_Kind (Name) is
         when Iir_Kind_Selected_By_All_Name =>
            Disp_Name (N,NewN(N,+"-"),Get_Prefix (Name));
            null;--            Put (".all");
         when Iir_Kind_Dereference =>
            Disp_Name (N,NewN(N,+"-"),Get_Prefix (Name));
            null;--            Put (".all");
         when Iir_Kind_Simple_Name =>
            Put (Iirs_Utils.Image_Identifier (Name));
         when Iir_Kind_Selected_Name =>
            Disp_Name (N,NewN(N,+"-"),Get_Prefix (Name));
            null;--            Put (".");
            Disp_Ident (N,NewN(N,+"-"),Get_Suffix_Identifier (Name));
         when Iir_Kind_Type_Declaration
           | Iir_Kind_Enumeration_Literal
           | Iir_Kind_Implicit_Function_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration
           | Iir_Kind_Variable_Declaration
           | Iir_Kind_Function_Declaration
           | Iir_Kind_Procedure_Declaration =>
            Disp_Name_Of (N,NewN(N,+"-"),Name);
         when others =>
            Error_Kind ("disp_name", Name);
      end case;
   end Disp_Name;

   procedure Disp_Use_Clause (P,N:X;Clause: Iir_Use_Clause) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"use_clause");
      null;--      Put ("use ");
      AddAttr(N,+"n",Str_Name(Get_Selected_Name (Clause))); -- f:n
      null;--      Put_Line (";");
   end Disp_Use_Clause;

   -- Disp the resolution function (if any) of type definition DEF.
   procedure Disp_Resolution_Function (P,N:X;Subtype_Def: Iir)
   is
      pragma Unreferenced (P);
      procedure Inner (P:X;Pos:U_String;Def : Iir)
      is
         Decl: Iir;
         N: constant X := X(Create_Xml_Node_Pretty(P,Pos));
      begin
         if Get_Kind (Def) in Iir_Kinds_Subtype_Definition then
            Decl := Get_Resolution_Function (Def);
            if Decl /= Null_Iir then
               AddAttr(N,+"n",Str_Name(Decl)); -- f:n
            else
               case Get_Kind (Def) is
                  when Iir_Kind_Array_Subtype_Definition =>
                     null;--                     Put ('(');
                     Inner (N,+"inner",Get_Element_Subtype (Def));
                     null;--                     Put (')');
                  when others =>
                     Error_Kind ("disp_resolution_function", Def);
               end case;
            end if;
         end if;
      end Inner;

   begin
      SetId(N,Subtype_Def);
      SetTag(N.all,+"resolution_function");
      if Get_Resolved_Flag (Subtype_Def) then
         Inner (N,+"inner",Subtype_Def);
         null;--         Put (' ');
      end if;
   end Disp_Resolution_Function;

   procedure Disp_Integer_Subtype_Definition
     (P,N:X;Def: Iir_Integer_Subtype_Definition)
   is
      pragma Unreferenced (P);
      Base_Type: Iir_Integer_Type_Definition;
      Decl: Iir;
   begin
      SetTag(N.all,+"integer_subtype_definition");
      if Def /= Std_Package.Universal_Integer_Subtype_Definition then
         Base_Type := Get_Base_Type (Def);
         Decl := Get_Type_Declarator (Base_Type);
         if Base_Type /= Std_Package.Universal_Integer_Subtype_Definition
           and then Def /= Decl
         then
            AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
            null;--            Put (" ");
         end if;
      end if;
      Disp_Resolution_Function (N,NewN(N,+"-"),Def);
      null;--      Put ("range ");
      Disp_Expression (N,NewN(N,+"-"),Get_Range_Constraint (Def));
      null;--      Put (";");
   end Disp_Integer_Subtype_Definition;

   procedure Disp_Floating_Subtype_Definition
     (P,N:X;Def: Iir_Floating_Subtype_Definition)
   is
      pragma Unreferenced (P);
      Base_Type: Iir_Floating_Type_Definition;
      Decl: Iir;
   begin
      SetTag(N.all,+"floating_subtype_definition");
      if Def /= Std_Package.Universal_Real_Subtype_Definition then
         Base_Type := Get_Base_Type (Def);
         Decl := Get_Type_Declarator (Base_Type);
         if Base_Type /= Std_Package.Universal_Real_Subtype_Definition
           and then Def /= Decl
         then
            AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
            null;--            Put (" ");
         end if;
      end if;
      Disp_Resolution_Function (N,NewN(N,+"res"),Def); --p:res
      null;--      Put ("range ");
      Disp_Expression (N,NewN(N,+"range"),Get_Range_Constraint (Def))
; --p:range
      null;--      Put (";");
   end Disp_Floating_Subtype_Definition;

   procedure Disp_Element_Constraint
     (P,N:X;Def : Iir; Type_Mark : Iir);

   procedure Disp_Array_Element_Constraint (P,N:X;Def : Iir
; Type_Mark : Iir)
   is
      Index : Iir;
      Def_El : Iir;
      Tm_El : Iir;
      Has_Index : Boolean;
      Has_Own_Element_Subtype : Boolean;
      Ec : X;
   begin
      SetId(N,Def);
      SetTag(N.all,+"array_element_constraint");
      Has_Index := Get_Index_Constraint_Flag (Def);
      Def_El := Get_Element_Subtype (Def);
      Tm_El := Get_Element_Subtype (Type_Mark);
      Has_Own_Element_Subtype := Def_El /= Tm_El;

      if not Has_Index and not Has_Own_Element_Subtype then
         return;
      end if;

      null;--      Put (" (");
      if Has_Index then
         for I in Natural loop  -- chain:[v=Ec|n=arrrange]
            Ec := NewN(N,+"-");
            SetTag(Ec.all,+"arrrange");
            Index := Get_Nth_Element (Get_Index_Subtype_List (Def), I);
            if Index = Null_Iir then
               RemFrom(N,Ec);
            end if;
            exit when Index = Null_Iir; --exitchain:Ec
            if I /= 0 then
               null;--               Put (", ");
            end if;
            Disp_Range (Ec,NewN(Ec,+"range"),Index); -- p:range
         end loop;
      else
         null;--         Put ("open");
      end if;
      null;--      Put (")");

      if Has_Own_Element_Subtype
        and then Get_Kind (Def_El) in Iir_Kinds_Composite_Type_Definition
      then
         AddAttr(N,+"ownsubtype",+("ownsubtype"));
         Disp_Element_Constraint (P,N,Def_El, Tm_El); --reent:1
      end if;
   end Disp_Array_Element_Constraint;

   procedure Disp_Record_Element_Constraint (P,N:X;Def : Iir)
   is
      pragma Unreferenced (P);
      El_List : constant Iir_List := Get_Elements_Declaration_List (Def);
      El : Iir;
      Has_El : Boolean := False;
      Ec : X;
   begin
      SetId(N,Def);
      SetTag(N.all,+"record_element_constraint");
      for I in Natural loop -- chain:[v=Ec|n=Enumeration]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Enumeration");
         El := Get_Nth_Element (El_List, I);
         if El = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when El = Null_Iir; --exitchain:Ec
         if Get_Kind (El) = Iir_Kind_Record_Element_Constraint
           and then Get_Parent (El) = Def
         then
            if Has_El then
               null;--               Put (", ");
            else
               null;--               Put ("(");
               Has_El := True;
            end if;
            AddAttr(Ec,+"n",Str_Name_Of(El)); -- f:n
            Disp_Element_Constraint (Ec,NewN(Ec,+"-"),Get_Type (El),
                                     Get_Base_Type (Get_Type (El)));
         end if;
      end loop;
      if Has_El then
         null;--         Put (")");
      end if;
   end Disp_Record_Element_Constraint;

   procedure Disp_Element_Constraint (P,N:X;Def : Iir; Type_Mark : Iir) is
   begin
      SetId(N,Def);
      SetTag(N.all,+"element_constraint");
      case Get_Kind (Def) is
         when Iir_Kind_Record_Subtype_Definition =>
            Disp_Record_Element_Constraint (P,N,Def); --reent:1
         when Iir_Kind_Array_Subtype_Definition =>
            Disp_Array_Element_Constraint (P,N,Def, Type_Mark); --reent:1
         when others =>
            Error_Kind ("disp_element_constraint", Def);
      end case;
   end Disp_Element_Constraint;

   procedure Disp_Subtype_Indication (P,N:X;Def : Iir
; Full_Decl : Boolean := False)
   is
      pragma Unreferenced (P);
      Type_Mark : Iir;
      Base_Type : Iir;
      Decl : Iir;
   begin
      SetId(N,Def);
      SetTag(N.all,+"subtype_indication");
      Decl := Get_Type_Declarator (Def);
      if not Full_Decl and then Decl /= Null_Iir then
         AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
         return;
      end if;

      -- Resolution function name.
      Disp_Resolution_Function (N,NewN(N,+"res"),Def); -- p:res

      -- type mark.
      Type_Mark := Get_Type_Mark (Def);
      if Type_Mark /= Null_Iir then
         Decl := Get_Type_Declarator (Type_Mark);
         AddAttr(N,+"typmark",Str_Name_Of(Decl)); -- f:typmark
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
                  null;--                  Put (" range ");
               end if;
               Disp_Expression (N,NewN(N,+"-"),Get_Range_Constraint (Def));
            end if;
         when Iir_Kind_Array_Type_Definition =>
            Disp_Array_Element_Constraint (N,NewN(N,+"array"),Def
, Type_Mark); -- p:array
         when Iir_Kind_Record_Type_Definition =>
            Disp_Record_Element_Constraint (N,NewN(N,+"record"),Def)
; -- p:record
         when others =>
            Error_Kind ("disp_subtype_indication", Base_Type);
      end case;
   end Disp_Subtype_Indication;

   procedure Disp_Enumeration_Type_Definition
     (P,N:X;Def: Iir_Enumeration_Type_Definition)
   is
      pragma Unreferenced (P);
      Len : Count;
      Start_Col: Count;
      Decl: Name_Id;
      A_Lit: Iir; --Enumeration_Literal_Acc;
      pragma Unreferenced (Start_Col);
      Ec : X;
   begin
      SetTag(N.all,+"enumeration_type_definition");
      for I in Natural loop -- chain:[v=Ec|n=Enumeration]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Enumeration");
         A_Lit := Get_Nth_Element (Get_Enumeration_Literal_List (Def), I);
         if A_Lit = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when A_Lit = Null_Iir; --exitchain:Ec
         if I = Natural'first then
            null;--            Put ("(");
            Start_Col := Col;
         else
            null;--            Put (", ");
         end if;
         Decl := Get_Identifier (A_Lit);
         if Name_Table.Is_Character (Decl) then
            Len := 3;
         else
            Len := Count (Name_Table.Get_Name_Length (Decl));
         end if;
         if Col + Len + 2 > Line_Length then
            null;--            New_Line;
            null;--            Set_Col (Start_Col);
         end if;
         AddAttr(Ec,+"n",Str_Name_Of(A_Lit)); -- f:n
      end loop;
      null;--      Put (");");
   end Disp_Enumeration_Type_Definition;

   procedure Disp_Enumeration_Subtype_Definition
     (P,N:X;Def: Iir_Enumeration_Subtype_Definition)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"enumeration_subtype_definition");
      Disp_Resolution_Function (N,NewN(N,+"-"),Def);
      null;--      Put ("range ");
      Disp_Range (N,NewN(N,+"-"),Def);
      null;--      Put (";");
   end Disp_Enumeration_Subtype_Definition;

   procedure Disp_Array_Subtype_Definition
     (P,N:X;Def: Iir_Array_Subtype_Definition)
   is
      pragma Unreferenced (P);
      Index: Iir;
      Ec : X;
   begin
      SetTag(N.all,+"array_subtype_definition");
      Disp_Resolution_Function (N,NewN(N,+"-"),Def);

      null;--      Put ("array (");
      for I in Natural loop -- chain:[v=Ec|n=arrrange]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"arrrange");
         Index := Get_Nth_Element (Get_Index_Subtype_List (Def), I);
         if Index = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when Index = Null_Iir; --exitchain:Ec
         if I /= 0 then
            null;--            Put (", ");
         end if;
         Disp_Subtype_Indication (Ec,NewN(Ec,+"range"),Index); --p:range
      end loop;
      null;--      Put (") of ");
      Disp_Subtype_Indication (N,NewN(N,+"typ"),Get_Element_Subtype (Def))
; --p:typ
   end Disp_Array_Subtype_Definition;

   procedure Disp_Array_Type_Definition (P,N:X
;Def: Iir_Array_Type_Definition) is
      pragma Unreferenced (P);
      Index: Iir;
      Ec : X;
   begin
      SetTag(N.all,+"array_type_definition");
      null;--      Put ("array (");
      for I in Natural loop -- chain:[v=Ec|n=arrrange]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"arrrange");
         Index := Get_Nth_Element (Get_Index_Subtype_List (Def), I);
         if Index = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when Index = Null_Iir; --exitchain:Ec
         if I /= 0 then
            null;--            Put (", ");
         end if;
         Disp_Subtype_Indication (Ec,NewN(Ec,+"range"),Index); --p:range
         null;--         Put (" range <>");
      end loop;
      null;--      Put (") of ");
      Disp_Type (N,NewN(N,+"typ"),Get_Element_Subtype (Def)); --p:typ
      null;--      Put (";");
   end Disp_Array_Type_Definition;

   procedure Disp_Physical_Literal (P,N:X;Lit: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Lit);
      SetTag(N.all,+"physical_literal");
      case Get_Kind (Lit) is
         when Iir_Kind_Physical_Int_Literal =>
            AddAttr(N,+"v",Str_Int64(Get_Value (Lit))); -- f:v
         when Iir_Kind_Physical_Fp_Literal =>
            AddAttr(N,+"v",Str_Fp64(Get_Fp_Value (Lit))); -- f:v
         when others =>
            Error_Kind ("disp_physical_literal", Lit);
      end case;
      null;--      Put (' ');
      AddAttr(N,+"unit",Str_Identifier(Get_Unit_Name (Lit))); -- f:unit
   end Disp_Physical_Literal;

   procedure Disp_Physical_Subtype_Definition
     (P,N:X;Def: Iir_Physical_Subtype_Definition; Indent: Count)
   is
      pragma Unreferenced (P);
      Base_Type: Iir;
      Unit: Iir_Unit_Declaration;
      Ec : X;
      pragma Unreferenced (Indent);
   begin
      SetTag(N.all,+"physical_subtype_definition");
      Disp_Resolution_Function (N,NewN(N,+"-"),Def);
      null;--      Put ("range ");
      Disp_Expression (N,NewN(N,+"-"),Get_Range_Constraint (Def));
      Base_Type := Get_Base_Type (Def);
      if Get_Type_Declarator (Base_Type) = Get_Type_Declarator (Def) then
         null;--         Put_Line (" units");
         null;--         Set_Col (Indent + Indentation);
         Unit := Get_Unit_Chain (Base_Type);
         AddAttr(N,+"nunit",Str_Identifier(Unit)); -- f:nunit
         null;--         Put_Line (";");
         Unit := Get_Chain (Unit);
         while Unit /= Null_Iir loop -- chain:[v=Ec|n=unit]
            Ec := NewN(N,+"-");
            SetTag(Ec.all,+"unit");
            null;--            Set_Col (Indent + Indentation);
            AddAttr(Ec,+"n",Str_Identifier(Unit)); -- f:n
            null;--            Put (" = ");
            Disp_Physical_Literal (Ec,NewN(Ec,+"-")
,Get_Physical_Literal (Unit));
            null;--            Put_Line (";");
            Unit := Get_Chain (Unit);
         end loop;
         null;--         Set_Col (Indent);
         null;--         Put ("end units;");
      end if;
   end Disp_Physical_Subtype_Definition;

   procedure Disp_Record_Type_Definition
     (P,N:X;Def: Iir_Record_Type_Definition; Indent: Count)
   is
      pragma Unreferenced (P);
      List : Iir_List;
      El: Iir_Element_Declaration;
      pragma Unreferenced (Indent);
      Ec : X;
   begin
      SetTag(N.all,+"record_type_definition");
      null;--      Put_Line ("record");
      null;--      Set_Col (Indent);
      null;--      Put_Line ("begin");
      List := Get_Elements_Declaration_List (Def);
      for I in Natural loop -- chain:[v=Ec|n=entry]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"entry");
         El := Get_Nth_Element (List, I);
         if El = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when El = Null_Iir; --exitchain:Ec
         null;--         Set_Col (Indent + Indentation);
         AddAttr(Ec,+"n",Str_Identifier(El)); -- f:n
         null;--         Put (" : ");
         Disp_Subtype_Indication (Ec,NewN(Ec,+"-"),Get_Type (El));
         null;--         Put_Line (";");
      end loop;
      null;--      Set_Col (Indent);
      null;--      Put ("end record;");
   end Disp_Record_Type_Definition;

   procedure Disp_Designator_List (P,N:X;List: Iir_List) is
      pragma Unreferenced (P);
      El: Iir;
   begin
      SetTag(N.all,+"designator_list");
      if List = Null_Iir_List then
         return;
      end if;
      for I in Natural loop
         El := Get_Nth_Element (List, I);
         exit when El = Null_Iir;
         if I > 0 then
            null;--            Put (", ");
         end if;
         Disp_Expression (N,NewN(N,+"-"),El);
         --Disp_Text_Literal (N,NewN(N,+"-"),El);
      end loop;
   end Disp_Designator_List;

   -- Display the full definition of a type, ie the sequence that can create
   -- such a type.
   procedure Disp_Type_Definition (P,N:X;Decl: in Iir; Indent: Count) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"type_definition");
      case Get_Kind (Decl) is
         when Iir_Kind_Enumeration_Type_Definition =>
            Disp_Enumeration_Type_Definition (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Enumeration_Subtype_Definition =>
            Disp_Enumeration_Subtype_Definition (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Integer_Subtype_Definition =>
            Disp_Integer_Subtype_Definition (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Floating_Subtype_Definition =>
            Disp_Floating_Subtype_Definition (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Array_Type_Definition =>
            Disp_Array_Type_Definition (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Array_Subtype_Definition =>
            Disp_Array_Subtype_Definition (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Physical_Subtype_Definition =>
            Disp_Physical_Subtype_Definition (N,NewN(N,+"-"),Decl, Indent);
         when Iir_Kind_Record_Type_Definition =>
            Disp_Record_Type_Definition (N,NewN(N,+"-"),Decl, Indent);
         when Iir_Kind_Access_Type_Definition =>
            AddAttr(N,+"typ",+("access"));
            Disp_Subtype_Indication (N,NewN(N,+"-")
,Get_Designated_Type (Decl));
            null;--            Put (';');
         when Iir_Kind_File_Type_Definition =>
            null;--            Put ("file of ");
            Disp_Subtype_Indication (N,NewN(N,+"-"),Get_Type_Mark (Decl));
            null;--            Put (';');
         when Iir_Kind_Protected_Type_Declaration =>
            null;--            Put_Line ("protected");
            Disp_Declaration_Chain (N,NewN(N,+"-"),Decl
, Indent + Indentation);
            null;--            Set_Col (Indent);
            null;--            Put ("end protected;");
         when Iir_Kind_Integer_Type_Definition =>
            null;--            Put ("<integer base type>");
         when Iir_Kind_Floating_Type_Definition =>
            null;--            Put ("<floating base type>");
         when Iir_Kind_Physical_Type_Definition =>
            null;--            Put ("<physical base type>");
         when others =>
            Error_Kind ("disp_type_definition", Decl);
      end case;
   end Disp_Type_Definition;

   procedure Disp_Type_Declaration (P,N:X;Decl: Iir_Type_Declaration)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Def : Iir;
   begin
      SetTag(N.all,+"type_declaration");
      Indent := Col;
      null;--      Put ("type ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      Def := Get_Type (Decl);
      if Def = Null_Iir
        or else Get_Kind (Def) = Iir_Kind_Incomplete_Type_Definition
      then
         null;--         Put_Line (";");
      else
         null;--         Put (" is ");
         Disp_Type_Definition (N,NewN(N,+"-"),Def, Indent);
         null;--         New_Line;
      end if;
   end Disp_Type_Declaration;

   procedure Disp_Anonymous_Type_Declaration
     (P,N:X;Decl: Iir_Anonymous_Type_Declaration)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Def : Iir;
      Ec : X;
   begin
      SetTag(N.all,+"anonymous_type_declaration");
      Indent := Col;
      null;--      Put ("-- type ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      null;--      Put (" is ");
      Def := Get_Type (Decl);
      Disp_Type_Definition (N,NewN(N,+"-"),Def, Indent);
      if Get_Kind (Def) = Iir_Kind_Physical_Type_Definition then
         declare
            Unit : Iir_Unit_Declaration;
         begin
            null;--            Put_Line (" units");
            null;--            Set_Col (Indent);
            null;--            Put ("--   ");
            Unit := Get_Unit_Chain (Def);
            AddAttr(N,+"nunit",Str_Identifier(Unit)); -- f:nunit
            null;--            Put_Line (";");
            Unit := Get_Chain (Unit);
            while Unit /= Null_Iir loop -- chain:[v=Ec|n=unit]
               Ec := NewN(N,+"-");
               SetTag(Ec.all,+"unit");
               null;--               Set_Col (Indent);
               null;--               Put ("--   ");
               AddAttr(Ec,+"n",Str_Identifier(Unit)); -- f:n
               null;--               Put (" = ");
               Disp_Physical_Literal (Ec,NewN(Ec,+"-")
,Get_Physical_Literal (Unit));
               null;--               Put_Line (";");
               Unit := Get_Chain (Unit);
            end loop;
            null;--            Set_Col (Indent);
            null;--            Put ("-- end units;");
         end;
      end if;
      null;--      New_Line;
   end Disp_Anonymous_Type_Declaration;

   procedure Disp_Subtype_Declaration (P,N:X
;Decl: in Iir_Subtype_Declaration) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"subtype_declaration");
      null;--      Put ("subtype ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); --f:n
      null;--      Put (" is ");
      Disp_Subtype_Indication (N,NewN(N,+"-"),Get_Type (Decl), True);
      null;--      Put_Line (";");
   end Disp_Subtype_Declaration;

   procedure Disp_Type (P,N:X;A_Type: Iir)
   is
      pragma Unreferenced (P);
      Decl: Iir;
   begin
      SetId(N,A_Type);
      SetTag(N.all,+"type");
      Decl := Get_Type_Declarator (A_Type);
      if Decl /= Null_Iir then
         AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      else
         case Get_Kind (A_Type) is
            when Iir_Kind_Enumeration_Type_Definition
              | Iir_Kind_Integer_Type_Definition =>
               raise Program_Error;
            when Iir_Kind_Integer_Subtype_Definition
              | Iir_Kind_Enumeration_Subtype_Definition =>
               Disp_Subtype_Indication (N,NewN(N,+"-"),A_Type);
            when Iir_Kind_Array_Subtype_Definition =>
               Disp_Subtype_Indication (N,NewN(N,+"-"),A_Type);
            when others =>
               Error_Kind ("disp_type", A_Type);
         end case;
      end if;
   end Disp_Type;

   procedure Disp_Mode (P,N:X;Mode: Iir_Mode) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"mode");
      case Mode is
         when Iir_In_Mode =>
            null;--            Put ("in ");
         when Iir_Out_Mode =>
            null;--            Put ("out ");
         when Iir_Inout_Mode =>
            null;--            Put ("inout ");
         when Iir_Buffer_Mode =>
            null;--            Put ("buffer ");
         when Iir_Linkage_Mode =>
            null;--            Put ("linkage ");
         when Iir_Unknown_Mode =>
            null;--            Put ("<unknown> ");
      end case;
   end Disp_Mode;
   pragma Unreferenced (Disp_Mode);

   procedure Disp_Signal_Kind (P,N:X;Kind: Iir_Signal_Kind) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"signal_kind");
      case Kind is
         when Iir_No_Signal_Kind =>
            null;
         when Iir_Register_Kind =>
            null;--            Put (" register");
         when Iir_Bus_Kind =>
            null;--            Put (" bus");
      end case;
   end Disp_Signal_Kind;
   pragma Unreferenced (Disp_Signal_Kind);

   procedure Disp_Interface_Declaration (P,N:X;Inter: Iir)
   is
      pragma Unreferenced (P);
      Default: Iir;
   begin
      SetId(N,Inter);
      SetTag(N.all,+"interface_declaration");
      case Get_Kind (Inter) is
         when Iir_Kind_Signal_Interface_Declaration =>
            null;--            Put ("signal ");
         when Iir_Kind_Variable_Interface_Declaration =>
            null;--            Put ("variable ");
         when Iir_Kind_Constant_Interface_Declaration =>
            null;--            Put ("constant ");
         when Iir_Kind_File_Interface_Declaration =>
            null;--            Put ("file ");
         when others =>
            Error_Kind ("disp_interface_declaration", Inter);
      end case;
      AddAttr(N,+"n",Str_Name_Of(Inter)); -- f:n
      null;--      Put (": ");
      AddAttr(N,+"mode",Str_Mode(Get_Mode (Inter))); --f:mode
      Disp_Type (N,NewN(N,+"-"),Get_Type (Inter));
      if Get_Kind (Inter) = Iir_Kind_Signal_Interface_Declaration then
         AddAttr(N,+"sigkind",Str_Signal_Kind(Get_Signal_Kind (Inter)))
; -- f:sigkind
      end if;
      Default := Get_Default_Value (Inter);
      if Default /= Null_Iir then
         null;--         Put (" := ");
         Disp_Expression (N,NewN(N,+"-"),Default);
      end if;
   end Disp_Interface_Declaration;

   procedure Disp_Interface_Chain (P,N:X;Chain: Iir; Str: String)
   is
      pragma Unreferenced (P);
      Inter: Iir;
      Start: Count;
      pragma Unreferenced (Start);
      pragma Unreferenced (Str);
   begin
      SetId(N,Chain);
      SetTag(N.all,+"interface_chain");
      if Chain = Null_Iir then
         return;
      end if;
      null;--      Put (" (");
      Start := Col;
      Inter := Chain;
      while Inter /= Null_Iir loop
         null;--         Set_Col (Start);
         Disp_Interface_Declaration (N,NewN(N,+"-"),Inter);
         if Get_Chain (Inter) /= Null_Iir then
            null;--            Put ("; ");
         else
            null;--            Put (')');
            null;--            Put (Str); -- nop:1
         end if;
         Inter := Get_Chain (Inter);
      end loop;
   end Disp_Interface_Chain;

   procedure Disp_Ports (P,N:X;Parent : Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Parent);
      SetTag(N.all,+"ports");
      null;--      Put ("port");
      Disp_Interface_Chain (N,NewN(N,+"-"),Get_Port_Chain (Parent), ";");
   end Disp_Ports;

   procedure Disp_Generics (P,N:X;Parent : Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Parent);
      SetTag(N.all,+"generics");
      null;--      Put ("generic");
      Disp_Interface_Chain (N,NewN(N,+"-"),Get_Generic_Chain (Parent), ";");
   end Disp_Generics;

   procedure Disp_Entity_Declaration (P,N:X;Decl: Iir_Entity_Declaration) is
      pragma Unreferenced (P);
      Start: Count;
   begin
      SetTag(N.all,+"entity_declaration");
      Start := Col;
      null;--      Put ("entity ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); --f:n
      null;--      Put_Line (" is");
      if Get_Generic_Chain (Decl) /= Null_Iir then
         null;--         Set_Col (Start + Indentation);
         Disp_Generics (N,NewN(N,+"-"),Decl);
      end if;
      if Get_Port_Chain (Decl) /= Null_Iir then
         null;--         Set_Col (Start + Indentation);
         Disp_Ports (N,NewN(N,+"-"),Decl);
      end if;
      Disp_Declaration_Chain (N,NewN(N,+"-"),Decl, Start + Indentation);
      if Get_Concurrent_Statement_Chain (Decl) /= Null_Iir then
         null;--         Set_Col (Start);
         null;--         Put_Line ("begin");
         Disp_Concurrent_Statement_Chain (N,NewN(N,+"-"),Decl
, Start + Indentation);
      end if;
      null;--      Set_Col (Start);
      null;--      Put_Line ("end entity;");
   end Disp_Entity_Declaration;

   procedure Disp_Component_Declaration (P,N:X
;Decl: Iir_Component_Declaration)
   is
      pragma Unreferenced (P);
      Indent: Count;
      pragma Unreferenced (Indent);
   begin
      SetTag(N.all,+"component_declaration");
      Indent := Col;
      null;--      Put ("component ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      if Get_Generic_Chain (Decl) /= Null_Iir then
         null;--         Set_Col (Indent + Indentation);
         Disp_Generics (N,NewN(N,+"-"),Decl);
      end if;
      if Get_Port_Chain (Decl) /= Null_Iir then
         null;--         Set_Col (Indent + Indentation);
         Disp_Ports (N,NewN(N,+"-"),Decl);
      end if;
      null;--      Set_Col (Indent);
      null;--      Put ("end component;");
   end Disp_Component_Declaration;

   procedure Disp_Concurrent_Statement_Chain (P,N:X;Parent : Iir
; Indent : Count)
   is
      pragma Unreferenced (P);
      El: Iir;
      pragma Unreferenced (Indent);
   begin
      SetId(N,Parent);
      SetTag(N.all,+"concurrent_statement_chain");
      El := Get_Concurrent_Statement_Chain (Parent);
      while El /= Null_Iir loop
         null;--         Set_Col (Indent);
         Disp_Concurrent_Statement (N,NewN(N,+"-"),El);
         El := Get_Chain (El);
      end loop;
   end Disp_Concurrent_Statement_Chain;

   procedure Disp_Architecture_Declaration (P,N:X
;Arch: Iir_Architecture_Declaration)
   is
      pragma Unreferenced (P);
      Start: Count;
   begin
      SetTag(N.all,+"architecture_declaration");
      Start := Col;
      null;--      Put ("architecture ");
      AddAttr(N,+"n",Str_Name_Of(Arch)); -- f:n
      null;--      Put (" of ");
      AddAttr(N,+"of",Str_Name_Of(Get_Entity (Arch))); -- f:of
      null;--      Put_Line (" is");
      Disp_Declaration_Chain (N,NewN(N,+"-"),Arch, Start + Indentation);
      null;--      Set_Col (Start);
      null;--      Put_Line ("begin");
      Disp_Concurrent_Statement_Chain (N,NewN(N,+"-"),Arch
, Start + Indentation);
      null;--      Set_Col (Start);
      null;--      Put_Line ("end;");
   end Disp_Architecture_Declaration;

   procedure Disp_Object_Alias_Declaration (P,N:X
;Decl: Iir_Object_Alias_Declaration)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"object_alias_declaration");
      null;--      Put ("alias ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      null;--      Put (": ");
      Disp_Type (N,NewN(N,+"-"),Get_Type (Decl));
      null;--      Put (" is ");
      Disp_Expression (N,NewN(N,+"-"),Get_Name (Decl));
      null;--      Put_Line (";");
   end Disp_Object_Alias_Declaration;

   procedure Disp_Non_Object_Alias_Declaration
     (P,N:X;Decl: Iir_Non_Object_Alias_Declaration)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"non_object_alias_declaration");
      null;--      Put ("alias ");
      AddAttr(N,+"n",Str_Function_Name(Decl)); -- f:n
      null;--      Put (" is ");
      AddAttr(N,+"alias",Str_Name(Get_Name (Decl))); -- f:alias
      null;--      Put_Line (";");
   end Disp_Non_Object_Alias_Declaration;

   procedure Disp_File_Declaration (P,N:X;Decl: Iir_File_Declaration) is
      pragma Unreferenced (P);
      Expr: Iir;
   begin
      SetTag(N.all,+"file_declaration");
      null;--      Put ("file ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      null;--      Put (": ");
      Disp_Type (N,NewN(N,+"-"),Get_Type (Decl));
      if Vhdl_Std = Vhdl_87 then
         null;--         Put (" is ");
         AddAttr(N,+"mode",Str_Mode(Get_Mode (Decl))); --f:mode
         Disp_Expression (N,NewN(N,+"-"),Get_File_Logical_Name (Decl));
      else
         Expr := Get_File_Open_Kind (Decl);
         if Expr /= Null_Iir then
            null;--            Put (" open ");
            Disp_Expression (N,NewN(N,+"-"),Expr);
         end if;
         Expr := Get_File_Logical_Name (Decl);
         if Expr /= Null_Iir then
            null;--            Put (" is ");
            Disp_Expression (N,NewN(N,+"-"),Expr);
         end if;
      end if;
      null;--      Put (';');
   end Disp_File_Declaration;

   procedure Disp_Object_Declaration (P,N:X;Decl: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Decl);
      SetTag(N.all,+"object_declaration");
      case Get_Kind (Decl) is
         when Iir_Kind_Variable_Declaration =>
            if Get_Shared_Flag (Decl) then
               null;--               Put ("shared ");
            end if;
            AddAttr(N,+"typ",+("variable"));
         when Iir_Kind_Constant_Declaration =>
            AddAttr(N,+"typ",+("constant"));
         when Iir_Kind_Signal_Declaration =>
            AddAttr(N,+"typ",+("signal"));
         when Iir_Kind_Object_Alias_Declaration =>
            AddAttr(N,+"typ",+"alias");
            Disp_Object_Alias_Declaration (N,NewN(N,+"-"),Decl)
; --s:[typ=alias]

            return;
         when Iir_Kind_File_Declaration =>
            AddAttr(N,+"typ",+"file");
            Disp_File_Declaration (N,NewN(N,+"-"),Decl); --s:[typ=file]

            return;
         when others =>
            raise Internal_Error;
      end case;
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      null;--      Put (": ");
      Disp_Type (N,NewN(N,+"-"),Get_Type (Decl));
      if Get_Kind (Decl) = Iir_Kind_Signal_Declaration then
         AddAttr(N,+"sigkind",Str_Signal_Kind(Get_Signal_Kind (Decl)))
;  -- f:sigkind
      end if;

      if Get_Default_Value (Decl) /= Null_Iir then
         null;--         Put (" := ");
         Disp_Expression (N,NewN(N,+"-"),Get_Default_Value (Decl));
      end if;
      null;--      Put_Line (";");
   end Disp_Object_Declaration;

   procedure Disp_Subprogram_Declaration (P,N:X;Subprg: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Subprg);
      SetTag(N.all,+"subprogram_declaration");
      case Get_Kind (Subprg) is
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            AddAttr(N,+"typ",+("function"));
            AddAttr(N,+"n",Str_Function_Name(Subprg));  -- f:n
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            AddAttr(N,+"typ",+("procedure"));
            AddAttr(N,+"n",Str_Identifier(Subprg));  -- f:n
         when others =>
            raise Internal_Error;
      end case;

      Disp_Interface_Chain (N,NewN(N,+"-")
,Get_Interface_Declaration_Chain (Subprg), "");

      case Get_Kind (Subprg) is
         when Iir_Kind_Function_Declaration
           | Iir_Kind_Implicit_Function_Declaration =>
            null;--            Put (" return ");
            Disp_Type (N,NewN(N,+"rtyp"),Get_Return_Type (Subprg))
; --p:rtyp
         when Iir_Kind_Procedure_Declaration
           | Iir_Kind_Implicit_Procedure_Declaration =>
            null;
         when others =>
            raise Internal_Error;
      end case;
   end Disp_Subprogram_Declaration;

   procedure Disp_Subprogram_Body (P,N:X;Subprg : Iir)
   is
      pragma Unreferenced (P);
      Decl : Iir;
      Indent : Count;
   begin
      SetId(N,Subprg);
      SetTag(N.all,+"subprogram_body");
      Decl := Get_Subprogram_Specification (Subprg);
      Indent := Col;
      if Get_Chain (Decl) /= Subprg then
         Disp_Subprogram_Declaration (N,NewN(N,+"-"),Decl);
      end if;
      null;--      Put_Line ("is");
      null;--      Set_Col (Indent);
      Disp_Declaration_Chain (N,NewN(N,+"decl"),Subprg
, Indent + Indentation); -- p:decl
      null;--      Set_Col (Indent);
      null;--      Put_Line ("begin");
      null;--      Set_Col (Indent + Indentation);
      Disp_Sequential_Statements (N,NewN(N,+"b")
,Get_Sequential_Statement_Chain (Subprg)); -- p:b
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end;");
      null;--      New_Line;
   end Disp_Subprogram_Body;

   procedure Disp_Instantiation_List (P,N:X;Insts: Iir_List) is
      pragma Unreferenced (P);
      El : Iir;
      Ec : X;
   begin
      SetTag(N.all,+"instantiation_list");
      if Insts = Iir_List_All then
         AddAttr(N,+"typ",+("all"));
      elsif Insts = Iir_List_Others then
         AddAttr(N,+"typ",+("others"));
      else
         for I in Natural loop -- chain:[v=Ec|n=instantiation]
            Ec := NewN(N,+"-");
            SetTag(Ec.all,+"instantiation");
            El := Get_Nth_Element (Insts, I);
            if El = Null_Iir then
               RemFrom(N,Ec);
            end if;
            exit when El = Null_Iir; --exitchain:Ec
            if I /= Natural'First then
               null;--               Put (", ");
            end if;
            AddAttr(Ec,+"n",Str_Name_Of(El)); --f:n
         end loop;
      end if;
   end Disp_Instantiation_List;

   procedure Disp_Configuration_Specification
     (P,N:X;Spec : Iir_Configuration_Specification)
   is
      pragma Unreferenced (P);
      Indent : Count;
   begin
      SetTag(N.all,+"configuration_specification");
      Indent := Col;
      null;--      Put ("for ");
      Disp_Instantiation_List (N,NewN(N,+"-"),Get_Instantiation_List (Spec))
;
      null;--      Put (": ");
      AddAttr(N,+"n",Str_Name_Of(Get_Component_Name (Spec))); -- f:n
      null;--      New_Line;
      Disp_Binding_Indication (N,NewN(N,+"-"),Get_Binding_Indication (Spec),
                               Indent + Indentation);
      null;--      Put_Line (";");
   end Disp_Configuration_Specification;

   procedure Disp_Disconnection_Specification
     (P,N:X;Dis : Iir_Disconnection_Specification)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"disconnection_specification");
      null;--      Put ("disconnect ");
      Disp_Instantiation_List (N,NewN(N,+"-"),Get_Signal_List (Dis));
      null;--      Put (": ");
      Disp_Subtype_Indication (N,NewN(N,+"-"),Get_Type (Dis));
      null;--      Put (" after ");
      Disp_Expression (N,NewN(N,+"-"),Get_Expression (Dis));
      null;--      Put_Line (";");
   end Disp_Disconnection_Specification;

   procedure Disp_Attribute_Declaration (P,N:X
;Attr : Iir_Attribute_Declaration)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"attribute_declaration");
      null;--      Put ("attribute ");
      AddAttr(N,+"n",Str_Identifier(Attr)); -- f:n
      null;--      Put (": ");
      Disp_Type (N,NewN(N,+"-"),Get_Type (Attr));
      null;--      Put_Line (";");
   end Disp_Attribute_Declaration;

   procedure Disp_Entity_Kind (P,N:X;Tok : Tokens.Token_Type) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"entity_kind");
      Put (Tokens.Image (Tok));
   end Disp_Entity_Kind;
   pragma Unreferenced (Disp_Entity_Kind);
   procedure Disp_Entity_Name_List (P,N:X;List : Iir_List)
   is
      pragma Unreferenced (P);
      El : Iir;
      Ec : X;
   begin
      SetTag(N.all,+"entity_name_list");
      for I in Natural loop -- chain:[v=Ec|n=Name]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Name");
         El := Get_Nth_Element (List, I);
         if El = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when El = Null_Iir; --exitchain:Ec
         if I /= 0 then
            null;--            Put (", ");
         end if;
         AddAttr(Ec,+"n",Str_Name_Of(El)); -- f:n
      end loop;
   end Disp_Entity_Name_List;

   procedure Disp_Attribute_Specification (P,N:X
;Attr : Iir_Attribute_Specification)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"attribute_specification");
      null;--      Put ("attribute ");
      AddAttr(N,+"n",Str_Identifier(Get_Attribute_Designator (Attr)))
; -- f:n
      null;--      Put (" of ");
      Disp_Entity_Name_List (N,NewN(N,+"-"),Get_Entity_Name_List (Attr));
      null;--      Put (": ");
      AddAttr(N,+"kind",Str_Entity_Kind(Get_Entity_Class (Attr))); --f:kind
      null;--      Put (" is ");
      Disp_Expression (N,NewN(N,+"-"),Get_Expression (Attr));
      null;--      Put_Line (";");
   end Disp_Attribute_Specification;

   procedure Disp_Protected_Type_Body
     (P,N:X;Bod : Iir_Protected_Type_Body; Indent : Count)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"protected_type_body");
      null;--      Put ("type ");
      AddAttr(N,+"n",Str_Identifier(Bod)); -- f:n
      null;--      Put (" is protected body");
      null;--      New_Line;
      Disp_Declaration_Chain (N,NewN(N,+"-"),Bod, Indent + Indentation);
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end protected body;");
   end Disp_Protected_Type_Body;

   procedure Disp_Declaration_Chain (P,N:X;Parent : Iir; Indent: Count)
   is
      pragma Unreferenced (P);
      Decl: Iir;
   begin
      SetId(N,Parent);
      SetTag(N.all,+"declaration_chain");
      Decl := Get_Declaration_Chain (Parent);
      while Decl /= Null_Iir loop
         null;--         Set_Col (Indent);
         case Get_Kind (Decl) is
            when Iir_Kind_Type_Declaration =>
               Disp_Type_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Anonymous_Type_Declaration =>
               Disp_Anonymous_Type_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Subtype_Declaration =>
               Disp_Subtype_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Use_Clause =>
               Disp_Use_Clause (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Component_Declaration =>
               Disp_Component_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kinds_Object_Declaration =>
               Disp_Object_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Non_Object_Alias_Declaration =>
               Disp_Non_Object_Alias_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Implicit_Function_Declaration
              | Iir_Kind_Implicit_Procedure_Declaration =>
               Disp_Subprogram_Declaration (N,NewN(N,+"-"),Decl);
               null;--               Put_Line (";");
            when Iir_Kind_Function_Declaration
              | Iir_Kind_Procedure_Declaration =>
               Disp_Subprogram_Declaration (N,NewN(N,+"-"),Decl);
               if Get_Subprogram_Body (Decl) = Null_Iir
                 or else Get_Subprogram_Body (Decl) /= Get_Chain (Decl)
               then
                  null;--                  Put_Line (";");
               end if;
            when Iir_Kind_Function_Body
              | Iir_Kind_Procedure_Body =>
               Disp_Subprogram_Body (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Protected_Type_Body =>
               Disp_Protected_Type_Body (N,NewN(N,+"-"),Decl, Indent);
            when Iir_Kind_Configuration_Specification =>
               Disp_Configuration_Specification (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Disconnection_Specification =>
               Disp_Disconnection_Specification (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Attribute_Declaration =>
               Disp_Attribute_Declaration (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Attribute_Specification =>
               Disp_Attribute_Specification (N,NewN(N,+"-"),Decl);
            when Iir_Kinds_Signal_Attribute =>
               null;
            when others =>
               Error_Kind ("disp_declaration_chain", Decl);
         end case;
         Decl := Get_Chain (Decl);
      end loop;
   end Disp_Declaration_Chain;

   procedure Disp_Waveform (P,N:X;Chain : Iir_Waveform_Element)
   is
      pragma Unreferenced (P);
      We: Iir_Waveform_Element;
      Val : Iir;
      Ec : X;
   begin
      SetTag(N.all,+"waveform");
      if Chain = Null_Iir then
         null;--         Put ("null after {disconnection_time}");
         return;
      end if;
      We := Chain;
      while We /= Null_Iir loop -- chain:[v=Ec|n=waveelem]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"waveelem");
         if We /= Chain then
            null;--            Put (", ");
         end if;
         Val := Get_We_Value (We);
         Disp_Expression (Ec,NewN(Ec,+"-"),Val);
         if Get_Time (We) /= Null_Iir then
            AddAttr(Ec,+"at",+(" after"));
            Disp_Expression (Ec,NewN(Ec,+"-"),Get_Time (We));
         end if;
         We := Get_Chain (We);
      end loop;
   end Disp_Waveform;

   procedure Disp_Delay_Mechanism (P,N:X;Stmt: Iir) is
      pragma Unreferenced (P);
      Expr: Iir;
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"delay_mechanism");
      case Get_Delay_Mechanism (Stmt) is
         when Iir_Transport_Delay =>
            null;--            Put ("transport ");
         when Iir_Inertial_Delay =>
            Expr := Get_Reject_Time_Expression (Stmt);
            if Expr /= Null_Iir then
               null;--               Put ("reject ");
               Disp_Expression (N,NewN(N,+"-"),Expr);
               null;--               Put (" inertial ");
            end if;
      end case;
   end Disp_Delay_Mechanism;

   procedure Disp_Signal_Assignment (P,N:X;Stmt: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"signal_assignment");
      Disp_Expression (N,NewN(N,+"-"),Get_Target (Stmt));
      null;--      Put (" <= ");
      Disp_Delay_Mechanism (N,NewN(N,+"-"),Stmt);
      Disp_Waveform (N,NewN(N,+"-"),Get_Waveform_Chain (Stmt));
      null;--      Put_Line (";");
   end Disp_Signal_Assignment;

   procedure Disp_Variable_Assignment (P,N:X;Stmt: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"variable_assignment");
      Disp_Expression (N,NewN(N,+"-"),Get_Target (Stmt));
      null;--      Put (" := ");
      Disp_Expression (N,NewN(N,+"-"),Get_Expression (Stmt));
      null;--      Put_Line (";");
   end Disp_Variable_Assignment;

   --  procedure Disp_Label (N,NewN(N,+"-"),Label: Name_Id) is
   --  begin
   --     if Label /= Null_Identifier then
   --        Disp_Ident (N,NewN(N,+"-"),Label);
   --        Put (": ");
   --     end if;
   --  end Disp_Label;

   procedure Disp_Concurrent_Selected_Signal_Assignment (P,N:X;Stmt: Iir)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Assoc: Iir;
      Assoc_Chain : Iir;
      pragma Unreferenced (Indent);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"concurrent_selected_signal_assignment");
      Indent := Col;
      null;--      Set_Col (Indent);
      AddAttr(N,+"lab",Str_Label( (Stmt))); -- f:lab
      null;--      Put ("with ");
      Disp_Expression (N,NewN(N,+"-"),Get_Expression (Stmt));
      null;--      Put (" select ");
      Disp_Expression (N,NewN(N,+"-"),Get_Target (Stmt));
      null;--      Put (" <= ");
      if Get_Guard (Stmt) /= Null_Iir then
         null;--         Put ("guarded ");
      end if;
      Disp_Delay_Mechanism (N,NewN(N,+"-"),Stmt);
      Assoc_Chain := Get_Selected_Waveform_Chain (Stmt);
      Assoc := Assoc_Chain;
      while Assoc /= Null_Iir loop
         if Assoc /= Assoc_Chain then
            null;--            Put_Line (",");
         end if;
         null;--         Set_Col (Indent + Indentation);
         Disp_Waveform (N,NewN(N,+"-"),Get_Associated (Assoc));
         null;--         Put (" when ");
         Disp_Choice (N,NewN(N,+"-"),Assoc);
      end loop;
      null;--      Put_Line (";");
   end Disp_Concurrent_Selected_Signal_Assignment;

   procedure Disp_Concurrent_Conditional_Signal_Assignment (P,N:X;Stmt: Iir)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Cond_Wf : Iir_Conditional_Waveform;
      Expr : Iir;
      pragma Unreferenced (Indent);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"concurrent_conditional_signal_assignment");
      AddAttr(N,+"lab",Str_Label( (Stmt))); -- f:lab
      Disp_Expression (N,NewN(N,+"-"),Get_Target (Stmt));
      null;--      Put (" <= ");
      if Get_Guard (Stmt) /= Null_Iir then
         null;--         Put ("guarded ");
      end if;
      Disp_Delay_Mechanism (N,NewN(N,+"-"),Stmt);
      Indent := Col;
      null;--      Set_Col (Indent);
      Cond_Wf := Get_Conditional_Waveform_Chain (Stmt);
      while Cond_Wf /= Null_Iir loop
         Disp_Waveform (N,NewN(N,+"-"),Get_Waveform_Chain (Cond_Wf));
         Expr := Get_Condition (Cond_Wf);
         if Expr /= Null_Iir then
            null;--            Put (" when ");
            Disp_Expression (N,NewN(N,+"-"),Expr);
            null;--            Put_Line (" else");
            null;--            Set_Col (Indent);
         end if;
         Cond_Wf := Get_Chain (Cond_Wf);
      end loop;

      null;--      Put_Line (";");
   end Disp_Concurrent_Conditional_Signal_Assignment;

   procedure Disp_Assertion_Statement (P,N:X;Stmt: Iir) is
      pragma Unreferenced (P);
      Start: Count;
      Expr: Iir;
      pragma Unreferenced (Start);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"assertion_statement");
      Start := Col;
      if Get_Kind (Stmt) = Iir_Kind_Concurrent_Assertion_Statement then
         AddAttr(N,+"lab",Str_Label( (Stmt))); -- f:lab
      end if;
      null;--      Put ("assert ");
      Disp_Expression (N,NewN(N,+"-"),Get_Assertion_Condition (Stmt));
      Expr := Get_Report_Expression (Stmt);
      if Expr /= Null_Iir then
         null;--         Set_Col (Start + Indentation);
         null;--         Put ("report ");
         Disp_Expression (N,NewN(N,+"-"),Expr);
      end if;
      Expr := Get_Severity_Expression (Stmt);
      if Expr /= Null_Iir then
         null;--         Set_Col (Start + Indentation);
         null;--         Put ("severity ");
         Disp_Expression (N,NewN(N,+"-"),Expr);
      end if;
      null;--      Put_Line (";");
   end Disp_Assertion_Statement;

   procedure Disp_Report_Statement (P,N:X;Stmt: Iir)
   is
      pragma Unreferenced (P);
      Start: Count;
      Expr: Iir;
      pragma Unreferenced (Start);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"report_statement");
      Start := Col;
      null;--      Put ("report ");
      Expr := Get_Report_Expression (Stmt);
      Disp_Expression (N,NewN(N,+"-"),Expr);
      Expr := Get_Severity_Expression (Stmt);
      if Expr /= Null_Iir then
         null;--         Set_Col (Start + Indentation);
         null;--         Put ("severity ");
         Disp_Expression (N,NewN(N,+"-"),Expr);
      end if;
      null;--      Put_Line (";");
   end Disp_Report_Statement;

   procedure Disp_Dyadic_Operator (P,N:X;Expr: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Expr);
      SetTag(N.all,+"dyadic_operator");
      null;--      Put ("(");
      Disp_Expression (N,NewN(N,+"l"),Get_Left (Expr));  -- p:l
      AddAttr(N,+"op"
,+( Name_Table.Image (Iirs_Utils.Get_Operator_Name (Expr)) ));
      Disp_Expression (N,NewN(N,+"r"),Get_Right (Expr)); -- p:r
      null;--      Put (")");
   end Disp_Dyadic_Operator;

   procedure Disp_Monadic_Operator (P,N:X;Expr: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Expr);
      SetTag(N.all,+"monadic_operator");
      AddAttr(N,+"op"
,+(Name_Table.Image (Iirs_Utils.Get_Operator_Name (Expr))));
      null;--      Put (" (");
      Disp_Expression (N,NewN(N,+"u"),Get_Operand (Expr)); -- p:u
      null;--      Put (")");
   end Disp_Monadic_Operator;

   procedure Disp_Case_Statement (P,N:X;Stmt: Iir_Case_Statement)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Assoc: Iir;
      Sel_Stmt : Iir;
      Ec : X;
      pragma Unreferenced (Indent);
   begin
      SetTag(N.all,+"case_statement");
      Indent := Col;
      null;--      Put ("case ");
      Disp_Expression (N,NewN(N,+"e"),Get_Expression (Stmt)); -- p:e
      null;--      Put_Line (" is");
      Assoc := Get_Case_Statement_Alternative_Chain (Stmt);
      while Assoc /= Null_Iir loop -- chain:[v=Ec|n=Choice]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Choice");
         null;--         Set_Col (Indent + Indentation);
         null;--         Put ("when ");
         Sel_Stmt := Get_Associated (Assoc);
         Disp_Choice (Ec,NewN(Ec,+"v"),Assoc); -- p:v
         null;--         Put_Line (" =>");
         null;--         Set_Col (Indent + 2 * Indentation);
         Disp_Sequential_Statements (Ec,NewN(Ec,+"b"),Sel_Stmt); -- p:b
      end loop;
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end case;");
   end Disp_Case_Statement;

   procedure Disp_Wait_Statement (P,N:X;Stmt: Iir_Wait_Statement) is
      pragma Unreferenced (P);
      List: Iir_List;
      Expr: Iir;
   begin
      SetTag(N.all,+"wait_statement");
      null;--      Put ("wait");
      List := Get_Sensitivity_List (Stmt);
      if List /= Null_Iir_List then
         null;--         Put (" on ");
         Disp_Designator_List (N,NewN(N,+"-"),List);
      end if;
      Expr := Get_Condition_Clause (Stmt);
      if Expr /= Null_Iir then
         null;--         Put (" until ");
         Disp_Expression (N,NewN(N,+"-"),Expr);
      end if;
      Expr := Get_Timeout_Clause (Stmt);
      if Expr /= Null_Iir then
         null;--         Put (" for ");
         Disp_Expression (N,NewN(N,+"-"),Expr);
      end if;
      null;--      Put_Line (";");
   end Disp_Wait_Statement;

   procedure Disp_If_Statement (P,N:X;Stmt: Iir_If_Statement) is
      pragma Unreferenced (P);
      Clause: Iir;
      Expr: Iir;
      Start: Count;
      Ec : X;
      pragma Unreferenced (Start);
   begin
      SetTag(N.all,+"if_statement");
      Ec := NewN(N,+"-");
      SetTag(Ec.all,+"clause");
      Start := Col; -- open:[v=Ec|n=clause]
      AddAttr(Ec,+"ctyp",+("if"));
      Clause := Stmt;
      Disp_Expression (Ec,NewN(Ec,+"e"),Get_Condition (Clause)); -- p:e
      null;--      Put_Line (" then");
      while Clause /= Null_Iir loop -- none
         null;--         Set_Col (Start + Indentation);
         Disp_Sequential_Statements (Ec,NewN(Ec,+"b")
,Get_Sequential_Statement_Chain (Clause)); -- p:b
         Clause := Get_Else_Clause (Clause);
         exit when Clause = Null_Iir;
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"clause");
         Expr := Get_Condition (Clause); -- reopen:[v=Ec|n=clause]
         null;--         Set_Col (Start);
         if Expr /= Null_Iir then
            AddAttr(Ec,+"ctyp",+("elsif"));
            Disp_Expression (Ec,NewN(Ec,+"e"),Expr); -- p:e
            null;--            Put_Line (" then");
         else
            AddAttr(Ec,+"ctyp",+("else"));
         end if;
      end loop;
      null;--      Set_Col (Start); --close:clause
      null;--      Put_Line ("end if;");
   end Disp_If_Statement;

   procedure Disp_Iterator (P,N:X;Iterator: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Iterator);
      SetTag(N.all,+"iterator");
      Disp_Subtype_Indication (N,NewN(N,+"-"),Iterator);
   end Disp_Iterator;

   procedure Disp_Parameter_Specification
     (P,N:X;Iterator : Iir_Iterator_Declaration) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"parameter_specification");
      AddAttr(N,+"n",Str_Identifier(Iterator)); -- f:n
      null;--      Put (" in ");
      Disp_Iterator (N,NewN(N,+"-"),Get_Type (Iterator));
   end Disp_Parameter_Specification;

   procedure Disp_Procedure_Call (P,N:X;Call : Iir)
   is
      pragma Unreferenced (P);
      Obj : Iir;
   begin
      SetId(N,Call);
      SetTag(N.all,+"procedure_call");
      Obj := Get_Method_Object (Call);
      if Obj /= Null_Iir then
         AddAttr(N,+"obj",Str_Name(Obj)); -- f:obj
         null;--         Put ('.');
      end if;
      AddAttr(N,+"n",Str_Identifier(Get_Implementation (Call))); -- f:n
      null;--      Put (' ');
      Disp_Association_Chain (N,NewN(N,+"-")
,Get_Parameter_Association_Chain (Call));
      null;--      Put_Line (";");
   end Disp_Procedure_Call;

   procedure Disp_Sequential_Statements (P,N:X;First : Iir)
   is
      pragma Unreferenced (P);
      Stmt: Iir;
      Start: Count;
      Ec : X;
      pragma Unreferenced (Start);
   begin
      SetId(N,First);
      SetTag(N.all,+"sequential_statements");
      Start := Col;
      Stmt := First;
      while Stmt /= Null_Iir loop
         null;--         Set_Col (Start);
         case Get_Kind (Stmt) is
            when Iir_Kind_Null_Statement =>
               null;--               Put_Line ("null;");
            when Iir_Kind_If_Statement =>
               Disp_If_Statement (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_For_Loop_Statement =>
               Ec := NewN(N,+"-");
               SetTag(Ec.all,+"loop");
               AddAttr(Ec,+"typ",+("for"));
               Disp_Parameter_Specification(Ec,NewN(Ec,+"param")
,Get_Iterator_Scheme(Stmt));--p:param
               null;--               Put_Line (" loop");
               null;--               Set_Col (Start + Indentation);
               Disp_Sequential_Statements(Ec,NewN(Ec,+"-")
,Get_Sequential_Statement_Chain (Stmt));
               null;--               Set_Col (Start);
               null;--               Put_Line ("end loop;"); --close:loop
            when Iir_Kind_While_Loop_Statement =>
               Ec := NewN(N,+"-");
               SetTag(Ec.all,+"while");
               AddAttr(Ec,+"typ",+("while"));
               if Get_Condition (Stmt) /= Null_Iir then
                  null;--                  Put ("while ");
                  Disp_Expression (Ec,NewN(Ec,+"param")
,Get_Condition (Stmt)); -- p:param
                  null;--                  Put (" ");
               end if;
               null;--               Put_Line ("loop");
               null;--               Set_Col (Start + Indentation);
               Disp_Sequential_Statements(Ec,NewN(Ec,+"-")
,Get_Sequential_Statement_Chain (Stmt));
               null;--               Set_Col (Start);
               null;--               Put_Line ("end loop;"); --close:while
            when Iir_Kind_Signal_Assignment_Statement =>
               Disp_Signal_Assignment (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_Variable_Assignment_Statement =>
               Disp_Variable_Assignment (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_Assertion_Statement =>
               Disp_Assertion_Statement (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_Report_Statement =>
               Disp_Report_Statement (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_Return_Statement =>
               if Get_Expression (Stmt) /= Null_Iir then-- open:[v=Ec|n=return]

                  null;--                  Put ("return ");
                  Disp_Expression (N,NewN(N,+"-"),Get_Expression (Stmt));
                  null;--                  Put_Line (";");
               else
                  null;--                  Put_Line ("return;");
               end if; --close:loop
            when Iir_Kind_Case_Statement =>
               Disp_Case_Statement (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_Wait_Statement =>
               Disp_Wait_Statement (N,NewN(N,+"-"),Stmt);
            when Iir_Kind_Procedure_Call_Statement =>
               Disp_Procedure_Call (N,NewN(N,+"-"),Get_Procedure_Call (Stmt))
;
            when Iir_Kind_Exit_Statement
              | Iir_Kind_Next_Statement =>
               if Get_Kind (Stmt) = Iir_Kind_Exit_Statement then
                  Ec := NewN(N,+"-");
                  SetTag(Ec.all,+"break");
                  AddAttr(Ec,+"typ",+("exit"));
               else
                  Ec := NewN(Ec,+"-");
                  SetTag(Ec.all,+"break");
                  AddAttr(Ec,+"typ",+("next"));
               end if;
               -- FIXME: label.
               if Get_Condition (Stmt) /= Null_Iir then
                  null;--                  Put (" when ");
                  Disp_Expression (Ec,NewN(Ec,+"-"),Get_Condition (Stmt));
               end if;
               null;--               Put_Line (";"); --close:loop

            when others =>
               Error_Kind ("disp_sequential_statements", Stmt);
         end case;
         Stmt := Get_Chain (Stmt);
      end loop;
   end Disp_Sequential_Statements;

   procedure Disp_Process_Statement (P,N:X;Process: Iir)
   is
      pragma Unreferenced (P);
      Start: Count;
   begin
      SetId(N,Process);
      SetTag(N.all,+"process_statement");
      Start := Col;
      AddAttr(N,+"lab",Str_Label( (Process))); -- f:lab

      null;--      Put ("process ");
      if Get_Kind (Process) = Iir_Kind_Sensitized_Process_Statement then
         null;--         Put ("(");
         Disp_Designator_List (N,NewN(N,+"-"),Get_Sensitivity_List (Process))
;
         null;--         Put (")");
      end if;
      if Vhdl_Std >= Vhdl_93 then
         null;--         Put_Line (" is");
      else
         null;--         New_Line;
      end if;
      Disp_Declaration_Chain (N,NewN(N,+"-"),Process, Start + Indentation);
      null;--      Set_Col (Start);
      null;--      Put_Line ("begin");
      null;--      Set_Col (Start + Indentation);
      Disp_Sequential_Statements (N,NewN(N,+"-")
,Get_Sequential_Statement_Chain (Process));
      null;--      Set_Col (Start);
      null;--      Put_Line ("end process;");
   end Disp_Process_Statement;

   procedure Disp_Association_Chain (P,N:X;Chain : Iir)
   is
      pragma Unreferenced (P);
      El: Iir;
      Formal: Iir;
      Need_Comma : Boolean;
      Conv : Iir;
      Ec : X;
   begin
      SetId(N,Chain);
      SetTag(N.all,+"association_chain");
      if Chain = Null_Iir then
         return;
      end if;
      null;--      Put ("(");
      Need_Comma := False;

      El := Chain;
      while El /= Null_Iir loop -- chain:[v=Ec|n=Association]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Association");
         if Get_Kind (El) /= Iir_Kind_Association_Element_By_Individual then
            if Need_Comma then
               null;--               Put (", ");
            end if;
            if Get_Kind (El) = Iir_Kind_Association_Element_By_Expression then

               Conv := Get_Out_Conversion (El);
               if Conv /= Null_Iir then
                  AddAttr(Ec,+"from",Str_Function_Name(Conv)); -- f:from
                  null;--                  Put (" (");
               end if;
            else
               Conv := Null_Iir;
            end if;
            Formal := Get_Formal (El);
            if Formal /= Null_Iir then
               Disp_Expression (Ec,NewN(Ec,+"-"),Formal);
               if Conv /= Null_Iir then
                  null;--                  Put (")");
               end if;
               null;--               Put (" => ");
            end if;
            if Get_Kind (El) = Iir_Kind_Association_Element_Open then
               null;--               Put ("open");
            else
               Conv := Get_In_Conversion (El);
               if Conv /= Null_Iir then
                  AddAttr(Ec,+"to",Str_Function_Name(Conv)); -- f:to
                  null;--                  Put (" (");
               end if;
               Disp_Expression (Ec,NewN(Ec,+"-"),Get_Actual (El));
               if Conv /= Null_Iir then
                  null;--                  Put (")");
               end if;
            end if;
            Need_Comma := True;
         end if;
         El := Get_Chain (El);
      end loop;
      null;--      Put (")");
   end Disp_Association_Chain;

   procedure Disp_Generic_Map_Aspect (P,N:X;Parent : Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Parent);
      SetTag(N.all,+"generic_map_aspect");
      null;--      Put ("generic map ");
      Disp_Association_Chain (N,NewN(N,+"-")
,Get_Generic_Map_Aspect_Chain (Parent));
   end Disp_Generic_Map_Aspect;

   procedure Disp_Port_Map_Aspect (P,N:X;Parent : Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Parent);
      SetTag(N.all,+"port_map_aspect");
      null;--      Put ("port map ");
      Disp_Association_Chain (N,NewN(N,+"-")
,Get_Port_Map_Aspect_Chain (Parent));
   end Disp_Port_Map_Aspect;

   procedure Disp_Entity_Aspect (P,N:X;Aspect : Iir) is
      pragma Unreferenced (P);
      Arch : Iir;
   begin
      SetId(N,Aspect);
      SetTag(N.all,+"entity_aspect");
      ChangeTag(N,Aspect);
      AddAttr(N,+"typ",+"aspect");
      case Get_Kind (Aspect) is -- rename:Aspect,flags:[typ=aspect]
         when Iir_Kind_Entity_Aspect_Entity =>
            null;--            Put ("entity ");
            AddAttr(N,+"n",Str_Name_Of(Get_Entity (Aspect))); -- f:n
            Arch := Get_Architecture (Aspect);
            if Arch /= Null_Iir then
               null;--               Put (" (");
               AddAttr(N,+"arch",Str_Name_Of(Arch)); -- f:arch
               null;--               Put (")");
            end if;
         when Iir_Kind_Entity_Aspect_Configuration =>
            null;--            Put ("configuration ");
            AddAttr(N,+"n",Str_Name_Of(Get_Configuration (Aspect))); -- f:n
         when Iir_Kind_Entity_Aspect_Open =>
            null;--            Put ("open");
         when others =>
            Error_Kind ("disp_entity_aspect", Aspect);
      end case;
   end Disp_Entity_Aspect;

   procedure Disp_Component_Instantiation_Statement
     (P,N:X;Stmt: Iir_Component_Instantiation_Statement)
   is
      pragma Unreferenced (P);
      Component: Iir;
      Alist: Iir;
   begin
      SetTag(N.all,+"component_instantiation_statement");
      AddAttr(N,+"lab",Str_Label( (Stmt))); -- f:lab
      Component := Get_Instantiated_Unit (Stmt);
      if Get_Kind (Component) = Iir_Kind_Component_Declaration then
         AddAttr(N,+"n",Str_Name_Of(Component)); -- f:n
      else
         Disp_Entity_Aspect (N,NewN(N,+"-"),Component);
      end if;
      Alist := Get_Generic_Map_Aspect_Chain (Stmt);
      if Alist /= Null_Iir then
         null;--         Put (" ");
         Disp_Generic_Map_Aspect (N,NewN(N,+"-"),Stmt);
      end if;
      Alist := Get_Port_Map_Aspect_Chain (Stmt);
      if Alist /= Null_Iir then
         null;--         Put (" ");
         Disp_Port_Map_Aspect (N,NewN(N,+"-"),Stmt);
      end if;
      null;--      Put (";");
   end Disp_Component_Instantiation_Statement;

   procedure Disp_Function_Call (P,N:X;Expr: Iir_Function_Call) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"function_call");
      AddAttr(N,+"n",Str_Function_Name(Get_Implementation (Expr))); -- f:n
      Disp_Association_Chain (N,NewN(N,+"-")
,Get_Parameter_Association_Chain (Expr));
   end Disp_Function_Call;

   procedure Disp_Indexed_Name (P,N:X;Indexed: Iir)
   is
      pragma Unreferenced (P);
      List : Iir_List;
      El: Iir;
      Ec : X;
   begin
      SetId(N,Indexed);
      SetTag(N.all,+"indexed_name");
      Disp_Expression (N,NewN(N,+"-"),Get_Prefix (Indexed));
      null;--      Put (" (");
      List := Get_Index_List (Indexed);
      for I in Natural loop -- chain:[v=Ec|n=Name]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Name");
         El := Get_Nth_Element (List, I);
         if El = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when El = Null_Iir; --exitchain:Ec
         if I /= 0 then
            null;--            Put (", ");
         end if;
         Disp_Expression (Ec,NewN(Ec,+"-"),El);
      end loop;
      null;--      Put (")");
   end Disp_Indexed_Name;

   procedure Disp_Choice (P,N:X;Choice: in out Iir) is
      pragma Unreferenced (P);
      Ec : X;
   begin
      SetTag(N.all,+"choice");
      loop -- chain:[v=Ec|n=Choice]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"Choice");
         case Get_Kind (Choice) is
            when Iir_Kind_Choice_By_Others =>
               AddAttr(Ec,+"val",+("others"));
            when Iir_Kind_Choice_By_None =>
               null;
            when Iir_Kind_Choice_By_Expression =>
               Disp_Expression (Ec,NewN(Ec,+"-"),Get_Expression (Choice));
            when Iir_Kind_Choice_By_Range =>
               Disp_Range (Ec,NewN(Ec,+"-"),Get_Expression (Choice));
            when Iir_Kind_Choice_By_Name =>
               AddAttr(Ec,+"val",Str_Name_Of(Get_Name (Choice))); -- f:val
            when others =>
               Error_Kind ("disp_choice", Choice);
         end case;
         Choice := Get_Chain (Choice);
         exit when Choice = Null_Iir;
         exit when Get_Same_Alternative_Flag (Choice) = False;
         --exit when Choice = Null_Iir;
         null;--         Put (" | ");
      end loop;
   end Disp_Choice;

   procedure Disp_Aggregate (P,N:X;Aggr: Iir_Aggregate)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Assoc: Iir;
      Expr : Iir;
      Ec : X;
      pragma Unreferenced (Indent);
   begin
      SetTag(N.all,+"aggregate");
      null;--      Put ("(");
      Indent := Col;
      Assoc := Get_Association_Choices_Chain (Aggr);
      loop -- chain:[v=Ec|n=AggE]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"AggE");
         Expr := Get_Associated (Assoc);
         if Get_Kind (Assoc) /= Iir_Kind_Choice_By_None then
            Disp_Choice (Ec,NewN(Ec,+"-"),Assoc);
            null;--            Put (" => ");
         else
            Assoc := Get_Chain (Assoc);
         end if;
         if Get_Kind (Expr) = Iir_Kind_Aggregate
           or else Get_Kind (Expr) = Iir_Kind_String_Literal then
            null;--            Set_Col (Indent);
         end if;
         Disp_Expression (Ec,NewN(Ec,+"-"),Expr);
         exit when Assoc = Null_Iir;
         null;--         Put (", ");
      end loop;
      null;--      Put (")");
   end Disp_Aggregate;

   procedure Disp_Simple_Aggregate (P,N:X;Aggr: Iir_Simple_Aggregate)
   is
      pragma Unreferenced (P);
      List : Iir_List;
      El : Iir;
      First : Boolean := True;
      Ec : X;
   begin
      SetTag(N.all,+"simple_aggregate");
      null;--      Put ("(");
      List := Get_Simple_Aggregate_List (Aggr);
      for I in Natural loop -- chain:[v=Ec|n=AggE]
         Ec := NewN(N,+"-");
         SetTag(Ec.all,+"AggE");
         El := Get_Nth_Element (List, I);
         if El = Null_Iir then
            RemFrom(N,Ec);
         end if;
         exit when El = Null_Iir; --exitchain:Ec
         if First then
            First := False;
         else
            null;--            Put (", ");
         end if;
         Disp_Expression (Ec,NewN(Ec,+"-"),El);
      end loop;
      null;--      Put (")");
   end Disp_Simple_Aggregate;

   procedure Disp_Parametered_Attribute (P,N:X;Name : String; Expr : Iir)
   is
      pragma Unreferenced (P);
      Param : Iir;
      Pfx : Iir;
   begin
      SetTag(N.all,+"parametered_attribute");
      Pfx := Get_Prefix (Expr);
      case Get_Kind (Pfx) is
         when Iir_Kind_Type_Declaration
           | Iir_Kind_Subtype_Declaration =>
            AddAttr(N,+"n",Str_Name_Of(Pfx)); -- f:n
         when others =>
            Disp_Expression (N,NewN(N,+"-"),Pfx);
      end case;
      null;--      Put ("'");
      AddAttr(N,+"attribute",+(Name));
      Param := Get_Parameter (Expr);
      if Param /= Null_Iir then
         null;--         Put (" (");
         Disp_Expression (N,NewN(N,+"-"),Param);
         null;--         Put (")");
      end if;
   end Disp_Parametered_Attribute;

   procedure Disp_String_Literal (P,N:X;Str : Iir)
   is
      pragma Unreferenced (P);
      Ptr : String_Fat_Acc;
      Len : Int32;
   begin
      SetId(N,Str);
      SetTag(N.all,+"string_literal");
      Ptr := Get_String_Fat_Acc (Str);
      Len := Get_String_Length (Str);
      Put (String (Ptr (1 .. Len)));
   end Disp_String_Literal;
   pragma Unreferenced (Disp_String_Literal);

   procedure Disp_Expression (P,N:X;Expr: Iir)
   is
      Orig : Iir;
   begin
      SetId(N,Expr);
      SetTag(N.all,+"expression");
      ChangeTag(N,Expr);
      AddAttr(N,+"typ",+"expr");
      case Get_Kind (Expr) is -- rename:Expr,flags:[typ=expr]
         when Iir_Kind_Integer_Literal =>
            Orig := Get_Literal_Origin (Expr);
            if Orig /= Null_Iir then
               Disp_Expression (P,N,Orig); --reent:1
            else
               AddAttr(N,+"val",Str_Int64(Get_Value (Expr))); -- f:val
            end if;
         when Iir_Kind_Floating_Point_Literal =>
            Orig := Get_Literal_Origin (Expr);
            if Orig /= Null_Iir then
               Disp_Expression (P,N,Orig); --reent:1
            else
               AddAttr(N,+"val",Str_Fp64(Get_Fp_Value (Expr))); -- f:val
            end if;
         when Iir_Kind_String_Literal =>
            null;--            Put (""""); -- nop:1
            AddAttr(N,+"val",Str_String_Literal(Expr)); -- f:val
            null;--            Put (""""); -- nop:1
            if Disp_String_Literal_Type or Flags.List_Verbose then
               null;--               Put ("[type: ");
               Disp_Type (N,NewN(N,+"-"),Get_Type (Expr));
               null;--               Put ("]");
            end if;
         when Iir_Kind_Bit_String_Literal =>
            if False then
               case Get_Bit_String_Base (Expr) is
                  when Base_2 =>
                     null;--                     Put ('B');
                  when Base_8 =>
                     null;--                     Put ('O');
                  when Base_16 =>
                     null;--                     Put ('X');
               end case;
            end if;
            null;--            Put ("B"""); -- nop:1
            AddAttr(N,+"val",Str_String_Literal(Expr)); -- f:val
            null;--            Put (""""); -- nop:1
         when Iir_Kind_Physical_Fp_Literal
           | Iir_Kind_Physical_Int_Literal =>
            Orig := Get_Literal_Origin (Expr);
            if Orig /= Null_Iir then
               Disp_Expression (N,NewN(N,+"-"),Orig);
            else
               Disp_Physical_Literal (N,NewN(N,+"-"),Expr); -- f:val
            end if;
         when Iir_Kind_Unit_Declaration =>
            AddAttr(N,+"val",Str_Name_Of(Expr)); -- f:val
         when Iir_Kind_Enumeration_Literal =>
            AddAttr(N,+"val",Str_Name_Of(Expr)); -- f:val
         when Iir_Kind_Object_Alias_Declaration =>
            AddAttr(N,+"val",Str_Name_Of(Expr)); -- f:val
         when Iir_Kind_Aggregate =>
            Disp_Aggregate (P,N,Expr); --reent:1
         when Iir_Kind_Null_Literal =>
            null;--            Put ("null");
         when Iir_Kind_Simple_Aggregate =>
            Disp_Simple_Aggregate (P,N,Expr); --reent:1

         when Iir_Kind_Element_Declaration =>
            AddAttr(N,+"val",Str_Name_Of(Expr)); -- f:val

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
            AddAttr(N,+"val",Str_Name_Of(Expr)); -- f:val
            return;

         when Iir_Kind_Simple_Name =>
            AddAttr(N,+"val",Str_Name(Expr)); -- f:val

         when Iir_Kinds_Dyadic_Operator =>
            Disp_Dyadic_Operator (P,N,Expr); --reent:1
         when Iir_Kinds_Monadic_Operator =>
            Disp_Monadic_Operator (P,N,Expr); --reent:1
         when Iir_Kind_Function_Call =>
            Disp_Function_Call (P,N,Expr); --reent:1
         when Iir_Kind_Type_Conversion =>
            Disp_Type (N,NewN(N,+"-"),Get_Type (Expr));
            null;--            Put (" (");
            Disp_Expression (N,NewN(N,+"-"),Get_Expression (Expr));
            null;--            Put (")");
         when Iir_Kind_Qualified_Expression =>
            Disp_Type (N,NewN(N,+"-"),Get_Type_Mark (Expr));
            null;--            Put ("'(");
            Disp_Expression (N,NewN(N,+"-"),Get_Expression (Expr));
            null;--            Put (")");
         when Iir_Kind_Allocator_By_Expression =>
            null;--            Put ("new ");
            Disp_Expression (N,NewN(N,+"-"),Get_Expression (Expr));
         when Iir_Kind_Allocator_By_Subtype =>
            null;--            Put ("new ");
            Disp_Subtype_Indication (N,NewN(N,+"-"),Get_Expression (Expr));

         when Iir_Kind_Indexed_Name =>
            Disp_Indexed_Name (P,N,Expr); --reent:1
         when Iir_Kind_Slice_Name =>
            Disp_Expression (N,NewN(N,+"-"),Get_Prefix (Expr));
            null;--            Put (" (");
            Disp_Range (N,NewN(N,+"-"),Get_Suffix (Expr));
            null;--            Put (")");
         when Iir_Kind_Selected_Element =>
            Disp_Expression (N,NewN(N,+"-"),Get_Prefix (Expr));
            null;--            Put (".");
            AddAttr(N,+"elem",Str_Name_Of(Get_Selected_Element (Expr)))
; -- f:elem
         when Iir_Kind_Implicit_Dereference =>
            Disp_Expression (N,NewN(N,+"-"),Get_Prefix (Expr));
         when Iir_Kind_Dereference =>
            Disp_Expression (N,NewN(N,+"-"),Get_Prefix (Expr));
            null;--            Put (".all");

         when Iir_Kind_Left_Type_Attribute =>
            AddAttr(N,+"attribute",+("'left"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Right_Type_Attribute =>
            AddAttr(N,+"attribute",+("'right"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_High_Type_Attribute =>
            AddAttr(N,+"attribute",+("'high"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Low_Type_Attribute =>
            AddAttr(N,+"attribute",+("'low"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1

         when Iir_Kind_Stable_Attribute =>
            Disp_Parametered_Attribute (P,N,"stable", Expr); --reent:1
         when Iir_Kind_Delayed_Attribute =>
            Disp_Parametered_Attribute (P,N,"delayed", Expr); --reent:1
         when Iir_Kind_Transaction_Attribute =>
            AddAttr(N,+"attribute",+("'transaction"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Event_Attribute =>
            AddAttr(N,+"attribute",+("'event"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Active_Attribute =>
            AddAttr(N,+"attribute",+("'active"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Last_Value_Attribute =>
            AddAttr(N,+"attribute",+("'last_value"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1
         when Iir_Kind_Last_Event_Attribute =>
            AddAttr(N,+"attribute",+("'last_event"));
            Disp_Expression (P,N,Get_Prefix (Expr)); --reent:1

         when Iir_Kind_Pos_Attribute =>
            Disp_Parametered_Attribute (P,N,"pos", Expr); --reent:1
         when Iir_Kind_Val_Attribute =>
            Disp_Parametered_Attribute (P,N,"val", Expr); --reent:1
         when Iir_Kind_Succ_Attribute =>
            Disp_Parametered_Attribute (P,N,"succ", Expr); --reent:1
         when Iir_Kind_Pred_Attribute =>
            Disp_Parametered_Attribute (P,N,"pred", Expr); --reent:1

         when Iir_Kind_Length_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"length", Expr); --reent:1
         when Iir_Kind_Range_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"range", Expr); --reent:1
         when Iir_Kind_Reverse_Range_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"reverse_range", Expr)
; --reent:1
         when Iir_Kind_Left_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"left", Expr); --reent:1
         when Iir_Kind_Right_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"right", Expr); --reent:1
         when Iir_Kind_Low_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"low", Expr); --reent:1
         when Iir_Kind_High_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"high", Expr); --reent:1
         when Iir_Kind_Ascending_Array_Attribute =>
            Disp_Parametered_Attribute (P,N,"ascending", Expr); --reent:1

         when Iir_Kind_Image_Attribute =>
            Disp_Parametered_Attribute (P,N,"image", Expr); --reent:1
         when Iir_Kind_Simple_Name_Attribute =>
            AddAttr(N,+"n",Str_Name_Of(Get_Prefix (Expr))); -- f:n
            AddAttr(N,+"attribute",+("'simple_name"));
         when Iir_Kind_Instance_Name_Attribute =>
            AddAttr(N,+"n",Str_Name_Of(Get_Prefix (Expr))); -- f:n
            AddAttr(N,+"attribute",+("'instance_name"));
         when Iir_Kind_Path_Name_Attribute =>
            AddAttr(N,+"n",Str_Name_Of(Get_Prefix (Expr))); -- f:n
            AddAttr(N,+"attribute",+("'path_name"));

         when Iir_Kind_Selected_By_All_Name =>
            Disp_Expression (N,NewN(N,+"-"),Get_Prefix (Expr));
            null;--            Put ("");
            return;
         when Iir_Kind_Selected_Name =>
            Disp_Expression (P,N,Get_Named_Entity (Expr)); --reent:1

         when Iir_Kinds_Type_And_Subtype_Definition =>
            Disp_Type (P,N,Expr); --reent:1

         when Iir_Kind_Proxy =>
            Disp_Expression (N,NewN(N,+"-"),Get_Proxy (Expr));

         when Iir_Kind_Range_Expression =>
            Disp_Range (P,N,Expr); --reent:1
         when Iir_Kind_Subtype_Declaration =>
            AddAttr(N,+"n",Str_Name_Of(Expr)); -- f:n

         when others =>
            Error_Kind ("disp_expression", Expr);
      end case;
   end Disp_Expression;

   --  procedure Disp_PSL_HDL_Expr
   -- (NPSL : PSL.Nodes.HDL_Node) is
   --  begin
   --     Disp_Expression (N,NewN(N,+"-"),Iir (NPSL));
   --  end Disp_PSL_HDL_Expr;

   procedure Disp_Psl_Expression (P,N:X;Expr : PSL_Node) is
      pragma Unreferenced (P);
      pragma Unreferenced (Expr);
   begin
      SetTag(N.all,+"psl_expression");
      null;--      Put_Line("Error Psl not supported\n");
      --PSL.Prints.HDL_Expr_Printer := Disp_PSL_HDL_Expr'Access;
      --PSL.Prints.Print_Property (Expr);
   end Disp_Psl_Expression;

   procedure Disp_Block_Header (P,N:X;Header : Iir_Block_Header
; Indent: Count)
   is
      pragma Unreferenced (P);
      Chain : Iir;
      pragma Unreferenced (Indent);
   begin
      SetTag(N.all,+"block_header");
      if Header = Null_Iir then
         return;
      end if;
      Chain := Get_Generic_Chain (Header);
      if Chain /= Null_Iir then
         null;--         Set_Col (Indent + Indentation);
         Disp_Generics (N,NewN(N,+"-"),Header);
         Chain := Get_Generic_Map_Aspect_Chain (Header);
         if Chain /= Null_Iir then
            null;--            Set_Col (Indent + Indentation);
            Disp_Generic_Map_Aspect (N,NewN(N,+"-"),Header);
            null;--            Put_Line (";");
         end if;
      end if;
      Chain := Get_Port_Chain (Header);
      if Chain /= Null_Iir then
         null;--         Set_Col (Indent + Indentation);
         Disp_Ports (N,NewN(N,+"-"),Header);
         Chain := Get_Port_Map_Aspect_Chain (Header);
         if Chain /= Null_Iir then
            null;--            Set_Col (Indent + Indentation);
            Disp_Port_Map_Aspect (N,NewN(N,+"-"),Header);
            null;--            Put_Line (";");
         end if;
      end if;
   end Disp_Block_Header;

   procedure Disp_Block_Statement (P,N:X;Block: Iir_Block_Statement)
   is
      pragma Unreferenced (P);
      Indent: Count;
      Sensitivity: Iir_List;
      Guard : Iir_Guard_Signal_Declaration;
   begin
      SetTag(N.all,+"block_statement");
      Indent := Col;
      AddAttr(N,+"lab",Str_Label( (Block))); -- f:lab
      null;--      Put ("block");
      Guard := Get_Guard_Decl (Block);
      if Guard /= Null_Iir then
         null;--         Put (" (");
         Disp_Expression (N,NewN(N,+"-"),Get_Guard_Expression (Guard));
         null;--         Put_Line (")");
         Sensitivity := Get_Guard_Sensitivity_List (Guard);
         if Sensitivity /= Null_Iir_List then
            null;--            Set_Col (Indent + Indentation);
            null;--            Put ("-- guard sensitivity list ");
            Disp_Designator_List (N,NewN(N,+"-"),Sensitivity);
         end if;
      else
         null;--         New_Line;
      end if;
      Disp_Block_Header (N,NewN(N,+"-"),Get_Block_Header (Block),
                         Indent + Indentation);
      Disp_Declaration_Chain (N,NewN(N,+"-"),Block, Indent + Indentation);
      null;--      Set_Col (Indent);
      null;--      Put_Line ("begin");
      Disp_Concurrent_Statement_Chain (N,NewN(N,+"-"),Block
, Indent + Indentation);
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end;");
   end Disp_Block_Statement;

   procedure Disp_Generate_Statement (P,N:X;Stmt : Iir_Generate_Statement)
   is
      pragma Unreferenced (P);
      Indent : Count;
      Scheme : Iir;
   begin
      SetTag(N.all,+"generate_statement");
      Indent := Col;
      AddAttr(N,+"lab",Str_Label( (Stmt))); -- f:lab
      Scheme := Get_Generation_Scheme (Stmt);
      case Get_Kind (Scheme) is
         when Iir_Kind_Iterator_Declaration =>
            AddAttr(N,+"typ",+("for"));
            Disp_Parameter_Specification (N,NewN(N,+"-"),Scheme);
         when others =>
            AddAttr(N,+"typ",+("if"));
            Disp_Expression (N,NewN(N,+"-"),Scheme);
      end case;
      null;--      Put_Line (" generate");
      Disp_Declaration_Chain (N,NewN(N,+"-"),Stmt, Indent);
      null;--      Set_Col (Indent);
      null;--      Put_Line ("begin");
      Disp_Concurrent_Statement_Chain (N,NewN(N,+"-"),Stmt
, Indent + Indentation);
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end generate;");
   end Disp_Generate_Statement;

   procedure Disp_Psl_Default_Clock (P,N:X;Stmt : Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"psl_default_clock");
      null;--      Put ("--psl default clock is ");
      Disp_Psl_Expression (N,NewN(N,+"-"),Get_Psl_Boolean (Stmt));
      null;--      Put_Line (";");
   end Disp_Psl_Default_Clock;

   procedure Disp_Psl_Assert_Statement (P,N:X;Stmt : Iir)
   is
      pragma Unreferenced (P);
      use PSL.NFAs;
      use PSL.Nodes;

      procedure Disp_State (P,N:X;S : NFA_State) is
         pragma Unreferenced (P);
         Str : constant String := Int32'Image (Get_State_Label (S));
      begin
         SetTag(N.all,+"state");
         Put (Str (2 .. Str'Last));
      end Disp_State;

      NPSL : NFA;
      S : NFA_State;
      E : NFA_Edge;
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"psl_assert_statement");
      null;--      Put ("--psl assert ");
      Disp_Psl_Expression (N,NewN(N,+"-"),Get_Psl_Property (Stmt));
      null;--      Put_Line (";");
      NPSL := Get_PSL_NFA (Stmt);
      if True and then NPSL /= No_NFA then
         S := Get_First_State (NPSL);
         while S /= No_State loop
            E := Get_First_Src_Edge (S);
            while E /= No_Edge loop
               null;--               Put ("-- ");
               Disp_State (N,NewN(N,+"-"),S);
               null;--               Put (" -> ");
               Disp_State (N,NewN(N,+"-"),Get_Edge_Dest (E));
               null;--               Put (": ");
               Disp_Psl_Expression (N,NewN(N,+"-"),Get_Edge_Expr (E));
               null;--               New_Line;
               E := Get_Next_Src_Edge (E);
            end loop;
            S := Get_Next_State (S);
         end loop;
      end if;
   end Disp_Psl_Assert_Statement;

   procedure Disp_Concurrent_Statement (P,N:X;Stmt: Iir) is
   begin
      SetId(N,Stmt);
      SetTag(N.all,+"concurrent_statement");
      ChangeTag(N,Stmt);
      AddAttr(N,+"typ",+"concur");
      case Get_Kind (Stmt) is -- rename:Stmt,flags:[typ=concur]
         when Iir_Kind_Concurrent_Conditional_Signal_Assignment =>
            Disp_Concurrent_Conditional_Signal_Assignment (P,N,Stmt)
;-- reent:1
         when Iir_Kind_Concurrent_Selected_Signal_Assignment =>
            Disp_Concurrent_Selected_Signal_Assignment (P,N,Stmt);-- reent:1
         when Iir_Kind_Sensitized_Process_Statement
           | Iir_Kind_Process_Statement =>
            Disp_Process_Statement (N,NewN(N,+"-"),Stmt);
         when Iir_Kind_Concurrent_Assertion_Statement =>
            Disp_Assertion_Statement (N,NewN(N,+"-"),Stmt);
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Component_Instantiation_Statement (P,N,Stmt); -- reent:1
         when Iir_Kind_Concurrent_Procedure_Call_Statement =>
            Disp_Procedure_Call (N,NewN(N,+"-"),Get_Procedure_Call (Stmt));
         when Iir_Kind_Block_Statement =>
            Disp_Block_Statement (N,NewN(N,+"-"),Stmt);
         when Iir_Kind_Generate_Statement =>
            Disp_Generate_Statement (P,N,Stmt);-- reent:1
         when Iir_Kind_Psl_Default_Clock =>
            Disp_Psl_Default_Clock (N,NewN(N,+"-"),Stmt);
         when Iir_Kind_Psl_Assert_Statement =>
            Disp_Psl_Assert_Statement (N,NewN(N,+"-"),Stmt);
         when others =>
            Error_Kind ("disp_concurrent_statement", Stmt);
      end case;
   end Disp_Concurrent_Statement;

   procedure Disp_Package_Declaration (P,N:X
;Decl: Iir_Package_Declaration) is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"package_declaration");
      null;--      Put ("package ");
      AddAttr(N,+"n",Str_Identifier(Decl)); -- f:n
      null;--      Put_Line (" is");
      Disp_Declaration_Chain (N,NewN(N,+"-"),Decl, Col + Indentation);
      null;--      Put_Line ("end;");
   end Disp_Package_Declaration;

   procedure Disp_Package_Body (P,N:X;Decl: Iir)
   is
      pragma Unreferenced (P);
   begin
      SetId(N,Decl);
      SetTag(N.all,+"package_body");
      null;--      Put ("package body ");
      AddAttr(N,+"n",Str_Identifier(Decl)); -- f:n
      null;--      Put_Line (" is");
      Disp_Declaration_Chain (N,NewN(N,+"-"),Decl, Col + Indentation);
      null;--      Put_Line ("end;");
   end Disp_Package_Body;

   procedure Disp_Binding_Indication (P,N:X;Bind : Iir; Indent : Count)
   is
      pragma Unreferenced (P);
      El : Iir;
      pragma Unreferenced (Indent);
   begin
      SetId(N,Bind);
      SetTag(N.all,+"binding_indication");
      El := Get_Entity_Aspect (Bind);
      if El /= Null_Iir then
         null;--         Set_Col (Indent);
         null;--         Put ("use ");
         Disp_Entity_Aspect (N,NewN(N,+"-"),El);
      end if;
      El := Get_Generic_Map_Aspect_Chain (Bind);
      if El /= Null_Iir then
         null;--         Set_Col (Indent);
         Disp_Generic_Map_Aspect (N,NewN(N,+"-"),Bind);
      end if;
      El := Get_Port_Map_Aspect_Chain (Bind);
      if El /= Null_Iir then
         null;--         Set_Col (Indent);
         Disp_Port_Map_Aspect (N,NewN(N,+"-"),Bind);
      end if;
   end Disp_Binding_Indication;

   procedure Disp_Component_Configuration
     (P,N:X;Conf : Iir_Component_Configuration; Indent : Count)
   is
      pragma Unreferenced (P);
      Block : Iir_Block_Configuration;
      Binding : Iir;
   begin
      SetTag(N.all,+"component_configuration");
      null;--      Set_Col (Indent);
      null;--      Put ("for ");
      Disp_Instantiation_List (N,NewN(N,+"-"),Get_Instantiation_List (Conf))
;
      null;--      Put(" : ");
      AddAttr(N,+"n",Str_Name_Of(Get_Component_Name (Conf))); -- f:n
      null;--      New_Line;
      Binding := Get_Binding_Indication (Conf);
      if Binding /= Null_Iir then
         Disp_Binding_Indication (N,NewN(N,+"-"),Binding
, Indent + Indentation);
      end if;
      Block := Get_Block_Configuration (Conf);
      if Block /= Null_Iir then
         Disp_Block_Configuration (N,NewN(N,+"-"),Block
, Indent + Indentation);
      end if;
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end for;");
   end Disp_Component_Configuration;

   procedure Disp_Configuration_Items
     (P,N:X;Conf : Iir_Block_Configuration; Indent : Count)
   is
      pragma Unreferenced (P);
      El : Iir;
   begin
      SetTag(N.all,+"configuration_items");
      El := Get_Configuration_Item_Chain (Conf);
      while El /= Null_Iir loop
         case Get_Kind (El) is
            when Iir_Kind_Block_Configuration =>
               Disp_Block_Configuration (N,NewN(N,+"-"),El, Indent);
            when Iir_Kind_Component_Configuration =>
               Disp_Component_Configuration (N,NewN(N,+"-"),El, Indent);
            when Iir_Kind_Configuration_Specification =>
               --  This may be created by canon.
               null;--               Set_Col (Indent);
               Disp_Configuration_Specification (N,NewN(N,+"-"),El);
               null;--               Set_Col (Indent);
               null;--               Put_Line ("end for;");
            when others =>
               Error_Kind ("disp_configuration_item_list", El);
         end case;
         El := Get_Chain (El);
      end loop;
   end Disp_Configuration_Items;

   procedure Disp_Block_Configuration
     (P,N:X;Block: Iir_Block_Configuration; Indent: Count)
   is
      pragma Unreferenced (P);
      Spec : Iir;
   begin
      SetTag(N.all,+"block_configuration");
      null;--      Set_Col (Indent);
      null;--      Put ("for ");
      Spec := Get_Block_Specification (Block);
      case Get_Kind (Spec) is
         when Iir_Kind_Block_Statement
           | Iir_Kind_Generate_Statement
           | Iir_Kind_Architecture_Declaration =>
            AddAttr(N,+"n",Str_Name_Of(Spec)); -- f:n
         when Iir_Kind_Indexed_Name =>
            AddAttr(N,+"prefix",Str_Name_Of(Get_Prefix (Spec)))
; -- f:prefix
            null;--            Put (" (");
            Disp_Expression (N,NewN(N,+"-")
,Get_First_Element (Get_Index_List (Spec)));
            null;--            Put (")");
         when Iir_Kind_Selected_Name =>
            AddAttr(N,+"prefix",Str_Name_Of(Get_Prefix (Spec)))
; -- f:prefix
            null;--            Put (" (");
            AddAttr(N,+"n",+(Iirs_Utils.Image_Identifier (Spec)));
            null;--            Put (")");
         when Iir_Kind_Slice_Name =>
            AddAttr(N,+"prefix",Str_Name_Of(Get_Prefix (Spec)))
; -- f:prefix
            null;--            Put (" (");
            Disp_Range (N,NewN(N,+"-"),Get_Suffix (Spec));
            null;--            Put (")");
         when others =>
            Error_Kind ("disp_block_configuration", Spec);
      end case;
      null;--      New_Line;
      Disp_Declaration_Chain (N,NewN(N,+"-"),Block, Indent + Indentation);
      Disp_Configuration_Items (N,NewN(N,+"-"),Block, Indent + Indentation);
      null;--      Set_Col (Indent);
      null;--      Put_Line ("end for;");
   end Disp_Block_Configuration;

   procedure Disp_Configuration_Declaration
     (P,N:X;Decl: Iir_Configuration_Declaration)
   is
      pragma Unreferenced (P);
   begin
      SetTag(N.all,+"configuration_declaration");
      null;--      Put ("configuration ");
      AddAttr(N,+"n",Str_Name_Of(Decl)); -- f:n
      null;--      Put (" of ");
      AddAttr(N,+"of",Str_Name_Of(Get_Entity (Decl))); --f:of
      null;--      Put_Line (" is");
      Disp_Declaration_Chain (N,NewN(N,+"-"),Decl, Col);
      Disp_Block_Configuration (N,NewN(N,+"-"),Get_Block_Configuration (Decl)
,
                                Col + Indentation);
      null;--      Put_Line ("end;");
   end Disp_Configuration_Declaration;

   procedure Disp_Design_Unit (P,N:X;Unit: Iir_Design_Unit)
   is
      pragma Unreferenced (P);
      Decl: Iir;
      Indent: Count;
      pragma Unreferenced (Indent);
   begin
      SetTag(N.all,+"design_unit");
      Indent := Col;
      Decl := Get_Context_Items (Unit);
      while Decl /= Null_Iir loop
         null;--         Set_Col (Indent);
         case Get_Kind (Decl) is
            when Iir_Kind_Use_Clause =>
               Disp_Use_Clause (N,NewN(N,+"-"),Decl);
            when Iir_Kind_Library_Clause =>
               null;--               Put ("library ");
               AddAttr(N,+"n",Str_Identifier(Decl)); -- f:n
               null;--               Put_Line (";");
            when others =>
               Error_Kind ("disp_design_unit1", Decl);
         end case;
         Decl := Get_Chain (Decl);
      end loop;

      Decl := Get_Library_Unit (Unit);
      null;--      Set_Col (Indent);
      case Get_Kind (Decl) is
         when Iir_Kind_Entity_Declaration =>
            Disp_Entity_Declaration (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Architecture_Declaration =>
            Disp_Architecture_Declaration (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Package_Declaration =>
            Disp_Package_Declaration (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Package_Body =>
            Disp_Package_Body (N,NewN(N,+"-"),Decl);
         when Iir_Kind_Configuration_Declaration =>
            Disp_Configuration_Declaration (N,NewN(N,+"-"),Decl);
         when others =>
            Error_Kind ("disp_design_unit2", Decl);
      end case;
      null;--      New_Line (2);
   end Disp_Design_Unit;

   procedure Disp_Xml_Vhdl (P,N:X;An_Iir: Iir) is
      pragma Unreferenced (P);
   begin
      SetId(N,An_Iir);
      SetTag(N.all,+"xml_vhdl");
      --Set_Line_Length (80);
      -- Put (Count'Image (Line_Length));
      case Get_Kind (An_Iir) is
         when Iir_Kind_Design_Unit =>
            Disp_Design_Unit (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Character_Literal =>
            Disp_Character_Literal (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Enumeration_Type_Definition =>
            Disp_Enumeration_Type_Definition (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Enumeration_Subtype_Definition =>
            Disp_Enumeration_Subtype_Definition (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Concurrent_Conditional_Signal_Assignment =>
            Disp_Concurrent_Conditional_Signal_Assignment (N,NewN(N,+"-")
,An_Iir);
         when Iir_Kinds_Dyadic_Operator =>
            Disp_Dyadic_Operator (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Signal_Interface_Declaration
           | Iir_Kind_Signal_Declaration
           | Iir_Kind_Object_Alias_Declaration =>
            AddAttr(N,+"n",Str_Name_Of(An_Iir)); -- f:n
         when Iir_Kind_Enumeration_Literal =>
            AddAttr(N,+"n",Str_Identifier(An_Iir)); -- f:n
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Component_Instantiation_Statement (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Integer_Subtype_Definition =>
            Disp_Integer_Subtype_Definition (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Array_Subtype_Definition =>
            Disp_Array_Subtype_Definition (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Array_Type_Definition =>
            Disp_Array_Type_Definition (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Package_Declaration =>
            Disp_Package_Declaration (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Wait_Statement =>
            Disp_Wait_Statement (N,NewN(N,+"-"),An_Iir);
         when Iir_Kind_Selected_Name
           | Iir_Kind_Selected_Element
           | Iir_Kind_Indexed_Name
           | Iir_Kind_Slice_Name =>
            Disp_Expression (N,NewN(N,+"-"),An_Iir);
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
   procedure Disp_Int64 (P,N:X;Val: Iir_Int64)
   is
      pragma Unreferenced (P);
      Str: constant String := Iir_Int64'Image (Val);
   begin
      SetTag(N.all,+"int64");
      if Str(Str'First) = ' ' then
         Put (Str (Str'First + 1 .. Str'Last));
      else
         Put (Str);
      end if;
   end Disp_Int64;
   pragma Unreferenced (Disp_Int64);

   --  procedure Disp_Int32 (N,NewN(N,+"-"),Val: Iir_Int32)
   --  is
   --     Str: constant String := Iir_Int32'Image (Val);
   --  begin
   --     if Str(Str'First) = ' ' then
   --        Put (Str (Str'First + 1 .. Str'Last));
   --     else
   --        Put (Str);
   --     end if;
   --  end Disp_Int32;

   procedure Disp_Fp64 (P,N:X;Val: Iir_Fp64)
   is
      pragma Unreferenced (P);
      Str: constant String := Iir_Fp64'Image (Val);
   begin
      SetTag(N.all,+"fp64");
      if Str(Str'First) = ' ' then
         Put (Str (Str'First + 1 .. Str'Last));
      else
         Put (Str);
      end if;
   end Disp_Fp64;
   pragma Unreferenced (Disp_Fp64);

end disp_xml_vhdl;