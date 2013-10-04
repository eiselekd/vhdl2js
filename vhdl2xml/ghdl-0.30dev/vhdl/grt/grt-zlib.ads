--  GHDL Run Time (GRT) - Zlib binding.
--  Copyright (C) 2005 Tristan Gingold
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

with System; use System;
with Grt.C; use Grt.C;

package Grt.Zlib is
   pragma Linker_Options ("-lz");

   type gzFile is new System.Address;

   NULL_gzFile : constant gzFile := gzFile (System'To_Address (0));

   function gzputc (File : gzFile; C : int) return int;
   pragma Import (C, gzputc);

   function gzwrite (File : gzFile; Buf : voids; Len : int) return int;
   pragma Import (C, gzwrite);

   function gzopen (Path : chars; Mode : chars) return gzFile;
   pragma Import (C, gzopen);

   procedure gzclose (File : gzFile);
   pragma Import (C, gzclose);
end Grt.Zlib;
