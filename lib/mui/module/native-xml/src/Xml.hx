/*
 * Copyright (c) 2005, The haXe Project Contributors
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

enum XmlType {
}

@:core_api class Xml {

	public static var Element(default,null):XmlType;
	public static var PCData(default,null):XmlType;
	public static var CData(default,null):XmlType;
	public static var Comment(default,null):XmlType;
	public static var DocType(default,null):XmlType;
	public static var Prolog(default,null):XmlType;
	public static var Document(default,null):XmlType;

	static var types:Array<XmlType>;

	var dom:Dynamic;

	public var nodeType(default,null):XmlType;

	public var parent(getParent,null):Xml;
	function getParent() { return new Xml(dom.parentNode); }

	public var nodeName(getNodeName,setNodeName):String;
	function getNodeName() { return dom.nodeName; }
	function setNodeName(value:String) { return value; }

	public var nodeValue(getNodeValue,setNodeValue):String;
	function getNodeValue() { return dom.nodeValue; }
	function setNodeValue(value:String) { return value; }

	public static function parse(data:String):Xml
	{
		var dom = untyped __js__("new DOMParser().parseFromString(data,'text/xml');");
		return new Xml(dom);
	}
	
	function new(dom:Dynamic)
	{
		this.dom = dom;
		nodeType = switch (dom.nodeType)
		{
			case 1: Element;
			case 4: CData;
			case 7: PCData;
			case 8: Comment;
			case 9: Document;
			case 10: DocType;
		}
	}

	public function elementsNamed(name:String):Array<Xml>
	{
		var elements:Array<Dynamic> = dom.getElementsByTagName(name);
		var result:Array<Xml> = [];
		
		for (element in elements)
		{
			result.push(new Xml(element));
		}
		
		return result;
	}
	
	public function elements():Array<Xml>
	{
		var elements:Array<Dynamic> = dom.childNodes;
		var result:Array<Xml> = [];
		
		for (element in elements)
		{
			if (element.nodeType == 1)
			{
				result.push(new Xml(element));
			}
		}
		
		return result;
	}
	
	public function firstElement():Xml
	{
		var elements:Array<Dynamic> = dom.childNodes;
		
		for (element in elements)
		{
			if (element.nodeType == 1)
			{
				return new Xml(element);
			}
		}
		
		return null;
	}
	
	public function firstChild():Xml
	{
		return new Xml(dom.firstChild);
	}
	
	public function length():Int
	{
		return dom.childNodes.length;
	}
	
	public function get(att:String):String
	{
		var attributes:Array<Dynamic> = cast dom.attributes;
		for (attribute in attributes)
		{
			if (attribute.name == att)
			{
				return attribute.value;
			}
		}
		
		return null;
	}
	
	public function toString():String
	{
		var serialized:Dynamic;
		try
		{
			untyped 
			{
				serializer = __js__("new XMLSerializer();");
				serialized = serializer.serializeToString(dom);
			}
		}
		catch (e:Dynamic)
		{
			serialized = dom.xml;
		}
		
		return serialized;
	}

	public static function createElement( name:String ):Xml {
		return new Xml(null);
	}

	public static function createPCData( data:String ):Xml {
		return new Xml(null);
	}

	public static function createCData( data:String ):Xml {
		return new Xml(null);
	}

	public static function createComment( data:String ):Xml {
		return new Xml(null);
	}

	public static function createDocType( data:String ):Xml {
		return new Xml(null);
	}

	public static function createProlog( data:String ):Xml {
		return new Xml(null);
	}

	public static function createDocument():Xml {
		return new Xml(null);
	}

	static function __init__():Void untyped {
		Xml.Element = "element";
		Xml.PCData = "pcdata";
		Xml.CData = "cdata";
		Xml.Comment = "comment";
		Xml.DocType = "doctype";
		Xml.Prolog = "prolog";
		Xml.Document = "document";
	}
}
