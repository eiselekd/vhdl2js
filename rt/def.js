var tokens = [
    
 "GENERATE",
 "COMPONENT",

 "GENERATE",

 "GENERIC",

 "COMPONENT",
 "ATTRIBUTEDEF",

 "INTEGER",
 "INTEGERSUBTYPE",
 "STRINGSUBTYPE",
 "ACCESSTYPE",
 "LIST",

 "INTLITERAL",       
 "ENUMLITERAL",      
 "BITSTRINGLITERAL", 
 "STRINGLITERAL",    
 "WAVEFORM", 'elem', 

 "BINARYEXPRESSION",   
 "UNARYEXPRESSION",    
 "WAITEXPRESSION",     
 "FUNCCALLEXPRESSION", 
 "PROCCALLEXPRESSION", 
 "QUALEXPRESSION",     
 "TYPECONVERSION",     

 "IDENTIFIER", 
 "AGGREGATE",  
 "AGGREGATEENTRY",
 "SIMPLEAGGREGATE",

 "ASSOCIATION", 

 "OTHERS", 
 "NAME", 

 "ASSIGNMENTEXPRESSIONVAR", 
 "ASSIGNMENTEXPRESSIONSIG", 
 "RANGEEXPRESSION",         
 "MEMBEREXPRESSION",        
 "INDEXEXPRESSION",         
 "SLICEEXPRESSION",         
 "SLICEPOSEXPRESSION",      
 "ATTRIBUTE",               

 "IFSTATEMENT",             
 "BLOCKSTATEMENT",          
 "SWITCHSTATEMENT",         
 "SWITCHCASE",              
 "LOOPSTATEMENT",           
 "WAITSTATEMENT",           

 "LOOPPARAM", 


 "WHILESTATEMENT",  
 "BREAKSTATEMENT",  
 "RETURNSTATEMENT", 

 "REPORTSTATEMENT"  , 
 "ASSERTSTATEMENT"  , 


 "TYPERECORD",  
 "RECORDENTRY", 
 "TYPEREF", 
 "TYPECONSTRAINEDARRAY", 
 "TYPEARRAY", 
 "TYPEENUM", 

 "SUBPROG", 
 "ARG", 

 "VAR", 
 "SIG", 
 "ALIAS",
 "FILE", 
 "SIGNAL", 
 "ATTR", 




 "SEMICOLON",
 "COMMA",
 "HOOK",
 "COLON",
 "OR",
 "AND",
 "BITWISE_OR",
 "BITWISE_XOR",
 "BITWISE_AND",
 "STRICT_EQ",
"EQ",
  "ASSIGN",
 "STRICT_NE",
 "NE",
 "LSH",
 "LE",
 "LT",
 "URSH",
 "RSH",
 "GE",
 "GT",
 "INCREMENT",
 "DECREMENT",
 "PLUS",
 "MINUS",
 "MUL",
 "DIV",
 "MOD",
 "NOT",
 "BITWISE_NOT",
 "DOT",
 "LEFT_BRACKET",
 "RIGHT_BRACKET",
 "LEFT_CURLY",
 "RIGHT_CURLY",
 "LEFT_PAREN",
 "RIGHT_PAREN"
];

var consts = "";
var tokenIds = {};
for (var i = 0, j = tokens.length; i < j; i++) {
    if (i > 0)
        consts += ", ";
    var t = tokens[i];
    var name;
    name = t.toUpperCase();
    consts += name + " = " + i;
    tokenIds[name] = i;
    tokens[t] = i;
}
consts += ";";

exports = {};
exports.consts = consts;

/*
  Local Variables:
  c-basic-offset:4
  indent-tabs-mode:nil
  End:
*/
