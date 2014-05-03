package com.jamwix;

import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.ErrorEvent;
import nme.events.IOErrorEvent;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.net.URLVariables;
import nme.net.URLRequestMethod;
import nme.net.URLRequestHeader;

import haxe.Json;

import com.jamwix.HXParseConfig;

class HXParseRequest extends EventDispatcher
{

	private var _loader:URLLoader;
	private var _cb:Dynamic->Void;

	public function new(url:String, ?method:String = URLRequestMethod.GET, 
						?data:String = null, ?cb:Dynamic->Void = null) 
	{ 
		super();

		var request:URLRequest = parseRequest(url, method, data);
		_loader = new URLLoader();
		_cb = cb;

		if (_cb != null) addListeners();
		_loader.load(request);
	}
	
	private function parseRequest(url:String, method:String, ?data:String = null):URLRequest
	{
		var request:URLRequest = new URLRequest(HXParseConfig.BASEURL + url);
		trace("URL: " + request.url);
		request.requestHeaders = 
		[
			new URLRequestHeader("X-Parse-Application-Id", HXParseConfig.APPID),
			new URLRequestHeader("X-Parse-REST-API-Key", HXParseConfig.CLIENTKEY)
		];

		if (method == URLRequestMethod.POST || method == URLRequestMethod.PUT)
			request.contentType = 'application/json';

		request.method = method;

		// TODO: try catch recommended
		if (data != null)
			request.data = data;

		//request.verbose = true;
		
		return request;
	}

	private function addListeners():Void
	{
		_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.addEventListener(Event.COMPLETE, onComplete);
	}

	private function removeListeners():Void
	{
		_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.removeEventListener(Event.COMPLETE, onComplete);
	}

	private function onComplete(?e:Event):Void
	{
		removeListeners();
		if (_cb != null) _cb({data: _loader.data});
	}

	private function onError(?e:IOErrorEvent):Void
	{
		removeListeners();
		if (_cb != null) _cb({err: e.text, code: e.errorID});
	}
}
