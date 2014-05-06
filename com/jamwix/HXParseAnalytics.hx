
package com.jamwix;

import haxe.Json;
import nme.net.URLRequestMethod;

import com.jamwix.HXParseRequest;

class HXParseAnalytics
{
	static public function trackEvent(name:String, dimensions:Dynamic) 
	{ 
		var request:HXParseRequest = new HXParseRequest(
			'events/' + name, 
			URLRequestMethod.POST, 
			dimensions
		);
	}
}

