var videos, videoNum;
var bpm, rhythm;
var count;
var timer;
var audio;
var generateFlag;

// ビデオを止める
function stopVideo(v){
    $(v).css("opacity", 0);
    v.pause();
    clearTimeout(timer);
    count++;
    if(count < videoNum && generateFlag){
        playVideo(videos[count]);
    }
}

// ビデオをループさせる
function loopVideo(v){
    v.currentTime = 0;
    v.play();
}

// ビデオを再生する
function playVideo(v){
    $(v).css("opacity", 1);
    v.play();
    v.addEventListener("ended", function(){loopVideo(v)}, false);
    timer = setInterval(function(){stopVideo(v)}, rhythm);
    audio.play();
}

// ビデオを強制終了
function stopForce(v){
    v.pause();
    $(v).css("opacity", 0);
    location.href =　"/"; // トップに戻る　
}

// ビデオをジェネレートをやめる
function stopGenerateMovie(){
    generateFlag = false;
    stopForce(videos[count]);
}

// オーディオが止まったら、ビデオを止める
function stopAudio(a){
    a.addEventListener("ended", function(){stopGenerateMovie()}, false);
}

// 初期化
function init(){
    audio = $('#audio').get(0);
    videos = $('.video');
    bpm　=　parseInt($("#bpm").html()) || 120;
    generateFlag = true;
    videoNum = videos.length;
    rhythm = 60000 / bpm * 4;
    count = 0;
    for(var i=0; i < videoNum; i++){
        videos[i].muted = true;
        videos[i].load;
    }
}

$(function(){
    init();
    playVideo(videos[count]);
    stopAudio(audio);
});
