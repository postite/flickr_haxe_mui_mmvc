package mui.core;

import haxe.ds.StringMap;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
	Compiler macro for generating getter/setters for node invalidation 
**/
class NodeMacro
{
	#if macro
	static var initializers = new StringMap<Array<Expr>>();

	/**
		Stores a hash of all fields that have been parsed to ensure they only 
		get parsed once, even if macro is added multiple times to a class
	**/
	static var processedTypes = new StringMap<Bool>();

	public static function build()
	{
		var inits = [];
		var pos = haxe.macro.Context.currentPos();

		var fields = haxe.macro.Context.getBuildFields();
		var editable = haxe.macro.Context.defined("editable");

		for (field in fields)
		{
			if (processedTypes.exists(Std.string(field.pos))) continue;

			var input = getMeta(field, ":input");
			if (editable && input != null) field.meta.push({pos:pos, name:"input", params:input.params});

			var meta = getMeta(field, ":set");
			if (meta == null) continue;

			field.meta.push({name:":isVar",params:[],pos:field.pos});

			if (meta.params.length == 0)
			{
				var name = field.name;
				var getter = hasMeta(field, ":get") ? "get_" + name : "default";
				var setter = "set_" + name;
				var type = getType(field);
				var typeName = getTypeName(type);

				if (editable) field.meta.push({pos:pos, name:"type", params:[{pos:pos, expr:EConst(CString(typeName))}]});

				switch (field.kind)
				{
					case FVar(t, e):
					if (e != null)
					{
						var init = {pos:pos, expr:EBinop(OpAssign,
							{pos:pos, expr:EConst(CIdent(name))},
							{pos:pos, expr:e.expr})};
						inits.push(init);
					}
					default:
				}

				field.kind = FProp(getter, setter, type);
				field.access = [APublic];
				
				fields.push({
					pos:pos,
					name:setter,
					meta:[],
					kind:FFun({
						ret:getType(field),
						params:[],
						args:[{
							name:"v",
							type:type,
							opt:false,
							value:null
						}],
						expr:{pos:pos, expr:EBlock([
							{pos:pos, expr:EReturn({pos:pos,expr:
								EBinop(OpAssign,
									{pos:pos, expr:EConst(CIdent(name))},
									{pos:pos, expr:ECall(
										{pos:pos,expr:EConst(CIdent("changeValue"))},
										[
											{pos:pos,expr:EConst(CString(name))},
											{pos:pos,expr:EConst(CIdent("v"))}
										]
									)}
								)
							})}
						])}
					}),
					doc:null,
					access:[]
				});

				if (getter != "default")
				{
					fields.push({
						pos:pos,
						name:getter,
						meta:[],
						kind:FFun({
							ret:getType(field),
							params:[],
							args:[],
							expr:{pos:pos, expr:EBlock([
								{pos:pos, expr:EReturn({pos:pos,expr:EConst(CIdent(name))})}
							])}
						}),
						doc:null,
						access:[]
					});
				}
			}
			else
			{
				var name = field.name;
				var setter = "set_" + name;
				var type = getType(field);

				field.kind = FProp("default", setter, getType(field));
				field.access = [APublic];
				
				var result = EBinop(OpAssign,
					{pos:pos, expr:EConst(CIdent(name))},
					{pos:pos, expr:EConst(CIdent("v"))});

				for (param in meta.params)
				{
					result = EBinop(OpAssign,
					{pos:pos, expr:EConst(CIdent(getString(param.expr)))},
					{pos:pos, expr:result});
				}

				fields.push({
					pos:pos,
					name:setter,
					meta:[],
					kind:FFun({
						ret:getType(field),
						params:[],
						args:[{
							name:"v",
							type:type,
							opt:false,
							value:null
						}],
						expr:{pos:pos, expr:EBlock([
							{pos:pos, expr:EReturn({pos:pos,expr:result})}
						])}
					}),
					doc:null,
					access:[]
				});
			}

			processedTypes.set(Std.string(field.pos), true);
		}

		return fields;
	}

	static function getID(type:Type):String
	{
		return switch (type)
		{
			case TInst(t, params):
			{
				var name = t.get().pack;
				name.push(t.get().name);
				name.join(".");
			}
			default: null;
		}
	}

	static function getType(field:Field):ComplexType
	{
		return switch (field.kind)
		{
			case FVar(t,e): t;
			case FProp(get, set, t, e): t;
			default: null;
		}
	}

	static function getTypeName(type:ComplexType):String
	{
		return switch (type)
		{
			case TPath(t): 
			if (t.name == "Null")
			{
				switch (t.params[0])
				{
					case TPType(a): "Null<" + getTypeName(a) + ">";
					default: null;
				}
				
			}
			else
			{
				(t.pack.length > 0 ? t.pack.join(".") + "." : "") + t.name;
			}
			
			default: "unknown";
		}
	}

	static function hasMeta(field:Field, name:String)
	{
		return getMeta(field, name) != null;
	}

	static function getMeta(field:Field, name:String)
	{
		for (param in field.meta)
		{
			if (param.name == name)
			{
				return param;
			}
		}

		return null;
	}

	static function getString(expr:ExprDef):String
	{
		return switch (expr)
		{
			case EConst(c):
			switch (c)
			{
				case CString(s): s;
				default: null;
			}

		 	default: null;
		}
	}
	#end
}