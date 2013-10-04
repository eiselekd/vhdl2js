with Scan; use Scan;
with Files_Map; use Files_Map;
with Types; use Types;
with Ada.Text_IO; use Ada.Text_IO;
with Name_Table; use Name_Table;
with GNAT.Table;
with Types; use Types;
with Lists; use Lists;
with Nodes; use Nodes;
with Std_Names; 

with System.Exceptions ;
with System.Soft_Links ;
with System.Secondary_Stack ;
--with System.Finalization_Implementation ;
with System.Finalization_Root ;

with Ada.Exceptions ;
with Ada.Io_Exceptions ;
with Ada.Finalization ;
--with Ada.Finalization.List_Controller ;
with Name_Table; use Name_Table;
with Str_Table; use Str_Table;
with Tokens; use Tokens;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body libvhdltok is
   
   package SSL renames System.Soft_Links;
   
   procedure Vhdltok_Init_Static is
   begin
      
      
--	System.Exceptions'Elab_Spec ;
--        System.Exception_Table'Elab_Body ;
	
--        System.Soft_Links'Elab_Spec ;
--        System.Soft_Links'Elab_Body ;
	
        System.Secondary_Stack'Elab_Body ;
    --  Ada.Exceptions'Elab_Spec ;
    --  Ada.Exceptions'Elab_Body ;
        Ada.Io_Exceptions'Elab_Spec ;
    --  System.Finalization_Implementation'Elab_Spec ;
    --  System.Finalization_Implementation'Elab_Body ;
        System.Finalization_Root'Elab_Spec ;
        Ada.Finalization'Elab_Spec ;
    --  Ada.Finalization.List_Controller'Elab_Spec ;      
	
        Ada.Text_IO'Elab_Spec;
        Ada.Text_IO'Elab_Body;
	
   end  Vhdltok_Init_Static;
   
   procedure Vhdltok_Init is
   begin
	
	Str_Table.Initialize;
	Files_Map.Initialize;
	lists.Initialize;
	Nodes.Initialize;
	Std_Names.Std_Names_Initialize; -- Name_Table.Initialize;
	
   end  Vhdltok_Init;
   
   function Value_Without_Exception(S : chars_ptr) return String is
      -- Translate S from a C-style char* into an Ada String.
      -- If S is Null_Ptr, return "", don't raise an exception.
   begin
      if S = Null_Ptr then return "";
      else return Value(S);
      end if;
   end Value_Without_Exception;
 
 pragma Inline(Value_Without_Exception);   
   procedure Vhdltok_Scan(D : Chars_Ptr; F : chars_ptr) is
      S : Source_File_Entry;
      I : String_Id;
      I0 : Name_Id;
      I1 : Name_Id;
      DAda : String := Value_Without_Exception(D);
      FAda : String := Value_Without_Exception(F);
   begin
      
      Put_Line("Inside libvhdltok");
      
      I := Str_Table.Start;
      I0 := Get_Identifier (DAda);
      I1 := Get_Identifier (FAda);
      
      S := Files_Map.Load_Source_File(I0,I1);
      if S /= No_Source_File_Entry then
	 Put_Line("scanning: " & Image(I1));
	 Scan.Set_File(S);
	 
	 loop
	    Scan.Scan;
	    if Current_Token = Tok_Eof then
	       exit;
	    end if;
	    
	    Put ( Token_Type'Image (Current_Token) & " ");
	    if Current_Token = Tok_Identifier then
	       Put ("(identifier:" & Name_Table.Image (Current_Identifier) & ")");
	    end if;
	    Put(" " & Natural'Image(Get_Current_Line) & ":" & Natural'Image(Get_Current_Column));
	    New_Line;
	    
	 end loop;
	    
      end if;
      
      SSL.Lock_Task.all;
      SSL.Unlock_Task.all;

      Put_Line("Exit libvhdltok");
      
   end Vhdltok_Scan;
   
end libvhdltok;

