package com.jamwix;

import nme.events.Event;
import nme.events.EventDispatcher;

class HXParse extends EventDispatcher
{
	private static var parseConnect = cpp.Lib.load("HXParse", "parseConnect", 2);

	public function new() { super(); }
	public function connect(appId:String, clientKey:String):Void
	{
		parseConnect(appId, clientKey);
	}
}
