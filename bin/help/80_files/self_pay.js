/**
 * Created with JetBrains PhpStorm.
 * User: iao
 * Date: 14-7-25
 * Time: 下午2:42
 * To change this template use File | Settings | File Templates.
 */

/**
 * reset domain to primary domain, avoid conflict cross-domain operation of sub domain frame
 */
function resetDomain(){
    try {
        var domainArr = window.document.domain.split(".");
        if( domainArr.length > 1 ){
            window.document.domain = domainArr[domainArr.length-2]+"." + domainArr[domainArr.length-1];
        }
         //  ga('send', 'event', 'Errors', 'success', 'Reset Domain', {
         //      nonInteraction: true
         ///  });
    } catch(ex) {
        //ga('send', 'event', 'Errors', 'error', 'Reset Domain', {
      //      nonInteraction: true
       // });
    }

   // var domainArr = window.document.domain.split(".");
   // window.document.domain = domainArr[domainArr.length-2]+"." + domainArr[domainArr.length-1];
}
function open_pay() {console.log('open_pay');
    var recharge_button_ele = $("#recharge");
    var recharge_link = recharge_button_ele.attr('recharge_link');

    //show_status_dialog('success', 'Recharge is temporarily unavailable!', 1000);
    if( recharge_button_ele.attr('open_type') == 'frame' ){
        show_pay_frame(recharge_link);
    }else {
        window.open(recharge_link);
    }
}

function show_pay_frame(recharge_link){
    if( $("#pay_frame").length > 0 ){
        $(".game_wrap").toggle(1000);
    } else {
        var frameCode = '<iframe id="pay_frame" name="pay_frame"  scrolling="no" frameborder="no" scroll="no" src="' + recharge_link + '"></iframe>';
        $("#frame_wrap").append(frameCode);
        $(".game_wrap").css('display', 'block');
    }
}
resetDomain();　// todo 2018-4-25 进行屏蔽，点击广告后 document.domain 问题

$(document).ready(function(){
    $("#recharge").live('click', function() {
        open_pay();
        return false;
    });


    $(".close_pay").live('click', function() {
        $(".game_wrap").css('display', 'none');
        $("#frame_wrap").empty('');
    });
});

