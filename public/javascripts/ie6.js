$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function() {
  $(".dropdown").each(function(e) {
    $(this).children().hover(
      function() {
        if ($(this).children().size() == 1) $(this).css("background", "url('/images/menu/rolloverstate1.png') repeat-x");
      },
      function() {
        if ($(this).children().size() == 1) $(this).css("background", "");
      }
    );
  });
  // Fix png images for stupid ie 6
  $("img, #top-courses h2").ifixpng();

  $('.course_buttons_wrapper').each(function(){
    $(this).css({background: '#3f3f3f url()'});
    $('ul, li, span', this).css({background: 'none', color: 'white'});
  });
  $(".creative_licences_nav li").hover(function(){
    $(this).addClass("hover")
  }, function(){
    $(this).removeClass("hover")
  })
});
