pragma Ada_95;
with System;
package vhdltokmain is
   pragma Warnings (Off);

   procedure vhdltokinit;
   pragma Export (C, vhdltokinit, "vhdltokinit");
   pragma Linker_Constructor (vhdltokinit);

   procedure vhdltokfinal;
   pragma Export (C, vhdltokfinal, "vhdltokfinal");
   pragma Linker_Destructor (vhdltokfinal);

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#14d730c4#;
   pragma Export (C, u00001, "files_mapB");
   u00002 : constant Version_32 := 16#ba268c50#;
   pragma Export (C, u00002, "files_mapS");
   u00003 : constant Version_32 := 16#571ec9da#;
   pragma Export (C, u00003, "tokensB");
   u00004 : constant Version_32 := 16#3ffd637c#;
   pragma Export (C, u00004, "tokensS");
   u00005 : constant Version_32 := 16#2ccb40f4#;
   pragma Export (C, u00005, "scanB");
   u00006 : constant Version_32 := 16#ac24c252#;
   pragma Export (C, u00006, "scanS");
   u00007 : constant Version_32 := 16#5b6374fe#;
   pragma Export (C, u00007, "str_tableB");
   u00008 : constant Version_32 := 16#675e2eee#;
   pragma Export (C, u00008, "str_tableS");
   u00009 : constant Version_32 := 16#ffa33921#;
   pragma Export (C, u00009, "name_tableB");
   u00010 : constant Version_32 := 16#1f617c2d#;
   pragma Export (C, u00010, "name_tableS");
   u00011 : constant Version_32 := 16#497c5347#;
   pragma Export (C, u00011, "iirsB");
   u00012 : constant Version_32 := 16#69507eba#;
   pragma Export (C, u00012, "iirsS");
   u00013 : constant Version_32 := 16#f5347972#;
   pragma Export (C, u00013, "std_namesB");
   u00014 : constant Version_32 := 16#b1e0f066#;
   pragma Export (C, u00014, "std_namesS");
   u00015 : constant Version_32 := 16#7d9068a1#;
   pragma Export (C, u00015, "typesS");
   u00016 : constant Version_32 := 16#0d623067#;
   pragma Export (C, u00016, "listsB");
   u00017 : constant Version_32 := 16#c68098ca#;
   pragma Export (C, u00017, "listsS");
   u00018 : constant Version_32 := 16#06b36031#;
   pragma Export (C, u00018, "libvhdltokB");
   u00019 : constant Version_32 := 16#c914d9a2#;
   pragma Export (C, u00019, "libvhdltokS");
   u00020 : constant Version_32 := 16#923d5f41#;
   pragma Export (C, u00020, "erroroutB");
   u00021 : constant Version_32 := 16#e860e3c5#;
   pragma Export (C, u00021, "erroroutS");
   u00022 : constant Version_32 := 16#7029e92f#;
   pragma Export (C, u00022, "testB");
   u00023 : constant Version_32 := 16#ef827416#;
   pragma Export (C, u00023, "iirs_utilsB");
   u00024 : constant Version_32 := 16#294804f0#;
   pragma Export (C, u00024, "iirs_utilsS");
   u00025 : constant Version_32 := 16#5a1e6ab0#;
   pragma Export (C, u00025, "flagsB");
   u00026 : constant Version_32 := 16#3e0bd1ba#;
   pragma Export (C, u00026, "flagsS");
   u00027 : constant Version_32 := 16#64596dc8#;
   pragma Export (C, u00027, "nodesB");
   u00028 : constant Version_32 := 16#559441b6#;
   pragma Export (C, u00028, "nodesS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.handling%s
   --  ada.characters.latin_1%s
   --  ada.command_line%s
   --  gnat%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.case_util%s
   --  system.case_util%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.io%s
   --  system.io%b
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  system.soft_links%s
   --  system.unsigned_types%s
   --  system.fat_lflt%s
   --  system.val_llu%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_llu%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  system.address_image%s
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.concat_7%s
   --  system.concat_7%b
   --  system.concat_8%s
   --  system.concat_8%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.strings.maps%s
   --  ada.strings.fixed%s
   --  ada.strings.maps.constants%s
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.tags%s
   --  ada.streams%s
   --  interfaces.c%s
   --  interfaces.c.strings%s
   --  system.aux_dec%s
   --  system.aux_dec%b
   --  system.crtl.runtime%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  gnat.directory_operations%s
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.secondary_stack%s
   --  interfaces.c.strings%b
   --  interfaces.c%b
   --  ada.tags%b
   --  ada.strings.fixed%b
   --  ada.strings.maps%b
   --  system.soft_links%b
   --  ada.command_line%b
   --  ada.characters.handling%b
   --  system.secondary_stack%b
   --  system.address_image%b
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.finalization_masters%b
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.os_lib%s
   --  system.os_lib%b
   --  gnat.os_lib%s
   --  gnat.directory_operations%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  system.file_control_block%s
   --  system.file_io%s
   --  system.file_io%b
   --  system.traceback%s
   --  ada.exceptions%b
   --  system.traceback%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  tokens%s
   --  tokens%b
   --  types%s
   --  files_map%s
   --  flags%s
   --  flags%b
   --  name_table%s
   --  name_table%b
   --  nodes%s
   --  nodes%b
   --  lists%s
   --  lists%b
   --  iirs%s
   --  errorout%s
   --  iirs%b
   --  iirs_utils%s
   --  scan%s
   --  libvhdltok%s
   --  test%b
   --  std_names%s
   --  std_names%b
   --  errorout%b
   --  str_table%s
   --  str_table%b
   --  libvhdltok%b
   --  scan%b
   --  iirs_utils%b
   --  files_map%b
   --  END ELABORATION ORDER


end vhdltokmain;
