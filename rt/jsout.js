
def = require("./def.js");
eval(def.consts);
function jsout(d) {
  var o = [], i, j, a;
  function totok(a) {
     return def.tokens[a];
  }
  function tostr(a) {
    if( !/^[0-9]/g.exec(a) ) {
      a = "\"" + a +"\"";
    }
    return a;   
  };
  if (d === undefined) {
      return 'undefined';
  }
  switch(d.type) {
  case ENTITY:
    o.push('type : ENTITY');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['generics'] === undefined)) { a = []; for (i = 0, j = d['generics'].length; i < j; i++) { a.push(jsout(d['generics'][i])) }; o.push('generics : [' + a.join(',') + ']'); }
    if (!(d['ports'] === undefined)) { a = []; for (i = 0, j = d['ports'].length; i < j; i++) { a.push(jsout(d['ports'][i])) }; o.push('ports : [' + a.join(',') + ']'); }
    break;
  case ARCHITECTURE:
    o.push('type : ARCHITECTURE');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['of'] === undefined)) { o.push('of :' + tostr(d['of'])); }
    if (!(d['decls'] === undefined)) { a = []; for (i = 0, j = d['decls'].length; i < j; i++) { a.push(jsout(d['decls'][i])) }; o.push('decls : [' + a.join(',') + ']'); }
    if (!(d['procs'] === undefined)) { a = []; for (i = 0, j = d['procs'].length; i < j; i++) { a.push(jsout(d['procs'][i])) }; o.push('procs : [' + a.join(',') + ']'); }
    if (!(d['concs'] === undefined)) { a = []; for (i = 0, j = d['concs'].length; i < j; i++) { a.push(jsout(d['concs'][i])) }; o.push('concs : [' + a.join(',') + ']'); }
    break;
  case PACKAGE:
    o.push('type : PACKAGE');
    if (!(d['decls'] === undefined)) { a = []; for (i = 0, j = d['decls'].length; i < j; i++) { a.push(jsout(d['decls'][i])) }; o.push('decls : [' + a.join(',') + ']'); }
    break;
  case PACKAGEBODY:
    o.push('type : PACKAGEBODY');
    if (!(d['decls'] === undefined)) { a = []; for (i = 0, j = d['decls'].length; i < j; i++) { a.push(jsout(d['decls'][i])) }; o.push('decls : [' + a.join(',') + ']'); }
    break;
  case PROCESS:
    o.push('type : PROCESS');
    if (!(d['label'] === undefined)) { o.push('label :' + tostr(d['label'])); }
    if (!(d['decls'] === undefined)) { a = []; for (i = 0, j = d['decls'].length; i < j; i++) { a.push(jsout(d['decls'][i])) }; o.push('decls : [' + a.join(',') + ']'); }
    if (!(d['block'] === undefined)) { a = []; for (i = 0, j = d['block'].length; i < j; i++) { a.push(jsout(d['block'][i])) }; o.push('block : [' + a.join(',') + ']'); }
    break;
  case GENERATE:
    o.push('type : GENERATE');
    if (!(d['decls'] === undefined)) { a = []; for (i = 0, j = d['decls'].length; i < j; i++) { a.push(jsout(d['decls'][i])) }; o.push('decls : [' + a.join(',') + ']'); }
    if (!(d['conditional'] === undefined)) { o.push("conditional : " + jsout(d['conditional'])); }
    break;
  case COMPONENT:
    o.push('type : COMPONENT');
    if (!(d['generics'] === undefined)) { a = []; for (i = 0, j = d['generics'].length; i < j; i++) { a.push(jsout(d['generics'][i])) }; o.push('generics : [' + a.join(',') + ']'); }
    if (!(d['ports'] === undefined)) { a = []; for (i = 0, j = d['ports'].length; i < j; i++) { a.push(jsout(d['ports'][i])) }; o.push('ports : [' + a.join(',') + ']'); }
    break;
  case GENERATE:
    o.push('type : GENERATE');
    if (!(d['cond'] === undefined)) { o.push('cond :' + tostr(d['cond'])); }
    if (!(d['decls'] === undefined)) { a = []; for (i = 0, j = d['decls'].length; i < j; i++) { a.push(jsout(d['decls'][i])) }; o.push('decls : [' + a.join(',') + ']'); }
    if (!(d['conditional'] === undefined)) { o.push("conditional : " + jsout(d['conditional'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case GENERIC:
    o.push('type : GENERIC');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['mode'] === undefined)) { o.push('mode :' + tostr(d['mode'])); }
    if (!(d['typedef'] === undefined)) { o.push("typedef : " + jsout(d['typedef'])); }
    if (!(d['init'] === undefined)) { o.push("init : " + jsout(d['init'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case COMPONENT:
    o.push('type : COMPONENT');
    if (!(d['generics'] === undefined)) { a = []; for (i = 0, j = d['generics'].length; i < j; i++) { a.push(jsout(d['generics'][i])) }; o.push('generics : [' + a.join(',') + ']'); }
    if (!(d['ports'] === undefined)) { a = []; for (i = 0, j = d['ports'].length; i < j; i++) { a.push(jsout(d['ports'][i])) }; o.push('ports : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ATTRIBUTEDEF:
    o.push('type : ATTRIBUTEDEF');
    if (!(d['val'] === undefined)) { o.push("val : " + jsout(d['val'])); }
    if (!(d['names'] === undefined)) { a = []; for (i = 0, j = d['names'].length; i < j; i++) { a.push(tostr(d['names'][i])) }; o.push('names : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case INTEGER:
    o.push('type : INTEGER');
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case INTEGERSUBTYPE:
    o.push('type : INTEGERSUBTYPE');
    if (!(d['range'] === undefined)) { o.push("range : " + jsout(d['range'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case STRINGSUBTYPE:
    o.push('type : STRINGSUBTYPE');
    if (!(d['range'] === undefined)) { o.push("range : " + jsout(d['range'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ACCESSTYPE:
    o.push('type : ACCESSTYPE');
    if (!(d['to'] === undefined)) { o.push('to :' + tostr(d['to'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case LIST:
    o.push('type : LIST');
    if (!(d['list'] === undefined)) { a = []; for (i = 0, j = d['list'].length; i < j; i++) { a.push(jsout(d['list'][i])) }; o.push('list : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case INTLITERAL:
    o.push('type : INTLITERAL');
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ENUMLITERAL:
    o.push('type : ENUMLITERAL');
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case BITSTRINGLITERAL:
    o.push('type : BITSTRINGLITERAL');
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case STRINGLITERAL:
    o.push('type : STRINGLITERAL');
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case WAVEFORM:
    o.push('type : WAVEFORM');
    if (!(d['elem'] === undefined)) { o.push("elem : " + jsout(d['elem'])); }
    if (!(d['delay'] === undefined)) { o.push("delay : " + jsout(d['delay'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case BINARYEXPRESSION:
    o.push('type : BINARYEXPRESSION');
    if (!(d['operator'] === undefined)) { o.push('operator :' + totok(d['operator'])); }
    if (!(d['left'] === undefined)) { o.push("left : " + jsout(d['left'])); }
    if (!(d['right'] === undefined)) { o.push("right : " + jsout(d['right'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case UNARYEXPRESSION:
    o.push('type : UNARYEXPRESSION');
    if (!(d['argument'] === undefined)) { o.push("argument : " + jsout(d['argument'])); }
    if (!(d['operator'] === undefined)) { o.push('operator :' + totok(d['operator'])); }
    if (!(d['left'] === undefined)) { o.push("left : " + jsout(d['left'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case WAITEXPRESSION:
    o.push('type : WAITEXPRESSION');
    if (!(d['wait'] === undefined)) { o.push("wait : " + jsout(d['wait'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case FUNCCALLEXPRESSION:
    o.push('type : FUNCCALLEXPRESSION');
    if (!(d['arguments'] === undefined)) { a = []; for (i = 0, j = d['arguments'].length; i < j; i++) { a.push(jsout(d['arguments'][i])) }; o.push('arguments : [' + a.join(',') + ']'); }
    if (!(d['calee'] === undefined)) { o.push("calee : " + jsout(d['calee'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case PROCCALLEXPRESSION:
    o.push('type : PROCCALLEXPRESSION');
    if (!(d['arguments'] === undefined)) { a = []; for (i = 0, j = d['arguments'].length; i < j; i++) { a.push(jsout(d['arguments'][i])) }; o.push('arguments : [' + a.join(',') + ']'); }
    if (!(d['calee'] === undefined)) { o.push("calee : " + jsout(d['calee'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case QUALEXPRESSION:
    o.push('type : QUALEXPRESSION');
    if (!(d['typedef'] === undefined)) { o.push('typedef :' + tostr(d['typedef'])); }
    if (!(d['right'] === undefined)) { o.push("right : " + jsout(d['right'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case TYPECONVERSION:
    o.push('type : TYPECONVERSION');
    if (!(d['typedef'] === undefined)) { o.push("typedef : " + jsout(d['typedef'])); }
    if (!(d['value'] === undefined)) { o.push("value : " + jsout(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case IDENTIFIER:
    o.push('type : IDENTIFIER');
    if (!(d['phase'] === undefined)) { o.push('phase :' + tostr(d['phase'])); }
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case IDENTIFIER:
    o.push('type : IDENTIFIER');
    if (!(d['phase'] === undefined)) { o.push('phase :' + tostr(d['phase'])); }
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case IDENTIFIER:
    o.push('type : IDENTIFIER');
    if (!(d['phase'] === undefined)) { o.push('phase :' + tostr(d['phase'])); }
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case IDENTIFIER:
    o.push('type : IDENTIFIER');
    if (!(d['phase'] === undefined)) { o.push('phase :' + tostr(d['phase'])); }
    if (!(d['value'] === undefined)) { o.push('value :' + tostr(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case IDENTIFIER:
    o.push('type : IDENTIFIER');
    if (!(d['phase'] === undefined)) { o.push('phase :' + tostr(d['phase'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case AGGREGATE:
    o.push('type : AGGREGATE');
    if (!(d['entries'] === undefined)) { a = []; for (i = 0, j = d['entries'].length; i < j; i++) { a.push(jsout(d['entries'][i])) }; o.push('entries : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case AGGREGATEENTRY:
    o.push('type : AGGREGATEENTRY');
    if (!(d['tags'] === undefined)) { a = []; for (i = 0, j = d['tags'].length; i < j; i++) { a.push(jsout(d['tags'][i])) }; o.push('tags : [' + a.join(',') + ']'); }
    if (!(d['value'] === undefined)) { o.push("value : " + jsout(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SIMPLEAGGREGATE:
    o.push('type : SIMPLEAGGREGATE');
    if (!(d['entries'] === undefined)) { a = []; for (i = 0, j = d['entries'].length; i < j; i++) { a.push(jsout(d['entries'][i])) }; o.push('entries : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ASSOCIATION:
    o.push('type : ASSOCIATION');
    if (!(d['value'] === undefined)) { o.push("value : " + jsout(d['value'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case OTHERS:
    o.push('type : OTHERS');
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case NAME:
    o.push('type : NAME');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ASSIGNMENTEXPRESSIONVAR:
    o.push('type : ASSIGNMENTEXPRESSIONVAR');
    if (!(d['left'] === undefined)) { o.push("left : " + jsout(d['left'])); }
    if (!(d['right'] === undefined)) { o.push("right : " + jsout(d['right'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ASSIGNMENTEXPRESSIONSIG:
    o.push('type : ASSIGNMENTEXPRESSIONSIG');
    if (!(d['left'] === undefined)) { o.push("left : " + jsout(d['left'])); }
    if (!(d['right'] === undefined)) { a = []; for (i = 0, j = d['right'].length; i < j; i++) { a.push(jsout(d['right'][i])) }; o.push('right : [' + a.join(',') + ']'); }
    if (!(d['wait'] === undefined)) { o.push("wait : " + jsout(d['wait'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case RANGEEXPRESSION:
    o.push('type : RANGEEXPRESSION');
    if (!(d['left'] === undefined)) { o.push("left : " + jsout(d['left'])); }
    if (!(d['right'] === undefined)) { o.push("right : " + jsout(d['right'])); }
    if (!(d['dir'] === undefined)) { o.push('dir :' + tostr(d['dir'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case MEMBEREXPRESSION:
    o.push('type : MEMBEREXPRESSION');
    if (!(d['object'] === undefined)) { o.push("object : " + jsout(d['object'])); }
    if (!(d['element'] === undefined)) { o.push('element :' + tostr(d['element'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case INDEXEXPRESSION:
    o.push('type : INDEXEXPRESSION');
    if (!(d['object'] === undefined)) { o.push("object : " + jsout(d['object'])); }
    if (!(d['indexes'] === undefined)) { a = []; for (i = 0, j = d['indexes'].length; i < j; i++) { a.push(jsout(d['indexes'][i])) }; o.push('indexes : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SLICEEXPRESSION:
    o.push('type : SLICEEXPRESSION');
    if (!(d['object'] === undefined)) { o.push("object : " + jsout(d['object'])); }
    if (!(d['range'] === undefined)) { o.push("range : " + jsout(d['range'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SLICEPOSEXPRESSION:
    o.push('type : SLICEPOSEXPRESSION');
    if (!(d['object'] === undefined)) { o.push("object : " + jsout(d['object'])); }
    if (!(d['pos'] === undefined)) { o.push('pos :' + tostr(d['pos'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ATTRIBUTE:
    o.push('type : ATTRIBUTE');
    if (!(d['object'] === undefined)) { o.push("object : " + jsout(d['object'])); }
    if (!(d['attribute'] === undefined)) { o.push('attribute :' + tostr(d['attribute'])); }
    if (!(d['parameter'] === undefined)) { o.push("parameter : " + jsout(d['parameter'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case IFSTATEMENT:
    o.push('type : IFSTATEMENT');
    if (!(d['test'] === undefined)) { o.push("test : " + jsout(d['test'])); }
    if (!(d['consequence'] === undefined)) { o.push("consequence : " + jsout(d['consequence'])); }
    if (!(d['alternate'] === undefined)) { o.push("alternate : " + jsout(d['alternate'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case BLOCKSTATEMENT:
    o.push('type : BLOCKSTATEMENT');
    if (!(d['body'] === undefined)) { a = []; for (i = 0, j = d['body'].length; i < j; i++) { a.push(jsout(d['body'][i])) }; o.push('body : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SWITCHSTATEMENT:
    o.push('type : SWITCHSTATEMENT');
    if (!(d['discriminant'] === undefined)) { o.push("discriminant : " + jsout(d['discriminant'])); }
    if (!(d['cases'] === undefined)) { a = []; for (i = 0, j = d['cases'].length; i < j; i++) { a.push(jsout(d['cases'][i])) }; o.push('cases : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SWITCHCASE:
    o.push('type : SWITCHCASE');
    if (!(d['tests'] === undefined)) { a = []; for (i = 0, j = d['tests'].length; i < j; i++) { a.push(jsout(d['tests'][i])) }; o.push('tests : [' + a.join(',') + ']'); }
    if (!(d['consequence'] === undefined)) { o.push("consequence : " + jsout(d['consequence'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case LOOPSTATEMENT:
    o.push('type : LOOPSTATEMENT');
    if (!(d['param'] === undefined)) { o.push("param : " + jsout(d['param'])); }
    if (!(d['block'] === undefined)) { o.push("block : " + jsout(d['block'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case WAITSTATEMENT:
    o.push('type : WAITSTATEMENT');
    if (!(d['wait'] === undefined)) { o.push("wait : " + jsout(d['wait'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case LOOPPARAM:
    o.push('type : LOOPPARAM');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['range'] === undefined)) { o.push("range : " + jsout(d['range'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case WHILESTATEMENT:
    o.push('type : WHILESTATEMENT');
    if (!(d['test'] === undefined)) { o.push("test : " + jsout(d['test'])); }
    if (!(d['block'] === undefined)) { o.push("block : " + jsout(d['block'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case BREAKSTATEMENT:
    o.push('type : BREAKSTATEMENT');
    if (!(d['cond'] === undefined)) { o.push("cond : " + jsout(d['cond'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case RETURNSTATEMENT:
    o.push('type : RETURNSTATEMENT');
    if (!(d['ret'] === undefined)) { o.push("ret : " + jsout(d['ret'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case REPORTSTATEMENT:
    o.push('type : REPORTSTATEMENT');
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ASSERTSTATEMENT:
    o.push('type : ASSERTSTATEMENT');
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case TYPERECORD:
    o.push('type : TYPERECORD');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['entries'] === undefined)) { a = []; for (i = 0, j = d['entries'].length; i < j; i++) { a.push(jsout(d['entries'][i])) }; o.push('entries : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case RECORDENTRY:
    o.push('type : RECORDENTRY');
    if (!(d['tag'] === undefined)) { o.push('tag :' + tostr(d['tag'])); }
    if (!(d['typedef'] === undefined)) { o.push("typedef : " + jsout(d['typedef'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case TYPEREF:
    o.push('type : TYPEREF');
    if (!(d['typedef'] === undefined)) { o.push('typedef :' + tostr(d['typedef'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case TYPECONSTRAINEDARRAY:
    o.push('type : TYPECONSTRAINEDARRAY');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['range'] === undefined)) { o.push("range : " + jsout(d['range'])); }
    if (!(d['typmark'] === undefined)) { o.push('typmark :' + tostr(d['typmark'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case TYPEARRAY:
    o.push('type : TYPEARRAY');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['range'] === undefined)) { o.push("range : " + jsout(d['range'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case TYPEENUM:
    o.push('type : TYPEENUM');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['values'] === undefined)) { a = []; for (i = 0, j = d['values'].length; i < j; i++) { a.push(tostr(d['values'][i])) }; o.push('values : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SUBPROG:
    o.push('type : SUBPROG');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['ftyp'] === undefined)) { o.push('ftyp :' + tostr(d['ftyp'])); }
    if (!(d['arguments'] === undefined)) { a = []; for (i = 0, j = d['arguments'].length; i < j; i++) { a.push(jsout(d['arguments'][i])) }; o.push('arguments : [' + a.join(',') + ']'); }
    if (!(d['decl'] === undefined)) { a = []; for (i = 0, j = d['decl'].length; i < j; i++) { a.push(jsout(d['decl'][i])) }; o.push('decl : [' + a.join(',') + ']'); }
    if (!(d['seq'] === undefined)) { a = []; for (i = 0, j = d['seq'].length; i < j; i++) { a.push(jsout(d['seq'][i])) }; o.push('seq : [' + a.join(',') + ']'); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ARG:
    o.push('type : ARG');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['mode'] === undefined)) { o.push('mode :' + tostr(d['mode'])); }
    if (!(d['typedef'] === undefined)) { o.push("typedef : " + jsout(d['typedef'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case VAR:
    o.push('type : VAR');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['typedef'] === undefined)) { o.push("typedef : " + jsout(d['typedef'])); }
    if (!(d['initializer'] === undefined)) { o.push("initializer : " + jsout(d['initializer'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SIG:
    o.push('type : SIG');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['typedef'] === undefined)) { o.push("typedef : " + jsout(d['typedef'])); }
    if (!(d['initializer'] === undefined)) { o.push("initializer : " + jsout(d['initializer'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ALIAS:
    o.push('type : ALIAS');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case FILE:
    o.push('type : FILE');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SIGNAL:
    o.push('type : SIGNAL');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['typdef'] === undefined)) { o.push("typdef : " + jsout(d['typdef'])); }
    if (!(d['initializer'] === undefined)) { o.push("initializer : " + jsout(d['initializer'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case ATTR:
    o.push('type : ATTR');
    if (!(d['name'] === undefined)) { o.push('name :' + tostr(d['name'])); }
    if (!(d['typdef'] === undefined)) { o.push("typdef : " + jsout(d['typdef'])); }
    if (!(d['loc'] === undefined)) { o.push('loc :' + tostr(d['loc'])); }
    break;
  case SELECT:
    o.push('type : SELECT');
    if (!(d['object'] === undefined)) { o.push("object : " + jsout(d['object'])); }
    if (!(d['indexes'] === undefined)) { a = []; for (i = 0, j = d['indexes'].length; i < j; i++) { a.push(jsout(d['indexes'][i])) }; o.push('indexes : [' + a.join(',') + ']'); }
    break;
  case APPEND:
    o.push('type : APPEND');
    if (!(d['elements'] === undefined)) { a = []; for (i = 0, j = d['elements'].length; i < j; i++) { a.push(jsout(d['elements'][i])) }; o.push('elements : [' + a.join(',') + ']'); }
    break;
  }
return '{' + o.join(',') + '}';
};

/*export jsout function only*/
exports.jsout = jsout;
