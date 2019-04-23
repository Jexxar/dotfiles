var loading = '<div class="loadingImage" style="margin: 100px;"></div>';
$(document).ready(function(){
//右侧选择语言功能
    var timer = null;
    clearTimeout(timer);
    //var typeLanguage = $('.languageWrap ul').attr('typeLanguage');

    $('.languageWrap .default').hover(function(){
        $(this).css('color' , '#c5c5c5');
        $(this).addClass('bgColorB');
        $('.languageWrap ul').slideDown("slow");

    }, function(){

        timer = setTimeout(function() {

            $('.languageWrap ul').stop(true, true).slideUp("slow");
            $('.languageWrap .default').delay(3000).removeClass('bgColorB');
        }, 500);
        $(this).css('color' , '#6a6a6a');

    });


    $('.languageWrap ul').hover( function(){
        $('.languageWrap .default').css('color' , '#c5c5c5');
        clearTimeout(timer);
    }, function(){
        $(this).delay(800).stop(true, true).slideUp("slow");
        $('.languageWrap .default').delay(3000).removeClass('bgColorB');
        $('.languageWrap .default').css('color' , '#6a6a6a');
    });

    //if($('.languageWrap ul').css('display') =='none'){
    //	('.languageWrap .default').removeClass('bgColorB');
    //}
    // reset document.domain
    resetDomain();
    $("div.contentBox").tooltip();
    $("div.server_open_plan_calendar").tooltip();
    $('a').live('click', function() {
        $need_login = $(this).attr('need_login');
        if($need_login == 1 && loginStatus == 'nologin') {
            $("#loginInBtn").click();
            show_status_dialog('error', needLogin.needLoginToAccess, false, 2000);
            return false;
        }
    });

    //New Tab click
    var newsTypeClicked = false;
    // tab切换
    function tabSwitch(tab, tabCon, tabActive) {
        $(tab).click(function () {
            newsTypeClicked = true;
            var index = $(tab).index(this);
            $(this).addClass(tabActive).siblings().removeClass(tabActive);
            /*$(tabCon).eq(index).fadeIn(500);*/
            $(tabCon).eq(index).fadeIn(500).siblings().hide();
        })
    }
    tabSwitch("#con_nav li", "#contentBox .newsbox", "active");
    tabSwitch("#con_nav li", "#contentBoxWrap .newsbox", "active");
    
    var selectTypeClicked = false;
    /** News Right Tab Check**/
    $('.Select_button a').live('click', function() {
        selectTypeClicked = true;
        $(this).addClass('active').siblings().removeClass('active');
        var typeU = $(this).attr('typeU');
        var selectBox = typeU;
        $('.Select_allbox div.Select_list').stop(true, true).fadeOut(10, function(){
            if($(this).attr('id') == selectBox) {
                $(this).fadeIn(2000);
            }

        });
    });

    /** News Type Style Class Change ***/
    $('#con_nav li').mouseover(function(){
        if(newsTypeClicked == false) {
            $(this).addClass('active').siblings().removeClass('active');
        }
    });
    $('#con_nav').mouseout(function() {
        if(newsTypeClicked == false) {
            $(this).find('li').removeClass('active');
            $(this).find('.default').addClass('active')
        }
    });

    //Menu Button

    $('#nav li').mouseover(function(){
        $(this).addClass('current').siblings().removeClass('current');
    });
    $('#nav').mouseout(function() {
        $(this).find('li').removeClass('current');
        $(this).find('.default').addClass('current')
    })

    $("#roll li").mouseover(function() {
        $("#roll span").hide();
        $(this).find("span").show();
    });
    $("#roll li").mouseout(function() {
        $("#roll span").hide();
    });

    //用户登录后鼠标移上显示内容
    $('.user_info').live('mouseover', function(){
		$('.user_info b').hide();
		//$('.user_info b').removeClass('tipVerityEmail');
        $(this).css('color','#c7c7c7');
        $('.logout').css('display','block')

    });
    $('.user_info').live('mouseout', function(){
		$('.user_info b').show();
		//$('.user_info b').addClass('tipVerityEmail');
        $(this).css('color','#6a6a6a');
        $('.logout').css('display','none')

    });
    //all game鼠标移上显示内容
    $('.all_hover').live('mouseover', function(){
        $(this).find('a.all').addClass('hover');
        $('.all_game').show();
    });
    $('.all_hover').live('mouseout', function(){
        $(this).find('a.all').removeClass('hover');
        $('.all_game').hide();
    });
    $('a.showBigialog').live('click', function(){
        var URI = $(this).attr('link');
        var Title = $(this).attr('title');
        show_big_dialog(URI, Title);
        return false;
    });

    // pop form dialog
	$('a.show_form').live('click', function(){
        var URI = $(this).attr('link');
        var title = $(this).attr('title');
        var dialog_type = $(this).attr('dialog_type');
        var width;
        var height;
        switch(dialog_type){
        	case 'Login':
        		width = 420;
        		height = 460;
        		break;
        	case 'Sign Up':
        		width = 450;
        		height = 520; 
        		break;
        	default:
                return false;
        }
        show_form_dialog(URI, title, width, height);
        return false;
	});

    //Account setting box
    $(".various").fancybox({
        padding     : 0,
        closeBtn    :false,
        fitToView	: false,
        width		: 842,
        height		: 632,
        autoSize	: false,
        closeClick	: false,
        openEffect	: 'fade',
        closeEffect	: 'fade',
        openSpeed   : 'slow',
        closeSpeed  :'fast',
        scrolling   : 'no',
        ajax  : {
            cache:true
        }
    });
    $("#closeFancybox").live('click', function() {
        $.fancybox.close()
    });

    // change password
    $(".submit_update_pw").live('click', function(){
        show_status_dialog('loading', 'Loading......', false);
        var old_pw = $(".old_pw").val();
        var new_pw = $(".new_pw").val();
        var confirm_new_pw = $(".confirm_new_pw").val();
        //validation
        if( new_pw.length < 6 || new_pw.length > 16 || confirm_new_pw.length < 6 || confirm_new_pw.length > 16 ){
            show_status_dialog('error', changePassword.passwordFormatError, false);
            return false;
        }
        if( new_pw != confirm_new_pw ) {
            show_status_dialog('error', changePassword.passwordNotEqual, false);
            return false;
        }
        if( new_pw == old_pw ) {
            show_status_dialog('error', changePassword.passwordEqual, false);
            return false;
        }
        // submit
        $.ajax({
            type: "post",
            url: '/static_resource/update_pw',
            dataType:"json",
            data:{old_pw:old_pw,new_pw:new_pw},
            cache: false,
            success: function(data){
                if(data.status == true) {
                    show_status_dialog('success', data.msg + "! " + changePassword.needReLogin, false, 3000);
                    $.fancybox.close();
                    setTimeout(function() {
                        $("a.user_logout").click();
                    }, 3000);
                } else {
                    show_status_dialog('error', data.msg, false, 1500);
                }
            }
        });
    });

    //玩游戏页面左侧效果
    $('.play_footer_leftside ul li').eq(0).mouseover(function(){
        $('.play_footer_leftside ul li a').eq(0).addClass("news");
        $('.cont').animate({opacity:'1'},1000);
        $('.cont').show();
        $('.cont').mouseover(function(){
            $(this).css('display','block');

            var divo = document.getElementById('divo');
            var divt = document.getElementById('divt');
            var divs = document.getElementById('divs');
            var MaxTop = divo.offsetHeight - divt.offsetHeight;
            divt.onmousedown = function(ev){
                var ev = ev || event;
                var disY = ev.clientY - this.offsetTop;
                document.onmousemove = function(ev){
                    var ev = ev || event;
                    var T = ev.clientY -  disY;
                    if(T>MaxTop){
                        T = MaxTop;
                    }else if(T < 0){
                        T = 0;
                    }
                    var iScale =T / MaxTop ;
                    divf.style.top = (divs.offsetHeight - divf.offsetHeight ) * iScale + 'px';
                    divt.style.top = T + 'px';
                };
                document.onmouseup = function(){
                    document.onmousemove = null;
                };
                return false;
            };
        });
        $('.cont').mouseout(function(){
            $(this).hide();

        });
    });
    $('.play_footer_leftside ul li').eq(0).mouseout(function(){
        $('.play_footer_leftside ul li a').eq(0).removeClass("news");
        $('.cont').hide();
    });
    $('.play_footer_leftside ul li a').eq(1).mouseover(function(){
        $(this).addClass("guide");
    });
    $('.play_footer_leftside ul li a').eq(1).mouseout(function(){
        $(this).removeClass("guide");
    });
    $('.play_footer_leftside ul li a').eq(2).mouseover(function(){
        $(this).addClass("support");
    });
    $('.play_footer_leftside ul li a').eq(2).mouseout(function(){
        $(this).removeClass("support");
    });
    $('.play_footer_leftside ul li a').eq(3).mouseover(function(){
        $(this).addClass("recharge");
    });
    $('.play_footer_leftside ul li a').eq(3).mouseout(function(){
        $(this).removeClass("recharge");
    });






    /**
     * 初始化站内消息弹窗
     */
    $('.emailNotice').fancybox({
        padding     : 0,
        closeBtn    : false,
        fitToView	: false,
        width		: 900,
        height		: 560,
        autoSize	: false,
        closeClick	: false,
        openEffect	: 'fade',
        closeEffect	: 'fade',
        openSpeed   : 'slow',
        closeSpeed  :'fast',
        scrolling   : 'no',
        ajax  : {
         cache: true
         },
        afterShow: ajax_update_user_message_log
    });
});

function ajax_update_user_message_log() {
    var firstMsgEle = $('.emailInfoBox').first().find('a.show');
    if (firstMsgEle.attr('isRead') == 'no') {
        $.ajax({
            type: 'POST',
            data: {
                'id': firstMsgEle.attr('msgLogId')
            },
            url: '/static_resource/update_user_message_log',
            dataType: 'json',
            success: function (data) {
                if (data.status) {
                    if (data.unread != 'undefined' && data.unread != '' && data.unread > 0) {
                        $('#messageTip').tooltipster("content", data.title);
                        $('.emailInfoTip').eq(0).find('b.radius').html(data.unread);
                    } else {
                        $('#messageTip').tooltipster("content", data.title);
                        $('.emailInfoTip').eq(0).find('b.radius').remove();
                    }
                }
            }
        });
    }
}

function changeTip(unread, title) {
    if (unread != 'undefined' && unread != '' && unread > 0) {
        $('#messageTip').tooltipster("content", title);
        $('.emailInfoTip').eq(0).find('b.radius').html(unread);
    } else {
        $('#messageTip').tooltipster("content", title);
        $('.emailInfoTip').eq(0).find('b.radius').remove();
    }
}
//facebook 按钮点赞部分
(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function show_big_dialog(URI, title) {

    var dialogOpts = {
        autoOpen: false,
        width:910,
        maxHeight :600,
        title: title,
        modal: true,
        draggable : false,
        resizable:false,
        position : 'center',
        buttons: {},
        close: function() { $('#dialog-box .content').empty();},
        open: function() {
            $('#dialog-box .content').append(loading);
            $.ajax({
                type: "GET",
                url: URI,
                dataType:"html",
                cache: false,
                success: function(html){
                    $('#dialog-box .content').empty();
                    $('#dialog-box .content').html(html);//显示到tbody中
                }
            });
        }
    }
    $( "#dialog-box" ).dialog(dialogOpts).dialog("open");
}

function show_form_dialog(URI, title, width, height) {
    var dialogShowStatus = $('#dialog_form').attr('showOut');
    if(dialogShowStatus == 'showOut') {
        $("#dialog_form").dialog("close");
    }
    var dialogOpts = {
        autoOpen: false,
        width:width,
        height:height,
        title: title,
        modal: true,
        draggable : false,
        resizable:false,
       // position : 'center',
        buttons: {},
        close: function() { $('#dialog_form').empty();$('#dialog_form').attr('showOut', 'Hide');},
        open: function() {
            $('#dialog_form').append(loading);
            $.ajax({
                type: "GET",
                url: URI,
                dataType:"html",
                cache: false,
                success: function(html){
                    $('#dialog_form').empty();
                    $('#dialog_form').html(html);//显示到tbody中
                    $('#dialog_form').attr('showOut', 'showOut');
                }
            });
        }
    }
    $("#dialog_form").dialog(dialogOpts).dialog("open");
}

/**** Top show status box ****/
/**
 *第一个参数 warning /error / success / loading 三种外观 第二个参数 返回信息  第三个参数 是否显示遮罩 第四个参数 可选 自动消失时间 第五个参数可选  与第四个参数配合使用 X毫秒后跳转到传进去地址
 * @param type
 * @param meaasge
 * @param shade
 * @param runtime
 * @param callback
 */
var show_status_dialog = function(type, meaasge, shade, runtime, callback){
    var messageBoxTpl = "<div id='tip_box'><span>" + meaasge + "</span><a class='clossTipBox'></a></div>";
    var timeout = parseInt(runtime);
    var shadeBoxId = false;
    var showBox;
    var shadeBox = 'null';

    $('#tip_box').stop().fadeOut('fast').remove();
    $("#maskfoot").stop().fadeOut('fast').remove();
    if(shade != false) {
        shadeBoxId = MaskFooter();
        shadeBox = $("#"+shadeBoxId);

    }
    var top = $(document).scrollTop();
    var left = $(document).scrollLeft();
    if(type == 'warning') {
        type = 'error';
        messageBoxTpl = "<div id='tip_box'><span>" + meaasge + "</span></div>";
    }
    $(messageBoxTpl).appendTo('body').addClass(type).css({
        "top":top,
        "left":left}).fadeIn("slow", function() {
        showBox = $(this);
        $(document).live('scroll', function() {
            var scrollTop = $(document).scrollTop();
            var scrollLeft = $(document).scrollLeft();
            var documentHeight = $(document).innerHeight();
            var documentWidth = $(document).innerWidth();

            var showBoxHeight = showBox.height();
            var showBoxWidth = showBox.width();

            if(scrollTop + showBoxHeight <= documentHeight && scrollLeft + showBoxWidth <= documentWidth) {
                showBox.css('top', scrollTop);
                showBox.css('left', scrollLeft);
            }

            if(shade != false) {
                var shadeBoxHeight = shadeBox.height();
                var shadeBoxWidth = shadeBox.width();
                if(scrollTop + shadeBoxHeight <= documentHeight && scrollLeft + shadeBoxWidth <= documentWidth) {
                    shadeBox.css('top', scrollTop);
                    shadeBox.css('left', scrollLeft);
                }
            }
        });
        if(callback != undefined && timeout > 0) {
            setTimeout(function() {
                window.location.href = callback;
            }, timeout);
        } else if(timeout > 0) {
            setTimeout(function() {
                showBox.fadeOut('slow');
                $("#maskfoot").fadeOut('slow').remove();
            }, timeout);
        }
        $('#tip_box a.clossTipBox').live('click', function(){
            $('#tip_box').stop().fadeOut('fast').remove();
            $("#maskfoot").fadeOut('slow').remove();
        });
    });
    return showBox;
}

/**************************shader function************************************/
function Mask(){
    //创建遮罩层
    var oMask = document.createElement('div');
    oMask.id = 'mask';
    document.body.appendChild(oMask);

    var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
    var scrollLeft = document.documentElement.scrollLeft || document.body.scrollLeft;

    oMask.style.display = 'block';
    oMask.style.width = Math.max(document.documentElement.clientWidth, document.body.offsetWidth) + 'px';
    oMask.style.height = Math.max(document.documentElement.clientHeight, document.body.offsetHeight) + 'px';
    return oMask.id;
}

/**************************shader function************************************/
function MaskFooter(){
    //创建遮罩层
    var oMaskfoot = document.createElement('div');
    oMaskfoot.id = 'maskfoot';
    document.body.appendChild(oMaskfoot);

    var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
    var scrollLeft = document.documentElement.scrollLeft || document.body.scrollLeft;

    oMaskfoot.style.display = 'block';
    oMaskfoot.style.width = Math.max(document.documentElement.clientWidth, document.body.offsetWidth) + 'px';
    oMaskfoot.style.height = Math.max(document.documentElement.clientHeight, document.body.offsetHeight) + 'px';
    $(window).resize(function() {
        $("#"+oMaskfoot.id).css('width', Math.max(document.documentElement.clientWidth, document.body.offsetWidth) + 'px');
        $("#"+oMaskfoot.id).css('height', Math.max(document.documentElement.clientHeight, document.body.offsetHeight) + 'px');
    });
    return oMaskfoot.id;
}


/**
 * screenshot scroll
 */


/**forget password Tab click   add 0311**/
    $('.forget_left li').live('click', function() {
        $(this).addClass('red').siblings().removeClass('red');
        var typeId = $(this).attr('typeid');
        var forgetRId = "forgetR" + typeId;
        $('.forget_password').find('div.forget_right').stop(true, true).fadeOut(10, function(){
            if($(this).attr('id') == forgetRId) {
                $(this).fadeIn(1000);
            }
        });
    });
/**forget password Tab click add 0311**/

/**
 * reset domain to primary domain, avoid conflict cross-domain operation of sub domain frame
 */
function resetDomain(){
    var domainArr = window.document.domain.split(".");
    if( domainArr.length > 1){
        window.document.domain = domainArr[domainArr.length-2]+"." + domainArr[domainArr.length-1];
    }
}

//侦测浏览器是否安装Flash,和已安装Flash版本
function flashDetector() {
    var hasFlash = 0; //是否安装了flash
    var flashVersion = ''; //flash版本
    var isIE =window.ActiveXObject; //是否IE11以的IE浏览器
    var  exception = '';
    if (isIE) {
        var iEActiveXObject = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
        if (iEActiveXObject) {
            hasFlash = 1;
            flashVersion = iEActiveXObject.GetVariable("$version");
            var versionArr = flashVersion.split(" ");
            if(typeof versionArr[1] != 'undefined' ){
                flashNumberVersionArr = versionArr[1].split(',');
                if( flashNumberVersionArr.length >= 2){
                    flashVersion = flashNumberVersionArr[0] + '.' + flashNumberVersionArr[1];
                } else {
                    flashVersion = versionArr[1];
                }
            } else {
                exception = 'no version Number in IE10-:' + flashVersion.toString();
            }
        }
    } else {
        if (navigator.plugins && navigator.plugins.length > 0) {
            var navigatorFlashObj = navigator.plugins["Shockwave Flash"];
            if( navigatorFlashObj ){
                hasFlash = 1;
                if( typeof navigatorFlashObj.version != 'undefined'){
                    flashNumberVersionArr = navigatorFlashObj.version.split('.');
                    if( flashNumberVersionArr.length >= 2){
                        flashVersion = flashNumberVersionArr[0] + '.' + flashNumberVersionArr[1];
                    } else {
                        flashVersion = navigatorFlashObj.version;
                    }

                } else if( typeof navigatorFlashObj.description != 'undefined'){ //chrome
                    var flashStrVersionArr = navigatorFlashObj.description.split(' ');
                    for(var i=0;i<flashStrVersionArr.length;i++){
                        if(parseFloat(flashStrVersionArr[i]) > 0){
                            flashVersion = flashStrVersionArr[i];
                        }
                    }
                    var flashNumberVersionArr = flashVersion.split('.');
                    if( flashNumberVersionArr.length >= 2){
                        flashVersion = flashNumberVersionArr[0] + '.' + flashNumberVersionArr[1];
                    }
                } else {
                    exception = 'no version, no description:' + navigatorFlashObj.toString();
                }
            } else {
                hasFlash = 0;
            }

        }
    }
    return {
        hasFlash: hasFlash,
        flashVersion: flashVersion, //flashVersion
        exception: exception
    };
}