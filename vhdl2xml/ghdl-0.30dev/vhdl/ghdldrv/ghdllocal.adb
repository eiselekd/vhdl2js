--  GHDL driver - local commands.
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
with Ada.Text_IO;
with Types; use Types;
with Libraries;
with Std_Package;
with Flags;
with Name_Table;
with Std_Names;
with Back_End;
with Disp_Vhdl;
with Default_Pathes;
with Scan;
with Sem;
with Canon;
with Errorout;
with Configuration;
with Files_Map;
with Post_Sems;
with Disp_Tree;
with Options;

package body Ghdllocal is
   --  Version of the IEEE library to use.  This just change pathes.
   type Ieee_Lib_Kind is (Lib_Standard, Lib_None, Lib_Synopsys, Lib_Mentor);
   Flag_Ieee : Ieee_Lib_Kind;

   Flag_Create_Default_Config : constant Boolean := True;

   --  If TRUE, generate 32bits code on 64bits machines.
   Flag_32bit : Boolean := False;

   procedure Finish_Compilation
     (Unit : Iir_Design_Unit; Main : Boolean := False)
   is
      use Errorout;
      use Ada.Text_IO;
      Config : Iir_Design_Unit;
      Lib : Iir;
   begin
      if (Main or Flags.Dump_All) and then Flags.Dump_Parse then
         Disp_Tree.Disp_Tree (Unit);
      end if;

      if Flags.Verbose then
         Put_Line ("semantize " & Disp_Node (Get_Library_Unit (Unit)));
      end if;

      Sem.Semantic (Unit);

      if (Main or Flags.Dump_All) and then Flags.Dump_Sem then
         Disp_Tree.Disp_Tree (Unit);
      end if;

      if Errorout.Nbr_Errors > 0 then
         raise Compilation_Error;
      end if;

      --Disp_Vhdl.Disp_Vhdl (Unit);
      if (Main or Flags.List_All) and then Flags.List_Sem then
         Disp_Vhdl.Disp_Vhdl (Unit);
      end if;

      Post_Sems.Post_Sem_Checks (Unit);

      if Errorout.Nbr_Errors > 0 then
         raise Compilation_Error;
      end if;

      if Flags.Flag_Elaborate then
         if Flags.Verbose then
            Put_Line ("canonicalize " & Disp_Node (Get_Library_Unit (Unit)));
         end if;

         Canon.Canonicalize (Unit);

         if Flag_Create_Default_Config then
            Lib := Get_Library_Unit (Unit);
            if Get_Kind (Lib) = Iir_Kind_Architecture_Declaration then
               Config := Canon.Create_Default_Configuration_Declaration (Lib);
               Set_Default_Configuration_Declaration (Lib, Config);
            end if;
         end if;
      end if;
   end Finish_Compilation;

   procedure Init (Cmd : in out Command_Lib)
   is
      pragma Unreferenced (Cmd);
   begin
      Options.Initialize;
      Flag_Ieee := Lib_Standard;
      Back_End.Finish_Compilation := Finish_Compilation'Access;
      Flag_Verbose := False;
   end Init;

   procedure Decode_Option (Cmd : in out Command_Lib;
                            Option : String;
                            Arg : String;
                            Res : out Option_Res)
   is
      pragma Unreferenced (Cmd);
      pragma Unreferenced (Arg);
      Opt : constant String (1 .. Option'Length) := Option;
   begin
      Res := Option_Bad;
      if Opt = "-v" and then Flag_Verbose = False then
         Flag_Verbose := True;
         Res := Option_Ok;
      elsif Opt'Length > 9 and then Opt (1 .. 9) = "--PREFIX=" then
         Prefix_Path := new String'(Opt (10 .. Opt'Last));
         Res := Option_Ok;
      elsif Opt = "--ieee=synopsys" then
         Flag_Ieee := Lib_Synopsys;
         Res := Option_Ok;
      elsif Opt = "--ieee=mentor" then
         Flag_Ieee := Lib_Mentor;
         Res := Option_Ok;
      elsif Opt = "--ieee=none" then
         Flag_Ieee := Lib_None;
         Res := Option_Ok;
      elsif Opt = "--ieee=standard" then
         Flag_Ieee := Lib_Standard;
         Res := Option_Ok;
      elsif Opt = "-m32" then
         Flag_32bit := True;
         Res := Option_Ok;
      elsif Opt'Length >= 2
        and then (Opt (2) = 'g' or Opt (2) = 'O')
      then
         --  Silently accept -g and -O.
         Res := Option_Ok;
      else
         if Options.Parse_Option (Opt) then
            Res := Option_Ok;
         end if;
      end if;
   end Decode_Option;

   procedure Disp_Long_Help (Cmd : Command_Lib)
   is
      pragma Unreferenced (Cmd);
      use Ada.Text_IO;
      procedure P (Str : String) renames Put_Line;
   begin
      P ("Main options (try --options-help for details):");
      P (" --std=XX       Use XX as VHDL standard (87,93c,93,00 or 02)");
      P (" --work=NAME    Set the name of the WORK library");
      P (" -PDIR          Add DIR in the library search path");
      P (" --workdir=DIR  Specify the directory of the WORK library");
      P (" --PREFIX=DIR   Specify installation prefix");
      P (" --ieee=NAME    Use NAME as ieee library, where name is:");
      P ("    standard: standard version (default)");
      P ("    synopsys, mentor: vendor version (not advised)");
      P ("    none: do not use a predefined ieee library");
   end Disp_Long_Help;

   function Get_Version_Path return String
   is
      use Flags;
   begin
      case Vhdl_Std is
         when Vhdl_87 =>
            return "v87";
         when Vhdl_93c
           | Vhdl_93
           | Vhdl_00
           | Vhdl_02 =>
            return "v93";
         when Vhdl_08 =>
            return "v08";
      end case;
   end Get_Version_Path;

   function Get_Machine_Path_Prefix return String is
   begin
      if Flag_32bit then
         return Prefix_Path.all & "32";
      else
         return Prefix_Path.all;
      end if;
   end Get_Machine_Path_Prefix;

   procedure Add_Library_Path (Name : String)
   is
   begin
      Libraries.Add_Library_Path
        (Get_Machine_Path_Prefix & Directory_Separator
         & Get_Version_Path & Directory_Separator
         & Name & Directory_Separator);
   end Add_Library_Path;

   procedure Setup_Libraries (Load : Boolean)
   is
   begin
      --  Get environment variable.
      Prefix_Env := GNAT.OS_Lib.Getenv ("GHDL_PREFIX");
      if Prefix_Env = null or else Prefix_Env.all = "" then
         Prefix_Env := null;
      end if;

      --  Set prefix path.
      --  If not set by command line, try environment variable.
      if Prefix_Path = null then
         Prefix_Path := Prefix_Env;
      end if;
      --  Else try default path.
      if Prefix_Path = null then
         Prefix_Path := new String'(Default_Pathes.Prefix);
      else
         -- Assume the user has set the correct path, so do not insert 32.
         Flag_32bit := False;
      end if;

      --  Add pathes for predefined libraries.
      if not Flags.Bootstrap then
         Add_Library_Path ("std");
         case Flag_Ieee is
            when Lib_Standard =>
               Add_Library_Path ("ieee");
            when Lib_Synopsys =>
               Add_Library_Path ("synopsys");
            when Lib_Mentor =>
               Add_Library_Path ("mentor");
            when Lib_None =>
               null;
         end case;
      end if;
      if Load then
         Libraries.Load_Std_Library;
         Libraries.Load_Work_Library;
      end if;
   end Setup_Libraries;

   procedure Disp_Library_Unit (Unit : Iir)
   is
      use Ada.Text_IO;
      use Name_Table;
      Id : Name_Id;
   begin
      Id := Get_Identifier (Unit);
      case Get_Kind (Unit) is
         when Iir_Kind_Entity_Declaration =>
            Put ("entity ");
         when Iir_Kind_Architecture_Declaration =>
            Put ("architecture ");
         when Iir_Kind_Configuration_Declaration =>
            Put ("configuration ");
         when Iir_Kind_Package_Declaration =>
            Put ("package ");
         when Iir_Kind_Package_Body =>
            Put ("package body ");
         when others =>
            Put ("???");
            return;
      end case;
      Image (Id);
      Put (Name_Buffer (1 .. Name_Length));
      case Get_Kind (Unit) is
         when Iir_Kind_Architecture_Declaration =>
            Put (" of ");
            Image (Get_Identifier (Get_Entity (Unit)));
            Put (Name_Buffer (1 .. Name_Length));
         when Iir_Kind_Configuration_Declaration =>
            if Id = Null_Identifier then
               Put ("<default> of entity ");
               Image (Get_Identifier (Get_Library_Unit (Get_Entity (Unit))));
               Put (Name_Buffer (1 .. Name_Length));
            end if;
         when others =>
            null;
      end case;
   end Disp_Library_Unit;

   procedure Disp_Library (Name : Name_Id)
   is
      use Ada.Text_IO;
      use Libraries;
      Lib : Iir_Library_Declaration;
      File : Iir_Design_File;
      Unit : Iir;
   begin
      if Name = Std_Names.Name_Work then
         Lib := Work_Library;
      elsif Name = Std_Names.Name_Std then
         Lib := Std_Library;
      else
         Lib := Get_Library (Name, Command_Line_Location);
      end if;

      --  Disp contents of files.
      File := Get_Design_File_Chain (Lib);
      while File /= Null_Iir loop
         Unit := Get_First_Design_Unit (File);
         while Unit /= Null_Iir loop
            Disp_Library_Unit (Get_Library_Unit (Unit));
            New_Line;
            Unit := Get_Chain (Unit);
         end loop;
         File := Get_Chain (File);
      end loop;
   end Disp_Library;

   --  Return FILENAME without the extension.
   function Get_Base_Name (Filename : String; Remove_Dir : Boolean := True)
                           return String
   is
      First : Natural;
      Last : Natural;
   begin
      First := Filename'First;
      Last := Filename'Last;
      for I in Filename'Range loop
         if Filename (I) = '.' then
            Last := I - 1;
         elsif Remove_Dir and then Filename (I) = Directory_Separator then
            First := I + 1;
            Last := Filename'Last;
         end if;
      end loop;
      return Filename (First .. Last);
   end Get_Base_Name;

   function Append_Suffix (File : String; Suffix : String) return String_Access
   is
      use Name_Table;
      Basename : constant String := Get_Base_Name (File);
   begin
      Image (Libraries.Work_Directory);
      Name_Buffer (Name_Length + 1 .. Name_Length + Basename'Length) :=
        Basename;
      Name_Length := Name_Length + Basename'Length;
      Name_Buffer (Name_Length + 1 .. Name_Length + Suffix'Length) := Suffix;
      Name_Length := Name_Length + Suffix'Length;
      return new String'(Name_Buffer (1 .. Name_Length));
   end Append_Suffix;


   --  Command Dir.
   type Command_Dir is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Dir; Name : String) return Boolean;
   function Get_Short_Help (Cmd : Command_Dir) return String;
   procedure Perform_Action (Cmd : in out Command_Dir; Args : Argument_List);

   function Decode_Command (Cmd : Command_Dir; Name : String) return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "-d" or else Name = "--dir";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Dir) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "-d or --dir        Disp contents of the work library";
   end Get_Short_Help;

   procedure Perform_Action (Cmd : in out Command_Dir; Args : Argument_List)
   is
      pragma Unreferenced (Cmd);
   begin
      if Args'Length /= 0 then
         Error ("command '-d' does not accept any argument");
         raise Option_Error;
      end if;

      Flags.Bootstrap := True;
      --  Load word library.
      Libraries.Load_Std_Library;
      Libraries.Load_Work_Library;

      Disp_Library (Std_Names.Name_Work);

--       else
--          for L in Libs'Range loop
--             Id := Get_Identifier (Libs (L).all);
--             Disp_Library (Id);
--          end loop;
--       end if;
   end Perform_Action;

   --  Command Find.
   type Command_Find is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Find; Name : String) return Boolean;
   function Get_Short_Help (Cmd : Command_Find) return String;
   procedure Perform_Action (Cmd : in out Command_Find; Args : Argument_List);

   function Decode_Command (Cmd : Command_Find; Name : String) return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "-f";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Find) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "-f FILEs           Disp units in FILES";
   end Get_Short_Help;

   --  Return TRUE is UNIT can be at the apex of a design hierarchy.
   function Is_Top_Entity (Unit : Iir) return Boolean
   is
   begin
      if Get_Kind (Unit) /= Iir_Kind_Entity_Declaration then
         return False;
      end if;
      if Get_Port_Chain (Unit) /= Null_Iir then
         return False;
      end if;
      if Get_Generic_Chain (Unit) /= Null_Iir then
         return False;
      end if;
      return True;
   end Is_Top_Entity;

   --  Disp contents design files FILES.
   procedure Perform_Action (Cmd : in out Command_Find; Args : Argument_List)
   is
      pragma Unreferenced (Cmd);

      use Ada.Text_IO;
      use Name_Table;
      Id : Name_Id;
      Design_File : Iir_Design_File;
      Unit : Iir;
      Lib : Iir;
      Flag_Add : constant Boolean := False;
   begin
      Flags.Bootstrap := True;
      Libraries.Load_Std_Library;
      Libraries.Load_Work_Library;

      for I in Args'Range loop
         Id := Get_Identifier (Args (I).all);
         Design_File := Libraries.Load_File (Id);
         if Design_File /= Null_Iir then
            Unit := Get_First_Design_Unit (Design_File);
            while Unit /= Null_Iir loop
               Lib := Get_Library_Unit (Unit);
               Disp_Library_Unit (Lib);
               if Is_Top_Entity (Lib) then
                  Put (" **");
               end if;
               New_Line;
               if Flag_Add then
                  Libraries.Add_Design_Unit_Into_Library (Unit);
               end if;
               Unit := Get_Chain (Unit);
            end loop;
         end if;
      end loop;
      if Flag_Add then
         Libraries.Save_Work_Library;
      end if;
   end Perform_Action;

   --  Command Import.
   type Command_Import is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Import; Name : String)
                           return Boolean;
   function Get_Short_Help (Cmd : Command_Import) return String;
   procedure Perform_Action (Cmd : in out Command_Import;
                             Args : Argument_List);

   function Decode_Command (Cmd : Command_Import; Name : String)
                           return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "-i";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Import) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "-i [OPTS] FILEs    Import units of FILEs";
   end Get_Short_Help;

   procedure Perform_Action (Cmd : in out Command_Import; Args : Argument_List)
   is
      pragma Unreferenced (Cmd);
      use Ada.Text_IO;
      Id : Name_Id;
      Design_File : Iir_Design_File;
      Unit : Iir;
      Next_Unit : Iir;
      Lib : Iir;
   begin
      Setup_Libraries (True);

      --  Parse all files.
      for I in Args'Range loop
         Id := Name_Table.Get_Identifier (Args (I).all);
         Design_File := Libraries.Load_File (Id);
         if Design_File /= Null_Iir then
            Unit := Get_First_Design_Unit (Design_File);
            while Unit /= Null_Iir loop
               if Flag_Verbose then
                  Lib := Get_Library_Unit (Unit);
                  Disp_Library_Unit (Lib);
                  if Is_Top_Entity (Lib) then
                     Put (" **");
                  end if;
                  New_Line;
               end if;
               Next_Unit := Get_Chain (Unit);
               Set_Chain (Unit, Null_Iir);
               Libraries.Add_Design_Unit_Into_Library (Unit);
               Unit := Next_Unit;
            end loop;
         end if;
      end loop;

      --  Analyze all files.
      if False then
         Design_File := Get_Design_File_Chain (Libraries.Work_Library);
         while Design_File /= Null_Iir loop
            Unit := Get_First_Design_Unit (Design_File);
            while Unit /= Null_Iir loop
               case Get_Date (Unit) is
                  when Date_Valid
                    | Date_Analyzed =>
                     null;
                  when Date_Parsed =>
                     Back_End.Finish_Compilation (Unit, False);
                  when others =>
                     raise Internal_Error;
               end case;
               Unit := Get_Chain (Unit);
            end loop;
            Design_File := Get_Chain (Design_File);
         end loop;
      end if;

      Libraries.Save_Work_Library;
   exception
      when Errorout.Compilation_Error =>
         Error ("importation has failed due to compilation error");
         raise;
   end Perform_Action;

   --  Command Check_Syntax.
   type Command_Check_Syntax is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Check_Syntax; Name : String)
                           return Boolean;
   function Get_Short_Help (Cmd : Command_Check_Syntax) return String;
   procedure Perform_Action (Cmd : in out Command_Check_Syntax;
                             Args : Argument_List);

   function Decode_Command (Cmd : Command_Check_Syntax; Name : String)
                           return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "-s";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Check_Syntax) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "-s [OPTS] FILEs    Check syntax of FILEs";
   end Get_Short_Help;

   procedure Analyze_Files (Files : Argument_List; Save_Library : Boolean)
   is
      use Ada.Text_IO;
      Id : Name_Id;
      Design_File : Iir_Design_File;
      Unit : Iir;
      Next_Unit : Iir;
   begin
      Setup_Libraries (True);

      --  Parse all files.
      for I in Files'Range loop
         Id := Name_Table.Get_Identifier (Files (I).all);
         if Flag_Verbose then
            Put (Files (I).all);
            Put_Line (":");
         end if;
         Design_File := Libraries.Load_File (Id);
         if Design_File /= Null_Iir then
            Unit := Get_First_Design_Unit (Design_File);
            while Unit /= Null_Iir loop
               if Flag_Verbose then
                  Put (' ');
                  Disp_Library_Unit (Get_Library_Unit (Unit));
                  New_Line;
               end if;
               -- Sem, canon, annotate a design unit.
               Back_End.Finish_Compilation (Unit, True);

               Next_Unit := Get_Chain (Unit);
               if Errorout.Nbr_Errors = 0 then
                  Set_Chain (Unit, Null_Iir);
                  Libraries.Add_Design_Unit_Into_Library (Unit);
               end if;

               Unit := Next_Unit;
            end loop;

            if Errorout.Nbr_Errors > 0 then
               raise Errorout.Compilation_Error;
            end if;
         end if;
      end loop;

      if Save_Library then
         Libraries.Save_Work_Library;
      end if;
   end Analyze_Files;

   procedure Perform_Action (Cmd : in out Command_Check_Syntax;
                             Args : Argument_List)
   is
      pragma Unreferenced (Cmd);
   begin
      Analyze_Files (Args, False);
   end Perform_Action;

   --  Command --clean: remove object files.
   type Command_Clean is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Clean; Name : String) return Boolean;
   function Get_Short_Help (Cmd : Command_Clean) return String;
   procedure Perform_Action (Cmd : in out Command_Clean; Args : Argument_List);

   function Decode_Command (Cmd : Command_Clean; Name : String) return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "--clean";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Clean) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "--clean            Remove generated files";
   end Get_Short_Help;

   procedure Delete (Str : String)
   is
      use Ada.Text_IO;
      Status : Boolean;
   begin
      Delete_File (Str'Address, Status);
      if Flag_Verbose and Status then
         Put_Line ("delete " & Str (Str'First .. Str'Last - 1));
      end if;
   end Delete;

   procedure Perform_Action (Cmd : in out Command_Clean; Args : Argument_List)
   is
      pragma Unreferenced (Cmd);
      use Name_Table;

      procedure Delete_Asm_Obj (Str : String) is
      begin
         Delete (Str & Get_Object_Suffix.all & Nul);
         Delete (Str & Asm_Suffix & Nul);
      end Delete_Asm_Obj;

      procedure Delete_Top_Unit (Str : String) is
      begin
         --  Delete elaboration file
         Delete_Asm_Obj (Image (Libraries.Work_Directory) & Elab_Prefix & Str);

         --  Delete file list.
         Delete (Image (Libraries.Work_Directory) & Str & List_Suffix & Nul);

         --  Delete executable.
         Delete (Str & Nul);
      end Delete_Top_Unit;

      File : Iir_Design_File;
      Design_Unit : Iir_Design_Unit;
      Lib_Unit : Iir;
      Ent_Unit : Iir;
      Str : String_Access;
   begin
      if Args'Length /= 0 then
         Error ("command '--clean' does not accept any argument");
         raise Option_Error;
      end if;

      Flags.Bootstrap := True;
      --  Load libraries.
      Libraries.Load_Std_Library;
      Libraries.Load_Work_Library;

      File := Get_Design_File_Chain (Libraries.Work_Library);
      while File /= Null_Iir loop
         --  Delete compiled file.
         Str := Append_Suffix (Image (Get_Design_File_Filename (File)), "");
         Delete_Asm_Obj (Str.all);
         Free (Str);

         Design_Unit := Get_First_Design_Unit (File);
         while Design_Unit /= Null_Iir loop
            Lib_Unit := Get_Library_Unit (Design_Unit);
            case Get_Kind (Lib_Unit) is
               when Iir_Kind_Entity_Declaration
                 | Iir_Kind_Configuration_Declaration =>
                  Delete_Top_Unit (Image (Get_Identifier (Lib_Unit)));
               when Iir_Kind_Architecture_Declaration =>
                  Ent_Unit := Get_Entity (Lib_Unit);
                  Delete_Top_Unit (Image (Get_Identifier (Ent_Unit))
                                   & '-'
                                   & Image (Get_Identifier (Lib_Unit)));
               when others =>
                  null;
            end case;
            Design_Unit := Get_Chain (Design_Unit);
         end loop;
         File := Get_Chain (File);
      end loop;
   end Perform_Action;

   --  Command --remove: remove object file and library file.
   type Command_Remove is new Command_Clean with null record;
   function Decode_Command (Cmd : Command_Remove; Name : String)
                           return Boolean;
   function Get_Short_Help (Cmd : Command_Remove) return String;
   procedure Perform_Action (Cmd : in out Command_Remove;
                             Args : Argument_List);

   function Decode_Command (Cmd : Command_Remove; Name : String) return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "--remove";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Remove) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "--remove           Remove generated files and library file";
   end Get_Short_Help;

   procedure Perform_Action (Cmd : in out Command_Remove; Args : Argument_List)
   is
      use Name_Table;
   begin
      if Args'Length /= 0 then
         Error ("command '--remove' does not accept any argument");
         raise Option_Error;
      end if;
      Perform_Action (Command_Clean (Cmd), Args);
      Delete (Image (Libraries.Work_Directory)
              & Back_End.Library_To_File_Name (Libraries.Work_Library)
              & Nul);
   end Perform_Action;

   --  Command --copy: copy work library to current directory.
   type Command_Copy is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Copy; Name : String) return Boolean;
   function Get_Short_Help (Cmd : Command_Copy) return String;
   procedure Perform_Action (Cmd : in out Command_Copy; Args : Argument_List);

   function Decode_Command (Cmd : Command_Copy; Name : String) return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "--copy";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Copy) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "--copy             Copy work library to current directory";
   end Get_Short_Help;

   procedure Perform_Action (Cmd : in out Command_Copy; Args : Argument_List)
   is
      pragma Unreferenced (Cmd);
      use Name_Table;
      use Libraries;

      File : Iir_Design_File;
      Dir : Name_Id;
   begin
      if Args'Length /= 0 then
         Error ("command '--copy' does not accept any argument");
         raise Option_Error;
      end if;

      Setup_Libraries (False);
      Libraries.Load_Std_Library;
      Dir := Work_Directory;
      Work_Directory := Null_Identifier;
      Libraries.Load_Work_Library;
      Work_Directory := Dir;

      Dir := Get_Library_Directory (Libraries.Work_Library);
      if Dir = Name_Nil or else Dir = Files_Map.Get_Home_Directory then
         Error ("cannot copy library on itself (use --remove first)");
         raise Option_Error;
      end if;

      File := Get_Design_File_Chain (Libraries.Work_Library);
      while File /= Null_Iir loop
         --  Copy object files (if any).
         declare
            Basename : constant String :=
              Get_Base_Name (Image (Get_Design_File_Filename (File)));
            Src : String_Access;
            Dst : String_Access;
            Success : Boolean;
            pragma Unreferenced (Success);
         begin
            Src := new String'(Image (Dir) & Basename & Get_Object_Suffix.all);
            Dst := new String'(Basename & Get_Object_Suffix.all);
            Copy_File (Src.all, Dst.all, Success, Overwrite, Full);
            --  Be silent in case of error.
            Free (Src);
            Free (Dst);
         end;
         if Get_Design_File_Directory (File) = Name_Nil then
            Set_Design_File_Directory (File, Dir);
         end if;

         File := Get_Chain (File);
      end loop;
      Libraries.Work_Directory := Name_Nil;
      Libraries.Save_Work_Library;
   end Perform_Action;

   --  Command --disp-standard.
   type Command_Disp_Standard is new Command_Lib with null record;
   function Decode_Command (Cmd : Command_Disp_Standard; Name : String)
                           return Boolean;
   function Get_Short_Help (Cmd : Command_Disp_Standard) return String;
   procedure Perform_Action (Cmd : in out Command_Disp_Standard;
                             Args : Argument_List);

   function Decode_Command (Cmd : Command_Disp_Standard; Name : String)
                           return Boolean
   is
      pragma Unreferenced (Cmd);
   begin
      return Name = "--disp-standard";
   end Decode_Command;

   function Get_Short_Help (Cmd : Command_Disp_Standard) return String
   is
      pragma Unreferenced (Cmd);
   begin
      return "--disp-standard    Disp std.standard in pseudo-vhdl";
   end Get_Short_Help;

   procedure Perform_Action (Cmd : in out Command_Disp_Standard;
                             Args : Argument_List)
   is
      pragma Unreferenced (Cmd);
   begin
      if Args'Length /= 0 then
         Error ("command '--disp-standard' does not accept any argument");
         raise Option_Error;
      end if;
      Flags.Bootstrap := True;
      Libraries.Load_Std_Library;
      Disp_Vhdl.Disp_Vhdl (Std_Package.Std_Standard_Unit);
   end Perform_Action;

   procedure Load_All_Libraries_And_Files
   is
      use Files_Map;
      use Libraries;
      use Errorout;

      procedure Extract_Library_Clauses (Unit : Iir_Design_Unit)
      is
         Lib1 : Iir_Library_Declaration;
         pragma Unreferenced (Lib1);
         Ctxt_Item : Iir;
      begin
         --  Extract library clauses.
         Ctxt_Item := Get_Context_Items (Unit);
         while Ctxt_Item /= Null_Iir loop
            if Get_Kind (Ctxt_Item) = Iir_Kind_Library_Clause then
               Lib1 := Get_Library (Get_Identifier (Ctxt_Item),
                                    Get_Location (Ctxt_Item));
            end if;
            Ctxt_Item := Get_Chain (Ctxt_Item);
         end loop;
      end Extract_Library_Clauses;

      Lib : Iir_Library_Declaration;
      Fe : Source_File_Entry;
      File, Next_File : Iir_Design_File;
      Unit, Next_Unit : Iir_Design_Unit;
      Design_File : Iir_Design_File;

      Old_Work : Iir_Library_Declaration;
   begin
      Lib := Std_Library;
      Lib := Get_Chain (Lib);
      Old_Work := Work_Library;
      while Lib /= Null_Iir loop
         --  Design units are always put in the work library.
         Work_Library := Lib;

         File := Get_Design_File_Chain (Lib);
         while File /= Null_Iir loop
            Next_File := Get_Chain (File);
            Fe := Load_Source_File (Get_Design_File_Directory (File),
                                    Get_Design_File_Filename (File));
            if Fe = No_Source_File_Entry then
               --  FIXME: should remove all the design file from the library.
               null;
            elsif Is_Eq (Get_File_Time_Stamp (Fe),
                         Get_File_Time_Stamp (File))
            then
               --  File has not been modified.
               --  Extract libraries.
               --  Note: we can't parse it only, since we need to keep the
               --    date.
               Unit := Get_First_Design_Unit (File);
               while Unit /= Null_Iir loop
                  Load_Parse_Design_Unit (Unit, Null_Iir);
                  Extract_Library_Clauses (Unit);
                  Unit := Get_Chain (Unit);
               end loop;
            else
               --  File has been modified.
               --  Parse it.
               Design_File := Load_File (Fe);

               --  Exit now in case of parse error.
               if Design_File = Null_Iir
                 or else Nbr_Errors > 0
               then
                  raise Compilation_Error;
               end if;

               Unit := Get_First_Design_Unit (Design_File);
               while Unit /= Null_Iir loop
                  Extract_Library_Clauses (Unit);

                  Next_Unit := Get_Chain (Unit);
                  Set_Chain (Unit, Null_Iir);
                  Add_Design_Unit_Into_Library (Unit);
                  Unit := Next_Unit;
               end loop;
            end if;
            File := Next_File;
         end loop;
         Lib := Get_Chain (Lib);
      end loop;
      Work_Library := Old_Work;
   end Load_All_Libraries_And_Files;

   procedure Check_No_Elab_Flag (Lib : Iir_Library_Declaration)
   is
      File : Iir_Design_File;
      Unit : Iir_Design_Unit;
   begin
      File := Get_Design_File_Chain (Lib);
      while File /= Null_Iir loop
         Unit := Get_First_Design_Unit (File);
         while Unit /= Null_Iir loop
            if Get_Elab_Flag (Unit) then
               raise Internal_Error;
            end if;
            Unit := Get_Chain (Unit);
         end loop;
         File := Get_Chain (File);
      end loop;
   end Check_No_Elab_Flag;

   function Build_Dependence (Prim : String_Access; Sec : String_Access)
     return Iir_List
   is
      procedure Build_Dependence_List (File : Iir_Design_File; List : Iir_List)
      is
         El : Iir_Design_File;
         Depend_List : Iir_List;
      begin
         if Get_Elab_Flag (File) then
            return;
         end if;

         Set_Elab_Flag (File, True);
         Depend_List := Get_File_Dependence_List (File);
         if Depend_List /= Null_Iir_List then
            for I in Natural loop
               El := Get_Nth_Element (Depend_List, I);
               exit when El = Null_Iir;
               Build_Dependence_List (El, List);
            end loop;
         end if;
         Append_Element (List, File);
      end Build_Dependence_List;

      use Configuration;
      use Name_Table;

      Top : Iir;
      Primary_Id : Name_Id;
      Secondary_Id : Name_Id;

      File : Iir_Design_File;
      Unit : Iir;

      Files_List : Iir_List;
   begin
      Check_No_Elab_Flag (Libraries.Work_Library);

      Primary_Id := Get_Identifier (Prim.all);
      if Sec /= null then
         Secondary_Id := Get_Identifier (Sec.all);
      else
         Secondary_Id := Null_Identifier;
      end if;

      if True then
         Load_All_Libraries_And_Files;
      else
         --  Re-parse modified files in order configure could find all design
         --  units.
         declare
            use Files_Map;
            Fe : Source_File_Entry;
            Next_File : Iir_Design_File;
            Design_File : Iir_Design_File;
         begin
            File := Get_Design_File_Chain (Libraries.Work_Library);
            while File /= Null_Iir loop
               Next_File := Get_Chain (File);
               Fe := Load_Source_File (Get_Design_File_Directory (File),
                                       Get_Design_File_Filename (File));
               if Fe = No_Source_File_Entry then
                  --  FIXME: should remove all the design file from
                  --  the library.
                  null;
               else
                  if not Is_Eq (Get_File_Time_Stamp (Fe),
                                Get_File_Time_Stamp (File))
                  then
                     --  FILE has been modified.
                     Design_File := Libraries.Load_File (Fe);
                     if Design_File /= Null_Iir then
                        Libraries.Add_Design_File_Into_Library (Design_File);
                     end if;
                  end if;
               end if;
               File := Next_File;
            end loop;
         end;
      end if;

      Flags.Flag_Elaborate := True;
      Flags.Flag_Elaborate_With_Outdated := True;
      Flag_Load_All_Design_Units := True;
      Flag_Build_File_Dependence := True;

      Top := Configure (Primary_Id, Secondary_Id);
      if Top = Null_Iir then
         --Error ("cannot find primary unit " & Prim.all);
         raise Option_Error;
      end if;

      --  Add unused design units.
      declare
         N : Natural;
      begin
         N := Design_Units.First;
         while N <= Design_Units.Last loop
            Unit := Design_Units.Table (N);
            N := N + 1;
            File := Get_Design_File (Unit);
            if not Get_Elab_Flag (File) then
               Set_Elab_Flag (File, True);
               Unit := Get_First_Design_Unit (File);
               while Unit /= Null_Iir loop
                  if not Get_Elab_Flag (Unit) then
                     Add_Design_Unit (Unit, Null_Iir);
                  end if;
                  Unit := Get_Chain (Unit);
               end loop;
            end if;
         end loop;
      end;

      --  Clear elab flag on design files.
      for I in reverse Design_Units.First .. Design_Units.Last loop
         Unit := Design_Units.Table (I);
         File := Get_Design_File (Unit);
         Set_Elab_Flag (File, False);
      end loop;

      --  Create a list of files, from the last to the first.
      Files_List := Create_Iir_List;
      for I in Design_Units.First .. Design_Units.Last loop
         Unit := Design_Units.Table (I);
         File := Get_Design_File (Unit);
         Build_Dependence_List (File, Files_List);
      end loop;

      return Files_List;
   end Build_Dependence;

   --  Convert NAME to lower cases, unless it is an extended identifier.
   function Convert_Name (Name : String_Access) return String_Access
   is
      use Name_Table;

      function Is_Bad_Unit_Name return Boolean is
      begin
         if Name_Length = 0 then
            return True;
         end if;
         --  Don't try to handle extended identifier.
         if Name_Buffer (1) = '\' then
            return False;
         end if;
         --  Look for suspicious characters.
         --  Do not try to be exhaustive as the correct check will be done
         --  by convert_identifier.
         for I in 1 .. Name_Length loop
            case Name_Buffer (I) is
               when '.' | '/' | '\' =>
                  return True;
               when others =>
                  null;
            end case;
         end loop;
         return False;
      end Is_Bad_Unit_Name;

      function Is_A_File_Name return Boolean is
      begin
         --  Check .vhd
         if Name_Length > 4
           and then Name_Buffer (Name_Length - 3 .. Name_Length) = ".vhd"
         then
            return True;
         end if;
         --  Check .vhdl
         if Name_Length > 5
           and then Name_Buffer (Name_Length - 4 .. Name_Length) = ".vhdl"
         then
            return True;
         end if;
         --  Check ../
         if Name_Length > 3
           and then Name_Buffer (1 .. 3) = "../"
         then
            return True;
         end if;
         --  Check ..\
         if Name_Length > 3
           and then Name_Buffer (1 .. 3) = "..\"
         then
            return True;
         end if;
         --  Should try to find the file ?
         return False;
      end Is_A_File_Name;
   begin
      Name_Length := Name'Length;
      Name_Buffer (1 .. Name_Length) := Name.all;

      --  Try to identifier bad names (such as file names), so that
      --  friendly message can be displayed.
      if Is_Bad_Unit_Name then
         Errorout.Error_Msg_Option_NR ("bad unit name '" & Name.all & "'");
         if Is_A_File_Name then
            Errorout.Error_Msg_Option_NR
              ("(a unit name is required instead of a filename)");
         end if;
         raise Option_Error;
      end if;
      Scan.Convert_Identifier;
      return new String'(Name_Buffer (1 .. Name_Length));
   end Convert_Name;

   procedure Extract_Elab_Unit
     (Cmd_Name : String; Args : Argument_List; Next_Arg : out Natural)
   is
   begin
      if Args'Length = 0 then
         Error ("command '" & Cmd_Name & "' required an unit name");
         raise Option_Error;
      end if;

      Prim_Name := Convert_Name (Args (Args'First));
      Next_Arg := Args'First + 1;
      Sec_Name := null;

      if Args'Length >= 2 then
         declare
            Sec : constant String_Access := Args (Next_Arg);
         begin
            if Sec (Sec'First) /= '-' then
               Sec_Name := Convert_Name (Sec);
               Next_Arg := Args'First + 2;
            end if;
         end;
      end if;
   end Extract_Elab_Unit;

   procedure Register_Commands is
   begin
      Register_Command (new Command_Import);
      Register_Command (new Command_Check_Syntax);
      Register_Command (new Command_Dir);
      Register_Command (new Command_Find);
      Register_Command (new Command_Clean);
      Register_Command (new Command_Remove);
      Register_Command (new Command_Copy);
      Register_Command (new Command_Disp_Standard);
   end Register_Commands;
end Ghdllocal;