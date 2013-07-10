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

## Types

A VHDL type definition is converted to a Javascript type definition by 
allocating a javascript object of the same name containing a "new" function 
and a javascript class protorype of the same name with prefix _t1_ prepended.

VHDL:
```vhdl
type t1 is ... ;
```

Javascript:

```javascript
function _t_t1 (p,n) {
    ...
}
_t_t1.prototype = hdl.mergetyp("t1",{},typ.<typ>.prototype); 
var t1 = { 
    new: function(p,n) { return new _t_t1(p,n); } 
};
```
(<typ> can be [enum|...])



t1 is the type definition while t1.new() creates a instance of type t1,
which is javascript class instance _t1.

## Array-types


To create a new type which represents a array of a typ the typ.array()
function is used: 

VHDL:
```vhdl
type std_logic_vector is array of std_logic ;
```

Javascript.
```javascript
var std_logic_vector = typ.array(std_logic);
```

## Range delimited Array subtype

To create a range delimited subtyp out of a array type the typ.[to|downto]()
function is be used:
VHDL:
```vhdl
type r1 is array (0 to 1) of t2
```
Javascript:
```javascript
var r1 = typ.to(typ.array(t2),0,1);
```

A entity is translated into a javascript class similar to the type translation.
The following template is used which is similar to the type tranlation:

## Enumeration basetype

enumeration values are specified by 'v' member of the prototype object of the
_t_ prefixed class object:

```javascript
_t_std_logic.prototype = hdl.mergetyp("std_logic",{v: ['U','X','0','1','Z','W','L','H', '-']},typ.enum.prototype);
```

## Entities


VHDL code:

```vhdl
entity e1 is
...
end;
```

Javascript code:
```javascript

function _t_e1 (_p,_n,_g,_port) {
	 ...
	 this.elaborate = function() { 
	 ...
	 };
}
_t_e1.prototype = hdl.merge({},typ.inst.prototype); 
var e1 = { 
    new: function(p,n,g,port) { return new _t_e1(p,n,g,port); } 
};
```

Inside a VHDL entity namespace there are: 

 * ports
 * generics
 * signal definitions
 * processes
 * variables

The VHDL entity namespace is modeled by a three level closure. 
Inside the entity entity instantiation function the generic
and port declarators are defined. Inside the entities elaborate() function
the signal  and process declarations are defined. Inside the 
process elaborate function the variables are defined.

```javascript
function _t_e1 (_p,_n,_g,_port) {
	 /* generics */
         var g1 = ...
         /* ports */
         var p1 = ...
	 this.elaborate = function() {  
             /* signals */
             var s1 = ...
             /* proc */
             var p0 = ... {
                 /* variables *(
                 var v1 = ...
             }
	 };
}
```

The vhdl "use" clause is implemented by eval() inside the entities instantiation
function, which will import the types and entity definitions into 
the entities namespace:

```javascript
function _t_e1 (_p,_n,_g,_port) {
    package_p1.use_elaborate();
    /* package p1, import namespace */
    eval(package_p1._e);
    ...
}
```

## Process declarations

The process statement list is build up in the process elaborate function
that is given as an argument to hdl.proc():

VHDL:
```vhdl
entity e1...
architecture rtl of ...
p0:  process  (...) ...
end rtl;
```
Javascript:
```javascript
function _t_e1 (_p,_n,_g,_port) {
    ...
    this.elaborate = function() {  
        var p0 = hdl.proc(this, "p0", function(p,n) {
            ...
            hdl.block(this,function() {
                ...
            }
        }
    }
}
```

 * hdl.block(p,fn) 
    models a VHDLstatement list. The AST of the statement list is built up by 
    executing fn.
 * hdl.if(p,exp0,block0,exp1,block1,...,blockn) 
    models a VHDL statement lists multiplexed by if,elsif,else expressions. The first
    (exp,block) pair is the if condition and clause, the second (exp,block) pair is 
    the subsequent elsif condition and block, the last block is the else clause. Each 
    expression is build as a AST and each clause is executed to build up AST of the 
    clause statements.
 * hdl.vset() 
    models a VHDL variable assignement
 * hdl.sset() 
    models a VHDL signal assignement
 * hdl.b() 
    models a VHDL binary expression
 * hdl.l() 
    models a VHDL expresion literal

VHDL:
```vhdl
    if (in0(0) = '0') then
      if (in0(1) = '0') then
        v1 := '0';
      end if;
      v0 := '1';
    else
      v0 := '0';
    end if;
```
	    
Javascript:
```javascript
    hdl.block(this,function() {
	hdl.if(this,hdl.b("=",hdl.l(in0.at(1)),hdl.l(0)),
           function() { /* if clause */
              hdl.if(this,hdl.b("=",hdl.l(in0.at(1)),hdl.l(0)),
                 function() {
                     hdl.vset(this,v1, ['0']);
                 }
               );
               hdl.vset(this,v0, ['1']);
	   },
           function() {  /* else clause */
               hdl.vset(this,v0, ['0']);
           }
        );
    });
```	    




## d8

d8 hdl.js

## web

firefox/chrome e1.html
