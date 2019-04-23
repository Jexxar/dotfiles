function addFlashVersion( myparams)
{
	myparams.flashVersion = "1.0.5.3_76";
	myparams.loaderUrl = "Preloader.swf?v=" + myparams.flashVersion+"_1";
	myparams.gameUrl =  "MainGame.swf?v="+ myparams.flashVersion+"_1";
	myparams.configUrl = "data/data?v="+ myparams.flashVersion+"_1";
	myparams.resTime = myparams.flashVersion + "2";
	myparams.preLoaderVersion = myparams.flashVersion+"_2";
	myparams.updateUrl = myparams.mainPath+"update_notice/";
	if(!myparams.createRoleUrl)
	{
		myparams.createRoleUrl = "CreateRole_v2_en.swf";
	}
	myparams.createRoleUrl += "?v="+myparams.flashVersion+"_6";
}
