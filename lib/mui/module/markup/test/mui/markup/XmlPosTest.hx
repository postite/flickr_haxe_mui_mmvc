package mui.markup;

import massive.munit.Assert;

class XmlPosTest 
{
	public function new(){}

	@Test
	public function element_with_no_children_does_not_iterate():Void
	{
		var i = 0;
		var xml = new XmlPos("<node/>");
		for (element in xml.elements())
		{
			trace(element.xml);
			i ++;
		}
		Assert.areEqual(0, i);
	}

	@Test
	public function element_with_one_child_iterates():Void
	{
		var i = 0;
		var xml = new XmlPos("<node><node/></node>");
		for (element in xml.elements()) i ++;
		Assert.areEqual(1, i);
	}

	@Test
	public function element_with_n_children_iterates():Void
	{
		var i = 0;
		var xml = new XmlPos("<node><node/><node/><node/></node>");
		for (element in xml.elements()) i ++;
		Assert.areEqual(3, i);
	}
}
