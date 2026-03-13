$('.toggle').click(function(e){
     e.preventDefault();
    var element = $(e.currentTarget),elementClass = element.data('class-toggle');
    $("#mainmenu"+elementClass).slideToggle("fast");
});

$('.stoggle').click(function(e){
     e.preventDefault();
    var element = $(e.currentTarget),elementClass = element.data('class-toggle');
    $('html,body').animate({scrollTop: $("#modelsbox").offset().top}, 'fast');
    $("#mainmenu"+elementClass).slideToggle("fast");
});

function toggle(id) {
 var e = document.getElementById(id);
    if (e.style.display == '')
    e.style.display = 'none';
      else
    e.style.display = '';
     }


$('#filtmenu a').on('click', function (e) {
        e.preventDefault();
        $('#filtmenu a').css("background-color","");
        $(this).css("background-color","lightgreen");
        var cat = $(this).data('categoryType');
        $('.list > li').hide();
        $('.separator').hide();
        $('.list > li[data-category-type*="'+cat+'"]').show();
         
    });
    
$('#filtmenu a.reset').on('click', function (e) {
        e.preventDefault();
        $('#filtmenu a').css("background-color","");
        $('.list > li').show();
        $('.separator').show();
         
    });
