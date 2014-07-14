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

package mdata;

/**
	A fomalized, strongly typed API for creating class instances. Factories use 
	generics to provide a strongly typed object creation method.
**/
class Factory<T>
{
	/**
		Creates a factory for a given type.
		
		@param type The class to create a factory for.
		@return A factory for the type.
	*/
	public static function forType<T>(type:Class<T>):Factory<T>
	{
		return new Factory<T>(type);
	}

	var forClass:Class<T>;

	function new(forClass:Class<T>)
	{
		this.forClass = forClass;
	}

	/**
		Create an instance of the factories type.

		@param args Arguments to be provided to the types constructor.
	*/
	public function create(?args:Array<Dynamic>):T
	{
		if (args == null) args = [];
		return mcore.util.Types.createInstance(forClass, args);
	}
}
