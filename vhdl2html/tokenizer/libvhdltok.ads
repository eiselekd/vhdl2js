with Scan;

package libvhdltok is
   
   procedure Vhdltok_Init;
   pragma Export (C, Vhdltok_Init, "Vhdltok_Init");
   
   procedure Vhdltok_Scan;
   pragma Export (C, Vhdltok_Scan, "Vhdltok_Scan");
   
end libvhdltok;
