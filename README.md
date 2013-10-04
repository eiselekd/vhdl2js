Status: Planning

# vhdl2js

Convert VHDL to Javascript and execute evaluation stage.

vhdl2js is a runtime for VHDL code translated to javascript.
It implements the elaboration stage of VHDL, generating a instance hirarchy tree
and a connection graph for signals. The elaboration stage can be run in a 
browser and the output can be used to visualize the VHDL code and implement
various inspection tools.


# Translation of VHDL to javascript

## vhdl2xml

Subdirectory vhdl2xml contains GHDL (r150,gcc-4.7.2) patch. It adds the --xml switch
to ghdl. When given, the GHDL parser AST tree will be dumped as XML.

## xml2js

Subdirectory xml2js contains a perl script hdl2js.pl that converts the GHDL XML output to javascript. 
hdl2js.pl requires XML::LibXML to be installed (perl -MCPAN -e shell ... "install XML::LibXML").

