(function($){
    var flag = 1;
    var pregEmail = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i;

    var init = function(){
        //tipInfo();
        tipEvent();
        //$(".sub_btn").attr("###");
        $(".sub_btn").live("click", checkEvent);
        $(".sub_login_btn").live("click", checkLogin);
        //绑定回车键登录
        $('#uname,#upwd,#check_code,#realName,#id_code,#sub_btn').bind('keydown', function(e){
            if (e.keyCode === 13) {
				//alert('ok')
                checkEvent();
            }
        });
        $("a.user_logout").live("click", user_logout);
        $(".open_auth").live("click",function(){
            var host = window.location.host;
            if( typeof gameInfo != "undefined" && typeof gameInfo.namespace != "undefined" && -1 === host.indexOf(gameInfo.namespace)){
                host = host+ '/' + gameInfo.namespace;
            }
            var url = $(this).attr('link')+'&host='+host;
            console.log(url);
            window.Oauth_Window= window.open(url,  'newwindow', 'height=540, width=700, top=' +(screen.height-540)/2+ ', left=' +(screen.width-700)/2+ ', toolbar=no, menubar=no, scrollbars=no, resizable=no,location=yes, status=no');
            $(document).click(showWindow);
        });

    }
    var showWindow = function(){
        if(typeof window.Oauth_Window!="undefined"&&window.Oauth_Window.closed===false){
            window.Oauth_Window.focus();
        } else {
            $(document).unbind("click",showWindow);
        }
    }

    var tipInfo = function(){
        /*$("input:not('#upwd')").val(function(){
            return $(this).attr("data-info");
        });*/
    }
    var tipEvent = function(){
        $("input:not('#upwd')").live(
            {

                focus : function(){
                    if($(this).attr("id") == "email") {
                        noticeInfo("#email", null, null, registerTip.emailCue);
                    }
                    if($(this).attr("id") == "confirmEmail") {
                        noticeInfo("#confirmEmail", null, null, registerTip.confirmEmailCue);
                    }
                    if($(this).attr("id") == "upwd") {
                        noticeInfo("#upwd", null, null, registerTip.passwordCue);
                    }
                    if($(this).attr("id") == "passwordConfirm") {
                        noticeInfo("#passwordConfirm", null, null, registerTip.confirmPasswordCue);
                    }
                },
                blur : function(){
                    if($(this).val()==""){
                        $(this).attr("data-state","0");
                        /*if($(this).attr("id") == "uname") {

                            noticeInfo("#uname", "red", "error", registerTip.unameCue);
                        }*/
                        if($(this).attr("id") == "email") {
                            noticeInfo("#email", "red", "error", registerTip.emailCue);
                        }/* else {
                            return false;
                        }*/
                        if($(this).attr("id") == "confirmEmail") {
                            noticeInfo("#confirmEmail", "red", "error", registerTip.confirmEmailCue);
                        }
                        if($(this).attr("id") == "upwd") {
                            noticeInfo("#upwd", "red", "error", registerTip.passwordCue);
                        }
                        if($(this).attr("id") == "passwordConfirm") {
                            noticeInfo("#passwordConfirm", "red", "error", registerTip.confirmPasswordCue);
                        }

                    }else{
                        $(this).attr("data-state","1");
                        if($(this).attr("id") == "email" ){
                            if((pregEmail).test($(this).val())){
                            noticeInfo("#email", null, null, "Verifying Email ⋯⋯");
                            $.ajax({
                                type: "post",
                                url: "/static_resource/check",
                                data: {field:'email',value:$("#email").val()},
                                dataType:"json",
                                success: function(data){
                                    if(!data.status){
                                        flag = 1;
                                        noticeInfo("#email", "red", "error", data.msg);
                                    }else{
                                        flag =0;
                                        noticeInfo("#email", null, "ok", "&nbsp");
                                    }
                                }
                                });
                            } else {
                                noticeInfo("#email", "red", "error", registerTip.emailCue);
                            }
                        }
                    }
                },
                keydown :  function(){
                    $(this).parent().find(".info_con").removeClass('red');
                    $(this).parent().find(".showIco").removeClass('ok');
                    $(this).parent().find(".showIco").removeClass('error');
                }
            }
        );

        $("#confirmEmail").live(
            {
                focus : function(){
                    /*if($(this).attr("data-state") == 0){
                        $(this).val("");
                    }*/
                    noticeInfo("#confirmEmail", null, null, registerTip.confirmEmailCue);
                },
                blur : function(){
                    if( $(this).val() == "" ){
                        $(this).attr("data-state","0");
                        noticeInfo("#confirmEmail", "red", "error", registerTip.confirmEmailNull);
                    }else if( $("#email").val() != $(this).val() ){
                        $(this).attr("data-state","0");
                        noticeInfo("#confirmEmail", "red", "error", registerTip.confirmEmailError);
                    }else{
                        $(this).attr("data-state","1");
                        noticeInfo("#confirmEmail", null, "ok", "&nbsp;");
                    }
                },
                keydown :  function(){
                    $(this).parent().find(".info_con").removeClass("error");
                    $(this).parent().find(".info_con").removeClass("ok");
                }
            }
        )

        $("#upwd").live(
            {
                focus : function(){
                    noticeInfo("#upwd", null, null, registerTip.passwordCue);
                },
                blur : function(){
                    if( $(this).val()=="" ){
                        $(this).attr("data-state","0");
                        noticeInfo("#upwd", "red", "error", registerTip.passwordNull);
                    // }else if(  $(this).val().length < 6 || $(this).val().length > 20 || !(/^(\d+[a-zA-Z][\da-zA-Z]*|[a-zA-Z]+\d[\da-zA-Z]*)$/).test($(this).val()) ){
                    }else if(  $(this).val().length < 6 || $(this).val().length > 20  ){
                        $(this).attr("data-state","0");
                        noticeInfo("#upwd", "red", "error", registerTip.passwordError);
                    }else{
                        $(this).attr("data-state","1");
                        noticeInfo("#upwd", null, "ok", "&nbsp;");
                    }
                },
                keydown :  function(){
                    $(this).parent().find(".info_con").removeClass('red');
                    $(this).parent().find(".showIco").removeClass('ok');
                    $(this).parent().find(".showIco").removeClass('error');
                }
            }
        )
        $("#passwordConfirm").live(
            {
                focus : function(){
                    if($(this).attr("data-state") == 0){
                        $(this).val("");
                    }
                    noticeInfo("#passwordConfirm", null, null, registerTip.confirmPasswordCue);
                },
                blur : function(){
                    if($(this).val() == "" || $("#upwd").val() != $(this).val()){
                        $(this).attr("data-state","0");
                        noticeInfo("#passwordConfirm", "red", "error", registerTip.confirmPasswordNull);
                    }else{
                        $(this).attr("data-state","1");
                        noticeInfo("#passwordConfirm", null, "ok", "&nbsp;");
                    }
                },
                keydown :  function(){
                    $(this).parent().find(".info_con").removeClass("error");
                    $(this).parent().find(".info_con").removeClass("ok");
                }
            }
        )
    }

    var noticeInfo = function(curNode, infoStyle, icoStyle, html){// 当前input 对象 ，  文字提示类名（red/null），显示图标类名（null/error/ok） ， 定义的提示信息/&nbsp;
        if(infoStyle != null ){
            $(curNode).parent().find(".info_con").addClass(infoStyle);
        } else {
            $(curNode).parent().find(".info_con").removeClass('red');
        }

        if(icoStyle != null) {
            $(curNode).parent().find(".showIco").addClass(icoStyle);
        } else {
            $(curNode).parent().find(".showIco").removeClass('ok');
            $(curNode).parent().find(".showIco").removeClass('error');
        }
        $(curNode).parent().find(".info_con").html(html);

    }

    var checkEvent = function(e){
        if(e){
            e.preventDefault();
        }

        if($("#email").attr("data-state")==0 || !(pregEmail).test($("#email").val())) {
            noticeInfo("#email", "red", "error", registerTip.emailCue);
            return false;
        } else if(flag ==1){
            return false;
        } else {
            noticeInfo("#email", null, "ok", "&nbsp;");
        }

        /*if($("#confirmEmail").attr("data-state")==0 || $("#confirmEmail").val() != $("#email").val()){
            noticeInfo("#confirmEmail", "red", "error", registerTip.confirmPasswordError);
            return false;
        } else{
            noticeInfo("#confirmEmail", null, "ok", "&nbsp;");
        }
*/
        // if($("#upwd").attr("data-state")==0 || $("#upwd").val().length <6 || $("#upwd").val().length >20 || !(/^(\d+[a-zA-Z][\da-zA-Z]*|[a-zA-Z]+\d[\da-zA-Z]*)$/).test($("#upwd").val()) ){
        if($("#upwd").attr("data-state")==0 || $("#upwd").val().length <6 || $("#upwd").val().length >20 ){
            noticeInfo("#upwd", "red", "error", registerTip.passwordError);
            return false;
        } else{
            noticeInfo("#upwd", null, "ok", "&nbsp;");
        }


        if($("#passwordConfirm").attr("data-state")==0 || $("#passwordConfirm").val() != $(".upwd").val()){
            noticeInfo("#passwordConfirm", "red", "error", registerTip.confirmPasswordError);
            return false;
        } else{
            noticeInfo("#passwordConfirm", null, "ok", "&nbsp;");
        }

        show_status_dialog('loading', 'Loading......', false);

        var email = $("#email").val();
        var password = $("#upwd").val();
        var game_id = $("#game_id").val();

        $.ajax({
            type: "post",
            url: "/static_resource/sign_up",
            data: {email:email, password:password,game_id:game_id},
            dataType:"json",
            success: function(data){
                if(!data.status){
                    show_status_dialog('error', data.msg, false);
                }else{
                    $("#dialog_form").dialog('close');
                    // login
                    $.getScript(data.script, function(){
                        getUserInfo(data.login_info);
                    });
                    show_status_dialog('success', registerTip.registerSuccess, false, 1000);
                }
            }
        });
        return false;
    }

    var checkLogin = function(e) {
        if(e){
            e.preventDefault();
        }
        show_status_dialog('loading', 'Loading.....', true);
        if($('#dialog_username').length > 0){
            var username = $('#dialog_username').val();
            var password = $('#dialog_password').val();
        }else {
            var username = $('#left_username').val();
            var password = $('#left_password').val();
        }
        var game_id = $("#game_id").val();
        if(password.length < 6 || ( !(pregEmail).test(username))){            //alert( 'Wrong User Name or Password' + username + password);
            show_status_dialog('error', 'Wrong Email or Password', false, 1000);
        } else {
            var login_url = (typeof gameInfo != "undefined" && typeof gameInfo.currentGamePageAjaxRootUrl != 'undefined') ? gameInfo.currentGamePageAjaxRootUrl + "/static_resource/login" :  "/static_resource/login";
            $.ajax({
                type: "post",
                url: login_url,
                data: {username:username, password:password,game_id:game_id},
                dataType:"json",
                success: function(data){
                    if(!data.status){
                        show_status_dialog('error', data.msg, false);
                    }else{
                        if($('#dialog_username').length > 0){
                            $("#dialog_form").dialog('close');
                        }
                        // landing page redirect to play page
                        var redirect = $("#signin").attr("redirect");
                        if( redirect != undefined && redirect.length > 0 ) {
                            $.getScript(data.script,function(){
                                if(redirect == 1){
                                    refreshPage();
                                } else if( redirect == '' || redirect == 0){
                                    getUserInfo(data.login_info);
                                } else {
                                    window.location.href=redirect;
                                }
                            });
                        } else {
                            $.getScript(data.script, function(){
                                getUserInfo(data.login_info);
                            });
                        }
                    }
                }
            });
        }
    }


    function user_logout() {
        var sign_out_tip = show_status_dialog('success', accountTip.logOut, false);
        $.ajax({
            type: "post",
            url: "/static_resource/logout",
            data: '',
            dataType:"json",
            cache:false,
            success:function(data){
                if(data.status == false){
                    show_status_dialog('Error', accountTip.logOutError, false);
                }else{
                    $.getScript(data.logout_url, function(){
                        refreshPage();
                    });
                }

            }
           
        });
    }
    init();
})(jQuery);



/**
 *
 * @param script
 * @param redirectModel
 */
function loginEnd(script, redirectModel ){
    if( typeof redirectModel == "undefined" || redirectModel ==='unknown'  ){
        if( typeof registerTip != "undefined" &&  typeof registerTip.redirectModel != "undefined"){
            if ('pop' == registerTip.redirectModel) {
                userLogin(script, -1);
                // pop
                var popWindow = $('#multiPlay');
                if(popWindow.length>0 ){
                    popWindow.css('display', 'block');
                } else {
                    window.location.reload();
                }
            } else if ('region' == registerTip.redirectModel) {
                userLogin(script, registerTip.game_url + '/play?sr=' + registerTip.region_id);
            } else {
                userLogin(script, registerTip.game_url + '/play');
            }
        } else {
            userLogin(script, 1);
        }
    } else{
        userLogin(script, redirectModel);
    }
}


var userLogin = function(codeString, refresh) {
    var re=/http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*/gi;
    var urlArr = codeString.match(re);
    if(urlArr != null && urlArr.length > 0) {
        loadScript(urlArr, 0, refresh);
    } else {
        //loadScript(urlArr, 0, refresh);
        if(refresh == 1){
            refreshPage();
        } else if( refresh == '' || refresh == 0){
            getUserInfo(0);
        } else if (refresh == -1) {
            return true;
        } else {
            window.location.href = refresh;
        }
    }
};



var refreshPage = function(e) {
    if(e){
        e.preventDefault();
    }
    window.location.reload();
}

var loadScript = function(urlS, startNo, refresh) {
    if(startNo < urlS.length) {
        $.getScript(urlS[startNo],function(){
            if(startNo == (urlS.length - 1)) {
                if(refresh == 1){
                    refreshPage();
                } else if( refresh == '' || refresh == 0){
                    getUserInfo(0);
                } else if (refresh == -1) {
                    return true;
                } else {
                    window.location.href=refresh;
                }
            } else {
                startNo++;
                loadScript(urlS, startNo, refresh);
            }
        });
    }
}


var getUserInfo = function(login_info) {
    show_status_dialog('loading', 'Loading......', false);

    //var top_info = false;
    //var left_info = false;
    //For Lottery page, after user login, reload page
    var lotteryReloadSattus = $("#lottery_login_box").attr('reload');
    if(lotteryReloadSattus == 'needreload') {
        window.location.reload();
    }

   if( loginStatus != 'login') {
       // handle top banner user info
       $("div#ajaxLoginWidget #bannerEmail").append(login_info.display_email);
       $("div#top_right").css('display', 'none');
       $("div#ajaxLoginWidget").css('display', 'block');

       show_status_dialog('success', accountTip.loginSuccess, false, 1500);

       // handle left user info
       $("div#userAjaxLoginWidget #welcome_email").append(login_info.email);
       $("div#userAjaxLoginWidget #left_last_login_ip").append(login_info.last_login_ip);
       $("div#userAjaxLoginWidget #left_last_login_time").append(login_info.last_login_time);
       if(login_info.last_login_server_id == ''){
           $("div#userAjaxLoginWidget #left_last_login_history a").attr('href', '/play');
       }else{
           $("div#userAjaxLoginWidget #left_last_login_history a").attr('href', '/play/server/' + login_info.last_login_server_id);
       }

       if ('undefined' == login_info.is_real_email || 1 == login_info.is_real_email) {
           $('div.user_info > b.tipVerityEmail').remove();
           $('ul.logout span.tipVerityEmail').remove();
       }

       $("div#userAjaxLoginWidget #left_last_login_history a").html(login_info.last_login_server_name);
       $("div#user_game_profile").css('display', 'none');
       $("div#userAjaxLoginWidget").css('display', 'block');
       loginStatus = 'login';

       loginAfterExec();
   }
}


$(document).ready(function(){
    if (typeof(isExecClientInfo) != "undefined" && isExecClientInfo) {
        loginAfterExec();
    }

    flashEnableCheck();
});


var loginAfterExec = function () {
    var flashInfo = flashDetector();
    $.ajax({
        type: "GET",
        url: "/static_resource/client_info",
        dataType:"jsonp",
        cache: false,
        data:{flash_version:flashInfo.flashVersion, screen_width:screen.width, screen_high:screen.height},
        success: function(result){}
    });

}


var flashEnableCheck = function () {
    var flashInfo = flashDetector();
    if (!flashInfo.flashVersion && $(".play_game_center").data("check-flash")) {
        flashConfirm.mask();
        var showContent = 'You need Adobe Flash to play this game.\n' +
            'Get Adobe Flash by clicking on the link below!\n';
        var hrefUrl = 'https://www.adobe.com/go/getflashplayer';
        flashConfirm.showTip(showContent, hrefUrl);
        flashConfirm.showCenter();
    }
}
