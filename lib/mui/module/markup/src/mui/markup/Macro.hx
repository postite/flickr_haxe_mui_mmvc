package mui.markup;

#if macro

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import sys.FileSystem;

class Macro
{
	static var map = new Hash<String>();
	static var currentPath:String;

	public static function build()
	{
		map.set("Button", "mui.control.Button");
		map.set("Container", "mui.core.Container");
		map.set("Collection", "mui.core.Collection");

		map.set("AssetDisplay", "mui.display.AssetDisplay");
		map.set("Rectangle", "mui.display.Rectangle");
		map.set("Color", "mui.display.Color");
		map.set("Gradient", "mui.display.Gradient");
		map.set("GradientColor", "mui.display.GradientColor");
		map.set("Text", "mui.display.Text");
		map.set("Icon", "mui.display.Icon");
		
		readTypes();
		// readType("markup/test/TestItem.xml");
	}

	static function readTypes(?dir:String="")
	{
		for (entry in FileSystem.readDirectory("src/" + dir))
		{
			var full = entry;
			if (dir != "") full = dir + "/" + full;

			if (sys.FileSystem.isDirectory("src/" + full))
			{
				readTypes(full);
			}
			else
			{
				if (StringTools.endsWith(full, ".xml"))
				{
					readType(full);
				}
			}
		}
	}

	static function buildType():Array<Field>
	{
		var fields = Context.getBuildFields();
		var file = Context.getPosInfos(Context.currentPos()).file;
		var type = Context.getLocalClass().get();

		var id = type.pack.concat([type.name]).join(".");
		dontBuild.set(id, true);

		file = file.split(".")[0] + ".xml";
		if (sys.FileSystem.exists(file))
		{
			var parts = file.split("/");
			parts.shift();
			file = parts.join("/");
			fields = fields.concat(readType(file));
		}
		return fields;
	}

	static var properties:Array<Field>;
	static var dontBuild = new Hash<Bool>();
	static var currentType:String;

	static function readType(path:String)
	{
		properties = [];

		var pack = path.split(".")[0].split("/");
		var name = pack.pop();
		var id = pack.concat([name]).join(".");

		currentPath = "src/" + path;
		
		var content = neko.io.File.getContent(currentPath);
		var xml = new XmlPos(content);

		var exprs = [];
		var pos = getPos(xml);

		var superPack = getTypeID(xml.xml).split(".");
		var superName = superPack.pop();
		var superID = superPack.concat([superName]).join(".");

		currentType = superID;

		// call super constructor
		exprs.push(makeExpr("super.buildMarkup()", xml));
		
		// make self t var
		exprs.push({expr:EVars([{name:"t", type:null, expr:makeExpr("this", xml)}]), pos:getPos(xml)});
		// exprs.push(makeExpr("var t = this", xml));

		// parse elements
		exprs = exprs.concat(parseElements(xml));

		// parse attributes
		exprs = exprs.concat(parseAttributes(xml));

		// create build method
		var buildMarkup = {pos:pos, name:"buildMarkup", meta:[], doc:null, access:[APublic, AOverride], kind:FFun({
			ret:null, params:[], expr:{expr:EBlock(exprs), pos:pos}, args:[]
		})}

		// merge fields
		var fields = properties.concat([buildMarkup]);

		try
		{
			// if the type exists, then it's a code behind, so return the build field for injection
			Context.getType(id);
			return fields;
		}
		catch (e:Dynamic) {}

		if (dontBuild.exists(id)) return fields;
		
		// define type from scratch
		Context.defineType
		({
			pos:pos,
			params:[],
			pack:pack,
			meta:[],
			name:name,
			isExtern:false,
			kind:TDClass({sub:null, params:[], pack:superPack, name:superName}, [], false),
			fields:fields
		});

		return fields;
	}

	static function makeMethod(name:String, expr:Expr, pos:Position)
	{
		return ;
	}

	static function getTypeID(xml:Xml):String
	{
		if (!map.exists(xml.nodeName)) trace("Not found: " + xml.nodeName);
		return map.get(xml.nodeName);
	}

	static function getPos(pos:{min:Int, max:Int}):Position
	{
		return Context.makePosition({min:pos.min, max:pos.max, file:currentPath});
	}

	static function makeExpr(expr:String, pos:{min:Int, max:Int}):Expr
	{
		return Context.parse(expr, getPos(pos));
	}

	/**
	Parses a type definition from Xml into an expr
	*/
	static function parseType(xml:XmlPos):Expr
	{
		var exprs = [];

		// add the type constructor expression
		exprs.push({expr:EVars([{name:"t", type:null, expr:makeExpr("new " + getTypeID(xml.xml) + "()", xml)}]), pos:getPos(xml)});
		
		// parse elements
		exprs = exprs.concat(parseElements(xml, "t."));

		// parse attributes
		exprs = exprs.concat(parseAttributes(xml, "t."));

		// yield instance
		exprs.push(makeExpr("t", xml));

		// return expressions wrapped in block, yielding id
		return {expr:EBlock(exprs), pos:getPos(xml)};
	}

	/**
	Parses the attributes of an xml into an array of expressions setting each 
	corresponding property on the parsed instance. The format of each attribute 
	value is checked against the type of the parsed instance property so that, 
	for example, setting an Int property to a String will error.
	*/
	static function parseAttributes(xml:XmlPos, ?scope:String="", ?type:String):Array<Expr>
	{
		var exprs = [];

		// get type to validate values
		if (type == null) type = getTypeID(xml.xml);

		// for each attribute
		for (attribute in xml.attributes())
		{
			var value = xml.get(attribute.name);

			// check for id, which creates a field on the built type and assigns the instance to it
			if (attribute.name == "id")
			{
				var pack = type.split(".");
				var name = pack.pop();
				var property = {pos:getPos(attribute), name:value, meta:[], doc:null, access:[APublic], kind:FVar(
					ComplexType.TPath({sub:null, params:[], pack:pack, name:name}))};
				properties.push(property);
				exprs.push(makeExpr(value + " = t", attribute));
				continue;
			}

			// check for binding
			if (value.charAt(0) == "{" && value.charAt(value.length - 1) == "}")
			{
				value = value.substr(1, value.length - 2);

				var idents = new Hash<Bool>();
				var ids = getIdents(makeExpr(value, attribute), idents);
				var flags = [];

				for (id in idents.keys())
				{
					if (getIDFieldType(currentType, id) != null) flags.push("f." + id);
				}

				if (value == "label.height")
				{
					flags = ["f.height"];
					Sys.println("label.changed.add(function(f){if(" + flags.join("||") + ")t." + attribute.name + "=" + value + ";})");
					var listener = "label.changed.add(function(f){if(" + flags.join("||") + ")t." + attribute.name + "=" + value + ";})";
					exprs.push(makeExpr(listener, attribute));
				}
				else if (flags.length == 0)
				{
					exprs.push(makeExpr(scope + attribute.name + " = " + value, attribute));
				}
				else
				{
					var listener = "changed.add(function(f){if(" + flags.join("||") + ")t." + attribute.name + "=" + value + ";})";
					exprs.push(makeExpr(listener, attribute));
				}
				
				continue;
			}

			// look up the type of property being set
			var fieldType = getIDFieldType(type, attribute.name);
			
			if (fieldType == null)
			{
				Context.error("Cannot set field '" + attribute.name + "' of instance '" + type + "' because it does not exist!", getPos(attribute));
			}

			// validate value
			value = validateValue(value, type, fieldType, attribute);

			// set property on instance
			exprs.push(makeExpr(scope + attribute.name + " = " + value, attribute));
		}

		return exprs;
	}

	static function parseElements(xml:XmlPos, ?scope:String=""):Array<Expr>
	{
		var exprs = [];
		
		// for each child element
		for (element in xml.elements())
		{
			var name = element.xml.nodeName;
			
			// if node name begins with lowercase letter
			if (name.charAt(0).toLowerCase() == name.charAt(0))
			{
				var type = getTypeID(xml.xml);
				var fieldType = getIDFieldType(getTypeID(xml.xml), name);
				
				if (fieldType == FArray)
				{
					var values = [];
					for (value in element.elements()) values.push(parseType(value));
					var decl = {expr:EArrayDecl(values), pos:getPos(element)};

					// set property "name" of instance to parsed types of child elements
					exprs.push({expr:EBinop(OpAssign, makeExpr(scope + name, element), decl), pos:getPos(element)});
				}
				else
				{
					if (element.xml.firstElement() == null)
					{
						if (fieldType == null)
						{
							Context.error("Cannot set field '" + name + "' of instance '" + type + "' because it does not exist!", getPos(element));
						}

						var path = switch (fieldType)
						{
							case FPath(path): path;
							default: "error";
						}

						// set properties on existing instance
						exprs = exprs.concat(parseAttributes(element, scope + name + ".", path));
					}
					else
					{
						// set property "name" of instance to parsed type of first element
						exprs.push({expr:EBinop(OpAssign, makeExpr(scope + name, element), parseType(element.firstElement())), pos:getPos(element)});
					}
				}
			}
			else
			{
				// else add parsed type as child of instance
				exprs.push({expr:ECall(makeExpr(scope + "addChild", element), [parseType(element)]), pos:getPos(element)});
			}
		}

		return exprs;
	}

	static function validateValue(value:String, type:String, fieldType:FieldType, attribute:{name:String, min:Int, max:Int}):String
	{
		switch (fieldType)
		{
			case FInt:
			if (!validInt(value))
				Context.error("Cannot set field '" + attribute.name + "' of instance '" + type + "' to value '" + value + "' because it cannot be parsed into an Int", getPos(attribute));

			case FFloat:
			if (!validFloat(value))
				Context.error("Cannot set field '" + attribute.name + "' of instance '" + type + "' to value '" + value + "' because it cannot be parsed into a Float", getPos(attribute));

			case FString:
			value = '"' + value + '"';

			case FBool:
			if (!validBool(value))
				Context.error("Cannot set field '" + attribute.name + "' of instance '" + type + "' to value '" + value + "' because it cannot be parsed into a Bool", getPos(attribute));

			case FNull(t):
				if (value != "null") return validateValue(value, type, t, attribute);

			case FUnknown(t):
				trace("unknown property type " + t + " for field " + attribute.name + " of " + type);

			default:
		}

		return value;
	}

	static function validInt(value:String):Bool
	{
		var parsed = Std.parseInt(value);

		if (StringTools.startsWith(value, "0x"))
		{
			return value.toLowerCase() == "0x" + StringTools.hex(parsed, value.length - 2).toLowerCase();
		}
		else
		{
			return value == Std.string(parsed);
		}
	}

	static function validFloat(value:String):Bool
	{
		return Std.string(Std.parseFloat(value)) == value;
	}

	static function validBool(value:String):Bool
	{
		return value == "false" || value == "true";
	}

	static function getIDFieldType(id:String, name:String):FieldType
	{
		return switch (haxe.macro.Context.follow(haxe.macro.Context.getType(id)))
		{
			case TInst(t, params): getFieldType(t.get(), name);
			default: throw "Could not find type '" + id + "'"; null;
		}
	}

	static function getFieldType(type:ClassType, name:String):FieldType
	{
		for (field in type.fields.get())
		{
			if (field.name != name) continue;

			switch (field.kind)
			{
				case FVar(read, write): return getType(field.type);
				default: throw "Unexpected field type " + field.kind + "for field '" + name + "' of type '" + type.name + "'";
			}
		}

		if (type.superClass != null)
		{
			return getFieldType(type.superClass.t.get(), name);
		}

		return null;
	}

	static function getType(type:Type):FieldType
	{
		return switch (type)
		{
			case TType(t, params): switch (t.get().name)
			{
				case "Int": FInt;
				case "Float": FFloat;
				case "String": FString;
				case "Array": FArray;
				case "Null": FNull(getType(params[0]));
				default:
					FPath(t.get().pack.concat([t.get().name]).join("."));
			}
			case TInst(t, params): switch (t.get().name)
			{
				case "Int": FInt;
				case "Float": FFloat;
				case "String": FString;
				case "Array": FArray;
				case "Null": FNull(getType(params[0]));
				case "Class":
					var path = switch(getType(params[0]))
					{
						case FPath(path): path;
						default: "unknown";
					}
					FClass(path);
				default:
					var type = t.get();
					FPath(type.pack.concat([type.name]).join("."));
			}
			case TEnum(t, params): switch (t.get().name)
			{
				case "Bool": FBool;
				default: FUnknown(t.get().name);
			}
			case TDynamic(t): FDynamic;
			default: FUnknown(type);
		}
	}

	static function getIdents(expr:Expr, idents:Hash<Bool>)
	{
		switch (expr.expr)
		{
			case EBinop(op, e1, e2):
				getIdents(e1, idents);
				getIdents(e2, idents);
			case EParenthesis(e):
				getIdents(e, idents);
			case ETernary(econd, eif, eelse):
				getIdents(econd, idents);
				getIdents(eif, idents);
				getIdents(eelse, idents);
			case EField(e, field):
				getIdents(e, idents);
			case ECall(e, params):
				getIdents(e, idents);
				for (e in params) getIdents(e, idents);
			case EConst(c): switch (c)
			{
				case CIdent(s): idents.set(s, true);
				default:
			}
			default:
		}
	}
}

enum FieldType
{
	FArray;
	FFloat;
	FInt;
	FBool;
	FString;
	FNull(t:FieldType);
	FUnknown(t:Dynamic);
	FPath(path:String);
	FDynamic;
	FClass(path:String);
}

#end
