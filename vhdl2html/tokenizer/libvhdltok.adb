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

package body libvhdltok is
   
   procedure Vhdltok_Init is
   begin
      
        Ada.Text_IO'Elab_Spec;
        Ada.Text_IO'Elab_Body;
      
	System.Exceptions'Elab_Spec ;
        System.Exception_Table'Elab_Body ;
	
        System.Soft_Links'Elab_Spec ;
        System.Soft_Links'Elab_Body ;
	
        System.Secondary_Stack'Elab_Body ;
    --  Ada.Exceptions'Elab_Spec ;
    --  Ada.Exceptions'Elab_Body ;
        Ada.Io_Exceptions'Elab_Spec ;
    --  System.Finalization_Implementation'Elab_Spec ;
    --  System.Finalization_Implementation'Elab_Body ;
        System.Finalization_Root'Elab_Spec ;
        Ada.Finalization'Elab_Spec ;
    --  Ada.Finalization.List_Controller'Elab_Spec ;      
    
	Str_Table.Initialize;
	Files_Map.Initialize;
	lists.Initialize;
	Nodes.Initialize;
	Std_Names.Std_Names_Initialize; -- Name_Table.Initialize;
	
   end  Vhdltok_Init;
   
   procedure Vhdltok_Scan is
      S : Source_File_Entry;
      I : String_Id;
      I0 : Name_Id;
      I1 : Name_Id;
   begin
      
      Put_Line("Inside libvhdltok");
      
      I := Str_Table.Start;
      I0 := Get_Identifier ("./");
      I1 := Get_Identifier ("e1.vhd");
      
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
      
      Put_Line("Exit libvhdltok");
      
   end Vhdltok_Scan;
   
end libvhdltok;

