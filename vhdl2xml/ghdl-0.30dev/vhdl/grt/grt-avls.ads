--  GHDL Run Time (GRT) - binary balanced tree.
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
with Grt.Types; use Grt.Types;

package Grt.Avls is
   --  Implementation of a binary balanced tree.
   --  This package is very generic, and provides only the algorithm.
   --  The user must provide the storage of the tree.
   --  The basic types of this implementation ares:
   --  * AVL_Value: the value stored in the tree.  This is an integer on 32
   --    bits.  However, they may either really represent integers or an index
   --    into another table.  To compare two values, a user function is always
   --    provided.
   --  * AVL_Nid: a node id or an index into the tree.
   --  * AVL_Node: a node, indexed by AVL_Nid.
   --  * AVL_Tree: an array of AVL_Node, indexed by AVL_Nid.  This represents
   --    the tree.  The root of the tree is always AVL_Root, which is the
   --    first element of the array.
   --
   --  As a choice, this package never allocate nodes.  So, to insert a value
   --  in the tree, the user must allocate an (empty) node, set the value of
   --  the node and try to insert this node into the tree.  If the value is
   --  already in the tree, Get_Node will returns the node id which contains
   --  the value.  Otherwise, Get_Node returns the node just created by the
   --  user.

   --  The value in an AVL tree.
   --  This is fixed.
   type AVL_Value is new Ghdl_I32;

   --  An AVL node id.
   type AVL_Nid is new Ghdl_I32;
   AVL_Nil : constant AVL_Nid := 0;
   AVL_Root : constant AVL_Nid := 1;

   type AVL_Node is record
      Val : AVL_Value;
      Left : AVL_Nid;
      Right : AVL_Nid;
      Height : Ghdl_I32;
   end record;

   type AVL_Tree is array (AVL_Nid range <>) of AVL_Node;

   --  Compare two values.
   --  Returns < 0 if L < R, 0 if L = R, > 0 if L > R.
   type AVL_Compare_Func is access function (L, R : AVL_Value) return Integer;

   --  Try to insert node N into TREE.
   --  Returns either N or the node id of a node containing already the value.
   procedure Get_Node (Tree : in out AVL_Tree;
                       Cmp : AVL_Compare_Func;
                       N : AVL_Nid;
                       Res : out AVL_Nid);

   function Find_Node (Tree : AVL_Tree;
                       Cmp : AVL_Compare_Func;
                       Val : AVL_Value) return AVL_Nid;

end Grt.Avls;


