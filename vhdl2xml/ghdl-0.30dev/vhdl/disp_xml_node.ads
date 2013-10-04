with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package disp_xml_node is

   subtype U_String is Ada.Strings.Unbounded.Unbounded_String;
   --use type U_String;
   function "+"(S: String) return U_String
     renames Ada.Strings.Unbounded.To_Unbounded_String;
   function "-"(U: U_String) return String
     renames Ada.Strings.Unbounded.To_String;
   function "&" (Left, Right : U_String) return U_String
     renames Ada.Strings.Unbounded."&";
   function "=" (Left, Right : U_String) return Boolean
     renames Ada.Strings.Unbounded."=";
   function Slice (Source : in U_String;
                   Low    : in Positive;
                   High   : in Natural) return String
     renames Ada.Strings.Unbounded.Slice;
   function Length (Source : in U_String) return Natural
     renames Ada.Strings.Unbounded.Length;
   function "+"(C: Character) return U_String;

   -- Attr ------------------------------------
   type Xml_NodeAttr_A;
   type Xml_NodeAttr_Acc is access all Xml_NodeAttr_A'Class;
   type Xml_NodeAttr_A is abstract tagged record
      N, V : U_String;
   end record;
   package Xml_NodeAttr_Vectors is new Ada.Containers.Vectors (Natural,
     Xml_NodeAttr_Acc);
   use Xml_NodeAttr_Vectors;
   subtype Xml_NodeAttr_Cursor is Xml_NodeAttr_Vectors.Cursor;
   subtype Xml_NodeAttrs is Xml_NodeAttr_Vectors.Vector;
   type Xml_NodeAttr is new Xml_NodeAttr_A with null record;
   function Create_NodeAttr(N: U_String; V:U_String) return Xml_NodeAttr_Acc;

   -- Base Node ------------------------------------
   type Xml_Node_Type;
   type Xml_Node_Acc is access all Xml_Node_Type'Class;
   package Xml_Node_Vectors is new Ada.Containers.Vectors (Natural,
     Xml_Node_Acc);
   use Xml_Node_Vectors;
   subtype Xml_Nodes is Xml_Node_Vectors.Vector;
   subtype Xml_Node_Cursor is Xml_Node_Vectors.Cursor;

   type Xml_Node_Type is abstract tagged record
      Next    : Xml_Node_Acc;
      Childs  : Xml_Nodes;
      Parent  : Xml_Node_Acc;
      Attrs   : Xml_NodeAttrs;
   end record;

   procedure Print (N : in Xml_Node_Type; Tab: Natural);
   procedure SetTag (N :  in out Xml_Node_Type; Tag: U_String) ;
   procedure Process (N : in  Xml_Node_Acc);
   procedure AddAttr (Node : in Xml_Node_Acc; N,V: U_String ) ;
   procedure RemFrom(P:Xml_Node_Acc; C:Xml_Node_Acc) ;

   -- Pretty Node ------------------------------------
   type Xml_Node_Pretty;
   type Xml_Node_Pretty_Acc is access all Xml_Node_Pretty;
   type Xml_Node_Pretty is new Xml_Node_Type with record
      Extra: U_String;
   end record;

   procedure Print (N : in  Xml_Node_Pretty; Tab: Natural) ;
   procedure SetTag (N :  in out Xml_Node_Pretty; Tag: U_String) ;
   function Create_Xml_Node_Pretty(P:Xml_Node_Acc; E: U_String)
                                   return Xml_Node_Pretty_Acc;

   -- Short Node ------------------------------------
   type Xml_Node_Short;
   type Xml_Node_Short_Acc is access all Xml_Node_Short;
   type Xml_Node_Short is new Xml_Node_Type with record
      Short: U_String;
   end record;

   procedure Print (N : in  Xml_Node_Short; Tab: Natural) ;
   procedure SetTag (N :  in out Xml_Node_Short; Tag: U_String) ;
   function Create_Xml_Node_Short(P:Xml_Node_Acc;E: U_String)
                                  return Xml_Node_Short_Acc;

end disp_xml_node;


