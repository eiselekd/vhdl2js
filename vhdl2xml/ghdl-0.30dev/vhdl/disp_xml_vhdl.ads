with Iirs; use Iirs;
with disp_xml_node; use disp_xml_node;

package disp_xml_vhdl is
   subtype X is Xml_Node_Acc;
   procedure Disp_Xml_Vhdl (P,N:X;An_Iir: Iir);
   function NewN(P:X;Pos:U_String) return X;
end disp_xml_vhdl;
