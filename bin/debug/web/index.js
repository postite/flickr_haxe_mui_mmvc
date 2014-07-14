(function () { "use strict";
var $hxClasses = {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	r: null
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw "EReg::matched";
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,__class__: EReg
};
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var JS = function() { };
$hxClasses["JS"] = JS;
JS.__name__ = ["JS"];
JS.detectPrefix = function() {
	var styles = Array.prototype.slice.call(window.getComputedStyle(document.documentElement,"")).join("");
	var ereg = new EReg("-(moz|webkit|o|ms)-","");
	if(ereg.match(styles)) return ereg.matched(1); else if(window.navigator.userAgent.toLowerCase().indexOf("presto") >= 0) return "o"; else return "";
};
JS.getPrefixedStyleName = function(name) {
	if(JS.prefix == "") return name; else return JS.prefix + name.charAt(0).toUpperCase() + HxOverrides.substr(name,1,null);
};
JS.getPrefixedCSSName = function(name) {
	if(JS.prefix == "") return name; else return "-" + JS.prefix + "-" + name;
};
var Lambda = function() { };
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = ["Lambda"];
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
};
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
};
Lambda.empty = function(it) {
	return !$iterator(it)().hasNext();
};
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
};
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,__class__: List
};
var Main = function() { };
$hxClasses["Main"] = Main;
Main.__name__ = ["Main"];
Main.main = function() {
	var view = new flickrapp.app.ApplicationView();
	new flickrapp.app.ApplicationContext(view);
	mui.Lib.get_display().addChild(view);
	view.initialize();
};
var IMap = function() { };
$hxClasses["IMap"] = IMap;
IMap.__name__ = ["IMap"];
IMap.prototype = {
	get: null
	,keys: null
	,__class__: IMap
};
Math.__name__ = ["Math"];
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) return null; else if(o.__properties__ && (tmp = o.__properties__["get_" + field])) return o[tmp](); else return o[field];
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
};
Reflect.deleteField = function(o,field) {
	if(!Object.prototype.hasOwnProperty.call(o,field)) return false;
	delete(o[field]);
	return true;
};
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	b: null
	,add: function(x) {
		this.b += Std.string(x);
	}
	,addSub: function(s,pos,len) {
		if(len == null) this.b += HxOverrides.substr(s,pos,null); else this.b += HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
};
var StringTools = function() { };
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	if(quotes) return s.split("\"").join("&quot;").split("'").join("&#039;"); else return s;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.lpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = c + s;
	return s;
};
StringTools.rpad = function(s,c,l) {
	if(c.length <= 0) return s;
	while(s.length < l) s = s + c;
	return s;
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
};
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
var StyleMacro = function() { };
$hxClasses["StyleMacro"] = StyleMacro;
StyleMacro.__name__ = ["StyleMacro"];
var ValueType = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] };
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { };
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
};
Type.getSuperClass = function(c) {
	return c.__super__;
};
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
};
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
};
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
};
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
};
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
};
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
};
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c;
		if((v instanceof Array) && v.__enum__ == null) c = Array; else c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
Type.enumConstructor = function(e) {
	return e[0];
};
Type.enumParameters = function(e) {
	return e.slice(2);
};
var XmlType = { __ename__ : ["XmlType"], __constructs__ : [] };
var Xml = function() {
};
$hxClasses["Xml"] = Xml;
Xml.__name__ = ["Xml"];
Xml.parse = function(str) {
	return haxe.xml.Parser.parse(str);
};
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new haxe.ds.StringMap();
	r.set_nodeName(name);
	return r;
};
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.set_nodeValue(data);
	return r;
};
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.set_nodeValue(data);
	return r;
};
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.set_nodeValue(data);
	return r;
};
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.set_nodeValue(data);
	return r;
};
Xml.createProcessingInstruction = function(data) {
	var r = new Xml();
	r.nodeType = Xml.ProcessingInstruction;
	r.set_nodeValue(data);
	return r;
};
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
};
Xml.prototype = {
	nodeType: null
	,_nodeName: null
	,_nodeValue: null
	,_attributes: null
	,_children: null
	,_parent: null
	,get_nodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,set_nodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,get_nodeValue: function() {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue;
	}
	,set_nodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.get(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,attributes: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.keys();
	}
	,iterator: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			return this.cur < this.x.length;
		}, next : function() {
			return this.x[this.cur++];
		}};
	}
	,elements: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				if(this.x[k].nodeType == Xml.Element) break;
				k += 1;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k1 = this.cur;
			var l1 = this.x.length;
			while(k1 < l1) {
				var n = this.x[k1];
				k1 += 1;
				if(n.nodeType == Xml.Element) {
					this.cur = k1;
					return n;
				}
			}
			return null;
		}};
	}
	,elementsNamed: function(name) {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				if(n.nodeType == Xml.Element && n._nodeName == name) break;
				k++;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k1 = this.cur;
			var l1 = this.x.length;
			while(k1 < l1) {
				var n1 = this.x[k1];
				k1++;
				if(n1.nodeType == Xml.Element && n1._nodeName == name) {
					this.cur = k1;
					return n1;
				}
			}
			return null;
		}};
	}
	,firstChild: function() {
		if(this._children == null) throw "bad nodetype";
		return this._children[0];
	}
	,firstElement: function() {
		if(this._children == null) throw "bad nodetype";
		var cur = 0;
		var l = this._children.length;
		while(cur < l) {
			var n = this._children[cur];
			if(n.nodeType == Xml.Element) return n;
			cur++;
		}
		return null;
	}
	,addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.push(x);
	}
	,toString: function() {
		if(this.nodeType == Xml.PCData) return StringTools.htmlEscape(this._nodeValue);
		if(this.nodeType == Xml.CData) return "<![CDATA[" + this._nodeValue + "]]>";
		if(this.nodeType == Xml.Comment) return "<!--" + this._nodeValue + "-->";
		if(this.nodeType == Xml.DocType) return "<!DOCTYPE " + this._nodeValue + ">";
		if(this.nodeType == Xml.ProcessingInstruction) return "<?" + this._nodeValue + "?>";
		var s = new StringBuf();
		if(this.nodeType == Xml.Element) {
			s.b += "<";
			s.b += Std.string(this._nodeName);
			var $it0 = this._attributes.keys();
			while( $it0.hasNext() ) {
				var k = $it0.next();
				s.b += " ";
				if(k == null) s.b += "null"; else s.b += "" + k;
				s.b += "=\"";
				s.add(this._attributes.get(k));
				s.b += "\"";
			}
			if(this._children.length == 0) {
				s.b += "/>";
				return s.b;
			}
			s.b += ">";
		}
		var $it1 = this.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			s.add(x.toString());
		}
		if(this.nodeType == Xml.Element) {
			s.b += "</";
			s.b += Std.string(this._nodeName);
			s.b += ">";
		}
		return s.b;
	}
	,__class__: Xml
	,__properties__: {set_nodeValue:"set_nodeValue",get_nodeValue:"get_nodeValue",set_nodeName:"set_nodeName",get_nodeName:"get_nodeName"}
};
var mmvc = {};
mmvc.api = {};
mmvc.api.IContext = function() { };
$hxClasses["mmvc.api.IContext"] = mmvc.api.IContext;
mmvc.api.IContext.__name__ = ["mmvc","api","IContext"];
mmvc.api.IContext.prototype = {
	commandMap: null
	,__class__: mmvc.api.IContext
};
mmvc.impl = {};
mmvc.impl.Context = function(contextView,autoStartup) {
	if(autoStartup == null) autoStartup = true;
	this.autoStartup = autoStartup;
	this.set_contextView(contextView);
};
$hxClasses["mmvc.impl.Context"] = mmvc.impl.Context;
mmvc.impl.Context.__name__ = ["mmvc","impl","Context"];
mmvc.impl.Context.__interfaces__ = [mmvc.api.IContext];
mmvc.impl.Context.prototype = {
	autoStartup: null
	,contextView: null
	,commandMap: null
	,injector: null
	,mediatorMap: null
	,reflector: null
	,viewMap: null
	,startup: function() {
	}
	,shutdown: function() {
	}
	,set_contextView: function(value) {
		if(this.contextView != value) {
			this.contextView = value;
			this.commandMap = null;
			this.mediatorMap = null;
			this.viewMap = null;
			this.mapInjections();
			this.checkAutoStartup();
		}
		return value;
	}
	,get_injector: function() {
		if(this.injector == null) return this.createInjector();
		return this.injector;
	}
	,get_reflector: function() {
		if(this.reflector == null) this.reflector = new minject.Reflector();
		return this.reflector;
	}
	,get_commandMap: function() {
		if(this.commandMap == null) this.commandMap = new mmvc.base.CommandMap(this.createChildInjector());
		return this.commandMap;
	}
	,get_mediatorMap: function() {
		if(this.mediatorMap == null) this.mediatorMap = new mmvc.base.MediatorMap(this.contextView,this.createChildInjector(),this.get_reflector());
		return this.mediatorMap;
	}
	,get_viewMap: function() {
		if(this.viewMap == null) this.viewMap = new mmvc.base.ViewMap(this.contextView,this.get_injector());
		return this.viewMap;
	}
	,mapInjections: function() {
		this.get_injector().mapValue(minject.Reflector,this.get_reflector());
		this.get_injector().mapValue(minject.Injector,this.get_injector());
		this.get_injector().mapValue(mmvc.api.IViewContainer,this.contextView);
		this.get_injector().mapValue(mmvc.api.ICommandMap,this.get_commandMap());
		this.get_injector().mapValue(mmvc.api.IMediatorMap,this.get_mediatorMap());
		this.get_injector().mapValue(mmvc.api.IViewMap,this.get_viewMap());
	}
	,checkAutoStartup: function() {
		if(this.autoStartup && this.contextView != null) this.startup();
	}
	,createInjector: function() {
		this.injector = new minject.Injector();
		return this.get_injector();
	}
	,createChildInjector: function() {
		return this.get_injector().createChildInjector();
	}
	,__class__: mmvc.impl.Context
	,__properties__: {get_viewMap:"get_viewMap",get_reflector:"get_reflector",get_mediatorMap:"get_mediatorMap",get_injector:"get_injector",get_commandMap:"get_commandMap",set_contextView:"set_contextView"}
};
var flickrapp = {};
flickrapp.app = {};
flickrapp.app.ApplicationContext = function(contextView) {
	mmvc.impl.Context.call(this,contextView);
};
$hxClasses["flickrapp.app.ApplicationContext"] = flickrapp.app.ApplicationContext;
flickrapp.app.ApplicationContext.__name__ = ["flickrapp","app","ApplicationContext"];
flickrapp.app.ApplicationContext.__super__ = mmvc.impl.Context;
flickrapp.app.ApplicationContext.prototype = $extend(mmvc.impl.Context.prototype,{
	startup: function() {
		this.get_mediatorMap().mapView(flickrapp.flickr.view.GalleryZoomView,flickrapp.flickr.view.GalleryZoomViewMediator);
		this.get_mediatorMap().mapView(flickrapp.flickr.view.SearchBoxView,flickrapp.flickr.view.SearchBoxViewMediator);
		this.get_mediatorMap().mapView(flickrapp.flickr.view.GalleryView,flickrapp.flickr.view.GalleryViewMediator);
		this.get_mediatorMap().mapView(flickrapp.flickr.view.GalleryItemView,flickrapp.flickr.view.GalleryItemViewMediator);
		this.get_commandMap().mapSignalClass(flickrapp.flickr.signal.LoadFlickrData,flickrapp.flickr.command.LoadFlickrDataCommand);
		this.get_injector().mapSingleton(flickrapp.flickr.api.FlickrAPI);
		this.get_injector().mapSingleton(flickrapp.flickr.model.GalleryModel);
		this.get_injector().mapSingleton(flickrapp.flickr.model.GalleryItemModel);
	}
	,shutdown: function() {
	}
	,__class__: flickrapp.app.ApplicationContext
});
var mui = {};
mui.core = {};
mui.core.Changeable = function() { };
$hxClasses["mui.core.Changeable"] = mui.core.Changeable;
mui.core.Changeable.__name__ = ["mui","core","Changeable"];
mui.core.Changeable.prototype = {
	changed: null
	,validate: null
	,__class__: mui.core.Changeable
};
mui.core.Validator = function() {
	this.valid = true;
	this.stack = [];
};
$hxClasses["mui.core.Validator"] = mui.core.Validator;
mui.core.Validator.__name__ = ["mui","core","Validator"];
mui.core.Validator.prototype = {
	valid: null
	,stack: null
	,invalidate: function(node) {
		this.stack.push(node);
		if(this.valid) {
			this.delayValidation();
			this.valid = false;
		}
	}
	,validate: function() {
		while(this.stack.length > 0) {
			var node = this.stack.shift();
			node.validate();
		}
		this.valid = true;
	}
	,delayValidation: function() {
		mui.Lib.frameRendered.addOnce($bind(this,this.validate));
	}
	,__class__: mui.core.Validator
};
mui.core.Node = function() {
	this.valid = true;
	this.initialValues = { };
	this.previousValues = { };
	this.changed = new msignal.Signal1(Dynamic);
};
$hxClasses["mui.core.Node"] = mui.core.Node;
mui.core.Node.__name__ = ["mui","core","Node"];
mui.core.Node.__interfaces__ = [mui.core.Changeable];
mui.core.Node.prototype = {
	changed: null
	,valid: null
	,initialValues: null
	,previousValues: null
	,getInitialValue: function(property) {
		return Reflect.field(this.initialValues,property);
	}
	,getPreviousValue: function(property) {
		return Reflect.field(this.previousValues,property);
	}
	,getChangedValues: function() {
		var changed = { };
		var _g = 0;
		var _g1 = Reflect.fields(this.initialValues);
		while(_g < _g1.length) {
			var property = _g1[_g];
			++_g;
			if(Reflect.field(this,property) != Reflect.field(this.initialValues,property)) changed[property] = true;
		}
		return changed;
	}
	,validate: function() {
		if(this.valid) return;
		this.valid = true;
		var flag = { };
		var hasChanged = false;
		var previousCopy = this.previousValues;
		this.previousValues = { };
		var _g = 0;
		var _g1 = Reflect.fields(previousCopy);
		while(_g < _g1.length) {
			var property = _g1[_g];
			++_g;
			var previousValue = Reflect.field(previousCopy,property);
			var currentValue = Reflect.field(this,property);
			if(currentValue != previousValue) {
				hasChanged = true;
				flag[property] = true;
			}
		}
		if(hasChanged) this.change(flag);
	}
	,changeValue: function(property,value) {
		if(!Object.prototype.hasOwnProperty.call(this.initialValues,property)) {
			this.initialValues[property] = value;
			return value;
		}
		var previousValue = Reflect.field(this,property);
		if(value == previousValue) return value;
		if(!Object.prototype.hasOwnProperty.call(this.previousValues,property)) this.previousValues[property] = previousValue;
		this.invalidate();
		return value;
	}
	,invalidateProperty: function(property) {
		this.previousValues[property] = { };
		this.invalidate();
	}
	,invalidate: function() {
		if(!this.valid) return;
		this.valid = false;
		mui.core.Node.validator.invalidate(this);
	}
	,change: function(flag) {
		this.changed.dispatch(flag);
	}
	,toString: function() {
		return Type.getClassName(Type.getClass(this));
	}
	,__class__: mui.core.Node
};
mui.display = {};
mui.display.Display = function() {
	mui.core.Node.call(this);
	this.keyPressed = new msignal.Signal1(mui.event.Key);
	this.keyReleased = new msignal.Signal1(mui.event.Key);
	this.touchStarted = new msignal.Signal1(mui.event.Touch);
	this.touchEnded = new msignal.Signal1(mui.event.Touch);
	this.mouseX = 0;
	this.mouseY = 0;
	this.numChildren = 0;
	this.children = [];
	this.set_enabled(true);
	this.parent = null;
	this.index = -1;
	this.set_visible(true);
	this.set_alpha(1);
	this.set_useHandCursor(false);
	this.set_x(0);
	this.set_y(0);
	this.set_scaleX(1);
	this.set_scaleY(1);
	this.set_width(0);
	this.set_height(0);
	this.set_contentWidth(0);
	this.set_contentHeight(0);
	this.set_clip(false);
	this.set_scrollX(0);
	this.set_scrollY(0);
	this.set_left(null);
	this.set_right(null);
	this.set_top(null);
	this.set_bottom(null);
	this.set_centerX(null);
	this.set_centerY(null);
	this.set_resizeX(false);
	this.set_resizeY(false);
	this.set_childOffset(0);
	this._new();
	null;
};
$hxClasses["mui.display.Display"] = mui.display.Display;
mui.display.Display.__name__ = ["mui","display","Display"];
mui.display.Display.__super__ = mui.core.Node;
mui.display.Display.prototype = $extend(mui.core.Node.prototype,{
	enabled: null
	,visible: null
	,clip: null
	,useHandCursor: null
	,alpha: null
	,x: null
	,y: null
	,width: null
	,height: null
	,scaleX: null
	,scaleY: null
	,scrollX: null
	,set_scrollX: function(value) {
		return this.scrollX = this.changeValue("scrollX",value);
	}
	,scrollY: null
	,set_scrollY: function(value) {
		return this.scrollY = this.changeValue("scrollY",value);
	}
	,resizeX: null
	,resizeY: null
	,centerX: null
	,centerY: null
	,all: null
	,left: null
	,right: null
	,top: null
	,bottom: null
	,childOffset: null
	,debugClassName: null
	,getDebugString: function() {
		if(this.debugClassName == null) {
			var type = Type.getClass(this);
			var name = Type.getClassName(type);
			name = name.split(".").pop();
			this.debugClassName = name.split("_")[0];
		}
		return this.debugClassName;
	}
	,iterator: function() {
		return HxOverrides.iter(this.children);
	}
	,keyPressed: null
	,keyReleased: null
	,keyPress: function(key) {
		if(!this.enabled) return;
		this.keyPressed.dispatch(key);
		if(this.parent == null) return;
		if(key.isCaptured) return;
		this.parent.keyPress(key);
	}
	,keyRelease: function(key) {
		if(!this.enabled) return;
		this.keyReleased.dispatch(key);
		if(this.parent == null) return;
		if(key.isCaptured) return;
		this.parent.keyRelease(key);
	}
	,touchStarted: null
	,touchEnded: null
	,touchStart: function(touch) {
		if(!this.enabled) return;
		this.touchStarted.dispatch(touch);
		if(this.parent == null) return;
		if(touch.isCaptured) return;
		this.parent.touchStart(touch);
	}
	,touchEnd: function(touch) {
		if(!this.enabled) return;
		this.touchEnded.dispatch(touch);
		if(this.parent == null) return;
		if(touch.isCaptured) return;
		this.parent.touchEnd(touch);
	}
	,getDisplayUnder: function(x,y) {
		if(x < 0 || x > this.get_width()) return null;
		if(y < 0 || y > this.get_height()) return null;
		if(!this.visible || !this.enabled) return null;
		if(this.children.length == 0) return js.Boot.__cast(this , mui.display.Display);
		var localX = x + this.get_scrollX();
		var localY = y + this.get_scrollY();
		var i = this.children.length;
		while(i > 0) {
			i -= 1;
			var display = this.children[i];
			var descendant = display.getDisplayUnder(localX - display.x,localY - display.y);
			if(descendant != null) return descendant;
		}
		return js.Boot.__cast(this , mui.display.Display);
	}
	,mouseX: null
	,mouseY: null
	,get_mouseX: function() {
		if(this.parent == null) return this.mouseX;
		return this.parent.get_mouseX() + this.parent.get_scrollX() - this.x;
	}
	,get_mouseY: function() {
		if(this.parent == null) return this.mouseY;
		return this.parent.get_mouseY() + this.parent.get_scrollY() - this.y;
	}
	,containsDisplay: function(d) {
		var p = d;
		while(p != null) {
			if(p == this) return true;
			p = p.parent;
		}
		return false;
	}
	,children: null
	,parent: null
	,index: null
	,rootX: null
	,get_rootX: function() {
		if(this.parent == null) return 0;
		return this.parent.get_rootX() - this.parent.get_scrollX() + this.x;
	}
	,rootY: null
	,get_rootY: function() {
		if(this.parent == null) return 0;
		return this.parent.get_rootY() - this.parent.get_scrollY() + this.y;
	}
	,contentWidth: null
	,set_contentWidth: function(value) {
		if(this.resizeX) this.set_width(value);
		return this.contentWidth = this.changeValue("contentWidth",value);
	}
	,contentHeight: null
	,set_contentHeight: function(value) {
		if(this.resizeY) this.set_height(value);
		return this.contentHeight = this.changeValue("contentHeight",value);
	}
	,maxScrollX: null
	,get_maxScrollX: function() {
		return Math.round(Math.max(0,this.contentWidth - this.get_width()));
	}
	,maxScrollY: null
	,get_maxScrollY: function() {
		return Math.round(Math.max(0,this.contentHeight - this.get_height()));
	}
	,layout: null
	,set_layout: function(value) {
		if(this.layout != null) this.layout.set_target(null);
		this.layout = this.changeValue("layout",value);
		if(this.layout != null) this.layout.set_target(js.Boot.__cast(this , mui.display.Display));
		return value;
	}
	,numChildren: null
	,addChild: function(child) {
		this.addChildAt(child,this.numChildren);
	}
	,isDescendantOf: function(display) {
		var p = this.parent;
		while(p != null) {
			if(p == display) return true;
			p = p.parent;
		}
		return false;
	}
	,addChildAt: function(child,index) {
		if(!(child != null)) throw "Assertion failed: " + "argument `child` cannot be `null`";
		if(!(child != this)) throw "Assertion failed: " + "argument `child` cannot be be equal to `this`";
		mui.util.Assert.that(!this.isDescendantOf(child),"argument `child` cannot be a parent hierarchy of `this`");
		if(!(index >= 0 && index <= this.numChildren)) throw "Assertion failed: " + "argument `index` is out of bounds";
		if(child.parent != null) child.parent.removeChild(child);
		this.children.splice(index,0,child);
		this.numChildren += 1;
		this._addChildAt(child,index);
		child.parent_addToParentAt(this,index);
		var _g1 = ++index;
		var _g = this.numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var next = this.children[i];
			next.parent_changeIndex(i);
		}
		this.invalidateProperty("children");
		child.addedToStage();
	}
	,removeChild: function(child) {
		var childIndex = this.getChildIndex(child);
		this.removeChildAt(childIndex);
	}
	,removeChildAt: function(index) {
		var child = this.getChildAt(index);
		child.removedFromStage();
		HxOverrides.remove(this.children,child);
		this.numChildren -= 1;
		child.parent_removeFromParent();
		this._removeChildAt(child,index);
		var _g1 = index;
		var _g = this.numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			var next = this.children[i];
			next.parent_changeIndex(i);
		}
		this.invalidateProperty("children");
	}
	,releaseChildAt: function(index) {
		return true;
	}
	,getChildIndex: function(child) {
		if(!(child != null)) throw "Assertion failed: " + "argument `child` cannot be `null`";
		if(!(child.parent == this)) throw "Assertion failed: " + "argument `child` must be a child of `this`";
		var _g1 = 0;
		var _g = this.numChildren;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.children[i] == child) return i;
		}
		throw "Assertion failed: " + "argument `child` is child of `this`, but is not in children!";
		return -1;
	}
	,getChildAt: function(index) {
		if(!(index >= 0 && index < this.numChildren)) throw "Assertion failed: " + ("argument `index` is out of bounds (0 <= " + index + " < " + this.numChildren + ")");
		return this.children[index];
	}
	,parent_addToParentAt: function(parent,index) {
		this.parent = this.changeValue("parent",parent);
		this.index = this.changeValue("index",index);
		parent.changed.add($bind(this,this.parentChange));
	}
	,parent_removeFromParent: function() {
		this.parent.changed.remove($bind(this,this.parentChange));
		this.parent = this.changeValue("parent",null);
		this.index = this.changeValue("index",-1);
	}
	,parent_changeIndex: function(index) {
		this.index = this.changeValue("index",index);
	}
	,addedToStage: function() {
		var _g = 0;
		var _g1 = this.children;
		while(_g < _g1.length) {
			var child = _g1[_g];
			++_g;
			child.addedToStage();
		}
	}
	,removedFromStage: function() {
		var _g = 0;
		var _g1 = this.children;
		while(_g < _g1.length) {
			var child = _g1[_g];
			++_g;
			child.removedFromStage();
		}
	}
	,destroy: function() {
		var _g = 0;
		var _g1 = this.children;
		while(_g < _g1.length) {
			var child = _g1[_g];
			++_g;
			child.destroy();
		}
	}
	,change: function(flag) {
		mui.core.Node.prototype.change.call(this,flag);
		if(this.parent != null && (flag.parent || flag.width || flag.height || flag.left || flag.right || flag.top || flag.bottom || flag.centerX || flag.centerY)) this.constrain(this.parent);
		if(this.parent != null && (flag.width || flag.height)) this.parent.childResized(this);
		this._change(flag);
	}
	,childResized: function(child) {
		if(this.layout != null && this.layout.enabled && child.parent == this.layout.target) this.layout.resizeDisplay(child.index);
	}
	,parentChange: function(flag) {
		if(flag.childOffset) {
			this.invalidateProperty("x");
			this.invalidateProperty("y");
		}
		if(flag.width || flag.height) this.invalidateProperty("parent");
	}
	,constrain: function(target) {
		if(target == null) return;
		if(this.centerX == null) {
			if(this.left == null) {
				if(this.right != null) this.set_x(target.get_width() - (this.get_width() + this.right));
			} else {
				this.set_x(this.left);
				if(this.right != null) this.set_width(target.get_width() - (this.left + this.right));
			}
		} else this.set_x(Math.round((target.get_width() - this.get_width()) * this.centerX));
		if(this.centerY == null) {
			if(this.top == null) {
				if(this.bottom != null) this.set_y(target.get_height() - (this.get_height() + this.bottom));
			} else {
				this.set_y(this.top);
				if(this.bottom != null) this.set_height(target.get_height() - (this.top + this.bottom));
			}
		} else this.set_y(Math.round((target.get_height() - this.get_height()) * this.centerY));
	}
	,element: null
	,scrollElement: null
	,_new: function() {
		this.element = this.scrollElement = this.createDisplay();
		this.element.className = "view";
		this.element.setAttribute("rel",this.getDebugString());
	}
	,createDisplay: function() {
		return window.document.createElement("div");
	}
	,_addChildAt: function(child,index) {
		if(this.scrollElement.childNodes[index] != null) this.scrollElement.insertBefore(child.element,this.scrollElement.childNodes[index]); else this.scrollElement.appendChild(child.element);
	}
	,_removeChildAt: function(child,index) {
		this.scrollElement.removeChild(child.element);
	}
	,_change: function(flag) {
		if(flag.visible) if(this.visible) this.element.style.visibility = ""; else this.element.style.visibility = "hidden";
		if(flag.alpha) this.setStyle("opacity",Std.string(this.alpha));
		if(flag.x) {
			var offset;
			if(this.parent == null) offset = 0; else offset = this.parent.childOffset;
			this.element.style.left = Std.string(this.x + offset) + "px";
		}
		if(flag.y) {
			var offset1;
			if(this.parent == null) offset1 = 0; else offset1 = this.parent.childOffset;
			this.element.style.top = Std.string(this.y + offset1) + "px";
		}
		if(flag.scaleX || flag.scaleY) {
			this.setStyle(JS.prefix == ""?"transformOrigin":JS.prefix + "transformOrigin".charAt(0).toUpperCase() + HxOverrides.substr("transformOrigin",1,null),"top left");
			this.setStyle(JS.prefix == ""?"transform":JS.prefix + "transform".charAt(0).toUpperCase() + HxOverrides.substr("transform",1,null),"scale(" + this.scaleX + "," + this.scaleY + ")");
		}
		if(flag.clip) {
			if(this.clip) {
				this.element.style.overflow = "hidden";
				this.scrollElement = window.document.createElement("div");
				while(this.element.hasChildNodes()) this.scrollElement.appendChild(this.element.removeChild(this.element.firstChild));
				this.element.appendChild(this.scrollElement);
			} else {
				this.element.style.overflow = null;
				this.element.removeChild(this.scrollElement);
				while(this.scrollElement.hasChildNodes()) this.element.appendChild(this.scrollElement.removeChild(this.scrollElement.firstChild));
				this.scrollElement = this.element;
			}
		}
		if(flag.width) this.element.style.width = this.get_width() + "px";
		if(flag.height) this.element.style.height = this.get_height() + "px";
		if(flag.scrollX || flag.scrollY) this.scrollElement.style[JS.prefix == ""?"transform":JS.prefix + "transform".charAt(0).toUpperCase() + HxOverrides.substr("transform",1,null)] = "translate(" + -this.get_scrollX() + "px," + -this.get_scrollY() + "px)";
		if(flag.useHandCursor) if(this.useHandCursor) this.element.style.cursor = "pointer"; else this.element.style.cursor = null;
	}
	,get_scrollX: function() {
		return this.element.scrollLeft + this.scrollX;
	}
	,get_scrollY: function() {
		return this.element.scrollTop + this.scrollY;
	}
	,setStyle: function(property,value) {
		this.element.style[property] = value;
	}
	,bringToFront: function() {
		if(this.parent == null) return;
		this.element.parentNode.appendChild(this.element);
	}
	,set_enabled: function(v) {
		return this.enabled = this.changeValue("enabled",v);
	}
	,set_visible: function(v) {
		return this.visible = this.changeValue("visible",v);
	}
	,set_clip: function(v) {
		return this.clip = this.changeValue("clip",v);
	}
	,set_useHandCursor: function(v) {
		return this.useHandCursor = this.changeValue("useHandCursor",v);
	}
	,set_alpha: function(v) {
		return this.alpha = this.changeValue("alpha",v);
	}
	,set_x: function(v) {
		return this.x = this.changeValue("x",v);
	}
	,set_y: function(v) {
		return this.y = this.changeValue("y",v);
	}
	,set_width: function(v) {
		return this.width = this.changeValue("width",v);
	}
	,get_width: function() {
		return this.width;
	}
	,set_height: function(v) {
		return this.height = this.changeValue("height",v);
	}
	,get_height: function() {
		return this.height;
	}
	,set_scaleX: function(v) {
		return this.scaleX = this.changeValue("scaleX",v);
	}
	,set_scaleY: function(v) {
		return this.scaleY = this.changeValue("scaleY",v);
	}
	,set_resizeX: function(v) {
		return this.resizeX = this.changeValue("resizeX",v);
	}
	,set_resizeY: function(v) {
		return this.resizeY = this.changeValue("resizeY",v);
	}
	,set_centerX: function(v) {
		return this.centerX = this.changeValue("centerX",v);
	}
	,set_centerY: function(v) {
		return this.centerY = this.changeValue("centerY",v);
	}
	,set_all: function(v) {
		return this.set_bottom(this.set_top(this.set_right(this.set_left(this.all = v))));
	}
	,set_left: function(v) {
		return this.left = this.changeValue("left",v);
	}
	,set_right: function(v) {
		return this.right = this.changeValue("right",v);
	}
	,set_top: function(v) {
		return this.top = this.changeValue("top",v);
	}
	,set_bottom: function(v) {
		return this.bottom = this.changeValue("bottom",v);
	}
	,set_childOffset: function(v) {
		return this.childOffset = this.changeValue("childOffset",v);
	}
	,__class__: mui.display.Display
	,__properties__: {set_layout:"set_layout",get_maxScrollY:"get_maxScrollY",get_maxScrollX:"get_maxScrollX",set_contentHeight:"set_contentHeight",set_contentWidth:"set_contentWidth",get_rootY:"get_rootY",get_rootX:"get_rootX",get_mouseY:"get_mouseY",get_mouseX:"get_mouseX",set_childOffset:"set_childOffset",set_bottom:"set_bottom",set_top:"set_top",set_right:"set_right",set_left:"set_left",set_all:"set_all",set_centerY:"set_centerY",set_centerX:"set_centerX",set_resizeY:"set_resizeY",set_resizeX:"set_resizeX",set_scrollY:"set_scrollY",get_scrollY:"get_scrollY",set_scrollX:"set_scrollX",get_scrollX:"get_scrollX",set_scaleY:"set_scaleY",set_scaleX:"set_scaleX",set_height:"set_height",get_height:"get_height",set_width:"set_width",get_width:"get_width",set_y:"set_y",set_x:"set_x",set_alpha:"set_alpha",set_useHandCursor:"set_useHandCursor",set_clip:"set_clip",set_visible:"set_visible",set_enabled:"set_enabled"}
});
mui.display.Rectangle = function() {
	mui.display.Display.call(this);
	this.isRounded = false;
	this.isComplex = false;
	this.set_fill(null);
	this.set_stroke(null);
	this.set_strokeThickness(0.0);
	this.set_radius(0);
	null;
};
$hxClasses["mui.display.Rectangle"] = mui.display.Rectangle;
mui.display.Rectangle.__name__ = ["mui","display","Rectangle"];
mui.display.Rectangle.__super__ = mui.display.Display;
mui.display.Rectangle.prototype = $extend(mui.display.Display.prototype,{
	isRounded: null
	,isComplex: null
	,fill: null
	,set_fill: function(value) {
		if(this.fill != null) this.fill.changed.remove($bind(this,this.fillChange));
		this.fill = this.changeValue("fill",value);
		if(this.fill != null) this.fill.changed.add($bind(this,this.fillChange));
		return this.fill;
	}
	,stroke: null
	,set_stroke: function(value) {
		if(this.stroke != null) this.stroke.changed.remove($bind(this,this.strokeChange));
		this.stroke = this.changeValue("stroke",value);
		if(this.stroke != null) this.stroke.changed.add($bind(this,this.strokeChange));
		return this.stroke;
	}
	,strokeThickness: null
	,set_strokeThickness: function(value) {
		value = Math.max(0,value);
		this.set_childOffset(-(value | 0));
		return this.strokeThickness = this.changeValue("strokeThickness",value);
	}
	,radius: null
	,radiusTopLeft: null
	,radiusTopRight: null
	,radiusBottomLeft: null
	,radiusBottomRight: null
	,fillChange: function(flag) {
		this.invalidateProperty("fill");
	}
	,strokeChange: function(flag) {
		this.invalidateProperty("stroke");
	}
	,change: function(flag) {
		mui.display.Display.prototype.change.call(this,flag);
		if(flag.radiusTopLeft || flag.radiusTopRight || flag.radiusBottomLeft || flag.radiusBottomRight) {
			flag.radius = true;
			this.isRounded = flag.radiusTopLeft > 0 || flag.radiusTopRight > 0 || flag.radiusBottomLeft > 0 || flag.radiusBottomRight > 0;
			this.isComplex = !(this.radiusTopLeft == this.radiusTopRight && this.radiusTopLeft == this.radiusBottomLeft && this.radiusBottomLeft == this.radiusBottomRight);
		}
		this.draw(flag);
	}
	,draw: function(flag) {
		var minSize = Math.min(this.get_width(),this.get_height());
		var strokeThickness = Math.min(this.strokeThickness,minSize * 0.5);
		var strokeThickness2 = strokeThickness * 2;
		var radius = Math.min(this.radiusTopLeft,minSize * 0.5);
		var radius2 = radius * 2;
		var fillRadius2 = Math.max(0,(radius - strokeThickness) * 2);
		if(flag.width || flag.height || flag.strokeThickness) {
			if(!(Math.isNaN(this.get_width()) || Math.isNaN(this.get_height()) || Math.isNaN(strokeThickness))) {
				if(this.get_width() >= 0) this.element.style.width = Std.string(this.get_width() - strokeThickness2) + "px"; else this.element.style.width = null;
				if(this.get_height() >= 0) this.element.style.height = Std.string(this.get_height() - strokeThickness2) + "px"; else this.element.style.height = null;
			}
		}
		if(flag.stroke || flag.strokeThickness) {
			if(strokeThickness > 0) {
				this.setStyle("borderStyle","solid");
				this.setStyle("borderWidth",strokeThickness + "px");
				if(this.stroke != null) this.stroke.applyStroke(this); else this.setStyle("borderColor","transparent");
			} else {
				this.setStyle("borderStyle",null);
				this.setStyle("borderWidth",null);
			}
		}
		if(flag.fill || flag.strokeThickness) {
			if(this.fill != null) this.fill.applyFill(this); else this.setStyle("background",null);
		}
		if(flag.radius || flag.width || flag.height) {
			if(this.isRounded) {
				if(this.isComplex) {
					var sl = Math.min(1,(this.get_height() - strokeThickness) / (this.radiusTopLeft + this.radiusBottomLeft));
					var sr = Math.min(1,(this.get_height() - strokeThickness) / (this.radiusTopRight + this.radiusBottomRight));
					var st = Math.min(1,(this.get_width() - strokeThickness) / (this.radiusTopLeft + this.radiusTopRight));
					var sb = Math.min(1,(this.get_width() - strokeThickness) / (this.radiusBottomLeft + this.radiusBottomRight));
					var tl = Math.floor(this.radiusTopLeft * Math.min(st,sl));
					var tr = Math.floor(this.radiusTopRight * Math.min(st,sr));
					var bl = Math.floor(this.radiusBottomLeft * Math.min(sb,sl));
					var br = Math.floor(this.radiusBottomRight * Math.min(sb,sr));
					var stl;
					if(tl > 0) stl = tl + "px"; else stl = null;
					var str;
					if(tr > 0) str = tr + "px"; else str = null;
					var sbl;
					if(bl > 0) sbl = bl + "px"; else sbl = null;
					var sbr;
					if(br > 0) sbr = br + "px"; else sbr = null;
					this.setStyle("borderTopLeftRadius",stl);
					this.setStyle("borderTopRightRadius",str);
					this.setStyle("borderBottomLeftRadius",sbl);
					this.setStyle("borderBottomRightRadius",sbr);
				} else this.setStyle("borderRadius",radius + "px");
			} else this.setStyle("borderRadius",null);
		}
	}
	,set_radius: function(v) {
		return this.set_radiusBottomRight(this.set_radiusBottomLeft(this.set_radiusTopRight(this.set_radiusTopLeft(this.radius = v))));
	}
	,set_radiusTopLeft: function(v) {
		return this.radiusTopLeft = this.changeValue("radiusTopLeft",v);
	}
	,set_radiusTopRight: function(v) {
		return this.radiusTopRight = this.changeValue("radiusTopRight",v);
	}
	,set_radiusBottomLeft: function(v) {
		return this.radiusBottomLeft = this.changeValue("radiusBottomLeft",v);
	}
	,set_radiusBottomRight: function(v) {
		return this.radiusBottomRight = this.changeValue("radiusBottomRight",v);
	}
	,__class__: mui.display.Rectangle
	,__properties__: $extend(mui.display.Display.prototype.__properties__,{set_radiusBottomRight:"set_radiusBottomRight",set_radiusBottomLeft:"set_radiusBottomLeft",set_radiusTopRight:"set_radiusTopRight",set_radiusTopLeft:"set_radiusTopLeft",set_radius:"set_radius",set_strokeThickness:"set_strokeThickness",set_stroke:"set_stroke",set_fill:"set_fill"})
});
mui.display.AssetLibrary = function() {
	this.assetByURI = new haxe.ds.StringMap();
	this.basePath = "asset/";
	if(mui.util.Param.get_isAvailable()) {
		var baseUrl = mui.util.Param.get("baseUrl");
		if(baseUrl != null) this.basePath = baseUrl + this.basePath;
		var variant = mui.util.Param.get("variant");
		if(variant != null) this.basePath += variant + "/";
	}
};
$hxClasses["mui.display.AssetLibrary"] = mui.display.AssetLibrary;
mui.display.AssetLibrary.__name__ = ["mui","display","AssetLibrary"];
mui.display.AssetLibrary.prototype = {
	subPath: null
	,assetByURI: null
	,basePath: null
	,load: function(library) {
		var loader = new mui.display.AssetLibraryLoader(this.resolveURI(library + ".xml"),this);
		loader.load();
		return loader;
	}
	,getAsset: function(uri) {
		if(this.assetByURI.exists(uri)) return this.assetByURI.get(uri);
		return null;
	}
	,set: function(uri,asset) {
		this.assetByURI.set(uri,asset);
	}
	,resolveURI: function(uri) {
		return this.basePath + (this.subPath == null || this.subPath == ""?"":this.subPath + "/") + uri;
	}
	,__class__: mui.display.AssetLibrary
};
var haxe = {};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe.ds.StringMap;
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,__class__: haxe.ds.StringMap
};
mui.util = {};
mui.util.Param = function() { };
$hxClasses["mui.util.Param"] = mui.util.Param;
mui.util.Param.__name__ = ["mui","util","Param"];
mui.util.Param.__properties__ = {get_isAvailable:"get_isAvailable"}
mui.util.Param.get_isAvailable = function() {
	if(mui.util.Param.checked) return mui.util.Param.isAvailable;
	mui.util.Param.checked = true;
	var string = haxe.Resource.getString("params");
	mui.util.Param.isAvailable = string != null;
	if(mui.util.Param.isAvailable) mui.util.Param.data = JSON.parse(string);
	return mui.util.Param.data != null;
};
mui.util.Param.get = function(key) {
	if(!mui.util.Param.get_isAvailable()) throw "mtask params not available!";
	if(Object.prototype.hasOwnProperty.call(mui.util.Param.data,key)) return Reflect.field(mui.util.Param.data,key);
	return null;
};
haxe.Resource = function() { };
$hxClasses["haxe.Resource"] = haxe.Resource;
haxe.Resource.__name__ = ["haxe","Resource"];
haxe.Resource.getString = function(name) {
	var _g = 0;
	var _g1 = haxe.Resource.content;
	while(_g < _g1.length) {
		var x = _g1[_g];
		++_g;
		if(x.name == name) {
			if(x.str != null) return x.str;
			var b = haxe.crypto.Base64.decode(x.data);
			return b.toString();
		}
	}
	return null;
};
haxe.io = {};
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
$hxClasses["haxe.io.Bytes"] = haxe.io.Bytes;
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
};
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var i = 0;
	while(i < s.length) {
		var c = StringTools.fastCodeAt(s,i++);
		if(55296 <= c && c <= 56319) c = c - 55232 << 10 | StringTools.fastCodeAt(s,i++) & 1023;
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
};
haxe.io.Bytes.prototype = {
	length: null
	,b: null
	,get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,getString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c21 = b[i++];
				var c3 = b[i++];
				var u = (c & 15) << 18 | (c21 & 127) << 12 | (c3 & 127) << 6 | b[i++] & 127;
				s += fcc((u >> 10) + 55232);
				s += fcc(u & 1023 | 56320);
			}
		}
		return s;
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
	,__class__: haxe.io.Bytes
};
haxe.crypto = {};
haxe.crypto.Base64 = function() { };
$hxClasses["haxe.crypto.Base64"] = haxe.crypto.Base64;
haxe.crypto.Base64.__name__ = ["haxe","crypto","Base64"];
haxe.crypto.Base64.decode = function(str,complement) {
	if(complement == null) complement = true;
	if(complement) while(HxOverrides.cca(str,str.length - 1) == 61) str = HxOverrides.substr(str,0,-1);
	return new haxe.crypto.BaseCode(haxe.crypto.Base64.BYTES).decodeBytes(haxe.io.Bytes.ofString(str));
};
haxe.crypto.BaseCode = function(base) {
	var len = base.length;
	var nbits = 1;
	while(len > 1 << nbits) nbits++;
	if(nbits > 8 || len != 1 << nbits) throw "BaseCode : base length must be a power of two.";
	this.base = base;
	this.nbits = nbits;
};
$hxClasses["haxe.crypto.BaseCode"] = haxe.crypto.BaseCode;
haxe.crypto.BaseCode.__name__ = ["haxe","crypto","BaseCode"];
haxe.crypto.BaseCode.prototype = {
	base: null
	,nbits: null
	,tbl: null
	,initTable: function() {
		var tbl = new Array();
		var _g = 0;
		while(_g < 256) {
			var i = _g++;
			tbl[i] = -1;
		}
		var _g1 = 0;
		var _g2 = this.base.length;
		while(_g1 < _g2) {
			var i1 = _g1++;
			tbl[this.base.b[i1]] = i1;
		}
		this.tbl = tbl;
	}
	,decodeBytes: function(b) {
		var nbits = this.nbits;
		var base = this.base;
		if(this.tbl == null) this.initTable();
		var tbl = this.tbl;
		var size = b.length * nbits >> 3;
		var out = haxe.io.Bytes.alloc(size);
		var buf = 0;
		var curbits = 0;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < 8) {
				curbits += nbits;
				buf <<= nbits;
				var i = tbl[b.get(pin++)];
				if(i == -1) throw "BaseCode : invalid encoded char";
				buf |= i;
			}
			curbits -= 8;
			out.set(pout++,buf >> curbits & 255);
		}
		return out;
	}
	,__class__: haxe.crypto.BaseCode
};
mui.display.AssetDisplay = function(uri,part) {
	mui.display.Rectangle.call(this);
	this.assetFrame = 0;
	this.assetFrames = 0;
	this.assetFrameRate = 1;
	if(uri != null) this.setURI(uri,part);
	null;
};
$hxClasses["mui.display.AssetDisplay"] = mui.display.AssetDisplay;
mui.display.AssetDisplay.__name__ = ["mui","display","AssetDisplay"];
mui.display.AssetDisplay.__super__ = mui.display.Rectangle;
mui.display.AssetDisplay.prototype = $extend(mui.display.Rectangle.prototype,{
	assetFrameRate: null
	,assetURI: null
	,assetPartID: null
	,assetFrame: null
	,assetFrames: null
	,asset: null
	,assetPart: null
	,assetCounter: null
	,setURI: function(uri,part,autoSize) {
		if(autoSize == null) autoSize = true;
		mui.Lib.frameEntered.remove($bind(this,this.nextAssetFrame));
		this.asset = mui.display.AssetDisplay.library.getAsset(uri);
		mui.util.Assert.that(this.asset != null,"asset not found in library: " + mui.display.AssetDisplay.library.resolveURI(uri));
		this.assetURI = uri;
		this.assetPartID = part;
		this.assetCounter = 0;
		if(part != null) {
			this.assetPart = this.asset.getPart(part);
			mui.util.Assert.that(this.assetPart != null,"asset part not found in library: " + mui.display.AssetDisplay.library.resolveURI(uri) + "-" + part);
			this.assetFrames = this.assetPart.frames;
			if(autoSize) {
				this.set_width(this.assetPart.width);
				this.set_height(this.assetPart.height);
			}
			this.resumeAsset();
		} else if(autoSize) {
			this.set_width(this.asset.width);
			this.set_height(this.asset.height);
		}
		this.initAsset();
	}
	,nextAssetFrame: function() {
		if(++this.assetCounter > this.assetFrameRate) {
			if(++this.assetFrame >= this.assetFrames) this.assetFrame = 0;
			this.updateFrame();
			this.assetCounter = 0;
		}
	}
	,pauseAsset: function() {
		if(this.assetFrames > 1) mui.Lib.frameEntered.remove($bind(this,this.nextAssetFrame));
	}
	,resumeAsset: function() {
		if(this.assetFrames > 1) mui.Lib.frameEntered.add($bind(this,this.nextAssetFrame));
	}
	,addedToStage: function() {
		this.resumeAsset();
		mui.display.Rectangle.prototype.addedToStage.call(this);
	}
	,removedFromStage: function() {
		this.pauseAsset();
		mui.display.Rectangle.prototype.removedFromStage.call(this);
	}
	,setPart: function(id) {
		this.assetPartID = id;
		if(this.assetURI != null) {
			this.assetPart = this.asset.getPart(this.assetPartID);
			this.assetFrame = 0;
			this.assetFrames = this.assetPart.frames;
			this.set_width(this.assetPart.width);
			this.set_height(this.assetPart.height);
			this.updateAsset();
		}
	}
	,initAsset: function() {
		this.set_fill(new mui.display.Bitmap(mui.display.AssetDisplay.library.resolveURI(this.assetURI)));
		this.updateAsset();
	}
	,clearAsset: function() {
		this.set_fill(null);
	}
	,updateAsset: function() {
		if(this.assetPart != null) this.setStyle("backgroundPosition","-" + this.assetPart.x + "px -" + this.assetPart.y + "px"); else this.setStyle("backgroundPosition","0px 0px");
	}
	,updateFrame: function() {
		this.setStyle("backgroundPosition","-" + this.get_width() * this.assetFrame + "px -" + this.assetPart.y + "px");
	}
	,__class__: mui.display.AssetDisplay
});
mui.core.DataComponent = function(skin) {
	mui.display.AssetDisplay.call(this);
	this.set_focused(false);
	this.set_selected(false);
	this.set_pressed(false);
	this.set_data(null);
	this.invalidateProperty("focused");
	this.invalidateProperty("selected");
	this.invalidateProperty("enabled");
	this.dispatcher = new mui.util.Dispatcher();
	if(skin != null) this.set_skin(skin);
	null;
};
$hxClasses["mui.core.DataComponent"] = mui.core.DataComponent;
mui.core.DataComponent.__name__ = ["mui","core","DataComponent"];
mui.core.DataComponent.__super__ = mui.display.AssetDisplay;
mui.core.DataComponent.prototype = $extend(mui.display.AssetDisplay.prototype,{
	container: null
	,dispatcher: null
	,action: function() {
	}
	,setAutomationId: function(id) {
	}
	,skin: null
	,set_skin: function(value) {
		if(this.skin != null) this.skin.set_target(null);
		this.skin = value;
		if(this.skin != null) this.skin.set_target(this);
		return this.skin;
	}
	,bubble: function(message) {
		this.bubbleFrom(message,this);
	}
	,bubbleFrom: function(message,target) {
		if(this.dispatcher.dispatch(message,target) == true) return;
		if(this.container == null) return;
		this.container.bubbleFrom(message,target);
	}
	,addedToStage: function() {
		mui.display.AssetDisplay.prototype.addedToStage.call(this);
		this.bubble(mui.core.ComponentEvent.COMPONENT_ADDED);
	}
	,removedFromStage: function() {
		this.bubble(mui.core.ComponentEvent.COMPONENT_REMOVED);
		mui.display.AssetDisplay.prototype.removedFromStage.call(this);
	}
	,focused: null
	,set_focused: function(value) {
		return this.focused = this.changeValue("focused",value);
	}
	,selected: null
	,set_selected: function(value) {
		return this.selected = this.changeValue("selected",value);
	}
	,pressed: null
	,set_pressed: function(value) {
		return this.pressed = this.changeValue("pressed",value);
	}
	,data: null
	,set_data: function(value) {
		if(value != null) this.updateData(value);
		return this.data = this.changeValue("data",value);
	}
	,updateData: function(newData) {
	}
	,focus: function() {
		if(!this.enabled) return;
		mui.event.Focus.set_current(this);
	}
	,focusIn: function(source) {
		this.set_focused(true);
		if(this.container == null) return;
		this.container.focusIn(this);
	}
	,focusOut: function(source) {
		this.set_focused(false);
		if(this.container == null) return;
		this.container.focusOut(this);
	}
	,__class__: mui.core.DataComponent
	,__properties__: $extend(mui.display.AssetDisplay.prototype.__properties__,{set_data:"set_data",set_pressed:"set_pressed",set_selected:"set_selected",set_focused:"set_focused",set_skin:"set_skin"})
});
mui.core.DataContainer = function(skin) {
	mui.core.DataComponent.call(this,skin);
	this.set_margin(0);
	this.components = new mui.core._Container.ContainerContent();
	this.addChild(this.components);
	this.components.changed.add($bind(this,this.componentsChange));
	this.numComponents = 0;
	this.set_selectedIndex(-1);
	this.numChildren = 0;
	this.set_layout(new mui.layout.Layout());
	this.layout.enabled = false;
	this.navigator = new mui.core.Navigator(this);
	this.scroller = new mui.behavior.ScrollBehavior(this.components);
	this.scroller.enabled = false;
	null;
};
$hxClasses["mui.core.DataContainer"] = mui.core.DataContainer;
mui.core.DataContainer.__name__ = ["mui","core","DataContainer"];
mui.core.DataContainer.__super__ = mui.core.DataComponent;
mui.core.DataContainer.prototype = $extend(mui.core.DataComponent.prototype,{
	components: null
	,navigator: null
	,scroller: null
	,addChildInfront: function(display) {
		this.addChild(display);
		this.element.appendChild(display.element);
	}
	,change: function(flag) {
		mui.core.DataComponent.prototype.change.call(this,flag);
		if(flag.selectedIndex) this.bubble(mui.core.ContainerEvent.SELECTION_CHANGED);
	}
	,componentsChange: function(flag) {
		if(flag.contentWidth && this.resizeX) this.set_width(this.components.contentWidth + this.marginLeft + this.marginRight);
		if(flag.contentHeight && this.resizeY) this.set_height(this.components.contentHeight + this.marginTop + this.marginBottom);
	}
	,set_layout: function(value) {
		this.invalidateProperty("layout");
		return this.layout = this.components.set_layout(value);
	}
	,margin: null
	,set_margin: function(value) {
		return this.set_marginLeft(this.set_marginRight(this.set_marginTop(this.set_marginBottom(value))));
	}
	,marginLeft: null
	,set_marginLeft: function(value) {
		this.marginLeft = this.changeValue("marginLeft",value);
		this.resizeComponents();
		return this.marginLeft;
	}
	,marginRight: null
	,set_marginRight: function(value) {
		this.marginRight = this.changeValue("marginRight",value);
		this.resizeComponents();
		return this.marginRight;
	}
	,marginTop: null
	,set_marginTop: function(value) {
		this.marginTop = this.changeValue("marginTop",value);
		this.resizeComponents();
		return this.marginTop;
	}
	,marginBottom: null
	,set_marginBottom: function(value) {
		this.marginBottom = this.changeValue("marginBottom",value);
		this.resizeComponents();
		return this.marginBottom;
	}
	,set_width: function(value) {
		mui.core.DataComponent.prototype.set_width.call(this,value);
		this.resizeComponents();
		return value;
	}
	,set_height: function(value) {
		mui.core.DataComponent.prototype.set_height.call(this,value);
		this.resizeComponents();
		return value;
	}
	,resizeComponents: function() {
		if(this.components == null) return;
		this.components.set_x(this.marginLeft);
		this.components.set_y(this.marginTop);
		this.components.set_width(this.get_width() - (this.marginLeft + this.marginRight));
		this.components.set_height(this.get_height() - (this.marginTop + this.marginBottom));
	}
	,addChildAt: function(child,index) {
		mui.core.DataComponent.prototype.addChildAt.call(this,child,index);
		if(js.Boot.__instanceof(child,mui.core.DataComponent)) haxe.Log.trace("warn",{ fileName : "Container.hx", lineNumber : 206, className : "mui.core.DataContainer", methodName : "addChildAt", customParams : ["Should not add component [",Type.getClassName(Type.getClass(child)),"] as child to [",Type.getClassName(Type.getClass(this)),"] , use addComponent or addComponentAt instead."]});
	}
	,numComponents: null
	,addComponent: function(component) {
		this.addComponentAt(component,this.numComponents);
	}
	,addComponentAt: function(component,index) {
		if(component.container != null) component.container.removeComponent(component);
		this.numComponents += 1;
		component.container = this;
		this.components.addChildAt(component,index);
		if(this.selectedIndex == -1) this.set_selectedComponent(this.navigator.closest(component));
		this.invalidateProperty("components");
	}
	,removeComponent: function(component) {
		this.removeComponentAt(this.getComponentIndex(component));
	}
	,removeComponentAt: function(index) {
		var component = this.getComponentAt(index);
		var _g = this;
		_g.set_selectedIndex(_g.selectedIndex - (index <= this.selectedIndex?1:0));
		component.set_focused(component.set_selected(component.set_pressed(false)));
		this.components.removeChildAt(index);
		this.numComponents -= 1;
		component.container = null;
		if(this.selectedIndex > -1) {
			this.set_selectedComponent(this.navigator.closest(this.get_selectedComponent()));
			this.get_selectedComponent().set_selected(true);
			this.get_selectedComponent().set_focused(this.focused);
		}
		this.invalidateProperty("components");
	}
	,getComponentIndex: function(component) {
		return this.components.getChildIndex(component);
	}
	,getComponentAt: function(index) {
		var component = this.components.getChildAt(index);
		return component;
	}
	,removeComponents: function() {
		this.set_selectedIndex(-1);
		var _g1 = 0;
		var _g = this.numComponents;
		while(_g1 < _g) {
			var i = _g1++;
			this.removeComponentAt(0);
		}
	}
	,getDisplayUnder: function(x,y) {
		if(x < 0 || x > this.get_width()) return null;
		if(y < 0 || y > this.get_height()) return null;
		if(!this.visible || !this.enabled) return null;
		if(this.children.length == 0) return js.Boot.__cast(this , mui.display.Display);
		var localX = x + this.get_scrollX();
		var localY = y + this.get_scrollY();
		var i = this.children.length;
		while(i > 0) {
			i -= 1;
			var display = this.children[i];
			var descendant = display.getDisplayUnder(localX - display.x,localY - display.y);
			if(descendant != null) return descendant;
		}
		return js.Boot.__cast(this , mui.display.Display);
	}
	,selectedIndex: null
	,set_selectedIndex: function(value) {
		if(!(value >= -1 && value < this.numComponents)) throw "Assertion failed: " + ("argument `value` is out of bounds: " + value);
		if(!Object.prototype.hasOwnProperty.call(this.initialValues,"selectedIndex")) return this.selectedIndex = this.changeValue("selectedIndex",value);
		if(value == this.selectedIndex) return this.selectedIndex;
		if(this.get_selectedComponent() != null) this.get_selectedComponent().set_selected(false);
		this.selectedIndex = this.changeValue("selectedIndex",value);
		if(this.get_selectedComponent() != null) {
			this.get_selectedComponent().set_selected(true);
			if(this.layout.enabled) this.layout.layoutDisplay(this.selectedIndex);
		}
		if(this.focused) this.focus();
		return this.selectedIndex;
	}
	,get_selectedComponent: function() {
		if(this.selectedIndex == -1 || Math.isNaN(this.selectedIndex)) return null;
		return this.getComponentAt(this.selectedIndex);
	}
	,set_selectedComponent: function(component) {
		this.set_selectedIndex(component == null?-1:this.getComponentIndex(component));
		return component;
	}
	,get_selectedData: function() {
		if(this.get_selectedComponent() == null) return null;
		return this.get_selectedComponent().data;
	}
	,set_selectedData: function(value) {
		var _g1 = 0;
		var _g = this.numComponents;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.getComponentAt(i).data == value) {
				this.set_selectedIndex(i);
				break;
			}
		}
		return value;
	}
	,focus: function() {
		if(!this.enabled) return;
		if(this.get_selectedComponent() != null && this.get_selectedComponent().enabled) this.get_selectedComponent().focus(); else mui.core.DataComponent.prototype.focus.call(this);
	}
	,focusIn: function(source) {
		mui.core.DataComponent.prototype.focusIn.call(this,source);
		if(source == null) return;
		this.set_selectedIndex(this.getComponentIndex(source));
	}
	,keyPress: function(key) {
		var next = null;
		var selected = this.get_selectedComponent();
		var action = key.get_action();
		if(this.selectedIndex > -1 && action != null) {
			var _g = key.get_action();
			switch(_g[1]) {
			case 3:
				next = this.navigator.next(selected,mui.layout.Direction.up);
				break;
			case 4:
				next = this.navigator.next(selected,mui.layout.Direction.down);
				break;
			case 1:
				next = this.navigator.next(selected,mui.layout.Direction.left);
				break;
			case 2:
				next = this.navigator.next(selected,mui.layout.Direction.right);
				break;
			default:
				next = null;
			}
		}
		if(next != null) {
			key.capture();
			next.focus();
		} else mui.core.DataComponent.prototype.keyPress.call(this,key);
	}
	,__class__: mui.core.DataContainer
	,__properties__: $extend(mui.core.DataComponent.prototype.__properties__,{set_selectedData:"set_selectedData",get_selectedData:"get_selectedData",set_selectedComponent:"set_selectedComponent",get_selectedComponent:"get_selectedComponent",set_selectedIndex:"set_selectedIndex",set_marginBottom:"set_marginBottom",set_marginTop:"set_marginTop",set_marginRight:"set_marginRight",set_marginLeft:"set_marginLeft",set_margin:"set_margin"})
});
mmvc.api.IViewContainer = function() { };
$hxClasses["mmvc.api.IViewContainer"] = mmvc.api.IViewContainer;
mmvc.api.IViewContainer.__name__ = ["mmvc","api","IViewContainer"];
mmvc.api.IViewContainer.prototype = {
	viewAdded: null
	,viewRemoved: null
	,isAdded: null
	,__class__: mmvc.api.IViewContainer
};
mui.container = {};
mui.container.Application = function(skin) {
	mui.core.DataContainer.call(this,skin);
	if(mui.util.Param.get_isAvailable()) {
		this.set_width(mui.util.Param.get("width"));
		this.set_height(mui.util.Param.get("height"));
		if(this.get_width() == 0 || this.get_height() == 0) this.set_all(0);
	} else this.set_all(0);
	this.scroller.enabled = false;
	this.focus();
	this.dispatcher.add($bind(this,this.addView),mui.core.ComponentEvent.COMPONENT_ADDED);
	this.dispatcher.add($bind(this,this.removeView),mui.core.ComponentEvent.COMPONENT_REMOVED);
	null;
};
$hxClasses["mui.container.Application"] = mui.container.Application;
mui.container.Application.__name__ = ["mui","container","Application"];
mui.container.Application.__interfaces__ = [mmvc.api.IViewContainer];
mui.container.Application.__super__ = mui.core.DataContainer;
mui.container.Application.prototype = $extend(mui.core.DataContainer.prototype,{
	viewAdded: null
	,viewRemoved: null
	,addView: function(message,view) {
		if(this.viewAdded != null) this.viewAdded(view);
	}
	,removeView: function(message,view) {
		if(this.viewRemoved != null) this.viewRemoved(view);
	}
	,isAdded: function(view) {
		return true;
	}
	,__class__: mui.container.Application
});
flickrapp.app.ApplicationView = function() {
	mui.container.Application.call(this);
	this.set_all(0);
	this.set_width(1000);
	this.set_height(700);
	this.scroller.enabled = true;
	this.set_left(this.set_right(50));
	this.set_bottom(10);
	this.set_fill(new mui.display.Color(268435455));
	this.layout.enabled = true;
	null;
};
$hxClasses["flickrapp.app.ApplicationView"] = flickrapp.app.ApplicationView;
flickrapp.app.ApplicationView.__name__ = ["flickrapp","app","ApplicationView"];
flickrapp.app.ApplicationView.__super__ = mui.container.Application;
flickrapp.app.ApplicationView.prototype = $extend(mui.container.Application.prototype,{
	searchBoxView: null
	,galleryView: null
	,initialize: function() {
		this.searchBoxView = new flickrapp.flickr.view.SearchBoxView();
		this.galleryView = new flickrapp.flickr.view.GalleryView();
		this.addComponent(this.searchBoxView);
		this.addComponent(this.galleryView);
	}
	,__class__: flickrapp.app.ApplicationView
});
flickrapp.flickr = {};
flickrapp.flickr.api = {};
flickrapp.flickr.api.FlickrAPI = function() {
	this.signal = new msignal.Signal1();
};
$hxClasses["flickrapp.flickr.api.FlickrAPI"] = flickrapp.flickr.api.FlickrAPI;
flickrapp.flickr.api.FlickrAPI.__name__ = ["flickrapp","flickr","api","FlickrAPI"];
flickrapp.flickr.api.FlickrAPI.prototype = {
	signal: null
	,createUrl: function(queryStr,numPerPage) {
		if(numPerPage == null) numPerPage = 30;
		return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + "4111e112a393aefbf0a66241479722cd" + "&tags=" + queryStr + "&format=json&nojsoncallback=1&per_page=" + numPerPage;
	}
	,makeRequest: function(queryStr,numPerPage) {
		if(numPerPage == null) numPerPage = 30;
		haxe.Log.trace("start to call flickr service",{ fileName : "FlickrAPI.hx", lineNumber : 30, className : "flickrapp.flickr.api.FlickrAPI", methodName : "makeRequest"});
		var loader = new mloader.JsonLoader(this.createUrl(queryStr,numPerPage));
		loader.loaded.add($bind(this,this.onLoadedContent));
		loader.load();
	}
	,onLoadedContent: function(event) {
		haxe.Log.trace("the json file has been loaded",{ fileName : "FlickrAPI.hx", lineNumber : 45, className : "flickrapp.flickr.api.FlickrAPI", methodName : "onLoadedContent"});
		this.signal.dispatch(event.target.content);
	}
	,__class__: flickrapp.flickr.api.FlickrAPI
};
mmvc.api.ICommand = function() { };
$hxClasses["mmvc.api.ICommand"] = mmvc.api.ICommand;
mmvc.api.ICommand.__name__ = ["mmvc","api","ICommand"];
mmvc.api.ICommand.prototype = {
	execute: null
	,__class__: mmvc.api.ICommand
};
mmvc.impl.Command = function() {
};
$hxClasses["mmvc.impl.Command"] = mmvc.impl.Command;
mmvc.impl.Command.__name__ = ["mmvc","impl","Command"];
mmvc.impl.Command.__interfaces__ = [mmvc.api.ICommand];
mmvc.impl.Command.prototype = {
	contextView: null
	,commandMap: null
	,injector: null
	,mediatorMap: null
	,signal: null
	,execute: function() {
	}
	,__class__: mmvc.impl.Command
};
flickrapp.flickr.command = {};
flickrapp.flickr.command.LoadFlickrDataCommand = function() {
	mmvc.impl.Command.call(this);
};
$hxClasses["flickrapp.flickr.command.LoadFlickrDataCommand"] = flickrapp.flickr.command.LoadFlickrDataCommand;
flickrapp.flickr.command.LoadFlickrDataCommand.__name__ = ["flickrapp","flickr","command","LoadFlickrDataCommand"];
flickrapp.flickr.command.LoadFlickrDataCommand.__super__ = mmvc.impl.Command;
flickrapp.flickr.command.LoadFlickrDataCommand.prototype = $extend(mmvc.impl.Command.prototype,{
	flickr: null
	,galleryModel: null
	,queryStr: null
	,numPerPage: null
	,execute: function() {
		haxe.Log.trace("execute the loading of flickr images",{ fileName : "LoadFlickrDataCommand.hx", lineNumber : 50, className : "flickrapp.flickr.command.LoadFlickrDataCommand", methodName : "execute"});
		this.flickr.makeRequest(this.queryStr,this.numPerPage);
		this.flickr.signal.addOnce($bind(this,this.completed));
	}
	,completed: function(resp) {
		haxe.Log.trace("search started.",{ fileName : "LoadFlickrDataCommand.hx", lineNumber : 65, className : "flickrapp.flickr.command.LoadFlickrDataCommand", methodName : "completed"});
		if(this.galleryModel.get_length() > 0) this.galleryModel.clear();
		if(Reflect.field(resp,"stat") == "ok") {
			var resultArray = [];
			var photos;
			photos = js.Boot.__cast(Reflect.field(Reflect.field(resp,"photos"),"photo") , Array);
			var _g = 0;
			while(_g < photos.length) {
				var photo = photos[_g];
				++_g;
				var farm = Reflect.field(photo,"farm");
				var server = Reflect.field(photo,"server");
				var id = Reflect.field(photo,"id");
				var secret = Reflect.field(photo,"secret");
				var url = "http://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_n.jpg";
				resultArray.push(new flickrapp.flickr.model.GalleryItemModel(id,url));
			}
			this.galleryModel.addAll(resultArray);
			haxe.Log.trace("search done.",{ fileName : "LoadFlickrDataCommand.hx", lineNumber : 91, className : "flickrapp.flickr.command.LoadFlickrDataCommand", methodName : "completed"});
		}
	}
	,__class__: flickrapp.flickr.command.LoadFlickrDataCommand
});
flickrapp.flickr.model = {};
flickrapp.flickr.model.GalleryItemModel = function(id,url) {
	this.id = id;
	this.url = url;
};
$hxClasses["flickrapp.flickr.model.GalleryItemModel"] = flickrapp.flickr.model.GalleryItemModel;
flickrapp.flickr.model.GalleryItemModel.__name__ = ["flickrapp","flickr","model","GalleryItemModel"];
flickrapp.flickr.model.GalleryItemModel.prototype = {
	id: null
	,url: null
	,__class__: flickrapp.flickr.model.GalleryItemModel
};
var mdata = {};
mdata.Collection = function() { };
$hxClasses["mdata.Collection"] = mdata.Collection;
mdata.Collection.__name__ = ["mdata","Collection"];
mdata.Collection.prototype = {
	changed: null
	,size: null
	,add: null
	,addAll: null
	,clear: null
	,contains: null
	,isEmpty: null
	,iterator: null
	,remove: null
	,removeAll: null
	,toArray: null
	,toString: null
	,__class__: mdata.Collection
};
mdata.List = function() { };
$hxClasses["mdata.List"] = mdata.List;
mdata.List.__name__ = ["mdata","List"];
mdata.List.__interfaces__ = [mdata.Collection];
mdata.List.prototype = {
	first: null
	,last: null
	,length: null
	,insert: null
	,insertAll: null
	,set: null
	,setAll: null
	,get: null
	,indexOf: null
	,lastIndexOf: null
	,removeAt: null
	,removeRange: null
	,__class__: mdata.List
};
mdata.SelectableList = function(list,selectedIndex) {
	if(selectedIndex == null) selectedIndex = 0;
	if(list == null) list = new mdata.ArrayList();
	this.source = list;
	this.source.get_changed().addWithPriority($bind(this,this.source_changed),1000);
	this.selectionChanged = new msignal.Signal1(mdata.SelectableList);
	this.set_selectedIndex(list.get_size() > 0?selectedIndex:-1);
	this.previousSelectedIndex = -1;
};
$hxClasses["mdata.SelectableList"] = mdata.SelectableList;
mdata.SelectableList.__name__ = ["mdata","SelectableList"];
mdata.SelectableList.__interfaces__ = [mdata.List];
mdata.SelectableList.prototype = {
	changed: null
	,get_changed: function() {
		return this.source.get_changed();
	}
	,get_eventsEnabled: function() {
		return this.source.get_eventsEnabled();
	}
	,set_eventsEnabled: function(value) {
		return this.source.set_eventsEnabled(value);
	}
	,size: null
	,get_size: function() {
		return this.source.get_size();
	}
	,first: null
	,get_first: function() {
		return this.source.get_first();
	}
	,last: null
	,get_last: function() {
		return this.source.get_last();
	}
	,length: null
	,get_length: function() {
		return this.source.get_length();
	}
	,selectionChanged: null
	,previousSelectedIndex: null
	,source: null
	,source_changed: function(e) {
		if(this.source.get_size() == 0 && this.selectedIndex != -1) this.previousSelectedIndex = this.set_selectedIndex(-1); else if(this.source.get_size() > 0 && this.selectedIndex == -1) {
			this.previousSelectedIndex = this.selectedIndex;
			this.set_selectedIndex(0);
		}
	}
	,selectedIndex: null
	,set_selectedIndex: function(value) {
		var s = this.source.get_size();
		if(value >= s || s == 0 && value != -1 || s > 0 && value < 0) throw mcore.exception.RangeException.numeric(value,0,this.get_size());
		if(value != this.selectedIndex) {
			this.previousSelectedIndex = this.selectedIndex;
			this.selectedIndex = value;
			if(this.get_eventsEnabled()) this.selectionChanged.dispatch(this);
		}
		return this.selectedIndex;
	}
	,get_selectedItem: function() {
		return this.source.get(this.selectedIndex);
	}
	,set_selectedItem: function(value) {
		if(!this.source.contains(value)) throw new mcore.exception.NotFoundException("Value was not found in List: " + Std.string(value),null,{ fileName : "SelectableList.hx", lineNumber : 169, className : "mdata.SelectableList", methodName : "set_selectedItem"});
		this.set_selectedIndex(this.source.indexOf(value));
		return value;
	}
	,add: function(value) {
		this.source.add(value);
		if(this.selectedIndex == -1) this.set_selectedIndex(0);
	}
	,addAll: function(values) {
		this.source.addAll(values);
		if(this.selectedIndex == -1 && this.source.get_size() > 0) this.set_selectedIndex(0);
	}
	,insert: function(index,value) {
		this.source.insert(index,value);
		if(this.selectedIndex == -1 && this.source.get_size() > 0) this.set_selectedIndex(0);
	}
	,insertAll: function(index,values) {
		this.source.insertAll(index,values);
		if(this.selectedIndex == -1 && this.source.get_size() > 0) this.set_selectedIndex(0);
	}
	,clear: function() {
		this.source.clear();
		this.set_selectedIndex(-1);
	}
	,remove: function(value) {
		var result = this.source.remove(value);
		if(this.selectedIndex >= this.source.get_size()) this.set_selectedIndex(this.source.get_size() - 1);
		return result;
	}
	,removeAt: function(index) {
		var result = this.source.removeAt(index);
		if(this.selectedIndex >= this.get_size()) this.set_selectedIndex(this.get_size() - 1);
		return result;
	}
	,removeRange: function(startIndex,endIndex) {
		var result = this.source.removeRange(startIndex,endIndex);
		if(this.selectedIndex >= this.get_size()) this.set_selectedIndex(this.get_size() - 1);
		return result;
	}
	,removeAll: function(values) {
		var result = this.source.removeAll(values);
		if(this.selectedIndex >= this.get_size()) this.set_selectedIndex(this.get_size() - 1);
		return result;
	}
	,set: function(index,value) {
		return this.source.set(index,value);
	}
	,setAll: function(index,values) {
		return this.source.setAll(index,values);
	}
	,get: function(index) {
		return this.source.get(index);
	}
	,indexOf: function(value) {
		return this.source.indexOf(value);
	}
	,lastIndexOf: function(value) {
		return this.source.lastIndexOf(value);
	}
	,contains: function(value) {
		return this.source.contains(value);
	}
	,isEmpty: function() {
		return this.source.isEmpty();
	}
	,iterator: function() {
		return this.source.iterator();
	}
	,toArray: function() {
		return this.source.toArray();
	}
	,toString: function() {
		return this.source.toString();
	}
	,__class__: mdata.SelectableList
	,__properties__: {set_selectedItem:"set_selectedItem",get_selectedItem:"get_selectedItem",set_selectedIndex:"set_selectedIndex",get_length:"get_length",get_last:"get_last",get_first:"get_first",get_size:"get_size",set_eventsEnabled:"set_eventsEnabled",get_eventsEnabled:"get_eventsEnabled",get_changed:"get_changed"}
};
flickrapp.flickr.model.GalleryModel = function(values) {
	mdata.SelectableList.call(this,values);
};
$hxClasses["flickrapp.flickr.model.GalleryModel"] = flickrapp.flickr.model.GalleryModel;
flickrapp.flickr.model.GalleryModel.__name__ = ["flickrapp","flickr","model","GalleryModel"];
flickrapp.flickr.model.GalleryModel.__super__ = mdata.SelectableList;
flickrapp.flickr.model.GalleryModel.prototype = $extend(mdata.SelectableList.prototype,{
	num: null
	,getAll: function() {
		return this.source;
	}
	,findByImgId: function(id) {
		var $it0 = this.source.iterator();
		while( $it0.hasNext() ) {
			var model = $it0.next();
			if(model.id == id) return model;
		}
		return null;
	}
	,__class__: flickrapp.flickr.model.GalleryModel
});
var msignal = {};
msignal.Signal = function(valueClasses) {
	if(valueClasses == null) valueClasses = [];
	this.valueClasses = valueClasses;
	this.slots = msignal.SlotList.NIL;
	this.priorityBased = false;
};
$hxClasses["msignal.Signal"] = msignal.Signal;
msignal.Signal.__name__ = ["msignal","Signal"];
msignal.Signal.prototype = {
	valueClasses: null
	,numListeners: null
	,slots: null
	,priorityBased: null
	,add: function(listener) {
		return this.registerListener(listener);
	}
	,addOnce: function(listener) {
		return this.registerListener(listener,true);
	}
	,addWithPriority: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.registerListener(listener,false,priority);
	}
	,addOnceWithPriority: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.registerListener(listener,true,priority);
	}
	,remove: function(listener) {
		var slot = this.slots.find(listener);
		if(slot == null) return null;
		this.slots = this.slots.filterNot(listener);
		return slot;
	}
	,removeAll: function() {
		this.slots = msignal.SlotList.NIL;
	}
	,registerListener: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		if(this.registrationPossible(listener,once)) {
			var newSlot = this.createSlot(listener,once,priority);
			if(!this.priorityBased && priority != 0) this.priorityBased = true;
			if(!this.priorityBased && priority == 0) this.slots = this.slots.prepend(newSlot); else this.slots = this.slots.insertWithPriority(newSlot);
			return newSlot;
		}
		return this.slots.find(listener);
	}
	,registrationPossible: function(listener,once) {
		if(!this.slots.nonEmpty) return true;
		var existingSlot = this.slots.find(listener);
		if(existingSlot == null) return true;
		if(existingSlot.once != once) throw "You cannot addOnce() then add() the same listener without removing the relationship first.";
		return false;
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return null;
	}
	,get_numListeners: function() {
		return this.slots.get_length();
	}
	,__class__: msignal.Signal
	,__properties__: {get_numListeners:"get_numListeners"}
};
msignal.Signal2 = function(type1,type2) {
	msignal.Signal.call(this,[type1,type2]);
};
$hxClasses["msignal.Signal2"] = msignal.Signal2;
msignal.Signal2.__name__ = ["msignal","Signal2"];
msignal.Signal2.__super__ = msignal.Signal;
msignal.Signal2.prototype = $extend(msignal.Signal.prototype,{
	dispatch: function(value1,value2) {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(value1,value2);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.Slot2(this,listener,once,priority);
	}
	,__class__: msignal.Signal2
});
flickrapp.flickr.signal = {};
flickrapp.flickr.signal.LoadFlickrData = function() {
	msignal.Signal2.call(this,String,Int);
};
$hxClasses["flickrapp.flickr.signal.LoadFlickrData"] = flickrapp.flickr.signal.LoadFlickrData;
flickrapp.flickr.signal.LoadFlickrData.__name__ = ["flickrapp","flickr","signal","LoadFlickrData"];
flickrapp.flickr.signal.LoadFlickrData.__super__ = msignal.Signal2;
flickrapp.flickr.signal.LoadFlickrData.prototype = $extend(msignal.Signal2.prototype,{
	__class__: flickrapp.flickr.signal.LoadFlickrData
});
mui.control = {};
mui.control.DataButton = function(skin) {
	mui.core.DataComponent.call(this,skin);
	this.set_useHandCursor(true);
	this.focusOnPress = true;
	this.focusOnRelease = false;
	this.actioned = new msignal.Signal0();
	null;
};
$hxClasses["mui.control.DataButton"] = mui.control.DataButton;
mui.control.DataButton.__name__ = ["mui","control","DataButton"];
mui.control.DataButton.__super__ = mui.core.DataComponent;
mui.control.DataButton.prototype = $extend(mui.core.DataComponent.prototype,{
	focusOnPress: null
	,focusOnRelease: null
	,actioned: null
	,press: function() {
		if(!this.enabled) return;
		if(this.focusOnPress && !this.focused) this.focus();
		this.set_pressed(true);
		if(mui.event.Input.mode == mui.event.InputMode.KEY) this.action();
	}
	,release: function() {
		if(!this.enabled) return;
		if(this.focusOnRelease && !this.focused) this.focus();
		this.set_pressed(false);
		if(mui.event.Input.mode == mui.event.InputMode.TOUCH) this.action();
	}
	,action: function() {
		mui.core.DataComponent.prototype.action.call(this);
		this.set_pressed(false);
		this.actioned.dispatch();
		this.bubble(mui.control.ButtonEvent.BUTTON_ACTIONED);
	}
	,change: function(flag) {
		mui.core.DataComponent.prototype.change.call(this,flag);
		if(flag.enabled) this.set_useHandCursor(this.enabled);
	}
	,keyPress: function(key) {
		if(key.get_action() == mui.event.KeyAction.OK) {
			key.capture();
			if(key.pressCount == 1) this.press();
		} else mui.core.DataComponent.prototype.keyPress.call(this,key);
	}
	,keyRelease: function(key) {
		if(key.get_action() == mui.event.KeyAction.OK) {
			key.capture();
			this.release();
		} else mui.core.DataComponent.prototype.keyRelease.call(this,key);
	}
	,initialX: null
	,initialY: null
	,touchStart: function(touch) {
		mui.core.DataComponent.prototype.touchStart.call(this,touch);
		this.press();
		this.set_pressed(true);
		this.initialX = touch.currentX - this.get_rootX();
		this.initialY = touch.currentY - this.get_rootY();
		touch.updated.add($bind(this,this.touchMoved));
		touch.completed.add($bind(this,this.inputCompleted));
		touch.captured.add($bind(this,this.inputCancelled));
	}
	,touchMoved: function(touch) {
		var currentX = this.initialX + touch.get_totalChangeX();
		var currentY = this.initialY + touch.get_totalChangeY();
		this.set_pressed(currentX >= 0 && currentX <= this.get_width() && currentY >= 0 && currentY <= this.get_height());
	}
	,inputCompleted: function(touch) {
		if(this.pressed) this.release();
	}
	,inputCancelled: function(touch) {
		touch.updated.remove($bind(this,this.touchMoved));
		touch.completed.remove($bind(this,this.inputCompleted));
		this.set_pressed(false);
	}
	,__class__: mui.control.DataButton
});
flickrapp.flickr.view = {};
flickrapp.flickr.view.GalleryItemView = function(imgId,imgUrl) {
	mui.control.DataButton.call(this);
	this.set_fill(new mui.display.Color(16184817));
	this.set_stroke(new mui.display.Color(15263976));
	this.set_strokeThickness(2);
	this.set_width(200);
	this.set_height(150);
	this.image = new mui.display.Image();
	this.addChild(this.image);
	this.image.set_autoSize(false);
	this.image.set_width(this.get_width());
	this.image.set_height(this.get_height());
	this.image.set_scaleMode(mui.display.ScaleMode.FILL);
	this.image.set_clip(true);
	this.image.set_url(imgUrl);
	this.url = imgUrl;
	this.id = imgId;
	this.image.loaded.add($bind(this,this.imageLoaded));
	this.image.failed.add($bind(this,this.imageFailed));
	null;
};
$hxClasses["flickrapp.flickr.view.GalleryItemView"] = flickrapp.flickr.view.GalleryItemView;
flickrapp.flickr.view.GalleryItemView.__name__ = ["flickrapp","flickr","view","GalleryItemView"];
flickrapp.flickr.view.GalleryItemView.__super__ = mui.control.DataButton;
flickrapp.flickr.view.GalleryItemView.prototype = $extend(mui.control.DataButton.prototype,{
	url: null
	,id: null
	,image: null
	,imageLoaded: function() {
		this.actioned.add($bind(this,this.showDetailedImage));
	}
	,imageFailed: function() {
	}
	,showDetailedImage: function() {
		var galleryZoomView = new flickrapp.flickr.view.GalleryZoomView(this.id,this.url);
		mui.Lib.get_display().addChild(galleryZoomView);
		mui.transition.Slide.to(100,50,{ ease : mui.transition.Ease.outCubic}).from(200,200).apply(galleryZoomView);
	}
	,__class__: flickrapp.flickr.view.GalleryItemView
});
mmvc.api.IMediator = function() { };
$hxClasses["mmvc.api.IMediator"] = mmvc.api.IMediator;
mmvc.api.IMediator.__name__ = ["mmvc","api","IMediator"];
mmvc.api.IMediator.prototype = {
	preRegister: null
	,onRegister: null
	,preRemove: null
	,onRemove: null
	,getViewComponent: null
	,setViewComponent: null
	,__class__: mmvc.api.IMediator
};
mmvc.base = {};
mmvc.base.MediatorBase = function() {
	this.slots = [];
};
$hxClasses["mmvc.base.MediatorBase"] = mmvc.base.MediatorBase;
mmvc.base.MediatorBase.__name__ = ["mmvc","base","MediatorBase"];
mmvc.base.MediatorBase.__interfaces__ = [mmvc.api.IMediator];
mmvc.base.MediatorBase.prototype = {
	view: null
	,removed: null
	,slots: null
	,preRegister: function() {
		this.removed = false;
		this.onRegister();
	}
	,onRegister: function() {
	}
	,preRemove: function() {
		this.removed = true;
		this.onRemove();
	}
	,onRemove: function() {
		var _g = 0;
		var _g1 = this.slots;
		while(_g < _g1.length) {
			var slot = _g1[_g];
			++_g;
			slot.remove();
		}
	}
	,getViewComponent: function() {
		return this.view;
	}
	,setViewComponent: function(viewComponent) {
		this.view = viewComponent;
	}
	,mediate: function(slot) {
		this.slots.push(slot);
	}
	,__class__: mmvc.base.MediatorBase
};
mmvc.impl.Mediator = function() {
	mmvc.base.MediatorBase.call(this);
};
$hxClasses["mmvc.impl.Mediator"] = mmvc.impl.Mediator;
mmvc.impl.Mediator.__name__ = ["mmvc","impl","Mediator"];
mmvc.impl.Mediator.__super__ = mmvc.base.MediatorBase;
mmvc.impl.Mediator.prototype = $extend(mmvc.base.MediatorBase.prototype,{
	injector: null
	,contextView: null
	,mediatorMap: null
	,__class__: mmvc.impl.Mediator
});
flickrapp.flickr.view.GalleryItemViewMediator = function() {
	mmvc.impl.Mediator.call(this);
};
$hxClasses["flickrapp.flickr.view.GalleryItemViewMediator"] = flickrapp.flickr.view.GalleryItemViewMediator;
flickrapp.flickr.view.GalleryItemViewMediator.__name__ = ["flickrapp","flickr","view","GalleryItemViewMediator"];
flickrapp.flickr.view.GalleryItemViewMediator.__super__ = mmvc.impl.Mediator;
flickrapp.flickr.view.GalleryItemViewMediator.prototype = $extend(mmvc.impl.Mediator.prototype,{
	onRegister: function() {
		haxe.Log.trace("mediated itemview to its mediator",{ fileName : "GalleryItemViewMediator.hx", lineNumber : 19, className : "flickrapp.flickr.view.GalleryItemViewMediator", methodName : "onRegister"});
		mmvc.impl.Mediator.prototype.onRegister.call(this);
	}
	,onRemove: function() {
		mmvc.impl.Mediator.prototype.onRemove.call(this);
	}
	,__class__: flickrapp.flickr.view.GalleryItemViewMediator
});
flickrapp.flickr.view.GalleryView = function() {
	mui.core.DataContainer.call(this);
	this.set_left(this.set_right(0));
	this.set_height(400);
	this.set_width(1000);
	this.set_fill(new mui.display.Color(16184817));
	this.set_stroke(new mui.display.Color(15263976));
	this.set_strokeThickness(2);
	this.gridLayout = new mui.layout.GridLayout();
	this.gridLayout.set_cellWidth(200);
	this.gridLayout.set_cellHeight(150);
	this.set_layout(this.set_layout(this.gridLayout));
	this.layout.enabled = true;
	this.layout.set_spacingX(this.layout.set_spacingY(10));
	null;
};
$hxClasses["flickrapp.flickr.view.GalleryView"] = flickrapp.flickr.view.GalleryView;
flickrapp.flickr.view.GalleryView.__name__ = ["flickrapp","flickr","view","GalleryView"];
flickrapp.flickr.view.GalleryView.__super__ = mui.core.DataContainer;
flickrapp.flickr.view.GalleryView.prototype = $extend(mui.core.DataContainer.prototype,{
	gridLayout: null
	,addImage: function(id,url) {
		var itemView = new flickrapp.flickr.view.GalleryItemView(id,url);
		this.addComponent(itemView);
	}
	,removeImages: function() {
		if(this.numComponents > 0) this.removeComponents();
	}
	,__class__: flickrapp.flickr.view.GalleryView
});
flickrapp.flickr.view.GalleryViewMediator = function() {
	mmvc.impl.Mediator.call(this);
};
$hxClasses["flickrapp.flickr.view.GalleryViewMediator"] = flickrapp.flickr.view.GalleryViewMediator;
flickrapp.flickr.view.GalleryViewMediator.__name__ = ["flickrapp","flickr","view","GalleryViewMediator"];
flickrapp.flickr.view.GalleryViewMediator.__super__ = mmvc.impl.Mediator;
flickrapp.flickr.view.GalleryViewMediator.prototype = $extend(mmvc.impl.Mediator.prototype,{
	galleryModel: null
	,onRegister: function() {
		haxe.Log.trace("mediated galleryview to its mediator",{ fileName : "GalleryViewMediator.hx", lineNumber : 20, className : "flickrapp.flickr.view.GalleryViewMediator", methodName : "onRegister"});
		mmvc.impl.Mediator.prototype.onRegister.call(this);
		this.mediate(this.galleryModel.get_changed().add($bind(this,this.onGalleryModelUpdate)));
	}
	,onRemove: function() {
		mmvc.impl.Mediator.prototype.onRemove.call(this);
	}
	,onGalleryModelUpdate: function(event) {
		var _g = event.type[0];
		switch(_g) {
		case "Add":
			this.view.gridLayout.wrapIndex = Math.round(this.galleryModel.num / 5) + 1;
			var galleryItemModels = this.galleryModel.getAll();
			var $it0 = galleryItemModels.iterator();
			while( $it0.hasNext() ) {
				var galleryItemModel = $it0.next();
				this.view.addImage(galleryItemModel.id,galleryItemModel.url);
			}
			break;
		case "Remove":
			this.view.removeImages();
			break;
		}
	}
	,__class__: flickrapp.flickr.view.GalleryViewMediator
});
flickrapp.flickr.view.ViewAction = { __ename__ : ["flickrapp","flickr","view","ViewAction"], __constructs__ : ["Next","Previous"] };
flickrapp.flickr.view.ViewAction.Next = ["Next",0];
flickrapp.flickr.view.ViewAction.Next.toString = $estr;
flickrapp.flickr.view.ViewAction.Next.__enum__ = flickrapp.flickr.view.ViewAction;
flickrapp.flickr.view.ViewAction.Previous = ["Previous",1];
flickrapp.flickr.view.ViewAction.Previous.toString = $estr;
flickrapp.flickr.view.ViewAction.Previous.__enum__ = flickrapp.flickr.view.ViewAction;
flickrapp.flickr.view.GalleryZoomView = function(imgId,imgUrl) {
	haxe.Log.trace("new gallerydetailed view",{ fileName : "GalleryZoomView.hx", lineNumber : 37, className : "flickrapp.flickr.view.GalleryZoomView", methodName : "new"});
	mui.core.DataContainer.call(this);
	this.clickSignal = new msignal.Signal1(flickrapp.flickr.view.ViewAction);
	this.set_fill(new mui.display.Color(16184817,0.5));
	this.set_stroke(new mui.display.Color(15263976));
	this.set_strokeThickness(2);
	this.set_width(800);
	this.set_height(600);
	this.set_left(this.set_right(this.set_top(this.set_bottom(100))));
	this.image = new mui.display.Image();
	this.addChild(this.image);
	this.image.set_autoSize(false);
	this.image.set_left(this.image.set_right(100));
	this.image.set_width(this.get_width());
	this.image.set_height(this.get_height());
	this.image.set_scaleMode(mui.display.ScaleMode.FILL);
	this.image.set_clip(true);
	this.image.set_url(imgUrl);
	this.image.loaded.addOnce($bind(this,this.imageLoaded));
	this.image.failed.addOnce($bind(this,this.imageFailed));
	null;
};
$hxClasses["flickrapp.flickr.view.GalleryZoomView"] = flickrapp.flickr.view.GalleryZoomView;
flickrapp.flickr.view.GalleryZoomView.__name__ = ["flickrapp","flickr","view","GalleryZoomView"];
flickrapp.flickr.view.GalleryZoomView.__super__ = mui.core.DataContainer;
flickrapp.flickr.view.GalleryZoomView.prototype = $extend(mui.core.DataContainer.prototype,{
	image: null
	,leftButton: null
	,rightButton: null
	,exitButton: null
	,clickSignal: null
	,imageLoaded: function() {
		this.leftButton = new mui.control.DataButton();
		this.rightButton = new mui.control.DataButton();
		this.exitButton = new mui.control.DataButton();
		this.exitButton.set_width(this.exitButton.set_height(50));
		this.exitButton.set_fill(new mui.display.Color(11141120,0.8));
		this.exitButton.set_right(this.exitButton.set_top(5));
		this.leftButton.set_width(this.leftButton.set_height(this.rightButton.set_width(this.rightButton.set_height(50))));
		this.leftButton.set_top(this.leftButton.set_bottom(this.rightButton.set_top(this.rightButton.set_bottom(275))));
		this.leftButton.set_fill(this.rightButton.set_fill(new mui.display.Color(11141120,0.8)));
		this.leftButton.actioned.add($bind(this,this.onLeftClick));
		this.rightButton.actioned.add($bind(this,this.onRightClick));
		this.exitButton.actioned.add($bind(this,this.onExitClick));
		this.leftButton.set_left(5);
		this.rightButton.set_right(5);
		this.addComponent(this.leftButton);
		this.addComponent(this.rightButton);
		this.addComponent(this.exitButton);
	}
	,change: function(flag) {
		mui.core.DataContainer.prototype.change.call(this,flag);
	}
	,imageFailed: function() {
	}
	,onLeftClick: function() {
		haxe.Log.trace("left one",{ fileName : "GalleryZoomView.hx", lineNumber : 105, className : "flickrapp.flickr.view.GalleryZoomView", methodName : "onLeftClick"});
		this.clickSignal.dispatch(flickrapp.flickr.view.ViewAction.Previous);
	}
	,onRightClick: function() {
		haxe.Log.trace("right one",{ fileName : "GalleryZoomView.hx", lineNumber : 111, className : "flickrapp.flickr.view.GalleryZoomView", methodName : "onRightClick"});
		this.clickSignal.dispatch(flickrapp.flickr.view.ViewAction.Next);
	}
	,onExitClick: function() {
		mui.Lib.get_display().removeChild(this);
	}
	,__class__: flickrapp.flickr.view.GalleryZoomView
});
flickrapp.flickr.view.GalleryZoomViewMediator = function() {
	mmvc.impl.Mediator.call(this);
};
$hxClasses["flickrapp.flickr.view.GalleryZoomViewMediator"] = flickrapp.flickr.view.GalleryZoomViewMediator;
flickrapp.flickr.view.GalleryZoomViewMediator.__name__ = ["flickrapp","flickr","view","GalleryZoomViewMediator"];
flickrapp.flickr.view.GalleryZoomViewMediator.__super__ = mmvc.impl.Mediator;
flickrapp.flickr.view.GalleryZoomViewMediator.prototype = $extend(mmvc.impl.Mediator.prototype,{
	screenList: null
	,onRegister: function() {
		haxe.Log.trace("zoom view mediator",{ fileName : "GalleryZoomViewMediator.hx", lineNumber : 20, className : "flickrapp.flickr.view.GalleryZoomViewMediator", methodName : "onRegister"});
		mmvc.impl.Mediator.prototype.onRegister.call(this);
	}
	,onRemove: function() {
		mmvc.impl.Mediator.prototype.onRemove.call(this);
	}
	,viewActioned: function(action) {
		this.navigateList(action);
	}
	,navigateList: function(action) {
		haxe.Log.trace("start to change the selected index of screenlist view",{ fileName : "GalleryZoomViewMediator.hx", lineNumber : 67, className : "flickrapp.flickr.view.GalleryZoomViewMediator", methodName : "navigateList"});
		var index;
		switch(action[1]) {
		case 0:
			index = this.screenList.selectedIndex + 1;
			break;
		case 1:
			index = this.screenList.selectedIndex - 1;
			break;
		}
		if(index >= 0 && index < this.screenList.get_size()) this.screenList.set_selectedIndex(index);
	}
	,__class__: flickrapp.flickr.view.GalleryZoomViewMediator
});
flickrapp.flickr.view.SearchBoxView = function() {
	mui.core.DataContainer.call(this);
	this.set_width(1000);
	this.set_height(300);
	this.set_left(this.set_right(0));
	this.clickSignal = new msignal.Signal2();
	this.form = new mui.input.DataForm();
	this.addComponent(this.form);
	this.form.set_strokeThickness(2);
	this.form.set_left(this.form.set_right(0));
	this.form.set_fill(new mui.display.Color(16184817));
	this.form.set_stroke(new mui.display.Color(15263976));
	this.form.set_height(300);
	this.form.set_width(1000);
	var errors = new mui.core.DataComponent();
	this.addComponent(errors);
	errors.set_width(700);
	errors.set_height(0);
	errors.set_clip(true);
	errors.set_fill(new mui.display.Color(11141120));
	var errorText = new mui.display.Text();
	errors.addChild(errorText);
	errorText.set_color(16777215);
	errorText.set_multiline(true);
	errorText.set_left(errorText.set_right(80));
	errorText.set_y(18);
	errorText.set_size(16);
	var theme = new mui.input.Theme();
	var builder = new mui.input.ThemeFormBuilder(theme);
	builder.build(this.form).group("Search filter").text("Keywords","Keywords: cat/camera/car").required("Please enter the keywords").text("NumberPerPage","Numbers per page: 10/50/100").required("Please enter the numbers");
	var submit = new flickrapp.flickr.view.TitleButton();
	submit.set_width(200);
	submit.set_height(50);
	submit.updateData("Search");
	this.form.addComponent(submit);
	submit.actioned.add($bind(this,this.onSubmit));
	null;
};
$hxClasses["flickrapp.flickr.view.SearchBoxView"] = flickrapp.flickr.view.SearchBoxView;
flickrapp.flickr.view.SearchBoxView.__name__ = ["flickrapp","flickr","view","SearchBoxView"];
flickrapp.flickr.view.SearchBoxView.__super__ = mui.core.DataContainer;
flickrapp.flickr.view.SearchBoxView.prototype = $extend(mui.core.DataContainer.prototype,{
	clickSignal: null
	,form: null
	,onSubmit: function() {
		haxe.Log.trace("submit button clicked",{ fileName : "SearchBoxView.hx", lineNumber : 87, className : "flickrapp.flickr.view.SearchBoxView", methodName : "onSubmit"});
		var keywords = this.form.getInputData("Keywords");
		var num = this.form.getInputData("NumberPerPage");
		this.clickSignal.dispatch(keywords,num);
	}
	,__class__: flickrapp.flickr.view.SearchBoxView
});
flickrapp.flickr.view.SearchBoxViewMediator = function() {
	mmvc.impl.Mediator.call(this);
};
$hxClasses["flickrapp.flickr.view.SearchBoxViewMediator"] = flickrapp.flickr.view.SearchBoxViewMediator;
flickrapp.flickr.view.SearchBoxViewMediator.__name__ = ["flickrapp","flickr","view","SearchBoxViewMediator"];
flickrapp.flickr.view.SearchBoxViewMediator.__super__ = mmvc.impl.Mediator;
flickrapp.flickr.view.SearchBoxViewMediator.prototype = $extend(mmvc.impl.Mediator.prototype,{
	loadFlickrData: null
	,galleryModel: null
	,onRegister: function() {
		haxe.Log.trace("----first register -------",{ fileName : "SearchBoxViewMediator.hx", lineNumber : 23, className : "flickrapp.flickr.view.SearchBoxViewMediator", methodName : "onRegister"});
		mmvc.impl.Mediator.prototype.onRegister.call(this);
		this.mediate(this.view.clickSignal.add($bind(this,this.searchHandler)));
	}
	,onRemove: function() {
		mmvc.impl.Mediator.prototype.onRemove.call(this);
	}
	,searchHandler: function(searchTerm,num) {
		this.loadFlickrData.dispatch(searchTerm,Std.parseInt(num));
		this.galleryModel.num = Std.parseInt(num);
	}
	,__class__: flickrapp.flickr.view.SearchBoxViewMediator
});
flickrapp.flickr.view.TitleButton = function() {
	mui.control.DataButton.call(this);
	this.set_fill(new mui.display.Color(12303291));
	this.title = new mui.display.Text();
	this.title.set_centerX(this.title.set_centerY(0.5));
	this.addChild(this.title);
	null;
};
$hxClasses["flickrapp.flickr.view.TitleButton"] = flickrapp.flickr.view.TitleButton;
flickrapp.flickr.view.TitleButton.__name__ = ["flickrapp","flickr","view","TitleButton"];
flickrapp.flickr.view.TitleButton.__super__ = mui.control.DataButton;
flickrapp.flickr.view.TitleButton.prototype = $extend(mui.control.DataButton.prototype,{
	title: null
	,updateData: function(newData) {
		mui.control.DataButton.prototype.updateData.call(this,newData);
		this.title.set_value(newData);
	}
	,__class__: flickrapp.flickr.view.TitleButton
});
haxe.StackItem = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","LocalFunction"] };
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.StackItem.LocalFunction = function(v) { var $x = ["LocalFunction",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.CallStack = function() { };
$hxClasses["haxe.CallStack"] = haxe.CallStack;
haxe.CallStack.__name__ = ["haxe","CallStack"];
haxe.CallStack.callStack = function() {
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe.StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe.StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe.CallStack.makeStack(new Error().stack);
	a.shift();
	Error.prepareStackTrace = oldValue;
	return a;
};
haxe.CallStack.exceptionStack = function() {
	return [];
};
haxe.CallStack.makeStack = function(s) {
	if(typeof(s) == "string") {
		var stack = s.split("\n");
		var m = [];
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			m.push(haxe.StackItem.Module(line));
		}
		return m;
	} else return s;
};
haxe.Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
$hxClasses["haxe.Http"] = haxe.Http;
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.prototype = {
	url: null
	,responseData: null
	,async: null
	,postData: null
	,headers: null
	,params: null
	,setHeader: function(header,value) {
		this.headers = Lambda.filter(this.headers,function(h) {
			return h.header != header;
		});
		this.headers.push({ header : header, value : value});
		return this;
	}
	,setPostData: function(data) {
		this.postData = data;
		return this;
	}
	,req: null
	,cancel: function() {
		if(this.req == null) return;
		this.req.abort();
		this.req = null;
	}
	,request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js.Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				s = null;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var $it0 = this.params.iterator();
			while( $it0.hasNext() ) {
				var p = $it0.next();
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var $it1 = this.headers.iterator();
		while( $it1.hasNext() ) {
			var h1 = $it1.next();
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe.Http
};
haxe.Log = function() { };
$hxClasses["haxe.Log"] = haxe.Log;
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe.Timer;
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
};
haxe.Timer.prototype = {
	id: null
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
};
haxe.Utf8 = function(size) {
	this.__b = "";
};
$hxClasses["haxe.Utf8"] = haxe.Utf8;
haxe.Utf8.__name__ = ["haxe","Utf8"];
haxe.Utf8.charCodeAt = function(s,index) {
	return HxOverrides.cca(s,index);
};
haxe.Utf8.prototype = {
	__b: null
	,__class__: haxe.Utf8
};
haxe.ds.IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe.ds.IntMap;
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	h: null
	,set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,__class__: haxe.ds.IntMap
};
haxe.io.Eof = function() { };
$hxClasses["haxe.io.Eof"] = haxe.io.Eof;
haxe.io.Eof.__name__ = ["haxe","io","Eof"];
haxe.io.Eof.prototype = {
	toString: function() {
		return "Eof";
	}
	,__class__: haxe.io.Eof
};
haxe.io.Error = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; };
haxe.rtti = {};
haxe.rtti.Meta = function() { };
$hxClasses["haxe.rtti.Meta"] = haxe.rtti.Meta;
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	if(meta == null || meta.obj == null) return { }; else return meta.obj;
};
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	if(meta == null || meta.fields == null) return { }; else return meta.fields;
};
haxe.xml = {};
haxe.xml.Parser = function() { };
$hxClasses["haxe.xml.Parser"] = haxe.xml.Parser;
haxe.xml.Parser.__name__ = ["haxe","xml","Parser"];
haxe.xml.Parser.parse = function(str) {
	var doc = Xml.createDocument();
	haxe.xml.Parser.doParse(str,0,doc);
	return doc;
};
haxe.xml.Parser.doParse = function(str,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var child = Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start));
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				next = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child1 = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw "Expected <![CDATA[";
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw "Expected <!DOCTYPE";
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw "Expected <!--"; else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw "Expected node name";
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw "Expected node name";
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				nsubs++;
				break;
			case 62:
				state = 9;
				nsubs++;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw "Expected attribute name";
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw "Duplicate attribute";
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw "Expected =";
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				state = 8;
				start = p;
				break;
			default:
				throw "Expected \"";
			}
			break;
		case 8:
			if(c == str.charCodeAt(start)) {
				var val = HxOverrides.substr(str,start + 1,p - start - 1);
				xml.set(aname,val);
				state = 0;
				next = 4;
			}
			break;
		case 9:
			p = haxe.xml.Parser.doParse(str,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw "Expected >";
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw "Expected >";
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw "Expected node name";
				var v = HxOverrides.substr(str,start,p - start);
				if(v != parent.get_nodeName()) throw "Expected </" + parent.get_nodeName() + ">";
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProcessingInstruction(str1));
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var i;
					if(s.charCodeAt(1) == 120) i = Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)); else i = Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.add(String.fromCharCode(i));
				} else if(!haxe.xml.Parser.escapes.exists(s)) buf.b += Std.string("&" + s + ";"); else buf.add(haxe.xml.Parser.escapes.get(s));
				start = p + 1;
				state = next;
			}
			break;
		}
		c = StringTools.fastCodeAt(str,++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) parent.addChild(Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start)));
		return p;
	}
	throw "Unexpected end";
};
var js = {};
js.Boot = function() { };
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js.Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js.Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js.Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
js.Browser = function() { };
$hxClasses["js.Browser"] = js.Browser;
js.Browser.__name__ = ["js","Browser"];
js.Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw "Unable to create XMLHttpRequest object.";
};
var mconsole = {};
mconsole.PrinterBase = function() {
	this.printPosition = true;
	this.printLineNumbers = true;
};
$hxClasses["mconsole.PrinterBase"] = mconsole.PrinterBase;
mconsole.PrinterBase.__name__ = ["mconsole","PrinterBase"];
mconsole.PrinterBase.prototype = {
	printPosition: null
	,printLineNumbers: null
	,position: null
	,lineNumber: null
	,print: function(level,params,indent,pos) {
		params = params.slice();
		var _g1 = 0;
		var _g = params.length;
		while(_g1 < _g) {
			var i = _g1++;
			params[i] = Std.string(params[i]);
		}
		var message = params.join(", ");
		var nextPosition = "@ " + pos.className + "." + pos.methodName;
		var nextLineNumber;
		if(pos.lineNumber == null) nextLineNumber = "null"; else nextLineNumber = "" + pos.lineNumber;
		var lineColumn = "";
		var emptyLineColumn = "";
		if(this.printPosition) {
			if(nextPosition != this.position) this.printLine(mconsole.ConsoleColor.none,nextPosition,pos);
		}
		if(this.printLineNumbers) {
			emptyLineColumn = StringTools.lpad(""," ",5);
			if(nextPosition != this.position || nextLineNumber != this.lineNumber) lineColumn = StringTools.lpad(nextLineNumber," ",4) + " "; else lineColumn = emptyLineColumn;
		}
		this.position = nextPosition;
		this.lineNumber = nextLineNumber;
		var color;
		switch(level[1]) {
		case 0:
			color = mconsole.ConsoleColor.white;
			break;
		case 1:
			color = mconsole.ConsoleColor.blue;
			break;
		case 2:
			color = mconsole.ConsoleColor.green;
			break;
		case 3:
			color = mconsole.ConsoleColor.yellow;
			break;
		case 4:
			color = mconsole.ConsoleColor.red;
			break;
		}
		var indent1 = StringTools.lpad(""," ",indent * 2);
		message = lineColumn + indent1 + message;
		message = message.split("\n").join("\n" + emptyLineColumn + indent1);
		this.printLine(color,message,pos);
	}
	,printLine: function(color,line,pos) {
		throw "method not implemented in ConsolePrinterBase";
	}
	,__class__: mconsole.PrinterBase
};
mconsole.Printer = function() { };
$hxClasses["mconsole.Printer"] = mconsole.Printer;
mconsole.Printer.__name__ = ["mconsole","Printer"];
mconsole.Printer.prototype = {
	print: null
	,__class__: mconsole.Printer
};
mconsole.ConsoleView = function() {
	mconsole.PrinterBase.call(this);
	this.atBottom = true;
	this.projectHome = "/Users/leo.chen/Documents/LeoProjectWorkspace/new_flickrgallery/mui_version_2/";
	var document = window.document;
	this.element = document.createElement("pre");
	this.element.id = "console";
	var style = document.createElement("style");
	this.element.appendChild(style);
	var rules = document.createTextNode("#console {\n\tfont-family:monospace;\n\tbackground-color:#002B36;\n\tbackground-color:rgba(0%,16.9%,21.2%,0.95);\n\tpadding:8px;\n\theight:600px;\n\tmax-height:600px;\n\toverflow-y:scroll;\n\tposition:absolute;\n\tleft:0px;\n\ttop:0px;\n\tright:0px;\n\tmargin:0px;\n\tz-index:10000;\n}\n#console a { text-decoration:none; }\n#console a:hover div { background-color:#063642 }\n#console a div span { display:none; float:right; color:white; }\n#console a:hover div span { display:block; }");
	style.type = "text/css";
	if(style.styleSheet) style.styleSheet.cssText = rules.nodeValue; else style.appendChild(rules);
	var me = this;
	this.element.onscroll = function(e) {
		me.updateScroll();
	};
};
$hxClasses["mconsole.ConsoleView"] = mconsole.ConsoleView;
mconsole.ConsoleView.__name__ = ["mconsole","ConsoleView"];
mconsole.ConsoleView.__interfaces__ = [mconsole.Printer];
mconsole.ConsoleView.__super__ = mconsole.PrinterBase;
mconsole.ConsoleView.prototype = $extend(mconsole.PrinterBase.prototype,{
	element: null
	,projectHome: null
	,atBottom: null
	,updateScroll: function() {
		this.atBottom = this.element.scrollTop - (this.element.scrollHeight - this.element.clientHeight) == 0;
	}
	,printLine: function(color,line,pos) {
		var style;
		switch(color[1]) {
		case 0:
			style = "#839496";
			break;
		case 1:
			style = "#ffffff";
			break;
		case 2:
			style = "#248bd2";
			break;
		case 3:
			style = "#859900";
			break;
		case 4:
			style = "#b58900";
			break;
		case 5:
			style = "#dc322f";
			break;
		}
		var file = pos.fileName + ":" + pos.lineNumber;
		var fileName = pos.className.split(".").join("/") + ".hx";
		var link = "";
		this.element.innerHTML = this.element.innerHTML + "<a" + link + "><div style='color:" + style + "'>" + line + "<span>" + file + "</span></div></a>";
		if(this.atBottom) this.element.scrollTop = this.element.scrollHeight;
	}
	,attach: function() {
		window.document.body.appendChild(this.element);
	}
	,remove: function() {
		window.document.body.removeChild(this.element);
	}
	,__class__: mconsole.ConsoleView
});
mconsole.Console = function() { };
$hxClasses["mconsole.Console"] = mconsole.Console;
mconsole.Console.__name__ = ["mconsole","Console"];
mconsole.Console.start = function() {
	if(mconsole.Console.running) return;
	mconsole.Console.running = true;
	mconsole.Console.previousTrace = haxe.Log.trace;
	haxe.Log.trace = mconsole.Console.haxeTrace;
	if(mconsole.Console.hasConsole) {
	} else {
	}
};
mconsole.Console.stop = function() {
	if(!mconsole.Console.running) return;
	mconsole.Console.running = false;
	haxe.Log.trace = mconsole.Console.previousTrace;
	mconsole.Console.previousTrace = null;
};
mconsole.Console.addPrinter = function(printer) {
	mconsole.Console.removePrinter(printer);
	mconsole.Console.printers.push(printer);
};
mconsole.Console.removePrinter = function(printer) {
	HxOverrides.remove(mconsole.Console.printers,printer);
};
mconsole.Console.haxeTrace = function(value,pos) {
	var params = pos.customParams;
	if(params == null) params = []; else pos.customParams = null;
	var level;
	switch(value) {
	case "log":
		level = mconsole.LogLevel.log;
		break;
	case "warn":
		level = mconsole.LogLevel.warn;
		break;
	case "info":
		level = mconsole.LogLevel.info;
		break;
	case "debug":
		level = mconsole.LogLevel.debug;
		break;
	case "error":
		level = mconsole.LogLevel.error;
		break;
	default:
		params.unshift(value);
		level = mconsole.LogLevel.log;
	}
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole(Std.string(level),params);
	mconsole.Console.print(level,params,pos);
};
mconsole.Console.print = function(level,params,pos) {
	var _g = 0;
	var _g1 = mconsole.Console.printers;
	while(_g < _g1.length) {
		var printer = _g1[_g];
		++_g;
		printer.print(level,params,mconsole.Console.groupDepth,pos);
	}
};
mconsole.Console.log = function(message,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("log",[message]);
	mconsole.Console.print(mconsole.LogLevel.log,[message],pos);
};
mconsole.Console.info = function(message,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("info",[message]);
	mconsole.Console.print(mconsole.LogLevel.info,[message],pos);
};
mconsole.Console.debug = function(message,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("debug",[message]);
	mconsole.Console.print(mconsole.LogLevel.debug,[message],pos);
};
mconsole.Console.warn = function(message,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("warn",[message]);
	mconsole.Console.print(mconsole.LogLevel.warn,[message],pos);
};
mconsole.Console.error = function(message,stack,pos) {
	if(stack == null) stack = haxe.CallStack.callStack();
	var stackTrace;
	if(stack.length > 0) stackTrace = "\n" + mconsole.StackHelper.toString(stack); else stackTrace = "";
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("error",[message]);
	mconsole.Console.print(mconsole.LogLevel.error,["Error: " + Std.string(message) + stackTrace],pos);
};
mconsole.Console.trace = function(pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("trace",[]);
	var stack = mconsole.StackHelper.toString(haxe.CallStack.callStack());
	mconsole.Console.print(mconsole.LogLevel.error,["Stack trace:\n" + stack],pos);
};
mconsole.Console.assert = function(expression,message,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("assert",[expression,message]);
	if(!expression) {
		var stack = mconsole.StackHelper.toString(haxe.CallStack.callStack());
		mconsole.Console.print(mconsole.LogLevel.error,["Assertion failed: " + Std.string(message) + "\n" + stack],pos);
		throw message;
	}
};
mconsole.Console.count = function(title,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("count",[title]);
	var position = pos.fileName + ":" + pos.lineNumber;
	var count;
	if(mconsole.Console.counts.exists(position)) count = mconsole.Console.counts.get(position) + 1; else count = 1;
	mconsole.Console.counts.set(position,count);
	mconsole.Console.print(mconsole.LogLevel.log,[title + ": " + count],pos);
};
mconsole.Console.group = function(message,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("group",[message]);
	mconsole.Console.print(mconsole.LogLevel.log,[message],pos);
	mconsole.Console.groupDepth += 1;
};
mconsole.Console.groupEnd = function(pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("groupEnd",[]);
	if(mconsole.Console.groupDepth > 0) mconsole.Console.groupDepth -= 1;
};
mconsole.Console.time = function(name,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("time",[name]);
	mconsole.Console.times.set(name,haxe.Timer.stamp());
};
mconsole.Console.timeEnd = function(name,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("timeEnd",[name]);
	if(mconsole.Console.times.exists(name)) {
		mconsole.Console.print(mconsole.LogLevel.log,[name + ": " + Std["int"]((haxe.Timer.stamp() - mconsole.Console.times.get(name)) * 1000) + "ms"],pos);
		mconsole.Console.times.remove(name);
	}
};
mconsole.Console.markTimeline = function(label,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("markTimeline",[label]);
};
mconsole.Console.profile = function(title,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("profile",[title]);
};
mconsole.Console.profileEnd = function(title,pos) {
	if(mconsole.Console.hasConsole) mconsole.Console.callConsole("profileEnd",[title]);
};
mconsole.Console.enterDebugger = function() {
	debugger;
};
mconsole.Console.detectConsole = function() {
	if(console != null && console[mconsole.Console.dirxml] == null) mconsole.Console.dirxml = "log";
	return console != undefined && console.log != undefined && console.warn != undefined;
};
mconsole.Console.callConsole = function(method,params) {
	if(console[method] != null) {
		if(method == "log" && js.Boot.__instanceof(params[0],Xml)) method = mconsole.Console.dirxml;
		if(console[method].apply != null) console[method].apply(console,mconsole.Console.toConsoleValues(params)); else if(Function.prototype.bind != null) Function.prototype.bind.call(console[method],console).apply(console,mconsole.Console.toConsoleValues(params));
	}
};
mconsole.Console.toConsoleValues = function(params) {
	var _g1 = 0;
	var _g = params.length;
	while(_g1 < _g) {
		var i = _g1++;
		params[i] = mconsole.Console.toConsoleValue(params[i]);
	}
	return params;
};
mconsole.Console.toConsoleValue = function(value) {
	var typeClass = Type.getClass(value);
	var typeName;
	if(typeClass == null) typeName = ""; else typeName = Type.getClassName(typeClass);
	if(typeName == "Xml") {
		var parser = new DOMParser();
		return parser.parseFromString(value.toString(),"text/xml").firstChild;
	} else if(typeName == "Map" || typeName == "StringMap" || typeName == "IntMap") {
		var $native = { };
		var map = value;
		var $it0 = map.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			Reflect.setField($native,Std.string(key),mconsole.Console.toConsoleValue(map.get(key)));
		}
		return $native;
	} else {
		{
			var _g = Type["typeof"](value);
			switch(_g[1]) {
			case 7:
				var e = _g[2];
				var native1 = [];
				var name = Type.getEnumName(e) + "." + Type.enumConstructor(value);
				var params = Type.enumParameters(value);
				if(params.length > 0) {
					native1.push(name + "(");
					var _g2 = 0;
					var _g1 = params.length;
					while(_g2 < _g1) {
						var i = _g2++;
						native1.push(mconsole.Console.toConsoleValue(params[i]));
					}
					native1.push(")");
				} else return [name];
				return native1;
			default:
			}
		}
		if(typeName == "Array" || typeName == "List" || typeName == "haxe.FastList") {
			var native2 = [];
			var iterable = value;
			var $it1 = $iterator(iterable)();
			while( $it1.hasNext() ) {
				var i1 = $it1.next();
				native2.push(mconsole.Console.toConsoleValue(i1));
			}
			return native2;
		}
	}
	return value;
};
mconsole.ConsoleMacro = function() { };
$hxClasses["mconsole.ConsoleMacro"] = mconsole.ConsoleMacro;
mconsole.ConsoleMacro.__name__ = ["mconsole","ConsoleMacro"];
mconsole.LogLevel = { __ename__ : ["mconsole","LogLevel"], __constructs__ : ["log","info","debug","warn","error"] };
mconsole.LogLevel.log = ["log",0];
mconsole.LogLevel.log.toString = $estr;
mconsole.LogLevel.log.__enum__ = mconsole.LogLevel;
mconsole.LogLevel.info = ["info",1];
mconsole.LogLevel.info.toString = $estr;
mconsole.LogLevel.info.__enum__ = mconsole.LogLevel;
mconsole.LogLevel.debug = ["debug",2];
mconsole.LogLevel.debug.toString = $estr;
mconsole.LogLevel.debug.__enum__ = mconsole.LogLevel;
mconsole.LogLevel.warn = ["warn",3];
mconsole.LogLevel.warn.toString = $estr;
mconsole.LogLevel.warn.__enum__ = mconsole.LogLevel;
mconsole.LogLevel.error = ["error",4];
mconsole.LogLevel.error.toString = $estr;
mconsole.LogLevel.error.__enum__ = mconsole.LogLevel;
mconsole.ConsoleColor = { __ename__ : ["mconsole","ConsoleColor"], __constructs__ : ["none","white","blue","green","yellow","red"] };
mconsole.ConsoleColor.none = ["none",0];
mconsole.ConsoleColor.none.toString = $estr;
mconsole.ConsoleColor.none.__enum__ = mconsole.ConsoleColor;
mconsole.ConsoleColor.white = ["white",1];
mconsole.ConsoleColor.white.toString = $estr;
mconsole.ConsoleColor.white.__enum__ = mconsole.ConsoleColor;
mconsole.ConsoleColor.blue = ["blue",2];
mconsole.ConsoleColor.blue.toString = $estr;
mconsole.ConsoleColor.blue.__enum__ = mconsole.ConsoleColor;
mconsole.ConsoleColor.green = ["green",3];
mconsole.ConsoleColor.green.toString = $estr;
mconsole.ConsoleColor.green.__enum__ = mconsole.ConsoleColor;
mconsole.ConsoleColor.yellow = ["yellow",4];
mconsole.ConsoleColor.yellow.toString = $estr;
mconsole.ConsoleColor.yellow.__enum__ = mconsole.ConsoleColor;
mconsole.ConsoleColor.red = ["red",5];
mconsole.ConsoleColor.red.toString = $estr;
mconsole.ConsoleColor.red.__enum__ = mconsole.ConsoleColor;
mconsole.StackHelper = function() { };
$hxClasses["mconsole.StackHelper"] = mconsole.StackHelper;
mconsole.StackHelper.__name__ = ["mconsole","StackHelper"];
mconsole.StackHelper.createFilters = function() {
	var filters = new haxe.ds.StringMap();
	filters.set("@ mconsole.ConsoleRedirect.haxeTrace:59",true);
	return filters;
};
mconsole.StackHelper.toString = function(stack) {
	return "null";
};
mconsole.StackItemHelper = function() { };
$hxClasses["mconsole.StackItemHelper"] = mconsole.StackItemHelper;
mconsole.StackItemHelper.__name__ = ["mconsole","StackItemHelper"];
mconsole.StackItemHelper.toString = function(item,isFirst) {
	if(isFirst == null) isFirst = false;
	switch(item[1]) {
	case 1:
		var module = item[2];
		return module;
	case 3:
		var method = item[3];
		var className = item[2];
		return className + "." + method;
	case 4:
		var v = item[2];
		return "LocalFunction(" + v + ")";
	case 2:
		var line = item[4];
		var file = item[3];
		var s = item[2];
		return (s == null?file.split("::").join(".") + ":" + line:mconsole.StackItemHelper.toString(s)) + ":" + line;
	case 0:
		return "(anonymous function)";
	}
};
var mcore = {};
mcore.exception = {};
mcore.exception.Exception = function(message,cause,info) {
	if(message == null) message = "";
	this.name = Type.getClassName(Type.getClass(this));
	this.message = message;
	this.cause = cause;
	this.info = info;
	this.stackTrace = this.createStackTrace();
};
$hxClasses["mcore.exception.Exception"] = mcore.exception.Exception;
mcore.exception.Exception.__name__ = ["mcore","exception","Exception"];
mcore.exception.Exception.getStackTrace = function(source) {
	if(js.Boot.__instanceof(source,mcore.exception.Exception)) return source.stackTrace;
	if(source != null && source.stack != null) return source.stack; else return Std.string(source);
	var s = "";
	var stack = haxe.CallStack.exceptionStack();
	while(stack.length > 0) {
		var _g = stack.shift();
		switch(_g[1]) {
		case 2:
			var line = _g[4];
			var file = _g[3];
			s += "\tat " + file + " (" + line + ")\n";
			break;
		case 3:
			var method = _g[3];
			var classname = _g[2];
			s += "\tat " + classname + "#" + method + "\n";
			break;
		default:
		}
	}
	return s;
};
mcore.exception.Exception.prototype = {
	name: null
	,get_name: function() {
		return this.name;
	}
	,message: null
	,get_message: function() {
		return this.message;
	}
	,stackTrace: null
	,cause: null
	,info: null
	,createStackTrace: function() {
		var stack = new Error(this.get_message()).stack;
		if(stack != null) {
			var pos = stack.indexOf("\n") + 1;
			stack = HxOverrides.substr(stack,pos,null);
			if(typeof(chrome) != 'undefined' || typeof(process) != 'undefined') {
				var pos1 = stack.indexOf("\n") + 1;
				stack = HxOverrides.substr(stack,pos1,null);
			}
		} else stack = "";
		return stack;
	}
	,toString: function() {
		var str = this.get_name() + ": " + this.get_message();
		if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
		if(this.cause != null) str += "\n\t Caused by: " + mcore.exception.Exception.getStackTrace(this.cause);
		return str;
	}
	,__class__: mcore.exception.Exception
	,__properties__: {get_message:"get_message",get_name:"get_name"}
};
mcore.exception.ArgumentException = function(message,cause,info) {
	if(message == null) message = "";
	mcore.exception.Exception.call(this,message,cause,info);
};
$hxClasses["mcore.exception.ArgumentException"] = mcore.exception.ArgumentException;
mcore.exception.ArgumentException.__name__ = ["mcore","exception","ArgumentException"];
mcore.exception.ArgumentException.__super__ = mcore.exception.Exception;
mcore.exception.ArgumentException.prototype = $extend(mcore.exception.Exception.prototype,{
	__class__: mcore.exception.ArgumentException
});
mcore.exception.NotFoundException = function(message,cause,info) {
	if(message == null) message = "";
	mcore.exception.Exception.call(this,message,cause,info);
};
$hxClasses["mcore.exception.NotFoundException"] = mcore.exception.NotFoundException;
mcore.exception.NotFoundException.__name__ = ["mcore","exception","NotFoundException"];
mcore.exception.NotFoundException.__super__ = mcore.exception.Exception;
mcore.exception.NotFoundException.prototype = $extend(mcore.exception.Exception.prototype,{
	__class__: mcore.exception.NotFoundException
});
mcore.exception.RangeException = function(message,cause,info) {
	if(message == null) message = "";
	mcore.exception.Exception.call(this,message,cause,info);
};
$hxClasses["mcore.exception.RangeException"] = mcore.exception.RangeException;
mcore.exception.RangeException.__name__ = ["mcore","exception","RangeException"];
mcore.exception.RangeException.numeric = function(breach,min,max) {
	return new mcore.exception.RangeException(breach + " was not within range " + min + ".." + max,null,{ fileName : "RangeException.hx", lineNumber : 44, className : "mcore.exception.RangeException", methodName : "numeric"});
};
mcore.exception.RangeException.__super__ = mcore.exception.Exception;
mcore.exception.RangeException.prototype = $extend(mcore.exception.Exception.prototype,{
	__class__: mcore.exception.RangeException
});
mcore.exception.TypeException = function(message,cause,info) {
	if(message == null) message = "";
	mcore.exception.Exception.call(this,message,cause,info);
};
$hxClasses["mcore.exception.TypeException"] = mcore.exception.TypeException;
mcore.exception.TypeException.__name__ = ["mcore","exception","TypeException"];
mcore.exception.TypeException.__super__ = mcore.exception.Exception;
mcore.exception.TypeException.prototype = $extend(mcore.exception.Exception.prototype,{
	__class__: mcore.exception.TypeException
});
mcore.util = {};
mcore.util.Arrays = function() { };
$hxClasses["mcore.util.Arrays"] = mcore.util.Arrays;
mcore.util.Arrays.__name__ = ["mcore","util","Arrays"];
mcore.util.Arrays.toString = function(source) {
	return source.toString();
};
mcore.util.Arrays.shuffle = function(source) {
	var copy = source.slice();
	var shuffled = [];
	while(copy.length > 0) shuffled.push(copy.splice(Std.random(copy.length),1)[0]);
	return shuffled;
};
mcore.util.Arrays.lastItem = function(source) {
	return source[source.length - 1];
};
mcore.util.Colors = function() { };
$hxClasses["mcore.util.Colors"] = mcore.util.Colors;
mcore.util.Colors.__name__ = ["mcore","util","Colors"];
mcore.util.Colors.hexToRGB = function(color) {
	return [(color & 16711680) >> 16,(color & 65280) >> 8,color & 255];
};
mcore.util.Colors.rgbToHex = function(red,green,blue) {
	return red << 16 | green << 8 | blue;
};
mcore.util.Colors.rgbStyle = function(color) {
	var rgb_0 = (color & 16711680) >> 16;
	var rgb_1 = (color & 65280) >> 8;
	var rgb_2 = color & 255;
	return "rgb(" + rgb_0 + "," + rgb_1 + "," + rgb_2 + ")";
};
mcore.util.Colors.rgbaStyle = function(color,alpha) {
	var rgb_0 = (color & 16711680) >> 16;
	var rgb_1 = (color & 65280) >> 8;
	var rgb_2 = color & 255;
	return "rgba(" + rgb_0 + "," + rgb_1 + "," + rgb_2 + "," + alpha + ")";
};
mcore.util.Colors.rgbaStyleToHex = function(rgbStyle) {
	var rgbColorsStr;
	var rgbColorsArr;
	var pos = rgbStyle.indexOf("(") + 1;
	rgbColorsStr = HxOverrides.substr(rgbStyle,pos,11);
	rgbColorsArr = rgbColorsStr.split(",");
	return StringTools.hex(mcore.util.Colors.rgbToHex(Std.parseInt(rgbColorsArr[0]),Std.parseInt(rgbColorsArr[1]),Std.parseInt(rgbColorsArr[2])),6);
};
mcore.util.Dynamics = function() { };
$hxClasses["mcore.util.Dynamics"] = mcore.util.Dynamics;
mcore.util.Dynamics.__name__ = ["mcore","util","Dynamics"];
mcore.util.Dynamics.copy = function(object) {
	return mcore.util.Dynamics.merge({ },object);
};
mcore.util.Dynamics.merge = function(to,from,overwrite,copyNulls) {
	if(copyNulls == null) copyNulls = true;
	if(overwrite == null) overwrite = true;
	var fromFields = mcore.util.Reflection.getFields(from);
	var _g = 0;
	while(_g < fromFields.length) {
		var field = fromFields[_g];
		++_g;
		var fromField = Reflect.field(from,field);
		var toField = Reflect.field(to,field);
		if(!(typeof(fromField) == "string") && !((fromField instanceof Array) && fromField.__enum__ == null) && (Type["typeof"](fromField) == ValueType.TObject || Type.getClass(fromField) != null)) {
			if(Type["typeof"](toField) != ValueType.TObject) {
				if(overwrite) {
					toField = { };
					to[field] = toField;
					mcore.util.Dynamics.merge(toField,fromField,overwrite);
				}
			} else mcore.util.Dynamics.merge(toField,fromField,overwrite);
		} else if(toField == null || overwrite && !Reflect.isFunction(toField)) {
			if(fromField != null || copyNulls) Reflect.setProperty(to,field,fromField);
		}
	}
	return to;
};
mcore.util.Dynamics.resolve = function(object,field) {
	var fields = field.split(".");
	while(fields.length > 0) {
		field = fields.shift();
		if(Object.prototype.hasOwnProperty.call(object,field)) object = Reflect.field(object,field); else throw new mcore.exception.TypeException("Field " + field + " not found on object " + Std.string(object),null,{ fileName : "Dynamics.hx", lineNumber : 122, className : "mcore.util.Dynamics", methodName : "resolve"});
	}
	return object;
};
mcore.util.Floats = function() { };
$hxClasses["mcore.util.Floats"] = mcore.util.Floats;
mcore.util.Floats.__name__ = ["mcore","util","Floats"];
mcore.util.Floats.toString = function(value) {
	if(value == null) return "null"; else return "" + value;
};
mcore.util.Floats.clamp = function(value,minimum,maximum) {
	if(value < minimum) return minimum; else if(value > maximum) return maximum; else return value;
};
mcore.util.Floats.wrap = function(value,minimum,maximum) {
	var index = value - minimum;
	var length = maximum - minimum;
	if(index < 0) index = length + index % length;
	if(index >= length) index %= length;
	return minimum + index;
};
mcore.util.Floats.round = function(value,precision) {
	value = value * Math.pow(10,precision);
	return Math.round(value) / Math.pow(10,precision);
};
mcore.util.Iterables = function() { };
$hxClasses["mcore.util.Iterables"] = mcore.util.Iterables;
mcore.util.Iterables.__name__ = ["mcore","util","Iterables"];
mcore.util.Iterables.contains = function(iterable,value) {
	return mcore.util.Iterables.indexOf(iterable,value) != -1;
};
mcore.util.Iterables.indexOf = function(iterable,value) {
	var i = 0;
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		if(member == value) return i;
		i++;
	}
	return -1;
};
mcore.util.Iterables.find = function(iterable,predicate) {
	var item = null;
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		if(predicate(member)) {
			item = member;
			break;
		}
	}
	return item;
};
mcore.util.Iterables.filter = function(iterable,predicate) {
	var items = [];
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		if(predicate(member)) items.push(member);
	}
	return items;
};
mcore.util.Iterables.concat = function(iterableA,iterableB) {
	var items = [];
	var _g = 0;
	var _g1 = [iterableA,iterableB];
	while(_g < _g1.length) {
		var iterable = _g1[_g];
		++_g;
		var $it0 = $iterator(iterable)();
		while( $it0.hasNext() ) {
			var item = $it0.next();
			items.push(item);
		}
	}
	return items;
};
mcore.util.Iterables.map = function(iterable,selector) {
	var items = [];
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		items.push(selector(item));
	}
	return items;
};
mcore.util.Iterables.mapWithIndex = function(iterable,selector) {
	var items = [];
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		items.push(selector(item,items.length));
	}
	return items;
};
mcore.util.Iterables.fold = function(iterable,aggregator,seed) {
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		seed = aggregator(member,seed);
	}
	return seed;
};
mcore.util.Iterables.foldRight = function(iterable,aggregator,seed) {
	return mcore.util.Iterables.fold(mcore.util.Iterables.reverse(iterable),aggregator,seed);
};
mcore.util.Iterables.reverse = function(iterable) {
	var items = [];
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		items.unshift(member);
	}
	return items;
};
mcore.util.Iterables.isEmpty = function(iterable) {
	return !$iterator(iterable)().hasNext();
};
mcore.util.Iterables.toArray = function(iterable) {
	var result = [];
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		result.push(member);
	}
	return result;
};
mcore.util.Iterables.toIterable = function(iterator) {
	return { iterator : function() {
		return iterator;
	}};
};
mcore.util.Iterables.size = function(iterable) {
	var i = 0;
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		i++;
	}
	return i;
};
mcore.util.Iterables.count = function(iterable,predicate) {
	var i = 0;
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var member = $it0.next();
		if(predicate(member)) i++;
	}
	return i;
};
mcore.util.Reflection = function() { };
$hxClasses["mcore.util.Reflection"] = mcore.util.Reflection;
mcore.util.Reflection.__name__ = ["mcore","util","Reflection"];
mcore.util.Reflection.setProperty = function(object,property,value) {
	Reflect.setProperty(object,property,value);
	return value;
};
mcore.util.Reflection.hasProperty = function(object,property) {
	var properties = Type.getInstanceFields(Type.getClass(object));
	return Lambda.has(properties,property);
};
mcore.util.Reflection.getFields = function(object) {
	{
		var _g = Type["typeof"](object);
		switch(_g[1]) {
		case 6:
			var c = _g[2];
			return Type.getInstanceFields(c);
		default:
			return Reflect.fields(object);
		}
	}
};
mcore.util.Reflection.here = function(info) {
	return info;
};
mcore.util.Reflection.callMethod = function(o,func,args) {
	if(args == null) args = [];
	try {
		return func.apply(o,args);
	} catch( e ) {
		throw new mcore.exception.Exception("Error calling method " + Type.getClassName(Type.getClass(o)) + "." + Std.string(func) + "(" + args.toString() + ")",e,{ fileName : "Reflection.hx", lineNumber : 111, className : "mcore.util.Reflection", methodName : "callMethod"});
	}
};
mcore.util.Types = function() { };
$hxClasses["mcore.util.Types"] = mcore.util.Types;
mcore.util.Types.__name__ = ["mcore","util","Types"];
mcore.util.Types.isSubClassOf = function(object,type) {
	return js.Boot.__instanceof(object,type) && Type.getClass(object) != type;
};
mcore.util.Types.createInstance = function(forClass,args) {
	if(args == null) args = [];
	try {
		return Type.createInstance(forClass,args);
	} catch( e ) {
		throw new mcore.exception.Exception("Error creating instance of " + Type.getClassName(forClass) + "(" + args.toString() + ")",e,{ fileName : "Types.hx", lineNumber : 65, className : "mcore.util.Types", methodName : "createInstance"});
	}
};
mdata.CollectionBase = function() {
	this.source = [];
	this.set_eventsEnabled(true);
	this.changed = new msignal.EventSignal(this);
};
$hxClasses["mdata.CollectionBase"] = mdata.CollectionBase;
mdata.CollectionBase.__name__ = ["mdata","CollectionBase"];
mdata.CollectionBase.__interfaces__ = [mdata.Collection];
mdata.CollectionBase.prototype = {
	changed: null
	,get_changed: function() {
		return this.changed;
	}
	,eventsEnabled: null
	,get_eventsEnabled: function() {
		return this.eventsEnabled;
	}
	,set_eventsEnabled: function(value) {
		return this.eventsEnabled = value;
	}
	,size: null
	,get_size: function() {
		return this.source.length;
	}
	,source: null
	,add: function(value) {
		this.source.push(value);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Add([value]));
	}
	,notifyChanged: function(eventType,payload) {
		this.get_changed().dispatchType(eventType);
	}
	,addAll: function(values) {
		if(values == null) return;
		var s = this.source.length;
		var $it0 = $iterator(values)();
		while( $it0.hasNext() ) {
			var value = $it0.next();
			this.source.push(value);
		}
		if(this.get_eventsEnabled() && this.source.length != s) {
			var v;
			if((values instanceof Array) && values.__enum__ == null) v = values; else v = mcore.util.Iterables.toArray(values);
			this.notifyChanged(mdata.CollectionEventType.Add(v));
		}
	}
	,clear: function() {
		if(this.isEmpty()) return;
		var values = this.source.splice(0,this.source.length);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Remove(values));
	}
	,contains: function(value) {
		return mcore.util.Iterables.indexOf(this.source,value) != -1;
	}
	,isEmpty: function() {
		return this.source.length == 0;
	}
	,iterator: function() {
		return HxOverrides.iter(this.source);
	}
	,remove: function(value) {
		var hasChanged = false;
		var i = this.source.length;
		var removed = [];
		while(i-- > 0) if(this.source[i] == value) {
			removed.push(this.source.splice(i,1)[0]);
			hasChanged = true;
			break;
		}
		if(this.get_eventsEnabled() && hasChanged) this.notifyChanged(mdata.CollectionEventType.Remove(removed));
		return hasChanged;
	}
	,removeAll: function(values) {
		var removed = [];
		var $it0 = $iterator(values)();
		while( $it0.hasNext() ) {
			var value = $it0.next();
			var i = this.source.length;
			while(i-- > 0) if(this.source[i] == value) removed.push(this.source.splice(i,1)[0]);
		}
		if(this.get_eventsEnabled() && removed.length > 0) this.notifyChanged(mdata.CollectionEventType.Remove(removed));
		return removed.length > 0;
	}
	,toArray: function() {
		return this.source.slice();
	}
	,toString: function() {
		return this.source.toString();
	}
	,__class__: mdata.CollectionBase
	,__properties__: {get_size:"get_size",set_eventsEnabled:"set_eventsEnabled",get_eventsEnabled:"get_eventsEnabled",get_changed:"get_changed"}
};
mdata.ArrayList = function(values) {
	mdata.CollectionBase.call(this);
	if(values != null) this.addAll(values);
};
$hxClasses["mdata.ArrayList"] = mdata.ArrayList;
mdata.ArrayList.__name__ = ["mdata","ArrayList"];
mdata.ArrayList.__interfaces__ = [mdata.List];
mdata.ArrayList.__super__ = mdata.CollectionBase;
mdata.ArrayList.prototype = $extend(mdata.CollectionBase.prototype,{
	first: null
	,get_first: function() {
		if(this.isEmpty()) throw mcore.exception.RangeException.numeric(0,0,0);
		return this.source[0];
	}
	,last: null
	,get_last: function() {
		if(this.isEmpty()) throw mcore.exception.RangeException.numeric(0,0,0);
		return this.source[this.get_size() - 1];
	}
	,length: null
	,get_length: function() {
		return this.source.length;
	}
	,add: function(value) {
		this.source.push(value);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Add([value]),mdata.ChangeLocation.Indices([this.source.length - 1]));
	}
	,addAll: function(values) {
		if(values == null) return;
		var s = this.source.length;
		var $it0 = $iterator(values)();
		while( $it0.hasNext() ) {
			var value = $it0.next();
			this.source.push(value);
		}
		if(this.get_eventsEnabled() && this.source.length != s) {
			var v;
			if((values instanceof Array) && values.__enum__ == null) v = values; else v = mcore.util.Iterables.toArray(values);
			this.notifyChanged(mdata.CollectionEventType.Add(v),mdata.ChangeLocation.Range(s,this.source.length));
		}
	}
	,insert: function(index,value) {
		if(index < 0 || index > this.get_size()) throw mcore.exception.RangeException.numeric(index,0,this.get_size());
		this.source.splice(index,0,value);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Add([value]),mdata.ChangeLocation.Indices([index]));
	}
	,insertAll: function(index,values) {
		if(index < 0 || index > this.get_size()) throw mcore.exception.RangeException.numeric(index,0,this.get_size());
		var i = index;
		var $it0 = $iterator(values)();
		while( $it0.hasNext() ) {
			var value = $it0.next();
			var pos = i++;
			this.source.splice(pos,0,value);
		}
		if(this.get_eventsEnabled() && i != index) {
			var v;
			if((values instanceof Array) && values.__enum__ == null) v = values; else v = mcore.util.Iterables.toArray(values);
			this.notifyChanged(mdata.CollectionEventType.Add(v),mdata.ChangeLocation.Range(index,i));
		}
	}
	,set: function(index,value) {
		if(index < 0 || index > this.get_size()) throw mcore.exception.RangeException.numeric(index,0,this.get_size());
		var item = this.source[index];
		this.source[index] = value;
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Replace([item]),mdata.ChangeLocation.Indices([index]));
		return item;
	}
	,setAll: function(index,values) {
		var count = mcore.util.Iterables.size(values);
		var max = index + count;
		if(index < 0) throw mcore.exception.RangeException.numeric(index,0,this.get_size()); else if(max > this.get_size()) throw mcore.exception.RangeException.numeric(max,0,this.get_size());
		var removed = [];
		if(count > 0) {
			var i = index;
			var $it0 = $iterator(values)();
			while( $it0.hasNext() ) {
				var value = $it0.next();
				removed.push(this.source[i]);
				this.source[i++] = value;
			}
			if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Replace(removed),mdata.ChangeLocation.Range(index,max));
		}
		return removed;
	}
	,get: function(index) {
		if(index < 0 || index >= this.get_size()) throw mcore.exception.RangeException.numeric(index,0,this.get_size());
		return this.source[index];
	}
	,indexOf: function(value) {
		var _g1 = 0;
		var _g = this.source.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.source[i] == value) return i;
		}
		return -1;
	}
	,lastIndexOf: function(value) {
		var i = this.source.length;
		while(i-- > 0) if(this.source[i] == value) return i;
		return -1;
	}
	,clear: function() {
		if(this.isEmpty()) return;
		var s = this.source.length;
		var values = this.source.splice(0,this.source.length);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Remove(values),mdata.ChangeLocation.Range(0,s));
	}
	,notifyChanged: function(eventType,payload) {
		this.get_changed().dispatch(new mdata.ListEvent(eventType,payload));
	}
	,removeAt: function(index) {
		if(index < 0 || index >= this.get_size()) throw mcore.exception.RangeException.numeric(index,0,this.get_size());
		var value = this.source.splice(index,1);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Remove(value),mdata.ChangeLocation.Indices([index]));
		return value[0];
	}
	,remove: function(value) {
		var index = -1;
		var removed = null;
		var _g1 = 0;
		var _g = this.source.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.source[i] == value) {
				index = i;
				removed = this.source.splice(i,1);
				break;
			}
		}
		if(this.get_eventsEnabled() && index != -1) this.notifyChanged(mdata.CollectionEventType.Remove(removed),mdata.ChangeLocation.Indices([index]));
		return index != -1;
	}
	,removeRange: function(startIndex,endIndex) {
		if(startIndex < 0 || startIndex >= this.get_size()) throw mcore.exception.RangeException.numeric(startIndex,0,this.get_size()); else if(endIndex == null || endIndex > this.get_size()) endIndex = this.get_size(); else if(endIndex < 0) endIndex = this.get_size() + endIndex;
		if(endIndex <= startIndex) return [];
		var removed = this.source.splice(startIndex,endIndex - startIndex);
		if(this.get_eventsEnabled()) this.notifyChanged(mdata.CollectionEventType.Remove(removed),mdata.ChangeLocation.Range(startIndex,endIndex));
		return removed;
	}
	,removeAll: function(values) {
		if(values == null) return false;
		var removed = [];
		var indices = [];
		var i = this.source.length;
		while(i-- > 0) {
			var $it0 = $iterator(values)();
			while( $it0.hasNext() ) {
				var value = $it0.next();
				if(this.source[i] == value) {
					removed.push(this.source.splice(i,1)[0]);
					indices.unshift(i);
					break;
				}
			}
		}
		if(this.get_eventsEnabled() && removed.length > 0) this.notifyChanged(mdata.CollectionEventType.Remove(removed),mdata.ChangeLocation.Indices(indices));
		return removed.length > 0;
	}
	,__class__: mdata.ArrayList
	,__properties__: $extend(mdata.CollectionBase.prototype.__properties__,{get_length:"get_length",get_last:"get_last",get_first:"get_first"})
});
mdata.CollectionEventType = { __ename__ : ["mdata","CollectionEventType"], __constructs__ : ["Add","Remove","Replace"] };
mdata.CollectionEventType.Add = function(items) { var $x = ["Add",0,items]; $x.__enum__ = mdata.CollectionEventType; $x.toString = $estr; return $x; };
mdata.CollectionEventType.Remove = function(items) { var $x = ["Remove",1,items]; $x.__enum__ = mdata.CollectionEventType; $x.toString = $estr; return $x; };
mdata.CollectionEventType.Replace = function(items) { var $x = ["Replace",2,items]; $x.__enum__ = mdata.CollectionEventType; $x.toString = $estr; return $x; };
mdata.Collections = function() {
};
$hxClasses["mdata.Collections"] = mdata.Collections;
mdata.Collections.__name__ = ["mdata","Collections"];
mdata.Collections.filter = function(collection,predicate) {
	var removedValues = [];
	var $it0 = collection.iterator();
	while( $it0.hasNext() ) {
		var item = $it0.next();
		if(!predicate(item)) removedValues.push(item);
	}
	collection.removeAll(removedValues);
};
mdata.Collections.copy = function(collection) {
	var type = Type.getClass(collection);
	var slist = null;
	if(type == mdata.SelectableList) {
		slist = collection;
		type = Type.getClass(slist.source);
	}
	var copy = null;
	copy = Type.createInstance(type,[]);
	copy.addAll(collection.toArray());
	if(slist != null) copy = new mdata.SelectableList(copy);
	return copy;
};
mdata.Collections.sort = function(list,comparator) {
	if(comparator == null) comparator = mdata.Collections.DEFAULT_COMPARATOR;
	if(!list.get_eventsEnabled() && Object.prototype.hasOwnProperty.call(list,"source") && ((list.source instanceof Array) && list.source.__enum__ == null)) list.source.sort(comparator); else {
		var array = list.toArray();
		array.sort(comparator);
		list.setAll(0,array);
	}
};
mdata.Collections.DEFAULT_COMPARATOR = function(a,b) {
	if(a > b) return 1;
	if(a < b) return -1;
	return 0;
};
mdata.Collections.binarySearch = function(list,needle,comparator) {
	if(comparator == null) comparator = mdata.Collections.DEFAULT_COMPARATOR;
	var min = 0;
	var max = list.get_length() - 1;
	while(min <= max) {
		var mid = min + max >>> 1;
		var cmp = comparator(list.get(mid),needle);
		if(cmp < 0) min = mid + 1; else if(cmp > 0) max = mid - 1; else return mid;
	}
	return -1;
};
mdata.Collections.reverse = function(list) {
	if(!list.get_eventsEnabled() && Object.prototype.hasOwnProperty.call(list,"source") && ((list.source instanceof Array) && list.source.__enum__ == null)) list.source.reverse(); else {
		var a = list.toArray();
		a.reverse();
		list.setAll(0,a);
	}
};
mdata.Collections.shuffle = function(list) {
	var a = mcore.util.Arrays.shuffle(list.toArray());
	list.setAll(0,a);
};
mdata.Collections.prototype = {
	__class__: mdata.Collections
};
mdata.Dictionary = function(weakKeys) {
	if(weakKeys == null) weakKeys = false;
	this.weakKeys = weakKeys;
	this.clear();
};
$hxClasses["mdata.Dictionary"] = mdata.Dictionary;
mdata.Dictionary.__name__ = ["mdata","Dictionary"];
mdata.Dictionary.prototype = {
	_keys: null
	,_values: null
	,weakKeys: null
	,set: function(key,value) {
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) {
				this._keys[i] = key;
				this._values[i] = value;
				return;
			}
		}
		this._keys.push(key);
		this._values.push(value);
	}
	,get: function(key) {
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) return this._values[i];
		}
		return null;
	}
	,remove: function(key) {
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) {
				this._keys.splice(i,1);
				this._values.splice(i,1);
				return true;
			}
		}
		return false;
	}
	,'delete': function(key) {
		this.remove(key);
	}
	,exists: function(key) {
		var _g = 0;
		var _g1 = this._keys;
		while(_g < _g1.length) {
			var k = _g1[_g];
			++_g;
			if(k == key) return true;
		}
		return false;
	}
	,clear: function() {
		this._keys = [];
		this._values = [];
	}
	,keys: function() {
		return HxOverrides.iter(this._keys);
	}
	,iterator: function() {
		return HxOverrides.iter(this._values);
	}
	,toString: function() {
		var s = "{";
		var $it0 = this.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			var value = this.get(key);
			var k;
			if((key instanceof Array) && key.__enum__ == null) k = "[" + key.toString() + "]"; else k = Std.string(key);
			var v;
			if((value instanceof Array) && value.__enum__ == null) v = "[" + value.toString() + "]"; else v = Std.string(value);
			s += k + " => " + v + ", ";
		}
		if(s.length > 2) s = HxOverrides.substr(s,0,s.length - 2);
		return s + "}";
	}
	,__class__: mdata.Dictionary
};
mdata.ChangeLocation = { __ename__ : ["mdata","ChangeLocation"], __constructs__ : ["Range","Indices"] };
mdata.ChangeLocation.Range = function(start,end) { var $x = ["Range",0,start,end]; $x.__enum__ = mdata.ChangeLocation; $x.toString = $estr; return $x; };
mdata.ChangeLocation.Indices = function(i) { var $x = ["Indices",1,i]; $x.__enum__ = mdata.ChangeLocation; $x.toString = $estr; return $x; };
msignal.Event = function(type) {
	this.type = type;
};
$hxClasses["msignal.Event"] = msignal.Event;
msignal.Event.__name__ = ["msignal","Event"];
msignal.Event.prototype = {
	signal: null
	,target: null
	,type: null
	,currentTarget: null
	,__class__: msignal.Event
};
mdata.ListEvent = function(type,location) {
	msignal.Event.call(this,type);
	this.location = location;
};
$hxClasses["mdata.ListEvent"] = mdata.ListEvent;
mdata.ListEvent.__name__ = ["mdata","ListEvent"];
mdata.ListEvent.__super__ = msignal.Event;
mdata.ListEvent.prototype = $extend(msignal.Event.prototype,{
	location: null
	,__class__: mdata.ListEvent
});
var minject = {};
minject.InjectionConfig = function(request,injectionName) {
	this.request = request;
	this.injectionName = injectionName;
};
$hxClasses["minject.InjectionConfig"] = minject.InjectionConfig;
minject.InjectionConfig.__name__ = ["minject","InjectionConfig"];
minject.InjectionConfig.prototype = {
	request: null
	,injectionName: null
	,injector: null
	,result: null
	,getResponse: function(injector) {
		if(this.injector != null) injector = this.injector;
		if(this.result != null) return this.result.getResponse(injector);
		var parentConfig = injector.getAncestorMapping(this.request,this.injectionName);
		if(parentConfig != null) return parentConfig.getResponse(injector);
		return null;
	}
	,hasResponse: function(injector) {
		return this.result != null;
	}
	,hasOwnResponse: function() {
		return this.result != null;
	}
	,setResult: function(result) {
		if(this.result != null && result != null) haxe.Log.trace("Warning: Injector contains " + Std.string(this) + "." + "\nAttempting to overwrite this with mapping for [" + Std.string(result) + "]." + "\nIf you have overwritten this mapping intentionally " + "you can use \"injector.unmap()\" prior to your replacement " + "mapping in order to avoid seeing this message.",{ fileName : "InjectionConfig.hx", lineNumber : 74, className : "minject.InjectionConfig", methodName : "setResult"});
		this.result = result;
	}
	,setInjector: function(injector) {
		this.injector = injector;
	}
	,toString: function() {
		var named;
		if(this.injectionName != null && this.injectionName != "") named = " named \"" + this.injectionName + "\" and"; else named = "";
		return "rule: [" + Type.getClassName(this.request) + "]" + named + " mapped to [" + Std.string(this.result) + "]";
	}
	,__class__: minject.InjectionConfig
};
minject.Injector = function() {
	this.injectionConfigs = new haxe.ds.StringMap();
	this.injecteeDescriptions = new minject.ClassHash();
	this.attendedToInjectees = new minject._Injector.InjecteeSet();
};
$hxClasses["minject.Injector"] = minject.Injector;
minject.Injector.__name__ = ["minject","Injector"];
minject.Injector.prototype = {
	attendedToInjectees: null
	,parentInjector: null
	,injectionConfigs: null
	,injecteeDescriptions: null
	,mapValue: function(whenAskedFor,useValue,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new minject.result.InjectValueResult(useValue));
		return config;
	}
	,mapClass: function(whenAskedFor,instantiateClass,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new minject.result.InjectClassResult(instantiateClass));
		return config;
	}
	,mapSingleton: function(whenAskedFor,named) {
		if(named == null) named = "";
		return this.mapSingletonOf(whenAskedFor,whenAskedFor,named);
	}
	,mapSingletonOf: function(whenAskedFor,useSingletonOf,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new minject.result.InjectSingletonResult(useSingletonOf));
		return config;
	}
	,mapRule: function(whenAskedFor,useRule,named) {
		if(named == null) named = "";
		var config = this.getMapping(whenAskedFor,named);
		config.setResult(new minject.result.InjectOtherRuleResult(useRule));
		return useRule;
	}
	,getMapping: function(forClass,named) {
		if(named == null) named = "";
		var requestName = this.getClassName(forClass) + "#" + named;
		if(this.injectionConfigs.exists(requestName)) return this.injectionConfigs.get(requestName);
		var config = new minject.InjectionConfig(forClass,named);
		this.injectionConfigs.set(requestName,config);
		return config;
	}
	,injectInto: function(target) {
		if(this.attendedToInjectees.contains(target)) return;
		this.attendedToInjectees.add(target);
		var targetClass = Type.getClass(target);
		var injecteeDescription = null;
		if(this.injecteeDescriptions.exists(targetClass)) injecteeDescription = this.injecteeDescriptions.get(targetClass); else injecteeDescription = this.getInjectionPoints(targetClass);
		if(injecteeDescription == null) return;
		var injectionPoints = injecteeDescription.injectionPoints;
		var length = injectionPoints.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var injectionPoint = injectionPoints[i];
			injectionPoint.applyInjection(target,this);
		}
	}
	,construct: function(theClass) {
		var injecteeDescription;
		if(this.injecteeDescriptions.exists(theClass)) injecteeDescription = this.injecteeDescriptions.get(theClass); else injecteeDescription = this.getInjectionPoints(theClass);
		var injectionPoint = injecteeDescription.ctor;
		return injectionPoint.applyInjection(theClass,this);
	}
	,instantiate: function(theClass) {
		var instance = this.construct(theClass);
		this.injectInto(instance);
		return instance;
	}
	,unmap: function(theClass,named) {
		if(named == null) named = "";
		var mapping = this.getConfigurationForRequest(theClass,named);
		if(mapping == null) throw "Error while removing an injector mapping: No mapping defined for class " + this.getClassName(theClass) + ", named \"" + named + "\"";
		mapping.setResult(null);
	}
	,hasMapping: function(forClass,named) {
		if(named == null) named = "";
		var mapping = this.getConfigurationForRequest(forClass,named);
		if(mapping == null) return false;
		return mapping.hasResponse(this);
	}
	,getInstance: function(ofClass,named) {
		if(named == null) named = "";
		var mapping = this.getConfigurationForRequest(ofClass,named);
		if(mapping == null || !mapping.hasResponse(this)) throw "Error while getting mapping response: No mapping defined for class " + this.getClassName(ofClass) + ", named \"" + named + "\"";
		return mapping.getResponse(this);
	}
	,createChildInjector: function() {
		var injector = new minject.Injector();
		injector.set_parentInjector(this);
		return injector;
	}
	,getAncestorMapping: function(forClass,named) {
		var parent = this.parentInjector;
		while(parent != null) {
			var parentConfig = parent.getConfigurationForRequest(forClass,named,false);
			if(parentConfig != null && parentConfig.hasOwnResponse()) return parentConfig;
			parent = parent.parentInjector;
		}
		return null;
	}
	,getInjectionPoints: function(forClass) {
		var typeMeta = haxe.rtti.Meta.getType(forClass);
		if(typeMeta != null && Object.prototype.hasOwnProperty.call(typeMeta,"interface")) throw "Interfaces can't be used as instantiatable classes.";
		var fieldsMeta = this.getFields(forClass);
		var ctorInjectionPoint = null;
		var injectionPoints = [];
		var postConstructMethodPoints = [];
		var _g = 0;
		var _g1 = Reflect.fields(fieldsMeta);
		while(_g < _g1.length) {
			var field = _g1[_g];
			++_g;
			var fieldMeta = Reflect.field(fieldsMeta,field);
			var inject = Object.prototype.hasOwnProperty.call(fieldMeta,"inject");
			var post = Object.prototype.hasOwnProperty.call(fieldMeta,"post");
			var type = Reflect.field(fieldMeta,"type");
			var args = Reflect.field(fieldMeta,"args");
			if(field == "_") {
				if(args.length > 0) ctorInjectionPoint = new minject.point.ConstructorInjectionPoint(fieldMeta,forClass,this);
			} else if(Object.prototype.hasOwnProperty.call(fieldMeta,"args")) {
				if(inject) {
					var injectionPoint = new minject.point.MethodInjectionPoint(fieldMeta,this);
					injectionPoints.push(injectionPoint);
				} else if(post) {
					var injectionPoint1 = new minject.point.PostConstructInjectionPoint(fieldMeta,this);
					postConstructMethodPoints.push(injectionPoint1);
				}
			} else if(type != null) {
				var injectionPoint2 = new minject.point.PropertyInjectionPoint(fieldMeta,this);
				injectionPoints.push(injectionPoint2);
			}
		}
		if(postConstructMethodPoints.length > 0) {
			postConstructMethodPoints.sort(function(a,b) {
				return a.order - b.order;
			});
			var _g2 = 0;
			while(_g2 < postConstructMethodPoints.length) {
				var point = postConstructMethodPoints[_g2];
				++_g2;
				injectionPoints.push(point);
			}
		}
		if(ctorInjectionPoint == null) ctorInjectionPoint = new minject.point.NoParamsConstructorInjectionPoint();
		var injecteeDescription = new minject.InjecteeDescription(ctorInjectionPoint,injectionPoints);
		this.injecteeDescriptions.set(forClass,injecteeDescription);
		return injecteeDescription;
	}
	,getConfigurationForRequest: function(forClass,named,traverseAncestors) {
		if(traverseAncestors == null) traverseAncestors = true;
		var requestName = this.getClassName(forClass) + "#" + named;
		if(!this.injectionConfigs.exists(requestName)) {
			if(traverseAncestors && this.parentInjector != null && this.parentInjector.hasMapping(forClass,named)) return this.getAncestorMapping(forClass,named);
			return null;
		}
		return this.injectionConfigs.get(requestName);
	}
	,set_parentInjector: function(value) {
		if(this.parentInjector != null && value == null) this.attendedToInjectees = new minject._Injector.InjecteeSet();
		this.parentInjector = value;
		if(this.parentInjector != null) this.attendedToInjectees = this.parentInjector.attendedToInjectees;
		return this.parentInjector;
	}
	,getClassName: function(forClass) {
		if(forClass == null) return "Dynamic"; else return Type.getClassName(forClass);
	}
	,getFields: function(type) {
		var meta = { };
		while(type != null) {
			var typeMeta = haxe.rtti.Meta.getFields(type);
			var _g = 0;
			var _g1 = Reflect.fields(typeMeta);
			while(_g < _g1.length) {
				var field = _g1[_g];
				++_g;
				Reflect.setField(meta,field,Reflect.field(typeMeta,field));
			}
			type = Type.getSuperClass(type);
		}
		return meta;
	}
	,__class__: minject.Injector
	,__properties__: {set_parentInjector:"set_parentInjector"}
};
minject._Injector = {};
minject._Injector.InjecteeSet = function() {
};
$hxClasses["minject._Injector.InjecteeSet"] = minject._Injector.InjecteeSet;
minject._Injector.InjecteeSet.__name__ = ["minject","_Injector","InjecteeSet"];
minject._Injector.InjecteeSet.prototype = {
	add: function(value) {
		value.__injected__ = true;
	}
	,contains: function(value) {
		return value.__injected__ == true;
	}
	,'delete': function(value) {
		Reflect.deleteField(value,"__injected__");
	}
	,iterator: function() {
		return HxOverrides.iter([]);
	}
	,__class__: minject._Injector.InjecteeSet
};
minject.ClassHash = function() {
	this.hash = new haxe.ds.StringMap();
};
$hxClasses["minject.ClassHash"] = minject.ClassHash;
minject.ClassHash.__name__ = ["minject","ClassHash"];
minject.ClassHash.prototype = {
	hash: null
	,set: function(key,value) {
		this.hash.set(Type.getClassName(key),value);
	}
	,get: function(key) {
		return this.hash.get(Type.getClassName(key));
	}
	,exists: function(key) {
		return this.hash.exists(Type.getClassName(key));
	}
	,__class__: minject.ClassHash
};
minject.InjecteeDescription = function(ctor,injectionPoints) {
	this.ctor = ctor;
	this.injectionPoints = injectionPoints;
};
$hxClasses["minject.InjecteeDescription"] = minject.InjecteeDescription;
minject.InjecteeDescription.__name__ = ["minject","InjecteeDescription"];
minject.InjecteeDescription.prototype = {
	ctor: null
	,injectionPoints: null
	,__class__: minject.InjecteeDescription
};
minject.Reflector = function() {
};
$hxClasses["minject.Reflector"] = minject.Reflector;
minject.Reflector.__name__ = ["minject","Reflector"];
minject.Reflector.prototype = {
	classExtendsOrImplements: function(classOrClassName,superClass) {
		var actualClass = null;
		if(js.Boot.__instanceof(classOrClassName,Class)) actualClass = js.Boot.__cast(classOrClassName , Class); else if(typeof(classOrClassName) == "string") try {
			actualClass = Type.resolveClass(js.Boot.__cast(classOrClassName , String));
		} catch( e ) {
			throw "The class name " + Std.string(classOrClassName) + " is not valid because of " + Std.string(e) + "\n" + Std.string(e.getStackTrace());
		}
		if(actualClass == null) throw "The parameter classOrClassName must be a Class or fully qualified class name.";
		var classInstance = Type.createEmptyInstance(actualClass);
		return js.Boot.__instanceof(classInstance,superClass);
	}
	,getClass: function(value) {
		if(js.Boot.__instanceof(value,Class)) return value;
		return Type.getClass(value);
	}
	,getFQCN: function(value) {
		var fqcn;
		if(typeof(value) == "string") return js.Boot.__cast(value , String);
		return Type.getClassName(value);
	}
	,__class__: minject.Reflector
};
minject.point = {};
minject.point.InjectionPoint = function(meta,injector) {
	this.initializeInjection(meta);
};
$hxClasses["minject.point.InjectionPoint"] = minject.point.InjectionPoint;
minject.point.InjectionPoint.__name__ = ["minject","point","InjectionPoint"];
minject.point.InjectionPoint.prototype = {
	applyInjection: function(target,injector) {
		return target;
	}
	,initializeInjection: function(meta) {
	}
	,__class__: minject.point.InjectionPoint
};
minject.point.MethodInjectionPoint = function(meta,injector) {
	this.requiredParameters = 0;
	minject.point.InjectionPoint.call(this,meta,injector);
};
$hxClasses["minject.point.MethodInjectionPoint"] = minject.point.MethodInjectionPoint;
minject.point.MethodInjectionPoint.__name__ = ["minject","point","MethodInjectionPoint"];
minject.point.MethodInjectionPoint.__super__ = minject.point.InjectionPoint;
minject.point.MethodInjectionPoint.prototype = $extend(minject.point.InjectionPoint.prototype,{
	methodName: null
	,_parameterInjectionConfigs: null
	,requiredParameters: null
	,applyInjection: function(target,injector) {
		var parameters = this.gatherParameterValues(target,injector);
		var method = Reflect.field(target,this.methodName);
		mcore.util.Reflection.callMethod(target,method,parameters);
		return target;
	}
	,initializeInjection: function(meta) {
		this.methodName = meta.name[0];
		this.gatherParameters(meta);
	}
	,gatherParameters: function(meta) {
		var nameArgs = meta.inject;
		var args = meta.args;
		if(nameArgs == null) nameArgs = [];
		this._parameterInjectionConfigs = [];
		var i = 0;
		var _g = 0;
		while(_g < args.length) {
			var arg = args[_g];
			++_g;
			var injectionName = "";
			if(i < nameArgs.length) injectionName = nameArgs[i];
			var parameterTypeName = arg.type;
			if(arg.opt) {
				if(parameterTypeName == "Dynamic") throw "Error in method definition of injectee. Required parameters can't have non class type.";
			} else this.requiredParameters++;
			this._parameterInjectionConfigs.push(new minject.point.ParameterInjectionConfig(parameterTypeName,injectionName));
			i++;
		}
	}
	,gatherParameterValues: function(target,injector) {
		var parameters = [];
		var length = this._parameterInjectionConfigs.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var parameterConfig = this._parameterInjectionConfigs[i];
			var config = injector.getMapping(Type.resolveClass(parameterConfig.typeName),parameterConfig.injectionName);
			var injection = config.getResponse(injector);
			if(injection == null) {
				if(i >= this.requiredParameters) break;
				throw "Injector is missing a rule to handle injection into target " + Type.getClassName(Type.getClass(target)) + ". Target dependency: " + Type.getClassName(config.request) + ", method: " + this.methodName + ", parameter: " + (i + 1) + ", named: " + parameterConfig.injectionName;
			}
			parameters[i] = injection;
		}
		return parameters;
	}
	,__class__: minject.point.MethodInjectionPoint
});
minject.point.ConstructorInjectionPoint = function(meta,forClass,injector) {
	minject.point.MethodInjectionPoint.call(this,meta,injector);
};
$hxClasses["minject.point.ConstructorInjectionPoint"] = minject.point.ConstructorInjectionPoint;
minject.point.ConstructorInjectionPoint.__name__ = ["minject","point","ConstructorInjectionPoint"];
minject.point.ConstructorInjectionPoint.__super__ = minject.point.MethodInjectionPoint;
minject.point.ConstructorInjectionPoint.prototype = $extend(minject.point.MethodInjectionPoint.prototype,{
	applyInjection: function(target,injector) {
		var ofClass = target;
		var withArgs = this.gatherParameterValues(target,injector);
		return mcore.util.Types.createInstance(ofClass,withArgs);
	}
	,initializeInjection: function(meta) {
		this.methodName = "new";
		this.gatherParameters(meta);
	}
	,__class__: minject.point.ConstructorInjectionPoint
});
minject.point.ParameterInjectionConfig = function(typeName,injectionName) {
	this.typeName = typeName;
	this.injectionName = injectionName;
};
$hxClasses["minject.point.ParameterInjectionConfig"] = minject.point.ParameterInjectionConfig;
minject.point.ParameterInjectionConfig.__name__ = ["minject","point","ParameterInjectionConfig"];
minject.point.ParameterInjectionConfig.prototype = {
	typeName: null
	,injectionName: null
	,__class__: minject.point.ParameterInjectionConfig
};
minject.point.NoParamsConstructorInjectionPoint = function() {
	minject.point.InjectionPoint.call(this,null,null);
};
$hxClasses["minject.point.NoParamsConstructorInjectionPoint"] = minject.point.NoParamsConstructorInjectionPoint;
minject.point.NoParamsConstructorInjectionPoint.__name__ = ["minject","point","NoParamsConstructorInjectionPoint"];
minject.point.NoParamsConstructorInjectionPoint.__super__ = minject.point.InjectionPoint;
minject.point.NoParamsConstructorInjectionPoint.prototype = $extend(minject.point.InjectionPoint.prototype,{
	applyInjection: function(target,injector) {
		return mcore.util.Types.createInstance(target,[]);
	}
	,__class__: minject.point.NoParamsConstructorInjectionPoint
});
minject.point.PostConstructInjectionPoint = function(meta,injector) {
	this.order = 0;
	minject.point.InjectionPoint.call(this,meta,injector);
};
$hxClasses["minject.point.PostConstructInjectionPoint"] = minject.point.PostConstructInjectionPoint;
minject.point.PostConstructInjectionPoint.__name__ = ["minject","point","PostConstructInjectionPoint"];
minject.point.PostConstructInjectionPoint.__super__ = minject.point.InjectionPoint;
minject.point.PostConstructInjectionPoint.prototype = $extend(minject.point.InjectionPoint.prototype,{
	order: null
	,methodName: null
	,applyInjection: function(target,injector) {
		mcore.util.Reflection.callMethod(target,Reflect.field(target,this.methodName),[]);
		return target;
	}
	,initializeInjection: function(meta) {
		this.methodName = meta.name[0];
		if(meta.post != null) this.order = meta.post[0];
	}
	,__class__: minject.point.PostConstructInjectionPoint
});
minject.point.PropertyInjectionPoint = function(meta,injector) {
	minject.point.InjectionPoint.call(this,meta,null);
};
$hxClasses["minject.point.PropertyInjectionPoint"] = minject.point.PropertyInjectionPoint;
minject.point.PropertyInjectionPoint.__name__ = ["minject","point","PropertyInjectionPoint"];
minject.point.PropertyInjectionPoint.__super__ = minject.point.InjectionPoint;
minject.point.PropertyInjectionPoint.prototype = $extend(minject.point.InjectionPoint.prototype,{
	propertyName: null
	,propertyType: null
	,injectionName: null
	,applyInjection: function(target,injector) {
		var injectionConfig = injector.getMapping(Type.resolveClass(this.propertyType),this.injectionName);
		var injection = injectionConfig.getResponse(injector);
		if(injection == null) throw "Injector is missing a rule to handle injection into property \"" + this.propertyName + "\" of object \"" + Std.string(target) + "\". Target dependency: \"" + this.propertyType + "\", named \"" + this.injectionName + "\"";
		Reflect.setProperty(target,this.propertyName,injection);
		return target;
	}
	,initializeInjection: function(meta) {
		this.propertyType = meta.type[0];
		this.propertyName = meta.name[0];
		if(meta.inject == null) this.injectionName = ""; else this.injectionName = meta.inject[0];
	}
	,__class__: minject.point.PropertyInjectionPoint
});
minject.result = {};
minject.result.InjectionResult = function() {
};
$hxClasses["minject.result.InjectionResult"] = minject.result.InjectionResult;
minject.result.InjectionResult.__name__ = ["minject","result","InjectionResult"];
minject.result.InjectionResult.prototype = {
	getResponse: function(injector) {
		return null;
	}
	,toString: function() {
		return "";
	}
	,__class__: minject.result.InjectionResult
};
minject.result.InjectClassResult = function(responseType) {
	minject.result.InjectionResult.call(this);
	this.responseType = responseType;
};
$hxClasses["minject.result.InjectClassResult"] = minject.result.InjectClassResult;
minject.result.InjectClassResult.__name__ = ["minject","result","InjectClassResult"];
minject.result.InjectClassResult.__super__ = minject.result.InjectionResult;
minject.result.InjectClassResult.prototype = $extend(minject.result.InjectionResult.prototype,{
	responseType: null
	,getResponse: function(injector) {
		return injector.instantiate(this.responseType);
	}
	,toString: function() {
		return "class " + Type.getClassName(this.responseType);
	}
	,__class__: minject.result.InjectClassResult
});
minject.result.InjectOtherRuleResult = function(rule) {
	minject.result.InjectionResult.call(this);
	this.rule = rule;
};
$hxClasses["minject.result.InjectOtherRuleResult"] = minject.result.InjectOtherRuleResult;
minject.result.InjectOtherRuleResult.__name__ = ["minject","result","InjectOtherRuleResult"];
minject.result.InjectOtherRuleResult.__super__ = minject.result.InjectionResult;
minject.result.InjectOtherRuleResult.prototype = $extend(minject.result.InjectionResult.prototype,{
	rule: null
	,getResponse: function(injector) {
		return this.rule.getResponse(injector);
	}
	,toString: function() {
		return this.rule.toString();
	}
	,__class__: minject.result.InjectOtherRuleResult
});
minject.result.InjectSingletonResult = function(responseType) {
	minject.result.InjectionResult.call(this);
	this.responseType = responseType;
};
$hxClasses["minject.result.InjectSingletonResult"] = minject.result.InjectSingletonResult;
minject.result.InjectSingletonResult.__name__ = ["minject","result","InjectSingletonResult"];
minject.result.InjectSingletonResult.__super__ = minject.result.InjectionResult;
minject.result.InjectSingletonResult.prototype = $extend(minject.result.InjectionResult.prototype,{
	responseType: null
	,response: null
	,getResponse: function(injector) {
		if(this.response == null) {
			this.response = this.createResponse(injector);
			injector.injectInto(this.response);
		}
		return this.response;
	}
	,createResponse: function(injector) {
		return injector.construct(this.responseType);
	}
	,toString: function() {
		return "singleton " + Type.getClassName(this.responseType);
	}
	,__class__: minject.result.InjectSingletonResult
});
minject.result.InjectValueResult = function(value) {
	minject.result.InjectionResult.call(this);
	this.value = value;
};
$hxClasses["minject.result.InjectValueResult"] = minject.result.InjectValueResult;
minject.result.InjectValueResult.__name__ = ["minject","result","InjectValueResult"];
minject.result.InjectValueResult.__super__ = minject.result.InjectionResult;
minject.result.InjectValueResult.prototype = $extend(minject.result.InjectionResult.prototype,{
	value: null
	,getResponse: function(injector) {
		return this.value;
	}
	,toString: function() {
		return "instance of " + Type.getClassName(Type.getClass(this.value));
	}
	,__class__: minject.result.InjectValueResult
});
var mloader = {};
mloader.Loader = function() { };
$hxClasses["mloader.Loader"] = mloader.Loader;
mloader.Loader.__name__ = ["mloader","Loader"];
mloader.Loader.prototype = {
	url: null
	,progress: null
	,content: null
	,loading: null
	,loaded: null
	,load: null
	,cancel: null
	,__class__: mloader.Loader
};
mloader.LoaderBase = function(url) {
	this.loaded = new msignal.EventSignal(this);
	this.set_url(this.sanitizeUrl(url));
	this.progress = 0;
	this.loading = false;
};
$hxClasses["mloader.LoaderBase"] = mloader.LoaderBase;
mloader.LoaderBase.__name__ = ["mloader","LoaderBase"];
mloader.LoaderBase.__interfaces__ = [mloader.Loader];
mloader.LoaderBase.prototype = {
	url: null
	,set_url: function(value) {
		if(value == this.url) return this.url;
		if(this.loading) this.cancel();
		return this.url = this.sanitizeUrl(value);
	}
	,content: null
	,loading: null
	,progress: null
	,loaded: null
	,load: function() {
		if(this.loading) return;
		if(this.url == null) throw "No url defined for Loader";
		this.loading = true;
		this.loaded.dispatchType(mloader.LoaderEventType.Start);
		this.loaderLoad();
	}
	,cancel: function() {
		if(!this.loading) return;
		this.loading = false;
		this.loaderCancel();
		this.progress = 0;
		this.content = null;
		this.loaded.dispatchType(mloader.LoaderEventType.Cancel);
	}
	,loaderLoad: function() {
		throw "missing implementation";
	}
	,loaderCancel: function() {
		throw "missing implementation";
	}
	,loaderComplete: function() {
		if(!this.loading) return;
		this.progress = 1;
		this.loading = false;
		this.loaded.dispatchType(mloader.LoaderEventType.Complete);
	}
	,loaderFail: function(error) {
		if(!this.loading) return;
		this.loading = false;
		this.loaded.dispatchType(mloader.LoaderEventType.Fail(error));
	}
	,sanitizeUrl: function(url) {
		var sanitized = url;
		return sanitized;
	}
	,__class__: mloader.LoaderBase
	,__properties__: {set_url:"set_url"}
};
mloader.HttpLoader = function(url,http) {
	mloader.LoaderBase.call(this,url);
	this.headers = new haxe.ds.StringMap();
	if(http == null) http = new haxe.Http("");
	this.http = http;
	http.onData = $bind(this,this.httpData);
	http.onError = $bind(this,this.httpError);
	http.onStatus = $bind(this,this.httpStatus);
};
$hxClasses["mloader.HttpLoader"] = mloader.HttpLoader;
mloader.HttpLoader.__name__ = ["mloader","HttpLoader"];
mloader.HttpLoader.__super__ = mloader.LoaderBase;
mloader.HttpLoader.prototype = $extend(mloader.LoaderBase.prototype,{
	http: null
	,headers: null
	,statusCode: null
	,send: function(data) {
		if(this.loading) this.cancel();
		if(this.url == null) throw "No url defined for Loader";
		this.loading = true;
		this.loaded.dispatchType(mloader.LoaderEventType.Start);
		var contentType = "application/octet-stream";
		if(js.Boot.__instanceof(data,Xml)) {
			data = Std.string(data);
			contentType = "application/xml";
		} else if(!(typeof(data) == "string")) {
			data = JSON.stringify(data);
			contentType = "application/json";
		} else if(typeof(data) == "string" && this.validateJSONdata(data)) contentType = "application/json";
		if(!this.headers.exists("Content-Type")) this.headers.set("Content-Type",contentType);
		this.httpConfigure();
		this.addHeaders();
		this.http.url = this.url;
		this.http.setPostData(data);
		try {
			this.http.request(true);
		} catch( e ) {
			this.loaderFail(mloader.LoaderErrorType.Security(Std.string(e)));
		}
	}
	,loaderLoad: function() {
		this.httpConfigure();
		this.addHeaders();
		this.http.url = this.url;
		try {
			this.http.request(false);
		} catch( e ) {
			this.loaderFail(mloader.LoaderErrorType.Security(Std.string(e)));
		}
	}
	,loaderCancel: function() {
		this.http.cancel();
	}
	,httpConfigure: function() {
	}
	,addHeaders: function() {
		var $it0 = this.headers.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			this.http.setHeader(name,this.headers.get(name));
		}
	}
	,httpData: function(data) {
		this.content = data;
		this.loaderComplete();
	}
	,httpStatus: function(status) {
		this.statusCode = status;
	}
	,httpError: function(error) {
		this.content = this.http.responseData;
		this.loaderFail(mloader.LoaderErrorType.IO(error));
	}
	,httpSecurityError: function(error) {
		this.loaderFail(mloader.LoaderErrorType.Security(error));
	}
	,validateJSONdata: function(data) {
		var isValid = true;
		try {
			JSON.parse(data);
		} catch( error ) {
			isValid = false;
		}
		return isValid;
	}
	,__class__: mloader.HttpLoader
});
mloader.ImageLoader = function(url) {
	mloader.LoaderBase.call(this,url);
};
$hxClasses["mloader.ImageLoader"] = mloader.ImageLoader;
mloader.ImageLoader.__name__ = ["mloader","ImageLoader"];
mloader.ImageLoader.__super__ = mloader.LoaderBase;
mloader.ImageLoader.prototype = $extend(mloader.LoaderBase.prototype,{
	image: null
	,loaderLoad: function() {
		if(this.image == null) this.content = window.document.createElement("img"); else this.content = this.image;
		this.content.onload = $bind(this,this.imageLoad);
		this.content.onerror = $bind(this,this.imageError);
		this.content.src = this.url;
	}
	,loaderCancel: function() {
		this.content.src = "";
	}
	,imageLoad: function(event) {
		this.content.onload = null;
		this.content.onerror = null;
		this.loaderComplete();
	}
	,imageError: function(event) {
		if(this.content == null) return;
		this.content.onload = null;
		this.content.onerror = null;
		this.loaderFail(mloader.LoaderErrorType.IO(Std.string(event)));
	}
	,__class__: mloader.ImageLoader
});
mloader.JsonLoader = function(url,http) {
	mloader.HttpLoader.call(this,url,http);
};
$hxClasses["mloader.JsonLoader"] = mloader.JsonLoader;
mloader.JsonLoader.__name__ = ["mloader","JsonLoader"];
mloader.JsonLoader.__super__ = mloader.HttpLoader;
mloader.JsonLoader.prototype = $extend(mloader.HttpLoader.prototype,{
	parseData: null
	,httpData: function(data) {
		var raw = null;
		try {
			raw = JSON.parse(data);
		} catch( e ) {
			this.loaderFail(mloader.LoaderErrorType.Format(Std.string(e)));
			return;
		}
		if(this.parseData == null) {
			this.content = raw;
			this.loaderComplete();
			return;
		}
		try {
			this.content = this.parseData(raw);
			this.loaderComplete();
		} catch( $e0 ) {
			if( js.Boot.__instanceof($e0,mloader.LoaderErrorType) ) {
				var loaderError = $e0;
				this.loaderFail(loaderError);
				return;
			} else {
			var e1 = $e0;
			this.loaderFail(mloader.LoaderErrorType.Data(Std.string(e1),data));
			return;
			}
		}
	}
	,__class__: mloader.JsonLoader
});
mloader.LoaderEventType = { __ename__ : ["mloader","LoaderEventType"], __constructs__ : ["Start","Cancel","Progress","Complete","Fail"] };
mloader.LoaderEventType.Start = ["Start",0];
mloader.LoaderEventType.Start.toString = $estr;
mloader.LoaderEventType.Start.__enum__ = mloader.LoaderEventType;
mloader.LoaderEventType.Cancel = ["Cancel",1];
mloader.LoaderEventType.Cancel.toString = $estr;
mloader.LoaderEventType.Cancel.__enum__ = mloader.LoaderEventType;
mloader.LoaderEventType.Progress = ["Progress",2];
mloader.LoaderEventType.Progress.toString = $estr;
mloader.LoaderEventType.Progress.__enum__ = mloader.LoaderEventType;
mloader.LoaderEventType.Complete = ["Complete",3];
mloader.LoaderEventType.Complete.toString = $estr;
mloader.LoaderEventType.Complete.__enum__ = mloader.LoaderEventType;
mloader.LoaderEventType.Fail = function(error) { var $x = ["Fail",4,error]; $x.__enum__ = mloader.LoaderEventType; $x.toString = $estr; return $x; };
mloader.LoaderErrorType = { __ename__ : ["mloader","LoaderErrorType"], __constructs__ : ["IO","Security","Format","Data"] };
mloader.LoaderErrorType.IO = function(info) { var $x = ["IO",0,info]; $x.__enum__ = mloader.LoaderErrorType; $x.toString = $estr; return $x; };
mloader.LoaderErrorType.Security = function(info) { var $x = ["Security",1,info]; $x.__enum__ = mloader.LoaderErrorType; $x.toString = $estr; return $x; };
mloader.LoaderErrorType.Format = function(info) { var $x = ["Format",2,info]; $x.__enum__ = mloader.LoaderErrorType; $x.toString = $estr; return $x; };
mloader.LoaderErrorType.Data = function(info,data) { var $x = ["Data",3,info,data]; $x.__enum__ = mloader.LoaderErrorType; $x.toString = $estr; return $x; };
mloader.LoaderQueue = function() {
	this.maxLoading = 8;
	this.loaded = new msignal.EventSignal(this);
	this.loading = false;
	this.ignoreFailures = true;
	this.autoLoad = false;
	this.numLoaded = 0;
	this.numFailed = 0;
	this.pendingQueue = [];
	this.activeLoaders = [];
};
$hxClasses["mloader.LoaderQueue"] = mloader.LoaderQueue;
mloader.LoaderQueue.__name__ = ["mloader","LoaderQueue"];
mloader.LoaderQueue.__interfaces__ = [mloader.Loader];
mloader.LoaderQueue.prototype = {
	content: null
	,loading: null
	,loaded: null
	,maxLoading: null
	,ignoreFailures: null
	,autoLoad: null
	,size: null
	,get_size: function() {
		return this.pendingQueue.length + this.activeLoaders.length;
	}
	,numPending: null
	,get_numPending: function() {
		return this.pendingQueue.length;
	}
	,numLoading: null
	,get_numLoading: function() {
		return this.activeLoaders.length;
	}
	,numLoaded: null
	,numFailed: null
	,progress: null
	,url: null
	,set_url: function(value) {
		return value;
	}
	,pendingQueue: null
	,activeLoaders: null
	,add: function(loader) {
		this.addWithPriority(loader,0);
	}
	,addWithPriority: function(loader,priority) {
		this.pendingQueue.push({ loader : loader, priority : priority});
		this.pendingQueue.sort(function(a,b) {
			return b.priority - a.priority;
		});
		if(this.autoLoad) this.load();
	}
	,remove: function(loader) {
		if(this.containsActiveLoader(loader)) {
			this.removeActiveLoader(loader);
			loader.cancel();
			this.continueLoading();
		} else if(this.containsPendingLoader(loader)) this.removePendingLoader(loader);
	}
	,load: function() {
		if(this.loading) return;
		this.loading = true;
		this.numLoaded = this.numFailed = 0;
		this.loaded.dispatchType(mloader.LoaderEventType.Start);
		if(this.pendingQueue.length > 0) this.continueLoading(); else this.queueCompleted();
	}
	,loaderCompleted: function(loader) {
		loader.loaded.remove($bind(this,this.loaderLoaded));
		HxOverrides.remove(this.activeLoaders,loader);
		this.numLoaded++;
		if(this.numLoaded == 0) this.progress = 0; else this.progress = this.numLoaded / (this.numLoaded + this.get_size());
		this.loaded.dispatchType(mloader.LoaderEventType.Progress);
		if(this.loading) {
			if(this.pendingQueue.length > 0) this.continueLoading(); else if(this.activeLoaders.length == 0) this.queueCompleted();
		} else throw "should not be!";
	}
	,loaderFail: function(loader,error) {
		this.numFailed += 1;
		if(this.ignoreFailures) this.loaderCompleted(loader); else {
			loader.loaded.remove($bind(this,this.loaderLoaded));
			HxOverrides.remove(this.activeLoaders,loader);
			this.loaded.dispatchType(mloader.LoaderEventType.Fail(error));
			this.loading = false;
		}
	}
	,continueLoading: function() {
		while(this.pendingQueue.length > 0 && this.activeLoaders.length < this.maxLoading) {
			var info = this.pendingQueue.shift();
			var loader = info.loader;
			loader.loaded.add($bind(this,this.loaderLoaded));
			this.activeLoaders.push(loader);
			loader.load();
		}
	}
	,queueCompleted: function() {
		this.loaded.dispatchType(mloader.LoaderEventType.Complete);
		this.loading = false;
	}
	,cancel: function() {
		while(this.activeLoaders.length > 0) {
			var loader = this.activeLoaders.pop();
			loader.loaded.remove($bind(this,this.loaderLoaded));
			loader.cancel();
		}
		this.loading = false;
		this.pendingQueue = [];
		this.loaded.dispatchType(mloader.LoaderEventType.Cancel);
	}
	,loaderLoaded: function(event) {
		var loader = event.target;
		{
			var _g = event.type;
			switch(_g[1]) {
			case 3:case 1:
				this.loaderCompleted(loader);
				break;
			case 4:
				var e = _g[2];
				this.loaderFail(loader,e);
				break;
			default:
			}
		}
	}
	,containsActiveLoader: function(loader) {
		var _g = 0;
		var _g1 = this.activeLoaders;
		while(_g < _g1.length) {
			var active = _g1[_g];
			++_g;
			if(active == loader) return true;
		}
		return false;
	}
	,containsPendingLoader: function(loader) {
		var _g = 0;
		var _g1 = this.pendingQueue;
		while(_g < _g1.length) {
			var pending = _g1[_g];
			++_g;
			if(pending.loader == loader) return true;
		}
		return false;
	}
	,removeActiveLoader: function(loader) {
		var i = this.activeLoaders.length;
		while(i-- > 0) if(this.activeLoaders[i] == loader) {
			loader.loaded.remove($bind(this,this.loaderLoaded));
			this.activeLoaders.splice(i,1);
		}
	}
	,removePendingLoader: function(loader) {
		var i = this.pendingQueue.length;
		while(i-- > 0) if(this.pendingQueue[i].loader == loader) this.pendingQueue.splice(i,1);
	}
	,__class__: mloader.LoaderQueue
	,__properties__: {set_url:"set_url",get_numLoading:"get_numLoading",get_numPending:"get_numPending",get_size:"get_size"}
};
mloader.XmlObjectLoader = function(url,parser,http) {
	mloader.HttpLoader.call(this,url,http);
	if(parser == null) this.parser = new mloader.XmlObjectParser(); else this.parser = parser;
};
$hxClasses["mloader.XmlObjectLoader"] = mloader.XmlObjectLoader;
mloader.XmlObjectLoader.__name__ = ["mloader","XmlObjectLoader"];
mloader.XmlObjectLoader.__super__ = mloader.HttpLoader;
mloader.XmlObjectLoader.prototype = $extend(mloader.HttpLoader.prototype,{
	parser: null
	,httpData: function(data) {
		try {
			var xml = Xml.parse(data);
			this.content = this.parser.parse(xml);
		} catch( e ) {
			this.loaderFail(mloader.LoaderErrorType.Format(Std.string(e)));
			return;
		}
		this.loaderComplete();
	}
	,mapClass: function(nodeName,nodeClass) {
		this.parser.classMap.set(nodeName,nodeClass);
	}
	,mapNode: function(fromNodeName,toNodeName) {
		this.parser.nodeMap.set(fromNodeName,toNodeName);
	}
	,__class__: mloader.XmlObjectLoader
});
mloader.XmlObjectParser = function() {
	this.classMap = new haxe.ds.StringMap();
	this.nodeMap = new haxe.ds.StringMap();
};
$hxClasses["mloader.XmlObjectParser"] = mloader.XmlObjectParser;
mloader.XmlObjectParser.__name__ = ["mloader","XmlObjectParser"];
mloader.XmlObjectParser.prototype = {
	classMap: null
	,nodeMap: null
	,parse: function(node) {
		try {
			if(node.nodeType == Xml.Document) node = node.firstElement();
			return this.parseNode(node);
		} catch( e ) {
			throw "Error parsing xml " + Std.string(e.toString());
		}
	}
	,parseNode: function(node) {
		var nodeName = node.get_nodeName();
		while(this.nodeMap.exists(nodeName)) nodeName = this.nodeMap.get(nodeName);
		switch(nodeName) {
		case "Null":
			return null;
		case "Bool":case "Int":case "Float":case "String":
			return this.parseString(StringTools.trim(node.firstChild().get_nodeValue()));
		case "Xml":
			return Xml.parse(node.firstElement().toString());
		case "Array":
			return this.parseArray(node);
		case "Hash":case "StringMap":
			return this.parseHash(node);
		case "IntHash":case "IntMap":
			return this.parseIntHash(node);
		case "Object":
			var object = { };
			this.processAttributes(node,object);
			this.processElements(node,object);
			return object;
		default:
			if(!this.classMap.exists(nodeName)) return null;
			var theClass = this.classMap.get(nodeName);
			var instance = Type.createInstance(theClass,[]);
			this.processAttributes(node,instance);
			this.processElements(node,instance);
			return instance;
		}
	}
	,processAttributes: function(node,instance) {
		var $it0 = node.attributes();
		while( $it0.hasNext() ) {
			var attribute = $it0.next();
			this.setStringProperty(instance,attribute,node.get(attribute));
		}
	}
	,processElements: function(node,instance) {
		var $it0 = node.elements();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			var nodeName = element.get_nodeName();
			var mappedName = nodeName;
			while(this.nodeMap.exists(mappedName)) mappedName = this.nodeMap.get(mappedName);
			if(mappedName != nodeName) this.setProperty(instance,nodeName,this.parseNode(element)); else if(this.classMap.exists(nodeName)) {
				var property = nodeName.charAt(0).toLowerCase() + HxOverrides.substr(nodeName,1,nodeName.length);
				this.setProperty(instance,property,this.parseNode(element));
			} else if(element.firstElement() == null) {
				if(element.firstChild() != null) this.setStringProperty(instance,nodeName,element.firstChild().get_nodeValue()); else this.setProperty(instance,nodeName,null);
			} else {
				var elements = element.elements();
				var first = elements.next();
				if(elements.hasNext()) {
					var children = [];
					this.processElements(element,children);
					this.setProperty(instance,nodeName,children);
				} else this.setProperty(instance,nodeName,this.parseNode(first));
			}
		}
	}
	,parseString: function(string) {
		if(string == null) return null;
		if(HxOverrides.substr(string,0,2) == "0x") return Std.parseInt(string);
		var $float = Std.parseFloat(string);
		if(($float == null?"null":"" + $float) == string) return $float;
		if(string == "true" || string == "false") return string == "true";
		var arrayString = this.extractPattern(string,"[","]");
		if(arrayString != null) {
			var result = arrayString.split(",");
			var _g1 = 0;
			var _g = result.length;
			while(_g1 < _g) {
				var i = _g1++;
				var value = result[i];
				result[i] = this.parseString(value);
			}
			return result;
		}
		var objectString = this.extractPattern(string,"{","}");
		if(objectString != null) {
			var result1 = { };
			var pairs = objectString.split(",");
			var _g2 = 0;
			while(_g2 < pairs.length) {
				var pair = pairs[_g2];
				++_g2;
				var parts = pair.split(":");
				Reflect.setField(result1,parts[0],this.parseString(parts[1]));
			}
			return result1;
		}
		return string;
	}
	,parseArray: function(node) {
		var array = [];
		var $it0 = node.elements();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			array.push(this.parseNode(element));
		}
		return array;
	}
	,parseHash: function(node) {
		var hash = new haxe.ds.StringMap();
		var $it0 = node.elements();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			var id = this.getIdFromNode(element);
			hash.set(id,this.parseNode(element));
		}
		return hash;
	}
	,parseIntHash: function(node) {
		var hash = new haxe.ds.IntMap();
		var $it0 = node.elements();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			var id = Std.parseInt(this.getIdFromNode(element));
			if(Math.isNaN(id) || id == null) id = -1;
			hash.set(id,this.parseNode(element));
		}
		return hash;
	}
	,getIdFromNode: function(node) {
		if(node.exists("id")) return Std.string(node.get("id"));
		var $it0 = node.elementsNamed("id");
		while( $it0.hasNext() ) {
			var element = $it0.next();
			return Std.string(element.firstChild());
		}
		return null;
	}
	,setStringProperty: function(object,property,value) {
		this.setProperty(object,property,this.parseString(value));
	}
	,setProperty: function(object,property,value) {
		Reflect.setProperty(object,property,value);
	}
	,extractPattern: function(string,startToken,endToken) {
		if(string.charAt(0) == startToken) {
			if(string.charAt(string.length - 1) == endToken) return HxOverrides.substr(string,1,string.length - 2);
		}
		return null;
	}
	,__class__: mloader.XmlObjectParser
};
mmvc.api.ICommandMap = function() { };
$hxClasses["mmvc.api.ICommandMap"] = mmvc.api.ICommandMap;
mmvc.api.ICommandMap.__name__ = ["mmvc","api","ICommandMap"];
mmvc.api.ICommandMap.prototype = {
	mapSignal: null
	,mapSignalClass: null
	,hasSignalCommand: null
	,unmapSignal: null
	,unmapSignalClass: null
	,detain: null
	,release: null
	,__class__: mmvc.api.ICommandMap
};
mmvc.api.IMediatorMap = function() { };
$hxClasses["mmvc.api.IMediatorMap"] = mmvc.api.IMediatorMap;
mmvc.api.IMediatorMap.__name__ = ["mmvc","api","IMediatorMap"];
mmvc.api.IMediatorMap.prototype = {
	mapView: null
	,unmapView: null
	,createMediator: null
	,registerMediator: null
	,removeMediator: null
	,removeMediatorByView: null
	,retrieveMediator: null
	,hasMapping: null
	,hasMediator: null
	,hasMediatorForView: null
	,contextView: null
	,enabled: null
	,__class__: mmvc.api.IMediatorMap
};
mmvc.api.IViewMap = function() { };
$hxClasses["mmvc.api.IViewMap"] = mmvc.api.IViewMap;
mmvc.api.IViewMap.__name__ = ["mmvc","api","IViewMap"];
mmvc.api.IViewMap.prototype = {
	mapPackage: null
	,unmapPackage: null
	,hasPackage: null
	,mapType: null
	,unmapType: null
	,hasType: null
	,contextView: null
	,enabled: null
	,__class__: mmvc.api.IViewMap
};
mmvc.base.CommandMap = function(injector) {
	this.injector = injector;
	this.signalMap = new mdata.Dictionary();
	this.signalClassMap = new mdata.Dictionary();
	this.detainedCommands = new mdata.Dictionary();
};
$hxClasses["mmvc.base.CommandMap"] = mmvc.base.CommandMap;
mmvc.base.CommandMap.__name__ = ["mmvc","base","CommandMap"];
mmvc.base.CommandMap.__interfaces__ = [mmvc.api.ICommandMap];
mmvc.base.CommandMap.prototype = {
	injector: null
	,signalMap: null
	,signalClassMap: null
	,detainedCommands: null
	,mapSignalClass: function(signalClass,commandClass,oneShot) {
		if(oneShot == null) oneShot = false;
		var signal = this.getSignalClassInstance(signalClass);
		this.mapSignal(signal,commandClass,oneShot);
		return signal;
	}
	,mapSignal: function(signal,commandClass,oneShot) {
		if(oneShot == null) oneShot = false;
		if(this.hasSignalCommand(signal,commandClass)) return;
		var signalCommandMap;
		if(this.signalMap.exists(signal)) signalCommandMap = this.signalMap.get(signal); else {
			signalCommandMap = new mdata.Dictionary(false);
			this.signalMap.set(signal,signalCommandMap);
		}
		var me = this;
		var callbackFunction = Reflect.makeVarArgs(function(args) {
			me.routeSignalToCommand(signal,args,commandClass,oneShot);
		});
		signalCommandMap.set(commandClass,callbackFunction);
		signal.add(callbackFunction);
	}
	,unmapSignalClass: function(signalClass,commandClass) {
		var signal = this.getSignalClassInstance(signalClass);
		this.unmapSignal(signal,commandClass);
		if(!this.hasCommand(signal)) {
			this.injector.unmap(signalClass);
			this.signalClassMap["delete"](signalClass);
		}
	}
	,unmapSignal: function(signal,commandClass) {
		var callbacksByCommandClass = this.signalMap.get(signal);
		if(callbacksByCommandClass == null) return;
		var callbackFunction = callbacksByCommandClass.get(commandClass);
		if(callbackFunction == null) return;
		if(!this.hasCommand(signal)) this.signalMap["delete"](signal);
		signal.remove(callbackFunction);
		callbacksByCommandClass["delete"](commandClass);
	}
	,getSignalClassInstance: function(signalClass) {
		if(this.signalClassMap.exists(signalClass)) return js.Boot.__cast(this.signalClassMap.get(signalClass) , msignal.Signal);
		return this.createSignalClassInstance(signalClass);
	}
	,createSignalClassInstance: function(signalClass) {
		var injectorForSignalInstance = this.injector;
		if(this.injector.hasMapping(minject.Injector)) injectorForSignalInstance = this.injector.getInstance(minject.Injector);
		var signal = injectorForSignalInstance.instantiate(signalClass);
		injectorForSignalInstance.mapValue(signalClass,signal);
		this.signalClassMap.set(signalClass,signal);
		return signal;
	}
	,hasCommand: function(signal) {
		var callbacksByCommandClass = this.signalMap.get(signal);
		if(callbacksByCommandClass == null) return false;
		var count = 0;
		var $it0 = callbacksByCommandClass.iterator();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			count++;
		}
		return count > 0;
	}
	,hasSignalCommand: function(signal,commandClass) {
		var callbacksByCommandClass = this.signalMap.get(signal);
		if(callbacksByCommandClass == null) return false;
		var callbackFunction = callbacksByCommandClass.get(commandClass);
		return callbackFunction != null;
	}
	,routeSignalToCommand: function(signal,valueObjects,commandClass,oneshot) {
		this.injector.mapValue(msignal.Signal,signal);
		this.mapSignalValues(signal.valueClasses,valueObjects);
		var command = this.createCommandInstance(commandClass);
		this.injector.unmap(msignal.Signal);
		this.unmapSignalValues(signal.valueClasses,valueObjects);
		command.execute();
		this.injector.attendedToInjectees["delete"](command);
		if(oneshot) this.unmapSignal(signal,commandClass);
	}
	,createCommandInstance: function(commandClass) {
		return this.injector.instantiate(commandClass);
	}
	,mapSignalValues: function(valueClasses,valueObjects) {
		var _g1 = 0;
		var _g = valueClasses.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.injector.mapValue(valueClasses[i],valueObjects[i]);
		}
	}
	,unmapSignalValues: function(valueClasses,valueObjects) {
		var _g1 = 0;
		var _g = valueClasses.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.injector.unmap(valueClasses[i]);
		}
	}
	,detain: function(command) {
		this.detainedCommands.set(command,true);
	}
	,release: function(command) {
		if(this.detainedCommands.exists(command)) this.detainedCommands["delete"](command);
	}
	,__class__: mmvc.base.CommandMap
};
mmvc.base.ContextError = function(message,id) {
	if(id == null) id = 0;
	if(message == null) message = "";
	this.message = message;
	this.id = id;
};
$hxClasses["mmvc.base.ContextError"] = mmvc.base.ContextError;
mmvc.base.ContextError.__name__ = ["mmvc","base","ContextError"];
mmvc.base.ContextError.prototype = {
	message: null
	,id: null
	,__class__: mmvc.base.ContextError
};
mmvc.base.ViewMapBase = function(contextView,injector) {
	this.viewListenerCount = 0;
	this.set_enabled(true);
	this.injector = injector;
	this.set_contextView(contextView);
};
$hxClasses["mmvc.base.ViewMapBase"] = mmvc.base.ViewMapBase;
mmvc.base.ViewMapBase.__name__ = ["mmvc","base","ViewMapBase"];
mmvc.base.ViewMapBase.prototype = {
	contextView: null
	,enabled: null
	,set_contextView: function(value) {
		if(value != this.contextView) {
			this.removeListeners();
			this.contextView = value;
			if(this.viewListenerCount > 0) this.addListeners();
		}
		return this.contextView;
	}
	,set_enabled: function(value) {
		if(value != this.enabled) {
			this.removeListeners();
			this.enabled = value;
			if(this.viewListenerCount > 0) this.addListeners();
		}
		return value;
	}
	,injector: null
	,viewListenerCount: null
	,addListeners: function() {
	}
	,removeListeners: function() {
	}
	,onViewAdded: function(view) {
	}
	,onViewRemoved: function(view) {
	}
	,__class__: mmvc.base.ViewMapBase
	,__properties__: {set_enabled:"set_enabled",set_contextView:"set_contextView"}
};
mmvc.base.MediatorMap = function(contextView,injector,reflector) {
	mmvc.base.ViewMapBase.call(this,contextView,injector);
	this.reflector = reflector;
	this.mediatorByView = new mdata.Dictionary(true);
	this.mappingConfigByView = new mdata.Dictionary(true);
	this.mappingConfigByViewClassName = new mdata.Dictionary();
	this.mediatorsMarkedForRemoval = new mdata.Dictionary();
	this.hasMediatorsMarkedForRemoval = false;
};
$hxClasses["mmvc.base.MediatorMap"] = mmvc.base.MediatorMap;
mmvc.base.MediatorMap.__name__ = ["mmvc","base","MediatorMap"];
mmvc.base.MediatorMap.__interfaces__ = [mmvc.api.IMediatorMap];
mmvc.base.MediatorMap.__super__ = mmvc.base.ViewMapBase;
mmvc.base.MediatorMap.prototype = $extend(mmvc.base.ViewMapBase.prototype,{
	mediatorByView: null
	,mappingConfigByView: null
	,mappingConfigByViewClassName: null
	,mediatorsMarkedForRemoval: null
	,hasMediatorsMarkedForRemoval: null
	,reflector: null
	,mapView: function(viewClassOrName,mediatorClass,injectViewAs,autoCreate,autoRemove) {
		if(autoRemove == null) autoRemove = true;
		if(autoCreate == null) autoCreate = true;
		var viewClassName = this.reflector.getFQCN(viewClassOrName);
		if(this.mappingConfigByViewClassName.get(viewClassName) != null) throw new mmvc.base.ContextError("Mediator Class has already been mapped to a View Class in this context - " + Std.string(mediatorClass));
		if(this.reflector.classExtendsOrImplements(mediatorClass,mmvc.api.IMediator) == false) throw new mmvc.base.ContextError("Mediator Class does not implement IMediator - " + Std.string(mediatorClass));
		var config = new mmvc.base.MappingConfig();
		config.mediatorClass = mediatorClass;
		config.autoCreate = autoCreate;
		config.autoRemove = autoRemove;
		if(injectViewAs) {
			if((injectViewAs instanceof Array) && injectViewAs.__enum__ == null) {
				var _this;
				_this = js.Boot.__cast(injectViewAs , Array);
				config.typedViewClasses = _this.slice();
			} else if(js.Boot.__instanceof(injectViewAs,Class)) config.typedViewClasses = [injectViewAs];
		} else if(js.Boot.__instanceof(viewClassOrName,Class)) config.typedViewClasses = [viewClassOrName];
		this.mappingConfigByViewClassName.set(viewClassName,config);
		if(autoCreate || autoRemove) {
			this.viewListenerCount++;
			if(this.viewListenerCount == 1) this.addListeners();
		}
		if(autoCreate && this.contextView != null && viewClassName == Type.getClassName(Type.getClass(this.contextView))) this.createMediatorUsing(this.contextView,viewClassName,config);
	}
	,unmapView: function(viewClassOrName) {
		var viewClassName = this.reflector.getFQCN(viewClassOrName);
		var config = this.mappingConfigByViewClassName.get(viewClassName);
		if(config != null && (config.autoCreate || config.autoRemove)) {
			this.viewListenerCount--;
			if(this.viewListenerCount == 0) this.removeListeners();
		}
		this.mappingConfigByViewClassName["delete"](viewClassName);
	}
	,createMediator: function(viewComponent) {
		return this.createMediatorUsing(viewComponent);
	}
	,registerMediator: function(viewComponent,mediator) {
		this.mediatorByView.set(viewComponent,mediator);
		var mapping = this.mappingConfigByViewClassName.get(Type.getClassName(Type.getClass(viewComponent)));
		this.mappingConfigByView.set(viewComponent,mapping);
		mediator.setViewComponent(viewComponent);
		mediator.preRegister();
	}
	,removeMediator: function(mediator) {
		if(mediator != null) {
			var viewComponent = mediator.getViewComponent();
			this.mediatorByView["delete"](viewComponent);
			this.mappingConfigByView["delete"](viewComponent);
			mediator.preRemove();
			mediator.setViewComponent(null);
		}
		return mediator;
	}
	,removeMediatorByView: function(viewComponent) {
		var mediator = this.removeMediator(this.retrieveMediator(viewComponent));
		this.injector.attendedToInjectees["delete"](mediator);
		return mediator;
	}
	,retrieveMediator: function(viewComponent) {
		return this.mediatorByView.get(viewComponent);
	}
	,hasMapping: function(viewClassOrName) {
		var viewClassName = this.reflector.getFQCN(viewClassOrName);
		return this.mappingConfigByViewClassName.get(viewClassName) != null;
	}
	,hasMediatorForView: function(viewComponent) {
		return this.mediatorByView.get(viewComponent) != null;
	}
	,hasMediator: function(mediator) {
		var $it0 = this.mediatorByView.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			if(this.mediatorByView.get(key) == mediator) return true;
		}
		return false;
	}
	,addListeners: function() {
		if(this.contextView != null && this.enabled) {
			this.contextView.viewAdded = $bind(this,this.onViewAdded);
			this.contextView.viewRemoved = $bind(this,this.onViewRemoved);
		}
	}
	,removeListeners: function() {
		if(this.contextView != null) {
			this.contextView.viewAdded = null;
			this.contextView.viewRemoved = null;
		}
	}
	,onViewAdded: function(view) {
		if(this.mediatorsMarkedForRemoval.get(view) != null) {
			this.mediatorsMarkedForRemoval["delete"](view);
			return;
		}
		var viewClassName = Type.getClassName(Type.getClass(view));
		var config = this.mappingConfigByViewClassName.get(viewClassName);
		if(config != null && config.autoCreate) this.createMediatorUsing(view,viewClassName,config);
	}
	,onViewRemoved: function(view) {
		var config = this.mappingConfigByView.get(view);
		if(config != null && config.autoRemove) this.removeMediatorByView(view);
	}
	,removeMediatorLater: function() {
		var $it0 = this.mediatorsMarkedForRemoval.iterator();
		while( $it0.hasNext() ) {
			var view = $it0.next();
			if(!this.contextView.isAdded(view)) this.removeMediatorByView(view);
			this.mediatorsMarkedForRemoval["delete"](view);
		}
		this.hasMediatorsMarkedForRemoval = false;
	}
	,createMediatorUsing: function(viewComponent,viewClassName,config) {
		var mediator = this.mediatorByView.get(viewComponent);
		if(mediator == null) {
			if(viewClassName == null) viewClassName = Type.getClassName(Type.getClass(viewComponent));
			if(config == null) config = this.mappingConfigByViewClassName.get(viewClassName);
			if(config != null) {
				var _g = 0;
				var _g1 = config.typedViewClasses;
				while(_g < _g1.length) {
					var claxx = _g1[_g];
					++_g;
					this.injector.mapValue(claxx,viewComponent);
				}
				mediator = this.injector.instantiate(config.mediatorClass);
				var _g2 = 0;
				var _g11 = config.typedViewClasses;
				while(_g2 < _g11.length) {
					var clazz = _g11[_g2];
					++_g2;
					this.injector.unmap(clazz);
				}
				this.registerMediator(viewComponent,mediator);
			}
		}
		return mediator;
	}
	,__class__: mmvc.base.MediatorMap
});
mmvc.base.MappingConfig = function() {
};
$hxClasses["mmvc.base.MappingConfig"] = mmvc.base.MappingConfig;
mmvc.base.MappingConfig.__name__ = ["mmvc","base","MappingConfig"];
mmvc.base.MappingConfig.prototype = {
	mediatorClass: null
	,typedViewClasses: null
	,autoCreate: null
	,autoRemove: null
	,__class__: mmvc.base.MappingConfig
};
mmvc.base.ViewMap = function(contextView,injector) {
	mmvc.base.ViewMapBase.call(this,contextView,injector);
	this.mappedPackages = new Array();
	this.mappedTypes = new mdata.Dictionary();
	this.injectedViews = new mdata.Dictionary(true);
};
$hxClasses["mmvc.base.ViewMap"] = mmvc.base.ViewMap;
mmvc.base.ViewMap.__name__ = ["mmvc","base","ViewMap"];
mmvc.base.ViewMap.__interfaces__ = [mmvc.api.IViewMap];
mmvc.base.ViewMap.__super__ = mmvc.base.ViewMapBase;
mmvc.base.ViewMap.prototype = $extend(mmvc.base.ViewMapBase.prototype,{
	mapPackage: function(packageName) {
		if(!Lambda.has(this.mappedPackages,packageName)) {
			this.mappedPackages.push(packageName);
			this.viewListenerCount++;
			if(this.viewListenerCount == 1) this.addListeners();
		}
	}
	,unmapPackage: function(packageName) {
		var index = Lambda.indexOf(this.mappedPackages,packageName);
		if(index > -1) {
			this.mappedPackages.splice(index,1);
			this.viewListenerCount--;
			if(this.viewListenerCount == 0) this.removeListeners();
		}
	}
	,mapType: function(type) {
		if(this.mappedTypes.get(type) != null) return;
		this.mappedTypes.set(type,type);
		this.viewListenerCount++;
		if(this.viewListenerCount == 1) this.addListeners();
		if(this.contextView != null && js.Boot.__instanceof(this.contextView,type)) this.injectInto(this.contextView);
	}
	,unmapType: function(type) {
		var mapping = this.mappedTypes.get(type);
		this.mappedTypes["delete"](type);
		if(mapping != null) {
			this.viewListenerCount--;
			if(this.viewListenerCount == 0) this.removeListeners();
		}
	}
	,hasType: function(type) {
		return this.mappedTypes.get(type) != null;
	}
	,hasPackage: function(packageName) {
		return Lambda.has(this.mappedPackages,packageName);
	}
	,mappedPackages: null
	,mappedTypes: null
	,injectedViews: null
	,addListeners: function() {
		if(this.contextView != null && this.enabled) {
			this.contextView.viewAdded = $bind(this,this.onViewAdded);
			this.contextView.viewRemoved = $bind(this,this.onViewAdded);
		}
	}
	,removeListeners: function() {
		if(this.contextView != null) {
			this.contextView.viewAdded = null;
			this.contextView.viewRemoved = null;
		}
	}
	,onViewAdded: function(view) {
		if(this.injectedViews.get(view) != null) return;
		var $it0 = this.mappedTypes.iterator();
		while( $it0.hasNext() ) {
			var type = $it0.next();
			if(js.Boot.__instanceof(view,type)) {
				this.injectInto(view);
				return;
			}
		}
		var len = this.mappedPackages.length;
		if(len > 0) {
			var className = Type.getClassName(Type.getClass(view));
			var _g = 0;
			while(_g < len) {
				var i = _g++;
				var packageName = this.mappedPackages[i];
				if(className.indexOf(packageName) == 0) {
					this.injectInto(view);
					return;
				}
			}
		}
	}
	,onViewRemoved: function(view) {
	}
	,injectInto: function(view) {
		this.injector.injectInto(view);
		this.injectedViews.set(view,true);
	}
	,__class__: mmvc.base.ViewMap
});
msignal.EventSignal = function(target) {
	msignal.Signal.call(this,[msignal.Event]);
	this.target = target;
};
$hxClasses["msignal.EventSignal"] = msignal.EventSignal;
msignal.EventSignal.__name__ = ["msignal","EventSignal"];
msignal.EventSignal.__super__ = msignal.Signal;
msignal.EventSignal.prototype = $extend(msignal.Signal.prototype,{
	target: null
	,dispatch: function(event) {
		if(event.target == null) {
			event.target = this.target;
			event.signal = this;
		}
		event.currentTarget = this.target;
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(event);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,dispatchType: function(type) {
		this.dispatch(new msignal.Event(type));
	}
	,bubble: function(event) {
		this.dispatch(event);
		var currentTarget = this.target;
		while(currentTarget != null && Object.prototype.hasOwnProperty.call(currentTarget,"parent")) {
			currentTarget = Reflect.field(currentTarget,"parent");
			if(js.Boot.__instanceof(currentTarget,msignal.EventDispatcher)) {
				event.currentTarget = currentTarget;
				var dispatcher;
				dispatcher = js.Boot.__cast(currentTarget , msignal.EventDispatcher);
				if(!dispatcher.dispatchEvent(event)) break;
			}
		}
	}
	,bubbleType: function(type) {
		this.bubble(new msignal.Event(type));
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.EventSlot(this,listener,once,priority);
	}
	,__class__: msignal.EventSignal
});
msignal.Slot = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	this.signal = signal;
	this.set_listener(listener);
	this.once = once;
	this.priority = priority;
	this.enabled = true;
};
$hxClasses["msignal.Slot"] = msignal.Slot;
msignal.Slot.__name__ = ["msignal","Slot"];
msignal.Slot.prototype = {
	listener: null
	,once: null
	,priority: null
	,enabled: null
	,signal: null
	,remove: function() {
		this.signal.remove(this.listener);
	}
	,set_listener: function(value) {
		if(value == null) throw "listener cannot be null";
		return this.listener = value;
	}
	,__class__: msignal.Slot
	,__properties__: {set_listener:"set_listener"}
};
msignal.EventSlot = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
$hxClasses["msignal.EventSlot"] = msignal.EventSlot;
msignal.EventSlot.__name__ = ["msignal","EventSlot"];
msignal.EventSlot.typeEq = function(a,b) {
	if(a == b) return true;
	{
		var _g = Type["typeof"](a);
		switch(_g[1]) {
		case 7:
			return msignal.EventSlot.enumTypeEq(a,b);
		default:
			return false;
		}
	}
	return false;
};
msignal.EventSlot.enumTypeEq = function(a,b) {
	if(a == b) return true;
	if(Type.getEnum(a) != Type.getEnum(b)) return false;
	if(a[1] != b[1]) return false;
	var aParams = a.slice(2);
	if(aParams.length == 0) return true;
	var bParams = b.slice(2);
	var _g1 = 0;
	var _g = aParams.length;
	while(_g1 < _g) {
		var i = _g1++;
		var aParam = aParams[i];
		var bParam = bParams[i];
		if(aParam == null) continue;
		if(!msignal.EventSlot.typeEq(aParam,bParam)) return false;
	}
	return true;
};
msignal.EventSlot.__super__ = msignal.Slot;
msignal.EventSlot.prototype = $extend(msignal.Slot.prototype,{
	filterType: null
	,execute: function(value1) {
		if(!this.enabled) return;
		if(this.filterType != null && !msignal.EventSlot.typeEq(this.filterType,value1.type)) return;
		if(this.once) this.remove();
		this.listener(value1);
	}
	,forType: function(value) {
		this.filterType = value;
	}
	,__class__: msignal.EventSlot
});
msignal.EventDispatcher = function() { };
$hxClasses["msignal.EventDispatcher"] = msignal.EventDispatcher;
msignal.EventDispatcher.__name__ = ["msignal","EventDispatcher"];
msignal.EventDispatcher.prototype = {
	dispatchEvent: null
	,__class__: msignal.EventDispatcher
};
msignal.Signal0 = function() {
	msignal.Signal.call(this);
};
$hxClasses["msignal.Signal0"] = msignal.Signal0;
msignal.Signal0.__name__ = ["msignal","Signal0"];
msignal.Signal0.__super__ = msignal.Signal;
msignal.Signal0.prototype = $extend(msignal.Signal.prototype,{
	dispatch: function() {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute();
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.Slot0(this,listener,once,priority);
	}
	,__class__: msignal.Signal0
});
msignal.Signal1 = function(type) {
	msignal.Signal.call(this,[type]);
};
$hxClasses["msignal.Signal1"] = msignal.Signal1;
msignal.Signal1.__name__ = ["msignal","Signal1"];
msignal.Signal1.__super__ = msignal.Signal;
msignal.Signal1.prototype = $extend(msignal.Signal.prototype,{
	dispatch: function(value) {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(value);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.Slot1(this,listener,once,priority);
	}
	,__class__: msignal.Signal1
});
msignal.Slot0 = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
$hxClasses["msignal.Slot0"] = msignal.Slot0;
msignal.Slot0.__name__ = ["msignal","Slot0"];
msignal.Slot0.__super__ = msignal.Slot;
msignal.Slot0.prototype = $extend(msignal.Slot.prototype,{
	execute: function() {
		if(!this.enabled) return;
		if(this.once) this.remove();
		this.listener();
	}
	,__class__: msignal.Slot0
});
msignal.Slot1 = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
$hxClasses["msignal.Slot1"] = msignal.Slot1;
msignal.Slot1.__name__ = ["msignal","Slot1"];
msignal.Slot1.__super__ = msignal.Slot;
msignal.Slot1.prototype = $extend(msignal.Slot.prototype,{
	param: null
	,execute: function(value1) {
		if(!this.enabled) return;
		if(this.once) this.remove();
		if(this.param != null) value1 = this.param;
		this.listener(value1);
	}
	,__class__: msignal.Slot1
});
msignal.Slot2 = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
$hxClasses["msignal.Slot2"] = msignal.Slot2;
msignal.Slot2.__name__ = ["msignal","Slot2"];
msignal.Slot2.__super__ = msignal.Slot;
msignal.Slot2.prototype = $extend(msignal.Slot.prototype,{
	param1: null
	,param2: null
	,execute: function(value1,value2) {
		if(!this.enabled) return;
		if(this.once) this.remove();
		if(this.param1 != null) value1 = this.param1;
		if(this.param2 != null) value2 = this.param2;
		this.listener(value1,value2);
	}
	,__class__: msignal.Slot2
});
msignal.SlotList = function(head,tail) {
	this.nonEmpty = false;
	if(head == null && tail == null) {
		if(msignal.SlotList.NIL != null) throw "Parameters head and tail are null. Use the NIL element instead.";
		this.nonEmpty = false;
	} else if(head == null) throw "Parameter head cannot be null."; else {
		this.head = head;
		if(tail == null) this.tail = msignal.SlotList.NIL; else this.tail = tail;
		this.nonEmpty = true;
	}
};
$hxClasses["msignal.SlotList"] = msignal.SlotList;
msignal.SlotList.__name__ = ["msignal","SlotList"];
msignal.SlotList.prototype = {
	head: null
	,tail: null
	,nonEmpty: null
	,length: null
	,get_length: function() {
		if(!this.nonEmpty) return 0;
		if(this.tail == msignal.SlotList.NIL) return 1;
		var result = 0;
		var p = this;
		while(p.nonEmpty) {
			++result;
			p = p.tail;
		}
		return result;
	}
	,prepend: function(slot) {
		return new msignal.SlotList(slot,this);
	}
	,append: function(slot) {
		if(slot == null) return this;
		if(!this.nonEmpty) return new msignal.SlotList(slot);
		if(this.tail == msignal.SlotList.NIL) return new msignal.SlotList(slot).prepend(this.head);
		var wholeClone = new msignal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			subClone = subClone.tail = new msignal.SlotList(current.head);
			current = current.tail;
		}
		subClone.tail = new msignal.SlotList(slot);
		return wholeClone;
	}
	,insertWithPriority: function(slot) {
		if(!this.nonEmpty) return new msignal.SlotList(slot);
		var priority = slot.priority;
		if(priority >= this.head.priority) return this.prepend(slot);
		var wholeClone = new msignal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			if(priority > current.head.priority) {
				subClone.tail = current.prepend(slot);
				return wholeClone;
			}
			subClone = subClone.tail = new msignal.SlotList(current.head);
			current = current.tail;
		}
		subClone.tail = new msignal.SlotList(slot);
		return wholeClone;
	}
	,filterNot: function(listener) {
		if(!this.nonEmpty || listener == null) return this;
		if(Reflect.compareMethods(this.head.listener,listener)) return this.tail;
		var wholeClone = new msignal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			if(Reflect.compareMethods(current.head.listener,listener)) {
				subClone.tail = current.tail;
				return wholeClone;
			}
			subClone = subClone.tail = new msignal.SlotList(current.head);
			current = current.tail;
		}
		return this;
	}
	,contains: function(listener) {
		if(!this.nonEmpty) return false;
		var p = this;
		while(p.nonEmpty) {
			if(Reflect.compareMethods(p.head.listener,listener)) return true;
			p = p.tail;
		}
		return false;
	}
	,find: function(listener) {
		if(!this.nonEmpty) return null;
		var p = this;
		while(p.nonEmpty) {
			if(Reflect.compareMethods(p.head.listener,listener)) return p.head;
			p = p.tail;
		}
		return null;
	}
	,__class__: msignal.SlotList
	,__properties__: {get_length:"get_length"}
};
mui.Lib = function() { };
$hxClasses["mui.Lib"] = mui.Lib;
mui.Lib.__name__ = ["mui","Lib"];
mui.Lib.__properties__ = {get_display:"get_display"}
mui.Lib.get_display = function() {
	if(mui.Lib.display == null) {
		mui.Lib.display = new mui.display.DisplayRoot();
		mui.device.Profile.init();
	}
	return mui.Lib.display;
};
mui.core.Behavior = function(target) {
	mui.core.Node.call(this);
	this.enabled = true;
	if(target != null) this.set_target(target);
	null;
};
$hxClasses["mui.core.Behavior"] = mui.core.Behavior;
mui.core.Behavior.__name__ = ["mui","core","Behavior"];
mui.core.Behavior.__super__ = mui.core.Node;
mui.core.Behavior.prototype = $extend(mui.core.Node.prototype,{
	enabled: null
	,target: null
	,set_target: function(value) {
		if(this.target != null) {
			this.remove();
			this.target.changed.remove($bind(this,this.targetChange));
		}
		this.target = value;
		if(this.target != null) {
			this.target.changed.add($bind(this,this.targetChange));
			this.add();
		}
		return this.target;
	}
	,targetChange: function(flag) {
		if(this.enabled) this.update(flag);
	}
	,add: function() {
	}
	,update: function(flag) {
	}
	,remove: function() {
	}
	,__class__: mui.core.Behavior
	,__properties__: {set_target:"set_target"}
});
mui.behavior = {};
mui.behavior.ButtonBehavior = function(target,externalAction) {
	mui.core.Behavior.call(this,target);
	this.externalAction = externalAction;
	this.focusOnPress = true;
	this.focusOnRelease = false;
	null;
};
$hxClasses["mui.behavior.ButtonBehavior"] = mui.behavior.ButtonBehavior;
mui.behavior.ButtonBehavior.__name__ = ["mui","behavior","ButtonBehavior"];
mui.behavior.ButtonBehavior.__super__ = mui.core.Behavior;
mui.behavior.ButtonBehavior.prototype = $extend(mui.core.Behavior.prototype,{
	focusOnPress: null
	,focusOnRelease: null
	,externalAction: null
	,add: function() {
		this.target.keyPressed.add($bind(this,this.keyPress));
		this.target.keyReleased.add($bind(this,this.keyRelease));
		this.target.touchStarted.add($bind(this,this.touchStart));
	}
	,remove: function() {
		this.target.keyPressed.remove($bind(this,this.keyPress));
		this.target.keyReleased.remove($bind(this,this.keyRelease));
		this.target.touchStarted.remove($bind(this,this.touchStart));
	}
	,press: function() {
		if(!this.target.enabled) return;
		if(this.focusOnPress && !this.target.focused) this.target.focus();
		this.target.set_pressed(true);
		if(mui.event.Input.mode == mui.event.InputMode.KEY) this.actionTarget();
	}
	,release: function() {
		if(!this.target.enabled) return;
		if(this.focusOnRelease && !this.target.focused) this.target.focus();
		this.target.set_pressed(false);
		if(mui.event.Input.mode == mui.event.InputMode.TOUCH) this.actionTarget();
	}
	,actionTarget: function() {
		if(this.externalAction != null) this.externalAction(); else this.target.action();
	}
	,change: function(flag) {
		mui.core.Behavior.prototype.change.call(this,flag);
		if(flag.enabled) this.target.set_useHandCursor(this.enabled);
	}
	,keyPress: function(key) {
		if(key.get_action() == mui.event.KeyAction.OK) {
			if(key.pressCount == 1) this.press();
			key.capture();
		}
	}
	,keyRelease: function(key) {
		if(key.get_action() == mui.event.KeyAction.OK) {
			this.release();
			key.capture();
		}
	}
	,touchStart: function(touch) {
		this.press();
		touch.completed.add($bind(this,this.inputCompleted));
		touch.captured.add($bind(this,this.inputCancelled));
	}
	,inputCompleted: function(touch) {
		this.release();
	}
	,inputCancelled: function(touch) {
		touch.completed.remove($bind(this,this.inputCompleted));
		this.target.set_pressed(false);
	}
	,__class__: mui.behavior.ButtonBehavior
});
mui.behavior.DragBehavior = function(target) {
	mui.core.Behavior.call(this,target);
	this.minimumX = this.minimumY = this.maximumX = this.maximumY = 0;
	this.dragStarted = new msignal.Signal0();
	this.dragUpdated = new msignal.Signal0();
	this.dragStopped = new msignal.Signal0();
	null;
};
$hxClasses["mui.behavior.DragBehavior"] = mui.behavior.DragBehavior;
mui.behavior.DragBehavior.__name__ = ["mui","behavior","DragBehavior"];
mui.behavior.DragBehavior.__super__ = mui.core.Behavior;
mui.behavior.DragBehavior.prototype = $extend(mui.core.Behavior.prototype,{
	minimumX: null
	,minimumY: null
	,maximumX: null
	,maximumY: null
	,dragStarted: null
	,dragUpdated: null
	,dragStopped: null
	,initialTargetX: null
	,initialTargetY: null
	,add: function() {
		this.target.touchStarted.add($bind(this,this.startDrag));
	}
	,remove: function() {
		this.target.touchStarted.remove($bind(this,this.startDrag));
	}
	,startDrag: function(touch) {
		if(!this.enabled) return;
		touch.capture();
		touch.updated.add($bind(this,this.updateDrag));
		touch.completed.add($bind(this,this.stopDrag));
		this.initialTargetX = this.target.x;
		this.initialTargetY = this.target.y;
		this.dragStarted.dispatch();
	}
	,updateDrag: function(touch) {
		var currentTargetX = this.initialTargetX + touch.get_totalChangeX();
		var currentTargetY = this.initialTargetY + touch.get_totalChangeY();
		this.target.set_x(Math.round(Math.min(this.maximumX,Math.max(this.minimumX,currentTargetX))));
		this.target.set_y(Math.round(Math.min(this.maximumY,Math.max(this.minimumY,currentTargetY))));
		this.dragUpdated.dispatch();
	}
	,stopDrag: function(touch) {
		touch.updated.remove($bind(this,this.updateDrag));
		touch.completed.remove($bind(this,this.stopDrag));
		this.dragStopped.dispatch();
	}
	,__class__: mui.behavior.DragBehavior
});
mui.behavior.InputTextHintBehavior = function(target) {
	mui.core.Behavior.call(this,target);
	null;
};
$hxClasses["mui.behavior.InputTextHintBehavior"] = mui.behavior.InputTextHintBehavior;
mui.behavior.InputTextHintBehavior.__name__ = ["mui","behavior","InputTextHintBehavior"];
mui.behavior.InputTextHintBehavior.__super__ = mui.core.Behavior;
mui.behavior.InputTextHintBehavior.prototype = $extend(mui.core.Behavior.prototype,{
	hint: null
	,add: function() {
		this.hint = new mui.display.Text();
		this.hint.set_left(this.target.left);
		this.hint.set_right(this.target.right);
		this.hint.set_centerY(this.target.centerY);
		this.hint.set_color(11119017);
		this.hint.set_font(this.target.font);
		this.hint.set_size(this.target.size);
		var parent = this.target.parent;
		parent.removeChild(this.target);
		parent.addChild(this.hint);
		parent.addChild(this.target);
		this.target.changed.add($bind(this,this.change));
	}
	,remove: function() {
		this.target.parent.removeChild(this.hint);
	}
	,update: function(flag) {
		if(flag.placeholder || flag.value) {
			this.hint.set_value(null);
			if(this.target.value == null || this.target.value == "") this.hint.set_value(this.target.placeholder);
		}
	}
	,__class__: mui.behavior.InputTextHintBehavior
});
mui.behavior.ScrollBehavior = function(target) {
	mui.core.Behavior.call(this,target);
	this.touchEnabled = true;
	this.animated = true;
	this.spring = 0.5;
	this.alignSelectionX = mui.layout.AlignX.center;
	this.alignSelectionY = mui.layout.AlignY.middle;
	this.constrainX = true;
	this.constrainY = true;
	this.inertiaEnabled = true;
	this.velocityX = 0;
	this.velocityY = 0;
	this.scrollX = true;
	this.scrollY = true;
	this.set_realScrollX(0);
	this.set_realScrollY(0);
	null;
};
$hxClasses["mui.behavior.ScrollBehavior"] = mui.behavior.ScrollBehavior;
mui.behavior.ScrollBehavior.__name__ = ["mui","behavior","ScrollBehavior"];
mui.behavior.ScrollBehavior.__super__ = mui.core.Behavior;
mui.behavior.ScrollBehavior.prototype = $extend(mui.core.Behavior.prototype,{
	constrainX: null
	,constrainY: null
	,spring: null
	,animated: null
	,tweenSettings: null
	,inertiaEnabled: null
	,touchEnabled: null
	,alignSelectionX: null
	,alignSelectionY: null
	,scrollX: null
	,scrollY: null
	,targetX: null
	,targetY: null
	,startScrollX: null
	,startScrollY: null
	,velocityX: null
	,velocityY: null
	,cancelled: null
	,activeTween: null
	,realScrollX: null
	,set_realScrollX: function(value) {
		if(this.target != null) this.target.set_scrollX(Math.round(value));
		return this.realScrollX = value;
	}
	,realScrollY: null
	,set_realScrollY: function(value) {
		if(this.target != null) this.target.set_scrollY(Math.round(value));
		return this.realScrollY = value;
	}
	,scrollTo: function(x,y,animate) {
		if(animate == null) animate = true;
		if(!this.enabled) return;
		this.targetX = x;
		if(this.constrainX) this.targetX = this.constrain(this.targetX,this.target.get_maxScrollX(),0);
		this.targetY = y;
		if(this.constrainY) this.targetY = this.constrain(this.targetY,this.target.get_maxScrollY(),0);
		if(mui.event.Key.get_held() || !this.animated) animate = false;
		if(this.tweenSettings != null && this.tweenSettings.onStart != null) this.tweenSettings.onStart();
		if(animate) {
			if(this.tweenSettings != null) {
				this.activeTween = new mui.transition.TimeTween(this,{ realScrollX : this.targetX, realScrollY : this.targetY},this.tweenSettings);
				this.targetX = this.targetY = null;
			} else mui.Lib.frameEntered.add($bind(this,this.updateInertia));
		} else {
			if(this.activeTween != null) {
				this.activeTween.cancel();
				this.activeTween = null;
			}
			this.set_realScrollX(this.targetX);
			this.set_realScrollY(this.targetY);
			if(this.tweenSettings != null && this.tweenSettings.onComplete != null) this.tweenSettings.onComplete();
		}
	}
	,setTarget: function(display,animate) {
		if(animate == null) animate = true;
		var selectionX = 0.0;
		var selectionY = 0.0;
		var scrollWidth = this.target.get_width();
		var scrollHeight = this.target.get_height();
		if(this.target.layout != null) {
			scrollWidth -= this.target.layout.paddingLeft + this.target.layout.paddingRight;
			scrollHeight -= this.target.layout.paddingTop + this.target.layout.paddingBottom;
		}
		var _g = this.alignSelectionX;
		switch(_g[1]) {
		case 0:
			selectionX = 0;
			break;
		case 1:
			selectionX = (scrollWidth - display.get_width()) * 0.5;
			break;
		case 2:
			selectionX = scrollWidth - display.get_width();
			break;
		}
		var _g1 = this.alignSelectionY;
		switch(_g1[1]) {
		case 0:
			selectionY = 0;
			break;
		case 1:
			selectionY = (scrollHeight - display.get_height()) * 0.5;
			break;
		case 2:
			selectionY = scrollHeight - display.get_height();
			break;
		}
		if(this.target.layout != null) {
			selectionX += this.target.layout.paddingLeft;
			selectionY += this.target.layout.paddingTop;
		}
		var x = Math.round(display.x - selectionX);
		var y = Math.round(display.y - selectionY);
		if(x != this.targetX || y != this.targetY) this.scrollTo(x,y,animate);
	}
	,add: function() {
		this.target.touchStarted.add($bind(this,this.startScroll));
		mui.Lib.frameEntered.add($bind(this,this.updateInertia));
	}
	,remove: function() {
		this.target.touchStarted.remove($bind(this,this.startScroll));
		mui.Lib.frameEntered.remove($bind(this,this.updateInertia));
	}
	,startScroll: function(touch) {
		if(!this.enabled || !this.touchEnabled) return;
		this.cancelled = false;
		this.velocityX = 0;
		this.velocityY = 0;
		this.targetX = null;
		this.targetY = null;
		this.startScrollX = Math.round(this.realScrollX);
		this.startScrollY = Math.round(this.realScrollY);
		touch.completed.add($bind(this,this.stopScroll));
		touch.updated.add($bind(this,this.updateScroll));
		touch.captured.add($bind(this,this.cancelScroll));
		mui.Lib.frameEntered.remove($bind(this,this.updateInertia));
	}
	,cancelScroll: function(touch) {
		this.cancelled = true;
		touch.completed.remove($bind(this,this.stopScroll));
		touch.updated.remove($bind(this,this.updateScroll));
		mui.Lib.frameEntered.add($bind(this,this.updateInertia));
		this.velocityX = this.velocityY = 0;
		this.set_realScrollX(this.startScrollX);
		this.set_realScrollY(this.startScrollY);
	}
	,updateScroll: function(touch) {
		if(!this.enabled || this.cancelled) return;
		var deltaX = Math.round(touch.get_totalChangeX());
		var deltaY = Math.round(touch.get_totalChangeY());
		if(!touch.isCaptured) {
			var delta = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
			if(delta > 2) {
				var direction = Math.abs(Math.round(Math.atan2(deltaY,deltaX) / (Math.PI / 2)));
				if(this.scrollX && (direction == 0 || direction == 2) || this.scrollY && direction == 1) {
					touch.captured.remove($bind(this,this.cancelScroll));
					touch.capture();
				}
			}
		}
		var newX = this.startScrollX - deltaX;
		var newY = this.startScrollY - deltaY;
		var maxScrollX = this.target.get_maxScrollX();
		var maxScrollY = this.target.get_maxScrollY();
		if(maxScrollX > 0) {
			if(this.constrainX) newX = this.constrain(newX,maxScrollX,this.spring);
			if(this.scrollX) this.set_realScrollX(newX);
		}
		if(maxScrollY > 0) {
			if(this.constrainY) newY = this.constrain(newY,maxScrollY,this.spring);
			if(this.scrollY) this.set_realScrollY(newY);
		}
	}
	,stopScroll: function(touch) {
		if(this.scrollX && this.target.get_maxScrollX() != 0) this.velocityX = touch.get_changeX(); else this.velocityX = 0;
		if(this.scrollY && this.target.get_maxScrollY() != 0) this.velocityY = touch.get_changeY(); else this.velocityY = 0;
		mui.Lib.frameEntered.add($bind(this,this.updateInertia));
	}
	,updateInertia: function() {
		if(!this.enabled) return;
		if(!this.inertiaEnabled) {
			if(this.constrainY && this.scrollY) {
				if(this.realScrollY < 0) this.set_realScrollY(0); else if(this.target.get_maxScrollY() > 0 && this.realScrollY > this.target.get_maxScrollY()) this.set_realScrollY(this.target.get_maxScrollY());
			} else if(this.constrainX && this.scrollX) {
				if(this.realScrollX < 0) this.set_realScrollX(0); else if(this.target.get_maxScrollX() > 0 && this.realScrollX > this.target.get_maxScrollX()) this.set_realScrollX(this.target.get_maxScrollX());
			}
			mui.Lib.frameEntered.remove($bind(this,this.updateInertia));
			return;
		}
		var frictionX = 0.92;
		var frictionY = 0.92;
		var acceleration = 0.4;
		var endX = this.targetX;
		var endY = this.targetY;
		var bounceX = false;
		var bounceY = false;
		if(this.targetX != null) {
			this.velocityX = (this.realScrollX - this.targetX) * acceleration;
			frictionX = 1;
		} else if(this.constrainX) {
			if(this.realScrollX < 0) {
				bounceX = this.realScrollX < -1;
				endX = 0;
				this.velocityX += this.realScrollX * 0.1;
				frictionX = 0.6;
			} else if(this.target.get_maxScrollX() > 0 && this.realScrollX > this.target.get_maxScrollX()) {
				bounceX = this.realScrollX > this.target.get_maxScrollX() + 1;
				endX = this.target.get_maxScrollX();
				this.velocityX += (this.realScrollX - endX) * 0.1;
				frictionX = 0.6;
			}
			if(this.spring == 0) {
				if(this.realScrollX <= 0) {
					this.velocityX = 0;
					this.set_realScrollX(0);
				} else if(this.realScrollX >= this.target.get_maxScrollX()) {
					this.velocityX = 0;
					this.set_realScrollX(this.target.get_maxScrollX());
				}
			}
		}
		if(this.targetY != null) {
			this.velocityY = (this.realScrollY - this.targetY) * acceleration;
			frictionY = 1;
		} else if(this.constrainY) {
			if(this.realScrollY < 0) {
				bounceY = this.realScrollY < -1;
				endY = 0;
				this.velocityY += this.realScrollY * 0.1;
				frictionY = 0.6;
			} else if(this.target.get_maxScrollY() > 0 && this.realScrollY > this.target.get_maxScrollY()) {
				bounceY = this.realScrollY > this.target.get_maxScrollY() + 1;
				endY = this.target.get_maxScrollY();
				this.velocityY += (this.realScrollY - endY) * 0.1;
				frictionY = 0.6;
			}
			if(this.spring == 0) {
				if(this.realScrollY <= 0) {
					this.velocityY = 0;
					this.set_realScrollY(0);
				} else if(this.realScrollY >= this.target.get_maxScrollY()) {
					this.velocityY = 0;
					this.set_realScrollY(this.target.get_maxScrollY());
				}
			}
		}
		if(this.scrollX) {
			this.velocityX *= frictionX;
			if(!bounceX && Math.abs(this.velocityX) < 0.2) {
				if(endX != null) this.set_realScrollX(endX); else {
					var _g = this;
					_g.set_realScrollX(_g.realScrollX - this.velocityX);
				}
				this.velocityX = 0;
			} else {
				var _g1 = this;
				_g1.set_realScrollX(_g1.realScrollX - this.velocityX);
			}
		}
		if(this.scrollY) {
			this.velocityY *= frictionY;
			if(!bounceY && Math.abs(this.velocityY) < 0.2) {
				if(endY != null) this.set_realScrollY(endY); else {
					var _g2 = this;
					_g2.set_realScrollY(_g2.realScrollY - this.velocityY);
				}
				this.velocityY = 0;
			} else {
				var _g3 = this;
				_g3.set_realScrollY(_g3.realScrollY - this.velocityY);
			}
		}
		if(this.velocityX == 0 && this.velocityY == 0) mui.Lib.frameEntered.remove($bind(this,this.updateInertia));
	}
	,constrain: function(value,maxValue,spring) {
		if(value < 0) return Math.round(value * spring);
		if(value > maxValue) return Math.round(maxValue + (value - maxValue) * spring);
		return value;
	}
	,__class__: mui.behavior.ScrollBehavior
	,__properties__: $extend(mui.core.Behavior.prototype.__properties__,{set_realScrollY:"set_realScrollY",set_realScrollX:"set_realScrollX"})
});
mui.control.ButtonEvent = { __ename__ : ["mui","control","ButtonEvent"], __constructs__ : ["BUTTON_ACTIONED"] };
mui.control.ButtonEvent.BUTTON_ACTIONED = ["BUTTON_ACTIONED",0];
mui.control.ButtonEvent.BUTTON_ACTIONED.toString = $estr;
mui.control.ButtonEvent.BUTTON_ACTIONED.__enum__ = mui.control.ButtonEvent;
mui.core.DataCollection = function(skin) {
	mui.core.DataContainer.call(this,skin);
	this.set_factory(new mui.core.ComponentFactory(mui.core.DataComponent));
	this.layout.enabled = true;
	this.scroller.enabled = true;
	null;
};
$hxClasses["mui.core.DataCollection"] = mui.core.DataCollection;
mui.core.DataCollection.__name__ = ["mui","core","DataCollection"];
mui.core.DataCollection.__super__ = mui.core.DataContainer;
mui.core.DataCollection.prototype = $extend(mui.core.DataContainer.prototype,{
	factory: null
	,set_factory: function(value) {
		return this.factory = this.changeValue("factory",value);
	}
	,updateData: function(value) {
		if((value instanceof Array) && value.__enum__ == null) this.set_childData(value);
	}
	,createComponent: function(data) {
		return this.factory.create(data);
	}
	,updateComponent: function(component,data) {
		this.factory.setData(component,data);
	}
	,childData: null
	,set_childData: function(value) {
		if(value == null) value = [];
		this.childData = value;
		var _g1 = 0;
		var _g = this.childData.length;
		while(_g1 < _g) {
			var i = _g1++;
			var child;
			if(i < this.numComponents) child = this.getComponentAt(i); else {
				child = this.createComponent(this.childData[i]);
				this.addComponent(child);
			}
			this.updateComponent(child,this.childData[i]);
			if(child == this.get_selectedComponent()) child.set_selected(true);
		}
		var _g11 = this.childData.length;
		var _g2 = this.numComponents;
		while(_g11 < _g2) {
			var i1 = _g11++;
			this.removeComponentAt(this.childData.length);
		}
		return this.childData;
	}
	,__class__: mui.core.DataCollection
	,__properties__: $extend(mui.core.DataContainer.prototype.__properties__,{set_childData:"set_childData",set_factory:"set_factory"})
});
mui.core.ComponentEvent = { __ename__ : ["mui","core","ComponentEvent"], __constructs__ : ["COMPONENT_ADDED","COMPONENT_REMOVED"] };
mui.core.ComponentEvent.COMPONENT_ADDED = ["COMPONENT_ADDED",0];
mui.core.ComponentEvent.COMPONENT_ADDED.toString = $estr;
mui.core.ComponentEvent.COMPONENT_ADDED.__enum__ = mui.core.ComponentEvent;
mui.core.ComponentEvent.COMPONENT_REMOVED = ["COMPONENT_REMOVED",1];
mui.core.ComponentEvent.COMPONENT_REMOVED.toString = $estr;
mui.core.ComponentEvent.COMPONENT_REMOVED.__enum__ = mui.core.ComponentEvent;
mui.core.ComponentFactory = function(component,skin) {
	this.set_component(component);
	this.set_skin(skin);
	this.getComponentType = $bind(this,this.getDefaultComponentType);
};
$hxClasses["mui.core.ComponentFactory"] = mui.core.ComponentFactory;
mui.core.ComponentFactory.__name__ = ["mui","core","ComponentFactory"];
mui.core.ComponentFactory.prototype = {
	component: null
	,set_component: function(value) {
		return this.component = value;
	}
	,skin: null
	,set_skin: function(value) {
		return this.skin = value;
	}
	,getComponentType: null
	,getDefaultComponentType: function(data) {
		if(js.Boot.__instanceof(this.component,Class)) return this.component; else return null;
	}
	,create: function(data) {
		var componentType = this.getComponentType(data);
		var componentInstance = null;
		if(!(this.component != null || componentType != null)) throw "Assertion failed: " + "factory component type is `null`";
		if(Reflect.isFunction(this.component)) componentInstance = this.component.apply(null,[data]); else if(componentType != null) {
			var skinInstance = this.createSkin(data);
			var params;
			if(this.skin == null) params = []; else params = [skinInstance];
			componentInstance = Type.createInstance(componentType,params);
		}
		return componentInstance;
	}
	,createSkin: function(data) {
		var skinInstance = null;
		if(Reflect.isFunction(this.skin)) skinInstance = this.skin.apply(null,[data]); else if(js.Boot.__instanceof(this.skin,Class)) skinInstance = Type.createInstance(this.skin,[]);
		return skinInstance;
	}
	,setData: function(component,data) {
		component.set_data(data);
	}
	,__class__: mui.core.ComponentFactory
	,__properties__: {set_skin:"set_skin",set_component:"set_component"}
};
mui.core._Container = {};
mui.core._Container.ContainerContent = function() {
	mui.display.Display.call(this);
	null;
};
$hxClasses["mui.core._Container.ContainerContent"] = mui.core._Container.ContainerContent;
mui.core._Container.ContainerContent.__name__ = ["mui","core","_Container","ContainerContent"];
mui.core._Container.ContainerContent.__super__ = mui.display.Display;
mui.core._Container.ContainerContent.prototype = $extend(mui.display.Display.prototype,{
	__class__: mui.core._Container.ContainerContent
});
mui.core.ContainerEvent = { __ename__ : ["mui","core","ContainerEvent"], __constructs__ : ["SELECTION_CHANGED"] };
mui.core.ContainerEvent.SELECTION_CHANGED = ["SELECTION_CHANGED",0];
mui.core.ContainerEvent.SELECTION_CHANGED.toString = $estr;
mui.core.ContainerEvent.SELECTION_CHANGED.__enum__ = mui.core.ContainerEvent;
mui.core.Navigator = function(target) {
	mui.core.Behavior.call(this,target);
	this.skipDisabled = true;
	null;
};
$hxClasses["mui.core.Navigator"] = mui.core.Navigator;
mui.core.Navigator.__name__ = ["mui","core","Navigator"];
mui.core.Navigator.__super__ = mui.core.Behavior;
mui.core.Navigator.prototype = $extend(mui.core.Behavior.prototype,{
	skipDisabled: null
	,closest: function(component) {
		if(component.enabled) return component;
		var index = component.index;
		var nextComponent = this.get(index,mui.layout.Direction.next);
		var previousComponent = this.get(index,mui.layout.Direction.previous);
		var _g1 = 0;
		var _g = this.target.numComponents;
		while(_g1 < _g) {
			var i = _g1++;
			if(nextComponent != null) {
				if(nextComponent.enabled) return nextComponent;
				nextComponent = this.get(index,mui.layout.Direction.next);
			}
			if(previousComponent != null) {
				if(previousComponent.enabled) return previousComponent;
				previousComponent = this.get(index,mui.layout.Direction.previous);
			}
		}
		return null;
	}
	,next: function(component,direction) {
		var index = component.index;
		var nextComponent = this.get(index,direction);
		var prevComponent = null;
		while(nextComponent != null && nextComponent != component && nextComponent != prevComponent) {
			if(nextComponent.enabled) return nextComponent; else if(!this.skipDisabled) return null;
			prevComponent = nextComponent;
			nextComponent = this.get(nextComponent.index,direction);
		}
		return null;
	}
	,get: function(index,direction) {
		var next = this.target.layout.next(index,direction);
		if(next == -1) return null;
		return this.target.getComponentAt(next);
	}
	,__class__: mui.core.Navigator
});
mui.core.Skin = function(target) {
	mui.core.Behavior.call(this,target);
	this.minWidth = 0;
	this.minHeight = 0;
	this.maxWidth = 5000;
	this.maxHeight = 5000;
	this.defaultWidth = null;
	this.defaultHeight = null;
	this.properties = { };
	this.parts = [];
	this.defaultStyles = { };
	this.set_styles({ });
	null;
};
$hxClasses["mui.core.Skin"] = mui.core.Skin;
mui.core.Skin.__name__ = ["mui","core","Skin"];
mui.core.Skin.__super__ = mui.core.Behavior;
mui.core.Skin.prototype = $extend(mui.core.Behavior.prototype,{
	minWidth: null
	,minHeight: null
	,maxWidth: null
	,maxHeight: null
	,defaultWidth: null
	,defaultHeight: null
	,properties: null
	,parts: null
	,add: function() {
		this.copy(this.properties,this.target);
		var _g = 0;
		var _g1 = this.parts;
		while(_g < _g1.length) {
			var part = _g1[_g];
			++_g;
			this.target.addChild(part);
		}
		this.measure();
	}
	,remove: function() {
		var _g = 0;
		var _g1 = this.parts;
		while(_g < _g1.length) {
			var part = _g1[_g];
			++_g;
			this.target.removeChild(part);
		}
	}
	,measure: function() {
		if(this.defaultWidth != null) this.target.set_width(this.defaultWidth); else if(this.target.get_width() > this.maxWidth) this.target.set_width(this.maxWidth); else if(this.target.get_width() < this.minWidth) this.target.set_width(this.minWidth);
		if(this.defaultHeight != null) this.target.set_height(this.defaultHeight); else if(this.target.get_height() > this.maxHeight) this.target.set_height(this.maxHeight); else if(this.target.get_height() < this.minHeight) this.target.set_height(this.minHeight);
	}
	,addChild: function(child) {
		this.parts.push(child);
	}
	,defaultStyles: null
	,styles: null
	,set_styles: function(value) {
		return this.styles = this.changeValue("styles",this.mergeStyles(value));
	}
	,appendStyles: function(fromStyles) {
		this.set_styles(this.mergeStyles(fromStyles,this.styles));
		this.changeValue("styles",this.styles);
	}
	,revertStyles: function() {
		this.set_styles(this.mergeStyles({ }));
		this.changeValue("styles",this.styles);
	}
	,mergeStyles: function(fromStyles,existingStyles) {
		var o = { };
		this.copy(this.defaultStyles,o);
		if(existingStyles != null) this.copy(existingStyles,o);
		this.copy(fromStyles,o);
		return o;
	}
	,copy: function(fromObject,toObject) {
		var _g = 0;
		var _g1 = Reflect.fields(fromObject);
		while(_g < _g1.length) {
			var field = _g1[_g];
			++_g;
			var fromValue = Reflect.field(fromObject,field);
			var toValue = Reflect.field(toObject,field);
			if(this.isMergable(fromValue) && this.isMergable(toValue)) this.copy(fromValue,toValue); else Reflect.setProperty(toObject,field,fromValue);
		}
	}
	,isMergable: function(value) {
		{
			var _g = Type["typeof"](value);
			switch(_g[1]) {
			case 6:case 4:
				return !(typeof(value) == "string");
			default:
				return false;
			}
		}
	}
	,__class__: mui.core.Skin
	,__properties__: $extend(mui.core.Behavior.prototype.__properties__,{set_styles:"set_styles"})
});
mui.device = {};
mui.device.Profile = function() { };
$hxClasses["mui.device.Profile"] = mui.device.Profile;
mui.device.Profile.__name__ = ["mui","device","Profile"];
mui.device.Profile.init = function() {
	mui.event.Key.manager.set_map(new mui.event.KeyMap());
};
mui.display.AssetLibraryLoader = function(url,library) {
	mloader.LoaderBase.call(this,url);
	if(library == null) library = new mui.display.AssetLibrary();
	this.library = library;
};
$hxClasses["mui.display.AssetLibraryLoader"] = mui.display.AssetLibraryLoader;
mui.display.AssetLibraryLoader.__name__ = ["mui","display","AssetLibraryLoader"];
mui.display.AssetLibraryLoader.__super__ = mloader.LoaderBase;
mui.display.AssetLibraryLoader.prototype = $extend(mloader.LoaderBase.prototype,{
	library: null
	,loaderLoad: function() {
		var loader = new mloader.XmlObjectLoader();
		loader.mapNode("assets","Array");
		loader.mapNode("parts","Array");
		loader.mapClass("image",mui.display.ImageAsset);
		loader.mapClass("part",mui.display.ImageAssetPart);
		loader.loaded.add($bind(this,this.xmlComplete)).forType(mloader.LoaderEventType.Complete);
		loader.set_url(this.url);
		loader.load();
	}
	,loaderCancel: function() {
	}
	,xmlComplete: function(event) {
		var assets = event.target.content;
		var _g = 0;
		while(_g < assets.length) {
			var asset = assets[_g];
			++_g;
			var _g1 = 0;
			var _g2 = asset.parts;
			while(_g1 < _g2.length) {
				var part = _g2[_g1];
				++_g1;
				part.configure(asset);
			}
			this.library.set(asset.uri,asset);
		}
		this.preload(assets);
	}
	,preload: function(assets) {
		var loaderQueue = new mloader.LoaderQueue();
		if(assets.length == 0) this.preloadComplete(null);
		loaderQueue.loaded.add($bind(this,this.preloadComplete)).forType(mloader.LoaderEventType.Complete);
		var _g = 0;
		while(_g < assets.length) {
			var asset = assets[_g];
			++_g;
			var loader = new mloader.ImageLoader();
			loader.set_url(this.library.resolveURI(asset.uri));
			loaderQueue.add(loader);
		}
		loaderQueue.load();
	}
	,preloadComplete: function(_) {
		this.loaderComplete();
	}
	,__class__: mui.display.AssetLibraryLoader
});
mui.display.GraphicStyle = function() { };
$hxClasses["mui.display.GraphicStyle"] = mui.display.GraphicStyle;
mui.display.GraphicStyle.__name__ = ["mui","display","GraphicStyle"];
mui.display.GraphicStyle.__interfaces__ = [mui.core.Changeable];
mui.display.GraphicStyle.prototype = {
	applyFill: null
	,applyStroke: null
	,__class__: mui.display.GraphicStyle
};
mui.display.Bitmap = function(url) {
	mui.core.Node.call(this);
	this.loadCompleted = new msignal.Signal0();
	this.loadFailed = new msignal.Signal0();
	this.set_url("");
	this.set_scaleMode(mui.display.ScaleMode.NONE);
	this.bitmap = this.changeValue("bitmap",null);
	this.bitmapWidth = this.changeValue("bitmapWidth",0);
	this.bitmapHeight = this.changeValue("bitmapHeight",0);
	if(url != null) this.set_url(url);
	null;
};
$hxClasses["mui.display.Bitmap"] = mui.display.Bitmap;
mui.display.Bitmap.__name__ = ["mui","display","Bitmap"];
mui.display.Bitmap.__interfaces__ = [mui.display.GraphicStyle];
mui.display.Bitmap.__super__ = mui.core.Node;
mui.display.Bitmap.prototype = $extend(mui.core.Node.prototype,{
	loadCompleted: null
	,loadFailed: null
	,url: null
	,scaleMode: null
	,bitmap: null
	,bitmapWidth: null
	,bitmapHeight: null
	,applyFill: function(graphic) {
		graphic.setStyle("backgroundImage","url('" + this.url + "')");
		var _g = this.scaleMode;
		switch(_g[1]) {
		case 1:
			graphic.setStyle("backgroundPosition","50% 50%");
			break;
		case 0:
			graphic.setStyle("backgroundPosition","50% 50%");
			break;
		case 2:
			graphic.setStyle("backgroundPosition","50% 50%");
			break;
		case 3:
			graphic.setStyle("backgroundRepeat","repeat");
			break;
		}
	}
	,applyStroke: function(graphic) {
		graphic.setStyle(JS.prefix == ""?"borderImage":JS.prefix + "borderImage".charAt(0).toUpperCase() + HxOverrides.substr("borderImage",1,null),"url('" + this.url + "')");
	}
	,set_url: function(v) {
		return this.url = this.changeValue("url",v);
	}
	,set_scaleMode: function(v) {
		return this.scaleMode = this.changeValue("scaleMode",v);
	}
	,__class__: mui.display.Bitmap
	,__properties__: {set_scaleMode:"set_scaleMode",set_url:"set_url"}
});
mui.display.ScaleMode = { __ename__ : ["mui","display","ScaleMode"], __constructs__ : ["FILL","FIT","STRETCH","NONE"] };
mui.display.ScaleMode.FILL = ["FILL",0];
mui.display.ScaleMode.FILL.toString = $estr;
mui.display.ScaleMode.FILL.__enum__ = mui.display.ScaleMode;
mui.display.ScaleMode.FIT = ["FIT",1];
mui.display.ScaleMode.FIT.toString = $estr;
mui.display.ScaleMode.FIT.__enum__ = mui.display.ScaleMode;
mui.display.ScaleMode.STRETCH = ["STRETCH",2];
mui.display.ScaleMode.STRETCH.toString = $estr;
mui.display.ScaleMode.STRETCH.__enum__ = mui.display.ScaleMode;
mui.display.ScaleMode.NONE = ["NONE",3];
mui.display.ScaleMode.NONE.toString = $estr;
mui.display.ScaleMode.NONE.__enum__ = mui.display.ScaleMode;
mui.display.Color = function(value,alpha) {
	if(alpha == null) alpha = 1.0;
	if(value == null) value = 16777215;
	mui.core.Node.call(this);
	this.set_value(16777215);
	this.set_alpha(1.0);
	this.set_value(value);
	this.set_alpha(alpha);
	null;
};
$hxClasses["mui.display.Color"] = mui.display.Color;
mui.display.Color.__name__ = ["mui","display","Color"];
mui.display.Color.__interfaces__ = [mui.display.GraphicStyle];
mui.display.Color.fromGray = function(gray) {
	if(gray < 0) gray = 0; else if(gray > 1) gray = 1; else gray = gray;
	return mui.display.Color.fromRGB(gray,gray,gray);
};
mui.display.Color.toGray = function(color) {
	return 0.3 * ((color >> 16 & 255) / 255) + 0.59 * ((color >> 8 & 255) / 255) + 0.11 * ((color & 255) / 255);
};
mui.display.Color.fromRGB = function(red,green,blue) {
	red = (red < 0?0:red > 1?1:red) * 255;
	green = (green < 0?0:green > 1?1:green) * 255;
	blue = (blue < 0?0:blue > 1?1:blue) * 255;
	return Math.round(red) << 16 | Math.round(green) << 8 | Math.round(blue);
};
mui.display.Color.toRGB = function(color) {
	return { red : (color >> 16 & 255) / 255, green : (color >> 8 & 255) / 255, blue : (color & 255) / 255};
};
mui.display.Color.toRed = function(color) {
	return (color >> 16 & 255) / 255;
};
mui.display.Color.toGreen = function(color) {
	return (color >> 8 & 255) / 255;
};
mui.display.Color.toBlue = function(color) {
	return (color & 255) / 255;
};
mui.display.Color.fromHSL = function(hue,saturation,lightness) {
	hue = mcore.util.Floats.wrap(hue,0,1);
	if(saturation < 0) saturation = 0; else if(saturation > 1) saturation = 1; else saturation = saturation;
	if(lightness < 0) lightness = 0; else if(lightness > 1) lightness = 1; else lightness = lightness;
	var red;
	var green;
	var blue;
	if(saturation == 0) red = green = blue = lightness; else {
		var q;
		if(lightness < 0.5) q = lightness * (1 + saturation); else q = lightness + saturation - lightness * saturation;
		var p = 2 * lightness - q;
		red = mui.display.Color.hue2rgb(p,q,hue + 0.333333333333333315);
		green = mui.display.Color.hue2rgb(p,q,hue);
		blue = mui.display.Color.hue2rgb(p,q,hue - 0.333333333333333315);
	}
	return mui.display.Color.fromRGB(red,green,blue);
};
mui.display.Color.toHSL = function(color) {
	var r = (color >> 16 & 255) / 255;
	var g = (color >> 8 & 255) / 255;
	var b = (color & 255) / 255;
	var max = Math.max(r,Math.max(g,b));
	var min = Math.min(r,Math.min(g,b));
	var h;
	var s;
	var l;
	h = s = l = (max + min) / 2;
	if(max == min) h = s = 0; else {
		var d = max - min;
		if(l > 0.5) s = d / (2 - max - min); else s = d / (max + min);
		if(max == r) h = (g - b) / d + (g < b?6:0); else if(max == g) h = (b - r) / d + 2; else h = (r - g) / d + 4;
		h /= 6;
	}
	return { hue : h, saturation : s, lightness : l};
};
mui.display.Color.toHue = function(color) {
	return mui.display.Color.toHSL(color).hue;
};
mui.display.Color.toSaturation = function(color) {
	return mui.display.Color.toHSL(color).saturation;
};
mui.display.Color.toLightness = function(color) {
	return mui.display.Color.toHSL(color).lightness;
};
mui.display.Color.spin = function(color,amount) {
	var hsl = mui.display.Color.toHSL(color);
	return mui.display.Color.fromHSL(hsl.hue + amount,hsl.saturation,hsl.lightness);
};
mui.display.Color.saturate = function(color,amount) {
	var hsl = mui.display.Color.toHSL(color);
	return mui.display.Color.fromHSL(hsl.hue,hsl.saturation + amount,hsl.lightness);
};
mui.display.Color.desaturate = function(color,amount) {
	var hsl = mui.display.Color.toHSL(color);
	return mui.display.Color.fromHSL(hsl.hue,hsl.saturation - amount,hsl.lightness);
};
mui.display.Color.lighten = function(color,amount) {
	var hsl = mui.display.Color.toHSL(color);
	return mui.display.Color.fromHSL(hsl.hue,hsl.saturation,hsl.lightness + amount);
};
mui.display.Color.darken = function(color,amount) {
	var hsl = mui.display.Color.toHSL(color);
	return mui.display.Color.fromHSL(hsl.hue,hsl.saturation,hsl.lightness - amount);
};
mui.display.Color.hue2rgb = function(p,q,t) {
	if(t < 0) t += 1;
	if(t > 1) t -= 1;
	if(t < 0.166666666666666657) return p + (q - p) * 6 * t;
	if(t < 0.5) return q;
	if(t < 0.66666666666666663) return p + (q - p) * (0.66666666666666663 - t) * 6;
	return p;
};
mui.display.Color.toHexString = function(color) {
	return "0x" + StringTools.lpad(StringTools.hex(color),"0",6);
};
mui.display.Color.toHexStyle = function(color) {
	return "#" + StringTools.lpad(StringTools.hex(color),"0",6);
};
mui.display.Color.toRGBStyle = function(color) {
	var rgb = mui.display.Color.toRGB(color);
	return "rgb(" + Math.floor(rgb.red * 255) + "," + Math.floor(rgb.green * 255) + "," + Math.floor(rgb.blue * 255) + ")";
};
mui.display.Color.toRGBAStyle = function(color,alpha) {
	var rgb = mui.display.Color.toRGB(color);
	return "rgba(" + Math.floor(rgb.red * 255) + "," + Math.floor(rgb.green * 255) + "," + Math.floor(rgb.blue * 255) + "," + alpha + ")";
};
mui.display.Color.toInt = function(c) {
	switch(c[1]) {
	case 0:
		return 0;
	case 1:
		return 16777215;
	case 2:
		return 16711680;
	case 3:
		return 65280;
	case 4:
		return 255;
	case 5:
		return 16776960;
	case 6:
		return 65535;
	case 7:
		return 16711935;
	case 8:
		var value = c[2];
		return mui.display.Color.fromGray(value);
	case 9:
		var blue = c[4];
		var green = c[3];
		var red = c[2];
		return mui.display.Color.fromRGB(red,green,blue);
	case 10:
		var lightness = c[4];
		var saturation = c[3];
		var hue = c[2];
		return mui.display.Color.fromHSL(hue,saturation,lightness);
	}
};
mui.display.Color.__super__ = mui.core.Node;
mui.display.Color.prototype = $extend(mui.core.Node.prototype,{
	value: null
	,alpha: null
	,applyFill: function(graphic) {
		graphic.setStyle("backgroundColor",mui.display.Color.toRGBAStyle(this.value,this.alpha));
		graphic.setStyle("backgroundImage",null);
	}
	,applyStroke: function(graphic) {
		graphic.setStyle("borderColor",mui.display.Color.toRGBAStyle(this.value,this.alpha));
	}
	,set_value: function(v) {
		return this.value = this.changeValue("value",v);
	}
	,set_alpha: function(v) {
		return this.alpha = this.changeValue("alpha",v);
	}
	,__class__: mui.display.Color
	,__properties__: {set_alpha:"set_alpha",set_value:"set_value"}
});
mui.display.ColorValue = { __ename__ : ["mui","display","ColorValue"], __constructs__ : ["black","white","red","green","blue","yellow","aqua","fuchsia","gray","rgb","hsl"] };
mui.display.ColorValue.black = ["black",0];
mui.display.ColorValue.black.toString = $estr;
mui.display.ColorValue.black.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.white = ["white",1];
mui.display.ColorValue.white.toString = $estr;
mui.display.ColorValue.white.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.red = ["red",2];
mui.display.ColorValue.red.toString = $estr;
mui.display.ColorValue.red.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.green = ["green",3];
mui.display.ColorValue.green.toString = $estr;
mui.display.ColorValue.green.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.blue = ["blue",4];
mui.display.ColorValue.blue.toString = $estr;
mui.display.ColorValue.blue.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.yellow = ["yellow",5];
mui.display.ColorValue.yellow.toString = $estr;
mui.display.ColorValue.yellow.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.aqua = ["aqua",6];
mui.display.ColorValue.aqua.toString = $estr;
mui.display.ColorValue.aqua.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.fuchsia = ["fuchsia",7];
mui.display.ColorValue.fuchsia.toString = $estr;
mui.display.ColorValue.fuchsia.__enum__ = mui.display.ColorValue;
mui.display.ColorValue.gray = function(value) { var $x = ["gray",8,value]; $x.__enum__ = mui.display.ColorValue; $x.toString = $estr; return $x; };
mui.display.ColorValue.rgb = function(red,green,blue) { var $x = ["rgb",9,red,green,blue]; $x.__enum__ = mui.display.ColorValue; $x.toString = $estr; return $x; };
mui.display.ColorValue.hsl = function(hue,saturation,lightness) { var $x = ["hsl",10,hue,saturation,lightness]; $x.__enum__ = mui.display.ColorValue; $x.toString = $estr; return $x; };
mui.display.DisplayRoot = function() {
	mui.display.Rectangle.call(this);
	this.defaultFrameRate = 16;
	this.previousMouseX = 0;
	this.previousMouseY = 0;
	null;
};
$hxClasses["mui.display.DisplayRoot"] = mui.display.DisplayRoot;
mui.display.DisplayRoot.__name__ = ["mui","display","DisplayRoot"];
mui.display.DisplayRoot.__super__ = mui.display.Rectangle;
mui.display.DisplayRoot.prototype = $extend(mui.display.Rectangle.prototype,{
	touch: null
	,previousMouseX: null
	,previousMouseY: null
	,defaultFrameRate: null
	,checkMouseMove: function() {
		if(this.enabled && (this.get_mouseX() != this.previousMouseX || this.get_mouseY() != this.previousMouseY)) {
			mui.Lib.mouseMoved.dispatch();
			if(this.touch != null) this.touch.updatePosition(this.get_mouseX(),this.get_mouseY());
			this.previousMouseX = this.get_mouseX();
			this.previousMouseY = this.get_mouseY();
		}
	}
	,setDefaultFrameRate: function(value) {
		this.defaultFrameRate = value;
	}
	,document: null
	,window: null
	,eventListeners: null
	,_new: function() {
		mui.display.Rectangle.prototype._new.call(this);
		this.eventListeners = [];
		this.document = window.document;
		this.window = window;
		var body = this.document.body;
		body.appendChild(this.element);
		this.addEventListener(this.window,"keydown",$bind(this,this.keyDown));
		this.addEventListener(this.window,"keyup",$bind(this,this.keyUp));
		if(Object.prototype.hasOwnProperty.call(this.document,"ontouchstart")) {
			this.addEventListener(body,"touchstart",$bind(this,this._touchStart));
			this.addEventListener(body,"touchend",$bind(this,this._touchEnd));
			this.addEventListener(body,"touchmove",$bind(this,this._touchMove));
		} else {
			this.addEventListener(body,"mousedown",$bind(this,this.mouseDown));
			this.addEventListener(body,"mouseup",$bind(this,this.mouseUp));
			this.addEventListener(body,"mousemove",$bind(this,this.mouseMove));
		}
		this.addEventListener(this.window,"resize",$bind(this,this.resize));
		if(Object.prototype.hasOwnProperty.call(this.window,"orientation")) {
			var orientation = this.angleToOrientation(this.window.orientation);
			mui.event.Screen.reorient(orientation);
			this.addEventListener(this.window,"orientationchange",$bind(this,this.reorient));
		}
		this.set_width(this.window.innerWidth);
		this.set_height(this.window.innerHeight);
		mui.event.Screen.resize(this.get_width(),this.get_height());
		this.window.requestAnimationFrame($bind(this,this.enterFrame),this.element);
	}
	,destroy: function() {
		this.removeAllEventListeners();
		mui.display.Rectangle.prototype.destroy.call(this);
	}
	,enterFrame: function() {
		this.checkMouseMove();
		mui.Lib.frameEntered.dispatch();
		mui.Lib.frameRendered.dispatch();
		this.window.requestAnimationFrame($bind(this,this.enterFrame),this.element);
	}
	,keyDown: function(e) {
		if(!this.enabled) return;
		var keyCode = e.keyCode;
		var key = new mui.event.Key(keyCode);
		mui.event.Key.press(key);
		if(key.isCaptured) this.cancelEvent(e);
	}
	,keyUp: function(e) {
		if(!this.enabled) return;
		var keyCode = e.keyCode;
		var key = new mui.event.Key(keyCode);
		mui.event.Key.release(key);
		if(key.isCaptured) this.cancelEvent(e);
	}
	,mouseDown: function(e) {
		if(!this.enabled || Object.prototype.hasOwnProperty.call(e,"button") && e.button != 0) return;
		this.mouseX = e.clientX;
		this.mouseY = e.clientY;
		this.touch = new mui.event.Touch(e.clientX,e.clientY);
		mui.event.Touch.start(this.touch);
	}
	,mouseUp: function(e) {
		if(!this.enabled) return;
		if(this.touch != null) {
			this.touch.complete();
			this.touch = null;
		}
	}
	,mouseMove: function(e) {
		if(!this.enabled) return;
		this.mouseX = e.clientX;
		this.mouseY = e.clientY;
	}
	,_touchStart: function(e) {
		this.mouseDown(e.touches[0]);
	}
	,_touchEnd: function(e) {
		this.mouseUp(e.touches[0]);
	}
	,_touchMove: function(e) {
		this.mouseMove(e.touches[0]);
	}
	,resize: function(e) {
		this.set_width(this.window.innerWidth);
		this.set_height(this.window.innerHeight);
		mui.core.Node.validator.validate();
		mui.event.Screen.resize(this.get_width(),this.get_height());
	}
	,reorient: function(e) {
		var newOrientation = this.angleToOrientation(this.window.orientation);
		mui.event.Screen.reorient(newOrientation);
	}
	,angleToOrientation: function(angle) {
		switch(angle) {
		case 90:
			return mui.event.ScreenOrientation.LandscapeRight;
		case 180:
			return mui.event.ScreenOrientation.PortraitUpsideDown;
		case -90:
			return mui.event.ScreenOrientation.LandscapeLeft;
		default:
			return mui.event.ScreenOrientation.Portrait;
		}
	}
	,addEventListener: function(element,event,handler) {
		var obj = { element : element, event : event, handler : Dynamic};
		this.eventListeners.push(obj);
		element.addEventListener(event,handler,false);
	}
	,removeAllEventListeners: function() {
		var _g = 0;
		var _g1 = this.eventListeners;
		while(_g < _g1.length) {
			var obj = _g1[_g];
			++_g;
			this.removeEventListener(obj.element,obj.event,obj.handler);
		}
		this.eventListeners = [];
	}
	,removeEventListener: function(element,event,handler) {
		element.removeEventListener(event,handler,false);
	}
	,cancelEvent: function(event) {
		event.preventDefault();
		event.stopPropagation();
	}
	,__class__: mui.display.DisplayRoot
});
mui.display.Gradient = function(colors,rotation) {
	if(rotation == null) rotation = 0.0;
	mui.core.Node.call(this);
	this.set_colors([]);
	this.set_rotation(0);
	if(colors != null) this.set_colors(colors);
	this.set_rotation(rotation);
	null;
};
$hxClasses["mui.display.Gradient"] = mui.display.Gradient;
mui.display.Gradient.__name__ = ["mui","display","Gradient"];
mui.display.Gradient.__interfaces__ = [mui.display.GraphicStyle];
mui.display.Gradient.__super__ = mui.core.Node;
mui.display.Gradient.prototype = $extend(mui.core.Node.prototype,{
	colors: null
	,rotation: null
	,clone: function() {
		return new mui.display.Gradient(this.colors,this.rotation);
	}
	,applyFill: function(graphic) {
		var styles = [];
		var _g = 0;
		var _g1 = this.colors;
		while(_g < _g1.length) {
			var color = _g1[_g];
			++_g;
			var rgbaStyle = mui.display.Color.toRGBAStyle(color.value,color.alpha);
			styles.push(rgbaStyle + " " + Math.round(color.position * 100) + "%");
		}
		graphic.setStyle("backgroundColor",mui.display.Color.toRGBAStyle(this.colors[0].value,this.colors[0].alpha));
		var gradient;
		gradient = (JS.prefix == ""?"linear-gradient(":"-" + JS.prefix + "-" + "linear-gradient(") + (-this.rotation | 0) + "deg," + styles.join(",") + ")";
		graphic.setStyle("backgroundImage",gradient);
	}
	,applyStroke: function(graphic) {
		graphic.setStyle("borderColor",mui.display.Color.toRGBStyle(this.colors[0].value));
	}
	,set_colors: function(v) {
		return this.colors = this.changeValue("colors",v);
	}
	,set_rotation: function(v) {
		return this.rotation = this.changeValue("rotation",v);
	}
	,__class__: mui.display.Gradient
	,__properties__: {set_rotation:"set_rotation",set_colors:"set_colors"}
});
mui.display.GradientColor = function(value,alpha,position) {
	if(position == null) position = 0.0;
	if(alpha == null) alpha = 1.0;
	mui.display.Color.call(this,value,alpha);
	this.set_position(0.0);
	this.set_position(position);
	null;
};
$hxClasses["mui.display.GradientColor"] = mui.display.GradientColor;
mui.display.GradientColor.__name__ = ["mui","display","GradientColor"];
mui.display.GradientColor.__super__ = mui.display.Color;
mui.display.GradientColor.prototype = $extend(mui.display.Color.prototype,{
	position: null
	,set_position: function(v) {
		return this.position = this.changeValue("position",v);
	}
	,__class__: mui.display.GradientColor
	,__properties__: $extend(mui.display.Color.prototype.__properties__,{set_position:"set_position"})
});
mui.display.Icon = function(type,size,color) {
	if(color == null) color = 0;
	if(size == null) size = 32;
	if(type == null) type = "";
	mui.display.Rectangle.call(this);
	this.text = new mui.display.Text();
	this.addChild(this.text);
	this.text.set_centerX(0.5);
	this.text.set_centerY(0.35);
	this.set_color(color);
	this.set_type(type);
	this.set_size(size);
	this.set_font("FontAwesome");
};
$hxClasses["mui.display.Icon"] = mui.display.Icon;
mui.display.Icon.__name__ = ["mui","display","Icon"];
mui.display.Icon.__super__ = mui.display.Rectangle;
mui.display.Icon.prototype = $extend(mui.display.Rectangle.prototype,{
	text: null
	,get_color: function() {
		return this.text.color;
	}
	,set_color: function(value) {
		return this.text.set_color(value);
	}
	,get_type: function() {
		return this.text.value;
	}
	,set_type: function(value) {
		return this.text.set_value(value);
	}
	,get_size: function() {
		return this.text.size;
	}
	,set_size: function(value) {
		return this.text.set_size(this.set_width(this.set_height(value)));
	}
	,get_font: function() {
		return this.text.font;
	}
	,set_font: function(value) {
		return this.text.set_font(value);
	}
	,__class__: mui.display.Icon
	,__properties__: $extend(mui.display.Rectangle.prototype.__properties__,{set_font:"set_font",get_font:"get_font",set_size:"set_size",get_size:"get_size",set_type:"set_type",get_type:"get_type",set_color:"set_color",get_color:"get_color"})
});
mui.display.Image = function() {
	mui.display.Rectangle.call(this);
	this.set_loader(new mloader.ImageLoader());
	this.image = window.document.createElement("img");
	this.element.appendChild(this.image);
	this.image.onmousedown = function(e) {
		e.preventDefault();
	};
	this.set_url("");
	this.set_autoSize(true);
	this.imageWidth = 0;
	this.imageHeight = 0;
	this.set_scaleMode(mui.display.ScaleMode.NONE);
	this.loaded = new msignal.Signal0();
	this.failed = new msignal.Signal0();
	null;
};
$hxClasses["mui.display.Image"] = mui.display.Image;
mui.display.Image.__name__ = ["mui","display","Image"];
mui.display.Image.__super__ = mui.display.Rectangle;
mui.display.Image.prototype = $extend(mui.display.Rectangle.prototype,{
	url: null
	,autoSize: null
	,scaleMode: null
	,loaded: null
	,failed: null
	,imageWidth: null
	,imageHeight: null
	,loader: null
	,set_loader: function(value) {
		if(this.loader != null) {
			this.loader.image = null;
			this.loader.loaded.removeAll();
		}
		if(value != null) {
			value.loaded.add($bind(this,this.loadComplete)).forType(mloader.LoaderEventType.Complete);
			value.loaded.add($bind(this,this.loadFail)).forType(mloader.LoaderEventType.Fail(null));
		}
		return this.loader = value;
	}
	,loaderQueue: null
	,image: null
	,change: function(flag) {
		mui.display.Rectangle.prototype.change.call(this,flag);
		if(flag.width || flag.height) {
			if(this.imageWidth > 0 && this.imageHeight > 0) this.updateScale();
		}
		if(flag.url) this.load(this.url);
	}
	,updateScale: function() {
		var sw = this.get_width() / this.imageWidth;
		var sh = this.get_height() / this.imageHeight;
		var s;
		var _g = this.scaleMode;
		switch(_g[1]) {
		case 1:
			if(sw < sh) s = sw; else s = sh;
			break;
		case 0:
			if(sw > sh) s = sw; else s = sh;
			break;
		case 2:
			if(sw < sh) s = sw; else s = sh;
			break;
		case 3:
			s = 1;
			break;
		}
		this.image.width = s * this.imageWidth | 0;
		this.image.height = s * this.imageHeight | 0;
		this.image.style.left = Std["int"]((this.get_width() - this.image.width) * 0.5) + "px";
		this.image.style.top = Std["int"]((this.get_height() - this.image.height) * 0.5) + "px";
	}
	,load: function(url) {
		this.image.removeAttribute("width");
		this.image.removeAttribute("height");
		this.loader.image = this.image;
		this.set_visible(false);
		this.imageWidth = 0;
		this.imageHeight = 0;
		this.loader.set_url(url);
		if(this.loaderQueue == null) {
			if(url != null && url != "") this.loader.load();
		} else {
			this.loaderQueue.remove(this.loader);
			if(url != null && url != "") this.loaderQueue.add(this.loader);
		}
	}
	,loadComplete: function(e) {
		this.imageWidth = this.changeValue("imageWidth",this.image.width);
		this.imageHeight = this.changeValue("imageHeight",this.image.height);
		if(this.autoSize) {
			this.set_width(this.imageWidth);
			this.set_height(this.imageHeight);
		}
		this.updateScale();
		this.set_visible(true);
		this.loaded.dispatch();
	}
	,loadFail: function(e) {
		this.failed.dispatch();
	}
	,set_url: function(v) {
		return this.url = this.changeValue("url",v);
	}
	,set_autoSize: function(v) {
		return this.autoSize = this.changeValue("autoSize",v);
	}
	,set_scaleMode: function(v) {
		return this.scaleMode = this.changeValue("scaleMode",v);
	}
	,__class__: mui.display.Image
	,__properties__: $extend(mui.display.Rectangle.prototype.__properties__,{set_loader:"set_loader",set_scaleMode:"set_scaleMode",set_autoSize:"set_autoSize",set_url:"set_url"})
});
mui.display.ImageAsset = function() {
	this.parts = [];
};
$hxClasses["mui.display.ImageAsset"] = mui.display.ImageAsset;
mui.display.ImageAsset.__name__ = ["mui","display","ImageAsset"];
mui.display.ImageAsset.prototype = {
	uri: null
	,width: null
	,height: null
	,parts: null
	,getPart: function(id) {
		var _g = 0;
		var _g1 = this.parts;
		while(_g < _g1.length) {
			var part = _g1[_g];
			++_g;
			if(part.id == id) return part;
		}
		return null;
	}
	,__class__: mui.display.ImageAsset
};
mui.display.ImageAssetPart = function() {
	this.x = null;
	this.y = this.width = this.height = 0;
	this.frames = 1;
};
$hxClasses["mui.display.ImageAssetPart"] = mui.display.ImageAssetPart;
mui.display.ImageAssetPart.__name__ = ["mui","display","ImageAssetPart"];
mui.display.ImageAssetPart.prototype = {
	asset: null
	,id: null
	,frames: null
	,x: null
	,y: null
	,width: null
	,height: null
	,configure: function(asset) {
		if(!(asset.parts != null)) throw "Assertion failed: " + "argument `asset` does not have any parts";
		var i = Lambda.indexOf(asset.parts,this);
		if(!(i > -1)) throw "Assertion failed: " + "`this` is not part of argument `asset`";
		var numParts = asset.parts.length;
		this.asset = asset;
		if(this.width == 0) this.width = asset.width / numParts | 0;
		if(this.frames > 1) this.width = this.width / this.frames | 0;
		if(this.height == 0) this.height = asset.height;
		if(this.x == null && numParts > 0) this.x = i * this.width;
	}
	,__class__: mui.display.ImageAssetPart
};
mui.display.Text = function() {
	mui.display.Rectangle.call(this);
	this.invalidateProperty("value");
	this.invalidateProperty("autoSize");
	this.invalidateProperty("selectable");
	this.invalidateProperty("font");
	this.invalidateProperty("size");
	this.invalidateProperty("color");
	this.invalidateProperty("multiline");
	this.invalidateProperty("wrap");
	this.set_value("");
	this.set_font("SourceSansPro");
	this.set_size(24);
	this.set_color(0);
	this.set_selectable(false);
	this.set_bold(false);
	this.set_italic(false);
	this.set_html(false);
	this.set_leading(0);
	this.set_wrap(false);
	this.set_autoSize(true);
	this.set_multiline(false);
	this.set_letterSpacing(0);
	this.set_align("left");
	this.set_transform(mui.display.TextTransform.None);
};
$hxClasses["mui.display.Text"] = mui.display.Text;
mui.display.Text.__name__ = ["mui","display","Text"];
mui.display.Text.__super__ = mui.display.Rectangle;
mui.display.Text.prototype = $extend(mui.display.Rectangle.prototype,{
	sizeDirty: null
	,value: null
	,set_value: function(value) {
		if(value == null) value = "";
		this.sizeDirty = true;
		return this.value = this.changeValue("value",value);
	}
	,align: null
	,set_align: function(value) {
		this.sizeDirty = true;
		return this.align = this.changeValue("align",value);
	}
	,transform: null
	,set_transform: function(value) {
		this.sizeDirty = true;
		return this.transform = this.changeValue("transform",value);
	}
	,font: null
	,set_font: function(value) {
		this.sizeDirty = true;
		return this.font = this.changeValue("font",value);
	}
	,autoSize: null
	,set_autoSize: function(value) {
		this.sizeDirty = true;
		return this.autoSize = this.changeValue("autoSize",value);
	}
	,multiline: null
	,set_multiline: function(value) {
		this.sizeDirty = true;
		return this.multiline = this.changeValue("multiline",value);
	}
	,wrap: null
	,set_wrap: function(value) {
		this.sizeDirty = true;
		return this.wrap = this.changeValue("wrap",value);
	}
	,size: null
	,set_size: function(value) {
		this.sizeDirty = true;
		return this.size = this.changeValue("size",value);
	}
	,color: null
	,set_color: function(value) {
		this.sizeDirty = true;
		return this.color = this.changeValue("color",value);
	}
	,html: null
	,set_html: function(value) {
		this.sizeDirty = true;
		return this.html = this.changeValue("html",value);
	}
	,leading: null
	,set_leading: function(value) {
		this.sizeDirty = true;
		return this.leading = this.changeValue("leading",value);
	}
	,letterSpacing: null
	,set_letterSpacing: function(value) {
		this.sizeDirty = true;
		return this.letterSpacing = this.changeValue("letterSpacing",value);
	}
	,italic: null
	,set_italic: function(value) {
		this.sizeDirty = true;
		return this.italic = this.changeValue("italic",value);
	}
	,bold: null
	,set_bold: function(value) {
		this.sizeDirty = true;
		return this.bold = this.changeValue("bold",value);
	}
	,selectable: null
	,set_selectable: function(value) {
		return this.selectable = this.changeValue("selectable",value);
	}
	,get_width: function() {
		if(this.sizeDirty) this.validate();
		return mui.display.Rectangle.prototype.get_width.call(this);
	}
	,get_height: function() {
		if(this.sizeDirty) this.validate();
		return mui.display.Rectangle.prototype.get_height.call(this);
	}
	,truncate: function(content,maxLines,ellipsis) {
		if(ellipsis == null) ellipsis = "…";
		if(maxLines == null) maxLines = 1;
		if(maxLines == 1) {
			if(this.element.className.indexOf(" truncate") == -1) this.element.className += " truncate";
			this.set_autoSize(false);
			this.set_wrap(false);
			this.set_multiline(false);
			this.set_value(content);
			return;
		}
		this.set_autoSize(true);
		this.set_multiline(true);
		this.set_wrap(true);
		this.set_value("0");
		var lineHeight = this.get_height();
		var maxHeight = lineHeight * maxLines;
		this.set_value(content);
		if(this.get_height() <= maxHeight) return;
		var overflow = false;
		var min = 0;
		var max = content.length - 1;
		while(min <= max || overflow) {
			var mid = min + max >>> 1;
			this.set_value(HxOverrides.substr(content,0,mid) + ellipsis);
			overflow = this.get_height() > maxHeight;
			if(overflow) max = mid - 1; else min = mid + 1;
		}
	}
	,_new: function() {
		mui.display.Rectangle.prototype._new.call(this);
		this.element.className += " view-text";
		this.element.style.fontFamily = this.font;
	}
	,change: function(flag) {
		mui.display.Rectangle.prototype.change.call(this,flag);
		if(flag.value) {
			if(this.html) this.element.innerHTML = this.value; else this.element.innerHTML = mui.display.Text.NEWLINES.replace(Std.string(this.value),"<br/>");
			this.sizeDirty = this.autoSize || !this.multiline;
		}
		if(flag.wrap) {
			if(this.wrap) this.element.style.whiteSpace = "normal"; else this.element.style.whiteSpace = null;
			if(this.wrap) this.element.style.wordWrap = "break-word"; else this.element.style.wordWrap = null;
		}
		if(flag.selectable) if(this.selectable) this.element.style[JS.prefix == ""?"userSelect":JS.prefix + "userSelect".charAt(0).toUpperCase() + HxOverrides.substr("userSelect",1,null)] = "text"; else this.element.style[JS.prefix == ""?"userSelect":JS.prefix + "userSelect".charAt(0).toUpperCase() + HxOverrides.substr("userSelect",1,null)] = null;
		if(flag.leading || flag.font || flag.size || flag.color || flag.bold || flag.italic || flag.letterSpacing || flag.align || flag.transform) {
			if(flag.leading || flag.size) {
				if(this.leading == 0) this.element.style.lineHeight = null; else this.element.style.lineHeight = this.leading + this.size + "px";
			}
			if(flag.font) this.element.style.fontFamily = this.font;
			if(flag.size) this.element.style.fontSize = this.size + "px";
			if(flag.bold) if(this.bold) this.element.style.fontWeight = "bold"; else this.element.style.fontWeight = "normal";
			if(flag.italic) if(this.italic) this.element.style.fontStyle = "italic"; else this.element.style.fontStyle = "normal";
			if(flag.letterSpacing) this.element.style.letterSpacing = this.letterSpacing + "px";
			if(flag.align) this.element.style.textAlign = this.align;
			if(flag.color) this.element.style.color = mui.display.Color.toRGBAStyle(this.color,1);
			if(flag.transform) if(this.transform == mui.display.TextTransform.None) this.element.style.textTransform = null; else this.element.style.textTransform = Std.string(this.transform).toLowerCase();
		}
		if(flag.width || flag.height || flag.autoSize || flag.multiline || flag.wrap) {
			if(this.autoSize && !(this.multiline && this.wrap)) this.element.style.width = null; else this.element.style.width = this.get_width() + "px";
			if(this.autoSize || !this.multiline) this.element.style.height = null; else this.element.style.height = this.get_height() + "px";
			this.sizeDirty = true;
		}
		if(this.sizeDirty) this.validateSize();
	}
	,addChildAt: function(child,index) {
		throw "You can not add children to text fields.";
	}
	,validateSize: function() {
		this.sizeDirty = false;
		if(!(this.autoSize && !this.wrap) && !(this.autoSize || !this.multiline)) return;
		var parentNode = null;
		var nextSibling = null;
		var offDOM = this.element.clientWidth == 0 && this.element.innerHTML != "";
		if(offDOM) {
			parentNode = this.element.parentNode;
			nextSibling = this.element.nextSibling;
			window.document.body.appendChild(this.element);
		}
		if(this.autoSize && !this.wrap) this.set_width(this.element.clientWidth);
		if(this.autoSize || !this.multiline) this.set_height(this.element.clientHeight);
		if(offDOM) {
			if(parentNode != null) parentNode.insertBefore(this.element,nextSibling); else window.document.body.removeChild(this.element);
		}
	}
	,__class__: mui.display.Text
	,__properties__: $extend(mui.display.Rectangle.prototype.__properties__,{set_selectable:"set_selectable",set_bold:"set_bold",set_italic:"set_italic",set_letterSpacing:"set_letterSpacing",set_leading:"set_leading",set_html:"set_html",set_color:"set_color",set_size:"set_size",set_wrap:"set_wrap",set_multiline:"set_multiline",set_autoSize:"set_autoSize",set_font:"set_font",set_transform:"set_transform",set_align:"set_align",set_value:"set_value"})
});
mui.display.InputText = function() {
	mui.display.Text.call(this);
	this.set_focused(false);
	this.set_placeholder(null);
	this.set_secureInput(false);
	this.set_maxLength(0);
	this.set_selectable(true);
	this.set_autoSize(false);
	this.set_width(200);
	this.element.addEventListener("focus",$bind(this,this.focusInHandler));
	this.element.addEventListener("blur",$bind(this,this.focusOutHandler));
	this.element.addEventListener("input",$bind(this,this.inputChanged));
	null;
};
$hxClasses["mui.display.InputText"] = mui.display.InputText;
mui.display.InputText.__name__ = ["mui","display","InputText"];
mui.display.InputText.__super__ = mui.display.Text;
mui.display.InputText.prototype = $extend(mui.display.Text.prototype,{
	focused: null
	,placeholder: null
	,secureInput: null
	,maxLength: null
	,focus: function() {
		this.element.focus();
	}
	,focusInHandler: function(e) {
		this.set_focused(true);
	}
	,focusOutHandler: function(e) {
		this.set_focused(false);
	}
	,inputChanged: function(e) {
		this.set_value(this.element.value);
	}
	,createDisplay: function() {
		var display = window.document.createElement("input");
		display.type = "text";
		return display;
	}
	,change: function(flag) {
		if(flag.enabled) this.element.disabled = !this.enabled;
		if(flag.value && this.element.value != this.value) this.element.value = this.value;
		if(flag.secureInput) if(this.secureInput) this.element.type = "password"; else this.element.type = "text";
		if(flag.focused && !this.focused) this.element.blur();
		if(flag.maxLength) if(this.maxLength > 0) this.element.maxLength = this.maxLength; else this.element.maxLength = null;
		mui.display.Text.prototype.change.call(this,flag);
	}
	,destroy: function() {
		this.element.removeEventListener("focus",$bind(this,this.focusInHandler));
		this.element.removeEventListener("blur",$bind(this,this.focusOutHandler));
		this.element.removeEventListener("input",$bind(this,this.inputChanged));
		mui.display.Text.prototype.destroy.call(this);
	}
	,set_focused: function(v) {
		return this.focused = this.changeValue("focused",v);
	}
	,set_placeholder: function(v) {
		return this.placeholder = this.changeValue("placeholder",v);
	}
	,set_secureInput: function(v) {
		return this.secureInput = this.changeValue("secureInput",v);
	}
	,set_maxLength: function(v) {
		return this.maxLength = this.changeValue("maxLength",v);
	}
	,__class__: mui.display.InputText
	,__properties__: $extend(mui.display.Text.prototype.__properties__,{set_maxLength:"set_maxLength",set_secureInput:"set_secureInput",set_placeholder:"set_placeholder",set_focused:"set_focused"})
});
mui.display.TextTransform = { __ename__ : ["mui","display","TextTransform"], __constructs__ : ["None","Uppercase","Lowercase","Capitalize"] };
mui.display.TextTransform.None = ["None",0];
mui.display.TextTransform.None.toString = $estr;
mui.display.TextTransform.None.__enum__ = mui.display.TextTransform;
mui.display.TextTransform.Uppercase = ["Uppercase",1];
mui.display.TextTransform.Uppercase.toString = $estr;
mui.display.TextTransform.Uppercase.__enum__ = mui.display.TextTransform;
mui.display.TextTransform.Lowercase = ["Lowercase",2];
mui.display.TextTransform.Lowercase.toString = $estr;
mui.display.TextTransform.Lowercase.__enum__ = mui.display.TextTransform;
mui.display.TextTransform.Capitalize = ["Capitalize",3];
mui.display.TextTransform.Capitalize.toString = $estr;
mui.display.TextTransform.Capitalize.__enum__ = mui.display.TextTransform;
mui.display.VirtualDisplay = function() {
	mui.display.Display.call(this);
	this.visibleChildren = new haxe.ds.IntMap();
	null;
};
$hxClasses["mui.display.VirtualDisplay"] = mui.display.VirtualDisplay;
mui.display.VirtualDisplay.__name__ = ["mui","display","VirtualDisplay"];
mui.display.VirtualDisplay.__super__ = mui.display.Display;
mui.display.VirtualDisplay.prototype = $extend(mui.display.Display.prototype,{
	requestChild: null
	,releaseChild: null
	,visibleChildren: null
	,addChildAt: function(child,index) {
	}
	,removeChild: function(child) {
	}
	,removeChildAt: function(index) {
	}
	,populate: function(numChildren) {
		this.numChildren = numChildren;
		this.invalidateProperty("children");
	}
	,removeChildren: function() {
		var $it0 = this.visibleChildren.keys();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			this.releaseChildAt(i);
		}
		this.populate(0);
		this.visibleChildren = new haxe.ds.IntMap();
	}
	,getChildIndex: function(child) {
		return child.index;
	}
	,getChildAt: function(index) {
		if(index < 0 || index > this.numChildren - 1) return mui.display.Display.prototype.getChildAt.call(this,index);
		if(this.visibleChildren.exists(index)) return this.visibleChildren.get(index);
		var child = this.requestChild(index);
		this.visibleChildren.set(index,child);
		this.addVirtualChildAt(child,index);
		return child;
	}
	,releaseChildAt: function(index) {
		if(!this.visibleChildren.exists(index)) return false;
		var child = this.visibleChildren.get(index);
		if(!this.releaseChild(child)) return false;
		this.visibleChildren.remove(index);
		this.removeVirtualChildAt(child,index);
		return true;
	}
	,addVirtualChildAt: function(child,index) {
		this.scrollElement.appendChild(child.element);
		this.changed.add($bind(child,child.parentChange));
		child.parent = child.changeValue("parent",this);
		child.index = child.changeValue("index",index);
	}
	,removeVirtualChildAt: function(child,index) {
		this.scrollElement.removeChild(child.element);
		this.changed.remove($bind(child,child.parentChange));
		child.parent = child.changeValue("parent",null);
		child.index = child.changeValue("index",-1);
	}
	,getDisplayUnder: function(x,y) {
		if(x < 0 || x > this.get_width()) return null;
		if(y < 0 || y > this.get_height()) return null;
		if(!this.visible || !this.enabled) return null;
		if(this.numChildren == 0) return this;
		var localX = x + this.get_scrollX();
		var localY = y + this.get_scrollY();
		var $it0 = this.visibleChildren.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			var display = this.visibleChildren.get(key);
			var descendant = display.getDisplayUnder(localX - display.x,localY - display.y);
			if(descendant != null) return descendant;
		}
		return this;
	}
	,iterator: function() {
		return this.visibleChildren.iterator();
	}
	,__class__: mui.display.VirtualDisplay
});
mui.event = {};
mui.event.Focus = function() { };
$hxClasses["mui.event.Focus"] = mui.event.Focus;
mui.event.Focus.__name__ = ["mui","event","Focus"];
mui.event.Focus.__properties__ = {set_current:"set_current"}
mui.event.Focus.set_current = function(value) {
	if(value == mui.event.Focus.current) return mui.event.Focus.current;
	if(mui.event.Focus.current != null) mui.event.Focus.current.focusOut(null);
	mui.event.Focus.current = value;
	if(mui.event.Focus.current != null) mui.event.Focus.current.focusIn(null);
	mui.event.Focus.changed.dispatch(mui.event.Focus.current);
	return value;
};
mui.event.Input = function() {
	this.bubbles = true;
	this.captured = new msignal.Signal1(mui.event.Input);
	this.updated = new msignal.Signal1(mui.event.Input);
	this.completed = new msignal.Signal1(mui.event.Input);
	this.isCaptured = false;
};
$hxClasses["mui.event.Input"] = mui.event.Input;
mui.event.Input.__name__ = ["mui","event","Input"];
mui.event.Input.setMode = function(value) {
	if(value == mui.event.Input.mode) return;
	mui.event.Input.mode = value;
	mui.event.Input.modeChanged.dispatch();
};
mui.event.Input.prototype = {
	captured: null
	,updated: null
	,completed: null
	,target: null
	,bubbles: null
	,isCaptured: null
	,capture: function() {
		if(this.isCaptured) return;
		this.isCaptured = true;
		this.captured.dispatch(this);
	}
	,update: function() {
		this.updated.dispatch(this);
	}
	,complete: function() {
		this.completed.dispatch(this);
		this.captured.removeAll();
		this.updated.removeAll();
		this.completed.removeAll();
	}
	,__class__: mui.event.Input
};
mui.event.InputMode = { __ename__ : ["mui","event","InputMode"], __constructs__ : ["TOUCH","KEY"] };
mui.event.InputMode.TOUCH = ["TOUCH",0];
mui.event.InputMode.TOUCH.toString = $estr;
mui.event.InputMode.TOUCH.__enum__ = mui.event.InputMode;
mui.event.InputMode.KEY = ["KEY",1];
mui.event.InputMode.KEY.toString = $estr;
mui.event.InputMode.KEY.__enum__ = mui.event.InputMode;
mui.event.KeyAction = { __ename__ : ["mui","event","KeyAction"], __constructs__ : ["UNKNOWN","LEFT","RIGHT","UP","DOWN","NEXT","PREVIOUS","OK","HOME","BACK","DEBUG","INFORMATION","EXIT","FAST_FORWARD","FAST_BACKWARD","SKIP_FORWARD","SKIP_BACKWARD","PLAY_PAUSE","PLAY","PAUSE","STOP","RECORD","SPACE","RED","GREEN","YELLOW","BLUE","CHANNEL_UP","CHANNEL_DOWN","VOLUME_UP","VOLUME_DOWN","VOLUME_MUTE","NUMBER"] };
mui.event.KeyAction.UNKNOWN = ["UNKNOWN",0];
mui.event.KeyAction.UNKNOWN.toString = $estr;
mui.event.KeyAction.UNKNOWN.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.LEFT = ["LEFT",1];
mui.event.KeyAction.LEFT.toString = $estr;
mui.event.KeyAction.LEFT.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.RIGHT = ["RIGHT",2];
mui.event.KeyAction.RIGHT.toString = $estr;
mui.event.KeyAction.RIGHT.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.UP = ["UP",3];
mui.event.KeyAction.UP.toString = $estr;
mui.event.KeyAction.UP.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.DOWN = ["DOWN",4];
mui.event.KeyAction.DOWN.toString = $estr;
mui.event.KeyAction.DOWN.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.NEXT = ["NEXT",5];
mui.event.KeyAction.NEXT.toString = $estr;
mui.event.KeyAction.NEXT.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.PREVIOUS = ["PREVIOUS",6];
mui.event.KeyAction.PREVIOUS.toString = $estr;
mui.event.KeyAction.PREVIOUS.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.OK = ["OK",7];
mui.event.KeyAction.OK.toString = $estr;
mui.event.KeyAction.OK.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.HOME = ["HOME",8];
mui.event.KeyAction.HOME.toString = $estr;
mui.event.KeyAction.HOME.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.BACK = ["BACK",9];
mui.event.KeyAction.BACK.toString = $estr;
mui.event.KeyAction.BACK.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.DEBUG = ["DEBUG",10];
mui.event.KeyAction.DEBUG.toString = $estr;
mui.event.KeyAction.DEBUG.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.INFORMATION = ["INFORMATION",11];
mui.event.KeyAction.INFORMATION.toString = $estr;
mui.event.KeyAction.INFORMATION.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.EXIT = ["EXIT",12];
mui.event.KeyAction.EXIT.toString = $estr;
mui.event.KeyAction.EXIT.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.FAST_FORWARD = ["FAST_FORWARD",13];
mui.event.KeyAction.FAST_FORWARD.toString = $estr;
mui.event.KeyAction.FAST_FORWARD.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.FAST_BACKWARD = ["FAST_BACKWARD",14];
mui.event.KeyAction.FAST_BACKWARD.toString = $estr;
mui.event.KeyAction.FAST_BACKWARD.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.SKIP_FORWARD = ["SKIP_FORWARD",15];
mui.event.KeyAction.SKIP_FORWARD.toString = $estr;
mui.event.KeyAction.SKIP_FORWARD.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.SKIP_BACKWARD = ["SKIP_BACKWARD",16];
mui.event.KeyAction.SKIP_BACKWARD.toString = $estr;
mui.event.KeyAction.SKIP_BACKWARD.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.PLAY_PAUSE = ["PLAY_PAUSE",17];
mui.event.KeyAction.PLAY_PAUSE.toString = $estr;
mui.event.KeyAction.PLAY_PAUSE.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.PLAY = ["PLAY",18];
mui.event.KeyAction.PLAY.toString = $estr;
mui.event.KeyAction.PLAY.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.PAUSE = ["PAUSE",19];
mui.event.KeyAction.PAUSE.toString = $estr;
mui.event.KeyAction.PAUSE.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.STOP = ["STOP",20];
mui.event.KeyAction.STOP.toString = $estr;
mui.event.KeyAction.STOP.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.RECORD = ["RECORD",21];
mui.event.KeyAction.RECORD.toString = $estr;
mui.event.KeyAction.RECORD.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.SPACE = ["SPACE",22];
mui.event.KeyAction.SPACE.toString = $estr;
mui.event.KeyAction.SPACE.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.RED = ["RED",23];
mui.event.KeyAction.RED.toString = $estr;
mui.event.KeyAction.RED.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.GREEN = ["GREEN",24];
mui.event.KeyAction.GREEN.toString = $estr;
mui.event.KeyAction.GREEN.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.YELLOW = ["YELLOW",25];
mui.event.KeyAction.YELLOW.toString = $estr;
mui.event.KeyAction.YELLOW.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.BLUE = ["BLUE",26];
mui.event.KeyAction.BLUE.toString = $estr;
mui.event.KeyAction.BLUE.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.CHANNEL_UP = ["CHANNEL_UP",27];
mui.event.KeyAction.CHANNEL_UP.toString = $estr;
mui.event.KeyAction.CHANNEL_UP.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.CHANNEL_DOWN = ["CHANNEL_DOWN",28];
mui.event.KeyAction.CHANNEL_DOWN.toString = $estr;
mui.event.KeyAction.CHANNEL_DOWN.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.VOLUME_UP = ["VOLUME_UP",29];
mui.event.KeyAction.VOLUME_UP.toString = $estr;
mui.event.KeyAction.VOLUME_UP.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.VOLUME_DOWN = ["VOLUME_DOWN",30];
mui.event.KeyAction.VOLUME_DOWN.toString = $estr;
mui.event.KeyAction.VOLUME_DOWN.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.VOLUME_MUTE = ["VOLUME_MUTE",31];
mui.event.KeyAction.VOLUME_MUTE.toString = $estr;
mui.event.KeyAction.VOLUME_MUTE.__enum__ = mui.event.KeyAction;
mui.event.KeyAction.NUMBER = function(n) { var $x = ["NUMBER",32,n]; $x.__enum__ = mui.event.KeyAction; $x.toString = $estr; return $x; };
mui.event.KeyManager = function() {
	this.held = false;
	this.pressedKeys = new haxe.ds.IntMap();
	this.holdDelay = 600;
	this.holdInterval = 200;
	this.pressed = new msignal.Signal1(mui.event.Key);
	this.released = new msignal.Signal1(mui.event.Key);
};
$hxClasses["mui.event.KeyManager"] = mui.event.KeyManager;
mui.event.KeyManager.__name__ = ["mui","event","KeyManager"];
mui.event.KeyManager.prototype = {
	held: null
	,map: null
	,holdDelay: null
	,holdInterval: null
	,pressed: null
	,released: null
	,pressedKeys: null
	,timer: null
	,currentKey: null
	,pressCount: null
	,lastPressEventTime: null
	,isDown: function(keyCode) {
		return this.pressedKeys.exists(keyCode);
	}
	,press: function(key) {
		mui.event.KeyManager.realPressCount++;
		this.lastPressEventTime = haxe.Timer.stamp();
		if(this.currentKey != null) {
			if(key.code != this.currentKey.code) this.release(this.currentKey);
		}
		if(this.currentKey != null) return;
		this.held = false;
		this.currentKey = key;
		this.pressedKeys.set(key.code,true);
		this.pressCount = 0;
		this.dispatchPress(key);
		mui.event.KeyManager.previousPressCount = mui.event.KeyManager.realPressCount;
		mui.core.Node.validator.validate();
	}
	,dispatchPress: function(key) {
		if(mui.event.Input.mode != mui.event.InputMode.KEY) {
			var inputModeKnown = mui.event.Input.mode != null;
			mui.event.Input.setMode(mui.event.InputMode.KEY);
			if(inputModeKnown) {
				var _g = key.get_action();
				switch(_g[1]) {
				case 7:case 3:case 4:case 1:case 2:
					return;
				default:
				}
			}
		}
		this.pressCount += 1;
		this.held = this.pressCount > 1;
		key.pressCount = this.pressCount;
		key.isCaptured = false;
		mui.event.Input.setMode(mui.event.InputMode.KEY);
		this.pressed.dispatch(key);
		if(mui.event.Focus.current != null) mui.event.Focus.current.keyPress(key);
		this.resetTimer();
		if(mui.event.KeyManager.realPressCount > mui.event.KeyManager.previousPressCount) {
			var delay;
			if(this.pressCount == 1) delay = this.holdDelay; else delay = this.holdInterval;
			this.timer = haxe.Timer.delay((function(f,a1) {
				return function() {
					return f(a1);
				};
			})($bind(this,this.dispatchPress),key),delay);
		}
	}
	,release: function(key) {
		if(this.currentKey != null && key.code == this.currentKey.code) {
			this.dispatchRelease(key);
			mui.core.Node.validator.validate();
		}
	}
	,dispatchRelease: function(key) {
		this.held = false;
		this.currentKey = null;
		this.pressedKeys.remove(key.code);
		this.pressCount = 0;
		this.released.dispatch(key);
		if(mui.event.Focus.current != null) mui.event.Focus.current.keyRelease(key);
		this.resetTimer();
	}
	,set_map: function(value) {
		if(!(value != null)) throw "Assertion failed: " + "argument `value` cannot be `null`";
		this.map = value;
		return this.map;
	}
	,resetTimer: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
	}
	,__class__: mui.event.KeyManager
	,__properties__: {set_map:"set_map"}
};
mui.event.Key = function(keyCode,keyAction) {
	mui.event.Input.call(this);
	this.code = keyCode;
	this.keyAction = keyAction;
	this.pressCount = 0;
};
$hxClasses["mui.event.Key"] = mui.event.Key;
mui.event.Key.__name__ = ["mui","event","Key"];
mui.event.Key.__properties__ = {get_released:"get_released",get_pressed:"get_pressed",get_map:"get_map",get_held:"get_held"}
mui.event.Key.get_held = function() {
	return mui.event.Key.manager.held;
};
mui.event.Key.get_map = function() {
	return mui.event.Key.manager.map;
};
mui.event.Key.get_pressed = function() {
	return mui.event.Key.manager.pressed;
};
mui.event.Key.get_released = function() {
	return mui.event.Key.manager.released;
};
mui.event.Key.isDown = function(keyCode) {
	return mui.event.Key.manager.isDown(keyCode);
};
mui.event.Key.press = function(key) {
	mui.event.Key.manager.press(key);
};
mui.event.Key.release = function(key) {
	mui.event.Key.manager.release(key);
};
mui.event.Key.__super__ = mui.event.Input;
mui.event.Key.prototype = $extend(mui.event.Input.prototype,{
	code: null
	,action: null
	,pressCount: null
	,keyAction: null
	,get_action: function() {
		if(this.keyAction != null) return this.keyAction;
		return mui.event.Key.manager.map.get(this.code);
	}
	,toString: function() {
		return "Key[" + this.code + ", " + Std.string(this.get_action()) + "]x" + this.pressCount;
	}
	,__class__: mui.event.Key
	,__properties__: {get_action:"get_action"}
});
mui.event.KeyMapBase = function() {
	this.map = new haxe.ds.IntMap();
};
$hxClasses["mui.event.KeyMapBase"] = mui.event.KeyMapBase;
mui.event.KeyMapBase.__name__ = ["mui","event","KeyMapBase"];
mui.event.KeyMapBase.prototype = {
	map: null
	,clear: function() {
		this.map = new haxe.ds.IntMap();
	}
	,set: function(keyCode,action) {
		this.map.set(keyCode,action);
	}
	,get: function(keyCode) {
		if(this.map.exists(keyCode)) return this.map.get(keyCode);
		return mui.event.KeyAction.UNKNOWN;
	}
	,remove: function(keyCode) {
		this.map.remove(keyCode);
	}
	,__class__: mui.event.KeyMapBase
};
mui.event.KeyMap = function() {
	mui.event.KeyMapBase.call(this);
	this.set(37,mui.event.KeyAction.LEFT);
	this.set(39,mui.event.KeyAction.RIGHT);
	this.set(38,mui.event.KeyAction.UP);
	this.set(40,mui.event.KeyAction.DOWN);
	this.set(13,mui.event.KeyAction.OK);
	this.set(8,mui.event.KeyAction.BACK);
	this.set(32,mui.event.KeyAction.SPACE);
	this.set(190,mui.event.KeyAction.DEBUG);
	this.set(82,mui.event.KeyAction.RED);
	this.set(71,mui.event.KeyAction.GREEN);
	this.set(89,mui.event.KeyAction.YELLOW);
	this.set(66,mui.event.KeyAction.BLUE);
	this.set(48,mui.event.KeyAction.NUMBER(0));
	this.set(49,mui.event.KeyAction.NUMBER(1));
	this.set(50,mui.event.KeyAction.NUMBER(2));
	this.set(51,mui.event.KeyAction.NUMBER(3));
	this.set(52,mui.event.KeyAction.NUMBER(4));
	this.set(53,mui.event.KeyAction.NUMBER(5));
	this.set(54,mui.event.KeyAction.NUMBER(6));
	this.set(55,mui.event.KeyAction.NUMBER(7));
	this.set(56,mui.event.KeyAction.NUMBER(8));
	this.set(57,mui.event.KeyAction.NUMBER(9));
};
$hxClasses["mui.event.KeyMap"] = mui.event.KeyMap;
mui.event.KeyMap.__name__ = ["mui","event","KeyMap"];
mui.event.KeyMap.__super__ = mui.event.KeyMapBase;
mui.event.KeyMap.prototype = $extend(mui.event.KeyMapBase.prototype,{
	__class__: mui.event.KeyMap
});
mui.event.ScreenOrientation = { __ename__ : ["mui","event","ScreenOrientation"], __constructs__ : ["OrientationUnknown","LandscapeLeft","LandscapeRight","Portrait","PortraitUpsideDown"] };
mui.event.ScreenOrientation.OrientationUnknown = ["OrientationUnknown",0];
mui.event.ScreenOrientation.OrientationUnknown.toString = $estr;
mui.event.ScreenOrientation.OrientationUnknown.__enum__ = mui.event.ScreenOrientation;
mui.event.ScreenOrientation.LandscapeLeft = ["LandscapeLeft",1];
mui.event.ScreenOrientation.LandscapeLeft.toString = $estr;
mui.event.ScreenOrientation.LandscapeLeft.__enum__ = mui.event.ScreenOrientation;
mui.event.ScreenOrientation.LandscapeRight = ["LandscapeRight",2];
mui.event.ScreenOrientation.LandscapeRight.toString = $estr;
mui.event.ScreenOrientation.LandscapeRight.__enum__ = mui.event.ScreenOrientation;
mui.event.ScreenOrientation.Portrait = ["Portrait",3];
mui.event.ScreenOrientation.Portrait.toString = $estr;
mui.event.ScreenOrientation.Portrait.__enum__ = mui.event.ScreenOrientation;
mui.event.ScreenOrientation.PortraitUpsideDown = ["PortraitUpsideDown",4];
mui.event.ScreenOrientation.PortraitUpsideDown.toString = $estr;
mui.event.ScreenOrientation.PortraitUpsideDown.__enum__ = mui.event.ScreenOrientation;
mui.event.Screen = function() {
	this.width = 800;
	this.height = 600;
	this.orientation = mui.event.ScreenOrientation.Portrait;
};
$hxClasses["mui.event.Screen"] = mui.event.Screen;
mui.event.Screen.__name__ = ["mui","event","Screen"];
mui.event.Screen.resize = function(width,height) {
	mui.event.Screen.primary.width = width;
	mui.event.Screen.primary.height = height;
	mui.event.Screen.resized.dispatch(mui.event.Screen.primary);
};
mui.event.Screen.reorient = function(orientation) {
	mui.event.Screen.primary.orientation = orientation;
	mui.event.Screen.reoriented.dispatch(mui.event.Screen.primary);
};
mui.event.Screen.isLandscape = function() {
	return mui.event.Screen.primary.orientation == mui.event.ScreenOrientation.LandscapeLeft || mui.event.Screen.primary.orientation == mui.event.ScreenOrientation.LandscapeRight;
};
mui.event.Screen.prototype = {
	width: null
	,height: null
	,orientation: null
	,__class__: mui.event.Screen
};
mui.event.Touch = function(x,y) {
	mui.event.Input.call(this);
	this.startX = this.previousX = this.currentX = x;
	this.startY = this.previousY = this.currentY = y;
};
$hxClasses["mui.event.Touch"] = mui.event.Touch;
mui.event.Touch.__name__ = ["mui","event","Touch"];
mui.event.Touch.start = function(touch) {
	mui.event.Input.setMode(mui.event.InputMode.TOUCH);
	mui.event.Touch.started.dispatch(touch);
	var display = mui.Lib.get_display().getDisplayUnder(touch.currentX,touch.currentY);
	if(display != null) {
		touch.target = display;
		display.touchStart(touch);
	}
	mui.core.Node.validator.validate();
};
mui.event.Touch.__super__ = mui.event.Input;
mui.event.Touch.prototype = $extend(mui.event.Input.prototype,{
	startX: null
	,startY: null
	,currentX: null
	,currentY: null
	,previousX: null
	,previousY: null
	,updatePosition: function(x,y) {
		this.previousX = this.currentX;
		this.previousY = this.currentY;
		this.currentX = x;
		this.currentY = y;
		this.update();
	}
	,complete: function() {
		this.target.touchEnd(this);
		mui.event.Input.prototype.complete.call(this);
		mui.core.Node.validator.validate();
	}
	,changeX: null
	,get_changeX: function() {
		return this.currentX - this.previousX;
	}
	,changeY: null
	,get_changeY: function() {
		return this.currentY - this.previousY;
	}
	,totalChangeX: null
	,get_totalChangeX: function() {
		return this.currentX - this.startX;
	}
	,totalChangeY: null
	,get_totalChangeY: function() {
		return this.currentY - this.startY;
	}
	,__class__: mui.event.Touch
	,__properties__: {get_totalChangeY:"get_totalChangeY",get_totalChangeX:"get_totalChangeX",get_changeY:"get_changeY",get_changeX:"get_changeX"}
});
mui.input = {};
mui.input.DataInput = function(skin) {
	mui.core.DataComponent.call(this,skin);
	this.validators = [];
	this.set_invalid(false);
	this.set_path(null);
	this.hasHadFocus = false;
	this.set_required(false);
	this.requiredMessage = "this field is required";
	this.set_validationLabel(null);
	this.isInRequiredGroup = false;
	null;
};
$hxClasses["mui.input.DataInput"] = mui.input.DataInput;
mui.input.DataInput.__name__ = ["mui","input","DataInput"];
mui.input.DataInput.__super__ = mui.core.DataComponent;
mui.input.DataInput.prototype = $extend(mui.core.DataComponent.prototype,{
	invalid: null
	,required: null
	,path: null
	,validationLabel: null
	,requiredMessage: null
	,isInRequiredGroup: null
	,hasHadFocus: null
	,validators: null
	,addRequiredValidator: function(message) {
		this.set_required(true);
		this.requiredMessage = message;
	}
	,addValidator: function(validator) {
		this.removeValidator(validator);
		this.validators.push(validator);
	}
	,removeValidator: function(validator) {
		HxOverrides.remove(this.validators,validator);
	}
	,validateData: function() {
		var value = this.data;
		if(this.required) {
			if(value == null || !(typeof(value) == "string") && value == false || typeof(value) == "string" && Std.string(value).length == 0) {
				this.set_invalid(true);
				return { isError : true, message : this.requiredMessage};
			}
		}
		var _g = 0;
		var _g1 = this.validators;
		while(_g < _g1.length) {
			var validator = _g1[_g];
			++_g;
			var result = validator.validate(value);
			if(result.isError) {
				this.set_invalid(true);
				return result;
			}
		}
		this.set_invalid(false);
		return { isError : false, message : ""};
	}
	,clearFormData: function() {
		if(!this.focused) this.hasHadFocus = false;
		this.set_invalid(false);
	}
	,getFormData: function() {
		return this.data;
	}
	,setFormData: function(data) {
		this.set_data(data);
	}
	,change: function(flag) {
		mui.core.DataComponent.prototype.change.call(this,flag);
		if(flag.focused) {
			if(this.focused) this.hasHadFocus = true; else if(this.hasHadFocus) this.validateData();
		}
	}
	,set_invalid: function(v) {
		return this.invalid = this.changeValue("invalid",v);
	}
	,set_required: function(v) {
		return this.required = this.changeValue("required",v);
	}
	,set_path: function(v) {
		return this.path = this.changeValue("path",v);
	}
	,set_validationLabel: function(v) {
		return this.validationLabel = this.changeValue("validationLabel",v);
	}
	,__class__: mui.input.DataInput
	,__properties__: $extend(mui.core.DataComponent.prototype.__properties__,{set_validationLabel:"set_validationLabel",set_path:"set_path",set_required:"set_required",set_invalid:"set_invalid"})
});
mui.input.ButtonInput = function(skin) {
	mui.input.DataInput.call(this,skin);
	var _this = window.document;
	this.inputElement = _this.createElement("input");
	this.element.appendChild(this.inputElement);
	this.inputElement.addEventListener("focus",$bind(this,this.focusInHandler));
	this.inputElement.addEventListener("blur",$bind(this,this.focusOutHandler));
	this.set_focused(false);
	this.set_data(false);
	this.invalidateProperty("data");
	this.set_label("");
	this.set_labelPosition(mui.input.FormLabelPosition.Right);
	this.set_groupName(null);
	this.set_groupValue(null);
	new mui.behavior.ButtonBehavior(this);
	null;
};
$hxClasses["mui.input.ButtonInput"] = mui.input.ButtonInput;
mui.input.ButtonInput.__name__ = ["mui","input","ButtonInput"];
mui.input.ButtonInput.__super__ = mui.input.DataInput;
mui.input.ButtonInput.prototype = $extend(mui.input.DataInput.prototype,{
	label: null
	,groupName: null
	,groupValue: null
	,labelPosition: null
	,inputElement: null
	,inputElementFocused: null
	,action: function() {
		this.set_data(!this.data);
	}
	,clearFormData: function() {
		mui.input.DataInput.prototype.clearFormData.call(this);
		if(this.groupName != null) {
			var group = this.getGroup();
			group[0].set_data(true);
		} else this.set_data(false);
	}
	,getGroup: function() {
		if(this.groupName == null) return [this];
		var formContainer = this.container;
		while(!js.Boot.__instanceof(formContainer,mui.input.DataForm)) {
			if(formContainer == null) return [this];
			formContainer = formContainer.container;
		}
		var group = [];
		var form = formContainer;
		var groupName = this.groupName;
		var $it0 = form.inputs();
		while( $it0.hasNext() ) {
			var input = $it0.next();
			if(!js.Boot.__instanceof(input,mui.input.ButtonInput)) continue;
			var button = input;
			if(button.groupName == groupName) group.push(button);
		}
		return group;
	}
	,focus: function() {
		mui.input.DataInput.prototype.focus.call(this);
		if(!this.inputElementFocused) this.inputElement.focus();
	}
	,focusInHandler: function(_) {
		this.set_inputElementFocused(true);
		if(!this.focused) this.focus();
	}
	,focusOutHandler: function(_) {
		this.set_inputElementFocused(false);
	}
	,change: function(flag) {
		mui.input.DataInput.prototype.change.call(this,flag);
		if(flag.enabled) this.inputElement.disabled = !this.enabled;
		if(flag.inputElementFocused && this.enabled && this.inputElementFocused) this.focus();
		if(flag.data) this.inputElement.checked = this.data;
		if(flag.groupValue) this.inputElement.value = this.groupValue;
		if(flag.groupName) this.inputElement.name = this.groupName;
	}
	,destroy: function() {
		this.inputElement.removeEventListener("focus",$bind(this,this.focusInHandler));
		this.inputElement.removeEventListener("blur",$bind(this,this.focusOutHandler));
		mui.input.DataInput.prototype.destroy.call(this);
	}
	,set_label: function(v) {
		return this.label = this.changeValue("label",v);
	}
	,set_groupName: function(v) {
		return this.groupName = this.changeValue("groupName",v);
	}
	,set_groupValue: function(v) {
		return this.groupValue = this.changeValue("groupValue",v);
	}
	,set_labelPosition: function(v) {
		return this.labelPosition = this.changeValue("labelPosition",v);
	}
	,set_inputElementFocused: function(v) {
		return this.inputElementFocused = this.changeValue("inputElementFocused",v);
	}
	,__class__: mui.input.ButtonInput
	,__properties__: $extend(mui.input.DataInput.prototype.__properties__,{set_inputElementFocused:"set_inputElementFocused",set_labelPosition:"set_labelPosition",set_groupValue:"set_groupValue",set_groupName:"set_groupName",set_label:"set_label"})
});
mui.input.ThemeSkin = function(theme) {
	mui.core.Skin.call(this);
	this.theme = theme;
	this.background = new mui.display.Rectangle();
	this.background.set_all(0);
	this.background.set_fill(new mui.display.Color(theme.backgroundColor));
	this.background.set_stroke(new mui.display.Color(theme.borderColor));
	this.background.set_strokeThickness(theme.borderWidth);
	this.background.set_radius(theme.borderRadius);
	null;
};
$hxClasses["mui.input.ThemeSkin"] = mui.input.ThemeSkin;
mui.input.ThemeSkin.__name__ = ["mui","input","ThemeSkin"];
mui.input.ThemeSkin.__super__ = mui.core.Skin;
mui.input.ThemeSkin.prototype = $extend(mui.core.Skin.prototype,{
	required: null
	,theme: null
	,background: null
	,updateState: function(text) {
		var bck = this.background.fill;
		var bdr = this.background.stroke;
		if(this.target.focused) {
			bck.set_value(this.theme.backgroundColorFocused);
			bdr.set_value(this.theme.borderColorFocused);
			if(text != null) text.set_color(this.theme.textColorFocused);
		} else if(!this.target.enabled) {
			bck.set_value(this.theme.backgroundColorDisabled);
			bdr.set_value(this.theme.borderColorDisabled);
			if(text != null) text.set_color(this.theme.textColorDisabled);
		} else if(this.target.invalid) {
			bck.set_value(this.theme.backgroundColorInvalid);
			bdr.set_value(this.theme.borderColorInvalid);
			if(text != null) text.set_color(this.theme.textColorInvalid);
		} else {
			bck.set_value(this.theme.backgroundColor);
			bdr.set_value(this.theme.borderColor);
			if(text != null) text.set_color(this.theme.textColor);
		}
	}
	,update: function(flag) {
		mui.core.Skin.prototype.update.call(this,flag);
		if(flag.required) {
			if(this.target.required && this.required == null && !this.target.isInRequiredGroup && this.theme.showRequiredIcon) {
				this.required = new mui.display.Icon(this.theme.requiredIcon,this.theme.requiredIconTextSize,this.theme.textColorInvalid);
				this.required.set_font(this.theme.textFont);
				this.required.set_x(-20);
				this.required.set_centerY(0.5);
				this.target.addChild(this.required);
			}
			if(!this.target.required && this.required != null) {
				this.target.removeChild(this.required);
				this.required = null;
			}
		}
	}
	,__class__: mui.input.ThemeSkin
});
mui.input.ButtonInputSkin = function(theme) {
	mui.input.ThemeSkin.call(this,theme);
	this.defaultWidth = 80;
	this.defaultHeight = 20;
	this.display = new mui.display.Display();
	this.addChild(this.display);
	this.display.set_width(this.display.set_height(20));
	this.display.addChild(this.background);
	this.checked = new mui.display.Icon();
	this.checked.set_visible(false);
	this.display.addChild(this.checked);
	this.checked.set_font(theme.iconFont);
	this.checked.set_color(theme.textColor);
	this.checked.set_size(12);
	this.checked.set_centerX(this.checked.set_centerY(0.5));
	this.label = new mui.display.Text();
	this.addChild(this.label);
	this.label.set_size(theme.labelSize);
	this.label.set_font(theme.textFont);
	this.label.set_color(theme.labelColor);
	this.label.set_x(30);
	this.label.set_selectable(false);
	this.label.set_centerY(0.5);
	null;
};
$hxClasses["mui.input.ButtonInputSkin"] = mui.input.ButtonInputSkin;
mui.input.ButtonInputSkin.__name__ = ["mui","input","ButtonInputSkin"];
mui.input.ButtonInputSkin.__super__ = mui.input.ThemeSkin;
mui.input.ButtonInputSkin.prototype = $extend(mui.input.ThemeSkin.prototype,{
	display: null
	,checked: null
	,label: null
	,update: function(flag) {
		mui.input.ThemeSkin.prototype.update.call(this,flag);
		if(flag.data) this.checked.set_visible(this.target.data);
		if(flag.label) {
			this.label.set_value(this.target.label);
			this.target.set_width(this.label.x + this.label.get_width() + 10);
		}
		if(flag.labelPosition || flag.label) {
			var _g = this.target.labelPosition;
			switch(_g[1]) {
			case 0:
				this.label.set_x(0);
				this.display.set_x(this.label.get_width() + 10);
				break;
			case 2:
				this.display.set_x(0);
				this.label.set_x(this.display.get_width() + 10);
				break;
			default:
			}
		}
		if(flag.enabled || flag.focused || flag.invalid) this.updateState(null);
	}
	,__class__: mui.input.ButtonInputSkin
});
mui.input.CheckBox = function(skin) {
	mui.input.ButtonInput.call(this,skin);
	this.inputElement.addEventListener("change",$bind(this,this.inputChanged));
	this.inputElement.className = "view-checkbox";
	this.inputElement.type = "checkbox";
	this.set_data(false);
	null;
};
$hxClasses["mui.input.CheckBox"] = mui.input.CheckBox;
mui.input.CheckBox.__name__ = ["mui","input","CheckBox"];
mui.input.CheckBox.__super__ = mui.input.ButtonInput;
mui.input.CheckBox.prototype = $extend(mui.input.ButtonInput.prototype,{
	getFormData: function() {
		if(this.groupName != null) {
			var values = [];
			var _g = 0;
			var _g1 = this.getGroup();
			while(_g < _g1.length) {
				var button = _g1[_g];
				++_g;
				if(button.data == true) values.push(button.groupValue);
			}
			if(values.length > 0) return values.toString(); else return "";
		}
		return mui.input.ButtonInput.prototype.getFormData.call(this);
	}
	,setFormData: function(data) {
		if(this.groupName != null && typeof(data) == "string") {
			var values = data.split(",");
			var value = null;
			var _g = 0;
			var _g1 = this.getGroup();
			while(_g < _g1.length) {
				var groupButton = _g1[_g];
				++_g;
				var _g2 = 0;
				while(_g2 < values.length) {
					var value1 = values[_g2];
					++_g2;
					if(groupButton.groupValue == value1) groupButton.set_data(true);
				}
			}
		} else if(typeof(data) == "string") mui.input.ButtonInput.prototype.setFormData.call(this,false); else mui.input.ButtonInput.prototype.setFormData.call(this,data);
	}
	,inputChanged: function(_) {
		if(this.inputElement.checked != this.data) this.set_data(this.inputElement.checked);
	}
	,destroy: function() {
		this.inputElement.removeEventListener("change",$bind(this,this.inputChanged));
		mui.input.ButtonInput.prototype.destroy.call(this);
	}
	,__class__: mui.input.CheckBox
});
mui.input.CheckBoxSkin = function(theme) {
	mui.input.ButtonInputSkin.call(this,theme);
	this.checked.set_type(theme.checkedIcon);
	null;
};
$hxClasses["mui.input.CheckBoxSkin"] = mui.input.CheckBoxSkin;
mui.input.CheckBoxSkin.__name__ = ["mui","input","CheckBoxSkin"];
mui.input.CheckBoxSkin.__super__ = mui.input.ButtonInputSkin;
mui.input.CheckBoxSkin.prototype = $extend(mui.input.ButtonInputSkin.prototype,{
	__class__: mui.input.CheckBoxSkin
});
mui.input.DataForm = function() {
	mui.core.DataContainer.call(this);
	this.layout.enabled = true;
	this.layout.set_padding(20);
	this.layout.set_paddingLeft(this.layout.set_paddingRight(80));
	this.layout.set_spacing(10);
	this.set_resizeY(true);
	null;
};
$hxClasses["mui.input.DataForm"] = mui.input.DataForm;
mui.input.DataForm.__name__ = ["mui","input","DataForm"];
mui.input.DataForm.__super__ = mui.core.DataContainer;
mui.input.DataForm.prototype = $extend(mui.core.DataContainer.prototype,{
	inputs: function() {
		var _this = this.findInputs(this);
		return HxOverrides.iter(_this);
	}
	,findInputs: function(container) {
		var inputs = [];
		var $it0 = container.components.iterator();
		while( $it0.hasNext() ) {
			var component = $it0.next();
			if(js.Boot.__instanceof(component,mui.input.DataInput)) inputs.push(component); else if(js.Boot.__instanceof(component,mui.core.DataContainer)) {
				var _g = 0;
				var _g1 = this.findInputs(component);
				while(_g < _g1.length) {
					var input = _g1[_g];
					++_g;
					inputs.push(input);
				}
			}
		}
		return inputs;
	}
	,getInputWithPath: function(path) {
		var $it0 = this.inputs();
		while( $it0.hasNext() ) {
			var input = $it0.next();
			if(input.path == path) return input;
		}
		return null;
	}
	,updateData: function(data) {
		this.data = data;
		var $it0 = this.inputs();
		while( $it0.hasNext() ) {
			var input = $it0.next();
			this.updateInputFromData(input);
		}
	}
	,commitData: function() {
		var $it0 = this.inputs();
		while( $it0.hasNext() ) {
			var input = $it0.next();
			this.updateDataFromInput(input);
		}
	}
	,setDataAtPath: function(path,data) {
		var value = this.data;
		var parts = path.split(".");
		var field = parts.pop();
		var _g = 0;
		while(_g < parts.length) {
			var part = parts[_g];
			++_g;
			value = Reflect.getProperty(value,part);
		}
		Reflect.setProperty(value,field,data);
	}
	,getDataAtPath: function(path) {
		var value = this.data;
		var parts = path.split(".");
		var _g = 0;
		while(_g < parts.length) {
			var part = parts[_g];
			++_g;
			value = Reflect.getProperty(value,part);
		}
		return value;
	}
	,updateInputFromData: function(input) {
		if(input.path == null) return;
		input.setFormData(this.getDataAtPath(input.path));
	}
	,updateDataFromInput: function(input) {
		if(input.path == null) return;
		this.setDataAtPath(input.path,input.getFormData());
	}
	,getInputData: function(path) {
		var $it0 = this.inputs();
		while( $it0.hasNext() ) {
			var input = $it0.next();
			if(input.path == path) return input.getFormData();
		}
		return null;
	}
	,validateData: function() {
		var fields = this.inputs();
		var errors = [];
		while( fields.hasNext() ) {
			var input = fields.next();
			var result = input.validateData();
			if(result.isError) errors.push(result);
		}
		if(errors.length == 0) this.commitData();
		return errors;
	}
	,clearData: function() {
		var $it0 = this.inputs();
		while( $it0.hasNext() ) {
			var input = $it0.next();
			input.clearFormData();
		}
	}
	,__class__: mui.input.DataForm
});
mui.input.FormBuilder = function() {
};
$hxClasses["mui.input.FormBuilder"] = mui.input.FormBuilder;
mui.input.FormBuilder.__name__ = ["mui","input","FormBuilder"];
mui.input.FormBuilder.prototype = {
	form: null
	,container: null
	,input: null
	,build: function(form) {
		this.form = form;
		this.container = form;
		return this;
	}
	,group: function(label) {
		this.container = this.form;
		this.input = null;
		var group = this.createGroup();
		group.set_label(label);
		this.container.addComponent(group);
		this.container = group;
		return this;
	}
	,hgroup: function(label) {
		this.group(label);
		this.container.layout.set_vertical(false);
		return this;
	}
	,endGroup: function() {
		this.container = this.form;
		this.input = null;
		return this;
	}
	,add: function(component) {
		this.container.addComponent(component);
		return this;
	}
	,text: function(path,placeholder,maxLength) {
		if(maxLength == null) maxLength = 0;
		var textInput = this.createTextInput();
		textInput.set_path(path);
		textInput.set_placeholder(placeholder);
		textInput.set_maxLength(maxLength);
		this.container.addComponent(textInput);
		this.input = textInput;
		return this;
	}
	,password: function(path,placeholder,maxLength) {
		if(maxLength == null) maxLength = 0;
		var textInput = this.createTextInput();
		textInput.set_path(path);
		textInput.set_placeholder(placeholder);
		textInput.set_secureInput(true);
		textInput.set_maxLength(maxLength);
		this.input = textInput;
		this.container.addComponent(this.input);
		return this;
	}
	,select: function(path,options,placeholder) {
		var select = this.createSelectInput();
		select.set_path(path);
		select.set_options(options);
		if(placeholder != null) select.set_placeholder(placeholder);
		this.input = select;
		this.container.addComponent(this.input);
		return this;
	}
	,radio: function(path,label,value) {
		var button = this.createRadioButton();
		button.set_path(path);
		button.set_label(label);
		button.set_groupName(path);
		button.set_groupValue(value);
		this.input = button;
		this.container.addComponent(this.input);
		return this;
	}
	,checkbox: function(path,label,value) {
		var button = this.createCheckBox();
		button.set_path(path);
		button.set_label(label);
		this.input = button;
		this.container.addComponent(this.input);
		if(value != null) {
			button.set_groupName(path);
			button.set_groupValue(value);
		}
		return this;
	}
	,range: function(path,min,max) {
		var range = this.createRangeInput();
		range.set_path(path);
		range.set_minimum(min);
		range.set_maximum(max);
		this.input = range;
		this.container.addComponent(this.input);
		return this;
	}
	,required: function(error) {
		if(this.input == null) throw "Error: no input";
		this.input.set_required(true);
		if(error != null) this.input.requiredMessage = error;
		return this;
	}
	,requiredGroup: function() {
		if(this.container != null && js.Boot.__instanceof(this.container,mui.input.FormGroup)) {
			var group;
			group = js.Boot.__cast(this.container , mui.input.FormGroup);
			group.set_required(true);
		}
		return this;
	}
	,validate: function(validator) {
		if(this.input == null) throw "Error: no input";
		this.input.addValidator(validator);
		return this;
	}
	,matches: function(path,error) {
		if(this.input == null) throw "Error: no input";
		this.input.addValidator(new mui.validator.MatchValidator(this.form,path,error));
		return this;
	}
	,size: function(width,height) {
		if(height == null) height = 0;
		if(this.input == null) throw "Error: no input";
		this.input.set_width(width);
		if(height > 0) this.input.set_height(height);
		return this;
	}
	,validationLabel: function(label) {
		if(this.input == null) throw "Error: no input";
		this.input.set_validationLabel(label);
		return this;
	}
	,createSelectInput: function() {
		return new mui.input.DataSelectInput();
	}
	,createGroup: function() {
		return new mui.input.FormGroup();
	}
	,createCheckBox: function() {
		return new mui.input.CheckBox();
	}
	,createRadioButton: function() {
		return new mui.input.RadioButton();
	}
	,createTextInput: function() {
		return new mui.input.TextInput();
	}
	,createRangeInput: function() {
		return new mui.input.RangeInput();
	}
	,__class__: mui.input.FormBuilder
};
mui.input.FormGroup = function(skin) {
	this.labelText = new mui.display.Text();
	mui.core.DataContainer.call(this,skin);
	this.set_required(false);
	this.set_label(null);
	this.set_labelPosition(mui.input.FormLabelPosition.Top);
	this.layout.enabled = true;
	this.layout.set_spacingX(10);
	this.layout.set_spacingY(14);
	this.set_resizeX(true);
	this.set_resizeY(true);
	this.addChild(this.labelText);
	null;
};
$hxClasses["mui.input.FormGroup"] = mui.input.FormGroup;
mui.input.FormGroup.__name__ = ["mui","input","FormGroup"];
mui.input.FormGroup.__super__ = mui.core.DataContainer;
mui.input.FormGroup.prototype = $extend(mui.core.DataContainer.prototype,{
	label: null
	,labelPosition: null
	,required: null
	,labelText: null
	,change: function(flag) {
		mui.core.DataContainer.prototype.change.call(this,flag);
		if(flag.label || flag.labelPosition) {
			this.labelText.set_value(this.label);
			if(this.label == null || this.label == "") this.layout.set_paddingTop(this.layout.set_paddingLeft(0)); else {
				var _g = this.labelPosition;
				switch(_g[1]) {
				case 1:
					this.layout.set_paddingTop(this.labelText.get_height() + 20);
					this.layout.set_paddingLeft(0);
					this.labelText.set_y(12);
					break;
				case 0:
					this.labelText.set_y(10);
					this.layout.set_paddingTop(0);
					this.layout.set_paddingLeft(this.labelText.get_width() + 20);
					break;
				default:
				}
			}
		}
		if(flag.required) {
			var $it0 = this.components.iterator();
			while( $it0.hasNext() ) {
				var c = $it0.next();
				this.setRequired(c);
			}
		}
	}
	,addComponent: function(component) {
		mui.core.DataContainer.prototype.addComponent.call(this,component);
		this.setRequired(component);
	}
	,setRequired: function(component) {
		if(component == null) return;
		if(!js.Boot.__instanceof(component,mui.input.DataInput)) return;
		var input;
		input = js.Boot.__cast(component , mui.input.DataInput);
		input.set_required(this.required);
		input.isInRequiredGroup = this.required;
	}
	,set_label: function(v) {
		return this.label = this.changeValue("label",v);
	}
	,set_labelPosition: function(v) {
		return this.labelPosition = this.changeValue("labelPosition",v);
	}
	,set_required: function(v) {
		return this.required = this.changeValue("required",v);
	}
	,__class__: mui.input.FormGroup
	,__properties__: $extend(mui.core.DataContainer.prototype.__properties__,{set_required:"set_required",set_labelPosition:"set_labelPosition",set_label:"set_label"})
});
mui.input.FormGroupSkin = function(theme) {
	mui.core.Skin.call(this);
	this.theme = theme;
	this.properties.labelText = { size : theme.textSize, color : theme.textColor, font : theme.textFont};
	null;
};
$hxClasses["mui.input.FormGroupSkin"] = mui.input.FormGroupSkin;
mui.input.FormGroupSkin.__name__ = ["mui","input","FormGroupSkin"];
mui.input.FormGroupSkin.__super__ = mui.core.Skin;
mui.input.FormGroupSkin.prototype = $extend(mui.core.Skin.prototype,{
	required: null
	,theme: null
	,update: function(flag) {
		mui.core.Skin.prototype.update.call(this,flag);
		if(flag.required) {
			if(this.target.required && this.required == null) {
				this.required = new mui.display.Icon(this.theme.requiredIcon,this.theme.requiredIconTextSize,this.theme.textColorInvalid);
				this.required.set_font(this.theme.textFont);
				this.required.set_x(-20);
				this.target.addChild(this.required);
			}
			if(!this.target.required && this.required != null) {
				this.target.removeChild(this.required);
				this.required = null;
			}
		}
		if(flag.height && this.required != null) this.required.set_y(Std["int"]((this.target.get_height() + this.target.labelText.get_height()) / 2) + 3);
	}
	,__class__: mui.input.FormGroupSkin
});
mui.input.FormLabelPosition = { __ename__ : ["mui","input","FormLabelPosition"], __constructs__ : ["Left","Top","Right","Bottom"] };
mui.input.FormLabelPosition.Left = ["Left",0];
mui.input.FormLabelPosition.Left.toString = $estr;
mui.input.FormLabelPosition.Left.__enum__ = mui.input.FormLabelPosition;
mui.input.FormLabelPosition.Top = ["Top",1];
mui.input.FormLabelPosition.Top.toString = $estr;
mui.input.FormLabelPosition.Top.__enum__ = mui.input.FormLabelPosition;
mui.input.FormLabelPosition.Right = ["Right",2];
mui.input.FormLabelPosition.Right.toString = $estr;
mui.input.FormLabelPosition.Right.__enum__ = mui.input.FormLabelPosition;
mui.input.FormLabelPosition.Bottom = ["Bottom",3];
mui.input.FormLabelPosition.Bottom.toString = $estr;
mui.input.FormLabelPosition.Bottom.__enum__ = mui.input.FormLabelPosition;
mui.input.NumberInput = function(skin) {
	mui.input.DataInput.call(this);
	this.set_minimum(0);
	this.set_maximum(100);
	this.set_data(0);
	if(skin != null) this.set_skin(skin);
	null;
};
$hxClasses["mui.input.NumberInput"] = mui.input.NumberInput;
mui.input.NumberInput.__name__ = ["mui","input","NumberInput"];
mui.input.NumberInput.__super__ = mui.input.DataInput;
mui.input.NumberInput.prototype = $extend(mui.input.DataInput.prototype,{
	clearFormData: function() {
		this.set_data(this.minimum);
	}
	,set_data: function(value) {
		if(value > this.maximum) value = this.maximum; else if(value < this.minimum) value = this.minimum;
		return this.data = this.changeValue("data",value);
	}
	,minimum: null
	,set_minimum: function(value) {
		this.minimum = this.changeValue("minimum",value);
		if(this.maximum < this.minimum) this.set_maximum(this.changeValue("maximum",this.minimum));
		if(this.data < this.minimum) this.set_data(this.changeValue("data",this.minimum));
		return this.minimum;
	}
	,maximum: null
	,set_maximum: function(value) {
		this.maximum = this.changeValue("maximum",value);
		if(this.minimum > this.maximum) this.set_minimum(this.changeValue("minimum",this.maximum));
		if(this.data > this.maximum) this.set_data(this.changeValue("data",this.maximum));
		return this.maximum;
	}
	,__class__: mui.input.NumberInput
	,__properties__: $extend(mui.input.DataInput.prototype.__properties__,{set_maximum:"set_maximum",set_minimum:"set_minimum"})
});
mui.input.RadioButton = function(skin) {
	mui.input.ButtonInput.call(this,skin);
	this.inputElement.addEventListener("change",$bind(this,this.inputChanged));
	this.inputElement.className = "view-radio";
	this.inputElement.type = "radio";
	this.set_data(false);
	null;
};
$hxClasses["mui.input.RadioButton"] = mui.input.RadioButton;
mui.input.RadioButton.__name__ = ["mui","input","RadioButton"];
mui.input.RadioButton.selectGroupButton = function(groupButton) {
	if(groupButton.groupName == null) return;
	var _g = 0;
	var _g1 = groupButton.getGroup();
	while(_g < _g1.length) {
		var button = _g1[_g];
		++_g;
		if(button != groupButton) button.set_data(false);
	}
};
mui.input.RadioButton.__super__ = mui.input.ButtonInput;
mui.input.RadioButton.prototype = $extend(mui.input.ButtonInput.prototype,{
	change: function(flag) {
		mui.input.ButtonInput.prototype.change.call(this,flag);
		if(flag.data && this.data) mui.input.RadioButton.selectGroupButton(this);
	}
	,action: function() {
		var selected = null;
		if(this.groupName != null) {
			var group = this.getGroup();
			var _g = 0;
			while(_g < group.length) {
				var radio = group[_g];
				++_g;
				if(radio.data == true) {
					selected = radio;
					this.updateGroupValidity(group,false);
					break;
				}
			}
		}
		if(selected == null || selected != null && selected != this) this.set_data(!this.data);
	}
	,validateData: function() {
		var value = this.data;
		var group = this.getGroup();
		if(this.required) {
			var isError = true;
			var _g = 0;
			while(_g < group.length) {
				var radio = group[_g];
				++_g;
				if(radio.data == true) {
					isError = false;
					break;
				}
			}
			if(isError) {
				this.updateGroupValidity(group,true);
				return { isError : true, message : this.requiredMessage};
			}
		}
		var _g1 = 0;
		var _g11 = this.validators;
		while(_g1 < _g11.length) {
			var validator = _g11[_g1];
			++_g1;
			var _g2 = 0;
			while(_g2 < group.length) {
				var radio1 = group[_g2];
				++_g2;
				var result = validator.validate(radio1.data);
				if(result.isError) {
					this.updateGroupValidity(group,true);
					return result;
				}
			}
		}
		this.updateGroupValidity(group,false);
		return { isError : false, message : ""};
	}
	,updateGroupValidity: function(group,invalid) {
		var _g = 0;
		while(_g < group.length) {
			var radio = group[_g];
			++_g;
			radio.set_invalid(invalid);
		}
	}
	,getFormData: function() {
		if(this.groupName != null) {
			var _g = 0;
			var _g1 = this.getGroup();
			while(_g < _g1.length) {
				var groupButton = _g1[_g];
				++_g;
				if(groupButton.data) return groupButton.groupValue;
			}
		}
		return mui.input.ButtonInput.prototype.getFormData.call(this);
	}
	,setFormData: function(data) {
		if(this.groupName != null) {
			var _g = 0;
			var _g1 = this.getGroup();
			while(_g < _g1.length) {
				var groupButton = _g1[_g];
				++_g;
				if(groupButton.groupValue == data) {
					groupButton.set_data(true);
					return;
				}
			}
		}
		mui.input.ButtonInput.prototype.setFormData.call(this,data);
	}
	,inputChanged: function(_) {
		if(this.inputElement.checked && !this.data) this.set_data(true);
	}
	,destroy: function() {
		this.inputElement.removeEventListener("change",$bind(this,this.inputChanged));
		mui.input.ButtonInput.prototype.destroy.call(this);
	}
	,__class__: mui.input.RadioButton
});
mui.input.RadioButtonSkin = function(theme) {
	mui.input.ButtonInputSkin.call(this,theme);
	this.checked.set_fill(new mui.display.Color(theme.textColor));
	this.background.set_radius(this.checked.set_radius(20));
	null;
};
$hxClasses["mui.input.RadioButtonSkin"] = mui.input.RadioButtonSkin;
mui.input.RadioButtonSkin.__name__ = ["mui","input","RadioButtonSkin"];
mui.input.RadioButtonSkin.__super__ = mui.input.ButtonInputSkin;
mui.input.RadioButtonSkin.prototype = $extend(mui.input.ButtonInputSkin.prototype,{
	__class__: mui.input.RadioButtonSkin
});
mui.input.RangeInput = function(skin) {
	mui.input.NumberInput.call(this,skin);
	this.set_singleStep(0.1);
	this.set_pageStep(1);
	this.set_tracking(true);
	this.set_sliderPosition(0);
	this.set_sliderDown(false);
	this.set_useHandCursor(true);
	null;
};
$hxClasses["mui.input.RangeInput"] = mui.input.RangeInput;
mui.input.RangeInput.__name__ = ["mui","input","RangeInput"];
mui.input.RangeInput.__super__ = mui.input.NumberInput;
mui.input.RangeInput.prototype = $extend(mui.input.NumberInput.prototype,{
	singleStep: null
	,set_singleStep: function(value) {
		return this.singleStep = this.changeValue("singleStep",value);
	}
	,pageStep: null
	,set_pageStep: function(value) {
		return this.pageStep = this.changeValue("pageStep",value);
	}
	,tracking: null
	,set_tracking: function(value) {
		return this.tracking = this.changeValue("tracking",value);
	}
	,sliderPosition: null
	,set_sliderPosition: function(value) {
		return this.sliderPosition = this.changeValue("sliderPosition",value);
	}
	,sliderDown: null
	,set_sliderDown: function(value) {
		return this.sliderDown = this.changeValue("sliderDown",value);
	}
	,triggerAction: function(action) {
		switch(action[1]) {
		case 0:
			null;
			break;
		case 1:
			var _g = this;
			_g.set_data(_g.data + this.singleStep);
			break;
		case 2:
			var _g1 = this;
			_g1.set_data(_g1.data - this.singleStep);
			break;
		case 3:
			var _g2 = this;
			_g2.set_data(_g2.data + this.pageStep);
			break;
		case 4:
			var _g3 = this;
			_g3.set_data(_g3.data - this.pageStep);
			break;
		case 5:
			this.set_data(this.minimum);
			break;
		case 6:
			this.set_data(this.maximum);
			break;
		case 7:
			null;
			break;
		}
	}
	,keyPress: function(key) {
		var _g = key.get_action();
		switch(_g[1]) {
		case 1:
			key.capture();
			this.triggerAction(mui.input.SliderAction.SliderSingleStepSub);
			break;
		case 2:
			key.capture();
			this.triggerAction(mui.input.SliderAction.SliderSingleStepAdd);
			break;
		default:
			mui.input.NumberInput.prototype.keyPress.call(this,key);
		}
	}
	,__class__: mui.input.RangeInput
	,__properties__: $extend(mui.input.NumberInput.prototype.__properties__,{set_sliderDown:"set_sliderDown",set_sliderPosition:"set_sliderPosition",set_tracking:"set_tracking",set_pageStep:"set_pageStep",set_singleStep:"set_singleStep"})
});
mui.input.SliderAction = { __ename__ : ["mui","input","SliderAction"], __constructs__ : ["SliderNoAction","SliderSingleStepAdd","SliderSingleStepSub","SliderPageStepAdd","SliderPageStepSub","SliderToMinimum","SliderToMaximum","SliderMove"] };
mui.input.SliderAction.SliderNoAction = ["SliderNoAction",0];
mui.input.SliderAction.SliderNoAction.toString = $estr;
mui.input.SliderAction.SliderNoAction.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderSingleStepAdd = ["SliderSingleStepAdd",1];
mui.input.SliderAction.SliderSingleStepAdd.toString = $estr;
mui.input.SliderAction.SliderSingleStepAdd.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderSingleStepSub = ["SliderSingleStepSub",2];
mui.input.SliderAction.SliderSingleStepSub.toString = $estr;
mui.input.SliderAction.SliderSingleStepSub.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderPageStepAdd = ["SliderPageStepAdd",3];
mui.input.SliderAction.SliderPageStepAdd.toString = $estr;
mui.input.SliderAction.SliderPageStepAdd.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderPageStepSub = ["SliderPageStepSub",4];
mui.input.SliderAction.SliderPageStepSub.toString = $estr;
mui.input.SliderAction.SliderPageStepSub.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderToMinimum = ["SliderToMinimum",5];
mui.input.SliderAction.SliderToMinimum.toString = $estr;
mui.input.SliderAction.SliderToMinimum.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderToMaximum = ["SliderToMaximum",6];
mui.input.SliderAction.SliderToMaximum.toString = $estr;
mui.input.SliderAction.SliderToMaximum.__enum__ = mui.input.SliderAction;
mui.input.SliderAction.SliderMove = ["SliderMove",7];
mui.input.SliderAction.SliderMove.toString = $estr;
mui.input.SliderAction.SliderMove.__enum__ = mui.input.SliderAction;
mui.input.SliderChange = { __ename__ : ["mui","input","SliderChange"], __constructs__ : ["SliderRangeChange","SliderOrientationChange","SliderStepsChange","SliderValueChange"] };
mui.input.SliderChange.SliderRangeChange = ["SliderRangeChange",0];
mui.input.SliderChange.SliderRangeChange.toString = $estr;
mui.input.SliderChange.SliderRangeChange.__enum__ = mui.input.SliderChange;
mui.input.SliderChange.SliderOrientationChange = ["SliderOrientationChange",1];
mui.input.SliderChange.SliderOrientationChange.toString = $estr;
mui.input.SliderChange.SliderOrientationChange.__enum__ = mui.input.SliderChange;
mui.input.SliderChange.SliderStepsChange = ["SliderStepsChange",2];
mui.input.SliderChange.SliderStepsChange.toString = $estr;
mui.input.SliderChange.SliderStepsChange.__enum__ = mui.input.SliderChange;
mui.input.SliderChange.SliderValueChange = ["SliderValueChange",3];
mui.input.SliderChange.SliderValueChange.toString = $estr;
mui.input.SliderChange.SliderValueChange.__enum__ = mui.input.SliderChange;
mui.input.RangeInputSkin = function(theme) {
	mui.input.ThemeSkin.call(this,theme);
	this.defaultWidth = 150;
	this.defaultHeight = 21;
	this.minHeight = this.maxHeight = 21;
	this.track = new mui.display.Rectangle();
	this.addChild(this.track);
	this.track.set_left(this.track.set_right(0));
	this.track.set_radius(9);
	this.track.set_height(9);
	this.track.set_fill(new mui.display.Gradient([new mui.display.GradientColor(14606046,1,0.1),new mui.display.GradientColor(16777215,1,0.14),new mui.display.GradientColor(15198183,1,0.41),new mui.display.GradientColor(12237498,1,0.83),new mui.display.GradientColor(9474192,1,0.85)],-90));
	this.track.set_strokeThickness(1);
	this.track.set_stroke(new mui.display.Gradient([new mui.display.GradientColor(11579568,1,0),new mui.display.GradientColor(8421504,1,1)],-90));
	this.track.set_centerY(0.5);
	this.amount = new mui.display.Rectangle();
	this.addChild(this.amount);
	this.amount.set_radiusTopLeft(this.amount.set_radiusBottomLeft(9));
	this.amount.set_height(9);
	this.amount.set_width(20);
	this.amount.set_centerY(0.5);
	this.amount.set_strokeThickness(1);
	this.amount.set_stroke(new mui.display.Gradient([new mui.display.GradientColor(5147349,1,0),new mui.display.GradientColor(670087,1,1)],-90));
	this.amount.set_fill(new mui.display.Gradient([new mui.display.GradientColor(7843318,1,0.0),new mui.display.GradientColor(3105975,1,0.85),new mui.display.GradientColor(870568,1,0.92)],-90));
	this.thumb = new mui.display.Rectangle();
	this.addChild(this.thumb);
	this.thumb.set_fill(new mui.display.Gradient([new mui.display.GradientColor(10921638,1,0),new mui.display.GradientColor(16448250,1,1)],90));
	this.thumb.set_strokeThickness(1);
	this.thumb.set_stroke(new mui.display.Color(10329501));
	this.thumb.set_width(this.thumb.set_height(21));
	this.thumb.set_centerY(0.5);
	this.thumb.set_radius(21);
	this.value = new mui.display.Text();
	this.thumb.addChild(this.value);
	this.value.set_autoSize(false);
	this.value.set_width(this.thumb.get_width());
	this.value.set_height(14);
	this.value.set_y(6);
	this.value.set_size(8);
	this.value.set_align("center");
	this.dragBehavior = new mui.behavior.DragBehavior();
	this.dragBehavior.set_target(this.thumb);
	this.dragBehavior.dragStarted.add($bind(this,this.dragStarted));
	this.dragBehavior.dragUpdated.add($bind(this,this.dragUpdated));
	this.dragBehavior.dragStopped.add($bind(this,this.dragStopped));
	null;
};
$hxClasses["mui.input.RangeInputSkin"] = mui.input.RangeInputSkin;
mui.input.RangeInputSkin.__name__ = ["mui","input","RangeInputSkin"];
mui.input.RangeInputSkin.__super__ = mui.input.ThemeSkin;
mui.input.RangeInputSkin.prototype = $extend(mui.input.ThemeSkin.prototype,{
	track: null
	,amount: null
	,thumb: null
	,dragBehavior: null
	,value: null
	,update: function(flag) {
		mui.input.ThemeSkin.prototype.update.call(this,flag);
		if(flag.width || flag.height) {
			this.dragBehavior.minimumX = 0;
			this.dragBehavior.maximumX = this.target.get_width() - this.thumb.get_width();
			this.dragBehavior.minimumY = this.dragBehavior.maximumY = this.thumb.y;
		}
		if(flag.data || flag.width || flag.height) {
			if(!this.target.sliderDown) this.updatePosition();
			var ratio = (this.target.data - this.target.minimum) / (this.target.maximum - this.target.minimum);
			if(!Math.isNaN(ratio)) this.amount.set_width(Math.round((this.target.get_width() - this.thumb.get_width()) * ratio) + 10);
			this.value.set_value(Std.string((this.target.data * 10 | 0) / 10));
		}
	}
	,dragStarted: function() {
		this.dragBehavior.minimumY = this.dragBehavior.maximumY = this.thumb.y;
		this.target.set_sliderDown(true);
		this.target.focus();
	}
	,dragUpdated: function() {
		if(this.target.tracking) this.updateValue();
	}
	,dragStopped: function() {
		this.target.set_sliderDown(false);
		this.updateValue();
	}
	,updatePosition: function() {
		var value;
		if(Math.isNaN(this.target.data)) value = 0; else value = this.target.data;
		var ratio = (value - this.target.minimum) / (this.target.maximum - this.target.minimum);
		this.thumb.set_x(Math.round((this.target.get_width() - this.thumb.get_width()) * ratio));
	}
	,updateValue: function() {
		var ratio = this.thumb.x / (this.target.get_width() - this.thumb.get_width());
		var range = this.target.maximum - this.target.minimum;
		this.target.set_data(this.target.minimum + range * ratio);
	}
	,__class__: mui.input.RangeInputSkin
});
mui.input.SelectDisplay = function() {
	mui.display.Display.call(this);
	this.element.className += " view-select";
	this.select = this.element;
	this.select.addEventListener("focus",$bind(this,this.elementFocused));
	this.select.addEventListener("blur",$bind(this,this.elementBlurred));
	this.select.addEventListener("change",$bind(this,this.elementChanged));
	this.select.addEventListener("click",$bind(this,this.elementClicked));
	this.select.addEventListener("mousedown",$bind(this,this.elementPressed));
	this.set_selectedIndex(-1);
	this.set_optionsVisible(false);
	this.set_focused(false);
	this.set_data([]);
	null;
};
$hxClasses["mui.input.SelectDisplay"] = mui.input.SelectDisplay;
mui.input.SelectDisplay.__name__ = ["mui","input","SelectDisplay"];
mui.input.SelectDisplay.__super__ = mui.display.Display;
mui.input.SelectDisplay.prototype = $extend(mui.display.Display.prototype,{
	select: null
	,focused: null
	,optionsVisible: null
	,selectedIndex: null
	,data: null
	,get_selectedData: function() {
		return this.data[this.selectedIndex];
	}
	,set_selectedData: function(value) {
		var _g1 = 0;
		var _g = this.data.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.data[i] == value) {
				this.set_selectedIndex(i);
				return value;
			}
		}
		return this.data[this.selectedIndex];
	}
	,set_data: function(values) {
		if(values == null) values = [];
		this.data = values;
		this.set_selectedIndex(-1);
		this.validate();
		this.select.innerHTML = "";
		var _g1 = 0;
		var _g = values.length;
		while(_g1 < _g) {
			var i = _g1++;
			var option = values[i];
			var optionElement = window.document.createElement("option");
			var value = Std.string(Object.prototype.hasOwnProperty.call(option,"value")?Reflect.field(option,"value"):option);
			if(Object.prototype.hasOwnProperty.call(option,"label")) optionElement.text = Std.string(Reflect.field(option,"label")); else optionElement.text = value;
			if(Object.prototype.hasOwnProperty.call(option,"disabled")) optionElement.setAttribute("disabled","true");
			this.select.appendChild(optionElement);
		}
		this.select.selectedIndex = this.selectedIndex;
		return values;
	}
	,createDisplay: function() {
		return window.document.createElement("select");
	}
	,elementChanged: function(_) {
		this.set_selectedIndex(this.select.selectedIndex);
	}
	,elementFocused: function(_) {
		this.set_focused(true);
		this.set_optionsVisible(false);
	}
	,elementBlurred: function(_) {
		this.set_focused(false);
	}
	,elementClicked: function(_) {
		this.set_optionsVisible(!this.optionsVisible);
	}
	,elementPressed: function(e) {
		e.stopPropagation();
	}
	,change: function(flag) {
		mui.display.Display.prototype.change.call(this,flag);
		if(flag.enabled) this.select.disabled = !this.enabled;
		if(flag.focused && this.enabled && this.focused) this.select.focus();
		if(flag.selectedIndex) this.select.selectedIndex = this.selectedIndex;
	}
	,destroy: function() {
		this.select.removeEventListener("focus",$bind(this,this.elementFocused));
		this.select.removeEventListener("blur",$bind(this,this.elementBlurred));
		this.select.removeEventListener("change",$bind(this,this.elementChanged));
		this.select.removeEventListener("click",$bind(this,this.elementClicked));
		this.select.removeEventListener("mousedown",$bind(this,this.elementPressed));
		mui.display.Display.prototype.destroy.call(this);
	}
	,set_focused: function(v) {
		return this.focused = this.changeValue("focused",v);
	}
	,set_optionsVisible: function(v) {
		return this.optionsVisible = this.changeValue("optionsVisible",v);
	}
	,set_selectedIndex: function(v) {
		return this.selectedIndex = this.changeValue("selectedIndex",v);
	}
	,__class__: mui.input.SelectDisplay
	,__properties__: $extend(mui.display.Display.prototype.__properties__,{set_data:"set_data",set_selectedData:"set_selectedData",get_selectedData:"get_selectedData",set_selectedIndex:"set_selectedIndex",set_optionsVisible:"set_optionsVisible",set_focused:"set_focused"})
});
mui.input.DataSelectInput = function(skin) {
	mui.input.DataInput.call(this,skin);
	this.set_data(null);
	this.set_options(null);
	this.set_optionsVisible(false);
	this.set_placeholder("");
	this.set_dataLabel(this.placeholder);
	null;
};
$hxClasses["mui.input.DataSelectInput"] = mui.input.DataSelectInput;
mui.input.DataSelectInput.__name__ = ["mui","input","DataSelectInput"];
mui.input.DataSelectInput.__super__ = mui.input.DataInput;
mui.input.DataSelectInput.prototype = $extend(mui.input.DataInput.prototype,{
	options: null
	,optionsVisible: null
	,placeholder: null
	,dataLabel: null
	,getDataLabel: function(data) {
		if(data == null) return this.placeholder;
		if(Object.prototype.hasOwnProperty.call(data,"label")) return Reflect.field(data,"label"); else return Std.string(data);
	}
	,set_data: function(value) {
		this.set_dataLabel(this.getDataLabel(value));
		return mui.input.DataInput.prototype.set_data.call(this,value);
	}
	,clearFormData: function() {
		mui.input.DataInput.prototype.clearFormData.call(this);
		this.set_data(null);
	}
	,set_options: function(v) {
		return this.options = this.changeValue("options",v);
	}
	,set_optionsVisible: function(v) {
		return this.optionsVisible = this.changeValue("optionsVisible",v);
	}
	,set_placeholder: function(v) {
		return this.placeholder = this.changeValue("placeholder",v);
	}
	,set_dataLabel: function(v) {
		return this.dataLabel = this.changeValue("dataLabel",v);
	}
	,__class__: mui.input.DataSelectInput
	,__properties__: $extend(mui.input.DataInput.prototype.__properties__,{set_dataLabel:"set_dataLabel",set_placeholder:"set_placeholder",set_optionsVisible:"set_optionsVisible",set_options:"set_options"})
});
mui.input.SelectInputSkin = function(theme) {
	mui.input.ThemeSkin.call(this,theme);
	this.defaultWidth = 385;
	this.defaultHeight = theme.defaultHeight;
	this.addChild(this.background);
	this.arrow = new mui.display.Icon(theme.downArrowIcon,20,theme.textColor);
	this.addChild(this.arrow);
	this.arrow.set_font(theme.iconFont);
	this.arrow.set_centerY(0.5);
	this.arrow.set_right(12);
	this.label = new mui.display.Text();
	this.addChild(this.label);
	this.label.set_autoSize(false);
	this.label.set_height(20);
	this.label.set_left(16);
	this.label.set_right(38);
	this.label.set_clip(true);
	this.label.set_size(theme.textSize);
	this.label.set_centerY(0.5);
	this.label.set_font(theme.textFont);
	this.label.set_color(11119017);
	this.options = new mui.input.SelectDisplay();
	this.addChild(this.options);
	this.options.changed.add($bind(this,this.optionsChanged));
	this.options.set_all(0);
	null;
};
$hxClasses["mui.input.SelectInputSkin"] = mui.input.SelectInputSkin;
mui.input.SelectInputSkin.__name__ = ["mui","input","SelectInputSkin"];
mui.input.SelectInputSkin.__super__ = mui.input.ThemeSkin;
mui.input.SelectInputSkin.prototype = $extend(mui.input.ThemeSkin.prototype,{
	arrow: null
	,label: null
	,options: null
	,update: function(flag) {
		mui.input.ThemeSkin.prototype.update.call(this,flag);
		if(flag.options) this.options.set_data(this.target.options);
		if(flag.width) this.options.set_width(this.target.get_width());
		if(flag.dataLabel) this.label.set_value(this.target.dataLabel);
		if(flag.enabled) this.options.set_enabled(this.target.enabled);
		if(flag.enabled || flag.focused || flag.invalid || flag.data) {
			this.updateState(this.label);
			if(this.target.data == null) {
				this.options.set_selectedIndex(-1);
				this.label.set_color(11119017);
			} else this.options.set_selectedIndex((function($this) {
				var $r;
				var x = $this.target.data;
				$r = HxOverrides.indexOf($this.target.options,x,0);
				return $r;
			}(this)));
		}
	}
	,optionsChanged: function(flag) {
		if(flag.focused && this.options.focused) this.target.focus();
		if(flag.selectedIndex) {
			if(this.options.get_selectedData() != null) this.target.set_data(this.options.get_selectedData());
		}
		if(flag.optionsVisible) this.target.set_optionsVisible(this.options.optionsVisible);
	}
	,__class__: mui.input.SelectInputSkin
});
mui.input.TextInput = function(skin) {
	this.inputText = new mui.display.InputText();
	mui.input.DataInput.call(this,skin);
	this.set_maxLength(0);
	this.set_secureInput(false);
	this.set_placeholder(null);
	this.addChild(this.inputText);
	this.inputText.changed.add($bind(this,this.inputTextChanged));
	this.inputText.set_left(this.inputText.set_right(10));
	this.inputText.set_centerY(0.5);
	var behavior = new mui.behavior.ButtonBehavior(this);
	behavior.focusOnPress = false;
	behavior.focusOnRelease = true;
	this.createHintBehavior();
	null;
};
$hxClasses["mui.input.TextInput"] = mui.input.TextInput;
mui.input.TextInput.__name__ = ["mui","input","TextInput"];
mui.input.TextInput.__super__ = mui.input.DataInput;
mui.input.TextInput.prototype = $extend(mui.input.DataInput.prototype,{
	inputText: null
	,placeholder: null
	,secureInput: null
	,maxLength: null
	,createHintBehavior: function() {
		new mui.behavior.InputTextHintBehavior(this.inputText);
	}
	,clearFormData: function() {
		mui.input.DataInput.prototype.clearFormData.call(this);
		this.set_data("");
	}
	,focus: function() {
		mui.input.DataInput.prototype.focus.call(this);
		if(!this.inputText.focused) this.inputText.focus();
	}
	,change: function(flag) {
		mui.input.DataInput.prototype.change.call(this,flag);
		if(flag.enabled) this.inputText.set_enabled(this.enabled);
		if(flag.placeholder) this.inputText.set_placeholder(this.placeholder);
		if(flag.secureInput) this.inputText.set_secureInput(this.secureInput);
		if(flag.maxLength) this.inputText.set_maxLength(this.maxLength);
		if(flag.focused && !this.focused) this.inputText.set_focused(false);
	}
	,inputTextChanged: function(flag) {
		if(flag.focused && this.inputText.focused) this.focus();
		if(flag.value) this.set_data(this.inputText.value);
	}
	,updateData: function(data) {
		this.inputText.set_value(data);
	}
	,keyPress: function(key) {
	}
	,set_placeholder: function(v) {
		return this.placeholder = this.changeValue("placeholder",v);
	}
	,set_secureInput: function(v) {
		return this.secureInput = this.changeValue("secureInput",v);
	}
	,set_maxLength: function(v) {
		return this.maxLength = this.changeValue("maxLength",v);
	}
	,__class__: mui.input.TextInput
	,__properties__: $extend(mui.input.DataInput.prototype.__properties__,{set_maxLength:"set_maxLength",set_secureInput:"set_secureInput",set_placeholder:"set_placeholder"})
});
mui.input.TextInputSkin = function(theme) {
	mui.input.ThemeSkin.call(this,theme);
	this.defaultWidth = 385;
	this.defaultHeight = theme.defaultHeight;
	this.addChild(this.background);
	this.properties.inputText = { left : 16, right : 16, size : theme.textSize, color : theme.textColor, font : theme.textFont};
	null;
};
$hxClasses["mui.input.TextInputSkin"] = mui.input.TextInputSkin;
mui.input.TextInputSkin.__name__ = ["mui","input","TextInputSkin"];
mui.input.TextInputSkin.__super__ = mui.input.ThemeSkin;
mui.input.TextInputSkin.prototype = $extend(mui.input.ThemeSkin.prototype,{
	update: function(flag) {
		mui.input.ThemeSkin.prototype.update.call(this,flag);
		if(flag.enabled || flag.focused || flag.invalid) this.updateState(this.target.inputText);
	}
	,__class__: mui.input.TextInputSkin
});
mui.input.Theme = function() {
	this.borderWidth = 2;
	this.borderRadius = 6;
	this.iconFont = "FontAwesome";
	this.textFont = "SourceSansPro";
	this.textSize = 16;
	this.requiredIconTextSize = 21;
	this.defaultHeight = 40;
	this.checkedIcon = "#";
	this.downArrowIcon = "≈";
	this.requiredIcon = "*";
	this.labelColor = 5066061;
	this.labelSize = 14;
	this.textColor = 5066061;
	this.textColorFocused = 5066061;
	this.textColorInvalid = 16711680;
	this.textColorDisabled = 5066061;
	this.backgroundColor = 13158600;
	this.backgroundColorFocused = 13158600;
	this.backgroundColorInvalid = 16761795;
	this.backgroundColorDisabled = 7500402;
	this.borderColor = 13158600;
	this.borderColorFocused = 16777215;
	this.borderColorInvalid = 16761795;
	this.borderColorDisabled = 7500402;
	this.showRequiredIcon = true;
};
$hxClasses["mui.input.Theme"] = mui.input.Theme;
mui.input.Theme.__name__ = ["mui","input","Theme"];
mui.input.Theme.prototype = {
	iconFont: null
	,checkedIcon: null
	,downArrowIcon: null
	,requiredIcon: null
	,requiredIconTextSize: null
	,labelColor: null
	,labelSize: null
	,textFont: null
	,textSize: null
	,textColor: null
	,textColorFocused: null
	,textColorInvalid: null
	,textColorDisabled: null
	,backgroundColor: null
	,backgroundColorFocused: null
	,backgroundColorInvalid: null
	,backgroundColorDisabled: null
	,borderColor: null
	,borderColorFocused: null
	,borderColorInvalid: null
	,borderColorDisabled: null
	,borderWidth: null
	,borderRadius: null
	,defaultHeight: null
	,showRequiredIcon: null
	,__class__: mui.input.Theme
};
mui.input.ThemeFormBuilder = function(theme) {
	mui.input.FormBuilder.call(this);
	this.theme = theme;
};
$hxClasses["mui.input.ThemeFormBuilder"] = mui.input.ThemeFormBuilder;
mui.input.ThemeFormBuilder.__name__ = ["mui","input","ThemeFormBuilder"];
mui.input.ThemeFormBuilder.__super__ = mui.input.FormBuilder;
mui.input.ThemeFormBuilder.prototype = $extend(mui.input.FormBuilder.prototype,{
	theme: null
	,createCheckBox: function() {
		return new mui.input.CheckBox(new mui.input.CheckBoxSkin(this.theme));
	}
	,createRadioButton: function() {
		return new mui.input.RadioButton(new mui.input.RadioButtonSkin(this.theme));
	}
	,createSelectInput: function() {
		return new mui.input.DataSelectInput(new mui.input.SelectInputSkin(this.theme));
	}
	,createTextInput: function() {
		return new mui.input.TextInput(new mui.input.TextInputSkin(this.theme));
	}
	,createGroup: function() {
		return new mui.input.FormGroup(new mui.input.FormGroupSkin(this.theme));
	}
	,createRangeInput: function() {
		return new mui.input.RangeInput(new mui.input.RangeInputSkin(this.theme));
	}
	,__class__: mui.input.ThemeFormBuilder
});
mui.layout = {};
mui.layout.AbstractLayout = function() {
	mui.core.Behavior.call(this);
	this.set_circular(false);
	this.reset();
	null;
};
$hxClasses["mui.layout.AbstractLayout"] = mui.layout.AbstractLayout;
mui.layout.AbstractLayout.__name__ = ["mui","layout","AbstractLayout"];
mui.layout.AbstractLayout.__super__ = mui.core.Behavior;
mui.layout.AbstractLayout.prototype = $extend(mui.core.Behavior.prototype,{
	circular: null
	,validIndex: null
	,cells: null
	,virtual: null
	,add: function() {
		this.virtual = js.Boot.__instanceof(this.target,mui.display.VirtualDisplay);
		this.reset();
	}
	,update: function(flag) {
		if(flag.children || flag.layout || flag.width || flag.height) {
			this.invalidateProperty("target");
			this.reset();
		}
		if((this.circular || this.virtual) && flag.scrollX || flag.scrollY) this.invalidateProperty("target");
	}
	,change: function(flag) {
		if(!this.enabled || this.target == null) return;
		if(flag.cellWidth || flag.cellHeight || flag.vertical) this.reset(); else if(flag.spacingX || flag.spacingY || flag.paddingLeft || flag.paddingTop || flag.paddingRight || flag.paddingBottom) this.validIndex = -1;
		if(flag.target || flag.cellAlignX || flag.cellAlignY || this.validIndex == -1) {
			if(this.target.numChildren > 0) {
				if(this.virtual) this.layoutVirtual(); else this.layout();
			}
		}
	}
	,reset: function() {
		this.validIndex = -1;
		this.cells = [];
		if(this.virtual) this.measureVirtual();
	}
	,layoutFirst: function(cell) {
	}
	,layoutNext: function(cell,previous) {
	}
	,isVisible: function(cell) {
		return true;
	}
	,isFirst: function(cell) {
		return false;
	}
	,isLast: function(cell) {
		return false;
	}
	,updateDisplay: function(display,cell) {
	}
	,updateCell: function(cell) {
	}
	,measureLayout: function() {
	}
	,measureVirtual: function() {
	}
	,resizeDisplay: function(index) {
	}
	,layout: function() {
		var _g1 = 0;
		var _g = this.target.numChildren;
		while(_g1 < _g) {
			var index = _g1++;
			this.layoutDisplay(index);
		}
	}
	,layoutVirtual: function() {
		var first = this.target.numChildren;
		var nextFirst = first;
		var last = -1;
		var $it0 = this.target.iterator();
		while( $it0.hasNext() ) {
			var display = $it0.next();
			var index = display.index;
			var cell = this.getCell(index);
			if(this.isVisible(cell)) {
				if(index < first) first = index;
				if(index > first && index < nextFirst) nextFirst = index;
				if(index > last) last = index;
				this.updateDisplay(display,cell);
			} else this.releaseDisplay(index);
		}
		if(nextFirst != this.target.numChildren && nextFirst - first > 1) first = nextFirst;
		if(first == this.target.numChildren) first = last = 0;
		var firstCell = this.getCell(first);
		if(!this.isVisible(firstCell)) return;
		while(!this.isFirst(firstCell)) {
			first = this.previousIndex(first);
			if(first == -1) break;
			firstCell = this.getCell(first);
			this.layoutDisplay(first);
		}
		var lastCell = this.getCell(last);
		while(!this.isLast(lastCell)) {
			last = this.nextIndex(last);
			if(last == -1) break;
			lastCell = this.getCell(last);
			this.layoutDisplay(last);
		}
	}
	,layoutDisplay: function(index) {
		var cell = this.getCell(index);
		var display = this.requestDisplay(index);
		this.updateDisplay(display,cell);
	}
	,getCell: function(index) {
		var cell = this.requestCell(index);
		if(index <= this.validIndex) return cell;
		if(index == 0) this.layoutFirst(cell); else {
			var previous = this.getCell(index - 1);
			this.layoutNext(cell,previous);
		}
		if(index > this.validIndex) this.validIndex = index;
		if(index == this.target.numChildren - 1) this.measureLayout();
		return cell;
	}
	,requestCell: function(index) {
		if(this.cells[index] == null) return this.cells[index] = this.createCell(index); else return this.cells[index];
	}
	,createCell: function(index) {
		var cell = new mui.layout.Cell(index);
		this.updateCell(cell);
		return cell;
	}
	,requestDisplay: function(index) {
		return this.target.getChildAt(index);
	}
	,releaseDisplay: function(index) {
		this.target.releaseChildAt(index);
	}
	,next: function(index,direction) {
		return -1;
	}
	,nextIndex: function(index) {
		if(index < this.target.numChildren - 1) return index + 1; else if(this.circular) return 0; else return -1;
	}
	,previousIndex: function(index) {
		if(index > 0) return index - 1; else if(this.circular) return this.target.numChildren - 1; else return -1;
	}
	,set_circular: function(v) {
		return this.circular = this.changeValue("circular",v);
	}
	,__class__: mui.layout.AbstractLayout
	,__properties__: $extend(mui.core.Behavior.prototype.__properties__,{set_circular:"set_circular"})
});
mui.layout.AlignX = { __ename__ : ["mui","layout","AlignX"], __constructs__ : ["left","center","right"] };
mui.layout.AlignX.left = ["left",0];
mui.layout.AlignX.left.toString = $estr;
mui.layout.AlignX.left.__enum__ = mui.layout.AlignX;
mui.layout.AlignX.center = ["center",1];
mui.layout.AlignX.center.toString = $estr;
mui.layout.AlignX.center.__enum__ = mui.layout.AlignX;
mui.layout.AlignX.right = ["right",2];
mui.layout.AlignX.right.toString = $estr;
mui.layout.AlignX.right.__enum__ = mui.layout.AlignX;
mui.layout.AlignY = { __ename__ : ["mui","layout","AlignY"], __constructs__ : ["top","middle","bottom"] };
mui.layout.AlignY.top = ["top",0];
mui.layout.AlignY.top.toString = $estr;
mui.layout.AlignY.top.__enum__ = mui.layout.AlignY;
mui.layout.AlignY.middle = ["middle",1];
mui.layout.AlignY.middle.toString = $estr;
mui.layout.AlignY.middle.__enum__ = mui.layout.AlignY;
mui.layout.AlignY.bottom = ["bottom",2];
mui.layout.AlignY.bottom.toString = $estr;
mui.layout.AlignY.bottom.__enum__ = mui.layout.AlignY;
mui.layout.Cell = function(index) {
	this.index = index;
	this.x = this.y = this.width = this.height = 0;
};
$hxClasses["mui.layout.Cell"] = mui.layout.Cell;
mui.layout.Cell.__name__ = ["mui","layout","Cell"];
mui.layout.Cell.prototype = {
	index: null
	,x: null
	,y: null
	,width: null
	,height: null
	,right: function() {
		return this.x + this.width;
	}
	,bottom: function() {
		return this.y + this.height;
	}
	,clone: function() {
		var cell = new mui.layout.Cell(this.index);
		cell.x = this.x;
		cell.y = this.y;
		cell.width = this.width;
		cell.height = this.height;
		return cell;
	}
	,__class__: mui.layout.Cell
};
mui.layout.Direction = { __ename__ : ["mui","layout","Direction"], __constructs__ : ["next","previous","up","down","left","right"] };
mui.layout.Direction.next = ["next",0];
mui.layout.Direction.next.toString = $estr;
mui.layout.Direction.next.__enum__ = mui.layout.Direction;
mui.layout.Direction.previous = ["previous",1];
mui.layout.Direction.previous.toString = $estr;
mui.layout.Direction.previous.__enum__ = mui.layout.Direction;
mui.layout.Direction.up = ["up",2];
mui.layout.Direction.up.toString = $estr;
mui.layout.Direction.up.__enum__ = mui.layout.Direction;
mui.layout.Direction.down = ["down",3];
mui.layout.Direction.down.toString = $estr;
mui.layout.Direction.down.__enum__ = mui.layout.Direction;
mui.layout.Direction.left = ["left",4];
mui.layout.Direction.left.toString = $estr;
mui.layout.Direction.left.__enum__ = mui.layout.Direction;
mui.layout.Direction.right = ["right",5];
mui.layout.Direction.right.toString = $estr;
mui.layout.Direction.right.__enum__ = mui.layout.Direction;
mui.layout.Layout = function() {
	mui.layout.AbstractLayout.call(this);
	this.set_cellWidth(this.set_cellHeight(null));
	this.set_vertical(true);
	this.set_paddingLeft(this.set_paddingRight(this.set_paddingTop(this.set_paddingBottom(this.set_spacingX(this.set_spacingY(0))))));
	this.set_cellAlignX(this.set_cellAlignY(0));
	null;
};
$hxClasses["mui.layout.Layout"] = mui.layout.Layout;
mui.layout.Layout.__name__ = ["mui","layout","Layout"];
mui.layout.Layout.__super__ = mui.layout.AbstractLayout;
mui.layout.Layout.prototype = $extend(mui.layout.AbstractLayout.prototype,{
	vertical: null
	,padding: null
	,paddingLeft: null
	,paddingRight: null
	,paddingTop: null
	,paddingBottom: null
	,spacing: null
	,spacingX: null
	,spacingY: null
	,cellWidth: null
	,cellHeight: null
	,cellAlignX: null
	,cellAlignY: null
	,layoutFirst: function(cell) {
		cell.x = this.paddingLeft;
		cell.y = this.paddingTop;
	}
	,layoutNext: function(cell,previous) {
		if(this.vertical) {
			cell.y = previous.y + previous.height + this.spacingY;
			cell.x = previous.x;
		} else {
			cell.x = previous.x + previous.width + this.spacingX;
			cell.y = previous.y;
		}
	}
	,isVisible: function(cell) {
		if(this.vertical) return cell.y + cell.height > this.target.get_scrollY() && cell.y < this.target.get_scrollY() + this.target.get_height(); else return cell.x + cell.width > this.target.get_scrollX() && cell.x < this.target.get_scrollX() + this.target.get_width();
	}
	,isFirst: function(cell) {
		if(this.vertical) return cell.y - this.spacingY <= this.target.get_scrollY(); else return cell.x - this.spacingX <= this.target.get_scrollX();
	}
	,isLast: function(cell) {
		if(this.vertical) return cell.y + cell.height + this.spacingY >= this.target.get_scrollY() + this.target.get_height(); else return cell.x + cell.width + this.spacingX >= this.target.get_scrollX() + this.target.get_width();
	}
	,updateCell: function(cell) {
		var index = cell.index;
		if(this.cellWidth == null) cell.width = Std["int"](this.requestDisplay(index).get_width()); else cell.width = this.cellWidth;
		if(this.cellHeight == null) cell.height = Std["int"](this.requestDisplay(index).get_height()); else cell.height = this.cellHeight;
	}
	,updateDisplay: function(display,cell) {
		display.set_x(cell.x + Math.round((cell.width - display.get_width()) * this.cellAlignX));
		display.set_y(cell.y + Math.round((cell.height - display.get_height()) * this.cellAlignY));
	}
	,resizeDisplay: function(index) {
		if(this.cellWidth != null && this.cellHeight != null) {
			if(this.cellAlignX != 0 || this.cellAlignY != 0) this.updateDisplay(this.requestDisplay(index),this.requestCell(index));
			return;
		}
		var update = this.cells[index] != null;
		var cell = this.requestCell(index);
		if(update) this.updateCell(cell);
		if(index < this.validIndex) this.validIndex = index;
		if(index == this.target.numChildren - 1) this.measureLayout();
		this.invalidateProperty("target");
	}
	,next: function(index,direction) {
		var previous = this.previousIndex(index);
		var next = this.nextIndex(index);
		switch(direction[1]) {
		case 4:
			if(this.vertical) return -1; else return previous;
			break;
		case 5:
			if(this.vertical) return -1; else return next;
			break;
		case 2:
			if(this.vertical) return previous; else return -1;
			break;
		case 3:
			if(this.vertical) return next; else return -1;
			break;
		case 1:
			return previous;
		case 0:
			return next;
		}
	}
	,measureLayout: function() {
		var cell = this.getCell(this.target.numChildren - 1);
		this.target.set_contentWidth(cell.x + cell.width + this.paddingRight);
		this.target.set_contentHeight(cell.y + cell.height + this.paddingBottom);
	}
	,measureVirtual: function() {
		if(this.vertical) {
			var w;
			if(this.cellWidth != null && this.target.numChildren > 0) w = this.cellWidth; else w = 0;
			this.target.set_contentWidth(this.paddingLeft + w + this.paddingRight);
			var h = 0;
			if(this.target.numChildren > 0) if(this.cellHeight == null) h = 100000; else h = this.target.numChildren * (this.cellHeight + this.spacingY) - this.spacingY;
			this.target.set_contentHeight(this.paddingTop + h + this.paddingBottom);
		} else {
			var w1 = 0;
			if(this.target.numChildren > 0) if(this.cellWidth == null) w1 = 100000; else w1 = this.target.numChildren * (this.cellWidth + this.spacingX) - this.spacingX;
			this.target.set_contentWidth(this.paddingLeft + w1 + this.paddingRight);
			var h1;
			if(this.cellHeight != null && this.target.numChildren > 0) h1 = this.cellHeight; else h1 = 0;
			this.target.set_contentHeight(this.paddingTop + h1 + this.paddingBottom);
		}
	}
	,set_vertical: function(v) {
		return this.vertical = this.changeValue("vertical",v);
	}
	,set_padding: function(v) {
		return this.set_paddingBottom(this.set_paddingTop(this.set_paddingRight(this.set_paddingLeft(this.padding = v))));
	}
	,set_paddingLeft: function(v) {
		return this.paddingLeft = this.changeValue("paddingLeft",v);
	}
	,set_paddingRight: function(v) {
		return this.paddingRight = this.changeValue("paddingRight",v);
	}
	,set_paddingTop: function(v) {
		return this.paddingTop = this.changeValue("paddingTop",v);
	}
	,set_paddingBottom: function(v) {
		return this.paddingBottom = this.changeValue("paddingBottom",v);
	}
	,set_spacing: function(v) {
		return this.set_spacingY(this.set_spacingX(this.spacing = v));
	}
	,set_spacingX: function(v) {
		return this.spacingX = this.changeValue("spacingX",v);
	}
	,set_spacingY: function(v) {
		return this.spacingY = this.changeValue("spacingY",v);
	}
	,set_cellWidth: function(v) {
		return this.cellWidth = this.changeValue("cellWidth",v);
	}
	,set_cellHeight: function(v) {
		return this.cellHeight = this.changeValue("cellHeight",v);
	}
	,set_cellAlignX: function(v) {
		return this.cellAlignX = this.changeValue("cellAlignX",v);
	}
	,set_cellAlignY: function(v) {
		return this.cellAlignY = this.changeValue("cellAlignY",v);
	}
	,__class__: mui.layout.Layout
	,__properties__: $extend(mui.layout.AbstractLayout.prototype.__properties__,{set_cellAlignY:"set_cellAlignY",set_cellAlignX:"set_cellAlignX",set_cellHeight:"set_cellHeight",set_cellWidth:"set_cellWidth",set_spacingY:"set_spacingY",set_spacingX:"set_spacingX",set_spacing:"set_spacing",set_paddingBottom:"set_paddingBottom",set_paddingTop:"set_paddingTop",set_paddingRight:"set_paddingRight",set_paddingLeft:"set_paddingLeft",set_padding:"set_padding",set_vertical:"set_vertical"})
});
mui.layout.GridLayout = function() {
	mui.layout.Layout.call(this);
	this.wrapIndex = 1;
	this.set_cellWidth(0);
	this.set_cellHeight(0);
	null;
};
$hxClasses["mui.layout.GridLayout"] = mui.layout.GridLayout;
mui.layout.GridLayout.__name__ = ["mui","layout","GridLayout"];
mui.layout.GridLayout.__super__ = mui.layout.Layout;
mui.layout.GridLayout.prototype = $extend(mui.layout.Layout.prototype,{
	wrapIndex: null
	,layoutNext: function(cell,previous) {
		cell.x = this.paddingLeft + (this.cellWidth + this.spacingX) * this.getColumn(cell.index);
		cell.y = this.paddingTop + (this.cellHeight + this.spacingY) * this.getRow(cell.index);
	}
	,getColumn: function(index) {
		if(this.vertical) return Math.floor(index / this.wrapIndex); else return index - this.getRow(index) * this.wrapIndex;
	}
	,getRow: function(index) {
		if(this.vertical) return index - this.getColumn(index) * this.wrapIndex; else return Math.floor(index / this.wrapIndex);
	}
	,getColumns: function() {
		if(!this.vertical) return this.wrapIndex; else return Math.ceil(this.target.numChildren / this.wrapIndex);
	}
	,getRows: function() {
		if(this.vertical) return this.wrapIndex; else return Math.ceil(this.target.numChildren / this.wrapIndex);
	}
	,next: function(index,direction) {
		var column = this.getColumn(index);
		var row = this.getRow(index);
		switch(direction[1]) {
		case 2:
			return this.indexAt(column,row - 1);
		case 3:
			return this.indexAt(column,row + 1);
		case 4:
			return this.indexAt(column - 1,row);
		case 5:
			return this.indexAt(column + 1,row);
		case 1:
			return this.previousIndex(index);
		case 0:
			return this.nextIndex(index);
		}
	}
	,indexAt: function(column,row) {
		var rows = this.getRows();
		var columns = this.getColumns();
		if(row < 0 || row > rows - 1 || column < 0 || column > columns - 1) return -1;
		var index;
		if(this.vertical) index = row + column * rows; else index = column + row * columns;
		if(index > this.target.numChildren - 1) return this.target.numChildren - 1;
		return index;
	}
	,isVisible: function(cell) {
		if(this.vertical) return cell.x + cell.width > this.target.get_scrollX() && cell.x < this.target.get_scrollX() + this.target.get_width(); else return cell.y + cell.height > this.target.get_scrollY() && cell.y < this.target.get_scrollY() + this.target.get_height();
	}
	,isFirst: function(cell) {
		if(this.vertical) return this.getRow(cell.index) == 0 && cell.x - this.spacingX <= this.target.get_scrollX(); else return this.getColumn(cell.index) == 0 && cell.y - this.spacingY <= this.target.get_scrollY();
	}
	,isLast: function(cell) {
		if(this.vertical) {
			var rows = this.getRows();
			return this.getRow(cell.index) == rows - 1 && cell.x + cell.width + this.spacingX >= this.target.get_scrollX() + this.target.get_width();
		} else {
			var columns = this.getColumns();
			return this.getColumn(cell.index) == columns - 1 && cell.y + cell.height + this.spacingY >= this.target.get_scrollY() + this.target.get_height();
		}
	}
	,measureLayout: function() {
		var columns = this.getColumns();
		this.target.set_contentWidth(this.paddingLeft + this.paddingRight + columns * this.cellWidth + (columns - 1) * this.spacingX);
		var rows = this.getRows();
		this.target.set_contentHeight(this.paddingTop + this.paddingBottom + rows * this.cellHeight + (rows - 1) * this.spacingY);
	}
	,measureVirtual: function() {
		this.measureLayout();
	}
	,__class__: mui.layout.GridLayout
});
mui.transition = {};
mui.transition.Transition = function() { };
$hxClasses["mui.transition.Transition"] = mui.transition.Transition;
mui.transition.Transition.__name__ = ["mui","transition","Transition"];
mui.transition.Transition.prototype = {
	completed: null
	,pre: null
	,post: null
	,apply: null
	,copy: null
	,__class__: mui.transition.Transition
};
mui.transition.TAnimation = function(properties,settings) {
	if(properties == null) this.properties = { }; else this.properties = properties;
	this.duration = mui.transition.TimeTween.defaultDuration;
	this.delay = 0;
	this.ease = mui.transition.Ease.none;
	if(settings != null) {
		if(settings.duration != null) this.duration = settings.duration;
		if(settings.delay != null) this.delay = settings.delay;
		if(settings.ease != null) this.ease = settings.ease;
	}
	this.completed = new msignal.Signal0();
	this.active = [];
};
$hxClasses["mui.transition.TAnimation"] = mui.transition.TAnimation;
mui.transition.TAnimation.__name__ = ["mui","transition","TAnimation"];
mui.transition.TAnimation.__interfaces__ = [mui.transition.Transition];
mui.transition.TAnimation.parallel = function() {
	return mui.transition.Composite.parallel();
};
mui.transition.TAnimation.sequential = function() {
	return mui.transition.Composite.sequential();
};
mui.transition.TAnimation.create = function(properties,settings) {
	return new mui.transition.TAnimation(properties,settings);
};
mui.transition.TAnimation.prototype = {
	duration: null
	,delay: null
	,ease: null
	,pre: null
	,set_pre: function(value) {
		if(this.pre != null) {
			var outer = this.pre;
			this.pre = function(view) {
				outer(view);
				value(view);
			};
		} else this.pre = value;
		return this.pre;
	}
	,post: null
	,set_post: function(value) {
		if(this.post != null) {
			var outer = this.post;
			this.post = function(view) {
				outer(view);
				value(view);
			};
		} else this.post = value;
		return this.post;
	}
	,properties: null
	,completed: null
	,active: null
	,apply: function(view) {
		this.cancel(view);
		if(this.pre != null) this.pre(view);
		this.startAnimation(view);
		return this;
	}
	,startAnimation: function(view) {
		var settings = { duration : this.duration, delay : this.delay, easing : this.ease, onCancelled : (function(f,a1) {
			return function() {
				return f(a1);
			};
		})($bind(this,this.animationCancelled),view), onComplete : $bind(this,this.animationComplete), onCompleteParams : view};
		this.active.push(new mui.transition.TimeTween(view,this.properties,settings));
	}
	,animationCancelled: function(view) {
		this.removeTween(view);
	}
	,animationComplete: function(view) {
		this.removeTween(view);
		if(this.post != null) this.post(view);
		if(this.active.length == 0) this.completed.dispatch();
	}
	,isActive: function(view) {
		var _g = 0;
		var _g1 = this.active;
		while(_g < _g1.length) {
			var tween = _g1[_g];
			++_g;
			if(tween.target == view) return true;
		}
		return false;
	}
	,cancel: function(view) {
		var tween = this.removeTween(view);
		if(tween != null) tween.cancel();
	}
	,removeTween: function(view) {
		var i = this.active.length;
		while(i-- > 0) if(this.active[i].target == view) return this.active.splice(i,1)[0];
		return null;
	}
	,copy: function() {
		var copy = this.createCopy();
		copy.duration = this.duration;
		copy.delay = this.delay;
		copy.ease = this.ease;
		return copy;
	}
	,createCopy: function() {
		return new mui.transition.TAnimation(mcore.util.Dynamics.copy(this.properties));
	}
	,__class__: mui.transition.TAnimation
	,__properties__: {set_post:"set_post",set_pre:"set_pre"}
};
mui.transition.Composite = function(isParallel) {
	if(isParallel == null) isParallel = true;
	this.isParallel = isParallel;
	this.completed = new msignal.Signal0();
	this.transitions = [];
};
$hxClasses["mui.transition.Composite"] = mui.transition.Composite;
mui.transition.Composite.__name__ = ["mui","transition","Composite"];
mui.transition.Composite.__interfaces__ = [mui.transition.Transition];
mui.transition.Composite.parallel = function() {
	return new mui.transition.Composite(true);
};
mui.transition.Composite.sequential = function() {
	return new mui.transition.Composite(false);
};
mui.transition.Composite.prototype = {
	isParallel: null
	,completed: null
	,pre: null
	,set_pre: function(value) {
		if(this.pre != null) {
			var outer = this.pre;
			this.pre = function(view) {
				outer(view);
				value(view);
			};
		} else this.pre = value;
		return this.pre;
	}
	,post: null
	,set_post: function(value) {
		if(this.post != null) {
			var outer = this.post;
			this.post = function(view) {
				outer(view);
				value(view);
			};
		} else this.post = value;
		return this.post;
	}
	,transitions: null
	,completedCount: null
	,view: null
	,apply: function(view) {
		this.completedCount = 0;
		this.view = view;
		if(this.pre != null) this.pre(view);
		if(this.isParallel) {
			var _g = 0;
			var _g1 = this.transitions;
			while(_g < _g1.length) {
				var transition = _g1[_g];
				++_g;
				transition.apply(view);
			}
		} else this.transitions[0].apply(view);
		return this;
	}
	,add: function(transition) {
		this.transitions.push(transition);
		transition.completed.add($bind(this,this.onTranstionCompleted));
		return this;
	}
	,onTranstionCompleted: function() {
		if(++this.completedCount >= this.transitions.length) {
			if(this.post != null) this.post(this.view);
			this.view = null;
			this.completed.dispatch();
		} else if(!this.isParallel) this.transitions[this.completedCount].apply(this.view);
	}
	,copy: function() {
		var copy = new mui.transition.Composite(this.isParallel);
		var _g = 0;
		var _g1 = this.transitions;
		while(_g < _g1.length) {
			var transition = _g1[_g];
			++_g;
			copy.add(transition.copy());
		}
		return copy;
	}
	,__class__: mui.transition.Composite
	,__properties__: {set_post:"set_post",set_pre:"set_pre"}
};
mui.transition.Ease = function() { };
$hxClasses["mui.transition.Ease"] = mui.transition.Ease;
mui.transition.Ease.__name__ = ["mui","transition","Ease"];
mui.transition.Ease.none = function(t,b,c,d) {
	return c * t / d + b;
};
mui.transition.Ease.inQuad = function(t,b,c,d) {
	return c * (t /= d) * t + b;
};
mui.transition.Ease.outQuad = function(t,b,c,d) {
	return -c * (t /= d) * (t - 2) + b;
};
mui.transition.Ease.inOutQuad = function(t,b,c,d) {
	if((t /= d / 2) < 1) return c / 2 * t * t + b;
	return -c / 2 * (--t * (t - 2) - 1) + b;
};
mui.transition.Ease.inBounce = function(t,b,c,d) {
	return c - mui.transition.Ease.outBounce(d - t,0,c,d) + b;
};
mui.transition.Ease.outBounce = function(t,b,c,d) {
	if((t /= d) < 0.363636363636363646) return c * (7.5625 * t * t) + b; else if(t < 0.727272727272727293) return c * (7.5625 * (t -= 0.545454545454545414) * t + .75) + b; else if(t < 0.909090909090909061) return c * (7.5625 * (t -= 0.818181818181818232) * t + .9375) + b; else return c * (7.5625 * (t -= 0.954545454545454586) * t + .984375) + b;
};
mui.transition.Ease.inOutBounce = function(t,b,c,d) {
	if(t < d / 2) return mui.transition.Ease.inBounce(t * 2,0,c,d) * .5 + b;
	return mui.transition.Ease.outBounce(t * 2 - d,0,c,d) * .5 + c * .5 + b;
};
mui.transition.Ease.inCubic = function(t,b,c,d) {
	return c * (t /= d) * t * t + b;
};
mui.transition.Ease.outCubic = function(t,b,c,d) {
	return c * ((t = t / d - 1) * t * t + 1) + b;
};
mui.transition.Ease.inOutCubic = function(t,b,c,d) {
	if((t /= d / 2) < 1) return c / 2 * t * t * t + b;
	return c / 2 * ((t -= 2) * t * t + 2) + b;
};
mui.transition.Slide = function(x,y,settings) {
	mui.transition.TAnimation.call(this,{ x : x, y : y},settings);
};
$hxClasses["mui.transition.Slide"] = mui.transition.Slide;
mui.transition.Slide.__name__ = ["mui","transition","Slide"];
mui.transition.Slide.to = function(x,y,settings) {
	return new mui.transition.Slide(x,y,settings);
};
mui.transition.Slide.x = function(x,settings) {
	return new mui.transition.Slide(x,null,settings);
};
mui.transition.Slide.y = function(y,settings) {
	return new mui.transition.Slide(null,y,settings);
};
mui.transition.Slide.on = function(direction,settings) {
	var slide = new mui.transition.Slide(null,null,settings);
	slide.set_pre(function(view) {
		var parent = view.parent;
		if(view.centerX != null) {
			if(parent != null) slide.set_targetX(Math.round((parent.get_width() - view.get_width()) * view.centerX));
		} else if(view.left != null) slide.set_targetX(view.left); else if(view.right != null && parent != null) slide.set_targetX(parent.get_width() - (view.get_width() + view.right)); else slide.set_targetX(view.x);
		if(view.centerY != null) {
			if(parent != null) slide.set_targetY(Math.round((parent.get_height() - view.get_height()) * view.centerY));
		} else if(view.top != null) slide.set_targetY(view.top); else if(view.bottom != null && parent != null) slide.set_targetY(parent.get_height() - (view.get_height() + view.bottom)); else slide.set_targetY(view.y);
		switch(direction[1]) {
		case 4:case 1:
			view.set_x(parent != null?parent.get_width():view.get_width());
			view.set_y(slide.get_targetY());
			break;
		case 5:case 0:
			view.set_x(-view.get_width());
			view.set_y(slide.get_targetY());
			break;
		case 2:
			view.set_x(slide.get_targetX());
			view.set_y(parent != null?parent.get_height():view.get_height());
			break;
		case 3:
			view.set_x(slide.get_targetX());
			view.set_y(-view.get_height());
			break;
		}
	});
	return slide;
};
mui.transition.Slide.off = function(direction,settings) {
	var slide = new mui.transition.Slide(null,null,settings);
	slide.set_pre(function(view) {
		var parent = view.parent;
		switch(direction[1]) {
		case 4:case 0:
			slide.set_targetX(-view.get_width());
			slide.set_targetY(view.y);
			break;
		case 5:case 1:
			slide.set_targetX(parent != null?parent.get_width():view.get_width());
			slide.set_targetY(view.y);
			break;
		case 2:
			slide.set_targetX(view.x);
			slide.set_targetY(-view.get_height());
			break;
		case 3:
			slide.set_targetX(view.x);
			slide.set_targetY(parent != null?parent.get_height():view.get_height());
			break;
		}
	});
	return slide;
};
mui.transition.Slide.__super__ = mui.transition.TAnimation;
mui.transition.Slide.prototype = $extend(mui.transition.TAnimation.prototype,{
	get_targetX: function() {
		return this.properties.x;
	}
	,set_targetX: function(x) {
		return this.properties.x = x;
	}
	,get_targetY: function() {
		return this.properties.y;
	}
	,set_targetY: function(y) {
		return this.properties.y = y;
	}
	,from: function(x,y) {
		if(this.pre != null) {
			if(mconsole.Console.hasConsole) mconsole.Console.callConsole("warn",["Overwriting an existing pre Slide function"]);
			mconsole.Console.print(mconsole.LogLevel.warn,["Overwriting an existing pre Slide function"],{ fileName : "Slide.hx", lineNumber : 129, className : "mui.transition.Slide", methodName : "from"});
		}
		this.set_pre(function(view) {
			if(x != null) view.set_x(x);
			if(y != null) view.set_y(y);
		});
		return this;
	}
	,position: function(x,y) {
		this.set_targetX(x);
		this.set_targetY(y);
		return this;
	}
	,createCopy: function() {
		return mui.transition.Slide.to(this.properties.x,this.properties.y);
	}
	,__class__: mui.transition.Slide
	,__properties__: $extend(mui.transition.TAnimation.prototype.__properties__,{set_targetY:"set_targetY",get_targetY:"get_targetY",set_targetX:"set_targetX",get_targetX:"get_targetX"})
});
mui.transition.TimeTween = function(target,properties,settings) {
	var sharedTargets = [];
	var _g = 0;
	var _g1 = mui.transition.TimeTween.tweens;
	while(_g < _g1.length) {
		var tween = _g1[_g];
		++_g;
		if(tween.target == target) sharedTargets.push(tween);
	}
	mui.transition.TimeTween.addTween(this);
	this.duration = mui.transition.TimeTween.defaultDuration;
	this.target = target;
	this.properties = properties;
	this.start = { };
	this.change = { };
	var _g2 = 0;
	var _g11 = Reflect.fields(properties);
	while(_g2 < _g11.length) {
		var property = _g11[_g2];
		++_g2;
		var i = sharedTargets.length;
		while(i-- > 0) {
			var tween1 = sharedTargets[i];
			if(Object.prototype.hasOwnProperty.call(tween1.properties,property)) {
				tween1.cancel();
				sharedTargets.splice(i,1);
			}
		}
		Reflect.setField(this.start,property,Std.parseFloat(Reflect.field(target,property)));
		Reflect.setField(this.change,property,Reflect.field(properties,property) - Reflect.field(target,property));
	}
	if(settings != null) {
		var _g3 = 0;
		var _g12 = Reflect.fields(settings);
		while(_g3 < _g12.length) {
			var property1 = _g12[_g3];
			++_g3;
			Reflect.setField(this,property1,Reflect.field(settings,property1));
		}
	}
	if(this.easing == null) this.easing = mui.transition.TimeTween.easeNone;
	if(this.frames != null) this.duration = Math.round(this.frames / mui.transition.TimeTween.fps * 1000);
	if(this.frame != null) this.delay = Math.round(-this.frame / mui.transition.TimeTween.fps * 1000);
	if(!(this.delay > 0)) this.delay = 0;
	this.startTime = new Date().getTime();
};
$hxClasses["mui.transition.TimeTween"] = mui.transition.TimeTween;
mui.transition.TimeTween.__name__ = ["mui","transition","TimeTween"];
mui.transition.TimeTween.easeNone = function(t,b,c,d) {
	return mui.transition.Ease.none(t,b,c,d);
};
mui.transition.TimeTween.easeInQuad = function(t,b,c,d) {
	return mui.transition.Ease.inQuad(t,b,c,d);
};
mui.transition.TimeTween.easeOutQuad = function(t,b,c,d) {
	return mui.transition.Ease.outQuad(t,b,c,d);
};
mui.transition.TimeTween.easeInOutQuad = function(t,b,c,d) {
	return mui.transition.Ease.inOutQuad(t,b,c,d);
};
mui.transition.TimeTween.easeInBounce = function(t,b,c,d) {
	return mui.transition.Ease.inBounce(t,b,c,d);
};
mui.transition.TimeTween.easeOutBounce = function(t,b,c,d) {
	return mui.transition.Ease.outBounce(t,b,c,d);
};
mui.transition.TimeTween.easeInOutBounce = function(t,b,c,d) {
	return mui.transition.Ease.inOutBounce(t,b,c,d);
};
mui.transition.TimeTween.easeInCubic = function(t,b,c,d) {
	return mui.transition.Ease.inCubic(t,b,c,d);
};
mui.transition.TimeTween.easeOutCubic = function(t,b,c,d) {
	return mui.transition.Ease.outCubic(t,b,c,d);
};
mui.transition.TimeTween.easeInOutCubic = function(t,b,c,d) {
	return mui.transition.Ease.inOutCubic(t,b,c,d);
};
mui.transition.TimeTween.getActiveTweens = function() {
	return mui.transition.TimeTween.tweens;
};
mui.transition.TimeTween.updateActiveTweens = function() {
	mui.transition.TimeTween.frameTime = haxe.Timer.stamp();
	var _g = 0;
	var _g1 = mui.transition.TimeTween.tweens;
	while(_g < _g1.length) {
		var tween = _g1[_g];
		++_g;
		tween.update();
	}
};
mui.transition.TimeTween.addTween = function(tween) {
	if(mui.transition.TimeTween.tweens.length == 0) mui.transition.TimeTween.renderFrame.add(mui.transition.TimeTween.updateActiveTweens);
	mui.transition.TimeTween.tweens.push(tween);
};
mui.transition.TimeTween.removeTween = function(tween) {
	HxOverrides.remove(mui.transition.TimeTween.tweens,tween);
	if(mui.transition.TimeTween.tweens.length == 0) mui.transition.TimeTween.renderFrame.remove(mui.transition.TimeTween.updateActiveTweens);
};
mui.transition.TimeTween.timeStamp = function() {
	return new Date().getTime();
};
mui.transition.TimeTween.prototype = {
	target: null
	,start: null
	,change: null
	,properties: null
	,frame: null
	,frames: null
	,easing: null
	,duration: null
	,delay: null
	,startTime: null
	,elapsedTime: null
	,onUpdate: null
	,onComplete: null
	,onCompleteParams: null
	,onCancelled: null
	,cancel: function() {
		this.stop();
		if(this.onCancelled != null) this.onCancelled();
	}
	,stop: function() {
		mui.transition.TimeTween.removeTween(this);
	}
	,update: function() {
		this.elapsedTime = new Date().getTime() - (this.startTime + this.delay);
		if(this.elapsedTime < 0) return;
		if(this.elapsedTime < this.duration) {
			var position = this.easing(this.elapsedTime,0,1,this.duration);
			var _g = 0;
			var _g1 = Reflect.fields(this.start);
			while(_g < _g1.length) {
				var property = _g1[_g];
				++_g;
				var value = Reflect.field(this.start,property) + Reflect.field(this.change,property) * position;
				Reflect.setProperty(this.target,property,value);
			}
			if(this.onUpdate != null) this.onUpdate();
		} else {
			var position1 = this.easing(this.duration,0,1,this.duration);
			var _g2 = 0;
			var _g11 = Reflect.fields(this.start);
			while(_g2 < _g11.length) {
				var property1 = _g11[_g2];
				++_g2;
				var value1 = Reflect.field(this.start,property1) + Reflect.field(this.change,property1) * position1;
				Reflect.setProperty(this.target,property1,value1);
			}
			this.stop();
			if(this.onComplete != null) {
				if(this.onCompleteParams != null) this.onComplete(this.onCompleteParams); else this.onComplete();
			}
		}
	}
	,__class__: mui.transition.TimeTween
};
mui.util.Assert = function() { };
$hxClasses["mui.util.Assert"] = mui.util.Assert;
mui.util.Assert.__name__ = ["mui","util","Assert"];
mui.util.Assert.that = function(expr,message) {
	if(!expr) throw "Assertion failed: " + message;
};
mui.util.Dispatcher = function() {
	this.listeners = [];
	this.listenersNeedCloning = false;
};
$hxClasses["mui.util.Dispatcher"] = mui.util.Dispatcher;
mui.util.Dispatcher.__name__ = ["mui","util","Dispatcher"];
mui.util.Dispatcher.prototype = {
	listeners: null
	,listenersNeedCloning: null
	,add: function(listener,type) {
		this.registerListener(listener,false,type);
	}
	,addOnce: function(listener,type) {
		this.registerListener(listener,true,type);
	}
	,remove: function(listener) {
		var index = -1;
		var _g1 = 0;
		var _g = this.listeners.length;
		while(_g1 < _g) {
			var i = _g1++;
			var info = this.listeners[i];
			if(Reflect.compareMethods(info.listener,listener)) {
				index = i;
				break;
			}
		}
		if(index == -1) return;
		if(this.listenersNeedCloning) {
			this.listeners = this.listeners.slice();
			this.listenersNeedCloning = false;
		}
		this.listeners.splice(index,1);
	}
	,removeAll: function() {
		this.listeners = [];
	}
	,dispatch: function(message,target) {
		if(this.listeners.length == 0) return false;
		this.listenersNeedCloning = true;
		var list = this.listeners;
		var handled = false;
		var _g1 = 0;
		var _g = list.length;
		while(_g1 < _g) {
			var i = _g1++;
			var info = list[i];
			var result = false;
			if(message != null && info.type != null) {
				if(js.Boot.__instanceof(message,info.type) || message == info.type) if(target != null) result = info.listener(message,target); else result = info.listener(message);
			} else if(target != null) result = info.listener(message,target); else if(message != null) result = info.listener(message); else result = info.listener();
			if(result == true) handled = true;
			if(info.once) this.remove(info.listener);
		}
		this.listenersNeedCloning = false;
		return handled;
	}
	,has: function(listener) {
		var _g = 0;
		var _g1 = this.listeners;
		while(_g < _g1.length) {
			var info = _g1[_g];
			++_g;
			if(Reflect.compareMethods(info.listener,listener)) return true;
		}
		return false;
	}
	,hasType: function(message) {
		var _g = 0;
		var _g1 = this.listeners;
		while(_g < _g1.length) {
			var info = _g1[_g];
			++_g;
			if(js.Boot.__instanceof(message,info.type) || message == info.type) return true;
		}
		return false;
	}
	,registerListener: function(listener,once,type) {
		if(this.listeners.length == 0) {
			this.listeners.push({ listener : listener, once : once, type : type});
			return;
		}
		var info = this.getListener(listener);
		if(info != null) {
			if(info.once && !once) throw "You cannot addOnce() then add() the same listener without removing the relationship first."; else if(!info.once && once) throw "You cannot add() then addOnce() the same listener without removing the relationship first.";
			return;
		}
		if(this.listenersNeedCloning) {
			this.listeners = this.listeners.slice();
			this.listenersNeedCloning = false;
		}
		this.listeners.push({ listener : listener, once : once, type : type});
	}
	,getListener: function(listener) {
		var _g = 0;
		var _g1 = this.listeners;
		while(_g < _g1.length) {
			var info = _g1[_g];
			++_g;
			if(Reflect.compareMethods(info.listener,listener)) return info;
		}
		return null;
	}
	,__class__: mui.util.Dispatcher
};
mui.validator = {};
mui.validator.Validator = function() { };
$hxClasses["mui.validator.Validator"] = mui.validator.Validator;
mui.validator.Validator.__name__ = ["mui","validator","Validator"];
mui.validator.Validator.prototype = {
	validate: null
	,__class__: mui.validator.Validator
};
mui.validator.MatchValidator = function(form,path,message) {
	this.form = form;
	this.path = path;
	this.set_message(message);
};
$hxClasses["mui.validator.MatchValidator"] = mui.validator.MatchValidator;
mui.validator.MatchValidator.__name__ = ["mui","validator","MatchValidator"];
mui.validator.MatchValidator.__interfaces__ = [mui.validator.Validator];
mui.validator.MatchValidator.prototype = {
	form: null
	,path: null
	,message: null
	,get_message: function() {
		return this.message;
	}
	,set_message: function(value) {
		return this.message = value;
	}
	,validate: function(data) {
		var matchData = this.form.getInputData(this.path);
		return { isError : data != matchData, message : this.get_message()};
	}
	,__class__: mui.validator.MatchValidator
	,__properties__: {set_message:"set_message",get_message:"get_message"}
};
var yaml = {};
yaml.ParserOptions = function(schema) {
	if(schema == null) this.schema = new yaml.schema.DefaultSchema(); else this.schema = schema;
	this.strict = false;
	this.resolve = true;
	this.validation = true;
	this.maps = true;
};
$hxClasses["yaml.ParserOptions"] = yaml.ParserOptions;
yaml.ParserOptions.__name__ = ["yaml","ParserOptions"];
yaml.ParserOptions.prototype = {
	schema: null
	,resolve: null
	,validation: null
	,strict: null
	,maps: null
	,useMaps: function() {
		this.maps = true;
		return this;
	}
	,useObjects: function() {
		this.maps = false;
		return this;
	}
	,setSchema: function(schema) {
		this.schema = schema;
		return this;
	}
	,strictMode: function(value) {
		if(value == null) value = true;
		this.strict = value;
		return this;
	}
	,validate: function(value) {
		if(value == null) value = true;
		this.validation = value;
		return this;
	}
	,__class__: yaml.ParserOptions
};
yaml.Parser = function() {
};
$hxClasses["yaml.Parser"] = yaml.Parser;
yaml.Parser.__name__ = ["yaml","Parser"];
yaml.Parser.options = function() {
	return new yaml.ParserOptions();
};
yaml.Parser.createUtf8Char = function(hex) {
	var utf8 = new haxe.Utf8(1);
	utf8.__b += String.fromCharCode(hex);
	return utf8.__b;
};
yaml.Parser.prototype = {
	schema: null
	,resolve: null
	,validate: null
	,strict: null
	,usingMaps: null
	,directiveHandlers: null
	,implicitTypes: null
	,typeMap: null
	,length: null
	,position: null
	,line: null
	,lineStart: null
	,lineIndent: null
	,character: null
	,version: null
	,checkLineBreaks: null
	,tagMap: null
	,anchorMap: null
	,tag: null
	,anchor: null
	,kind: null
	,result: null
	,input: null
	,output: null
	,safeParseAll: function(input,output,options) {
		options.schema = new yaml.schema.SafeSchema();
		this.parseAll(input,output,options);
	}
	,safeParse: function(input,options) {
		options.schema = new yaml.schema.SafeSchema();
		return this.parse(input,options);
	}
	,parse: function(input,options) {
		var result = null;
		var received = false;
		var responder = function(data) {
			if(!received) {
				result = data;
				received = true;
			} else throw new yaml.YamlException("expected a single document in the stream, but found more",null,{ fileName : "Parser.hx", lineNumber : 155, className : "yaml.Parser", methodName : "parse"});
		};
		this.parseAll(input,responder,options);
		return result;
	}
	,parseAll: function(input,output,options) {
		var _g = this;
		this.input = input;
		this.output = output;
		this.schema = options.schema;
		this.resolve = options.resolve;
		this.validate = options.validation;
		this.strict = options.strict;
		this.usingMaps = options.maps;
		this.directiveHandlers = new haxe.ds.StringMap();
		this.implicitTypes = this.schema.compiledImplicit;
		this.typeMap = this.schema.compiledTypeMap;
		this.length = this.input.length;
		this.position = 0;
		this.line = 0;
		this.lineStart = 0;
		this.lineIndent = 0;
		this.character = HxOverrides.cca(this.input,this.position);
		this.directiveHandlers.set("YAML",function(name,args) {
			if(null != _g.version) _g.throwError("duplication of %YAML directive",{ fileName : "Parser.hx", lineNumber : 199, className : "yaml.Parser", methodName : "parseAll"});
			if(1 != args.length) _g.throwError("YAML directive accepts exactly one argument",{ fileName : "Parser.hx", lineNumber : 202, className : "yaml.Parser", methodName : "parseAll"});
			var regex = new EReg("^([0-9]+)\\.([0-9]+)$","u");
			if(!regex.match(args[0])) _g.throwError("ill-formed argument of the YAML directive",{ fileName : "Parser.hx", lineNumber : 207, className : "yaml.Parser", methodName : "parseAll"});
			var major = yaml.util.Ints.parseInt(regex.matched(1),10);
			var minor = yaml.util.Ints.parseInt(regex.matched(2),10);
			if(1 != major) _g.throwError("unacceptable YAML version of the document",{ fileName : "Parser.hx", lineNumber : 213, className : "yaml.Parser", methodName : "parseAll"});
			_g.version = args[0];
			_g.checkLineBreaks = minor < 2;
			if(1 != minor && 2 != minor) _g.throwWarning("unsupported YAML version of the document",{ fileName : "Parser.hx", lineNumber : 219, className : "yaml.Parser", methodName : "parseAll"});
		});
		this.directiveHandlers.set("TAG",function(name1,args1) {
			var handle;
			var prefix;
			if(2 != args1.length) _g.throwError("TAG directive accepts exactly two arguments",{ fileName : "Parser.hx", lineNumber : 233, className : "yaml.Parser", methodName : "parseAll"});
			handle = args1[0];
			prefix = args1[1];
			if(!yaml.Parser.PATTERN_TAG_HANDLE.match(handle)) _g.throwError("ill-formed tag handle (first argument) of the TAG directive",{ fileName : "Parser.hx", lineNumber : 239, className : "yaml.Parser", methodName : "parseAll"});
			if(_g.tagMap.exists(handle)) _g.throwError("there is a previously declared suffix for \"" + handle + "\" tag handle",{ fileName : "Parser.hx", lineNumber : 242, className : "yaml.Parser", methodName : "parseAll"});
			if(!yaml.Parser.PATTERN_TAG_URI.match(prefix)) _g.throwError("ill-formed tag prefix (second argument) of the TAG directive",{ fileName : "Parser.hx", lineNumber : 245, className : "yaml.Parser", methodName : "parseAll"});
			_g.tagMap.set(handle,prefix);
		});
		if(this.validate && yaml.Parser.PATTERN_NON_PRINTABLE.match(this.input)) this.throwError("the stream contains non-printable characters",{ fileName : "Parser.hx", lineNumber : 252, className : "yaml.Parser", methodName : "parseAll"});
		while(32 == this.character) {
			this.lineIndent += 1;
			this.character = haxe.Utf8.charCodeAt(input,++this.position);
		}
		while(this.position < this.length) this.readDocument();
	}
	,generateError: function(message,info) {
		return new yaml.YamlException(message,info,{ fileName : "Parser.hx", lineNumber : 269, className : "yaml.Parser", methodName : "generateError"});
	}
	,throwError: function(message,info) {
		throw this.generateError(message,info);
	}
	,throwWarning: function(message,info) {
		var error = this.generateError(message,info);
		if(this.strict) throw error; else haxe.Log.trace("Warning : " + error.toString(),{ fileName : "Parser.hx", lineNumber : 284, className : "yaml.Parser", methodName : "throwWarning"});
	}
	,captureSegment: function(start,end,checkJson) {
		var _result;
		if(start < end) {
			_result = yaml.util.Utf8.substring(this.input,start,end);
			if(checkJson && this.validate) {
				var _g1 = 0;
				var _g = _result.length;
				while(_g1 < _g) {
					var pos = _g1++;
					var $char = HxOverrides.cca(_result,pos);
					if(!(9 == $char || 32 <= $char && $char <= 1114111)) this.throwError("expected valid JSON character",{ fileName : "Parser.hx", lineNumber : 302, className : "yaml.Parser", methodName : "captureSegment"});
				}
			}
			this.result += _result;
		}
	}
	,mergeObjectMappings: function(destination,source) {
		if(Type["typeof"](source) != ValueType.TObject) this.throwError("cannot merge mappings; the provided source object is unacceptable",{ fileName : "Parser.hx", lineNumber : 314, className : "yaml.Parser", methodName : "mergeObjectMappings"});
		var _g = 0;
		var _g1 = Reflect.fields(source);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			if(!Object.prototype.hasOwnProperty.call(destination,key)) Reflect.setField(destination,key,Reflect.field(source,key));
		}
	}
	,mergeMappings: function(destination,source) {
		if(!js.Boot.__instanceof(source,yaml.util.TObjectMap)) this.throwError("cannot merge mappings; the provided source object is unacceptable",{ fileName : "Parser.hx", lineNumber : 326, className : "yaml.Parser", methodName : "mergeMappings"});
		var $it0 = source.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			if(!destination.exists(key)) destination.set(key,source.get(key));
		}
	}
	,storeObjectMappingPair: function(_result,keyTag,keyNode,valueNode) {
		if(null == _result) _result = { };
		if("tag:yaml.org,2002:merge" == keyTag) {
			if((valueNode instanceof Array) && valueNode.__enum__ == null) {
				var list = valueNode;
				var _g = 0;
				while(_g < list.length) {
					var member = list[_g];
					++_g;
					this.mergeObjectMappings(_result,member);
				}
			} else this.mergeObjectMappings(_result,valueNode);
		} else Reflect.setField(_result,Std.string(keyNode),valueNode);
		return _result;
	}
	,storeMappingPair: function(_result,keyTag,keyNode,valueNode) {
		if(null == _result) _result = new yaml.util.TObjectMap();
		if("tag:yaml.org,2002:merge" == keyTag) {
			if((valueNode instanceof Array) && valueNode.__enum__ == null) {
				var list = valueNode;
				var _g = 0;
				while(_g < list.length) {
					var member = list[_g];
					++_g;
					this.mergeMappings(_result,member);
				}
			} else this.mergeMappings(_result,valueNode);
		} else _result.set(keyNode,valueNode);
		return _result;
	}
	,readLineBreak: function() {
		if(10 == this.character) this.position += 1; else if(13 == this.character) {
			if(10 == HxOverrides.cca(this.input,this.position + 1)) this.position += 2; else this.position += 1;
		} else this.throwError("a line break is expected",{ fileName : "Parser.hx", lineNumber : 406, className : "yaml.Parser", methodName : "readLineBreak"});
		this.line += 1;
		this.lineStart = this.position;
		if(this.position < this.length) this.character = HxOverrides.cca(this.input,this.position); else this.character = null;
	}
	,skipSeparationSpace: function(allowComments,checkIndent) {
		var lineBreaks = 0;
		while(this.position < this.length) {
			while(32 == this.character || 9 == this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			if(allowComments && 35 == this.character) do this.character = haxe.Utf8.charCodeAt(this.input,++this.position); while(this.position < this.length && 10 != this.character && 13 != this.character);
			if(10 == this.character || 13 == this.character) {
				this.readLineBreak();
				lineBreaks += 1;
				this.lineIndent = 0;
				while(32 == this.character) {
					this.lineIndent += 1;
					this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
				}
				if(this.lineIndent < checkIndent) this.throwWarning("deficient indentation",{ fileName : "Parser.hx", lineNumber : 449, className : "yaml.Parser", methodName : "skipSeparationSpace"});
			} else break;
		}
		return lineBreaks;
	}
	,testDocumentSeparator: function() {
		if(this.position == this.lineStart && (45 == this.character || 46 == this.character) && HxOverrides.cca(this.input,this.position + 1) == this.character && HxOverrides.cca(this.input,this.position + 2) == this.character) {
			var pos = this.position + 3;
			var $char = HxOverrides.cca(this.input,pos);
			if(pos >= this.length || 32 == $char || 9 == $char || 10 == $char || 13 == $char) return true;
		}
		return false;
	}
	,writeFoldedLines: function(count) {
		if(1 == count) this.result += " "; else if(count > 1) this.result += yaml.util.Strings.repeat("\n",count - 1);
	}
	,readPlainScalar: function(nodeIndent,withinFlowCollection) {
		var preceding;
		var following;
		var captureStart;
		var captureEnd;
		var hasPendingContent;
		var _line = 0;
		var _kind = this.kind;
		var _result = this.result;
		if(32 == this.character || 9 == this.character || 10 == this.character || 13 == this.character || 44 == this.character || 91 == this.character || 93 == this.character || 123 == this.character || 125 == this.character || 35 == this.character || 38 == this.character || 42 == this.character || 33 == this.character || 124 == this.character || 62 == this.character || 39 == this.character || 34 == this.character || 37 == this.character || 64 == this.character || 96 == this.character) return false;
		if(63 == this.character || 45 == this.character) {
			following = HxOverrides.cca(this.input,this.position + 1);
			if(32 == following || 9 == following || 10 == following || 13 == following || withinFlowCollection && (44 == following || 91 == following || 93 == following || 123 == following || 125 == following)) return false;
		}
		this.kind = "string";
		this.result = "";
		captureStart = captureEnd = this.position;
		hasPendingContent = false;
		while(this.position < this.length) {
			if(58 == this.character) {
				following = HxOverrides.cca(this.input,this.position + 1);
				if(32 == following || 9 == following || 10 == following || 13 == following || withinFlowCollection && (44 == following || 91 == following || 93 == following || 123 == following || 125 == following)) break;
			} else if(35 == this.character) {
				preceding = HxOverrides.cca(this.input,this.position - 1);
				if(32 == preceding || 9 == preceding || 10 == preceding || 13 == preceding) break;
			} else if(this.position == this.lineStart && this.testDocumentSeparator() || withinFlowCollection && (44 == this.character || 91 == this.character || 93 == this.character || 123 == this.character || 125 == this.character)) break; else if(10 == this.character || 13 == this.character) {
				_line = this.line;
				var _lineStart = this.lineStart;
				var _lineIndent = this.lineIndent;
				this.skipSeparationSpace(false,-1);
				if(this.lineIndent >= nodeIndent) {
					hasPendingContent = true;
					continue;
				} else {
					this.position = captureEnd;
					this.line = _line;
					this.lineStart = _lineStart;
					this.lineIndent = _lineIndent;
					this.character = HxOverrides.cca(this.input,this.position);
					break;
				}
			}
			if(hasPendingContent) {
				this.captureSegment(captureStart,captureEnd,false);
				this.writeFoldedLines(this.line - _line);
				captureStart = captureEnd = this.position;
				hasPendingContent = false;
			}
			if(32 != this.character && 9 != this.character) captureEnd = this.position + 1;
			if(++this.position >= this.length) break;
			this.character = HxOverrides.cca(this.input,this.position);
		}
		this.captureSegment(captureStart,captureEnd,false);
		if(this.result != null) return true; else {
			this.kind = _kind;
			this.result = _result;
			return false;
		}
	}
	,readSingleQuotedScalar: function(nodeIndent) {
		var captureStart;
		var captureEnd;
		if(39 != this.character) return false;
		this.kind = "string";
		this.result = "";
		this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		captureStart = captureEnd = this.position;
		while(this.position < this.length) if(39 == this.character) {
			this.captureSegment(captureStart,this.position,true);
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			if(39 == this.character) {
				captureStart = captureEnd = this.position;
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			} else return true;
		} else if(10 == this.character || 13 == this.character) {
			this.captureSegment(captureStart,captureEnd,true);
			this.writeFoldedLines(this.skipSeparationSpace(false,nodeIndent));
			captureStart = captureEnd = this.position;
			this.character = HxOverrides.cca(this.input,this.position);
		} else if(this.position == this.lineStart && this.testDocumentSeparator()) this.throwError("unexpected end of the document within a single quoted scalar",{ fileName : "Parser.hx", lineNumber : 708, className : "yaml.Parser", methodName : "readSingleQuotedScalar"}); else {
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			captureEnd = this.position;
		}
		this.throwError("unexpected end of the stream within a single quoted scalar",{ fileName : "Parser.hx", lineNumber : 717, className : "yaml.Parser", methodName : "readSingleQuotedScalar"});
		return false;
	}
	,readDoubleQuotedScalar: function(nodeIndent) {
		var captureStart;
		var captureEnd;
		if(34 != this.character) return false;
		this.kind = "string";
		this.result = "";
		this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		captureStart = captureEnd = this.position;
		while(this.position < this.length) if(34 == this.character) {
			this.captureSegment(captureStart,this.position,true);
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			return true;
		} else if(92 == this.character) {
			this.captureSegment(captureStart,this.position,true);
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			if(10 == this.character || 13 == this.character) this.skipSeparationSpace(false,nodeIndent); else if(yaml.Parser.SIMPLE_ESCAPE_SEQUENCES.exists(this.character)) {
				this.result += yaml.Parser.SIMPLE_ESCAPE_SEQUENCES.get(this.character);
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			} else if(yaml.Parser.HEXADECIMAL_ESCAPE_SEQUENCES.exists(this.character)) {
				var hexLength = yaml.Parser.HEXADECIMAL_ESCAPE_SEQUENCES.get(this.character);
				var hexResult = 0;
				var _g = 1;
				while(_g < hexLength) {
					var hexIndex = _g++;
					var hexOffset = (hexLength - hexIndex) * 4;
					this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
					if(48 <= this.character && this.character <= 57) hexResult |= this.character - 48 << hexOffset; else if(65 <= this.character && this.character <= 70) hexResult |= this.character - 65 + 10 << hexOffset; else if(97 <= this.character && this.character <= 102) hexResult |= this.character - 97 + 10 << hexOffset; else this.throwError("expected hexadecimal character",{ fileName : "Parser.hx", lineNumber : 784, className : "yaml.Parser", methodName : "readDoubleQuotedScalar"});
				}
				this.result += String.fromCharCode(hexResult);
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			} else this.throwError("unknown escape sequence",{ fileName : "Parser.hx", lineNumber : 794, className : "yaml.Parser", methodName : "readDoubleQuotedScalar"});
			captureStart = captureEnd = this.position;
		} else if(10 == this.character || 13 == this.character) {
			this.captureSegment(captureStart,captureEnd,true);
			this.writeFoldedLines(this.skipSeparationSpace(false,nodeIndent));
			captureStart = captureEnd = this.position;
			this.character = HxOverrides.cca(this.input,this.position);
		} else if(this.position == this.lineStart && this.testDocumentSeparator()) this.throwError("unexpected end of the document within a double quoted scalar",{ fileName : "Parser.hx", lineNumber : 809, className : "yaml.Parser", methodName : "readDoubleQuotedScalar"}); else {
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			captureEnd = this.position;
		}
		this.throwError("unexpected end of the stream within a double quoted scalar",{ fileName : "Parser.hx", lineNumber : 818, className : "yaml.Parser", methodName : "readDoubleQuotedScalar"});
		return false;
	}
	,composeNode: function(parentIndent,nodeContext,allowToSeek,allowCompact) {
		var allowBlockStyles;
		var allowBlockScalars;
		var allowBlockCollections;
		var atNewLine = false;
		var isIndented = true;
		var hasContent = false;
		this.tag = null;
		this.anchor = null;
		this.kind = null;
		this.result = null;
		allowBlockCollections = 4 == nodeContext || 3 == nodeContext;
		allowBlockStyles = allowBlockScalars = allowBlockCollections;
		if(allowToSeek) {
			if(this.skipSeparationSpace(true,-1) != 0) {
				atNewLine = true;
				if(this.lineIndent == parentIndent) isIndented = false; else if(this.lineIndent > parentIndent) isIndented = true; else return false;
			}
		}
		if(isIndented) while(this.readTagProperty() || this.readAnchorProperty()) if(this.skipSeparationSpace(true,-1) != 0) {
			atNewLine = true;
			if(this.lineIndent > parentIndent) {
				isIndented = true;
				allowBlockCollections = allowBlockStyles;
			} else if(this.lineIndent == parentIndent) {
				isIndented = false;
				allowBlockCollections = allowBlockStyles;
			} else return true;
		} else allowBlockCollections = false;
		if(allowBlockCollections) allowBlockCollections = atNewLine || allowCompact;
		if(isIndented || 4 == nodeContext) {
			var flowIndent;
			var blockIndent;
			if(1 == nodeContext || 2 == nodeContext) flowIndent = parentIndent; else flowIndent = parentIndent + 1;
			blockIndent = this.position - this.lineStart;
			if(isIndented) {
				if(allowBlockCollections && (this.readBlockSequence(blockIndent) || this.readBlockMapping(blockIndent)) || this.readFlowCollection(flowIndent)) hasContent = true; else {
					if(allowBlockScalars && this.readBlockScalar(flowIndent) || this.readSingleQuotedScalar(flowIndent) || this.readDoubleQuotedScalar(flowIndent)) hasContent = true; else if(this.readAlias()) {
						hasContent = true;
						if(null != this.tag || null != this.anchor) this.throwError("alias node should not have any properties",{ fileName : "Parser.hx", lineNumber : 932, className : "yaml.Parser", methodName : "composeNode"});
					} else if(this.readPlainScalar(flowIndent,1 == nodeContext)) {
						hasContent = true;
						if(null == this.tag) this.tag = "?";
					}
					if(null != this.anchor) this.anchorMap.set(this.anchor,this.result);
				}
			} else hasContent = allowBlockCollections && this.readBlockSequence(blockIndent);
		}
		if(null != this.tag && "!" != this.tag) {
			var _result = null;
			if("?" == this.tag) {
				if(this.resolve) {
					var _g1 = 0;
					var _g = this.implicitTypes.length;
					while(_g1 < _g) {
						var typeIndex = _g1++;
						var type = this.implicitTypes[typeIndex];
						var resolvedType = false;
						try {
							_result = type.resolve(this.result,this.usingMaps,false);
							this.tag = type.tag;
							this.result = _result;
							resolvedType = true;
						} catch( e ) {
							if( js.Boot.__instanceof(e,yaml.ResolveTypeException) ) {
							} else throw(e);
						}
						if(resolvedType) break;
					}
				}
			} else if(this.typeMap.exists(this.tag)) {
				var t = this.typeMap.get(this.tag);
				if(null != this.result && t.loader.kind != this.kind) this.throwError("unacceptable node kind for !<" + this.tag + "> tag; it should be \"" + t.loader.kind + "\", not \"" + this.kind + "\"",{ fileName : "Parser.hx", lineNumber : 996, className : "yaml.Parser", methodName : "composeNode"});
				if(!t.loader.skip) try {
					_result = t.resolve(this.result,this.usingMaps,true);
					this.result = _result;
				} catch( e1 ) {
					if( js.Boot.__instanceof(e1,yaml.ResolveTypeException) ) {
						this.throwError("cannot resolve a node with !<" + this.tag + "> explicit tag",{ fileName : "Parser.hx", lineNumber : 1014, className : "yaml.Parser", methodName : "composeNode"});
					} else throw(e1);
				}
			} else this.throwWarning("unknown tag !<" + this.tag + ">",{ fileName : "Parser.hx", lineNumber : 1020, className : "yaml.Parser", methodName : "composeNode"});
		}
		return null != this.tag || null != this.anchor || hasContent;
	}
	,readFlowCollection: function(nodeIndent) {
		var readNext = true;
		var _tag = this.tag;
		var _result;
		var terminator;
		var isPair;
		var isExplicitPair;
		var isMapping;
		var keyNode;
		var keyTag;
		var valueNode;
		var _g = this.character;
		switch(_g) {
		case 91:
			terminator = 93;
			isMapping = false;
			_result = [];
			break;
		case 123:
			terminator = 125;
			isMapping = true;
			if(this.usingMaps) _result = new yaml.util.TObjectMap(); else _result = { };
			break;
		default:
			return false;
		}
		if(null != this.anchor) this.anchorMap.set(this.anchor,_result);
		this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		while(this.position < this.length) {
			this.skipSeparationSpace(true,nodeIndent);
			if(this.character == terminator) {
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
				this.tag = _tag;
				if(isMapping) this.kind = "object"; else this.kind = "array";
				this.result = _result;
				return true;
			} else if(!readNext) this.throwError("missed comma between flow collection entries",{ fileName : "Parser.hx", lineNumber : 1075, className : "yaml.Parser", methodName : "readFlowCollection"});
			keyTag = keyNode = valueNode = null;
			isPair = isExplicitPair = false;
			if(63 == this.character) {
				var following = HxOverrides.cca(this.input,this.position + 1);
				if(32 == following || 9 == following || 10 == following || 13 == following) {
					isPair = isExplicitPair = true;
					this.position += 1;
					this.character = following;
					this.skipSeparationSpace(true,nodeIndent);
				}
			}
			var _line = this.line;
			this.composeNode(nodeIndent,1,false,true);
			keyTag = this.tag;
			keyNode = this.result;
			if((isExplicitPair || this.line == _line) && 58 == this.character) {
				isPair = true;
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
				this.skipSeparationSpace(true,nodeIndent);
				this.composeNode(nodeIndent,1,false,true);
				valueNode = this.result;
			}
			if(isMapping) {
				if(this.usingMaps) this.storeMappingPair(_result,keyTag,keyNode,valueNode); else this.storeObjectMappingPair(_result,keyTag,keyNode,valueNode);
			} else if(isPair) {
				if(this.usingMaps) _result.push(this.storeMappingPair(null,keyTag,keyNode,valueNode)); else _result.push(this.storeObjectMappingPair(null,keyTag,keyNode,valueNode));
			} else _result.push(keyNode);
			this.skipSeparationSpace(true,nodeIndent);
			if(44 == this.character) {
				readNext = true;
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			} else readNext = false;
		}
		this.throwError("unexpected end of the stream within a flow collection",{ fileName : "Parser.hx", lineNumber : 1143, className : "yaml.Parser", methodName : "readFlowCollection"});
		return false;
	}
	,readBlockScalar: function(nodeIndent) {
		var captureStart;
		var folding;
		var chomping = 1;
		var detectedIndent = false;
		var textIndent = nodeIndent;
		var emptyLines = -1;
		var _g = this.character;
		switch(_g) {
		case 124:
			folding = false;
			break;
		case 62:
			folding = true;
			break;
		default:
			return false;
		}
		this.kind = "string";
		this.result = "";
		while(this.position < this.length) {
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			if(43 == this.character || 45 == this.character) {
				if(1 == chomping) if(43 == this.character) chomping = 3; else chomping = 2; else this.throwError("repeat of a chomping mode identifier",{ fileName : "Parser.hx", lineNumber : 1183, className : "yaml.Parser", methodName : "readBlockScalar"});
			} else if(48 <= this.character && this.character <= 57) {
				if(48 == this.character) this.throwError("bad explicit indentation width of a block scalar; it cannot be less than one",{ fileName : "Parser.hx", lineNumber : 1191, className : "yaml.Parser", methodName : "readBlockScalar"}); else if(!detectedIndent) {
					textIndent = nodeIndent + (this.character - 49);
					detectedIndent = true;
				} else this.throwError("repeat of an indentation width identifier",{ fileName : "Parser.hx", lineNumber : 1200, className : "yaml.Parser", methodName : "readBlockScalar"});
			} else break;
		}
		if(32 == this.character || 9 == this.character) {
			do this.character = haxe.Utf8.charCodeAt(this.input,++this.position); while(32 == this.character || 9 == this.character);
			if(35 == this.character) do this.character = haxe.Utf8.charCodeAt(this.input,++this.position); while(this.position < this.length && 10 != this.character && 13 != this.character);
		}
		while(this.position < this.length) {
			this.readLineBreak();
			this.lineIndent = 0;
			while((!detectedIndent || this.lineIndent < textIndent) && 32 == this.character) {
				this.lineIndent += 1;
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			}
			if(!detectedIndent && this.lineIndent > textIndent) textIndent = this.lineIndent;
			if(10 == this.character || 13 == this.character) {
				emptyLines += 1;
				continue;
			}
			if(this.lineIndent < textIndent) {
				if(3 == chomping) this.result += yaml.util.Strings.repeat("\n",emptyLines + 1); else if(1 == chomping) this.result += "\n";
				break;
			}
			detectedIndent = true;
			if(folding) {
				if(32 == this.character || 9 == this.character) {
					this.result += yaml.util.Strings.repeat("\n",emptyLines + 1);
					emptyLines = 1;
				} else if(0 == emptyLines) {
					this.result += " ";
					emptyLines = 0;
				} else {
					this.result += yaml.util.Strings.repeat("\n",emptyLines);
					emptyLines = 0;
				}
			} else {
				this.result += yaml.util.Strings.repeat("\n",emptyLines + 1);
				emptyLines = 0;
			}
			captureStart = this.position;
			do this.character = haxe.Utf8.charCodeAt(this.input,++this.position); while(this.position < this.length && 10 != this.character && 13 != this.character);
			this.captureSegment(captureStart,this.position,false);
		}
		return true;
	}
	,readBlockSequence: function(nodeIndent) {
		var _line;
		var _tag = this.tag;
		var _result = [];
		var following;
		var detected = false;
		if(null != this.anchor) this.anchorMap.set(this.anchor,_result);
		while(this.position < this.length) {
			if(45 != this.character) break;
			following = HxOverrides.cca(this.input,this.position + 1);
			if(32 != following && 9 != following && 10 != following && 13 != following) break;
			detected = true;
			this.position += 1;
			this.character = following;
			if(this.skipSeparationSpace(true,-1) != 0) {
				if(this.lineIndent <= nodeIndent) {
					_result.push(null);
					continue;
				}
			}
			_line = this.line;
			this.composeNode(nodeIndent,3,false,true);
			_result.push(this.result);
			this.skipSeparationSpace(true,-1);
			if((this.line == _line || this.lineIndent > nodeIndent) && this.position < this.length) this.throwError("bad indentation of a sequence entry",{ fileName : "Parser.hx", lineNumber : 1365, className : "yaml.Parser", methodName : "readBlockSequence"}); else if(this.lineIndent < nodeIndent) break;
		}
		if(detected) {
			this.tag = _tag;
			this.kind = "array";
			this.result = _result;
			return true;
		} else return false;
	}
	,readBlockMapping: function(nodeIndent) {
		var following;
		var allowCompact = false;
		var _line;
		var _tag = this.tag;
		var _result;
		if(this.usingMaps) _result = new yaml.util.TObjectMap(); else _result = { };
		var keyTag = null;
		var keyNode = null;
		var valueNode = null;
		var atExplicitKey = false;
		var detected = false;
		if(null != this.anchor) this.anchorMap.set(this.anchor,_result);
		while(this.position < this.length) {
			following = HxOverrides.cca(this.input,this.position + 1);
			_line = this.line;
			if((63 == this.character || 58 == this.character) && (32 == following || 9 == following || 10 == following || 13 == following)) {
				if(63 == this.character) {
					if(atExplicitKey) {
						if(this.usingMaps) this.storeMappingPair(_result,keyTag,keyNode,null); else this.storeObjectMappingPair(_result,keyTag,keyNode,null);
						keyTag = keyNode = valueNode = null;
					}
					detected = true;
					atExplicitKey = true;
					allowCompact = true;
				} else if(atExplicitKey) {
					atExplicitKey = false;
					allowCompact = true;
				} else this.throwError("incomplete explicit mapping pair; a key node is missed",{ fileName : "Parser.hx", lineNumber : 1440, className : "yaml.Parser", methodName : "readBlockMapping"});
				this.position += 1;
				this.character = following;
			} else if(this.composeNode(nodeIndent,2,false,true)) {
				if(this.line == _line) {
					while(32 == this.character || 9 == this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
					if(58 == this.character) {
						this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
						if(32 != this.character && 9 != this.character && 10 != this.character && 13 != this.character) this.throwError("a whitespace character is expected after the key-value separator within a block mapping",{ fileName : "Parser.hx", lineNumber : 1467, className : "yaml.Parser", methodName : "readBlockMapping"});
						if(atExplicitKey) {
							if(this.usingMaps) this.storeMappingPair(_result,keyTag,keyNode,null); else this.storeObjectMappingPair(_result,keyTag,keyNode,null);
							keyTag = keyNode = valueNode = null;
						}
						detected = true;
						atExplicitKey = false;
						allowCompact = false;
						keyTag = this.tag;
						keyNode = this.result;
					} else if(detected) this.throwError("can not read an implicit mapping pair; a colon is missed",{ fileName : "Parser.hx", lineNumber : 1489, className : "yaml.Parser", methodName : "readBlockMapping"}); else {
						this.tag = _tag;
						return true;
					}
				} else if(detected) this.throwError("can not read a block mapping entry; a multiline key may not be an implicit key",{ fileName : "Parser.hx", lineNumber : 1501, className : "yaml.Parser", methodName : "readBlockMapping"}); else {
					this.tag = _tag;
					return true;
				}
			} else break;
			if(this.line == _line || this.lineIndent > nodeIndent) {
				if(this.composeNode(nodeIndent,4,true,allowCompact)) {
					if(atExplicitKey) keyNode = this.result; else valueNode = this.result;
				}
				if(!atExplicitKey) {
					if(this.usingMaps) this.storeMappingPair(_result,keyTag,keyNode,valueNode); else this.storeObjectMappingPair(_result,keyTag,keyNode,valueNode);
					keyTag = keyNode = valueNode = null;
				}
				this.skipSeparationSpace(true,-1);
			}
			if(this.lineIndent > nodeIndent && this.position < this.length) this.throwError("bad indentation of a mapping entry",{ fileName : "Parser.hx", lineNumber : 1541, className : "yaml.Parser", methodName : "readBlockMapping"}); else if(this.lineIndent < nodeIndent) break;
		}
		if(atExplicitKey) {
			if(this.usingMaps) this.storeMappingPair(_result,keyTag,keyNode,null); else this.storeObjectMappingPair(_result,keyTag,keyNode,null);
		}
		if(detected) {
			this.tag = _tag;
			this.kind = "object";
			this.result = _result;
		}
		return detected;
	}
	,readTagProperty: function() {
		var _position;
		var isVerbatim = false;
		var isNamed = false;
		var tagHandle = null;
		var tagName = null;
		if(33 != this.character) return false;
		if(null != this.tag) this.throwError("duplication of a tag property",{ fileName : "Parser.hx", lineNumber : 1579, className : "yaml.Parser", methodName : "readTagProperty"});
		this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		if(60 == this.character) {
			isVerbatim = true;
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		} else if(33 == this.character) {
			isNamed = true;
			tagHandle = "!!";
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		} else tagHandle = "!";
		_position = this.position;
		if(isVerbatim) {
			do this.character = haxe.Utf8.charCodeAt(this.input,++this.position); while(this.position < this.length && 62 != this.character);
			if(this.position < this.length) {
				tagName = yaml.util.Utf8.substring(this.input,_position,this.position);
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			} else this.throwError("unexpected end of the stream within a verbatim tag",{ fileName : "Parser.hx", lineNumber : 1614, className : "yaml.Parser", methodName : "readTagProperty"});
		} else {
			while(this.position < this.length && 32 != this.character && 9 != this.character && 10 != this.character && 13 != this.character) {
				if(33 == this.character) {
					if(!isNamed) {
						tagHandle = yaml.util.Utf8.substring(this.input,_position - 1,this.position + 1);
						if(this.validate && !yaml.Parser.PATTERN_TAG_HANDLE.match(tagHandle)) this.throwError("named tag handle cannot contain such characters",{ fileName : "Parser.hx", lineNumber : 1633, className : "yaml.Parser", methodName : "readTagProperty"});
						isNamed = true;
						_position = this.position + 1;
					} else this.throwError("tag suffix cannot contain exclamation marks",{ fileName : "Parser.hx", lineNumber : 1641, className : "yaml.Parser", methodName : "readTagProperty"});
				}
				this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			}
			tagName = yaml.util.Utf8.substring(this.input,_position,this.position);
			if(this.validate && yaml.Parser.PATTERN_FLOW_INDICATORS.match(tagName)) this.throwError("tag suffix cannot contain flow indicator characters",{ fileName : "Parser.hx", lineNumber : 1652, className : "yaml.Parser", methodName : "readTagProperty"});
		}
		if(this.validate && tagName != null && tagName != "" && !yaml.Parser.PATTERN_TAG_URI.match(tagName)) this.throwError("tag name cannot contain such characters: " + tagName,{ fileName : "Parser.hx", lineNumber : 1658, className : "yaml.Parser", methodName : "readTagProperty"});
		if(isVerbatim) this.tag = tagName; else if(this.tagMap.exists(tagHandle)) this.tag = this.tagMap.get(tagHandle) + tagName; else if("!" == tagHandle) this.tag = "!" + tagName; else if("!!" == tagHandle) this.tag = "tag:yaml.org,2002:" + tagName; else this.throwError("undeclared tag handle \"" + tagHandle + "\"",{ fileName : "Parser.hx", lineNumber : 1679, className : "yaml.Parser", methodName : "readTagProperty"});
		return true;
	}
	,readAnchorProperty: function() {
		var _position;
		if(38 != this.character) return false;
		if(null != this.anchor) this.throwError("duplication of an anchor property",{ fileName : "Parser.hx", lineNumber : 1693, className : "yaml.Parser", methodName : "readAnchorProperty"});
		this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		_position = this.position;
		while(this.position < this.length && 32 != this.character && 9 != this.character && 10 != this.character && 13 != this.character && 44 != this.character && 91 != this.character && 93 != this.character && 123 != this.character && 125 != this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		if(this.position == _position) this.throwError("name of an anchor node must contain at least one character",{ fileName : "Parser.hx", lineNumber : 1713, className : "yaml.Parser", methodName : "readAnchorProperty"});
		this.anchor = yaml.util.Utf8.substring(this.input,_position,this.position);
		return true;
	}
	,readAlias: function() {
		var _position;
		var alias;
		if(42 != this.character) return false;
		this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		_position = this.position;
		while(this.position < this.length && 32 != this.character && 9 != this.character && 10 != this.character && 13 != this.character && 44 != this.character && 91 != this.character && 93 != this.character && 123 != this.character && 125 != this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
		if(this.position == _position) this.throwError("name of an alias node must contain at least one character",{ fileName : "Parser.hx", lineNumber : 1745, className : "yaml.Parser", methodName : "readAlias"});
		alias = yaml.util.Utf8.substring(this.input,_position,this.position);
		if(!this.anchorMap.exists(alias)) this.throwError("unidentified alias \"" + alias + "\"",{ fileName : "Parser.hx", lineNumber : 1750, className : "yaml.Parser", methodName : "readAlias"});
		this.result = this.anchorMap.get(alias);
		this.skipSeparationSpace(true,-1);
		return true;
	}
	,readDocument: function() {
		var documentStart = this.position;
		var _position;
		var directiveName;
		var directiveArgs;
		var hasDirectives = false;
		this.version = null;
		this.checkLineBreaks = false;
		this.tagMap = new haxe.ds.StringMap();
		this.anchorMap = new haxe.ds.StringMap();
		while(this.position < this.length) {
			this.skipSeparationSpace(true,-1);
			if(this.lineIndent > 0 || 37 != this.character) break;
			hasDirectives = true;
			this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			_position = this.position;
			while(this.position < this.length && 32 != this.character && 9 != this.character && 10 != this.character && 13 != this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
			directiveName = yaml.util.Utf8.substring(this.input,_position,this.position);
			directiveArgs = [];
			if(directiveName.length < 1) this.throwError("directive name must not be less than one character in length",{ fileName : "Parser.hx", lineNumber : 1795, className : "yaml.Parser", methodName : "readDocument"});
			while(this.position < this.length) {
				while(32 == this.character || 9 == this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
				if(35 == this.character) {
					do this.character = haxe.Utf8.charCodeAt(this.input,++this.position); while(this.position < this.length && 10 != this.character && 13 != this.character);
					break;
				}
				if(10 == this.character || 13 == this.character) break;
				_position = this.position;
				while(this.position < this.length && 32 != this.character && 9 != this.character && 10 != this.character && 13 != this.character) this.character = haxe.Utf8.charCodeAt(this.input,++this.position);
				directiveArgs.push(yaml.util.Utf8.substring(this.input,_position,this.position));
			}
			if(this.position < this.length) this.readLineBreak();
			if(this.directiveHandlers.exists(directiveName)) (this.directiveHandlers.get(directiveName))(directiveName,directiveArgs); else this.throwWarning("unknown document directive \"" + directiveName + "\"",{ fileName : "Parser.hx", lineNumber : 1839, className : "yaml.Parser", methodName : "readDocument"});
		}
		this.skipSeparationSpace(true,-1);
		if(0 == this.lineIndent && 45 == this.character && 45 == HxOverrides.cca(this.input,this.position + 1) && 45 == HxOverrides.cca(this.input,this.position + 2)) {
			this.position += 3;
			this.character = HxOverrides.cca(this.input,this.position);
			this.skipSeparationSpace(true,-1);
		} else if(hasDirectives) this.throwError("directives end mark is expected",{ fileName : "Parser.hx", lineNumber : 1857, className : "yaml.Parser", methodName : "readDocument"});
		this.composeNode(this.lineIndent - 1,4,false,true);
		this.skipSeparationSpace(true,-1);
		if(this.validate && this.checkLineBreaks && yaml.Parser.PATTERN_NON_ASCII_LINE_BREAKS.match(yaml.util.Utf8.substring(this.input,documentStart,this.position))) this.throwWarning("non-ASCII line breaks are interpreted as content",{ fileName : "Parser.hx", lineNumber : 1865, className : "yaml.Parser", methodName : "readDocument"});
		this.output(this.result);
		if(this.position == this.lineStart && this.testDocumentSeparator()) {
			if(46 == this.character) {
				this.position += 3;
				this.character = HxOverrides.cca(this.input,this.position);
				this.skipSeparationSpace(true,-1);
			}
			return;
		}
		if(this.position < this.length) this.throwError("end of the stream or a document separator is expected",{ fileName : "Parser.hx", lineNumber : 1883, className : "yaml.Parser", methodName : "readDocument"}); else return;
	}
	,__class__: yaml.Parser
};
yaml.RenderOptions = function(schema,styles) {
	if(schema != null) this.schema = schema; else this.schema = new yaml.schema.DefaultSchema();
	if(styles != null) this.styles = styles; else this.styles = new haxe.ds.StringMap();
	this.indent = 2;
	this.flow = -1;
};
$hxClasses["yaml.RenderOptions"] = yaml.RenderOptions;
yaml.RenderOptions.__name__ = ["yaml","RenderOptions"];
yaml.RenderOptions.prototype = {
	schema: null
	,indent: null
	,flow: null
	,styles: null
	,setSchema: function(schema) {
		this.schema = schema;
		return this;
	}
	,setFlowLevel: function(level) {
		this.flow = level;
		return this;
	}
	,setIndent: function(indent) {
		this.indent = indent;
		return this;
	}
	,setStyle: function(name,value) {
		this.styles.set(name,value);
		return this;
	}
	,__class__: yaml.RenderOptions
};
yaml.Renderer = function() {
};
$hxClasses["yaml.Renderer"] = yaml.Renderer;
yaml.Renderer.__name__ = ["yaml","Renderer"];
yaml.Renderer.options = function() {
	return new yaml.RenderOptions();
};
yaml.Renderer.compileStyleMap = function(schema,map) {
	if(null == map) return new haxe.ds.StringMap();
	var result = new haxe.ds.StringMap();
	var $it0 = map.keys();
	while( $it0.hasNext() ) {
		var tag = $it0.next();
		var style = Std.string(map.get(tag));
		if(0 == tag.indexOf("!!")) tag = "tag:yaml.org,2002:" + tag.substring(2);
		var type = schema.compiledTypeMap.get(tag);
		if(type != null && type.dumper != null) {
			if(type.dumper.styleAliases.exists(style)) style = type.dumper.styleAliases.get(style);
		}
		result.set(tag,style);
	}
	return result;
};
yaml.Renderer.encodeHex = function(charCode) {
	var handle;
	var length;
	var str = yaml.util.Ints.toString(charCode,16).toUpperCase();
	if(charCode <= 255) {
		handle = "x";
		length = 2;
	} else if(charCode <= 65535) {
		handle = "u";
		length = 4;
	} else if(charCode <= -1) {
		handle = "U";
		length = 8;
	} else throw new yaml.YamlException("code point within a string may not be greater than 0xFFFFFFFF",null,{ fileName : "Renderer.hx", lineNumber : 586, className : "yaml.Renderer", methodName : "encodeHex"});
	return "\\" + handle + yaml.util.Strings.repeat("0",length - str.length) + str;
};
yaml.Renderer.prototype = {
	schema: null
	,indent: null
	,flowLevel: null
	,styleMap: null
	,implicitTypes: null
	,explicitTypes: null
	,kind: null
	,tag: null
	,result: null
	,safeRender: function(input,options) {
		options.schema = new yaml.schema.SafeSchema();
		return this.render(input,options);
	}
	,render: function(input,options) {
		this.schema = options.schema;
		this.indent = Std["int"](Math.max(1,options.indent));
		this.flowLevel = options.flow;
		this.styleMap = yaml.Renderer.compileStyleMap(this.schema,options.styles);
		this.implicitTypes = this.schema.compiledImplicit;
		this.explicitTypes = this.schema.compiledExplicit;
		this.writeNode(0,input,true,true);
		return Std.string(this.result) + "\n";
	}
	,generateNextLine: function(level) {
		return "\n" + yaml.util.Strings.repeat(" ",this.indent * level);
	}
	,testImplicitResolving: function(object) {
		var _g = 0;
		var _g1 = this.implicitTypes;
		while(_g < _g1.length) {
			var type = _g1[_g];
			++_g;
			try {
				if(!type.loader.skip) {
					type.resolve(object,false);
					return true;
				}
			} catch( e ) {
				if( js.Boot.__instanceof(e,yaml.ResolveTypeException) ) {
				} else throw(e);
			}
		}
		return false;
	}
	,writeScalar: function(object) {
		var isQuoted = false;
		var checkpoint = 0;
		var position = -1;
		this.result = "";
		if(0 == object.length || 32 == HxOverrides.cca(object,0) || 32 == HxOverrides.cca(object,object.length - 1)) isQuoted = true;
		var length = object.length;
		while(++position < length) {
			var character = HxOverrides.cca(object,position);
			if(!isQuoted) {
				if(9 == character || 10 == character || 13 == character || 44 == character || 91 == character || 93 == character || 123 == character || 125 == character || 35 == character || 38 == character || 42 == character || 33 == character || 124 == character || 62 == character || 39 == character || 34 == character || 37 == character || 64 == character || 96 == character || 63 == character || 58 == character || 45 == character) isQuoted = true;
			}
			if(yaml.Renderer.ESCAPE_SEQUENCES.exists(character) || !(32 <= character && character <= 126 || 133 == character || 160 <= character && character <= 55295 || 57344 <= character && character <= 65533 || 65536 <= character && character <= 1114111)) {
				this.result += yaml.util.Utf8.substring(object,checkpoint,position);
				if(yaml.Renderer.ESCAPE_SEQUENCES.exists(character)) this.result += yaml.Renderer.ESCAPE_SEQUENCES.get(character); else this.result += yaml.Renderer.encodeHex(character);
				checkpoint = position + 1;
				isQuoted = true;
			}
		}
		if(checkpoint < position) this.result += yaml.util.Utf8.substring(object,checkpoint,position);
		if(!isQuoted && this.testImplicitResolving(this.result)) isQuoted = true;
		if(isQuoted) this.result = "\"" + Std.string(this.result) + "\"";
	}
	,writeFlowSequence: function(level,object) {
		var _result = "";
		var _tag = this.tag;
		var _g1 = 0;
		var _g = object.length;
		while(_g1 < _g) {
			var index = _g1++;
			if(0 != index) _result += ", ";
			this.writeNode(level,object[index],false,false);
			_result += Std.string(this.result);
		}
		this.tag = _tag;
		this.result = "[" + _result + "]";
	}
	,writeBlockSequence: function(level,object,compact) {
		var _result = "";
		var _tag = this.tag;
		var _g1 = 0;
		var _g = object.length;
		while(_g1 < _g) {
			var index = _g1++;
			if(!compact || 0 != index) _result += this.generateNextLine(level);
			this.writeNode(level + 1,object[index],true,true);
			_result += "- " + Std.string(this.result);
		}
		this.tag = _tag;
		this.result = _result;
	}
	,writeFlowMapping: function(level,object) {
		if(Type["typeof"](object) == ValueType.TObject) this.writeObjectFlowMapping(level,object); else this.writeMapFlowMapping(level,object);
	}
	,writeObjectFlowMapping: function(level,object) {
		var _result = "";
		var _tag = this.tag;
		var index = 0;
		var objectKey;
		var _g = 0;
		var _g1 = Reflect.fields(object);
		while(_g < _g1.length) {
			var objectKey1 = _g1[_g];
			++_g;
			if(0 != index++) _result += ", ";
			var objectValue = Reflect.field(object,objectKey1);
			this.writeNode(level,objectKey1,false,false);
			if(this.result.length > 1024) _result += "? ";
			_result += Std.string(this.result) + ": ";
			this.writeNode(level,objectValue,false,false);
			_result += Std.string(this.result);
		}
		this.tag = _tag;
		this.result = "{" + _result + "}";
	}
	,writeMapFlowMapping: function(level,object) {
		var _result = "";
		var _tag = this.tag;
		var index = 0;
		var objectKey;
		var keys = object.keys();
		while( keys.hasNext() ) {
			var objectKey1 = keys.next();
			if(0 != index++) _result += ", ";
			var objectValue = object.get(objectKey1);
			this.writeNode(level,objectKey1,false,false);
			if(this.result.length > 1024) _result += "? ";
			_result += Std.string(this.result) + ": ";
			this.writeNode(level,objectValue,false,false);
			_result += Std.string(this.result);
		}
		this.tag = _tag;
		this.result = "{" + _result + "}";
	}
	,writeBlockMapping: function(level,object,compact) {
		if(Type["typeof"](object) == ValueType.TObject) this.writeObjectBlockMapping(level,object,compact); else this.writeMapBlockMapping(level,object,compact);
	}
	,writeObjectBlockMapping: function(level,object,compact) {
		var _result = "";
		var _tag = this.tag;
		var index = 0;
		var _g = 0;
		var _g1 = Reflect.fields(object);
		while(_g < _g1.length) {
			var objectKey = _g1[_g];
			++_g;
			if(!compact || 0 != index++) _result += this.generateNextLine(level);
			var objectValue = Reflect.field(object,objectKey);
			this.writeNode(level + 1,objectKey,true,true);
			var explicitPair = null != this.tag && "?" != this.tag && this.result.length <= 1024;
			if(explicitPair) _result += "? ";
			_result += Std.string(this.result);
			if(explicitPair) _result += this.generateNextLine(level);
			this.writeNode(level + 1,objectValue,true,explicitPair);
			_result += ": " + Std.string(this.result);
		}
		this.tag = _tag;
		this.result = _result;
	}
	,writeMapBlockMapping: function(level,object,compact) {
		var _result = "";
		var _tag = this.tag;
		var index = 0;
		var keys = object.keys();
		while( keys.hasNext() ) {
			var objectKey = keys.next();
			if(!compact || 0 != index++) _result += this.generateNextLine(level);
			var objectValue = object.get(objectKey);
			this.writeNode(level + 1,objectKey,true,true);
			var explicitPair = null != this.tag && "?" != this.tag && this.result.length <= 1024;
			if(explicitPair) _result += "? ";
			_result += Std.string(this.result);
			if(explicitPair) _result += this.generateNextLine(level);
			this.writeNode(level + 1,objectValue,true,explicitPair);
			_result += ": " + Std.string(this.result);
		}
		this.tag = _tag;
		this.result = _result;
	}
	,detectType: function(object,explicit) {
		var _result = null;
		var typeList;
		if(explicit) typeList = this.explicitTypes; else typeList = this.implicitTypes;
		var style;
		this.kind = this.kindOf(object);
		var _g = 0;
		while(_g < typeList.length) {
			var type = typeList[_g];
			++_g;
			if(null != type.dumper && type.dumper.skip != true && (null == type.dumper.kind || this.kind == type.dumper.kind) && (null == type.dumper.instanceOf || js.Boot.__instanceof(object,type.dumper.instanceOf) && (null == type.dumper.predicate || type.dumper.predicate(object)))) {
				if(explicit) this.tag = type.tag; else this.tag = "?";
				if(this.styleMap.exists(type.tag)) style = this.styleMap.get(type.tag); else style = type.dumper.defaultStyle;
				var success = true;
				try {
					_result = type.represent(object,style);
				} catch( e ) {
					if( js.Boot.__instanceof(e,yaml.RepresentTypeException) ) {
						success = false;
					} else throw(e);
				}
				if(success) {
					this.kind = this.kindOf(_result);
					this.result = _result;
				} else if(explicit) throw new yaml.YamlException("cannot represent an object of !<" + type.tag + "> type",null,{ fileName : "Renderer.hx", lineNumber : 444, className : "yaml.Renderer", methodName : "detectType"}); else continue;
				return true;
			}
		}
		return false;
	}
	,writeNode: function(level,object,block,compact) {
		this.tag = null;
		this.result = object;
		if(!this.detectType(object,false)) this.detectType(object,true);
		if(block) block = 0 > this.flowLevel || this.flowLevel > level;
		if(null != this.tag && "?" != this.tag || 2 != this.indent && level > 0) compact = false;
		if("object" == this.kind) {
			var empty;
			if(Type["typeof"](object) == ValueType.TObject) empty = Reflect.fields(object).length == 0; else empty = Lambda.empty(object);
			if(block && !empty) this.writeBlockMapping(level,object,compact); else this.writeFlowMapping(level,object);
		} else if("array" == this.kind) {
			if(block && 0 != this.result.length) this.writeBlockSequence(level,this.result,compact); else this.writeFlowSequence(level,this.result);
		} else if("string" == this.kind) {
			if("?" != this.tag) this.writeScalar(this.result);
		} else throw new yaml.YamlException("unacceptabe kind of an object to dump (" + this.kind + ")",null,{ fileName : "Renderer.hx", lineNumber : 501, className : "yaml.Renderer", methodName : "writeNode"});
		if(null != this.tag && "?" != this.tag) this.result = "!<" + this.tag + "> " + Std.string(this.result);
	}
	,kindOf: function(object) {
		var kind = Type["typeof"](object);
		{
			var _g = Type["typeof"](object);
			switch(_g[1]) {
			case 0:
				return "null";
			case 1:
				return "integer";
			case 2:
				return "float";
			case 3:
				return "boolean";
			case 4:
				if((object instanceof Array) && object.__enum__ == null) return "array"; else return "object";
				break;
			case 5:
				return "function";
			case 6:
				var c = _g[2];
				if(c == String) return "string"; else if(c == Array) return "array"; else if(c == haxe.io.Bytes) return "binary"; else return "object";
				break;
			case 7:
				return "enum";
			case 8:
				return "unknown";
			}
		}
	}
	,__class__: yaml.Renderer
};
yaml.Schema = function(include,explicit,implicit) {
	if(include == null) this.include = []; else this.include = include;
	if(implicit == null) this.implicit = []; else this.implicit = implicit;
	if(explicit == null) this.explicit = []; else this.explicit = explicit;
	var _g = 0;
	var _g1 = this.implicit;
	while(_g < _g1.length) {
		var type = _g1[_g];
		++_g;
		if(null != type.loader && "string" != type.loader.kind) throw new yaml.YamlException("There is a non-scalar type in the implicit list of a schema. Implicit resolving of such types is not supported.",null,{ fileName : "Schema.hx", lineNumber : 28, className : "yaml.Schema", methodName : "new"});
	}
	this.compiledImplicit = yaml.Schema.compileList(this,"implicit",[]);
	this.compiledExplicit = yaml.Schema.compileList(this,"explicit",[]);
	this.compiledTypeMap = yaml.Schema.compileMap([this.compiledImplicit,this.compiledExplicit]);
};
$hxClasses["yaml.Schema"] = yaml.Schema;
yaml.Schema.__name__ = ["yaml","Schema"];
yaml.Schema.create = function(types,schemas) {
	if(schemas == null) schemas = [yaml.Schema.DEFAULT]; else if(schemas.length == 0) schemas.push(yaml.Schema.DEFAULT);
	return new yaml.Schema(schemas,types);
};
yaml.Schema.compileList = function(schema,name,result) {
	var exclude = [];
	var _g = 0;
	var _g1 = schema.include;
	while(_g < _g1.length) {
		var includedSchema = _g1[_g];
		++_g;
		result = yaml.Schema.compileList(includedSchema,name,result);
	}
	var types;
	switch(name) {
	case "implicit":
		types = schema.implicit;
		break;
	case "explicit":
		types = schema.explicit;
		break;
	default:
		throw new yaml.YamlException("unknown type list type: " + name,null,{ fileName : "Schema.hx", lineNumber : 61, className : "yaml.Schema", methodName : "compileList"});
	}
	var _g2 = 0;
	while(_g2 < types.length) {
		var currenYamlType = types[_g2];
		++_g2;
		var _g21 = 0;
		var _g11 = result.length;
		while(_g21 < _g11) {
			var previousIndex = _g21++;
			var previousType = result[previousIndex];
			if(previousType.tag == currenYamlType.tag) exclude.push(previousIndex);
		}
		result.push(currenYamlType);
	}
	var filteredResult = [];
	var _g12 = 0;
	var _g3 = result.length;
	while(_g12 < _g3) {
		var i = _g12++;
		if(!Lambda.has(exclude,i)) filteredResult.push(result[i]);
	}
	return filteredResult;
};
yaml.Schema.compileMap = function(list) {
	var result = new haxe.ds.StringMap();
	var _g = 0;
	while(_g < list.length) {
		var member = list[_g];
		++_g;
		var _g1 = 0;
		while(_g1 < member.length) {
			var type = member[_g1];
			++_g1;
			result.set(type.tag,type);
		}
	}
	return result;
};
yaml.Schema.prototype = {
	compiledImplicit: null
	,compiledExplicit: null
	,compiledTypeMap: null
	,implicit: null
	,explicit: null
	,include: null
	,__class__: yaml.Schema
};
yaml.Yaml = function() {
};
$hxClasses["yaml.Yaml"] = yaml.Yaml;
yaml.Yaml.__name__ = ["yaml","Yaml"];
yaml.Yaml.parse = function(document,options) {
	if(options == null) options = new yaml.ParserOptions();
	return new yaml.Parser().parse(document,options);
};
yaml.Yaml.render = function(data,options) {
	if(options == null) options = new yaml.RenderOptions();
	return new yaml.Renderer().render(data,options);
};
yaml.Yaml.prototype = {
	__class__: yaml.Yaml
};
yaml.YamlException = function(message,cause,info) {
	if(message == null) message = "";
	this.name = Type.getClassName(Type.getClass(this));
	this.message = message;
	this.cause = cause;
	this.info = info;
};
$hxClasses["yaml.YamlException"] = yaml.YamlException;
yaml.YamlException.__name__ = ["yaml","YamlException"];
yaml.YamlException.prototype = {
	name: null
	,get_name: function() {
		return this.name;
	}
	,message: null
	,get_message: function() {
		return this.message;
	}
	,cause: null
	,info: null
	,toString: function() {
		var str = this.get_name() + ": " + this.get_message();
		if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
		return str;
	}
	,__class__: yaml.YamlException
	,__properties__: {get_message:"get_message",get_name:"get_name"}
};
yaml.YamlType = function(tag,loaderOptions,dumperOptions) {
	if(loaderOptions == null && dumperOptions == null) throw new yaml.YamlException("Incomplete YAML type definition. \"loader\" or \"dumper\" setting must be specified.",null,{ fileName : "YamlType.hx", lineNumber : 34, className : "yaml.YamlType", methodName : "new"});
	this.tag = tag;
	this.loader = loaderOptions;
	this.dumper = dumperOptions;
	if(loaderOptions != null && !loaderOptions.skip) this.validateLoaderOptions();
	if(dumperOptions != null && !dumperOptions.skip) this.validateDumperOptions();
};
$hxClasses["yaml.YamlType"] = yaml.YamlType;
yaml.YamlType.__name__ = ["yaml","YamlType"];
yaml.YamlType.prototype = {
	tag: null
	,loader: null
	,dumper: null
	,resolve: function(object,usingMaps,explicit) {
		if(explicit == null) explicit = false;
		if(usingMaps == null) usingMaps = true;
		this.cantResolveType({ fileName : "YamlType.hx", lineNumber : 48, className : "yaml.YamlType", methodName : "resolve"});
		return null;
	}
	,represent: function(object,style) {
		this.cantRepresentType({ fileName : "YamlType.hx", lineNumber : 54, className : "yaml.YamlType", methodName : "represent"});
		return null;
	}
	,cantResolveType: function(info) {
		throw new yaml.ResolveTypeException("",null,info);
		return null;
	}
	,cantRepresentType: function(info) {
		throw new yaml.RepresentTypeException("",null,info);
		return null;
	}
	,validateLoaderOptions: function() {
		if(this.loader.skip != true && "string" != this.loader.kind && "array" != this.loader.kind && "object" != this.loader.kind) throw new yaml.YamlException("Unacceptable \"kind\" setting of a type loader: " + this.loader.kind,null,{ fileName : "YamlType.hx", lineNumber : 74, className : "yaml.YamlType", methodName : "validateLoaderOptions"});
	}
	,validateDumperOptions: function() {
		if(this.dumper.skip != true && "undefined" != this.dumper.kind && "null" != this.dumper.kind && "boolean" != this.dumper.kind && "integer" != this.dumper.kind && "float" != this.dumper.kind && "string" != this.dumper.kind && "array" != this.dumper.kind && "object" != this.dumper.kind && "binary" != this.dumper.kind && "function" != this.dumper.kind) throw new yaml.YamlException("Unacceptable \"kind\" setting of a type dumper: " + this.dumper.kind,null,{ fileName : "YamlType.hx", lineNumber : 92, className : "yaml.YamlType", methodName : "validateDumperOptions"});
	}
	,__class__: yaml.YamlType
};
yaml.ResolveTypeException = function(message,cause,info) {
	if(message == null) message = "";
	yaml.YamlException.call(this,message,cause,info);
};
$hxClasses["yaml.ResolveTypeException"] = yaml.ResolveTypeException;
yaml.ResolveTypeException.__name__ = ["yaml","ResolveTypeException"];
yaml.ResolveTypeException.__super__ = yaml.YamlException;
yaml.ResolveTypeException.prototype = $extend(yaml.YamlException.prototype,{
	__class__: yaml.ResolveTypeException
});
yaml.RepresentTypeException = function(message,cause,info) {
	if(message == null) message = "";
	yaml.YamlException.call(this,message,cause,info);
};
$hxClasses["yaml.RepresentTypeException"] = yaml.RepresentTypeException;
yaml.RepresentTypeException.__name__ = ["yaml","RepresentTypeException"];
yaml.RepresentTypeException.__super__ = yaml.YamlException;
yaml.RepresentTypeException.prototype = $extend(yaml.YamlException.prototype,{
	__class__: yaml.RepresentTypeException
});
yaml.schema = {};
yaml.schema.DefaultSchema = function() {
	yaml.Schema.call(this,[new yaml.schema.SafeSchema()],null);
};
$hxClasses["yaml.schema.DefaultSchema"] = yaml.schema.DefaultSchema;
yaml.schema.DefaultSchema.__name__ = ["yaml","schema","DefaultSchema"];
yaml.schema.DefaultSchema.__super__ = yaml.Schema;
yaml.schema.DefaultSchema.prototype = $extend(yaml.Schema.prototype,{
	__class__: yaml.schema.DefaultSchema
});
yaml.schema.MinimalSchema = function() {
	yaml.Schema.call(this,[],[new yaml.type.YString(),new yaml.type.YSeq(),new yaml.type.YMap()]);
};
$hxClasses["yaml.schema.MinimalSchema"] = yaml.schema.MinimalSchema;
yaml.schema.MinimalSchema.__name__ = ["yaml","schema","MinimalSchema"];
yaml.schema.MinimalSchema.__super__ = yaml.Schema;
yaml.schema.MinimalSchema.prototype = $extend(yaml.Schema.prototype,{
	__class__: yaml.schema.MinimalSchema
});
yaml.schema.SafeSchema = function() {
	yaml.Schema.call(this,[new yaml.schema.MinimalSchema()],[new yaml.type.YBinary(),new yaml.type.YOmap(),new yaml.type.YPairs(),new yaml.type.YSet()],[new yaml.type.YNull(),new yaml.type.YBool(),new yaml.type.YInt(),new yaml.type.YFloat(),new yaml.type.YTimestamp(),new yaml.type.YMerge()]);
};
$hxClasses["yaml.schema.SafeSchema"] = yaml.schema.SafeSchema;
yaml.schema.SafeSchema.__name__ = ["yaml","schema","SafeSchema"];
yaml.schema.SafeSchema.__super__ = yaml.Schema;
yaml.schema.SafeSchema.prototype = $extend(yaml.Schema.prototype,{
	__class__: yaml.schema.SafeSchema
});
yaml.type = {};
yaml.type.YBinary = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:binary",{ kind : "string"},{ kind : "binary", instanceOf : haxe.io.Bytes});
};
$hxClasses["yaml.type.YBinary"] = yaml.type.YBinary;
yaml.type.YBinary.__name__ = ["yaml","type","YBinary"];
yaml.type.YBinary.__super__ = yaml.YamlType;
yaml.type.YBinary.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(usingMaps == null) usingMaps = true;
		var length = object.length;
		var idx = 0;
		var result = [];
		var leftbits = 0;
		var leftdata = 0;
		var _g = 0;
		while(_g < length) {
			var idx1 = _g++;
			var code = HxOverrides.cca(object,idx1);
			var value = yaml.type.YBinary.BASE64_BINTABLE[code & 127];
			if(10 != code && 13 != code) {
				if(-1 == value) return this.cantResolveType({ fileName : "YBinary.hx", lineNumber : 49, className : "yaml.type.YBinary", methodName : "resolve"});
				leftdata = leftdata << 6 | value;
				leftbits += 6;
				if(leftbits >= 8) {
					leftbits -= 8;
					if(61 != code) result.push(leftdata >> leftbits & 255);
					leftdata &= (1 << leftbits) - 1;
				}
			}
		}
		if(leftbits != 0) this.cantResolveType({ fileName : "YBinary.hx", lineNumber : 71, className : "yaml.type.YBinary", methodName : "resolve"});
		var bytes = haxe.io.Bytes.alloc(result.length);
		var _g1 = 0;
		var _g2 = result.length;
		while(_g1 < _g2) {
			var i = _g1++;
			bytes.b[i] = result[i] & 255;
		}
		return bytes;
	}
	,represent: function(object,style) {
		var result = "";
		var index = 0;
		var max = object.length - 2;
		while(index < max) {
			result += yaml.type.YBinary.BASE64_CHARTABLE[object.b[index] >> 2];
			result += yaml.type.YBinary.BASE64_CHARTABLE[((object.b[index] & 3) << 4) + (object.b[index + 1] >> 4)];
			result += yaml.type.YBinary.BASE64_CHARTABLE[((object.b[index + 1] & 15) << 2) + (object.b[index + 2] >> 6)];
			result += yaml.type.YBinary.BASE64_CHARTABLE[object.b[index + 2] & 63];
			index += 3;
		}
		var rest = object.length % 3;
		if(0 != rest) {
			index = object.length - rest;
			result += yaml.type.YBinary.BASE64_CHARTABLE[object.b[index] >> 2];
			if(2 == rest) {
				result += yaml.type.YBinary.BASE64_CHARTABLE[((object.b[index] & 3) << 4) + (object.b[index + 1] >> 4)];
				result += yaml.type.YBinary.BASE64_CHARTABLE[(object.b[index + 1] & 15) << 2];
				result += "=";
			} else {
				result += yaml.type.YBinary.BASE64_CHARTABLE[(object.b[index] & 3) << 4];
				result += 61 + "=";
			}
		}
		return result;
	}
	,__class__: yaml.type.YBinary
});
yaml.type.YBool = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:bool",{ kind : "string"},{ kind : "boolean", defaultStyle : "lowercase"});
};
$hxClasses["yaml.type.YBool"] = yaml.type.YBool;
yaml.type.YBool.__name__ = ["yaml","type","YBool"];
yaml.type.YBool.__super__ = yaml.YamlType;
yaml.type.YBool.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(usingMaps == null) usingMaps = true;
		if(explicit) {
			if(yaml.type.YBool.YAML_EXPLICIT_BOOLEAN_MAP.exists(object)) return yaml.type.YBool.YAML_EXPLICIT_BOOLEAN_MAP.get(object); else return this.cantResolveType({ fileName : "YBool.hx", lineNumber : 64, className : "yaml.type.YBool", methodName : "resolve"});
		} else if(yaml.type.YBool.YAML_IMPLICIT_BOOLEAN_MAP.exists(object)) return yaml.type.YBool.YAML_IMPLICIT_BOOLEAN_MAP.get(object); else return this.cantResolveType({ fileName : "YBool.hx", lineNumber : 75, className : "yaml.type.YBool", methodName : "resolve"});
	}
	,represent: function(object,style) {
		switch(style) {
		case "uppercase":
			if(object) return "TRUE"; else return "FALSE";
			break;
		case "lowercase":
			if(object) return "true"; else return "false";
			break;
		case "camelcase":
			if(object) return "True"; else return "False";
			break;
		default:
			throw new yaml.YamlException("Style not supported: " + style,null,{ fileName : "YBool.hx", lineNumber : 88, className : "yaml.type.YBool", methodName : "represent"});
			return null;
		}
	}
	,__class__: yaml.type.YBool
});
yaml.type.YFloat = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:float",{ kind : "string"},{ kind : "float", defaultStyle : "lowercase"});
};
$hxClasses["yaml.type.YFloat"] = yaml.type.YFloat;
yaml.type.YFloat.__name__ = ["yaml","type","YFloat"];
yaml.type.YFloat.__super__ = yaml.YamlType;
yaml.type.YFloat.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(usingMaps == null) usingMaps = true;
		if(!yaml.type.YFloat.YAML_FLOAT_PATTERN.match(object)) this.cantResolveType({ fileName : "YFloat.hx", lineNumber : 23, className : "yaml.type.YFloat", methodName : "resolve"});
		var value = StringTools.replace(object,"_","").toLowerCase();
		var sign;
		if("-" == value.charAt(0)) sign = -1; else sign = 1;
		if(0 <= "+-".indexOf(value.charAt(0))) value = HxOverrides.substr(value,1,null);
		if(".inf" == value) if(1 == sign) return Math.POSITIVE_INFINITY; else return Math.NEGATIVE_INFINITY; else if(".nan" == value) return Math.NaN; else if(0 <= value.indexOf(":")) {
			var digits = [];
			var _g = 0;
			var _g1 = value.split(":");
			while(_g < _g1.length) {
				var v = _g1[_g];
				++_g;
				digits.unshift(Std.parseFloat(v));
			}
			var v1 = 0.0;
			var base = 1;
			var _g2 = 0;
			while(_g2 < digits.length) {
				var d = digits[_g2];
				++_g2;
				v1 += d * base;
				base *= 60;
			}
			return sign * v1;
		} else return sign * Std.parseFloat(value);
	}
	,represent: function(object,style) {
		if(Math.isNaN(object)) switch(style) {
		case "lowercase":
			return ".nan";
		case "uppercase":
			return ".NAN";
		case "camelcase":
			return ".NaN";
		default:
			return ".nan";
		} else if(Math.POSITIVE_INFINITY == object) switch(style) {
		case "lowercase":
			return ".inf";
		case "uppercase":
			return ".INF";
		case "camelcase":
			return ".Inf";
		default:
			return ".inf";
		} else if(Math.NEGATIVE_INFINITY == object) switch(style) {
		case "lowercase":
			return "-.inf";
		case "uppercase":
			return "-.INF";
		case "camelcase":
			return "-.Inf";
		default:
			return "-.inf";
		} else return yaml.util.Floats.toString(object);
	}
	,__class__: yaml.type.YFloat
});
yaml.type.YInt = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:int",{ kind : "string"},{ kind : "integer", defaultStyle : "decimal", styleAliases : this.createStyleAliases()});
};
$hxClasses["yaml.type.YInt"] = yaml.type.YInt;
yaml.type.YInt.__name__ = ["yaml","type","YInt"];
yaml.type.YInt.__super__ = yaml.YamlType;
yaml.type.YInt.prototype = $extend(yaml.YamlType.prototype,{
	createStyleAliases: function() {
		var styleAliases = new haxe.ds.StringMap();
		styleAliases.set("bin","binary");
		styleAliases.set("2","binary");
		styleAliases.set("oct","octal");
		styleAliases.set("8","octal");
		styleAliases.set("dec","decimal");
		styleAliases.set("hex","hexadecimal");
		styleAliases.set("16","hexadecimal");
		return styleAliases;
	}
	,resolve: function(object,usingMaps,explicit) {
		if(usingMaps == null) usingMaps = true;
		if(!yaml.type.YInt.YAML_INTEGER_PATTERN.match(object)) this.cantResolveType({ fileName : "YInt.hx", lineNumber : 38, className : "yaml.type.YInt", methodName : "resolve"});
		var value = StringTools.replace(object,"_","").toLowerCase();
		var sign;
		if("-" == value.charAt(0)) sign = -1; else sign = 1;
		var digits = [];
		if(0 <= "+-".indexOf(value.charAt(0))) value = HxOverrides.substr(value,1,null);
		if("0" == value) return 0; else if(value.indexOf("0b") == 0) return sign * yaml.util.Ints.parseInt(HxOverrides.substr(value,2,null),2); else if(value.indexOf("0x") == 0) return sign * yaml.util.Ints.parseInt(value,16); else if(value.indexOf("0") == 0) return sign * yaml.util.Ints.parseInt(value,8); else if(0 <= value.indexOf(":")) {
			var _g = 0;
			var _g1 = value.split(":");
			while(_g < _g1.length) {
				var v = _g1[_g];
				++_g;
				digits.unshift(yaml.util.Ints.parseInt(v,10));
			}
			var result = 0;
			var base = 1;
			var _g2 = 0;
			while(_g2 < digits.length) {
				var d = digits[_g2];
				++_g2;
				result += d * base;
				base *= 60;
			}
			return sign * result;
		} else return sign * yaml.util.Ints.parseInt(value,10);
	}
	,represent: function(object,style) {
		switch(style) {
		case "binary":
			return "0b" + yaml.util.Ints.toString(object,2);
		case "octal":
			return "0" + yaml.util.Ints.toString(object,8);
		case "decimal":
			return yaml.util.Ints.toString(object,10);
		case "hexadecimal":
			return "0x" + yaml.util.Ints.toString(object,16);
		default:
			throw new yaml.YamlException("Style not supported: " + style,null,{ fileName : "YInt.hx", lineNumber : 99, className : "yaml.type.YInt", methodName : "represent"});
			return null;
		}
	}
	,__class__: yaml.type.YInt
});
yaml.type.YMap = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:map",{ kind : "object", skip : true},{ skip : true});
};
$hxClasses["yaml.type.YMap"] = yaml.type.YMap;
yaml.type.YMap.__name__ = ["yaml","type","YMap"];
yaml.type.YMap.__super__ = yaml.YamlType;
yaml.type.YMap.prototype = $extend(yaml.YamlType.prototype,{
	__class__: yaml.type.YMap
});
yaml.type.YMerge = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:merge",{ kind : "string"},{ skip : true});
};
$hxClasses["yaml.type.YMerge"] = yaml.type.YMerge;
yaml.type.YMerge.__name__ = ["yaml","type","YMerge"];
yaml.type.YMerge.__super__ = yaml.YamlType;
yaml.type.YMerge.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(usingMaps == null) usingMaps = true;
		if("<<" == object) return object; else return this.cantResolveType({ fileName : "YMerge.hx", lineNumber : 14, className : "yaml.type.YMerge", methodName : "resolve"});
	}
	,represent: function(object,style) {
		return null;
	}
	,__class__: yaml.type.YMerge
});
yaml.type.YNull = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:null",{ kind : "string"},{ kind : "null", defaultStyle : "lowercase"});
};
$hxClasses["yaml.type.YNull"] = yaml.type.YNull;
yaml.type.YNull.__name__ = ["yaml","type","YNull"];
yaml.type.YNull.__super__ = yaml.YamlType;
yaml.type.YNull.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(explicit == null) explicit = false;
		if(usingMaps == null) usingMaps = true;
		if(yaml.type.YNull.YAML_NULL_MAP.exists(object)) return null; else return this.cantResolveType({ fileName : "YNull.hx", lineNumber : 24, className : "yaml.type.YNull", methodName : "resolve"});
	}
	,represent: function(object,style) {
		switch(style) {
		case "canonical":
			return "~";
		case "lowercase":
			return "null";
		case "uppercase":
			return "NULL";
		case "camelcase":
			return "Null";
		default:
			return "~";
		}
	}
	,__class__: yaml.type.YNull
});
yaml.type.YOmap = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:omap",{ kind : "array"},{ skip : true});
};
$hxClasses["yaml.type.YOmap"] = yaml.type.YOmap;
yaml.type.YOmap.__name__ = ["yaml","type","YOmap"];
yaml.type.YOmap.__super__ = yaml.YamlType;
yaml.type.YOmap.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(explicit == null) explicit = false;
		if(usingMaps == null) usingMaps = true;
		if(usingMaps) this.validateOMap(object); else this.validateObjectOMap(object);
		return object;
	}
	,validateOMap: function(object) {
		var objectKeys = new yaml.util.TObjectMap();
		var _g = 0;
		while(_g < object.length) {
			var pair = object[_g];
			++_g;
			var pairHasKey = false;
			var pairKey = null;
			if(!js.Boot.__instanceof(pair,yaml.util.TObjectMap)) this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 31, className : "yaml.type.YOmap", methodName : "validateOMap"});
			var $it0 = pair.keys();
			while( $it0.hasNext() ) {
				var key = $it0.next();
				if(pairKey == null) pairKey = key; else this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 36, className : "yaml.type.YOmap", methodName : "validateOMap"});
			}
			if(pairKey == null) this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 40, className : "yaml.type.YOmap", methodName : "validateOMap"});
			if(objectKeys.exists(pairKey)) this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 43, className : "yaml.type.YOmap", methodName : "validateOMap"}); else objectKeys.set(pairKey,null);
		}
		return object;
	}
	,validateObjectOMap: function(object) {
		var objectKeys = new haxe.ds.StringMap();
		var _g = 0;
		while(_g < object.length) {
			var pair = object[_g];
			++_g;
			var pairHasKey = false;
			var pairKey = null;
			if(Type["typeof"](pair) != ValueType.TObject) this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 60, className : "yaml.type.YOmap", methodName : "validateObjectOMap"});
			var _g1 = 0;
			var _g2 = Reflect.fields(pair);
			while(_g1 < _g2.length) {
				var key = _g2[_g1];
				++_g1;
				if(pairKey == null) pairKey = key; else this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 65, className : "yaml.type.YOmap", methodName : "validateObjectOMap"});
			}
			if(pairKey == null) this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 69, className : "yaml.type.YOmap", methodName : "validateObjectOMap"});
			if(objectKeys.exists(pairKey)) this.cantResolveType({ fileName : "YOmap.hx", lineNumber : 72, className : "yaml.type.YOmap", methodName : "validateObjectOMap"}); else objectKeys.set(pairKey,null);
		}
	}
	,__class__: yaml.type.YOmap
});
yaml.type.YPairs = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:pairs",{ kind : "array"},{ skip : true});
};
$hxClasses["yaml.type.YPairs"] = yaml.type.YPairs;
yaml.type.YPairs.__name__ = ["yaml","type","YPairs"];
yaml.type.YPairs.__super__ = yaml.YamlType;
yaml.type.YPairs.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(explicit == null) explicit = false;
		if(usingMaps == null) usingMaps = true;
		if(usingMaps) return this.resolveMapPair(object); else return this.resolveObjectPair(object);
	}
	,resolveMapPair: function(object) {
		var result = [];
		var _g = 0;
		while(_g < object.length) {
			var pair = object[_g];
			++_g;
			if(!js.Boot.__instanceof(pair,yaml.util.TObjectMap)) this.cantResolveType({ fileName : "YPairs.hx", lineNumber : 28, className : "yaml.type.YPairs", methodName : "resolveMapPair"});
			var fieldCount = 0;
			var keyPair = null;
			var $it0 = pair.keys();
			while( $it0.hasNext() ) {
				var key = $it0.next();
				keyPair = key;
				if(fieldCount++ > 1) break;
			}
			if(fieldCount != 1) this.cantResolveType({ fileName : "YPairs.hx", lineNumber : 39, className : "yaml.type.YPairs", methodName : "resolveMapPair"});
			result.push([keyPair,pair.get(keyPair)]);
		}
		return result;
	}
	,resolveObjectPair: function(object) {
		var result = [];
		var _g = 0;
		while(_g < object.length) {
			var pair = object[_g];
			++_g;
			if(Type["typeof"](pair) != ValueType.TObject) this.cantResolveType({ fileName : "YPairs.hx", lineNumber : 52, className : "yaml.type.YPairs", methodName : "resolveObjectPair"});
			var fieldCount = 0;
			var keyPair = null;
			var _g1 = 0;
			var _g2 = Reflect.fields(pair);
			while(_g1 < _g2.length) {
				var key = _g2[_g1];
				++_g1;
				keyPair = key;
				if(fieldCount++ > 1) break;
			}
			if(fieldCount != 1) this.cantResolveType({ fileName : "YPairs.hx", lineNumber : 63, className : "yaml.type.YPairs", methodName : "resolveObjectPair"});
			result.push([keyPair,Reflect.field(pair,keyPair)]);
		}
		return result;
	}
	,__class__: yaml.type.YPairs
});
yaml.type.YSeq = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:seq",{ kind : "array", skip : true},{ skip : true});
};
$hxClasses["yaml.type.YSeq"] = yaml.type.YSeq;
yaml.type.YSeq.__name__ = ["yaml","type","YSeq"];
yaml.type.YSeq.__super__ = yaml.YamlType;
yaml.type.YSeq.prototype = $extend(yaml.YamlType.prototype,{
	__class__: yaml.type.YSeq
});
yaml.type.YSet = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:set",{ kind : "object"},{ skip : true});
};
$hxClasses["yaml.type.YSet"] = yaml.type.YSet;
yaml.type.YSet.__name__ = ["yaml","type","YSet"];
yaml.type.YSet.__super__ = yaml.YamlType;
yaml.type.YSet.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(explicit == null) explicit = false;
		if(usingMaps == null) usingMaps = true;
		if(usingMaps) this.validateSet(object); else this.validateObjectSet(object);
		return object;
	}
	,validateSet: function(object) {
		var $it0 = object.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			if(object.get(key) != null) this.cantResolveType({ fileName : "YSet.hx", lineNumber : 24, className : "yaml.type.YSet", methodName : "validateSet"});
		}
	}
	,validateObjectSet: function(object) {
		var _g = 0;
		var _g1 = Reflect.fields(object);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			if(Reflect.field(object,key) != null) this.cantResolveType({ fileName : "YSet.hx", lineNumber : 31, className : "yaml.type.YSet", methodName : "validateObjectSet"});
		}
	}
	,__class__: yaml.type.YSet
});
yaml.type.YString = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:str",{ kind : "string", skip : true},{ skip : true});
};
$hxClasses["yaml.type.YString"] = yaml.type.YString;
yaml.type.YString.__name__ = ["yaml","type","YString"];
yaml.type.YString.__super__ = yaml.YamlType;
yaml.type.YString.prototype = $extend(yaml.YamlType.prototype,{
	__class__: yaml.type.YString
});
yaml.type.YTimestamp = function() {
	yaml.YamlType.call(this,"tag:yaml.org,2002:timestamp",{ kind : "string"},{ kind : "object", instanceOf : Date});
};
$hxClasses["yaml.type.YTimestamp"] = yaml.type.YTimestamp;
yaml.type.YTimestamp.__name__ = ["yaml","type","YTimestamp"];
yaml.type.YTimestamp.nativeDate = function() {
	return Date;
	return null;
};
yaml.type.YTimestamp.__super__ = yaml.YamlType;
yaml.type.YTimestamp.prototype = $extend(yaml.YamlType.prototype,{
	resolve: function(object,usingMaps,explicit) {
		if(explicit == null) explicit = false;
		if(usingMaps == null) usingMaps = true;
		if(!yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.match(object)) this.cantResolveType({ fileName : "YTimestamp.hx", lineNumber : 28, className : "yaml.type.YTimestamp", methodName : "resolve"});
		var year = 0;
		var month = 0;
		var day = 0;
		var hour = 0;
		var minute = 0;
		var second = 0;
		var fraction = 0;
		var delta = 0;
		try {
			year = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(1));
			month = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(2)) - 1;
			day = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(3));
			hour = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(4));
			minute = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(5));
			second = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(6));
			var matched = -1;
			if(year == null) matched = year = 0;
			if(month == null) matched = month = 0;
			if(day == null) matched = day = 0;
			if(hour == null) matched = hour = 0;
			if(minute == null) matched = minute = 0;
			if(second == null) matched = second = 0;
			if(matched == 0) throw "Nothing left to match";
			var msecs = yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(7);
			if(msecs == null) throw "Nothing left to match";
			var f = msecs.substring(0,3);
			while(f.length < 3) f += "0";
			fraction = Std.parseInt(f);
			if(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(9) != null) {
				var tz_hour = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(10));
				if(tz_hour == null) throw "Nothing left to match";
				var tz_minute = 0;
				try {
					tz_minute = Std.parseInt(yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(11));
					if(tz_minute == null) tz_minute = 0;
				} catch( e ) {
				}
				delta = (tz_hour * 60 + tz_minute) * 60000;
				if("-" == yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP.matched(9)) delta = -delta;
			}
		} catch( e1 ) {
		}
		var stamp = yaml.type.YTimestamp.nativeDate().UTC(year,month,day,hour,minute,second,fraction);
		if(delta != 0) stamp = stamp - delta;
		var d = new Date();
		d.setTime(stamp);
		return d;
	}
	,represent: function(object,style) {
		return yaml.util.Dates.toISOString(object);
	}
	,__class__: yaml.type.YTimestamp
});
yaml.util = {};
yaml.util.Dates = function() { };
$hxClasses["yaml.util.Dates"] = yaml.util.Dates;
yaml.util.Dates.__name__ = ["yaml","util","Dates"];
yaml.util.Dates.getNativeDate = function() {
	return Date;
	return null;
};
yaml.util.Dates.toISOString = function(date) {
	var NativeDate = yaml.util.Dates.getNativeDate();
	var d = new NativeDate(date.getTime());
	return d.getUTCFullYear() + "-" + StringTools.lpad("" + (d.getUTCMonth() + 1),"0",2) + "-" + StringTools.lpad("" + d.getUTCDate(),"0",2) + "T" + StringTools.lpad("" + d.getUTCHours(),"0",2) + ":" + StringTools.lpad("" + d.getUTCMinutes(),"0",2) + ":" + StringTools.lpad("" + d.getUTCSeconds(),"0",2) + "." + StringTools.rpad((function($this) {
		var $r;
		var _this = "" + yaml.util.Floats.round(d.getUTCMilliseconds() / 1000,3);
		$r = HxOverrides.substr(_this,2,5);
		return $r;
	}(this)),"0",3) + "Z";
};
yaml.util.Floats = function() { };
$hxClasses["yaml.util.Floats"] = yaml.util.Floats;
yaml.util.Floats.__name__ = ["yaml","util","Floats"];
yaml.util.Floats.toString = function(value) {
	if(value == null) return "null"; else return "" + value;
};
yaml.util.Floats.round = function(value,precision) {
	value = value * Math.pow(10,precision);
	return Math.round(value) / Math.pow(10,precision);
};
yaml.util.Ints = function() { };
$hxClasses["yaml.util.Ints"] = yaml.util.Ints;
yaml.util.Ints.__name__ = ["yaml","util","Ints"];
yaml.util.Ints.toString = function(value,radix) {
	if(radix == null) radix = 10;
	if(radix < 2 || radix > yaml.util.Ints.BASE.length) throw "Unsupported radix " + radix;
	return value.toString(radix);
};
yaml.util.Ints.parseInt = function(value,radix) {
	if(radix != null && (radix < 2 || radix > yaml.util.Ints.BASE.length)) throw "Unsupported radix " + radix;
	var v = parseInt(value,radix);
	if(isNaN(v)) return null; else return v;
};
yaml.util.TObjectMap = function(weakKeys) {
	if(weakKeys == null) weakKeys = false;
	this._keys = [];
	this.values = [];
};
$hxClasses["yaml.util.TObjectMap"] = yaml.util.TObjectMap;
yaml.util.TObjectMap.__name__ = ["yaml","util","TObjectMap"];
yaml.util.TObjectMap.prototype = {
	_keys: null
	,values: null
	,set: function(key,value) {
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) {
				this._keys[i] = key;
				this.values[i] = value;
				return;
			}
		}
		this._keys.push(key);
		this.values.push(value);
	}
	,get: function(key) {
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) return this.values[i];
		}
		return null;
	}
	,exists: function(key) {
		var _g = 0;
		var _g1 = this._keys;
		while(_g < _g1.length) {
			var k = _g1[_g];
			++_g;
			if(k == key) return true;
		}
		return false;
	}
	,remove: function(key) {
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._keys[i] == key) {
				this._keys.splice(i,1);
				this.values.splice(i,1);
				return true;
			}
		}
		return false;
	}
	,keys: function() {
		return HxOverrides.iter(this._keys);
	}
	,iterator: function() {
		return HxOverrides.iter(this.values);
	}
	,toString: function() {
		var s = "{";
		var ks = this._keys;
		var vs = this.values;
		var _g1 = 0;
		var _g = this._keys.length;
		while(_g1 < _g) {
			var i = _g1++;
			var k;
			if(Type.getClass(ks[i]) == Array) k = "[" + ks[i] + "]"; else k = ks[i];
			var v;
			if(Type.getClass(vs[i]) == Array) v = "[" + vs[i] + "]"; else v = vs[i];
			s += k + " => " + v + ", ";
		}
		if(this._keys.length > 0) s = HxOverrides.substr(s,0,s.length - 2);
		return s + "}";
	}
	,__class__: yaml.util.TObjectMap
};
yaml.util.Strings = function() { };
$hxClasses["yaml.util.Strings"] = yaml.util.Strings;
yaml.util.Strings.__name__ = ["yaml","util","Strings"];
yaml.util.Strings.repeat = function(source,times) {
	var result = "";
	var _g = 0;
	while(_g < times) {
		var i = _g++;
		result += source;
	}
	return result;
};
yaml.util.Utf8 = function() { };
$hxClasses["yaml.util.Utf8"] = yaml.util.Utf8;
yaml.util.Utf8.__name__ = ["yaml","util","Utf8"];
yaml.util.Utf8.substring = function(value,startIndex,endIndex) {
	var size = value.length;
	var pos = startIndex;
	var length = 0;
	if(endIndex == null) length = size - pos; else {
		if(startIndex > endIndex) {
			pos = endIndex;
			endIndex = startIndex;
		}
		length = endIndex - pos;
	}
	return HxOverrides.substr(value,pos,length);
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
$hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
Xml.Element = "element";
Xml.PCData = "pcdata";
Xml.CData = "cdata";
Xml.Comment = "comment";
Xml.DocType = "doctype";
Xml.ProcessingInstruction = "processingInstruction";
Xml.Document = "document";
haxe.Resource.content = [{ name : "params", data : "eyJ3aWR0aCI6MCwidmVyc2lvbiI6IjAuMS4wIiwiYXBwIjoicHJvamVjdC1pZC0wLjEuMCIsImhlaWdodCI6MCwidGFyZ2V0Ijoia2V5IiwidGl0bGUiOiJOZXdGbGlja3JfTVVJIiwiYmFzZVVybCI6IiIsImJ1aWxkIjoiZGVmYXVsdC51c2VyIDIwMTQtMDctMTQgMTU6NDU6NTEifQ"}];
msignal.SlotList.NIL = new msignal.SlotList(null,null);
JS.prefix = JS.detectPrefix();
IMap.__meta__ = { obj : { 'interface' : null}};
StyleMacro.REF_PATTERN = new EReg("^\\$(.+)","");
mmvc.api.IContext.__meta__ = { obj : { 'interface' : null}};
mui.core.Changeable.__meta__ = { obj : { 'interface' : null}};
mui.core.Node.validator = new mui.core.Validator();
haxe.crypto.Base64.CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
haxe.crypto.Base64.BYTES = haxe.io.Bytes.ofString(haxe.crypto.Base64.CHARS);
mui.display.AssetDisplay.library = new mui.display.AssetLibrary();
mmvc.api.IViewContainer.__meta__ = { obj : { 'interface' : null}};
flickrapp.flickr.api.FlickrAPI.API_KEY = "4111e112a393aefbf0a66241479722cd";
mmvc.api.ICommand.__meta__ = { obj : { 'interface' : null}};
mmvc.impl.Command.__meta__ = { fields : { contextView : { name : ["contextView"], type : ["mmvc.api.IViewContainer"], inject : null}, commandMap : { name : ["commandMap"], type : ["mmvc.api.ICommandMap"], inject : null}, injector : { name : ["injector"], type : ["minject.Injector"], inject : null}, mediatorMap : { name : ["mediatorMap"], type : ["mmvc.api.IMediatorMap"], inject : null}, signal : { name : ["signal"], type : ["msignal.Signal"], inject : null}}};
flickrapp.flickr.command.LoadFlickrDataCommand.__meta__ = { fields : { flickr : { name : ["flickr"], type : ["flickrapp.flickr.api.FlickrAPI"], inject : null}, galleryModel : { name : ["galleryModel"], type : ["flickrapp.flickr.model.GalleryModel"], inject : null}, queryStr : { name : ["queryStr"], type : ["String"], inject : null}, numPerPage : { name : ["numPerPage"], type : ["Int"], inject : null}}};
mdata.Collection.__meta__ = { obj : { 'interface' : null}};
mdata.List.__meta__ = { obj : { 'interface' : null}};
mmvc.api.IMediator.__meta__ = { obj : { 'interface' : null}};
mmvc.impl.Mediator.__meta__ = { fields : { injector : { name : ["injector"], type : ["minject.Injector"], inject : null}, contextView : { name : ["contextView"], type : ["mmvc.api.IViewContainer"], inject : null}, mediatorMap : { name : ["mediatorMap"], type : ["mmvc.api.IMediatorMap"], inject : null}}};
flickrapp.flickr.view.GalleryViewMediator.__meta__ = { fields : { galleryModel : { name : ["galleryModel"], type : ["flickrapp.flickr.model.GalleryModel"], inject : null}}};
flickrapp.flickr.view.GalleryZoomView.BG_COLOR = 13421772;
flickrapp.flickr.view.GalleryZoomView.FOCUS_COLOR = 889651;
flickrapp.flickr.view.GalleryZoomViewMediator.__meta__ = { fields : { screenList : { name : ["screenList"], type : ["flickrapp.flickr.model.GalleryModel"], inject : null}}};
flickrapp.flickr.view.SearchBoxView.DO_SEARCH = "do search";
flickrapp.flickr.view.SearchBoxViewMediator.__meta__ = { fields : { loadFlickrData : { name : ["loadFlickrData"], type : ["flickrapp.flickr.signal.LoadFlickrData"], inject : null}, galleryModel : { name : ["galleryModel"], type : ["flickrapp.flickr.model.GalleryModel"], inject : null}}};
haxe.xml.Parser.escapes = (function($this) {
	var $r;
	var h = new haxe.ds.StringMap();
	h.set("lt","<");
	h.set("gt",">");
	h.set("amp","&");
	h.set("quot","\"");
	h.set("apos","'");
	h.set("nbsp",String.fromCharCode(160));
	$r = h;
	return $r;
}(this));
mconsole.Printer.__meta__ = { obj : { 'interface' : null}};
mconsole.ConsoleView.CONSOLE_STYLES = "#console {\n\tfont-family:monospace;\n\tbackground-color:#002B36;\n\tbackground-color:rgba(0%,16.9%,21.2%,0.95);\n\tpadding:8px;\n\theight:600px;\n\tmax-height:600px;\n\toverflow-y:scroll;\n\tposition:absolute;\n\tleft:0px;\n\ttop:0px;\n\tright:0px;\n\tmargin:0px;\n\tz-index:10000;\n}\n#console a { text-decoration:none; }\n#console a:hover div { background-color:#063642 }\n#console a div span { display:none; float:right; color:white; }\n#console a:hover div span { display:block; }";
mconsole.Console.defaultPrinter = new mconsole.ConsoleView();
mconsole.Console.printers = [mconsole.Console.defaultPrinter];
mconsole.Console.groupDepth = 0;
mconsole.Console.times = new haxe.ds.StringMap();
mconsole.Console.counts = new haxe.ds.StringMap();
mconsole.Console.running = false;
mconsole.Console.dirxml = "dirxml";
mconsole.Console.hasConsole = mconsole.Console.detectConsole();
mconsole.ConsoleMacro.__meta__ = { obj : { IgnoreCover : null}};
mconsole.StackHelper.filters = mconsole.StackHelper.createFilters();
mloader.Loader.__meta__ = { obj : { 'interface' : null}};
mloader.LoaderQueue.DEFAULT_MAX_LOADING = 8;
mmvc.api.ICommandMap.__meta__ = { obj : { 'interface' : null}};
mmvc.api.IMediatorMap.__meta__ = { obj : { 'interface' : null}};
mmvc.api.IViewMap.__meta__ = { obj : { 'interface' : null}};
msignal.EventDispatcher.__meta__ = { obj : { 'interface' : null}};
mui.Lib.init = (function($this) {
	var $r;
	mconsole.Console.start();
	$r = true;
	return $r;
}(this));
mui.Lib.frameEntered = new msignal.Signal0();
mui.Lib.frameRendered = new msignal.Signal0();
mui.Lib.mouseMoved = new msignal.Signal0();
mui.core.Skin.NONE = new mui.core.Skin();
mui.display.GraphicStyle.__meta__ = { obj : { 'interface' : null}};
mui.display.DisplayRoot.DEFAULT_FRAME_RATE = 16;
mui.display.Text.ELLIPSE = "…";
mui.display.Text.NEWLINES = new EReg("\n","g");
mui.event.Focus.changed = new msignal.Signal1(mui.core.DataComponent);
mui.event.Input.modeChanged = new msignal.Signal0();
mui.event.KeyManager.DEFAULT_HOLD_DELAY = 600;
mui.event.KeyManager.DEFAULT_HOLD_INTERVAL = 200;
mui.event.KeyManager.previousPressCount = 0;
mui.event.KeyManager.realPressCount = 0;
mui.event.Key.manager = new mui.event.KeyManager();
mui.event.Screen.resized = new msignal.Signal1(mui.event.Screen);
mui.event.Screen.reoriented = new msignal.Signal1(mui.event.Screen);
mui.event.Screen.primary = new mui.event.Screen();
mui.event.Touch.started = new msignal.Signal1(mui.event.Touch);
mui.transition.Transition.__meta__ = { obj : { 'interface' : null}};
mui.transition.TimeTween.defaultDuration = 500;
mui.transition.TimeTween.fps = 24;
mui.transition.TimeTween.renderFrame = mui.Lib.frameEntered;
mui.transition.TimeTween.tweens = new Array();
mui.validator.Validator.__meta__ = { obj : { 'interface' : null}};
yaml.Parser.KIND_STRING = "string";
yaml.Parser.KIND_ARRAY = "array";
yaml.Parser.KIND_OBJECT = "object";
yaml.Parser.CONTEXT_FLOW_IN = 1;
yaml.Parser.CONTEXT_FLOW_OUT = 2;
yaml.Parser.CONTEXT_BLOCK_IN = 3;
yaml.Parser.CONTEXT_BLOCK_OUT = 4;
yaml.Parser.CHOMPING_CLIP = 1;
yaml.Parser.CHOMPING_STRIP = 2;
yaml.Parser.CHOMPING_KEEP = 3;
yaml.Parser.CHAR_TAB = 9;
yaml.Parser.CHAR_LINE_FEED = 10;
yaml.Parser.CHAR_CARRIAGE_RETURN = 13;
yaml.Parser.CHAR_SPACE = 32;
yaml.Parser.CHAR_EXCLAMATION = 33;
yaml.Parser.CHAR_DOUBLE_QUOTE = 34;
yaml.Parser.CHAR_SHARP = 35;
yaml.Parser.CHAR_PERCENT = 37;
yaml.Parser.CHAR_AMPERSAND = 38;
yaml.Parser.CHAR_SINGLE_QUOTE = 39;
yaml.Parser.CHAR_ASTERISK = 42;
yaml.Parser.CHAR_PLUS = 43;
yaml.Parser.CHAR_COMMA = 44;
yaml.Parser.CHAR_MINUS = 45;
yaml.Parser.CHAR_DOT = 46;
yaml.Parser.CHAR_SLASH = 47;
yaml.Parser.CHAR_DIGIT_ZERO = 48;
yaml.Parser.CHAR_DIGIT_ONE = 49;
yaml.Parser.CHAR_DIGIT_NINE = 57;
yaml.Parser.CHAR_COLON = 58;
yaml.Parser.CHAR_LESS_THAN = 60;
yaml.Parser.CHAR_GREATER_THAN = 62;
yaml.Parser.CHAR_QUESTION = 63;
yaml.Parser.CHAR_COMMERCIAL_AT = 64;
yaml.Parser.CHAR_CAPITAL_A = 65;
yaml.Parser.CHAR_CAPITAL_F = 70;
yaml.Parser.CHAR_CAPITAL_L = 76;
yaml.Parser.CHAR_CAPITAL_N = 78;
yaml.Parser.CHAR_CAPITAL_P = 80;
yaml.Parser.CHAR_CAPITAL_U = 85;
yaml.Parser.CHAR_LEFT_SQUARE_BRACKET = 91;
yaml.Parser.CHAR_BACKSLASH = 92;
yaml.Parser.CHAR_RIGHT_SQUARE_BRACKET = 93;
yaml.Parser.CHAR_UNDERSCORE = 95;
yaml.Parser.CHAR_GRAVE_ACCENT = 96;
yaml.Parser.CHAR_SMALL_A = 97;
yaml.Parser.CHAR_SMALL_B = 98;
yaml.Parser.CHAR_SMALL_E = 101;
yaml.Parser.CHAR_SMALL_F = 102;
yaml.Parser.CHAR_SMALL_N = 110;
yaml.Parser.CHAR_SMALL_R = 114;
yaml.Parser.CHAR_SMALL_T = 116;
yaml.Parser.CHAR_SMALL_U = 117;
yaml.Parser.CHAR_SMALL_V = 118;
yaml.Parser.CHAR_SMALL_X = 120;
yaml.Parser.CHAR_LEFT_CURLY_BRACKET = 123;
yaml.Parser.CHAR_VERTICAL_LINE = 124;
yaml.Parser.CHAR_RIGHT_CURLY_BRACKET = 125;
yaml.Parser.SIMPLE_ESCAPE_SEQUENCES = (function($this) {
	var $r;
	var hash = new haxe.ds.IntMap();
	hash.set(48,yaml.Parser.createUtf8Char(0));
	hash.set(97,yaml.Parser.createUtf8Char(7));
	hash.set(98,yaml.Parser.createUtf8Char(8));
	hash.set(116,yaml.Parser.createUtf8Char(9));
	hash.set(9,yaml.Parser.createUtf8Char(9));
	hash.set(110,yaml.Parser.createUtf8Char(10));
	hash.set(118,yaml.Parser.createUtf8Char(11));
	hash.set(102,yaml.Parser.createUtf8Char(12));
	hash.set(114,yaml.Parser.createUtf8Char(13));
	hash.set(101,yaml.Parser.createUtf8Char(27));
	hash.set(32,yaml.Parser.createUtf8Char(32));
	hash.set(34,yaml.Parser.createUtf8Char(34));
	hash.set(47,yaml.Parser.createUtf8Char(47));
	hash.set(92,yaml.Parser.createUtf8Char(92));
	hash.set(78,yaml.Parser.createUtf8Char(133));
	hash.set(95,yaml.Parser.createUtf8Char(160));
	hash.set(76,yaml.Parser.createUtf8Char(8232));
	hash.set(80,yaml.Parser.createUtf8Char(8233));
	$r = hash;
	return $r;
}(this));
yaml.Parser.HEXADECIMAL_ESCAPE_SEQUENCES = (function($this) {
	var $r;
	var hash = new haxe.ds.IntMap();
	hash.set(120,2);
	hash.set(117,4);
	hash.set(85,8);
	$r = hash;
	return $r;
}(this));
yaml.Parser.PATTERN_NON_PRINTABLE = new EReg("[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F\\x7F-\\x84\\x86-\\x9F\\uD800-\\uDFFF\\uFFFE\\uFFFF]","u");
yaml.Parser.PATTERN_NON_ASCII_LINE_BREAKS = new EReg("[\\x85\\u2028\\u2029]","u");
yaml.Parser.PATTERN_FLOW_INDICATORS = new EReg("[,\\[\\]\\{\\}]","u");
yaml.Parser.PATTERN_TAG_HANDLE = new EReg("^(?:!|!!|![a-z\\-]+!)$","iu");
yaml.Parser.PATTERN_TAG_URI = new EReg("^(?:!|[^,\\[\\]\\{\\}])(?:%[0-9a-f]{2}|[0-9a-z\\-#;/\\?:@&=\\+\\$,_\\.!~\\*'\\(\\)\\[\\]])*$","iu");
yaml.Renderer.CHAR_TAB = 9;
yaml.Renderer.CHAR_LINE_FEED = 10;
yaml.Renderer.CHAR_CARRIAGE_RETURN = 13;
yaml.Renderer.CHAR_SPACE = 32;
yaml.Renderer.CHAR_EXCLAMATION = 33;
yaml.Renderer.CHAR_DOUBLE_QUOTE = 34;
yaml.Renderer.CHAR_SHARP = 35;
yaml.Renderer.CHAR_PERCENT = 37;
yaml.Renderer.CHAR_AMPERSAND = 38;
yaml.Renderer.CHAR_SINGLE_QUOTE = 39;
yaml.Renderer.CHAR_ASTERISK = 42;
yaml.Renderer.CHAR_COMMA = 44;
yaml.Renderer.CHAR_MINUS = 45;
yaml.Renderer.CHAR_COLON = 58;
yaml.Renderer.CHAR_GREATER_THAN = 62;
yaml.Renderer.CHAR_QUESTION = 63;
yaml.Renderer.CHAR_COMMERCIAL_AT = 64;
yaml.Renderer.CHAR_LEFT_SQUARE_BRACKET = 91;
yaml.Renderer.CHAR_RIGHT_SQUARE_BRACKET = 93;
yaml.Renderer.CHAR_GRAVE_ACCENT = 96;
yaml.Renderer.CHAR_LEFT_CURLY_BRACKET = 123;
yaml.Renderer.CHAR_VERTICAL_LINE = 124;
yaml.Renderer.CHAR_RIGHT_CURLY_BRACKET = 125;
yaml.Renderer.HEX_VALUES = "0123456789ABCDEF";
yaml.Renderer.ESCAPE_SEQUENCES = (function($this) {
	var $r;
	var hash = new haxe.ds.IntMap();
	hash.set(0,"\\0");
	hash.set(7,"\\a");
	hash.set(8,"\\b");
	hash.set(9,"\\t");
	hash.set(10,"\\n");
	hash.set(11,"\\v");
	hash.set(12,"\\f");
	hash.set(13,"\\r");
	hash.set(27,"\\e");
	hash.set(34,"\\\"");
	hash.set(92,"\\\\");
	hash.set(133,"\\N");
	hash.set(160,"\\_");
	hash.set(8232,"\\L");
	hash.set(8233,"\\P");
	$r = hash;
	return $r;
}(this));
yaml.type.YBinary.BASE64_PADDING_CODE = 61;
yaml.type.YBinary.BASE64_PADDING_CHAR = "=";
yaml.type.YBinary.BASE64_BINTABLE = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,52,53,54,55,56,57,58,59,60,61,-1,-1,-1,0,-1,-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1];
yaml.type.YBinary.BASE64_CHARTABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("");
yaml.type.YBool.YAML_IMPLICIT_BOOLEAN_MAP = (function($this) {
	var $r;
	var hash = new haxe.ds.StringMap();
	hash.set("true",true);
	hash.set("True",true);
	hash.set("TRUE",true);
	hash.set("false",false);
	hash.set("False",false);
	hash.set("FALSE",false);
	$r = hash;
	return $r;
}(this));
yaml.type.YBool.YAML_EXPLICIT_BOOLEAN_MAP = (function($this) {
	var $r;
	var hash = new haxe.ds.StringMap();
	hash.set("true",true);
	hash.set("True",true);
	hash.set("TRUE",true);
	hash.set("false",false);
	hash.set("False",false);
	hash.set("FALSE",false);
	hash.set("y",true);
	hash.set("Y",true);
	hash.set("yes",true);
	hash.set("Yes",true);
	hash.set("YES",true);
	hash.set("n",false);
	hash.set("N",false);
	hash.set("no",false);
	hash.set("No",false);
	hash.set("NO",false);
	hash.set("on",true);
	hash.set("On",true);
	hash.set("ON",true);
	hash.set("off",false);
	hash.set("Off",false);
	hash.set("OFF",false);
	$r = hash;
	return $r;
}(this));
yaml.type.YFloat.YAML_FLOAT_PATTERN = new EReg("^(?:[-+]?(?:[0-9][0-9_]*)\\.[0-9_]*(?:[eE][-+][0-9]+)?" + "|\\.[0-9_]+(?:[eE][-+][0-9]+)?" + "|[-+]?[0-9][0-9_]*(?::[0-5]?[0-9])+\\.[0-9_]*" + "|[-+]?\\.(?:inf|Inf|INF)" + "|\\.(?:nan|NaN|NAN))$","iu");
yaml.type.YInt.YAML_INTEGER_PATTERN = new EReg("^(?:[-+]?0b[0-1_]+" + "|[-+]?0[0-7_]+" + "|[-+]?(?:0|[1-9][0-9_]*)" + "|[-+]?0x[0-9a-fA-F_]+" + "|[-+]?[1-9][0-9_]*(?::[0-5]?[0-9])+)$","iu");
yaml.type.YNull.YAML_NULL_MAP = (function($this) {
	var $r;
	var hash = new haxe.ds.StringMap();
	hash.set("~",true);
	hash.set("null",true);
	hash.set("Null",true);
	hash.set("NULL",true);
	$r = hash;
	return $r;
}(this));
yaml.type.YTimestamp.YAML_TIMESTAMP_REGEXP = new EReg("^([0-9][0-9][0-9][0-9])" + "-([0-9][0-9]?)" + "-([0-9][0-9]?)" + "(?:(?:[Tt]|[ \\t]+)" + "([0-9][0-9]?)" + ":([0-9][0-9])" + ":([0-9][0-9])" + "(?:\\.([0-9]*))?" + "(?:[ \\t]*(Z|([-+])([0-9][0-9]?)" + "(?::([0-9][0-9]))?))?)?$","iu");
yaml.util.Ints.BASE = "0123456789abcdefghijklmnopqrstuvwxyz";
Main.main();
})();

//# sourceMappingURL=index.js.map