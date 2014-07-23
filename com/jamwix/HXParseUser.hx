package com.jamwix;

import haxe.Json;
import openfl.net.URLRequestMethod;

import com.jamwix.HXParsePersistance;
import com.jamwix.HXParseRequest;
import com.jamwix.HXParseUtils;

class HXParseUser
{
	private var _persist:HXParsePersistance;

	public var username:String;
	public var createdAt:String;
	public var objectId:String;
	public var sessionToken:String;

	public function new() 
	{ 
		_persist = new HXParsePersistance();
		var user:Dynamic = _persist.user();
		
		if (user == null) return;

		username = user.username;
		createdAt = user.createdAt;
		objectId = user.objectId;
		sessionToken = user.sessionToken;
	}

	private function saveResponse(res:Dynamic):Bool
	{
		if (res == null)
		{
			trace("SAVE RESPONSE NULL");
			return false;
		}

		var code:Int = -1;
		if (res.code != null) code = res.code;

		if (res.err != null)
		{
			// TODO: prolly want to get a new seesion
			if (code == 101)
			{
				trace("INVALID PARSE SESSION");
				return false;
			}

			trace("PARSE API ERROR - CODE: " + code + " MSG: " + res.err);
			return false;
		}

		if (res.data == null)
		{
			trace("RESPONSE DATA NULL");
			return false;
		}

		
		var json:String = res.data;
		var data:Dynamic = null;
		try
		{
			data = Json.parse(json);
		}
		catch(msg:String)
		{
			trace("Unable to parse user data: " + msg);
			return false;
		}

		if (data == null)
		{
			trace("Parsed user json is empty");
			return false;
		}

		if (data.username != null) username = data.username;
		if (data.createdAt != null) createdAt = data.createdAt;
		if (data.objectId != null) objectId = data.objectId;
		if (data.sessionToken != null) sessionToken = data.sessionToken;

		_persist.setUser({
			username: username,
			createdAt: createdAt,
			objectId: objectId,
			sessionToken: sessionToken
		});

		return true;
	}

	public function signupAnonymous(cb:Dynamic->Void = null)
	{
		var uuid:String = HXParseUtils.genUUID();
		var postData:Dynamic = 
		{
			authData: 
			{
				anonymous:
				{
					id: uuid
				}
			}
		};

		var request:HXParseRequest = new HXParseRequest(
			'users', 
			URLRequestMethod.POST, 
			postData,
			function(res:Dynamic) 
			{
				var success = saveResponse(res);
				if (cb != null) cb({success: success, res: res});
			}
		);
	}
}
