ghdl (http://ghdl.free.fr/), svn-r150 note: 
To compile on a 32-bit machine you need to revert the patch
for ortho-lang.c like this:

   if (precision <= MAX_BITS_PER_WORD)
     signed_and_unsigned_types[precision][unsignedp] = t;
-  else
-    t = NULL_TREE;

   return t;

otherwise vhdl compilation will fail.
