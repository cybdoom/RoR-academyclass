$(document).ready(function() {
  $("#certifications #button-bar div a").click(function() {
    click_tab($(this).attr('href'));
    return false;
  });


  if ($('body').attr('id') == 'certifications') {
    $(window).bind('hashchange', function(event) {
      var hash = window.location.hash;
      if (hash.length > 4) {
        if (hash.substr(0, 6) == '#adobe') click_tab('#adobe');
        else if (hash.substr(0, 6) == '#apple') click_tab('#apple');
        else if (hash.substr(0, 9) == '#autodesk') click_tab('#autodesk');
        document.getElementById(hash.substr(1)).scrollIntoView(true);
      }
    });  
    $(window).trigger('hashchange');
  }

  function click_tab(name) {
    $("#certifications #button-bar div").removeClass('selected');
    $(name + '-button').addClass('selected');
    $('.product').addClass('hidden');
    $(name).removeClass('hidden');
  }
});