$(function(){

    $(".Character_Tab ul li").click(function(){
        $(this).addClass("Character_active").siblings().removeClass("Character_active"); //切换选中的按钮高亮状态
        var index=$(this).index(); //获取被按下按钮的索引值，需要注意index是从0开始的
        $(".Character_box > div").eq(index).show().siblings().hide(); //在按钮选中时在下面显示相应的内容，隐藏不需要的内容
    });
    //调用人物轮播


    //end
    $('.ShowPlay').click(function(){
        Mask();
        showVideo();
        showBoxTop();
        showBoxLeft();
    });

    $('#mask').live('click', function(){
        $('div').remove('#videoBox');
        $('div').remove('#mask');
    });
    $('#videoA').live('click', function(){
        $('div').remove('#videoBox');
        $('div').remove('#mask');
    });

    var selectTypeClicked = false;
    /** News Right Tab Check**/
    $('.Select_button li ').live('click', function() {
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
    // 导航切换
    $('.nav li').mouseover(function(){
        $(this).addClass('current').siblings().removeClass('current');
    });
    $('.nav').mouseout(function() {
        $(this).find('li').removeClass('current');
        $(this).find('.default').addClass('current');
    });
    //New Tab click // 首页右侧选项卡效果start
    var newsTypeClicked = false;
    $('.navUL li').live('click', function() {
        newsTypeClicked = true;
        $(this).addClass('activers').siblings().removeClass('activers');
        var typeId = $(this).attr('typeId');
        var newsBoxId = "news" + typeId;
        $('.contentBox').find('div.newsbox').stop(true, true).fadeOut(300, function(){
            if($(this).attr('id') == newsBoxId) {
                $(this).fadeIn(2000);
            }
        });
        $('.contentCenter').find('.box').stop(true, true).fadeOut(300, function(){
            if($(this).attr('id') == newsBoxId) {
                $(this).fadeIn(2000);
            }
        });
    });



    //翻页
    var page  = 1;
    var i = 2;

    $('a.btn_right').click(function(){
        var $parent = $(this).parents('div.control');
        var $v_show = $parent.find('div.wrap');
        var $v_content = $parent.find('div.roll');
        var v_width = $v_content.width();
        var len = $v_show.find('li').length;
        var page_count = Math.ceil(len/i);
        if(!$v_show.is(':animated')){
            if(page == page_count){
                $v_show.animate({left:'='+v_width  },'slow');
                return;
            }else{
                $v_show.animate({left:'-='+v_width }, 'slow');
                page++;
            }
        }
        $parent.find('span').eq((page-1)).addClass('current').siblings().removeClass('current');
    });

    $('a.btn_left').click(function(){
        var $parent = $(this).parents('div.control');
        var $v_show = $parent.find('div.wrap');
        var $v_content = $parent.find('div.roll');
        var v_width = $v_content.width();
        var len = $v_show.find('li').length;
        var page_count = Math.ceil(len/i);

        if(!$v_show.is(':animated')){

            if(page == 1){
                $v_show.animate({left:'0px'},'slow');
                return;
            }else{
                $v_show.animate({left:'+='+v_width}, 'slow');
                page--;
            }
        }
        $parent.find('span').eq((page-1)).addClass('current').siblings().removeClass('current');
    })
});





(function ($) {
    $.fn.autobanner = function (options) {
        var defaults = {animateTime: 300, delayTime: 2000};

        var setting = $.extend({}, defaults, options);

        return this.each(function () {
            $obj = $(this);
            var a = setting.animateTime;
            var b = setting.delayTime;
            var banli = $obj.find(".banList li");
            var _len = banli.length;
            var nav = $obj.find(".fomW a");
            var _index = 0;
            var timer = null;
            //图片轮播
            function showImage(n) {
                /*banli.eq(n).addClass("active").siblings().removeClass("active");*/
                banli.eq(n).animate({opacity: '1', zIndex: '9' }, 700).siblings().animate({opacity: '0', zIndex: '8'}, 800);
                nav.eq(n).addClass("current").siblings().removeClass("current");}
            //自动播放
            function autoplay() {
                timer = setInterval(function () {var _index = $obj.find(".fomW").find("a.current").index();
                    //console.log(_index);
                    if (_index + 1 == _len) {_index = -1;showImage(_index + 1 % _len);
                    } else if (_index + 1 == 0) {_index = 2;showImage(_index + 1 % _len);}
                    showImage(_index + 1 % _len);
                }, b);
            }
            nav.hover(function () {
                clearInterval(timer);
                nav.eq($(this)).addClass("current").siblings().removeClass("current");
                if (!(banli.is(":animated"))) {
                    var _index = $(this).index();
                    showImage(_index);
                }
            }, function(){
                autoplay();
            });


            banli.hover(function () {clearInterval(timer);
            }, function () {
                autoplay();
            });
            autoplay();
        });
    }
})(jQuery)




$(document).scroll(function(){
    showBoxTop();
    showBoxLeft();
});
$(window).resize( function(){
    showBoxTop();
    showBoxLeft();
});



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
    window.onresize = function(){
        oMask.style.width = Math.max(document.documentElement.clientWidth, document.body.offsetWidth) + 'px';
        oMask.style.height = Math.max(document.documentElement.clientHeight, document.body.offsetHeight) + 'px';
    }
    return oMask.id;
};
function showVideo(){
    //创建视频窗口
    var typeSrc = $('.ShowPlay').attr('typeSrc');
    //alert(typeSrc);
    var ovideoBox = document.createElement('div');
    ovideoBox.id = 'videoBox';
    document.body.appendChild(ovideoBox);

    var ovideoShow= document.createElement('div');
    ovideoShow.id= 'videoShow';
    ovideoBox.appendChild(ovideoShow);

    var oaBtnEnter = document.createElement('a');
    oaBtnEnter.id = 'videoA';
    oaBtnEnter.href = 'javascript:;';
    ovideoBox.appendChild(oaBtnEnter);

    var oiframe = document.createElement('iframe');
    oiframe.src = typeSrc;
    oiframe.frameBorder ="0";
    oiframe.setAttribute('allowFullScreen', '');
    ovideoShow.appendChild(oiframe);


};


/*始终可视区的中间*/
function showBoxTop(){
    var scrollTop = $(document).scrollTop();
    var tipVideoH = $('#videoBox').height();
    var top;
    if(scrollTop>0){
        top = $(document).scrollTop()+($(window).height()-tipVideoH)/2;
    }else{
        top =($(window).height()-tipVideoH)/2;
    }
    $('#videoBox').css('top', top);
}

function showBoxLeft(){
    var scrollLeft = $(document).scrollLeft();
    var tipVideoW = $('#videoBox').width();
    var left;
    if(scrollLeft>0){
        left = $(document).scrollLeft()+($(window).width()-tipVideoW)/2;
    }else{
        left =($(window).width()-tipVideoW)/2;
    }
    $('#videoBox').css('left', left);
}
