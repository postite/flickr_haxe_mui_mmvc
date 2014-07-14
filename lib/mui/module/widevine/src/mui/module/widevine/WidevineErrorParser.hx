package mui.module.widevine;

class WidevineErrorParser
{
	public static function parse(error:String):String
	{
		var result:String = "";
		var code:String = "";
		var charCode:Null<Int>;
		var numChars:Int = error.length;
		
		for (i in 0...numChars)
		{
			charCode = error.charCodeAt(i);
			if (charCode >= 48 && charCode <= 57)
			{
				code += error.charAt(i);
			}
			else if (code.length > 0)
			{
				result += translateErrorCode(Std.parseInt(code)) + error.charAt(i);
				code = "";
			}
			else
			{
				result += error.charAt(i);
			}
			
			if (code.length > 0 && (i + 1) == numChars) 
				result += translateErrorCode(Std.parseInt(code));
		}
		
		return result;
	}
	
	static function translateErrorCode(code:Int):String
	{
		return switch (code)
		{
			case 400: "Bad Request";
			case 401: "Unauthorized";
			case 404: "Not Found";
			case 405: "Method Not Allowed";
			case 408: "Request Timeout";
			case 415: "Unsupported Media Type";
			case 416: "Requested Range Not Satisfiable";
			case 451: "Invalid Parameter";
			case 454: "Session Not Found";
			case 455: "Method Not Valid In This State";
			case 457: "Invalid Range";
			case 461: "Unsupported Transport";
			case 462: "Destination Unreachable";
			case 463: "Terminate Requested";
			case 500: "Internal Server Error";
			case 501: "Not Implemented";
			case 503: "Service Unavailable";
			case 504: "Service Response Error";
			
			// WidevineMediaKit
			case 1000: "End Of Media";
			case 1001: "Invalid Data Format";
			case 1002: "Invalid Data Version";
			case 1003: "Parse Error";
			case 1004: "Tamper Detected";
			case 1005: "Truncated Media";
			case 1006: "WVMK Internal Error";
			case 1007: "Entitlement Error";
			case 1008: "Key Error";
			case 1009: "Value Out Of Range";
			case 1010: "System Error";
			case 1011: "Invalid Response";
			case 1012: "Unsupported Transport Type";
			case 1013: "FileSystem Error";
			case 1014: "User Cancel";
			case 1015: "Invalid State";
			case 1016: "Invalid Piggyback File";
			case 1017: "Configuration Error";
			case 1018: "Error No Adaptive Tracks";
			case 1019: "Invalid Credentials";
			case 1020: "Initialization Failed";
			case 1021: "Already Initialized";
			case 1022: "Not Initialized";
			case 2000: "Warning Download Stalled";
			case 2001: "Warning Need Key";
			case 2002: "Warning Not Available";
			case 2003: "Checking Bandwidth";
			case 2004: "Error Download Stalled";
			case 2005: "Error Need Key";
			case 2006: "Error Out Of Memory";
			case 2007: "Uninitialized";
			case 2008: "Internal Error";
			case 2009: "Error Invalid Chapter";
			case 2010: "Heartbeat Configuration Error";
			case 2011: "Invalid Keybox";

			// Progressive Download
			case 3000: "PDL Invalid State";
			case 3001: "PDL Invalid Path";
			case 3002: "PDL Already Exists";
			case 3003: "PDL Invalid Track";

			// License Manager
			case 4001: "License Manager Out Of Memory";
			case 4002: "License Manager License Absent";
			case 4003: "License Manager License Expired";
			case 4004: "License Manager License Corrupted";
			case 4005: "License Manager License Optional Fields Missing";
			case 4006: "License Manager Outside License Window";
			case 4007: "License Manager Outside Purchase Window";
			case 4008: "License Manager Outside Distribution Window";
			case 4009: "License Manager DataStore Corrupted";
			case 4010: "License Manager DataStore Read Failed";
			case 4011: "License Manager DataStore Write Failed";
			case 4012: "License Manager DataStore File Does Not Exist";
			case 4013: "License Manager Clock Tamper Detected";
			case 4014: "License Manager No EMMs Present";
			case 4015: "License Manager CACGI Error";
			case 4016: "License Manager Asset Not Registered";
			case 4017: "License Manager License Revoked";
			case 4018: "License Manager CACGI Status Error";
			
			default: Std.string(code);
		}
	}
}