package com.jamwix;

import openfl.net.SharedObject;

class HXParsePersistance
{
	private static var _so:SharedObject;

	public function new() 
	{ 
		if (_so == null) _so = SharedObject.getLocal("parse");
	}

	public function setCookies(cookies:Array<String>)
	{
		_so.data.cookies = cookies;
		_so.flush();
	}

	public function cookies():Array<String>
	{
		return _so.data.cookies;
	}

	public function user():Dynamic
	{
		return _so.data.user;
	}

	public function setUser(user:Dynamic)
	{
		_so.data.user = user;
		_so.flush();
	}

	public function sessionToken():String
	{
		if (_so.data.user != null) return _so.data.user.sessionToken;
		return null;
	}
}
