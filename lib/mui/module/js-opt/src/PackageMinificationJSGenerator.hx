/*
 * Copyright (c) 2005-2010, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package ;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.JSGenApi;
import haxe.macro.Compiler;
import haxe.macro.Context;
import PackageMinification;
using Lambda;

class PackageMinificationJSGenerator {

	var api : JSGenApi;
	var buf : StringBuf;
	var inits : List<TypedExpr>;
	var statics : List<{ c : ClassType, f : ClassField }>;
	var packages : Hash<Bool>;
	var forbidden : Hash<Bool>;



	public function new(api) {
		this.api = api;
		buf = new StringBuf();
		inits = new List();
		statics = new List();
		packages = new Hash();
		forbidden = new Hash();
		for( x in ["prototype", "__proto__", "constructor"] )
			forbidden.set(x, true);
		api.setTypeAccessor(getType);
	}

	function getType( t : Type ) {
		return switch(t) {
			case TInst(c, _): getPath(c.get());
			case TEnum(e, _): getPath(e.get());
			default: throw "assert";
		};
	}

	inline function print(str) {
		buf.add(str);
	}

	inline function newline() {
		buf.add(";\n");
	}

	inline function genExpr(e) {
		print(api.generateExpr(e));
	}

	@:macro static function fprint( e : Expr ) {
		switch( e.expr ) {
		case EConst(c):
			switch( c ) {
			case CString(str):
				var exprs = [];
				var r = ~/%((\([^\)]+\))|([A-Za-z_][A-Za-z0-9_]*))/;
				var pos = e.pos;
				var inf = Context.getPosInfos(pos);
				inf.min++; // string quote
				while( r.match(str) ) {
					var left = r.matchedLeft();
					if( left.length > 0 ) {
						exprs.push( { expr : EConst(CString(left)), pos : pos } );
						inf.min += left.length;
					}
					var v = r.matched(1);
					if( v.charCodeAt(0) == "(".code ) {
						var pos = Context.makePosition( { min : inf.min + 2, max : inf.min + v.length, file : inf.file } );
						exprs.push(Context.parse(v.substr(1, v.length-2), pos));
					} else {
						var pos = Context.makePosition( { min : inf.min + 1, max : inf.min + 1 + v.length, file : inf.file } );
						exprs.push( { expr : EConst(CIdent(v)), pos : pos } );
					}
					inf.min += v.length + 1;
					str = r.matchedRight();
				}
				exprs.push({ expr : EConst(CString(str)), pos : pos });
				var ret = null;
				for( e in exprs )
					if( ret == null ) ret = e else ret = { expr : EBinop(OpAdd, ret, e), pos : pos };
				return { expr : ECall({ expr : EConst(CIdent("print")), pos : pos },[ret]), pos : pos };
			default:
			}
		default:
		}
		Context.error("Expression should be a constant string", e.pos);
		return null;
	}

	function field(p) {
		return api.isKeyword(p) ? '["' + p + '"]' : "." + p;
	}

	function genPackage( p : Array<String> ) {
		var full = null;
		for( x in p ) {
			var prev = full;
			if( full == null ) full = x else full += "." + x;
			if( packages.exists(full) )
				continue;
			packages.set(full, true);
			if( prev == null )
				fprint("if(typeof %x=='undefined') %x = {}");
			else {
				var p = prev + field(x);
				fprint("if(!%p) %p = {}");
			}
			newline();
		}
	}

	function getPath( t : BaseType ) {
		return (t.pack.length == 0) ? t.name : t.pack.join(".") + "." + t.name;
	}

	function checkFieldName( c : ClassType, f : ClassField ) {
		if( forbidden.exists(f.name) )
			Context.error("The field " + f.name + " is not allowed in JS", c.pos);
	}

	function genClassField( c : ClassType, p : String, f : ClassField ) {
		checkFieldName(c, f);
		var field = field(f.name);
		fprint("%p.prototype%field = ");
		if( f.expr == null )
			print("null");
		else {
			api.setDebugInfos(c, f.name, false);
			print(api.generateExpr(f.expr));
		}
		newline();
	}

	function genStaticField( c : ClassType, p : String, f : ClassField ) {
		checkFieldName(c, f);
		var field = field(f.name);
		if( f.expr == null ) {
			fprint("%p%field = null");
			newline();
		} else switch( f.kind ) {
		case FMethod(_):
			fprint("%p%field = ");
			api.setDebugInfos(c, f.name, true);
			genExpr(f.expr);
			newline();
		default:
			statics.add( { c : c, f : f } );
		}
	}

	function genClass( c : ClassType ) {
		genPackage(c.pack);
		var p = getPath(c);
		fprint("%p = ");
		api.setDebugInfos(c, "new", false);
		if( c.constructor != null )
			print(api.generateConstructor(c.constructor.get().expr));
		else
			print("function() { }");
		newline();
		var name = p.split(".").map(api.quoteString).join(",");
		fprint("%p.__name__ = [%name]");
		newline();
		if( c.superClass != null ) {
			var psup = getPath(c.superClass.t.get());
			fprint("%p.__super__ = %psup");
			newline();
			fprint("for(var k in %psup.prototype ) %p.prototype[k] = %psup.prototype[k]");
			newline();
		}

		var reg:EReg = ~/^Cl[0-9]/; //Class matches 'Cl123'

		var isMatch = reg.match(p);

		var ff = c.statics.get();
		if(isMatch) ff.reverse();
		for( f in  ff)
			genStaticField(c, p, f);

		ff = c.fields.get();
		if(isMatch) ff.reverse();

		for( f in ff ) {
			switch( f.kind ) {
			case FVar(r, _):
				if( r == AccResolve ) continue;
			default:
			}
			genClassField(c, p, f);
		}
		fprint("%p.prototype.__class__ = %p");
		newline();
		if( c.interfaces.length > 0 ) {
			var me = this;
			var inter = c.interfaces.map(function(i) return me.getPath(i.t.get())).join(",");
			fprint("%p.__interfaces__ = [%inter]");
			newline();
		}
	}

	function genEnum( e : EnumType ) {
		genPackage(e.pack);
		var p = getPath(e);
		var names = p.split(".").map(api.quoteString).join(",");
		var constructs = e.names.map(api.quoteString).join(",");
		fprint("%p = { __ename__ : [%names], __constructs__ : [%constructs] }");
		newline();
		for( c in e.constructs.keys() ) {
			var c = e.constructs.get(c);
			var f = field(c.name);
			fprint("%p%f = ");
			switch( c.type ) {
			case TFun(args, _):
				var sargs = args.map(function(a) return a.name).join(",");
				fprint('function(%sargs) { var $x = ["%(c.name)",%(c.index),%sargs]; $x.__enum__ = %p; $x.toString = $estr; return $x; }');
			default:
				print("[" + api.quoteString(c.name) + "," + c.index + "]");
				newline();
				fprint("%p%f.toString = $estr");
				newline();
				fprint("%p%f.__enum__ = %p");
			}
			newline();
		}
		var meta = api.buildMetaData(e);
		if( meta != null ) {
			fprint("%p.__meta__ = ");
			genExpr(meta);
			newline();
		}
	}


	function genStaticValue( c : ClassType, cf : ClassField ) {
		var p = getPath(c);
		var f = field(cf.name);
		fprint("%p%f = ");
		genExpr(cf.expr);
		newline();
	}

	function genType( t : Type ) {
		switch( t ) {
		case TInst(c, _):
			var c = c.get();
			if( c.init != null )
				inits.add(c.init);
			if( !c.isExtern ) genClass(c);
		case TEnum(r, _):
			var e = r.get();
			if( !e.isExtern ) genEnum(e);
		default:
		}
	}

	public function generate() {
		print("$estr = function() { return js.Boot.__string_rec(this,''); }");
		newline();
		/*
		(match ctx.namespace with
		| None -> ()
		| Some ns ->
			print ctx "if(typeof %s=='undefined') %s = {}" ns ns;
			newline ctx);
		*/
		for( t in api.types )
			genType(t);
		print("$_ = {}");
		newline();
		print("js.Boot.__res = {}");
		newline();
		if( Context.defined("debug") ) {
			fprint("%(api.stackVar) = []");
			newline();
			fprint("%(api.excVar) = []");
			newline();
		}
		print("js.Boot.__init()");
		newline();
		for( e in inits ) {
			genExpr(e);
			newline();
		}
		for( s in statics ) {
			genStaticValue(s.c,s.f);
			// newline();
		}
		if( api.main != null ) {
			genExpr(api.main);
			newline();
		}

		var output = buf.toString();


		output = replaceEnumReferences(output,PackageMinification.ENUMS);
		output = replaceEnumReferences(output,PackageMinification.PRIVATE_ENUMS);
		output = replacePrivateClassReferences(output,PackageMinification.PRIVATE_CLASSES);

		output = replacePackagesForIgnoredItems(output, PackageMinification.INGORED);

		var file = neko.io.File.write(api.outputFile, true);
		file.writeString(output);
		file.close();
	}


	static function replacePrivateClassReferences(output:String, path:String):String
	{
		if(!neko.FileSystem.exists(path)) return output;

		var contents = neko.io.File.getContent(path);

		var classes = contents.split("\n");

		for(cls in classes)
		{
			if(cls == "") continue;

			var a = cls.split("|"); //format : foo.com._Bar.Foo|C123
			var oldName = a[0];
			var newName = a[1];

		
			//replace qualified paths with new name
			output = StringTools.replace(output, oldName, newName);

			//replace string rep of enum (e.g. foo.com._Bar.Foo.__name__ = ["foo", "com", "_Bar", "Foo"])
			var pckgs = oldName.split(".");


			var oldParts = "[\"" + pckgs.join("\",\"") + "\"]";
			var newParts = "[\"" + newName + "\"]";
			
			output = StringTools.replace(output, oldParts, newParts);

			pckgs.pop();

			var pckg = "";

			while(pckgs.length > 0)
			{
				if(pckg != "") pckg += ".";
				pckg += pckgs.shift();
				output = StringTools.replace(output, "if(!" + pckg + ") " + pckg + " = {};\n", "");

			}	
		}

		//neko.FileSystem.deleteFile("temp/enums.tmp");

		return output;

	}

	static function replaceEnumReferences(output:String, path:String):String
	{
		if(!neko.FileSystem.exists(path)) return output;

		var enumFile = neko.io.File.getContent(path);

		var enums = enumFile.split("\n");

		for(en in enums)
		{
			if(en == "") continue;

			var a = en.split("|"); //format : foo.com.Bar|E123
			var oldName = a[0];
			var newName = a[1];

		
			//replace qualified paths with new name
			output = StringTools.replace(output, oldName, newName);

			//replace string rep of enum (e.g. foo.bar.MyEnum = { __ename__ : ["foo", "bar", "MyEnum"])
			var pckgs = oldName.split(".");


			var oldParts = "[\"" + pckgs.join("\",\"") + "\"]";
			var newParts = "[\"" + newName + "\"]";
			
			output = StringTools.replace(output, oldParts, newParts);

			pckgs.pop();

			var pckg = "";

			while(pckgs.length > 0)
			{
				if(pckg != "") pckg += ".";
				pckg += pckgs.shift();
				output = StringTools.replace(output, "if(!" + pckg + ") " + pckg + " = {};\n", "");

			}	
		}

		//neko.FileSystem.deleteFile("temp/enums.tmp");

		return output;

	}

	static function replacePackagesForIgnoredItems(output:String, path:String):String
	{
		if(!neko.FileSystem.exists(path)) return output;

		var contents = neko.io.File.getContent(path);

		var classes = contents.split("\n");

		var paths:Hash<String> = new Hash();

		for(cls in classes)
		{
			if(cls == "") continue;
			var pckgs = cls.split(".");
			pckgs.pop();

			var pckg = "";

			while(pckgs.length > 0)
			{
				if(pckg != "") pckg += ".";
				pckg += pckgs.shift();

				if(!paths.exists(pckg)) paths.set(pckg, pckg);
			}	
		}

		var a = Lambda.array(paths);

		a.sort(strSort);

		var packages = "";

		for(pckg in a)
		{
			if(pckg.indexOf(".") == -1) packages += pckg + " = {};\n";
			else packages += "if(" + pckg + "==null) " + pckg + " = {};\n";
		}
		return packages + output;

	}

	static function strSort(a:String, b:String):Int
	{
	    a = a.toLowerCase();
	    b = b.toLowerCase();
	    if (a < b) return -1;
	    if (a > b) return 1;
	    return 0;
	}



	/*
	if(typeof massive=='undefined') massive = {};
if(!m.ui) m.ui = {};
if(!m.ui.core) m.ui.core = {};
En257 = { __ename__ : ["massive","ui","core","ButtonEvent"], __constructs__ : ["BUTTON_ACTIONED"] };
*/

	#if macro
	public static function use() {
		Compiler.setCustomJSGenerator(function(api) new PackageMinificationJSGenerator(api).generate());
	}
	#end

}