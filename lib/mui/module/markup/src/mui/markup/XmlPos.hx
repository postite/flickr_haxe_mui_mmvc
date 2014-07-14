package mui.markup;

class XmlPos
{
	public var source:String;
	public var min:Int;
	public var max:Int;
	public var xml:Xml;

	public function new(source:String, min:Int=0, max:Int=-1)
	{
		this.source = source;
		this.min = source.indexOf("<", min);
		this.max = source.lastIndexOf(">", max > -1 ? max : source.length) + 1;
		this.xml = Xml.parse(source.substring(this.min, this.max)).firstElement();
	}

	public function get(name:String):String
	{
		return xml.get(name);
	}

	public function attributes():Iterator<{name:String, min:Int, max:Int}>
	{
		var itr = xml.attributes();
		return
		{
			next:function()
			{
				return attributePos(itr.next());
			},
			hasNext:itr.hasNext
		};
	}

	public function elements():Iterator<XmlPos>
	{
		var element = firstElement();
		return
		{
			next:function()
			{
				var e = element;
				element = firstElementAfter(element.max);
				return e;
			},
			hasNext:function()
			{
				return element != null;
			}
		};
	}

	public function firstElement():XmlPos
	{
		return firstElementAfter(source.indexOf("<", this.min + 1));
	}

	function firstElementAfter(index:Int):XmlPos
	{
		if (index == -1) return null;
		var tag = new EReg("(</?)[^</>]+(/?>)", "");
		var str = source.substring(index, this.max);
		
		if (tag.match(str))
		{
			var pos = tag.matchedPos();
			var min = index + pos.pos;
			var length = pos.len;

			if (tag.matched(2) == "/>")
			{
				return new XmlPos(source, min, min + length);
			}
			else if (tag.matched(1) == "</")
			{
				return null;
			}
			else
			{
				var depth = 1;
				str = tag.matchedRight();

				while (depth > 0)
				{
					if (tag.match(str))
					{
						if (tag.matched(1) == "</")
						{
							depth -= 1;
						}
						else if (tag.matched(2) != "/>")
						{
							depth += 1;
						}

						var pos = tag.matchedPos();
						length += pos.pos + pos.len;
						str = tag.matchedRight();
					}
					else break;
				}

				return new XmlPos(source, min, min + length);
			}
		}

		return null;
	}

	public function attributePos(name:String):{name:String, min:Int, max:Int}
	{
		var min = source.indexOf(name + "=", this.min);
		var max = source.indexOf('"', min + name.length + 2) + 1;
		return {name:name, min:min, max:max};
	}
}
