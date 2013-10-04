pragma Ada_95;
pragma Source_File_Name (vhdltokmain, Spec_File_Name => "b~vhdltok.ads");
pragma Source_File_Name (vhdltokmain, Body_File_Name => "b~vhdltok.adb");
with Ada.Exceptions;

package body vhdltokmain is
   pragma Warnings (Off);

   E040 : Short_Integer; pragma Import (Ada, E040, "system__soft_links_E");
   E160 : Short_Integer; pragma Import (Ada, E160, "system__fat_lflt_E");
   E050 : Short_Integer; pragma Import (Ada, E050, "system__exception_table_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "ada__io_exceptions_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "ada__strings_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "ada__strings__maps_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "ada__strings__maps__constants_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "ada__tags_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "ada__streams_E");
   E075 : Short_Integer; pragma Import (Ada, E075, "interfaces__c_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "interfaces__c__strings_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "system__aux_dec_E");
   E056 : Short_Integer; pragma Import (Ada, E056, "system__exceptions_E");
   E033 : Short_Integer; pragma Import (Ada, E033, "ada__calendar_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "gnat__directory_operations_E");
   E044 : Short_Integer; pragma Import (Ada, E044, "system__secondary_stack_E");
   E100 : Short_Integer; pragma Import (Ada, E100, "system__finalization_root_E");
   E098 : Short_Integer; pragma Import (Ada, E098, "ada__finalization_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "system__storage_pools_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "system__finalization_masters_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "system__storage_pools__subpools_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "ada__strings__unbounded_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "system__os_lib_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "system__pool_global_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "system__file_control_block_E");
   E096 : Short_Integer; pragma Import (Ada, E096, "system__file_io_E");
   E090 : Short_Integer; pragma Import (Ada, E090, "ada__text_io_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "types_E");
   E002 : Short_Integer; pragma Import (Ada, E002, "files_map_E");
   E026 : Short_Integer; pragma Import (Ada, E026, "flags_E");
   E010 : Short_Integer; pragma Import (Ada, E010, "name_table_E");
   E028 : Short_Integer; pragma Import (Ada, E028, "nodes_E");
   E017 : Short_Integer; pragma Import (Ada, E017, "lists_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "iirs_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "errorout_E");
   E024 : Short_Integer; pragma Import (Ada, E024, "iirs_utils_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "scan_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "libvhdltok_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "std_names_E");
   E008 : Short_Integer; pragma Import (Ada, E008, "str_table_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
      LE_Set : Boolean;
      pragma Import (Ada, LE_Set, "__gnat_library_exception_set");
   begin
      E090 := E090 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "ada__text_io__finalize_spec");
      begin
         if E090 = 0 then
            F1;
         end if;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "system__file_io__finalize_body");
      begin
         E096 := E096 - 1;
         if E096 = 0 then
            F2;
         end if;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__file_control_block__finalize_spec");
      begin
         E109 := E109 - 1;
         if E109 = 0 then
            F3;
         end if;
      end;
      E121 := E121 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__pool_global__finalize_spec");
      begin
         if E121 = 0 then
            F4;
         end if;
      end;
      E168 := E168 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "ada__strings__unbounded__finalize_spec");
      begin
         if E168 = 0 then
            F5;
         end if;
      end;
      E125 := E125 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__storage_pools__subpools__finalize_spec");
      begin
         if E125 = 0 then
            F6;
         end if;
      end;
      E111 := E111 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__finalization_masters__finalize_spec");
      begin
         if E111 = 0 then
            F7;
         end if;
      end;
      E100 := E100 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__finalization_root__finalize_spec");
      begin
         if E100 = 0 then
            F8;
         end if;
      end;
      if LE_Set then
         declare
            LE : Ada.Exceptions.Exception_Occurrence;
            pragma Import (Ada, LE, "__gnat_library_exception");
            procedure Raise_From_Controlled_Operation (X : Ada.Exceptions.Exception_Occurrence);
            pragma Import (Ada, Raise_From_Controlled_Operation, "__gnat_raise_from_controlled_operation");
         begin
            Raise_From_Controlled_Operation (LE);
         end;
      end if;
   end finalize_library;

   procedure vhdltokfinal is
   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      finalize_library;
   end vhdltokfinal;

   type No_Param_Proc is access procedure;

   procedure vhdltokinit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Zero_Cost_Exceptions : Integer;
      pragma Import (C, Zero_Cost_Exceptions, "__gl_zero_cost_exceptions");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Zero_Cost_Exceptions := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      if E040 = 0 then
         System.Soft_Links'Elab_Spec;
      end if;
      if E160 = 0 then
         System.Fat_Lflt'Elab_Spec;
      end if;
      E160 := E160 + 1;
      if E050 = 0 then
         System.Exception_Table'Elab_Body;
      end if;
      E050 := E050 + 1;
      if E101 = 0 then
         Ada.Io_Exceptions'Elab_Spec;
      end if;
      E101 := E101 + 1;
      if E131 = 0 then
         Ada.Strings'Elab_Spec;
      end if;
      E131 := E131 + 1;
      if E133 = 0 then
         Ada.Strings.Maps'Elab_Spec;
      end if;
      if E136 = 0 then
         Ada.Strings.Maps.Constants'Elab_Spec;
      end if;
      E136 := E136 + 1;
      if E081 = 0 then
         Ada.Tags'Elab_Spec;
      end if;
      if E091 = 0 then
         Ada.Streams'Elab_Spec;
      end if;
      E091 := E091 + 1;
      if E075 = 0 then
         Interfaces.C'Elab_Spec;
      end if;
      if E103 = 0 then
         Interfaces.C.Strings'Elab_Spec;
      end if;
      if E164 = 0 then
         System.Aux_Dec'Elab_Spec;
      end if;
      E164 := E164 + 1;
      if E056 = 0 then
         System.Exceptions'Elab_Spec;
      end if;
      E056 := E056 + 1;
      if E033 = 0 then
         Ada.Calendar'Elab_Spec;
      end if;
      if E033 = 0 then
         Ada.Calendar'Elab_Body;
      end if;
      E033 := E033 + 1;
      if E128 = 0 then
         Gnat.Directory_Operations'Elab_Spec;
      end if;
      E103 := E103 + 1;
      E075 := E075 + 1;
      if E081 = 0 then
         Ada.Tags'Elab_Body;
      end if;
      E081 := E081 + 1;
      E133 := E133 + 1;
      if E040 = 0 then
         System.Soft_Links'Elab_Body;
      end if;
      E040 := E040 + 1;
      if E044 = 0 then
         System.Secondary_Stack'Elab_Body;
      end if;
      E044 := E044 + 1;
      if E100 = 0 then
         System.Finalization_Root'Elab_Spec;
      end if;
      E100 := E100 + 1;
      if E098 = 0 then
         Ada.Finalization'Elab_Spec;
      end if;
      E098 := E098 + 1;
      if E119 = 0 then
         System.Storage_Pools'Elab_Spec;
      end if;
      E119 := E119 + 1;
      if E111 = 0 then
         System.Finalization_Masters'Elab_Spec;
      end if;
      if E111 = 0 then
         System.Finalization_Masters'Elab_Body;
      end if;
      E111 := E111 + 1;
      if E125 = 0 then
         System.Storage_Pools.Subpools'Elab_Spec;
      end if;
      E125 := E125 + 1;
      if E168 = 0 then
         Ada.Strings.Unbounded'Elab_Spec;
      end if;
      E168 := E168 + 1;
      if E106 = 0 then
         System.Os_Lib'Elab_Body;
      end if;
      E106 := E106 + 1;
      if E128 = 0 then
         Gnat.Directory_Operations'Elab_Body;
      end if;
      E128 := E128 + 1;
      if E121 = 0 then
         System.Pool_Global'Elab_Spec;
      end if;
      E121 := E121 + 1;
      if E109 = 0 then
         System.File_Control_Block'Elab_Spec;
      end if;
      E109 := E109 + 1;
      if E096 = 0 then
         System.File_Io'Elab_Body;
      end if;
      E096 := E096 + 1;
      if E090 = 0 then
         Ada.Text_Io'Elab_Spec;
      end if;
      if E090 = 0 then
         Ada.Text_Io'Elab_Body;
      end if;
      E090 := E090 + 1;
      if E015 = 0 then
         Types'Elab_Spec;
      end if;
      E015 := E015 + 1;
      E026 := E026 + 1;
      if E010 = 0 then
         Name_Table'Elab_Body;
      end if;
      E010 := E010 + 1;
      if E028 = 0 then
         Nodes'Elab_Body;
      end if;
      E028 := E028 + 1;
      if E017 = 0 then
         Lists'Elab_Body;
      end if;
      E017 := E017 + 1;
      if E021 = 0 then
         Errorout'Elab_Spec;
      end if;
      E012 := E012 + 1;
      E014 := E014 + 1;
      E021 := E021 + 1;
      if E008 = 0 then
         Str_Table'Elab_Body;
      end if;
      E008 := E008 + 1;
      E019 := E019 + 1;
      E006 := E006 + 1;
      E024 := E024 + 1;
      if E002 = 0 then
         Files_Map'Elab_Body;
      end if;
      E002 := E002 + 1;
   end vhdltokinit;

--  BEGIN Object file/option list
   --   ./tokens.o
   --   ./types.o
   --   ./flags.o
   --   ./name_table.o
   --   ./nodes.o
   --   ./lists.o
   --   ./iirs.o
   --   ./test.o
   --   ./std_names.o
   --   ./errorout.o
   --   ./str_table.o
   --   ./libvhdltok.o
   --   ./scan.o
   --   ./iirs_utils.o
   --   ./files_map.o
   --   -L./
   --   -L/Users/eiselekd/src/vhdl2js/vhdl2html/tokenizer/
   --   -L/opt/gcc-4.7.2-ghdl/lib/gcc/x86_64-apple-darwin11.4.2/4.7.2/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end vhdltokmain;
