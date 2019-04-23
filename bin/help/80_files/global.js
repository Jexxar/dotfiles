var callBackAry = [];

var keyDownAry = [];

var Brower = 
{
	check:function(r) {
        return r.test(navigator.userAgent.toLowerCase());
	},
	isIe : function (){
		  return Brower.check(/(msie\s|trident.*rv:)([\w.]+)/);
	},
	/**
	 * 是否为webkit内核的浏览器
	 */
	isWebkit : function() {
	  return Brower.check(/webkit/);
	},
	/**
	 * 是否为UC浏览器
	 */
	isUCBrowser : function() {
	  return Brower.check(/ucbrowser/);
	},
	/**
	 * 是否为搜狗浏览器
	 */
	isSogou : function() {
	  return Brower.check(/se/);
	},
	/**
	 * 是否为遨游浏览器
	 */
	isAoyou : function() {
	  return Brower.check(/aoyou/);
	},
	/**
	 * 是否为世界之窗
	 */
	isTheWorld : function() {
	  return Brower.check(/theworld/);
	},
	/**
	 * 是否为QQ浏览器
	 */
	isQQbrowser : function() {
	  return Brower.check(/qqbrowser/);
	},
	/**
	 * 是否为百度浏览器
	 */
	isBaidu : function() {
	  return Brower.check(/baidu/);
	},
	/**
	 * 是否为绿色浏览器
	 */
	isGreenbrowser : function() {
	  return Brower.check(/greenbrowser/);
	},
	/**
	 * 是否为火狐浏览器
	 */
	isFirefox : function() {
	  return Brower.check(/firefox/);
	},
	/**
	 * 是否为谷歌浏览器
	 */
	isChrome : function() {
	  return !Brower.isOpera() && Brower.check(/chrome/);
	},
	/**
	 * 是否为Opera浏览器
	 */
	isOpera : function() {
	  return Brower.check(/opr/);
	},
	/**
	 * 检测是否为Safari浏览器
	 */
	isSafari : function() {
	  // google chrome浏览器中也包含了safari
	  return !Brower.isChrome() && !Brower.isOpera() && Brower.check(/safari/);
	},
	/**
	 * 获取浏览器版本类型
	 */
	getBrowserType:function (){
		if(Brower.isUCBrowser())
		{
			return "UCBrowser";
		}
		else if(Brower.isGreenbrowser())
		{
			return "Greenbrowser";
		}
		else if(Brower.isBaidu())
		{
			return "Baidu";
		}
		else if(Brower.isQQbrowser())
		{
			return "QQbrowser";
		}
		else if(Brower.isTheWorld())
		{
			return "TheWorld";
		}
		else if(Brower.isAoyou())
		{
			return "Aoyou";
		}
		else if(Brower.isSogou())
		{
			return "Sogou";
		}
		else if(Brower.isIe())
		{
			return "IE";
		}
		else if(Brower.isChrome())
		{
			return "Chrome";
		}
		else if(Brower.isFirefox())
		{
			return "Firefox";
		}
		else if(Brower.isOpera())
		{
			return "Opera";
		}
		else if(Brower.isSafari())
		{
			return "Safari";
		}
		else
		{
			return "Other";
		}
	},
	checkVeison:function()
	{
		var minMajorVersion = 11;//最低主版本号
		var minorVersion = 4;//二级版本号
		var flashVersion = swfobject.getFlashPlayerVersion();
		if(flashVersion.major < minMajorVersion)
		{
			return true;			
			//location.href = "js/FlashInstall.html";			
		}
		if(flashVersion.major==minMajorVersion && flashVersion.minor<minorVersion){
			return true;
		}
		return false;
	},
	getViewportSize:function()
	{
		var _w = 0;
		var _h = 0;
		if(window.innerWidth){
			_w = window.innerWidth;
			_h = window.innerHeight;
		}else if(document.documentElement && document.documentElement.clientWidth){
			_w = document.documentElement.clientWidth;
			_h = document.documentElement.clientHeight;
		}else if(document.body && document.body.clientWidth){
			_w = document.body.clientWidth;
			_h = document.body.clientHeight;
		}
		return {width:_w, height:_h};
	},
	getScrollPosition:function ()
	{
		var _l = 0;
		var _t = 0;
		if(window.innerWidth){
			_l = window.pageXOffset;
			_t = window.pageYOffset;
		}else if(document.documentElement && document.documentElement.clientWidth){
			_l = document.documentElement.scrollLeft;
			_t = document.documentElement.scrollTop;
		}else if(document.body && document.body.clientWidth){
			_l = document.body.scrollLeft;
			_t = document.body.scrollTop;
		}
		return {left:_l, top:_t};
	},
	addLoadCallBack:function(value)
	{
		callBackAry.push(value);
	},
	addKeyDown:function(value)
	{
		keyDownAry.push(value);
	},
	loadSwf:function( filename ,params,div)
	{
		var flashvars = {
			 quality:"high",
			 algin:"middle",
			 AllowScriptAccess:"always",
			 menu:false,
			 bgcolor:"#000000",
			 wmode:"direct",
			 allowFullScreen: "true",
			 allowfullscreeninteractive:"true",
			 pluginspage:"http://www.adobe.com/go/getflashplayer"
		};

		var attributes = { 
			  id: "myFlash", 
			  name: "myFlash" 
		}; 
		swfobject.embedSWF( filename, div, "100%", "100%", "10.0.0","playerProductInstall.swf", params,flashvars, attributes);
		return Brower.getFlash();	
	},
	getParams:function()
	{ 
		var url = location.href;
		var paraString = url.substring(url.indexOf("?")+1,url.length).split("&");  
		var paraObj = {};
		var ary;
		for (i=0; i < paraString.length; i++)
		{  
			ary = paraString[i].split("=");
			paraObj[ary[0]] = ary[1];
		}  
		return paraObj;
	},
	random:function(min,max)
	{
		var num = max - min;
		return Math.round(Math.random()*num) + min;
	},
	getFlash:function()
	{
		return document.getElementById('myFlash');
	},
	onloadComplete:function()
	{
		var objId =  Brower.getFlash();
		if( objId )
		{
			//objId.focus();
		}
		for(var i=0;i<callBackAry.length;i++)
		{
			callBackAry[i].call(this);
		}
	},
	getURL:function (){
		return document.location.href;
	},
	setTitle:function (title){
		document.title = title;
	},
	getTitle:function (){
		return document.title;
	},
	setUrlVariables:function (url)
	{
		window.location.replace(url);
	},
	addFavorite:function (url,title)
	{
		setTimeout("Brower.addFavoriteImpl('"+url+"','"+title+"')",10);
	},
	addFavoriteImpl:function (url,title)
	{
		if (document.all) 
		{ 
			if( window.external )
			{
				try
				{
					window.external.addFavorite(url,title);
				}
				catch (e)
				{
				}
				return false;
			}
		} 
		else if (window.sidebar ) 
		{ 
			try
			{
				window.sidebar.addPanel(title, url, ""); 
			}
			catch (e)
			{
			}
			return false;
		}
		
		//alert("按 Ctrl+D 添加到收藏");
		return false;
	},
	setHomePage:function (url){
		try
		{
			document.body.style.behavior='url(#default#homepage)';
			document.body.setHomePage(url);
		}
		catch(e)
		{
			if(window.netscape)
			{
				try 
				{
					netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");  
				}  
				catch (e) 
				{ 
					alert("抱歉！您的浏览器不支持直接设为首页。请在浏览器地址栏输入“about:config”并回车然后将[signed.applets.codebase_principal_support]设置为“true”，点击“加入收藏”后忽略安全提示，即可设置成功。");  
				}
				var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
				prefs.setCharPref('browser.startup.homepage',vrl);
			}
		}
	},
	setCookie:function (name, value, expires, security) {
		var str = name + '=' + escape(value);
		if (expires != null) str += ';expires=' + expires;
		if (security == true) str += ';secure';
		document.cookie = str;
	},
	getCookie:function (name) {
		var arr = document.cookie.match(new RegExp(';?' +name + '=([^;]*)'));
		if(arr != null) return unescape(arr[1]);
		return null;
	},
	confirmClose:function (text) {
		if (text != null)
			window.onbeforeunload = function () {return text};
		else
			window.onbeforeunload = null;
	},
	disableScroll:function (objId) {
		var obj = document;
		if (objId != null) 
			obj = document.getElementById(objId);   
               
		if (obj.addEventListener)
			obj.addEventListener('DOMMouseScroll', preventDefault, true);   
		else if (obj.attachEvent)  
			obj.attachEvent('onmousewheel', preventDefault, true);   
		else  
			obj['onmousewheel'] = preventDefault;
                
		function preventDefault(e)
		{   
			if (window.event)  
				window.event.returnValue = false;   
                  
			if (e && e.preventDefault)  
				e.preventDefault(); 
		} 
 	}
}

var Cookie = {
        /**
         * 设置cookie
         * @param key 键名
         * @param value 键值
         * @param domain 域
         * @param path 路径
         * @param expires 过期时间（毫秒）
         * @throws 参数错误
         */
        set : function(key, value, domain, path, expires)
        {
            var args = arguments;
            var size = args.length;
            domain = domain || document.domain;
            path = path || "/";
            expires = new Date().addDate("i", (expires||0)).toGMTString();
            switch (size)
            {
                case 2:
                    document.cookie = key + "=" + Cookie.encode(value) + "; path=/;";
                    break;
                case 3:
                    document.cookie = key + "=" + Cookie.encode(value) + "; path=/; domain=" + domain;
                    break;
                case 4:
                    document.cookie = key + "=" + Cookie.encode(value) + "; path=" + path + "; domain="+domain;
                    break;
                case 5:
                    document.cookie = key + "=" + Cookie.encode(value) + "; path=" + path + "; domain="+domain+"; expires=" + exp;
                    break;
                default:
                    throw new Error("设置cookie时参数错误！");
            }
        },
        /**
         * 获取cookie值
         * @param key 键名
         * @return cookie值,如果没有返回null
         */
        get : function(key)
        {
            var _cookie = document.cookie;
            var items = _cookie.split("; ");
            var item = [];
            var size = items.length;
            for (var i = 0; i < size; i++)
            {
                item = items[i].split("=");
                if(key == item[0] && item.length == 2)
                {
                    return Cookie.decode(item[1]);
                }
            }
            return null;
        },
        /**
         * 删除cookie值
         * @param key 键名
         * @param domain 域
         * @param path 路径
         */
        remove : function(key, domain, path)
        {
            this.set(key, "", domain, path, -1);
        },
		encode : function(str)
		{
			return encodeURIComponent(str);
		}
    }


var keyIdArr = [17,112,113,114,115,116,117,118,119,9,27,192];
function isFB(k){
	for(var i in keyIdArr)
	{
		if(keyIdArr[i] == k)
		{
		  return true;
		}
	}
	return false;
}

//IE keydown
function ieKeyDownHandler()
{
	var val = window.event.keyCode;
	var key = String.fromCharCode(window.event.keyCode);
	if(isFB(val))
	{
		doKeyDown(window.event);
		window.event.keyCode = 0;
		window.event.cancelBubble = true;
		return false;
	}
}

function doKeyDown(event)
{
	for(var i=0;i<keyDownAry.length;i++)
	{
		keyDownAry[i].call(this,event);
	}
}

function ffKeyDownHandler(event)
{
	var val = event.keyCode;
	if(isFB(val))
	{
		doKeyDown(event);
		event.cancelBubble = true;
		event.preventDefault();
		event.returnValue = false;
		return false;
	}
}

function callMapResize( type )
{
	  if( type == 1 )
	  {
		 maxWidth = 1000;
		 maxHeight = 520; 
	  }
	  else
	  {
	  	maxWidth = 4096;
	  	maxHeight = 2048;
	  }
	 setPosition();
}

function asCallJs()
{
	//setInterval("showTime()",30);
}
var objID = null;

function showTime()
{
	if( objID )
	{
		objID.jsCall();
	}
	else
	{
		objID = Brower.getFlash();
		if( objID )
		{
			objID.focus();
		}
	}
}

var addFavoriteFun = function(){};
window.onbeforeunload = closeOpen;
function closeOpen(event)
 {
	if( objID )
	{
		objID.jsClose();
	}
	return addFavoriteFun();
}


if(navigator.userAgent.indexOf('MSIE') != -1)
{
	document.onkeydown = ieKeyDownHandler;
}
else if(navigator.userAgent.indexOf('Mozilla') != -1)
{
	document.documentElement.onkeydown = ffKeyDownHandler;
}

var maxWidth = 4096;
var maxHeight = 2048;

function setPosition()
{
	//目前用不着
	//return;
	var t = document.getElementById('myFlash');
	if( !t ) 
	{
		t = document.getElementById('flashcontent');
		if(!t)
		{
			return;
		}
	}
	var w = Brower.getViewportSize().width;
	var h = Brower.getViewportSize().height;
	
	var mw = maxWidth > w?w:maxWidth;
	var mh = maxHeight > h?h:maxHeight;
	var rh = document.getElementById('msg_bar');
	if(rh)
	{
		mh -= 20;
	}
	
	var x,y;
	if( mw <= 1000 )
	{
		mw = 1000;
	}
	t.style.width = mw+"px";
	
	if( mh <= 520 )
	{
		mh = 520;
	}
	t.style.height= mh+"px";
	//alert(mh);
	if( mw == w && mh == h )
	{
		t.style.left = "0px";
		t.style.top = "0px";
		return;
	}
	
	var top= (h - mh)/2;
	var left = (w - mw)/2;

	top = top < 0?0:top;
	left = left < 0?0:left;

	t.style.left = left + "px";
	t.style.top = top + "px";
	
}

function addEvent()
{
	if(document.addEventListener){
		document.body.addEventListener("scroll", function(){
			setPosition();
		},false);
		window.addEventListener("resize", function(){
		   setPosition();
		},false);
	}else{
		document.attachEvent("onscroll", function(){
		   setPosition();
		});
		window.attachEvent("onresize", function(){
			setPosition();
		});
	}
}
Brower.addLoadCallBack(setPosition);
Brower.addLoadCallBack(addEvent);
