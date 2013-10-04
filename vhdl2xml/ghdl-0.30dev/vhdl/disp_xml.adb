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

         when Iir_Kind_Design_File =>
            typ := +"design_file";
         when Iir_Kind_Design_Unit =>
            typ := +"design_unit";
         when Iir_Kind_Use_Clause =>
            typ := +"use_clause";
         when Iir_Kind_Library_Clause =>
            typ := +"library_clause";
         when Iir_Kind_Library_Declaration =>
            typ := +"library_declaration";
         when Iir_Kind_Proxy =>
            typ := +"proxy";
         when Iir_Kind_Waveform_Element =>
            typ := +"waveform_element";
         when Iir_Kind_Package_Declaration =>
            typ := +"package_declaration";
         when Iir_Kind_Package_Body =>
            typ := +"package_body";
         when Iir_Kind_Entity_Declaration =>
            typ := +"entity_declaration";
         when Iir_Kind_Architecture_Declaration =>
            typ := +"architecture_declaration";
         when Iir_Kind_Configuration_Declaration =>
            typ := +"configuration_declaration";
         when Iir_Kind_Function_Declaration =>
            typ := +"function_declaration";
         when Iir_Kind_Function_Body =>
            typ := +"function_body";
         when Iir_Kind_Procedure_Declaration =>
            typ := +"procedure_declaration";
         when Iir_Kind_Procedure_Body =>
            typ := +"procedure_body";
         when Iir_Kind_Object_Alias_Declaration =>
            typ := +"object_alias_declaration";
         when Iir_Kind_Non_Object_Alias_Declaration =>
            typ := +"non_object_alias_declaration";
         when Iir_Kind_Signal_Interface_Declaration =>
            typ := +"signal_interface_declaration";
         when Iir_Kind_Signal_Declaration =>
            typ := +"signal_declaration";
         when Iir_Kind_Variable_Interface_Declaration =>
            typ := +"variable_interface_declaration";
         when Iir_Kind_Variable_Declaration =>
            typ := +"variable_declaration";
         when Iir_Kind_Constant_Interface_Declaration =>
            typ := +"constant_interface_declaration";
         when Iir_Kind_Constant_Declaration =>
            typ := +"constant_declaration";
         when Iir_Kind_Iterator_Declaration =>
            typ := +"iterator_declaration";
         when Iir_Kind_File_Interface_Declaration =>
            typ := +"file_interface_declaration";
         when Iir_Kind_File_Declaration =>
            typ := +"file_declaration";
         when Iir_Kind_Type_Declaration =>
            typ := +"type_declaration";
         when Iir_Kind_Anonymous_Type_Declaration =>
            typ := +"anonymous_type_declaration";
         when Iir_Kind_Subtype_Declaration =>
            typ := +"subtype_declaration";
         when Iir_Kind_Component_Declaration =>
            typ := +"component_declaration";
         when Iir_Kind_Element_Declaration =>
            typ := +"element_declaration";
         when Iir_Kind_Record_Element_Constraint =>
            typ := +"record_element_constraint";
         when Iir_Kind_Attribute_Declaration =>
            typ := +"attribute_declaration";
         when Iir_Kind_Group_Template_Declaration =>
            typ := +"group_template_declaration";
         when Iir_Kind_Group_Declaration =>
            typ := +"group_declaration";
         when Iir_Kind_Psl_Declaration =>
            typ := +"psl_declaration";
         when Iir_Kind_Psl_Expression =>
            typ := +"psl_expression";
         when Iir_Kind_Enumeration_Type_Definition =>
            typ := +"enumeration_type_definition";
         when Iir_Kind_Enumeration_Subtype_Definition =>
            typ := +"enumeration_subtype_definition";
         when Iir_Kind_Integer_Subtype_Definition =>
            typ := +"integer_subtype_definition";
         when Iir_Kind_Integer_Type_Definition =>
            typ := +"integer_type_definition";
         when Iir_Kind_Floating_Subtype_Definition =>
            typ := +"floating_subtype_definition";
         when Iir_Kind_Floating_Type_Definition =>
            typ := +"floating_type_definition";
         when Iir_Kind_Array_Subtype_Definition =>
            typ := +"array_subtype_definition";
         when Iir_Kind_Array_Type_Definition =>
            typ := +"array_type_definition";
         when Iir_Kind_Record_Type_Definition =>
            typ := +"record_type_definition";
         when Iir_Kind_Access_Type_Definition =>
            typ := +"access_type_definition";
         when Iir_Kind_File_Type_Definition =>
            typ := +"file_type_definition";
         when Iir_Kind_Subtype_Definition =>
            typ := +"subtype_definition";
         when Iir_Kind_Physical_Type_Definition =>
            typ := +"physical_type_definition";
         when Iir_Kind_Physical_Subtype_Definition =>
            typ := +"physical_subtype_definition";
         when Iir_Kind_Simple_Name =>
            typ := +"simple_name";
         when Iir_Kind_Operator_Symbol =>
            typ := +"operator_symbol";
         when Iir_Kind_Null_Literal =>
            typ := +"null_literal";
         when Iir_Kind_Physical_Int_Literal =>
            typ := +"physical_int_literal";
         when Iir_Kind_Physical_Fp_Literal =>
            typ := +"physical_fp_literal";
         when Iir_Kind_Component_Instantiation_Statement =>
            typ := +"component_instantiation_statement";
         when Iir_Kind_Block_Statement =>
            typ := +"block_statement";
         when Iir_Kind_Sensitized_Process_Statement =>
            typ := +"sensitized_process_statement";
         when Iir_Kind_Process_Statement =>
            typ := +"process_statement";
         when Iir_Kind_Case_Statement =>
            typ := +"case_statement";
         when Iir_Kind_If_Statement =>
            typ := +"if_statement";
         when Iir_Kind_Elsif =>
            typ := +"elsif";
         when Iir_Kind_For_Loop_Statement =>
            typ := +"for_loop_statement";
         when Iir_Kind_While_Loop_Statement =>
            typ := +"while_loop_statement";
         when Iir_Kind_Exit_Statement =>
            typ := +"exit_statement";
         when Iir_Kind_Next_Statement =>
            typ := +"next_statement";
         when Iir_Kind_Wait_Statement =>
            typ := +"wait_statement";
         when Iir_Kind_Assertion_Statement =>
            typ := +"assertion_statement";
         when Iir_Kind_Variable_Assignment_Statement =>
            typ := +"variable_assignment_statement";
         when Iir_Kind_Signal_Assignment_Statement =>
            typ := +"signal_assignment_statement";
         when Iir_Kind_Concurrent_Assertion_Statement =>
            typ := +"concurrent_assertion_statement";
         when Iir_Kind_Procedure_Call_Statement =>
            typ := +"procedure_call_statement";
         when Iir_Kind_Concurrent_Procedure_Call_Statement =>
            typ := +"concurrent_procedure_call_statement";
         when Iir_Kind_Return_Statement =>
            typ := +"return_statement";
         when Iir_Kind_Null_Statement =>
            typ := +"null_statement";
         when Iir_Kind_Enumeration_Literal =>
            typ := +"enumeration_literal";
         when Iir_Kind_Character_Literal =>
            typ := +"character_literal";
         when Iir_Kind_Integer_Literal =>
            typ := +"integer_literal";
            val := + Iir_Int64'Image (Get_Value (Tree)) ;
         when Iir_Kind_Floating_Point_Literal =>
            typ := +"floating_point_literal";
            val := + Iir_Fp64'Image (Get_Fp_Value (Tree)) ;
         when Iir_Kind_String_Literal =>
            typ := +"string_literal";
            val := + Image_String_Lit (Tree) ;
         when Iir_Kind_Unit_Declaration =>
            typ := +"physical_unit";
         when Iir_Kind_Entity_Class =>
            typ := +"entity_class";
            val := + Tokens.Image (Get_Entity_Class (Tree))  ;
         when Iir_Kind_Attribute_Name =>
            typ := +"attribute_name";
         when Iir_Kind_Implicit_Function_Declaration =>
            typ := +"implicit_function_declaration";
         when Iir_Kind_Implicit_Procedure_Declaration =>
            typ := +"implicit_procedure_declaration";
         when others =>
            typ := +Iir_Kind'Image (Get_Kind (Tree));

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
         when Iir_Kind_Overload_List =>
            Disp_Xml_List(e,+"overload_list",
            Get_Overload_List (Tree),
             Flat_Decl);
         when Iir_Kind_Error =>
            null;
         when Iir_Kind_Design_File =>
            flag(e,+"design_file_filename",
            + (Name_Table.Image (Get_Design_File_Filename (Tree))));
            flag(e,+"design_file_directory",
            + (Name_Table.Image (Get_Design_File_Directory (Tree))));
            flag(e,+"analysis_time_stamp",
            + (Files_Map.Get_Time_Stamp_String
                    (Get_Analysis_Time_Stamp (Tree))));
            flag(e,+"file_time_stamp",
            + (Files_Map.Get_Time_Stamp_String
                    (Get_File_Time_Stamp (Tree))));
            child := Disp_Xml_Flat(e,+"library",
            Get_Parent (Tree));
            Disp_Xml_Chain(e,+"design_unit_chain",
            Get_First_Design_Unit (Tree),
             Flat_Decl);
         when Iir_Kind_Design_Unit =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"date_state",
            + (Date_State_Type'Image (Get_Date_State (Tree))
                    ));
            flag(e,+"elab",
            + (Boolean'Image (Get_Elab_Flag (Tree))));
            flag(e,+"date",
            + (Date_Type'Image (Get_Date (Tree))));
            child := Disp_Xml_Flat(e,
            +"parent_(design_file)",
            Get_Design_File (Tree));
            Disp_Xml_List_Flat(e,+"dependence_list",
            Get_Dependence_List (Tree));
            if Get_Date_State (Tree) /= Date_Disk then
               Disp_Xml_Chain(e,+"context_items",
            Get_Context_Items (Tree));
            end if;
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
            Disp_Xml(e,+"library_unit",
            Get_Library_Unit (Tree));
         when Iir_Kind_Use_Clause =>
            Disp_Xml(e,+"selected_name",
            Get_Selected_Name (Tree),
             True);
            Disp_Xml(e,+"use_clause_chain",
            Get_Use_Clause_Chain (Tree));
         when Iir_Kind_Library_Clause =>
            child := Disp_Xml_Flat(e,+"library_declaration",
            Get_Library_Declaration (Tree));
         when Iir_Kind_Library_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"library_directory",
            + (Name_Table.Image (Get_Library_Directory (Tree))));
            Disp_Xml_Chain(e,+"design_file_list",
            Get_Design_File_Chain (Tree));
         when Iir_Kind_Entity_Declaration =>
            Disp_Xml_Chain(e,+"generic_chain",
            Get_Generic_Chain (Tree));
            Disp_Xml_Chain(e,+"port_chain",
            Get_Port_Chain (Tree));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"concurrent_statements",
            Get_Concurrent_Statement_Chain (Tree));
         when Iir_Kind_Package_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"need_body",
            + (Boolean'Image (Get_Need_Body (Tree))));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
         when Iir_Kind_Package_Body =>
            child := Disp_Xml_Flat(e,+"package",
            Get_Package (Tree));
            Disp_Xml_Chain(e,+"declaration",
            Get_Declaration_Chain (Tree));
         when Iir_Kind_Architecture_Declaration =>
            if Flat_Decl then
               return;
            end if;
            child := Disp_Xml_Flat(e,+"entity",
            Get_Entity (Tree));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"concurrent_statements",
            Get_Concurrent_Statement_Chain (Tree));
            child := Disp_Xml_Flat(e,
            +"default_configuration",
            Get_Default_Configuration_Declaration (Tree));
         when Iir_Kind_Configuration_Declaration =>
            child := Disp_Xml_Flat(e,+"entity",
            Get_Entity (Tree));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml(e,+"block_configuration",
            Get_Block_Configuration (Tree),
             True);
         when Iir_Kind_Entity_Aspect_Entity =>
            child := Disp_Xml_Flat(e,+"entity",
            Get_Entity (Tree));
            child := Disp_Xml_Flat(e,+"architecture",
            Get_Architecture (Tree));
         when Iir_Kind_Entity_Aspect_Configuration =>
            Disp_Xml(e,+"configuration",
            Get_Configuration (Tree),
             True);
         when Iir_Kind_Entity_Aspect_Open =>
            null;
         when Iir_Kind_Block_Configuration =>
            Disp_Xml(e,+"block_specification",
            Get_Block_Specification (Tree),
             True);
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"configuration_item_chain",
            Get_Configuration_Item_Chain (Tree));
            child := Disp_Xml_Flat(e,
            +"prev_block_configuration",
            Get_Prev_Block_Configuration (Tree));
         when Iir_Kind_Attribute_Specification =>
            Disp_Xml(e,+"attribute_designator",
            Get_Attribute_Designator (Tree),
             True);
            Disp_Xml_List_Flat(e,+"entity_name_list",
            Get_Entity_Name_List (Tree));
            flag(e,+"entity_class",
            + (Tokens.Image (Get_Entity_Class (Tree))));
            Disp_Xml(e,+"expression",Get_Expression (Tree));
            Disp_Xml_Chain(e,+"attribute_value_spec_chain",
            Get_Attribute_Value_Spec_Chain (Tree));
         when Iir_Kind_Configuration_Specification|
           Iir_Kind_Component_Configuration =>
            Disp_Xml_List_Flat(e,+"instantiation_list",
            Get_Instantiation_List (Tree));
            Disp_Xml(e,+"component_name",
            Get_Component_Name (Tree),
             True);
            Disp_Xml(e,+"binding_indication",
            Get_Binding_Indication (Tree));
            if Kind = Iir_Kind_Component_Configuration then
               Disp_Xml(e,+"block_configuration",
            Get_Block_Configuration (Tree));
            end if;
         when Iir_Kind_Binding_Indication =>
            Disp_Xml(e,+"entity_aspect",
            Get_Entity_Aspect (Tree),
             True);
            Disp_Xml_Chain(e,+"generic_map_aspect_chain",
            Get_Generic_Map_Aspect_Chain (Tree));
            Disp_Xml_Chain(e,+"port_map_aspect_chain",
            Get_Port_Map_Aspect_Chain (Tree));
            Disp_Xml_Chain(e,
            +"default_generic_map_aspect_chain",
            Get_Default_Generic_Map_Aspect_Chain (Tree));
            Disp_Xml_Chain(e,
            +"default_port_map_aspect_chain",
            Get_Default_Port_Map_Aspect_Chain (Tree));
         when Iir_Kind_Block_Header =>
            Disp_Xml_Chain(e,+"generic_chain",
            Get_Generic_Chain (Tree));
            Disp_Xml_Chain(e,+"generic_map_aspect_chain",
            Get_Generic_Map_Aspect_Chain (Tree));
            Disp_Xml_Chain(e,+"port_chain",
            Get_Port_Chain (Tree));
            Disp_Xml_Chain(e,+"port_map_aspect_chain",
            Get_Port_Map_Aspect_Chain (Tree));
         when Iir_Kind_Attribute_Value =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,
            +"attribute_specification",
            Get_Attribute_Specification (Tree));
            child := Disp_Xml_Flat(e,+"designated_entity",
            Get_Designated_Entity (Tree));
         when Iir_Kind_Signature =>
            child := Disp_Xml_Flat(e,+"return_type",
            Get_Return_Type (Tree));
            Disp_Xml_List(e,+"type_marks_list",
            Get_Type_Marks_List (Tree));
         when Iir_Kind_Disconnection_Specification =>
            Disp_Xml_List(e,+"signal_list",
            Get_Signal_List (Tree),
             True);
            Disp_Xml(e,+"type_mark",Get_Type (Tree), True);
            Disp_Xml(e,+"time_expression",
            Get_Expression (Tree));
         when Iir_Kind_Association_Element_By_Expression =>
            flag(e,+"whole_association_flag",
             Disp_Flag(Get_Whole_Association_Flag (Tree)));
            flag(e,+"collapse_signal_flag",
             Disp_Flag(Get_Collapse_Signal_Flag (Tree)));
            Disp_Xml(e,+"formal",Get_Formal (Tree), True);
            Disp_Xml(e,+"out_conversion",
            Get_Out_Conversion (Tree),
             True);
            Disp_Xml(e,+"actual",Get_Actual (Tree), True);
            Disp_Xml(e,+"in_conversion",
            Get_In_Conversion (Tree),
             True);
         when Iir_Kind_Association_Element_By_Individual =>
            flag(e,+"whole_association_flag",
             Disp_Flag(Get_Whole_Association_Flag (Tree)));
            Disp_Xml(e,+"formal",Get_Formal (Tree), True);
            Disp_Xml(e,+"actual_type",
            Get_Actual_Type (Tree),
             True);
            Disp_Xml_Chain(e,
            +"individual_association_chain",
            Get_Individual_Association_Chain (Tree));
         when Iir_Kind_Association_Element_Open =>
            Disp_Xml(e,+"formal",Get_Formal (Tree), True);
         when Iir_Kind_Waveform_Element =>
            Disp_Xml(e,+"value",Get_We_Value (Tree), True);
            Disp_Xml(e,+"time",Get_Time (Tree));
         when Iir_Kind_Conditional_Waveform =>
            Disp_Xml(e,+"condition",Get_Condition (Tree));
            Disp_Xml_Chain(e,+"waveform_chain",
            Get_Waveform_Chain (Tree));
         when Iir_Kind_Choice_By_Name =>
            Disp_Xml(e,+"name",Get_Name (Tree));
            Disp_Xml(e,+"associated",Get_Associated (Tree),
             True);
         when Iir_Kind_Choice_By_Others =>
            Disp_Xml(e,+"associated",Get_Associated (Tree),
             True);
         when Iir_Kind_Choice_By_None =>
            Disp_Xml(e,+"associated",Get_Associated (Tree),
             True);
         when Iir_Kind_Choice_By_Range =>
            flag(e,+"staticness",
             Disp_Choice_Staticness(Tree));
            Disp_Xml(e,+"range",Get_Expression (Tree));
            Disp_Xml(e,+"associated",Get_Associated (Tree),
             True);
         when Iir_Kind_Choice_By_Expression =>
            Disp_Xml(e,+"expression",Get_Expression (Tree));
            flag(e,+"staticness",
             Disp_Choice_Staticness(Tree));
            Disp_Xml(e,+"associated",Get_Associated (Tree),
             True);
         when Iir_Kind_Signal_Interface_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Name_Staticness(Tree));
            flag(e,+"lexical_layout",
             Disp_Lexical_Layout(Tree));
            flag(e,+"mode",
            + (Iir_Mode'Image (Get_Mode (Tree))));
            flag(e,+"signal_kind",
            + (Iir_Signal_Kind'Image (Get_Signal_Kind (Tree))));
            flag(e,+"has_active_flag",
             Disp_Flag(Get_Has_Active_Flag (Tree)));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"default_value",
            Get_Default_Value (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Variable_Interface_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Name_Staticness(Tree));
            flag(e,+"lexical_layout",
             Disp_Lexical_Layout(Tree));
            flag(e,+"mode",
            + (Iir_Mode'Image (Get_Mode (Tree))));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"default_value",
            Get_Default_Value (Tree),
             True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Constant_Interface_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Name_Staticness(Tree));
            flag(e,+"lexical_layout",
             Disp_Lexical_Layout(Tree));
            flag(e,+"mode",
            + (Iir_Mode'Image (Get_Mode (Tree))));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"default_value",
            Get_Default_Value (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_File_Interface_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Name_Staticness(Tree));
            flag(e,+"lexical_layout",
             Disp_Lexical_Layout(Tree));
            flag(e,+"mode",
            + (Iir_Mode'Image (Get_Mode (Tree))));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Signal_Declaration|
           Iir_Kind_Guard_Signal_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"kind",
            + (Iir_Signal_Kind'Image (Get_Signal_Kind (Tree))));
            flag(e,+"has_active_flag",
             Disp_Flag(Get_Has_Active_Flag (Tree)));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            if Kind = Iir_Kind_Signal_Declaration then
               Disp_Xml(e,+"default_value",
            Get_Default_Value (Tree),
             True);
               child := Disp_Xml_Flat(e,+"signal_driver",
            Get_Signal_Driver (Tree));
            else
               Disp_Xml(e,+"guard_expr",
            Get_Guard_Expression (Tree));
               Disp_Xml_List(e,+"guard_sensitivity_list",
            Get_Guard_Sensitivity_List (Tree));
            end if;
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Constant_Declaration|
           Iir_Kind_Iterator_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            if Kind = Iir_Kind_Constant_Declaration then
               flag(e,+"deferred_flag",+ (Boolean'Image
                       (Get_Deferred_Declaration_Flag (Tree))));
               Disp_Xml(e,+"deferred",
            Get_Deferred_Declaration (Tree),
             True);
               Disp_Xml(e,+"default_value",
            Get_Default_Value (Tree),
             True);
            end if;
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Variable_Declaration =>
            if Flat_Decl then
               return;
            end if;
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"default_value",
            Get_Default_Value (Tree),
             True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_File_Declaration =>
            if Flat_Decl then
               return;
            end if;
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"logical_name",
            Get_File_Logical_Name (Tree));
            flag(e,+"mode",
            + (Iir_Mode'Image (Get_Mode (Tree))));
            Disp_Xml(e,+"file_open_kind",
            Get_File_Open_Kind (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Type_Declaration|
           Iir_Kind_Subtype_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml(e,+"type_(definition)",
            Get_Type (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Anonymous_Type_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml(e,+"type_(definition)",
            Get_Type (Tree));
         when Iir_Kind_Component_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml_Chain(e,+"generic_chain",
            Get_Generic_Chain (Tree));
            Disp_Xml_Chain(e,+"port_chain",
            Get_Port_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Element_Declaration =>
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Record_Element_Constraint =>
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"element_declaration",
            Get_Element_Declaration (Tree));
         when Iir_Kind_Attribute_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Psl_Declaration =>
            if Flat_Decl then
               return;
            end if;
         when Iir_Kind_Psl_Expression =>
            return;
         when Iir_Kind_Function_Declaration|
           Iir_Kind_Procedure_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml_Chain(e,+"interface_declaration_chain",
            Get_Interface_Declaration_Chain (Tree));
            if Kind = Iir_Kind_Function_Declaration then
               Disp_Xml(e,+"return_type",
            Get_Return_Type (Tree),
             True);
               flag(e,+"pure_flag",
             Disp_Flag(Get_Pure_Flag (Tree)));
            else
               flag(e,+"purity_state",
             Disp_Purity_State(Get_Purity_State (Tree)));
            end if;
            flag(e,+"wait_state",
             Disp_State(Get_Wait_State (Tree)));
            flag(e,+"all_sensitized_state",
            + (Iir_All_Sensitized'Image
                      (Get_All_Sensitized_State (Tree))));
            flag(e,+"subprogram_depth",
             Disp_Depth(Get_Subprogram_Depth (Tree)));
            child := Disp_Xml_Flat(e,+"subprogram_body",
            Get_Subprogram_Body (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Procedure_Body|
           Iir_Kind_Function_Body =>
            child := Disp_Xml_Flat(e,+"specification",
            Get_Subprogram_Specification (Tree));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"statements",
            Get_Sequential_Statement_Chain (Tree));
         when Iir_Kind_Implicit_Function_Declaration =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"operation",
            + (Iir_Predefined_Functions'Image
                    (Get_Implicit_Definition (Tree))));
            Disp_Xml_Chain(e,+"interface_declaration_chain",
            Get_Interface_Declaration_Chain (Tree));
            Disp_Xml(e,+"return_type",
            Get_Return_Type (Tree),
             True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Implicit_Procedure_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml_Chain(e,+"interface_declaration_chain",
            Get_Interface_Declaration_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Object_Alias_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml(e,+"name",Get_Name (Tree));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Non_Object_Alias_Declaration =>
            if Flat_Decl then
               return;
            end if;
            Disp_Xml(e,+"name",Get_Name (Tree));
            Disp_Xml(e,+"signature",Get_Signature (Tree),
             True);
         when Iir_Kind_Group_Template_Declaration =>
            Disp_Xml_Chain(e,+"entity_class_entry",
            Get_Entity_Class_Entry_Chain (Tree));
         when Iir_Kind_Group_Declaration =>
            Disp_Xml_List_Flat(e,+"group_constituent_list",
            Get_Group_Constituent_List (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Enumeration_Type_Definition =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"type_declarator",
            Get_Type_Declarator (Tree));
            Disp_Xml_List(e,+"literals",
            Get_Enumeration_Literal_List (Tree));
         when Iir_Kind_Integer_Type_Definition|
           Iir_Kind_Floating_Type_Definition =>
            if Flat_Decl and then not Is_Anonymous_Type_Definition (Tree)
            then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"type_declarator",
            Get_Type_Declarator (Tree));
         when Iir_Kind_Integer_Subtype_Definition|
           Iir_Kind_Floating_Subtype_Definition|
           Iir_Kind_Physical_Subtype_Definition|
           Iir_Kind_Enumeration_Subtype_Definition|
           Iir_Kind_Subtype_Definition =>
            if Flat_Decl
              and then Kind /= Iir_Kind_Subtype_Definition
              and then Get_Type_Declarator (Tree) /= Null_Iir
            then
               return;
            end if;
            if Kind /= Iir_Kind_Subtype_Definition then
               flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
               flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
               flag(e,+"signal_type_flag",
             Disp_Flag(Get_Signal_Type_Flag (Tree)));
               flag(e,+"has_signal_flag",
             Disp_Flag(Get_Has_Signal_Flag (Tree)));
               Disp_Xml(e,+"type_declarator",
            Get_Type_Declarator (Tree),
             True);
               Disp_Xml(e,+"base_type",Get_Base_Type (Tree),
             True);
            end if;
            Disp_Xml(e,+"type_mark",Get_Type_Mark (Tree),
             True);
            child := Disp_Xml_Flat(e,+"resolution_function",
            Get_Resolution_Function (Tree));
            Disp_Xml(e,+"range_constraint",
            Get_Range_Constraint (Tree));
         when Iir_Kind_Range_Expression =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            Disp_Xml(e,+"left_limit",Get_Left_Limit (Tree),
             True);
            Disp_Xml(e,+"right_limit",
            Get_Right_Limit (Tree),
             True);
            flag(e,+"direction",
            + (Iir_Direction'Image (Get_Direction (Tree))));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Array_Subtype_Definition =>
            if Flat_Decl and then Get_Type_Declarator (Tree) /= Null_Iir then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            flag(e,+"signal_type_flag",
             Disp_Flag(Get_Signal_Type_Flag (Tree)));
            flag(e,+"has_signal_flag",
             Disp_Flag(Get_Has_Signal_Flag (Tree)));
            child := Disp_Xml_Flat(e,+"type_declarator",
            Get_Type_Declarator (Tree));
            declare
               Base : constant Iir := Get_Base_Type (Tree);
               Fl : Boolean;
            begin
               if Base /= Null_Iir
                 and then Get_Kind (Base) = Iir_Kind_Array_Type_Definition
               then
                  Fl := Get_Type_Declarator (Base)
                    /= Get_Type_Declarator (Tree);
               else
                  Fl := False;
               end if;
               Disp_Xml (e,+"base", Base, Fl);
            end;
            Disp_Xml(e,+"type_mark",Get_Type_Mark (Tree),
             True);
            Disp_Xml_List(e,+"index_subtype_list",
            Get_Index_Subtype_List (Tree),
             True);
            Disp_Xml(e,+"element_subtype",
            Get_Element_Subtype (Tree),
             True);
            child := Disp_Xml_Flat(e,+"resolution_function",
            Get_Resolution_Function (Tree));
            flag(e,+"index_constraint",
             Disp_Flag(Get_Index_Constraint_Flag (Tree)));
            flag(e,+"constraint_state",
            + (Iir_Constraint'Image (Get_Constraint_State (Tree))));
         when Iir_Kind_Array_Type_Definition =>
            if Flat_Decl and then Get_Type_Declarator (Tree) /= Null_Iir then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            flag(e,+"signal_type_flag",
             Disp_Flag(Get_Signal_Type_Flag (Tree)));
            flag(e,+"has_signal_flag",
             Disp_Flag(Get_Has_Signal_Flag (Tree)));
            Disp_Xml_List(e,+"index_subtype_list",
            Get_Index_Subtype_List (Tree),
             True);
            Disp_Xml(e,+"element_subtype",
            Get_Element_Subtype (Tree),
             True);
         when Iir_Kind_Record_Type_Definition =>
            if Flat_Decl and then Get_Type_Declarator (Tree) /= Null_Iir then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            flag(e,+"signal_type_flag",
             Disp_Flag(Get_Signal_Type_Flag (Tree)));
            flag(e,+"has_signal_flag",
             Disp_Flag(Get_Has_Signal_Flag (Tree)));
            flag(e,+"constraint_state",
            + (Iir_Constraint'Image (Get_Constraint_State (Tree))));
            Disp_Xml_List(e,+"elements",
            Get_Elements_Declaration_List (Tree),
             True);
         when Iir_Kind_Record_Subtype_Definition =>
            if Flat_Decl and then not Is_Anonymous_Type_Definition (Tree) then
               return;
            end if;
            child := Disp_Xml_Flat(e,+"type_declarator",
            Get_Type_Declarator (Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            flag(e,+"signal_type_flag",
             Disp_Flag(Get_Signal_Type_Flag (Tree)));
            Disp_Xml(e,+"base_type",Get_Base_Type (Tree),
             True);
            Disp_Xml(e,+"type_mark",Get_Type_Mark (Tree),
             True);
            child := Disp_Xml_Flat(e,+"resolution_function",
            Get_Resolution_Function (Tree));
            flag(e,+"constraint_state",
            + (Iir_Constraint'Image (Get_Constraint_State (Tree))));
            Disp_Xml_List(e,+"elements",
            Get_Elements_Declaration_List (Tree),
             True);
         when Iir_Kind_Physical_Type_Definition =>
            if Flat_Decl and then Get_Type_Declarator (Tree) /= Null_Iir then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            child := Disp_Xml_Flat(e,+"declarator",
            Get_Type_Declarator (Tree));
            Disp_Xml_Chain(e,+"unit_chain",
            Get_Unit_Chain (Tree));
         when Iir_Kind_Unit_Declaration =>
            if Flat_Decl then
               return;
            end if;
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"physical_literal",
            Get_Physical_Literal (Tree),
             True);
            Disp_Xml(e,+"physical_Unit_Value",
            Get_Physical_Unit_Value (Tree),
             True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Access_Type_Definition =>
            if Flat_Decl then
               return;
            end if;
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            flag(e,+"signal_type_flag",
             Disp_Flag(Get_Signal_Type_Flag (Tree)));
            child := Disp_Xml_Flat(e,+"declarator",
            Get_Type_Declarator (Tree));
            child := Disp_Xml_Flat(e,+"designated_type",
            Get_Designated_Type (Tree));
         when Iir_Kind_Access_Subtype_Definition =>
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            flag(e,+"resolved_flag",
             Disp_Type_Resolved_Flag(Tree));
            child := Disp_Xml_Flat(e,+"declarator",
            Get_Type_Declarator (Tree));
            Disp_Xml(e,+"base_type",Get_Base_Type (Tree),
             True);
            Disp_Xml(e,+"type_mark",Get_Type_Mark (Tree),
             True);
            child := Disp_Xml_Flat(e,+"designated_type",
            Get_Designated_Type (Tree));
            child := Disp_Xml_Flat(e,+"resolution_function",
            Get_Resolution_Function (Tree));
         when Iir_Kind_Incomplete_Type_Definition =>
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"declarator",
            Get_Type_Declarator (Tree));
            Disp_Xml(e,+"base_type",Get_Base_Type (Tree),
             True);
         when Iir_Kind_File_Type_Definition =>
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"declarator",
            Get_Type_Declarator (Tree));
            child := Disp_Xml_Flat(e,+"type_mark",
            Get_Type_Mark (Tree));
         when Iir_Kind_Protected_Type_Declaration =>
            flag(e,+"staticness",
             Disp_Type_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"declarator",
            Get_Type_Declarator (Tree));
            child := Disp_Xml_Flat(e,+"protected_type_body",
            Get_Protected_Type_Body (Tree));
            Disp_Xml_Chain(e,+"declarative_part",
            Get_Declaration_Chain (Tree));
         when Iir_Kind_Protected_Type_Body =>
            child := Disp_Xml_Flat(e,
            +"protected_type_declaration",
            Get_Protected_Type_Declaration (Tree));
            Disp_Xml_Chain(e,+"declarative_part",
            Get_Declaration_Chain (Tree));
         when Iir_Kind_Block_Statement =>
            if Flat_Decl then
               return;
            end if;
            Disp_Label(e,Tree);
            Disp_Xml(e,+"guard_decl",Get_Guard_Decl (Tree));
            Disp_Xml(e,+"block_header",
            Get_Block_Header (Tree));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"concurrent_statements",
            Get_Concurrent_Statement_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Generate_Statement =>
            if Flat_Decl then
               return;
            end if;
            Disp_Label(e,Tree);
            Disp_Xml(e,+"generation_scheme",
            Get_Generation_Scheme (Tree));
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"concurrent_statements",
            Get_Concurrent_Statement_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Component_Instantiation_Statement =>
            Disp_Label(e,Tree);
            Disp_Xml(e,+"instantiated_unit",
            Get_Instantiated_Unit (Tree),
             True);
            Disp_Xml_Chain(e,+"generic_map_aspect_chain",
            Get_Generic_Map_Aspect_Chain (Tree));
            Disp_Xml_Chain(e,+"port_map_aspect_chain",
            Get_Port_Map_Aspect_Chain (Tree));
            Disp_Xml(e,+"component_configuration",
            Get_Component_Configuration (Tree));
            Disp_Xml(e,+"default_binding_indication",
            Get_Default_Binding_Indication (Tree),
             True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Concurrent_Conditional_Signal_Assignment =>
            flag(e,+"guarded_target_flag",
            + (Tri_State_Type'Image (Get_Guarded_Target_State (Tree))));
            Disp_Xml(e,+"target",Get_Target (Tree), True);
            if Get_Guard (Tree) = Tree then
               flag(e,+"guard",
            + ("guarded" & "guard: guarded"));
            else
               child := Disp_Xml_Flat(e,+"guard",
            Get_Guard (Tree));
            end if;
            Disp_Xml_Chain(e,+"conditional_waveform_chain",
            Get_Conditional_Waveform_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Concurrent_Selected_Signal_Assignment =>
            flag(e,+"guarded_target_flag",
            + (Tri_State_Type'Image (Get_Guarded_Target_State (Tree))));
            Disp_Xml(e,+"target",Get_Target (Tree), True);
            if Get_Guard (Tree) = Tree then
               flag(e,+"guard",
            + ("guarded" & "guard: guarded"));
            else
               child := Disp_Xml_Flat(e,+"guard",
            Get_Guard (Tree));
            end if;
            Disp_Xml_Chain(e,+"choices",
            Get_Selected_Waveform_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Concurrent_Assertion_Statement =>
            Disp_Xml(e,+"condition",
            Get_Assertion_Condition (Tree));
            Disp_Xml(e,+"report_expression",
            Get_Report_Expression (Tree));
            Disp_Xml(e,+"severity_expression",
            Get_Severity_Expression (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Psl_Assert_Statement =>
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Psl_Default_Clock =>
            null;
         when Iir_Kind_Sensitized_Process_Statement|
           Iir_Kind_Process_Statement =>
            Disp_Label(e,Tree);
            flag(e,+"passive",
            + (Boolean'Image (Get_Passive_Flag (Tree))));
            if Kind = Iir_Kind_Sensitized_Process_Statement then
               Disp_Xml_List(e,+"sensivity_list",
            Get_Sensitivity_List (Tree),
             True);
            end if;
            Disp_Xml_Chain(e,+"declaration_chain",
            Get_Declaration_Chain (Tree));
            Disp_Xml_Chain(e,+"process_statements",
            Get_Sequential_Statement_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_If_Statement =>
            Disp_Xml(e,+"condition",Get_Condition (Tree),
             True);
            Disp_Xml_Chain(e,+"then_sequence",
            Get_Sequential_Statement_Chain (Tree));
            Disp_Xml(e,+"elsif",Get_Else_Clause (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Elsif =>
            Disp_Xml(e,+"condition",Get_Condition (Tree));
            Disp_Xml_Chain(e,+"then_sequence",
            Get_Sequential_Statement_Chain (Tree));
            Disp_Xml(e,+"elsif",Get_Else_Clause (Tree));
         when Iir_Kind_For_Loop_Statement =>
            Disp_Xml(e,+"iterator",
            Get_Iterator_Scheme (Tree));
            Disp_Xml_Chain(e,+"statements",
            Get_Sequential_Statement_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_While_Loop_Statement =>
            Disp_Xml(e,+"condition",Get_Condition (Tree));
            Disp_Xml_Chain(e,+"statements",
            Get_Sequential_Statement_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Case_Statement =>
            Disp_Xml(e,+"expression",Get_Expression (Tree),
             True);
            Disp_Xml_Chain(e,+"choices_chain",
            Get_Case_Statement_Alternative_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Signal_Assignment_Statement =>
            flag(e,+"guarded_target_flag",
            + (Tri_State_Type'Image (Get_Guarded_Target_State (Tree))));
            Disp_Xml(e,+"target",Get_Target (Tree), True);
            Disp_Xml_Chain(e,+"waveform_chain",
            Get_Waveform_Chain (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Variable_Assignment_Statement =>
            Disp_Xml(e,+"target",Get_Target (Tree), True);
            Disp_Xml(e,+"expression",Get_Expression (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Assertion_Statement =>
            Disp_Xml(e,+"condition",
            Get_Assertion_Condition (Tree));
            Disp_Xml(e,+"report_expression",
            Get_Report_Expression (Tree));
            Disp_Xml(e,+"severity_expression",
            Get_Severity_Expression (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Report_Statement =>
            Disp_Xml(e,+"report_expression",
            Get_Report_Expression (Tree));
            Disp_Xml(e,+"severity_expression",
            Get_Severity_Expression (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Return_Statement =>
            Disp_Xml(e,+"expression",Get_Expression (Tree),
             True);
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Wait_Statement =>
            Disp_Xml_List(e,+"sensitivity_list",
            Get_Sensitivity_List (Tree),
             True);
            Disp_Xml(e,+"condition",
            Get_Condition_Clause (Tree));
            Disp_Xml(e,+"timeout",
            Get_Timeout_Clause (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Procedure_Call_Statement|
           Iir_Kind_Concurrent_Procedure_Call_Statement =>
            Disp_Label(e,Tree);
            Disp_Xml(e,+"procedure_call",
            Get_Procedure_Call (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Procedure_Call =>
            Disp_Xml(e,+"implementation",
            Get_Implementation (Tree),
             True);
            Disp_Xml(e,+"method_object",
            Get_Method_Object (Tree));
            Disp_Xml_Chain(e,+"parameters",
            Get_Parameter_Association_Chain (Tree));
         when Iir_Kind_Exit_Statement|
           Iir_Kind_Next_Statement =>
            child := Disp_Xml_Flat(e,+"loop",
            Get_Loop (Tree));
            Disp_Xml(e,+"condition",Get_Condition (Tree));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kind_Null_Statement =>
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
         when Iir_Kinds_Dyadic_Operator =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            Disp_Xml(e,+"implementation",
            Get_Implementation (Tree),
             True);
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"left",Get_Left (Tree), True);
            Disp_Xml(e,+"right",Get_Right (Tree), True);
         when Iir_Kinds_Monadic_Operator =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            Disp_Xml(e,+"implementation",
            Get_Implementation (Tree),
             True);
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"operand",Get_Operand (Tree), True);
         when Iir_Kind_Function_Call =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            child := Disp_Xml_Flat(e,+"implementation",
            Get_Implementation (Tree));
            Disp_Xml(e,+"method_object",
            Get_Method_Object (Tree));
            Disp_Xml_Chain(e,+"parameters",
            Get_Parameter_Association_Chain (Tree));
         when Iir_Kind_Qualified_Expression =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"type_mark",Get_Type_Mark (Tree),
             True);
            Disp_Xml(e,+"expression",Get_Expression (Tree),
             True);
         when Iir_Kind_Type_Conversion =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"expression",Get_Expression (Tree),
             True);
         when Iir_Kind_Allocator_By_Expression =>
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"expression",Get_Expression (Tree),
             True);
         when Iir_Kind_Allocator_By_Subtype =>
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"subtype_indication",
            Get_Expression (Tree),
             True);
         when Iir_Kind_Selected_Element =>
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
            Disp_Xml(e,+"selected_element",
            Get_Selected_Element (Tree),
             True);
         when Iir_Kind_Implicit_Dereference|
           Iir_Kind_Dereference =>
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
         when Iir_Kind_Aggregate =>
            flag(e,+"value",
             Disp_Staticness(Get_Value_Staticness (Tree)));
            flag(e,+"staticness-expr",
             Disp_Expr_Staticness(Tree));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"aggregate_info",
            Get_Aggregate_Info (Tree));
            Disp_Xml_Chain(e,+"associations",
            Get_Association_Choices_Chain (Tree));
         when Iir_Kind_Aggregate_Info =>
            flag(e,+"aggr_others_flag",
             Disp_Flag(Get_Aggr_Others_Flag (Tree)));
            flag(e,+"aggr_named_flag",
             Disp_Flag(Get_Aggr_Named_Flag (Tree)));
            flag(e,+"aggr_dynamic_flag",
             Disp_Flag(Get_Aggr_Dynamic_Flag (Tree)));
            Disp_Xml(e,+"aggr_low_limit",
            Get_Aggr_Low_Limit (Tree),
             False);
            Disp_Xml(e,+"aggr_high_limit",
            Get_Aggr_High_Limit (Tree),
             False);
            flag(e,+"aggr_max_length",
            + (Iir_Int32'Image (Get_Aggr_Max_Length (Tree))));
            Disp_Xml(e,+"sub_aggregate_info",
            Get_Sub_Aggregate_Info (Tree));
         when Iir_Kind_Operator_Symbol =>
            null;
         when Iir_Kind_Simple_Name =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Indexed_Name =>
            flag(e,+"staticness",
             Disp_Name_Staticness(Tree));
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
            Disp_Xml_List(e,+"index",Get_Index_List (Tree),
             True);
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Slice_Name =>
            flag(e,+"staticness",
             Disp_Name_Staticness(Tree));
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
            Disp_Xml(e,+"suffix",Get_Suffix (Tree));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Parenthesis_Name =>
            Disp_Xml(e,+"prefix",Get_Prefix (Tree),
             Flat_Decl);
            Disp_Xml_Chain(e,+"association_chain",
            Get_Association_Chain (Tree));
         when Iir_Kind_Selected_By_All_Name =>
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
            Disp_Xml(e,+"type",Get_Type (Tree), True);
         when Iir_Kind_Selected_Name =>
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
            flag(e,+"identifier",
             Disp_Ident(Get_Suffix_Identifier (Tree)));
         when Iir_Kind_Attribute_Name =>
            Disp_Xml(e,+"prefix",Get_Prefix (Tree), True);
            Disp_Xml(e,+"signature",Get_Signature (Tree));
         when Iir_Kind_Base_Attribute =>
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Left_Type_Attribute|
           Iir_Kind_Right_Type_Attribute|
           Iir_Kind_High_Type_Attribute|
           Iir_Kind_Low_Type_Attribute|
           Iir_Kind_Ascending_Type_Attribute =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Image_Attribute|
           Iir_Kind_Value_Attribute =>
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"parameter",Get_Parameter (Tree));
         when Iir_Kind_Pos_Attribute|
           Iir_Kind_Val_Attribute|
           Iir_Kind_Succ_Attribute|
           Iir_Kind_Pred_Attribute|
           Iir_Kind_Leftof_Attribute|
           Iir_Kind_Rightof_Attribute =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"parameter",Get_Parameter (Tree));
         when Iir_Kind_Left_Array_Attribute|
           Iir_Kind_Right_Array_Attribute|
           Iir_Kind_High_Array_Attribute|
           Iir_Kind_Low_Array_Attribute|
           Iir_Kind_Range_Array_Attribute|
           Iir_Kind_Reverse_Range_Array_Attribute|
           Iir_Kind_Length_Array_Attribute|
           Iir_Kind_Ascending_Array_Attribute =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"parameter",Get_Parameter (Tree));
         when Iir_Kind_Delayed_Attribute|
           Iir_Kind_Stable_Attribute|
           Iir_Kind_Quiet_Attribute|
           Iir_Kind_Transaction_Attribute =>
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            if Kind /= Iir_Kind_Transaction_Attribute then
               Disp_Xml(e,+"parameter",
            Get_Parameter (Tree));
            end if;
            flag(e,+"has_active_flag",
             Disp_Flag(Get_Has_Active_Flag (Tree)));
         when Iir_Kind_Event_Attribute|
           Iir_Kind_Active_Attribute|
           Iir_Kind_Last_Event_Attribute|
           Iir_Kind_Last_Active_Attribute|
           Iir_Kind_Last_Value_Attribute|
           Iir_Kind_Driving_Attribute|
           Iir_Kind_Driving_Value_Attribute =>
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Behavior_Attribute|
           Iir_Kind_Structure_Attribute =>
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Simple_Name_Attribute|
           Iir_Kind_Instance_Name_Attribute|
           Iir_Kind_Path_Name_Attribute =>
            child := Disp_Xml_Flat(e,+"prefix",
            Get_Prefix (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Enumeration_Literal =>
            if Flat_Decl and then Get_Literal_Origin (Tree) = Null_Iir then
               return;
            end if;
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            flag(e,+"value",
            + (Iir_Int32'Image (Get_Enum_Pos (Tree))));
            Disp_Xml_Flat_Chain(e,+"attribute_value_chain",
            Get_Attribute_Value_Chain (Tree));
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree),
             True);
         when Iir_Kind_Integer_Literal =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree),
             True);
         when Iir_Kind_Floating_Point_Literal =>
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree),
             True);
         when Iir_Kind_String_Literal =>
            flag(e,+"value",
            + (Iirs_Utils.Image_String_Lit (Tree) ));
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree),
             True);
         when Iir_Kind_Bit_String_Literal =>
            flag(e,+"base",
            + (Base_Type'Image (Get_Bit_String_Base (Tree))));
            flag(e,+"value",
            + (Iirs_Utils.Image_String_Lit (Tree) ));
            flag(e,+"len",
            + (Int32'Image (Get_String_Length (Tree))));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Character_Literal =>
            flag(e,+"value",
            + (Name_Table.Get_Character (Get_Identifier (Tree)) ));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Physical_Int_Literal =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            flag(e,+"value",
            + (Iir_Int64'Image (Get_Value (Tree))));
            child := Disp_Xml_Flat(e,+"unit_name",
            Get_Unit_Name (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree));
         when Iir_Kind_Physical_Fp_Literal =>
            flag(e,+"staticness",
             Disp_Expr_Staticness(Tree));
            flag(e,+"fp_value",
            + (Iir_Fp64'Image (Get_Fp_Value (Tree))));
            child := Disp_Xml_Flat(e,+"unit_name",
            Get_Unit_Name (Tree));
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree));
         when Iir_Kind_Null_Literal =>
            child := Disp_Xml_Flat(e,+"type",
            Get_Type (Tree));
         when Iir_Kind_Simple_Aggregate =>
            Disp_Xml_List(e,+"simple_aggregate_list",
            Get_Simple_Aggregate_List (Tree),
             True);
            Disp_Xml(e,+"type",Get_Type (Tree), True);
            Disp_Xml(e,+"origin",Get_Literal_Origin (Tree),
             True);
         when Iir_Kind_Proxy =>
            child := Disp_Xml_Flat(e,+"proxy",
            Get_Proxy (Tree));
         when Iir_Kind_Entity_Class =>
            null;
      end case;
   end Disp_Xml;

   --  procedure Disp_Xml_For_Psl (N : Int32) is
   --  begin
   --     Disp_Xml_Flat (Iir (N), 1);
   --  end Disp_Xml_For_Psl;
end Disp_Xml;
