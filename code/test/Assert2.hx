using massive.munit.Assert;

// Remove and switch to MUnit once they publish a version
// newer than 2.1.2
class Assert2
{
    public static function throws(expectedType:Dynamic, code:Dynamic, ?info:haxe.PosInfos):Dynamic
	{
		try
		{
			code();
			Assert.fail("Expected exception wasn't thrown!", info);
			return null; // needed to compile
		}
		catch (e:Dynamic)
		{
			if (Std.is(e, expectedType))
			{
				return e;
			}
			else
			{
				Assert.fail('Expected exception of type ${Type.getClassName(expectedType)} but got ${Type.getClassName(Type.getClass(e))}: ${e}');
				return null; // needed to compile
			}
		}
	}
}