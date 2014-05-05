package com.jamwix;

class HXParseUtils
{
	private static var _symbols:String = 
		"abcdef0123456789";

	static public function genUUID():String
	{
		var uuid:StringBuf = new StringBuf();
		var symLen:Int = _symbols.length;
		for (i in 0...8)
		{
			uuid.add(_symbols.charAt(Std.random(symLen)));
		}
		uuid.add('-');

		for (i in 0...4)
		{
			uuid.add(_symbols.charAt(Std.random(symLen)));
		}
		uuid.add('-');
		
		for (i in 0...4)
		{
			uuid.add(_symbols.charAt(Std.random(symLen)));
		}
		uuid.add('-');
		
		for (i in 0...4)
		{
			uuid.add(_symbols.charAt(Std.random(symLen)));
		}
		uuid.add('-');
		
		for (i in 0...12)
		{
			uuid.add(_symbols.charAt(Std.random(symLen)));
		}
		return uuid.toString();
	}
}
