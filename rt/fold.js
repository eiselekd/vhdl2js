eval(read("def.js"));

eval(exports.consts);

/* do a merge in case <hdl> is already defined */
if (typeof hdl === 'undefined') { hdl = {}; }
hdl = (function(a,b) {
    var r = {}
    for (var i in a) { r[i] = a[i];}
    for (var i in b) { r[i] = b[i]; }
    return r;
})(hdl,
(function() {
    return {
        fold: function (n,x) {
            switch(d.type) {
            case BINARYEXPRESSION:
                switch(d.op) {
                case PLUS:
                    c = n.children;
                    a = hdl.fold(c[left ], x);
                    b = hdl.fold(c[right], x);
                    
                    v = getValue(a) + getValue(b);
                }
                break;
            case UNARYEXPRESSION:
                break;
            }
        }
    };
})());

/*
  Local Variables:
  c-basic-offset:4
  indent-tabs-mode:nil
  End:
*/
