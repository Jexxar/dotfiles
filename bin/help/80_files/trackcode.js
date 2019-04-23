(function (win,doc) {
    var isPlaysnailDomain = /(^\.?|\.)vivagames.me/.test(doc.domain);
    var GTPlaysnailDomain = /(^\.?|\.)vivagames.me/.test(doc.domain);
    var request_add = 'http://storm.vivagames.me/static_resource/game_callback';
    window.__game = {
        collect: function (x, s) {
            console.log('JS Callback Start;');
            console.log('Parameter x:' + x);
            console.log('Parameter s:' + s);
            if (isPlaysnailDomain || GTPlaysnailDomain) {
                $.ajax({
                    type: "post",
                    url: request_add,
                    data: {level:x ,server_id:s},
                    dataType:"jsonp",
                    success: function(data){
                        if(data.error_code > 0){
                            $('body').append(data.msg);
                        }else{
                            if(data.get_user_character == 'success') {
                                //window.parent.showGuidesBox(data.character_name);
                            }
                            if(data.script == 'undefined' || data.script == '' || data.script == null) {
                            } else {
                                $('body').append(data.script);
                            }
                        }
                    }
                });
            }
        },
        pay: function () {
            if (isPlaysnailDomain || GTPlaysnailDomain) {
                this.resetDomain();
                window.parent.open_pay();
            }
        },
        resetDomain: function () {
            var domainArr = window.document.domain.split(".");
            window.document.domain = domainArr[domainArr.length - 2] + "." + domainArr[domainArr.length - 1];
        }
    };
})(window,document)
