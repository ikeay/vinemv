function clearTags() {
    $("#gmv").remove();
}

function clearSearchResults() {
    $('#info').keyup(function() {
        if (!$('#info').val().length) {
            $("#output").empty();
            if ($('#gmv')) {
                clearTags();
                $('#load').css("display", "");
            }
        }
    });
}

// 自動フォーカス
function focusToForm(){
    $('#info').focus();
}

// エンターキーを押しても検索できるように
function keyPerssInForm(){
    $("#info").keypress( function(e){
        if (e.which == 13) {
            searchMusic();
            return false;
        }
    });
}

// ボタンを押して検索
function clickBotton(){
    $('#load').click(function(){
        searchMusic();
    });
}

// 配列を文字列にする
function arrayToText(array){
    var text = "";
    for(var i = 0; i < array.length; i++){
        text += array[i] + ", ";
    }
    return text;
}

// 曲を探すためにmusicメソッドにポスト
function searchMusic(){
    var info = $('#info').val();
    if(info){
        $('#loading').css("display", "block");
        if ($('#gmv')) {
            clearTags();
        }
        var req = $.ajax({
            type: 'GET',
            url: '/music',
            data: { info: info },
            success: function (json) {
                var text = '<ul id="search-list">'
                for(var i = 0; i < json.music["artist"].length; i++){
                    text += '<li><span class="info"><span class="track">' + json.music["track"][i] + '</span> / <span class="artist">' + json.music["artist"][i] + '</span><span class="id">' + json.music["id"][i] + '</span></span></li>';
                }
                text += '</ul>'
                $('#output').append(text);
                $('#loading').css("display", "none");
            },
            error: function () {
                $('#loading').css("display", "none");
                $('#output').append('error');
            }
        });
    }
}

// リストから楽曲を選ぶ
function chooseMusic(){
    $(document).on('click', '#search-list li', function(){
        $(this).css('background', '#CCCCCC');
        var artist = $('.info .artist', this).html();
        var track = $('.info .track', this).html();
        var id = $('.info .id', this).html();
        $('#loading').css("display", "block");
        var req = $.ajax({
            type: 'GET',
            url: '/fixed',
            data: {
                artist: artist,
                track: track,
                id: id
            },
            success: function (json) {
                $("#output").empty();
                $("#load").css("display", "none");
                $("#info").val(json.track + ' / ' + json.artist);
                $("#form").append('<form id="gmv" action="result" method="post"> <div id="search-items"> <div id="bpm-wrap"> <div class="form-label">BPM</div> <input id="bpm" class="form-content" name="bpm" type="number"> </div> <div id="tags-wrap"> <div class="form-label">TAGS</div> <input id="tags" class="form-content" name="tags" type="text" value="' + arrayToText(json.tags) + '"> </div> <input id="track-id" name="id" value="' + json.id + '"> </div> <input id="generate" class="btn" type="submit" value="MVを生成する"> </form>');
                $('#loading').css("display", "none");
            },
            error: function () {
                $('#output').append('error');
                $('#loading').css("display", "none");
            }
        });
    });
}

// ジェネレートボタンが押されたら
function pushGButton(){
    $(document).on('click', '#generate', function(){
        $('#loading').css("display", "block");
    });
}

$(function(){
    clearSearchResults();
    focusToForm();
    keyPerssInForm();
    clickBotton();
    chooseMusic();
    pushGButton();
});