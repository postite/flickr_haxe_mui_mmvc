/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package mcore.util;

import Type;
using Reflect;
using Type;

/**
	Utility methods for working with dynamic objects
**/
class Dynamics
{
	/**
		Creates a deep copy of an object by merging it with an empty 
		anonymous object. Class instances are not cloned, but have their 
		fields copied to anonymous objects.

		@param object 		object to be copied
		@return deep copy of original object
	**/
	public static function copy<T>(object:T):T
	{
		return merge({}, object);
	}

	/**
		Recursively copies the fields of one object to another.
		
		@param to 			the object to copy to
		@param from 		the object to copy from
		@param overwrite 	whether to overwrite existing properties on the target
		@param copyNulls 	whether to copy null values to the target
	**/
	public static function merge(to:Dynamic, from:Dynamic, ?overwrite:Bool=true, ?copyNulls=true):Dynamic
	{
		var fromFields = Reflection.getFields(from);

		for (field in fromFields)
		{
			var fromField = from.field(field);
			var toField = to.field(field);
			
			if (!Std.is(fromField, String) && !Std.is(fromField, Array) && (Type.typeof(fromField) == TObject || Type.getClass(fromField) != null))
			{
				if (Type.typeof(toField) != TObject)
				{
					if (overwrite)
					{
						toField = {};
						to.setField(field, toField);
						merge(toField, fromField, overwrite);
					}
				}
				else
				{
					merge(toField, fromField, overwrite);
				}
			}
			else
			{
				if (toField == null || overwrite && !toField.isFunction())
				{
					if (fromField != null || copyNulls)
					{
						to.setProperty(field, fromField);
					}
				}
			}
		}
		
		return to;
	}

	/**
		Resolved a property within an object hiearchy recursively from a string property path.
		
		Example:
		
			var a = {b:{c:1}};
			resolve(a, "b.c"); // 1

		@param object 		the object to search
		@param fields 		the property path to resolve
		@return the property if found
		@throws mcore.exception.TypeException if the property cannot be resolved
	**/
	public static function resolve(object:{}, field:String):Dynamic
	{
		var fields = field.split(".");
		
		while (fields.length > 0)
		{
			field = fields.shift();
			
			if (object.hasField(field))
			{
				object = object.field(field);
			}
			else
			{
				throw new mcore.exception.TypeException("Field " + field + " not found on object " + Std.string(object));
			}
		}
		
		return object;
	}
}
