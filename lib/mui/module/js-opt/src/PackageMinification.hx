package ;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

/**
* Minifies one or more classes or packages down to smallest possible path
* e.g. 
*		foo.Bar --> C1
*		foo.bar.Cab --> C2
*		foo.BarEnum --> E1
*
*  Notes:
*      1. As haxe macros have bugs with public enums and private classes/enums, these are manually converted in PackageMinificationJSGenerator
*      2. Ingored classes (and/or enums) will be excluded from minification
*      3. Manifests of all conversions are generated in temp/minification/*.tmp
*
* @usage: --macro PackageMinification.include(mainClass, [packages], [classes], [ignoredClasses])
**/
class PackageMinification
{
	static public var TEMP_DIR:String = "temp/minification";
	static public var CLASSES:String =  TEMP_DIR + "/classes.tmp";
	static public var PRIVATE_CLASSES:String =  TEMP_DIR + "/privateClasses.tmp";
	static public var ENUMS:String =  TEMP_DIR + "/enums.tmp";
	static public var PRIVATE_ENUMS:String =  TEMP_DIR + "/privateEnums.tmp";
	static public var INGORED:String =  TEMP_DIR + "/ignored.tmp";
		

	static public var classPathHash:IntHash<String> = new IntHash();

	static public var allClasses:Array<String> = [];
	static public var allEnums:Array<String> = [];
	static public var privateClasses:Hash<String> = new Hash();
	static public var privateEnums:Hash<String> = new Hash();

	static public var ignored:Hash<String> = new Hash();

	static var count:Int = 0;

	static var skip:String -> Bool;


	public static function include(main:String, packages:Array<String>, classes:Array<String>, ignore:Array<String>)
	{
		allClasses.push(main);

		skip = if(null == ignore) {
			function(c) return false;
		} else {
			function(c) return isIgnoredClass(ignore, c);
		}

		for(pckg in packages)
		{
			includePackage(pckg);
		}

		writeOuput();
		
	}

	static function writeOuput()
	{
		if(!neko.FileSystem.exists(TEMP_DIR))
		{
			neko.FileSystem.createDirectory(TEMP_DIR);
		}

		writeOutClasses();
		writeOutEnums();
		writeOutIgnored();
	}

	static function writeOutClasses()
	{
		var total = allClasses.length;
		var chars = Std.string(total).length;

		var buf = new StringBuf();
		var privateBuf = new StringBuf();

		for(i in 0...total)
		{
			var cls = allClasses[i];

			if(ignored.exists(cls)) continue;
			var name = "C" + Std.string(count++);

			buf.add(cls + "|" + name + "\n");

			if(privateClasses.exists(cls))
			{
				var privateCls = privateClasses.get(cls);
				privateBuf.add(privateCls + "|" + name + "\n");
			}

			//trace(name + " ...... " + allClasses[i]);
			Compiler.addMetadata('@:native("' + name + '")', cls);	
		}

		var file = neko.io.File.write(CLASSES, true);
		file.writeString(buf.toString());
		file.close();

		if(Lambda.count(privateClasses) > 0)
		{
			file = neko.io.File.write(PRIVATE_CLASSES, true);
			file.writeString(privateBuf.toString());
			file.close();
		}
	}

	static function writeOutEnums()
	{
		var total = allEnums.length;
		var chars = Std.string(total).length;

		var buf = new StringBuf();
		var privateBuf = new StringBuf();

		count = 0;

		for(i in 0...total)
		{
			var en = allEnums[i];

			if(ignored.exists(en)) continue;

			var name = "E" + Std.string(count++);
			buf.add(en + "|" + name + "\n");

			if(privateEnums.exists(en))
			{
				var privateEn = privateEnums.get(en);
				privateBuf.add(privateEn + "|" + name + "\n");
			}

			//trace(name + " ...... " + allEnums[i]);
			// Compiler.addMetadata('@:native("' + name + '")', allEnums[i]);	
		}

		
		var file = neko.io.File.write(ENUMS, true);
		file.writeString(buf.toString());
		file.close();

		if(Lambda.count(privateEnums) > 0)
		{
			file = neko.io.File.write(PRIVATE_ENUMS, true);
			file.writeString(privateBuf.toString());
			file.close();
		}
	}


	static function writeOutIgnored()
	{
		var buf = new StringBuf();
		
		for(cl in ignored)
		{
			buf.add(cl + "\n");
		}

		var file = neko.io.File.write(INGORED, true);
		file.writeString(buf.toString());
		file.close();
	}


	/**
		Looks for match in ignored class patterns.
		Supports optional '*' wildcards
		e.g. foo.Foo
		e.g. foo.*
		e.g. *.Foo
		
		@return true if ingored
	**/
	static function isIgnoredClass(ignore:Array<String>, clazz:String):Bool
	{
		for(pattern in ignore)
		{
			if(pattern.indexOf("*") == -1)
			{
				 if(clazz == pattern) return true;
				 continue;
			}

			var expr = pattern.split(".").join("\\.");
			expr = expr.split("*").join("(.*)");

			var reg = new EReg(expr, "");

			if(reg.match(clazz)) return true;
		}

		return false;
	}

	/**
		Recursively loops through classpaths and appends @:build metadata into each matching class
		@param pack - package name to filter on (e.g. "com.example"). Use empty string to match all classes ('')
		@param classPaths - zero or more classpaths to include in coverage (defaults to local scope only (''))
		@param ignore - array of classes to exclude from coverage
	**/
	static function includePackage(pack : String)
	{

		var classPaths = Context.getClassPath();
		
		
		var prefix = pack == '' ? '' : pack + '.';
		for( cp in classPaths ) {
			var path = pack == '' ? cp : cp + "/" + pack.split(".").join("/");

			if( !neko.FileSystem.exists(path) || !neko.FileSystem.isDirectory(path) )
				continue;
			
			for( file in neko.FileSystem.readDirectory(path) ) {
				if( StringTools.endsWith(file, ".hx") ) {
					var classes = getClassesInFile(path + "/" + file, prefix);
					for(cl in classes)
					{
						if( skip(cl) )
						{
							ignored.set(cl, cl);
							continue;
						}
							

						allClasses.push(cl);
						//Compiler.addMetadata("@:keep @:build(m.mcover.macro.CoverClassMacro.build())", cl);
					}

					var enums = getEnumsInFile(path + "/" + file, prefix);
					for(en in enums)
					{
						if( skip(en) )
						{
							ignored.set(en, en);
							continue;
						}

						allEnums.push(en);
					}

					// var privateClasses = getPrivateClassesInFile(path + "/" + file);

				} else if(neko.FileSystem.isDirectory(path + "/" + file))
					includePackage(prefix + file);
			}
		}
	}

	static function getClassesInFile(path:String, prefix:String):Array<String>
	{
		var classes:Array<String> = [];
		var contents = neko.io.File.getContent(path);
		var reg:EReg = ~/^(.*)(class|interface)( +)([A-Z]([A-Za-z0-9])+)/;

		var mainClass:String = null;
		
		while(reg.match(contents))
		{
			var cl = reg.matched(4);

			if(reg.matched(1).indexOf("private ") != -1)
			{
				if(mainClass == null)
				{
					mainClass = path.split("/").pop().substr(0, -3);
				}
				privateClasses.set(prefix + cl, prefix + "_" + mainClass + "." + cl);
			}
			classes.push(prefix + cl);
			contents = reg.matchedRight();
		}
		return classes;
	}

	
	static function getEnumsInFile(path:String, prefix:String):Array<String>
	{
		var enums:Array<String> = [];
		var contents = neko.io.File.getContent(path);
		var reg:EReg = ~/^(.*)(enum)( +)([A-Z]([A-Za-z0-9])+)/;

		var mainClass:String = null;

		while(reg.match(contents))
		{
			var en = reg.matched(4);

			if(reg.matched(1).indexOf("private ") != -1)
			{
				if(mainClass == null)
				{
					mainClass = path.split("/").pop().substr(0, -3);
				}
				privateEnums.set(prefix + en, prefix + "_" + mainClass + "." + en);
			}
			enums.push(prefix + en);
			contents = reg.matchedRight();
		}
		return enums;
	}

	static function debug(value:Dynamic, ?posInfos:haxe.PosInfos)
	{

			neko.Lib.println(posInfos.fileName+ ":" + posInfos.lineNumber + ": " + value);

	}
}