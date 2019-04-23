function getParams()
{
        var myparams = {};

        myparams.platformCode="987654321";
        myparams.version="1.0.0.0_20131104_1";
        myparams.loginIP = "80.gamestorm1.vivagames.me:9012"
        myparams.gameIP = "";
        myparams.isDebug = false;
        myparams.mainPath = "";
        myparams.proxyType = "English";
        myparams.dothingUrl= encodeURIComponent("../fbdl/game/index.php?c=regApi&m=upRegInfo");// php 统计页面
        myparams.randomNameUrl="/f2_game/get_default_rolename.php?1=1";//随机获取角色名页面
        myparams.loginGiftUrl = encodeURIComponent("../fbdl/game/index.php?c=award&m=sendLoginGift");
        myparams.platformCode = "JF";//平台标识，一定要和平台名对应一定要和平台名对应一定要和平台名对应
        
        //统一配置
        myparams.gameName = "Divine Storm";
	//myparams.preLoadPageBg = "assets/modules/PreloaderPage/preLoadPageBg5.jpg?1";//新加载页
        //myparams.preLoadPageBg = "assets/modules/PreloaderPage/preLoadPageBg.jpg";//加载页
       myparams.preLoadPageBg = "assets/modules/PreloaderPage/preLoadPage_en.jpg";//新加载>页
        //特殊设置
        myparams.chatBaseLevel = 50;//限制世界聊天频道发言等级
        myparams.timerTestType = 30; //检测外挂配置，配置越大放得越宽。0为不检测
        //myparams.createRoleUrl = "CreateRole_v3_big.swf";//特殊创号页版本控制
        //myparams.downLoadLanderUrl = encodeURIComponent("http://s1.sm.test.game-as.com/3dmmo/huanyu.exe");//研发登陆器下载地址
        //myparams.platformDownLoadUrl = "http://jump2.niu.xunlei.com:8080/000000/201511111586393487";//平台登录器下载地址
        //myparams.showGirlRechargeAmount = "8000";//累计充值钻石显示ShowGirl联系方式
        //myparams.showGirlQQ = "800051551";//showGirlQQ号码
        //myparams.platformMobileVerificUrl = "http://niu.xunlei.com/actives/bigbang3/";//手机验证地址      
        //myparams.downLoadLanderUrl = encodeURIComponent("http://cdn.infiplay.ru/storm/INFIPLAY/storminstaller.exe");//登陆器下载地址
        //myparams.platformVipUpgradeUrl = encodeURIComponent("http://vip.niu.xunlei.com/pay.html?advNo=201510267021207138");//迅雷金钻升级URL（一般配置充值链接）
 
        //服务器必要配置
        myparams.actimUrl = encodeURIComponent("http://storm.vivagames.me");//官网地址
  	    myparams.favoritesUrl = encodeURIComponent("http://niu.xunlei.com/entergame/fbdl/?fenQuNum=");//收藏夹地址
        myparams.bbsUrl = encodeURIComponent("http://forums.vivagames.me/forum/divine-storm");//论坛地址
        //myparams.platFeedBackUrl=encodeURIComponent("GameSuggest.html?game=#Game#&platform=#Platform#&server=#Server#&uid=#Uid#&rolename=#Rolename#&ts=#Ts#&sign=#Sign#");//反馈图标链接，客户端填参
        myparams.payUrl = encodeURIComponent("http://pay.vivagames.me/pay?account=#XXHUserName#&server=#XXHServer#&game=1493793413"); //充值付费url
        //myparams.xskUrl = encodeURIComponent("http:http://fbdl.niu.xunlei.com/newcard.shtml");//新手卡地址 
        //myparams.proctecUrl = encodeURIComponent("http://game.kuwo.cn/g/st/perfectInfo?act=chenmi");//配置该防沉迷地址实现直接跳转平台防沉迷页面
        myparams.title = "Divine Storm";

        //客服信息配置
        //myparams.gmUrl = "http://niu.xunlei.com/cs/zzfw/index.html";//游戏内GM按钮直接跳转到指定的在线GM链接，不再打开游戏内GM界面
        myparams.gmInfo = "请在下方输入您的反馈和建议，客服工作人员将尽快通过游戏内邮件联系您。";
        //myparams.gmHelpUrl = encodeURIComponent("http://niu.xunlei.com/cs/zzfw/index.html");//平台客服地址
        //myparams.vipHelpUrl = encodeURIComponent("http://chat.53kf.com/company.php?arg=weedong&style=6&u=#XXHUserName#");//平台VIP客服地址（功能未有）
        myparams.platformJFCollectLevel = "1#40#72#80"
        
        myparams.issmType = 1;
        myparams.chatLimitLevel = 50; //限制世界聊天频道发数字的等级
        myparams.chatNumLimit = 3; //一句话中可使用的数字，默认3
        myparams.isShowError = true;
	    myparams.isUIByLevel = true;
        myparams.isShowMusic = 0;
	    myparams.cRegionNum = 0; 
	    myparams.isShowCustomPreloadPage = false;
        myparams.timezone= -6;
        myparams.fastUrl = "download.php";
        document.title = myparams.title;
        return myparams;
}
document.domain = "vivagames.me";
