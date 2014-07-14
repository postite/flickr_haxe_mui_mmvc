package mui.core;

/**
	Creates a `Component` given a specific data object.
**/
class ComponentFactory
{
	/**
		Creates a new `ComponentFactory`
		
		@param component the default Component type the factory will create 
			instances of. This can be a class or a function with the following 
			signature: Component -> Dynamic -> Skin
		@param skin the optional skin class the factory will create an instance 
			of and set on a Component it creates before passing it back
	**/
	public function new(?component:Dynamic, ?skin:Dynamic)
	{
		this.component = component;
		this.skin = skin;
		getComponentType = getDefaultComponentType;
	}
	
	public var component(default, set_component):Dynamic;
	function set_component(value:Dynamic):Dynamic
	{
		return component = value;
	}
	
	public var skin(default, set_skin):Dynamic;
	function set_skin(value:Dynamic):Dynamic
	{
		return skin = value;
	}

	/**
		Set with a function to return the Class type of a Component given
		the data provided.
		
		If `component` is set with a Component type then the default function 
		will return this value.
	**/
	public var getComponentType:Dynamic -> Class<Dynamic>;
	
	function getDefaultComponentType(data:Dynamic):Class<Dynamic>
	{
		return Std.is(component, Class) ? component : null;
	}

	/**
		Factory method to create an instance of a Component given a data object.
		
		@param data the data to create a Component for
		@return	a new instance of a Component
	**/
	public function create(data:Dynamic):Component
	{
		var componentType = getComponentType(data);
		var componentInstance:Component = null;

		mui.util.Assert.that(component != null || componentType != null, "factory component type is `null`");
		
		if (Reflect.isFunction(component))
		{
			componentInstance = Reflect.callMethod(null, component, [data]);
		}
		else if (componentType != null)
		{
			var skinInstance = createSkin(data);
			var params = (skin == null) ? [] : [skinInstance];
			componentInstance = Type.createInstance(componentType, params);
		}
		return componentInstance;
	}
	
	function createSkin(data:Dynamic):Skin<Dynamic>
	{
		var skinInstance:Skin<Dynamic> = null;

		if (Reflect.isFunction(skin))
		{
			skinInstance = Reflect.callMethod(null, skin, [data]);
		}
		else if (Std.is(skin, Class))
		{
			skinInstance = Type.createInstance(skin, []);
		}
		return skinInstance;
	}
	
	/**
		Updates the data on the provided component. Can be overriden to 
		customise behavior in response to different data.
	**/
	public function setData(component:Component, data:Dynamic):Void
	{
		component.data = data;
	}
}
