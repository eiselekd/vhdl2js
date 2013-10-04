with Scan;

package libvhdltok is
   
   procedure Vhdltok_Init_Static;
   pragma Export (C, Vhdltok_Init_Static, "Vhdltok_Init_Static");
   
   procedure Vhdltok_Scan;
   pragma Export (C, Vhdltok_Scan, "Vhdltok_Scan");
   
end libvhdltok;
