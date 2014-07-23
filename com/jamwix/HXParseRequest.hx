package com.jamwix;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.ErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.HTTPStatusEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLVariables;
import openfl.net.URLRequestMethod;
import openfl.net.URLRequestHeader;

import haxe.Json;

import com.jamwix.HXParseConfig;
import com.jamwix.HXParsePersistance;

class HXParseRequest extends EventDispatcher
{

	private var _loader:URLLoader;
	private var _cb:Dynamic->Void;
	private var _persist:HXParsePersistance;
	private var _code:Int = -1;

	public function new(url:String, ?method:String = URLRequestMethod.GET, 
						?data:Dynamic = null, ?cb:Dynamic->Void = null) 
	{ 
		super();

		_persist = new HXParsePersistance();
		var request:URLRequest = parseRequest(url, method, data);
		if (request == null)
		{
			trace("Unable to create URLRequest");
			return;
		}

		_loader = new URLLoader();
		_cb = cb;

		if (_cb != null) addListeners();
		_loader.load(request);
	}
	
	private function parseRequest(url:String, method:String, ?data:Dynamic = null):URLRequest
	{
		var request:URLRequest = new URLRequest(HXParseConfig.BASEURL + url);
		trace("PARSEURL: " + request.url);
		request.requestHeaders = 
		[
			new URLRequestHeader("X-Parse-Application-Id", HXParseConfig.APPID),
			new URLRequestHeader("X-Parse-REST-API-Key", HXParseConfig.CLIENTKEY)
		];

		if (_persist.sessionToken() != null)
		{
			request.requestHeaders.push
			(
				new URLRequestHeader("X-Parse-Session-Token", 
									 _persist.sessionToken())
			);
		}

		if (_persist.cookies() != null)
		{
			request.requestHeaders.push
			(
				new URLRequestHeader("Cookie", _persist.cookies().join("; "))
			);
		}

		if (method == URLRequestMethod.POST || method == URLRequestMethod.PUT)
			request.contentType = 'application/json';

		request.method = method;

		if (data != null)
		{
			if (Std.is(data, Dynamic))
			{
				try 
				{
					request.data = Json.stringify(data);
				}
				catch (msg:String)
				{
					trace("Unable to stringify data: " + msg);
					return null;
				}
			}
			else
			{
				request.data = data;
			}
		}

		request.verbose = true;
		
		return request;
	}

	private function addListeners():Void
	{
		_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.addEventListener(Event.COMPLETE, onComplete);
		_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
	}

	private function removeListeners():Void
	{
		_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.removeEventListener(Event.COMPLETE, onComplete);
		_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
	}

	private function onStatus(?e:HTTPStatusEvent):Void
	{
		if (e == null)
		{
			trace("HTTPSTATUS was null");
			return;
		}

		_code = e.status;
	}

	private function onComplete(?e:Event):Void
	{
		removeListeners();
		var cookieStrs:Array<String> = _loader.getCookies();
		var cookies:Array<String> = new Array<String>();
		for (cookieStr in cookieStrs)
		{
			var cookie:String = parseCookie(cookieStr);
			if (cookie != null) cookies.push(cookie);
		}

		if (cookies != null) 
		{
			trace("COOKIES: " + cookies.join(", "));
			_persist.setCookies(cookies);
		}
		if (_cb != null) _cb({data: _loader.data, code: _code});
	}

	private function parseCookie(cookieLine:String):String
	{
		var reg:EReg = ~/\s+/g;
		var fields:Array<String> = reg.split(cookieLine);
		if (fields.length < 2) return null;
		
		return fields[fields.length - 2] + "=" + fields[fields.length -1];
	}

	private function onError(?e:IOErrorEvent):Void
	{
		removeListeners();
		if (_cb != null) _cb({err: e.text, code: e.errorID});
	}
}
