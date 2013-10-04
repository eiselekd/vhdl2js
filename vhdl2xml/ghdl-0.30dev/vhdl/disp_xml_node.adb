with Ada.Text_IO; use Ada.Text_IO;
--With Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
--with Ada.Command_Line; use Ada.Command_Line;
with Ada.Containers; use Ada.Containers;
with GNAT.Regpat;
with Interfaces; use Interfaces;
with Ada.Unchecked_Conversion;

package body disp_xml_node is
   package Pat renames GNAT.Regpat;
   subtype Byte is Unsigned_8;
   function Conv_Char_To_U8 is
      new Ada.Unchecked_Conversion(Source => Character,Target => Byte);
   function Conv_U8_To_Char is
      new Ada.Unchecked_Conversion(Source => Byte, Target => Character);
   procedure Search_For_Pattern(Compiled_Expression: Pat.Pattern_Matcher;
                                Search_In: String;
                                First, Last: out Positive;
                                Found: out Boolean) is
      Result: Pat.Match_Array (0 .. 1);
   begin
      Pat.Match(Compiled_Expression, Search_In, Result);
      Found := not Pat."="(Result(1), Pat.No_Match);
      if Found then
         First := Result(1).First;
         Last := Result(1).Last;
      end if;
   end Search_For_Pattern;

   function Substitute(P: String; S,R : U_String) return U_String is
      Ret : U_String := +"";
      Str : U_String := S;
      PatC : constant Pat.Pattern_Matcher := Pat.Compile(P);
      First, Last:   Positive;
      Found:         Boolean;
   begin
      loop
         Search_For_Pattern(PatC, - Str,
                            First, Last, Found);
         exit when not Found;
         Ret := Ret & (+Slice(Str,1,First-1)) & R;
         Str := (+Slice(Str,Last+1,Length(Str)));
      end loop;
      Ret := Ret & Str;
      return Ret;
   end Substitute;

   function Encode_Utf8(P: U_String) return U_String is
      S : U_String := +"";
      C:Byte;
      Ch:Character;
   begin
      for I in 1 .. Length(P) loop
         Ch := Ada.Strings.Unbounded.Element(P,I);
         C := Conv_Char_To_U8(Ch);
         if (C and 128) /= 0 then
            Append(S,Conv_U8_To_Char(Shift_Right((C and 16#c0#),6) or 16#c0#));
            Append(S,Conv_U8_To_Char((C and 16#3f#) or 16#80#));
         else
            Append(S,Ch);
         end if;
      end loop;
      return S;
   end Encode_Utf8;

   function FormatXml(P: U_String) return U_String is
      S : U_String := P;
      C: Byte;
      F: Boolean := False;
   begin
      S := Substitute("(&)",S,+"&amp;");
      S := Substitute("(<)",S,+"&lt;");
      S := Substitute("(>)",S,+"&gt;");
      S := Substitute("("&""""&")",S,+"&quot;");
      for I in 1 .. Length(S) loop
         C := Conv_Char_To_U8(Ada.Strings.Unbounded.Element(S,I));
         if (C and 128) /= 0 then
            F:= True;
            exit;
         end if;
      end loop;
      if F then
         S:= Encode_Utf8(S);
      end if;
      return S;
   end FormatXml;

   function "+"(C: Character) return U_String is
      Str   : String (1 .. 1);
   begin
      Str(1) := C;
      return + Str;
   end "+";

   function Create_NodeAttr(N: U_String; V:U_String) return Xml_NodeAttr_Acc is
      A : Xml_NodeAttr_Acc;
   begin
      A := new Xml_NodeAttr;
      A.N := N; A.V := V;
      return A;
   end Create_NodeAttr;

   procedure Process (N : in Xml_Node_Acc) is
   begin
      AddAttr(N, + "id", + "001");
      Print(N.all,0);
   end Process;

   procedure AddAttr (Node : in Xml_Node_Acc; N,V: U_String ) is
      Found : Boolean := False;
      procedure ItFindA (A : Xml_NodeAttr_Cursor) is
         E : constant Xml_NodeAttr_Acc := Element (A);
      begin
         if (E.N = N) then
            E.V := V; Found := True;
         end if;
      end ItFindA;
   begin
      Node.Attrs.Iterate (ItFindA'Access);
      if (Found = False) then
         Node.Attrs.Append(Create_NodeAttr(N, V));
      end if;
   end AddAttr;

   procedure Disp_Tab (Tab: Natural) is
      Blanks : constant String (1 .. Tab) := (others => ' ');
   begin
      Put (Blanks);
   end Disp_Tab;

   procedure Print (N : in Xml_Node_Type; Tab: Natural) is
      pragma Unreferenced (N);
   begin
      Disp_Tab(Tab); Put_Line("Base-Print");
   end Print;

   procedure SetTag (N :  in out Xml_Node_Type; Tag: U_String) is
   begin
      null;
   end SetTag;

   -- Pretty Node ------------------------------------

   procedure Print (N :  in Xml_Node_Pretty; Tab: Natural) is
      NTab: constant Natural := Tab + 1;
      procedure ItPrint (A : Xml_Node_Cursor) is
         E : constant Xml_Node_Acc := Element (A);
      begin
         Print(E.all,NTab);
      end ItPrint;
      procedure ItPrintA (A : Xml_NodeAttr_Cursor) is
         E : constant Xml_NodeAttr_Acc := Element (A);
      begin
         Put((-E.N) & "=""" & (-FormatXml(E.V)) & """ ");
      end ItPrintA;
   begin
      Disp_Tab(Tab); Put( "<" & (- N.Extra) & " ");
      N.Attrs.Iterate (ItPrintA'Access);
      if (Length(N.Childs) = 0) then
         Put_Line("/>");
      else
         Put_Line(">");
         N.Childs.Iterate (ItPrint'Access);
         Disp_Tab(Tab); Put_Line( "</" & (- N.Extra) & ">");
      end if;
   end Print;
   procedure RemFrom(P:Xml_Node_Acc; C:Xml_Node_Acc) is
   begin
      for I in 1 .. Length (P.Childs) loop
         if P.Childs.Element(Integer(I)) = C then
            P.Childs.Delete(Integer(I), 1);
            exit;
         end if;
      end loop;
   end RemFrom;

   procedure SetTag (N :  in out Xml_Node_Pretty; Tag: U_String) is
   begin
      N.Extra := Tag;
   end SetTag;

   function Create_Xml_Node_Pretty(P:Xml_Node_Acc; E: U_String)
                                   return Xml_Node_Pretty_Acc is
      Node : Xml_Node_Pretty_Acc ;
   begin
      Node := new Xml_Node_Pretty;
      Node.Extra := E;
      Node.Parent := P;
      if P /= null then
         P.Childs.Append(Xml_Node_Acc(Node));
      end if;
      return Node;
   end Create_Xml_Node_Pretty;

   -- Short Node ------------------------------------
   procedure Print (N : in Xml_Node_Short; Tab: Natural) is
   begin
      --Disp_Tab(Tab); Print(Xml_Node_Type(N));
      Disp_Tab(Tab); Put_Line(- N.Short);
   end Print;

   procedure SetTag (N :  in out Xml_Node_Short; Tag: U_String) is
   begin
      null;
   end SetTag;

   function Create_Xml_Node_Short(P:Xml_Node_Acc;E: U_String)
                                  return Xml_Node_Short_Acc is
      Node : Xml_Node_Short_Acc ;
   begin
      Node := new Xml_Node_Short;
      Node.Short := E;
      Node.Parent := P;
      if P /= null then
         P.Childs.Append(Xml_Node_Acc(Node));
      end if;
      return Node;
   end Create_Xml_Node_Short;

end disp_xml_node;
