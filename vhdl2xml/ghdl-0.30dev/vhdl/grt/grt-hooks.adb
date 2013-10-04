--  GHDL Run Time (GRT) -  Hooks.
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

package body Grt.Hooks is
   type Hooks_Cell;
   type Hooks_Cell_Acc is access Hooks_Cell;
   type Hooks_Cell is record
      Hooks : Hooks_Acc;
      Next : Hooks_Cell_Acc;
   end record;

   First_Hooks : Hooks_Cell_Acc := null;
   Last_Hooks : Hooks_Cell_Acc := null;

   procedure Register_Hooks (Hooks : Hooks_Acc)
   is
      Cell : Hooks_Cell_Acc;
   begin
      Cell := new Hooks_Cell'(Hooks => Hooks,
                              Next => null);
      if Last_Hooks = null then
         First_Hooks := Cell;
      else
         Last_Hooks.Next := Cell;
      end if;
      Last_Hooks := Cell;
   end Register_Hooks;

   type Hook_Cell;
   type Hook_Cell_Acc is access Hook_Cell;
   type Hook_Cell is record
      Hook : Proc_Hook_Type;
      Next : Hook_Cell_Acc;
   end record;

   --  Chain of cycle hooks.
   Cycle_Hook : Hook_Cell_Acc := null;
   Last_Cycle_Hook : Hook_Cell_Acc := null;

   procedure Register_Cycle_Hook (Proc : Proc_Hook_Type)
   is
      Cell : Hook_Cell_Acc;
   begin
      Cell := new Hook_Cell'(Hook => Proc,
                             Next => null);
      if Cycle_Hook = null then
         Cycle_Hook := Cell;
      else
         Last_Cycle_Hook.Next := Cell;
      end if;
      Last_Cycle_Hook := Cell;
   end Register_Cycle_Hook;

   procedure Call_Cycle_Hooks
   is
      Cell : Hook_Cell_Acc;
   begin
      Cell := Cycle_Hook;
      while Cell /= null loop
         Cell.Hook.all;
         Cell := Cell.Next;
      end loop;
   end Call_Cycle_Hooks;

   function Call_Option_Hooks (Opt : String) return Boolean
   is
      Cell : Hooks_Cell_Acc;
   begin
      Cell := First_Hooks;
      while Cell /= null loop
         if Cell.Hooks.Option /= null
           and then Cell.Hooks.Option.all (Opt)
         then
            return True;
         end if;
         Cell := Cell.Next;
      end loop;
      return False;
   end Call_Option_Hooks;

   procedure Call_Help_Hooks
   is
      Cell : Hooks_Cell_Acc;
   begin
      Cell := First_Hooks;
      while Cell /= null loop
         if Cell.Hooks.Help /= null then
            Cell.Hooks.Help.all;
         end if;
         Cell := Cell.Next;
      end loop;
   end Call_Help_Hooks;

   procedure Call_Init_Hooks
   is
      Cell : Hooks_Cell_Acc;
   begin
      Cell := First_Hooks;
      while Cell /= null loop
         if Cell.Hooks.Init /= null then
            Cell.Hooks.Init.all;
         end if;
         Cell := Cell.Next;
      end loop;
   end Call_Init_Hooks;

   procedure Call_Start_Hooks
   is
      Cell : Hooks_Cell_Acc;
   begin
      Cell := First_Hooks;
      while Cell /= null loop
         if Cell.Hooks.Start /= null then
            Cell.Hooks.Start.all;
         end if;
         Cell := Cell.Next;
      end loop;
   end Call_Start_Hooks;

   procedure Call_Finish_Hooks
   is
      Cell : Hooks_Cell_Acc;
   begin
      Cell := First_Hooks;
      while Cell /= null loop
         if Cell.Hooks.Finish /= null then
            Cell.Hooks.Finish.all;
         end if;
         Cell := Cell.Next;
      end loop;
   end Call_Finish_Hooks;

   procedure Proc_Hook_Nil is
   begin
      null;
   end Proc_Hook_Nil;
end Grt.Hooks;


