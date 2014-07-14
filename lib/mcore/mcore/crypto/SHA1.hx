/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package mcore.crypto;


/**
	Port of SHA1 encryption algorithm for Haxe
	
		var sha1 = new SHA1();
		var output = sha1.b64_hmac_sha1(key, "")

	@link http://en.wikipedia.org/wiki/SHA-1
**/
#if !(sys||neko||cpp)

class SHA1 
{
	var chrsz:Int;
	var b64pad:String;

	public function new()
	{ 
		chrsz = 8;
		b64pad  = "";
	}
	
	public function b64_hmac_sha1(key:String, data:String):String
	{ 
		var temp = core_hmac_sha1(key, data);
		var dr = binb2b64(temp);
		
		dr = dr + "=";
		
		return dr;
	}
	
	function binb2b64(binarray:Dynamic):String
	{
		var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		var str = "";
		var i:Int = 0;

		while (i < (binarray.length * 4))
		{
			var triplet = (((binarray[i   >> 2] >> 8 * (3 -  i   %4)) & 0xFF) << 16)
						| (((binarray[i+1 >> 2] >> 8 * (3 - (i+1)%4)) & 0xFF) << 8 )
						|  ((binarray[i+2 >> 2] >> 8 * (3 - (i+2)%4)) & 0xFF);
			for (j in 0...4)
			{
				if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
				else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
			}
			
			i += 3;
		}

		return str;
	}
	
	function core_hmac_sha1(key:String, data:String)
	{
		var bkey = str2binb(key);
		var ipad = new Array<Dynamic>();
		var opad = new Array<Dynamic>();
		
		for(i in 0...16)
		{
			ipad[i] = bkey[i] ^ 0x36363636;
			opad[i] = bkey[i] ^ 0x5C5C5C5C;
		}
		
		var map = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
		return core_sha1(opad.concat(map), 512 + 160);
	}
	
	function core_sha1(x:Array<Dynamic>, len:Int):Array<Int>
	{
		x[len >> 5] |= 0x80 << (24 - len % 32);
		x[((len + 64 >> 9) << 4) + 15] = len;
		
		var w = new Array<Dynamic>();
		var a =  1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d =  271733878;
		var e = -1009589776;

		var i = 0;
		while(i < x.length)
		{
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			var olde = e;
			
			for(j in 0...80)
			{
				if (j < 16) {
					w[j] = x[i + j];
				}
				else {
					w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
				}
				var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
				e = d;
				d = c;
				c = rol(b, 30);
				b = a;
				a = t;
			}
			
			a = safe_add(a, olda);
			b = safe_add(b, oldb);
			c = safe_add(c, oldc);
			d = safe_add(d, oldd);
			e = safe_add(e, olde);
			
			i += 16;
		}
		
		var tempArray = [a, b, c, d, e];
		return tempArray;
	}

	function safe_add(x:Int, y:Int):Int
	{
		var lsw = (x & 0xFFFF) + (y & 0xFFFF);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return (msw << 16) | (lsw & 0xFFFF);
	}
	
	function rol(num, cnt)
	{
		return (num << cnt) | (num >>> (32 - cnt));
	}
	
	/**
		Note: Neko has no Bitwise NOT operator (~), so (~b) needs to be calculated using haxe.Int32
	**/
	function sha1_ft(t:Int, b:Int, c:Int, d:Int):Int
	{
		if(t < 20)
		{
			return (b & c) | ((~b) & d);
		}
		if(t < 40) return b ^ c ^ d;
		if(t < 60) return (b & c) | (b & d) | (c & d);
		return b ^ c ^ d;
	}

	function sha1_kt(t:Int):Int
	{
		return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 : (t < 60) ? -1894007588 : -899497514;
	}

	function str2binb(str:String):Array<Dynamic>
	{
		var bin = new Array<Dynamic>();
		var mask = (1 << chrsz) - 1;
		
		for (i in 0...str.length)
		{
			var temp = i * chrsz;
			var charCodeIndex = Std.int(temp / chrsz);
			bin[temp >> 5] |= (str.charCodeAt(charCodeIndex) & mask) << (32 - chrsz - temp % 32);
		}
		
		return bin;
	}
}
#end
