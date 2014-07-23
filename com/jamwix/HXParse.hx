package com.jamwix;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.ErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLRequestHeader;

import haxe.Json;

import com.jamwix.HXParseRequest;
import com.jamwix.HXParseConfig;

class HXParse extends EventDispatcher
{
	public function new(appID:String, clientKey:String) 
	{ 
		super();
		HXParseConfig.APPID = appID;
		HXParseConfig.CLIENTKEY = clientKey;
	}
}
