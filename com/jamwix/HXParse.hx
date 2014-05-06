package com.jamwix;

import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.ErrorEvent;
import nme.events.IOErrorEvent;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.net.URLRequestMethod;
import nme.net.URLRequestHeader;

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
