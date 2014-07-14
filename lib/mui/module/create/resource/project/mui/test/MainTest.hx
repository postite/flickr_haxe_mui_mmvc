import massive.munit.Assert;

class MainTest 
{
	public function new(){}

	@Test
	public function failing_test():Void
	{
		Assert.isTrue(false);
	}
}
