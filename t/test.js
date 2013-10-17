defs = require("./def.js");
eval(defs.consts);
jsout    = require("./jsout.js");
data     = require("./e1.vhd.b.js");
foldmod  = require("./fold.js");

var f = new foldmod.fold(0);
var c = new foldmod.Ctx();
var e = f.fold(arch['e1']['rtl'], c);

var v = e['procs'][0]['_scope'].getSym("v0",undefined, 0);
console.log(v);


console.log("a=");
console.log(jsout.jsout(e));
console.log(";");

var a = [];
a[2] = 1;

console.log(a.length + "!");

