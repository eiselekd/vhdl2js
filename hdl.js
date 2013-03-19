/* do a merge in case <hdl> is already defined */
if (typeof hdl === 'undefined') { hdl = {}; }
hdl = (function(a,b) {
    var r = {}
    for (var i in a) {
	r[i] = a[i];
    }
    for (var i in b) {
	r[i] = b[i];
    }
    return r;
})(hdl,
(function() {
    var e = [];
    var p = function () { };
    var l = function () { };
    var a = function (b) { };
    if((!(typeof window === 'undefined')) && window.console ) {
	p = function (a) { 
	    if (typeof a === 'string') {
		console.log(a); 
	    } else {
		console.dir(a); 
	    };
	};
	a = function(b) {
	    console.assert(b);
	}
    } else if (!(typeof readline === 'undefined')) {
	p = function (a) { print(a); };
	l = function (a) { load(a); };
    }
    return {
	/* return type of object, 
	 * return "_typ()" if defined, 
	 * return class name 
	 * return typeof */
	typeof: function(a) {
	    if (typeof a === "object") {
		if (!(typeof a._typ ===  'undefined')) {
		    return a._typ();
		}
		var funcNameRegex = /function (.{1,})\(/;
		var results = (funcNameRegex).exec(a.constructor.toString());
		if (results && results.length > 1) { 
		    return results[1];
		}
	    } 
	    return (typeof a);
	},
	/* convert Arguments to Array */
	arg2ar: function (j,a) {
	    var ar = []; var i;
	    for (i = j; i < a.length; i += 1) {
		ar.push(a[i]);
	    }
	    return ar;
	},
	/* create ast base class */
	ast: function(a) {
	    var v = new typ.ast(a, hdl.arg2ar(1,arguments));
	    return v;
	},
	/* create ast-literal */
	l: function() {
	    var v = new typ.ast("l", hdl.arg2ar(0,arguments));
	    hdl.propreadwrite(v,'tryeval',typ.ast.prototype.tryeval_l);
	    hdl.propreadwrite(v,'l',v.c[0]);
	    hdl.pushcode(v,v.l);
	    return v;
	},
	/* create ast-binop */
	b: function(a,rest) {
	    var v =new typ.ast(a, hdl.arg2ar(1,arguments));
	    hdl.propreadwrite(v,'tryeval',typ.ast.prototype.tryeval_b);
	    hdl.propreadenum(v,'l',v.c[0]);
	    hdl.propreadenum(v,'r',v.c[1]);
	    hdl.pushcode(v,v.l);
	    hdl.pushcode(v,v.r);
	    return v;
	},
	/* create ast-unop */
	u: function(a) {
	    var v =new typ.ast(a, hdl.arg2ar(1,arguments));
	    hdl.propreadwrite(v,'tryeval',typ.ast.prototype.tryeval_u);
	    hdl.propreadenum(v,'l',v.c[0]);
	    hdl.pushcode(v,v.l);
	    return v;
	},
	/* create a non-enumerable property */
	propreadwrite: function(p,n,v) {
	    Object.defineProperty(p,n, {value : v,
					writable : true,
					enumerable : false,
					configurable : true});
	},
	/* create a enumerable noon-writable property */
	propreadenum: function(p,n,v) {
	    Object.defineProperty(p,n, {value : v,
					writable : false,
					enumerable : true,
					configurable : true});
	},
	/* add enumerable property <v> to ast <p> */
	pushcode: function (p,v) {
	    hdl.propreadenum(p,(p.cnt++)+"",v);
	},
	/* ast if case called with array of "<cond> <block>" entries,
	 * the last entry is <block> it is a else, nested elsif are subtrees */ 
	if: function(p,a,f) {
	    var isfirst = 1; var ret;
	    var ar = hdl.arg2ar(1,arguments);
	    var cur = p; var al;
	    
	    while(ar.length >= 2 &&
		  hdl.typeof(ar[0]) == 'ast' &&
		  hdl.typeof(ar[1]) == 'function'
		 ) {
		var v = new typ.ast("if", hdl.arg2ar(1,arguments));
		if (isfirst) {
		    isfirst = 0;
		    ret = v;
		}
		hdl.pushcode(cur,v); cur = v;
	    	var c = ar.shift();
		var b = ar.shift();
		hdl.pushcode(v,c);
		al = hdl.block(v, b);
		hdl.propreadwrite(v,'true',al);
		
	    }
	    if (hdl.typeof(ar[0]) == 'function') {
		al = hdl.block(cur, ar[0]);
		hdl.propreadwrite(v,'false',al);
	    }
	    
	    return ret;
	},
	/* vhdl variable set */ 
	vset: function(p,d,s) {
	    var ret; var cur = p;
	    var ar = hdl.arg2ar(1,arguments);
	    var v = new typ.ast(":=", ar);
	    hdl.pushcode(cur,v);
	    hdl.propreadenum(v,'d',d);
	    hdl.propreadenum(v,'s',s);
	    return v;
	},
	/* vhdl signal set */
	sigset: function(p,d,s) {
	    var ret; var cur = p;
	    var ar = hdl.arg2ar(1,arguments);
	    var v = new typ.ast("<=", ar);
	    hdl.pushcode(cur,v);
	    hdl.propreadenum(v,'d',d);
	    hdl.propreadenum(v,'s',s);
	    return v;
	},
	/* ast block is a sequential implemented as function <f>. <f> 
	 * is called to generate the ast-tree */
	block: function(p,f) {
	    var v = new typ.ast("block", hdl.arg2ar(1,arguments));
	    hdl.pushcode(p,v);
	    f.apply(v,[]);
	    return v;
	},
	/* PORTS: register inport <port> with name <n> at <o>*/
	inport: function (o,n,port) { 
	    hdl.assert(port._n() == n);
	    o[n] = port;
	    port._s = 'pi';
	    return port; 
	},
	/* PORTS: register outport <port> with name <n> at <o> */
	outport: function (o,n,port) { 
	    hdl.assert(port._n() == n);
	    o[n] = port;
	    port._s = 'po';
	    return port;
	},
	/* SIGNALS: register signal <s> with name <n> at <o> */
	signal: function (o,n,s) {
	    hdl.assert(s._n() == n);
	    o[n] = s;
	    s._s = 'sig';
	    return s;
	},
	/* VARIABLES: register variable <v> with name <n> at <o> */
	var: function (o,n,v) {
	    hdl.assert(v._n() == n);
	    o[n] = v;
	    return v;
	},
	/* INSTANCES: register instance <i> with name <n> at <o> */
	inst: function (o,n,i) {
	    hdl.assert(i._n() == n);
	    o[n] = i;
	    if (typeof o._i === 'undefined') { o._i = []; }
	    o._i.push(i);
	    return i;
	},
	/* PROCESS: register process <f> with name <n> at <o>,
	 * register a elaborate callback
	 */
	proc: function (o,n,f) {
	    var v = new typ.proc();
	    hdl.propreadwrite(v, "cnt", 0);
	    hdl.obj(v,o,n);
	    v.elaborate = function() { f.apply(v,[n]); }
	    o[n] = v;
	    if (typeof o._p === 'undefined') { o._p = []; }
	    o._p.push(v);
	    return v;
	},
	/* merge 2 objects, used to subclass a prototype */
	merge: function(a,b) {
	    var r = {}
	    for (var i in a) {
		r[i] = a[i];
	    }
	    for (var i in b) {
		r[i] = b[i];
	    }
	    return r;
	},
	/* merge and also add _typ() that is used by hdl.typeof */
	mergetyp: function(n,a,b) {
	    a._typ = function() { return n; }
	    return hdl.merge(a,b);
	},
	/* merge prototype, make all properties non-enumerable */
	mergeenum: function(n,b,a) {
	    var r = {};
	    hdl.propreadwrite(r, "_typ", function() { return n; });
	    var a0 = Object.getOwnPropertyNames(a);
	    for (var i in a0) {
		hdl.propreadwrite(r, a0[i], a[a0[i]]);
	    }
	    var b0 = Object.getOwnPropertyNames(b);
	    for (var i in b0) {
		hdl.propreadwrite(r, b0[i], b[b0[i]]);
	    }
	    return r;
	},
	/* define name path of <o> as child of <p>, unique name of <o> is <n> */
	obj: function (o,p,n) {
	    var path = p._id().split();
	    path.push(n);
	    o.__id = path.filter(function(a) { return a.length > 0; }).join(".");
	    return o;
	},
	/* elaborate loop */
	elaborate: function(top) {
	    e = [top];
	    while(e.length > 0) {
		var a = e.shift();
		a.elaborate();
		if (!(typeof a._i === 'undefined')) {
		    for (var i in a._i) {
			e.push(a._i[i]);
		    }
		}
		if (!(typeof a._p === 'undefined')) {
		    for (var i in a._p) {
			e.push(a._p[i]);
		    }
		}
	    }
	},
	print: p,
	load: l,
	assert: a
    };
})());

typ = (function() {
    var _ec = [];
    var _obj = function (p,n) {};
    _obj.prototype = { 
	_scope: function () { return (typeof this._s === 'undefined') ? "" : this._s; }, 
	_id: function () { return this.__id; }, 
    	_n:  function () { var a = this._id().split("."); return a.pop(); }/*,
	toString: function() { return this._n(); }*/
    };
    var _inst = function (p,n) {};
    _inst.prototype = hdl.mergetyp("inst",{}, _obj.prototype);
    var _proc = function (p,n) {};
    _proc.prototype = hdl.mergetyp("proc",{}, _obj.prototype);
    var _line = function (f) { this._f = f; };
    _line.prototype = hdl.mergetyp("line",{
	evaluate: function(o,n) {
	    o[n] = this;
	    this._f(arguments);
	}
    }, _obj.prototype);
    var _ast = function (n,c) { 
	hdl.propreadwrite(this,"cmd",n);
	hdl.propreadwrite(this,"c",c);
	hdl.propreadwrite(this,"cnt",0); };
    _ast.prototype = hdl.mergeenum("ast",{
	toString: function() {
	    var r = "(" + this.cmd + " ";
	    this.forEach(function(v,i) {
		if (!(hdl.typeof(v) === 'undefined' || (typeof v.toString === 'undefined'))) {
		    r += v.toString() + " ";
		} else {
		    r += "<" + (typeof v) + ">" ;
		}
	    });
	    r += ")";
	    return r;
	},
	forEach: function ( callback, thisArg ) {
	    var T, k;
	    /* https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/forEach */
	    if ( this == null ) {
		throw new TypeError( "this is null or not defined" );
	    }
	    var ks = this.keys();
	    var O = Object(this);
	    var len = ks.length >>> 0; // Hack to convert O.length to a UInt32
	    if ( {}.toString.call(callback) !== "[object Function]" ) {
		throw new TypeError( callback + " is not a function" );
	    }
	    if ( thisArg ) {
		T = thisArg;
	    }
	    k = 0;
	    while( k < len ) {
		var kValue;
		var id = ks[k];
		if ( Object.prototype.hasOwnProperty.call(O, id) ) {
		    kValue = O[ id ];
		    callback.call( T, kValue, id, O );
		}
		k++;
	    }
	},
	keys: function() {
	    var a = [];
	    for (var p in this) {
		if (this.hasOwnProperty(p)) {
    		    a.push(p);
		}
	    }
	    return a.sort(function(a,b){return a-b});
	},
	tryeval_l: function (a) {
	    
	},
	tryeval_u: function (a) {
	    var cmd, x, y, r = 0, ctx = {}, lv, rv;
	    this.l.tryeval();
	},
	tryeval_b: function (a) {
	    /* binop : */
	    var cmd, x, y, r = 0, ctx = {}, lv, rv;
	    this.l.tryeval();
	    this.r.tryeval();
	    
	    if (this.op == '=') {
	    } else if (this.op == '&&') {
		if (this.l.isconst(x) && this.l.isconst(y)) {
		    ret = (this.l.int(x) && this.r.int(y)) ? 1 : 0;
		    this.setint(ret);
	    	}
	    } else if (cmd == '||') {
		if (this.l.isconst(x) && this.l.isconst(y)) {
		    ret = (this.l.int(x) || this.r.int(y)) ? 1 : 0;
		    this.setint(ret);
	    	}
	    }
	    return r;
	}

    }, _obj.prototype);
    
    /* _arr is a subrange of an _arr instance */
    var _range = function(p,a,b,d) {
	var n = "[]";
	switch(d) {
	case -1:
	    n = "[" + a + " downto " + b + "]"; break;
	case 0:
	    n = "[" + a + "]"; break;
	case 1:
	    n = "[" + a + " to " + b + "]"; break;
	}
	hdl.obj(this,p,n);
	this._p = p;
	this._l = a;
	this._r = b;
	this._d = d;
    }
    _range.prototype =  hdl.mergetyp("range",{
	toString: function() { var r = []; var a = this._id().split("."); return a.splice(a.length-2,2).join("");
			       return this._id(); },
    	p: function() { return this._p; },
	l: function() { return this._l; },
	r: function() { return this._r; },
	d: function() { return this._d; }
    },_obj.prototype);
    /* _arr is a instance of a subrange(array()) type */
    var _arr = function(p,n,a,b,d) {
	hdl.obj(this,p,n);
	this._a  = [];
	this._l = a;
	this._r = b;
	this._d = d;
    }
    _arr.prototype =  hdl.mergetyp("arr",{
	l: function() { return this._l; },
	r: function() { return this._r; },
	d: function() { return this._d; },
	to: function(a,b) {
	    return new _range(this,a,b,1);
	},
	at: function(a) {
	    return new _range(this,a,a,0);
	},
	downto: function(a,b) {
	    return new _range(this,a,b,-1);
	}
    },_obj.prototype);
    /* for _enum.prototype */
    var _enum = function (p,n) { }
    _enum.prototype =  hdl.mergetyp("enum",{
	toString: function() { return this._n(); }
    },_obj.prototype);
    /* for _rec.prototype */
    var _rec = function (p,n) { }
    _rec.prototype =  hdl.mergetyp("rec",{},_obj.prototype);
    

    return {
	/* Create subtype of a bound array() type. Subtype is <pt>.st(). Set range <a>[to|downto]<b>.
	 * vhdl:subtype lru_type is std_logic_vector(DLRUBITS-1 downto 0)
	 *      [type valid_type is array (0 to DSETS-1)] of [std_logic_vector(dlinesize - 1 downto 0)] */
	subrange: function (pt,a,b,dir) {
	    var f = {
		pt : function () { return pt; },
		st : function () { return pt.st(); },
		new : function(p,n) {
		    var o = new _arr(p,n,a,b,dir); 
		    for (var i = o.l(); (o.d() == -1) ? (i >= o.r()) : (i <= o.r()); i+=o.d()) {
			o._a[i] = pt.st().new(o, "["+i+"]");
		    }
		    return o;
		}
	    }
	    return f;
	},
	to: function (t,a,b) { return typ.subrange(t,a,b,1); },
	downto: function (t,a,b) { return typ.subrange(t,a,b,-1); },
	
	/* vhdl: TYPE artyp IS ARRAY ( [NATURAL RANGE <>] ) OF subtyp; */
	array: function (t,tn) {
	    var st = t;
	    var a = {
		st  : function () { return st; },
		new : function (p,n) {
		    return t.new(p,n)
		}
	    };
	    return a;
	},
	obj : _obj,
	arr : _arr,
	enum : _enum,
	rec : _rec,
	inst : _inst,
	proc : _proc,
	line : _line,
	ast: _ast
    };
})();

/*
  Local Variables:
  c-basic-offset:4
  indent-tabs-mode:nil
  End:
*/
