function overlayShow(){
    document.getElementById('overlay-fade').style.display='block';
    document.getElementById('overlay-box').style.display='block';
    document.getElementById('overlay-box').onclick=overlayHide;
    document.getElementById('overlay-fade').onclick=overlayHide;
}
function overlayHide(){
    document.getElementById('overlay-fade').style.display='none';
    document.getElementById('overlay-box').style.display='none';
}
function overlaySet(content){
    document.getElementById('overlay-box').innerHTML=content+'<br/><a onclick="overlayHide();" href="javascript:void(0)">[close]</a>';
}
function overlaySetImage(src){
    document.getElementById('overlay-box').innerHTML='<a href="'+src+'" target="_blank"><img class="overlayimg" src="'+src+'"></a><br/><div class="overlaytxt">Click image for fullsize version<br/></div>';
}
