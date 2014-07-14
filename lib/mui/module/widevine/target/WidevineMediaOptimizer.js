var WidevinePlugin;

var scripts = document.getElementsByTagName('script');
var query = scripts[scripts.length - 1].src.replace(/^[^\?]+\??/,'');

var widevine = function() {
	
    // Version of plugin pointed by the installer
    var version = "5.0.0.000";
    var ie_version = "5,0,0,000";
	
    function doDetect( type, value  ) {
        return eval( 'navigator.' + type + '.toLowerCase().indexOf("' + value + '") != -1' );
    }
	
    function detectMac()     { return doDetect( "platform", "mac" );}
    function detectWin32()   { return doDetect( "platform", "win32" );}
    function detectIE()      { return doDetect( "userAgent", "msie" ); }
    function detectFirefox() { return doDetect( "userAgent", "firefox" ); }
    function detectSafari()  { return doDetect( "userAgent", "safari" ); }
    function detectChrome()  { return doDetect( "userAgent", "chrome" ); }
	
    function detectVistaOrWindows7()   { return doDetect( "userAgent", "windows nt 6" ); }
	
    function getCookie(c_name)
    {
        if (document.cookie.length>0)
            {
                var c_start=document.cookie.indexOf(c_name + "=")
                    if (c_start!=-1)
                        {
                            c_start=c_start + c_name.length+1;
                            c_end=document.cookie.indexOf(";",c_start);
                            if (c_end==-1) c_end=document.cookie.length;
                            return unescape(document.cookie.substring(c_start,c_end))
                        }
            }
        return ""
    }
	
    function setCookie(c_name,value,expireseconds)
    {
        var exdate=new Date();
        exdate.setSeconds(exdate.getSeconds()+expireseconds);
        document.cookie=c_name+ "=" +escape(value)+
            ((expireseconds==null) ? "" : ";expires="+exdate.toGMTString())
    }

    /////////////////////////////////////////////////////////////////////////////////
    // Start debug output section
    // Used to write debug information to the screen if debug variable is set to true.
    // Only used by test page
    /////////////////////////////////////////////////////////////////////////////////

    function writeDebugCell( name, bold ) {
        if ( bold ) {
            return "<td><b>" + name + "</b></td>";
        } else {
            return "<td><s>" + name + "</s></td>";
        }
    }
    
    function writeDebugMimeArray( values ){
        var result = "";
        for ( value in values ) {
            if ( values[value] ) {
                result += "<td><table><tr><td>" + values[value].description + "</td></tr><tr><td>"+values[value].type+"</td></tr><tr><td>"+values[value].enabledPlugin+"</td></tr></table></td>";
            }
        }
        return result;
    }
    
    function DebugInfo() {
        var result = "";
        result += "<table border=1>";
            
        result += "<tr><td>Platform</td>";
        result += writeDebugCell( "Macintosh", detectMac() );
        result += writeDebugCell( "Windows", detectWin32() );
        if ( detectWin32() ) {
            result += writeDebugCell( "Vista/Windows7", detectVistaOrWindows7() );
        }
        result += "</tr>";
            
        result += "<tr><td>Browser</td>";
        result += writeDebugCell( "IE", detectIE() );
        result += writeDebugCell( "Firefox", detectFirefox() );
        result += writeDebugCell( "Safari", detectSafari() );
        result += writeDebugCell( "Chrome", detectChrome() );
        result += "</tr>";
            
        if ( !detectIE() ) {
            result += "<tr><td>MIME types</td>";
            result += writeDebugMimeArray( navigator.mimeTypes );
            result += "</tr>";
        }

        result += "<tr><td>Installed</td><td>";
        if ( navigator.mimeTypes['application/x-widevinemediaoptimizer'] ) {
            var aWidevinePlugin = document.getElementById('WidevinePlugin');
            if ( aWidevinePlugin ) {
                result += aWidevinePlugin.GetVersion();
            } else {
                result += "MIME type exists but could not load plugin";
            }
        } else {
            result += "MIME Type Not Found";
        }
        result += "</td></tr>";
            
        result += "</table>";
        return result;
    }
   
    /////////////////////////////////////////////////////////////////////////////////
    // End debug output section
    // Used to write debug information to the screen if debug variable is set to true.
    // Only used by test page
    /////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////
	// AddDiv
	//
	// Adds a div to the html page
	// html: html to place in the div
	////////////////////////////////////////////
	function AddDiv( containerId, html, replace ) {
		var container = document.getElementById(containerId);
		if(replace === true)
		{
			container.innerHTML = html;
		}
		else
		{
			var div = document.createElement( "div" );
			div.id = "widevine";
			div.style.width = div.style.height = '1px';
			div.innerHTML = html;
			container.insertBefore(div, container.firstChild);
		}
		// can't hide as it's needed to display install plugin msg
		//div.style.position = "absolute";
		//div.style.top = div.style.left = "-999px";
		//div.style.width = div.style.height = '1px';
		//var wv = document.getElementById('widevine');
		//wv.insertBefore(div, wv.firstChild);
		//wv.appendChild(div);
		//document.body.appendChild( div );
		//div.innerHTML = html;
		//return div;
	}

   	////////////////////////////////////////////
	// showDownloadPageText
	//
	// Returns button to download page
	////////////////////////////////////////////
	function showDownloadPageText() {
		return 	"<div style='width: 100%; height: 100%; color: white; background-color: black'>" +
			"<div align='center'>" +
			"<h2>Widevine Video Optimizer is not installed</h2>" +
			"<input type='button' value='Get Video Optimizer' OnClick='javascript: window.open(\"http://tools.google.com/dlpage/widevine\");'>" +
			"</div>" +
			"</div>"
	}

	////////////////////////////////////////////
	// pluginInstalledIE
	//
	// Returns true is the plugin is installed
	////////////////////////////////////////////
	function pluginInstalledIE(){
		try{
			var o = new ActiveXObject("npwidevinemediaoptimizer.WidevineMediaTransformerPlugin");
			o = null;
			return true;
		}catch(e){
			return false;
		}
	}

	// Public API
    return {
		pluginInstalledIE: function() {
			return pluginInstalledIE();
		},
		
		flashVersion: function() {
			return current_ver;
		},
		
		init: function(containerId, signon_url, log_url, emm_url, portal) {
			
			var container = document.getElementById(containerId);
			if(container == null) {
				console.log("WidevineMediaOptimizer.js: ERROR unable to find div with id '"+containerId+"'");
				return;
			}
			
			if (detectIE() && pluginInstalledIE()) {
				AddDiv(containerId, 
						'<object id="WidevinePlugin" classid=CLSID:defa762b-ebc6-4ce2-a48c-32b232aac64d ' +
							'hidden=true style="display:none" height="0" width="0">' +
							'<param name="default_url" value="' + signon_url + '">' +
							'<param name="emm_url" value="' + emm_url + '">' +
							'<param name="log_url" value="' + log_url + '">' +
							'<param name="portal" value="' + portal + '">' +
							'<param name="user_agent" value="' + navigator.userAgent + '">' +
						'</object>', false);
				WidevinePlugin = document.getElementById('WidevinePlugin');
			} else if (navigator.mimeTypes['application/x-widevinemediaoptimizer']) {
				setCookie("FirefoxDisabledCheck", "");
				AddDiv(containerId, 
						'<embed id="WidevinePlugin" type="application/x-widevinemediaoptimizer" default_url="' + signon_url +
							'" emm_url="' + emm_url +
							'" log_url="' + log_url +
							'" portal="' + portal +
							'" height="0" width="0' +
							'" user_agent="' + navigator.userAgent +
						'">', false);
				WidevinePlugin = document.getElementById('WidevinePlugin');
			}
			else {
				AddDiv(containerId, showDownloadPageText(), true);
			}

			return WVPluginAvailable();
		}
    };
}();

// TODO: Moves these out of global scope and into widevine package above
function WVPluginAvailable() {

    if (WidevinePlugin == null) {
        return false;
    }
    // Confirm the plugin is available after embedding (it's possible to be embedded but not available if it or it's parent are set to display:none)
    if (typeof(WidevinePlugin.Translate) === "undefined") {
        console.error("WidevineMediaOptimizer: plugin is embedded however it's unavailable. This may be because it or a parent is set to display:none.");
        return false;
    }

	return true;
}

function WVEmbedPlugin(playerDivId, signOnUrl, logUrl, emmUrl, portal) {
	var embedded = widevine.init(playerDivId, signOnUrl, logUrl, emmUrl, portal);
    if (embedded === true) {
        return WVPluginAvailable();
    }
	return false;
}

function WVGetURL( arg ) {
	try {
		transformedUrl = WidevinePlugin.Translate( arg );
	}
	catch (err) {
		//return "Error calling Translate: " + err.description;
	}
	return transformedUrl;
}
     
function WVGetCommURL () {
	try {
		return WidevinePlugin.GetCommandChannelBaseUrl();
	} catch (err) {
		//alert("Error calling GetCommandChannelBaseUrl: " + err.description);
	}
	return "http://localhost:20001/cgi-bin/";
}

function WVSetPlayScale( arg ) {
	try {
		return WidevinePlugin.SetPlayScale( arg );
	}
	catch (err) {
		//alert ("Error calling SetPlayScale: " + err.description);
	}
	return 0;
}

function WVGetMediaTime( arg ) {
	try {
		return WidevinePlugin.GetMediaTime( arg );
	} catch (err) {
		//alert("Error calling GetMediaTime: " + err.description);
	}
	return 0;
}

function WVGetClientId() {
	try {
		return WidevinePlugin.getClientId();
	}
	catch (err) {
		//alert ("Error calling GetClientId: " + err.description);
	}
	return 0;
}

function WVSetDeviceId(arg) {
	try {
		return WidevinePlugin.setDeviceId(arg);
	}
	catch (err) {
		//alert ("Error calling SetDeviceId: " + err.description);
	}
	return 0;
}

function WVSetStreamId(arg) {
	try {
		return WidevinePlugin.setStreamId(arg);
	}
	catch (err) {
		//alert ("Error calling SetStreamId: " + err.description);
	}
	return 0;
}

function WVSetClientIp(arg) {
	try {
		return WidevinePlugin.setClientIp(arg);
	}
	catch (err) {
		//alert ("Error calling SetClientIp: " + err.description);
	}
	return 0;
}

function WVSetEmmURL(arg) {
	try {
		return WidevinePlugin.setEmmUrl(arg);
	}
	catch (err) {
		//alert ("Error calling SetEmmURL: " + err.description);
	}
	return 0;
}


function WVSetEmmAckURL(arg) {
	try {
		return WidevinePlugin.setEmmAckUrl(arg);
	}
	catch (err) {
		//alert ("Error calling SetEmmAckUrl: " + err.description);
	}
	return 0;
}

function WVSetHeartbeatUrl(arg) {
	try {
		return WidevinePlugin.setHeartbeatUrl(arg);
	}
	catch (err) {
		//alert ("Error calling SetHeartbeatUrl: " + err.description);
	}
	return 0;
}

function WVSetHeartbeatPeriod(arg) {
	try {
		return WidevinePlugin.setHeartbeatPeriod(arg);
	}
	catch (err) {
		//alert ("Error calling SetHeartbeatPeriod: " + err.description);
	}
	return 0;
}

function WVSetOptData(arg) {
	try {
		return WidevinePlugin.setOptData(arg);
	}
	catch (err) {
		//alert ("Error calling SetOptData: " + err.description);
	}
	return 0;
}

function WVSetPortal(arg) {
	try {
		return WidevinePlugin.setPortal(arg);
	}
	catch (err) {
		//alert ("Error calling SetPortal: " + err.description);
	}
	return 0;
}

function WVGetDeviceId() {
	try {
		return WidevinePlugin.getDeviceId();
	}
	catch (err) {
		//alert ("Error calling GetDeviceId: " + err.description);
	}
	return 0;
}

function WVGetStreamId() {
	try {
		return WidevinePlugin.getStreamId();
	}
	catch (err) {
		//alert ("Error calling GetStreamId: " + err.description);
	}
	return 0;
}

function WVGetClientIp() {
	try {
		return WidevinePlugin.getClientIp();
	}
	catch (err) {
		//alert ("Error calling GetClientIp: " + err.description);
	}
	return 0;
}

function WVGetEmmURL() {
	try {
		return WidevinePlugin.getEmmUrl();
	}
	catch (err) {
		//alert ("Error calling GetEmmURL: " + err.description);
	}
	return "";
}

function WVGetEmmAckURL() {
	try {
		return WidevinePlugin.getEmmAckUrl();
	}
	catch (err) {
		//alert ("Error calling GetEmmAckUrl: " + err.description);
	}
	return "";
}

function WVGetHeartbeatUrl() {
	try {
		return WidevinePlugin.getHeartbeatUrl();
	}
	catch (err) {
		//alert ("Error calling GetHeartbeatUrl: " + err.description);
	}
	return "";
}

function WVGetHeartbeatPeriod() {
	try {
		return WidevinePlugin.getHeartbeatPeriod();
	}
	catch (err) {
		//alert ("Error calling GetHeartbeatPeriod: " + err.description);
	}
	return "";
}

function WVGetOptData() {
	try {
		return WidevinePlugin.getOptData();
	}
	catch (err) {
		//alert ("Error calling GetOptData: " + err.description);
	}
	return "";
}

function WVGetPortal() {
	try {
		return WidevinePlugin.getPortal();
	}
	catch (err) {
		//alert ("Error calling GetPortal: " + err.description);
	}
	return "";
}

function WVAlert( arg ) {
	alert(arg);
    return 0;
}

function WVPDLNew(mediaPath, pdlPath) {
	try {
		pdl_new =  WidevinePlugin.PDL_New(mediaPath, pdlPath);
		return pdl_new;
	}
	catch (err) {
		//alert ("Error calling PDL_New: " + err.description);
	}
	return "";
}

function WVPDLStart(pdlPath, trackNumber, trickPlay) {
	try {
		return WidevinePlugin.PDL_Start(pdlPath, trackNumber, trickPlay);
	}
	catch (err) {
		//alert ("Error calling PDL_Start: " + err.description);
	}
	return "";
}

function WVPDLResume(pdlPath) {
	try {
		return WidevinePlugin.PDL_Resume(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_Resume: " + err.description);
	}
	return "";
}

function WVPDLStop(pdlPath) {
	try {
		return WidevinePlugin.PDL_Stop(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_Stop: " + err.description);
	}
	return "";
}

function WVPDLCancel(pdlPath) {
	try {
		return WidevinePlugin.PDL_Cancel(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_Stop: " + err.description);
	}
	return "";
}

function WVPDLGetProgress(pdlPath) {
	try {
		return WidevinePlugin.PDL_GetProgress(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_GetProgress: " + err.description);
	}
	return "";
}


function WVPDLGetTotalSize(pdlPath) {
	try {
		return WidevinePlugin.PDL_GetTotalSize(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_GetTotalSize: " + err.description);
	}
	return "";
}

function WVPDLFinalize(pdlPath) {
	try {
		return WidevinePlugin.PDL_Finalize(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_Finalize: " + err.description);
	}
	return "";
}

function WVPDLCheckHasTrickPlay(pdlPath) {
	try {
		return WidevinePlugin.PDL_CheckHasTrickPlay(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_CheckHasTrickPlay: " + err.description);
	}
	return "";
}

function WVPDLGetTrackBitrate(pdlPath, trackNumber) {
	try {
		return WidevinePlugin.PDL_GetTrackBitrate(pdlPath, trackNumber);
	}
	catch (err) {
		//alert ("Error calling PDL_GetTrackBitrate: " + err.description);
	}
	return "";
}

function WVPDLGetTrackCount(pdlPath) {
	try {
		return WidevinePlugin.PDL_GetTrackCount(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_GetTrackCount: " + err.description);
	}
	return "";
}

function WVPDLGetDownloadMap(pdlPath) {
	try {
		return WidevinePlugin.PDL_GetDownloadMap(pdlPath);
	}
	catch (err) {
		//alert ("Error calling PDL_GetDownloadMap: " + err.description);
	}
	return "";
}

function WVGetLastError() {
	try {
		return WidevinePlugin.GetLastError();
	}
	catch (err) {
		//alert ("Error calling GetLastError: " + err.description);
	}
	return "";
}

function WVRegisterAsset(assetPath, requestLicense) {
	try {
		return WidevinePlugin.RegisterAsset(assetPath, requestLicense);
	}
	catch (err) {
		//alert ("Error calling RegisterAsset: " + err.description);
	}
	return "";

}


function WVQueryAsset(assetPath) {
	try {
		return WidevinePlugin.QueryAsset(assetPath);
	}
	catch (err) {
		//alert ("Error calling QueryAsset: " + err.description);
	}
	return "";
}

function WVQueryAllAssets() {
	try {
		return WidevinePlugin.QueryAllAssets();
	}
	catch (err) {
		//alert ("Error calling QueryAllAssets: " + err.description);
	}
	return "";
}

function WVUnregisterAsset(assetPath) {
	try {
		return WidevinePlugin.UnregisterAsset(assetPath);
	}
	catch (err) {
		//alert ("Error calling UnregisterAsset: " + err.description);
	}
	return "";
}

function WVUpdateLicense(assetPath) {
	try {
		return WidevinePlugin.UpdateLicense(assetPath);
	}
	catch (err) {
		//alert ("Error calling UpdateAssetLicense: " + err.description);
	}
	return "";

}

function WVGetQueryLicenseValue(assetPath, key) {
	var licenseInfo = eval('(' + WVQueryAsset(assetPath) + ')');
	licenseInfo = eval("licenseInfo." + key);
	return licenseInfo;
}

function WVCancelAllDownloads() {
	try {
		if (WidevinePlugin){
			var downloading_list = eval(aWidevinePlugin.PDL_QueryDownloadNames());
			for(var i = 0; i < downloading_list.length; i++){
				WVPDLCancel(downloading_list[i]);
			}
		}
	}
	catch (err) {
		//alert ("Error calling QueryAllAssets: " + err.description);
	}
	return "";
}


function WVSetJSON(value) {
	try {
		return WidevinePlugin.setUseJSON(value);
	}
	catch (err) {
		//alert ("Error calling setUseJSON: " + err.description);
	}
	return "";

}

function WVSetAudioTrack(trackid) {
	try {
		var result = WidevinePlugin.SetAudioTrack(parseInt(trackid));
		if(!result){
				alert('Set Audio Track Failed');
		}
		return result;
	}
	catch (err) {
		//alert ("Error calling : SetAudioTrack" + err.description);
	}
	return "";
}

function WVGetAudioTracks() {
	try {
		return WidevinePlugin.GetAudioTracks();
	}
	catch (err) {
		//alert ("Error calling : GetAudioTracks " + err.description);
	}
	return "";
}

function WVGetCurrentAudioTrack() {
	try {
		return WidevinePlugin.GetCurrentAudioTrack();
	}
	catch (err) {
		  //alert ("Error calling : GetCurrentAudioTrack " + err.description);
	}
	return "";
}

function WVGetSubtitles() {
	try {
		return WidevinePlugin.GetSubtitleTracks();
	}
	catch (err) {
		//alert ("Error calling : GetSubtitleTracks " + err.description);
	}
	return "";
}
