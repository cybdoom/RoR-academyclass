$(document).ready(function() {
  if ($('body').attr('id') == "creative-licence-page") {
    $(".save ul#creative-licences li.selectable").click(function() {
      $(".save ul#creative-licences li").removeClass("selected");
      $(this).addClass("selected");
      $(".content").hide();
      $("#" + $(this).attr("id") + "_content").show();
  
      $(".save .content ul.submenu li").removeClass("selected");
      var first = $("#" + $(this).attr("id")+"_content .submenu li:first");
      $(first).addClass("selected");
      $(".subcontent").hide();
      $("#" + first.attr("id") + "-subcontent").show();
    });
    
    $(".save a.box-link").click(function() {
      licence_link_click($(this).attr('href'));
    });
    
    if ($('body').attr('id') == 'creative-licence-page') {
      $(window).bind('hashchange', function(event) {
        var hash = window.location.hash;
        if (hash.indexOf('_content') > 5) {
          licence_link_click(hash);
          document.getElementById(hash.substr(1)).scrollIntoView(true);
        }
      });  
      $(window).trigger('hashchange');
    }
    
    jwplayer('video-1').setup({'flashplayer': '/video/player.swf', 'id': 'player1', 'width': '500', 'height': '294', 'file': '/video/creative-licence-video-1.flv', 'image': '/images/creative_licence/video/editing.jpg'});
    jwplayer('video-2').setup({'flashplayer': '/video/player.swf', 'id': 'player1', 'width': '500', 'height': '294', 'file': '/video/creative-licence-video-2.flv', 'image': '/images/creative_licence/video/colour.jpg'});
    jwplayer('video-3').setup({'flashplayer': '/video/player.swf', 'id': 'player1', 'width': '500', 'height': '294', 'file': '/video/creative-licence-video-3.flv', 'image': '/images/creative_licence/video/effects.jpg'});
    
  }
    
  
  function licence_link_click(href) {
    var id = href.substr(0, href.indexOf('_content'));
    $(".save ul#creative-licences li").removeClass("selected");
    $(id).addClass("selected");
    $(".content").hide();
    $(id + "_content").show();

    $(".save .content ul.submenu li").removeClass("selected");
    var first = $(id+"_content .submenu li:first");
    $(first).addClass("selected");
    $(".subcontent").hide();
    $("#" + first.attr("id") + "-subcontent").show();
  }
  
  $(".save .content ul.submenu li").click(function() {
    $(".save .content ul.submenu li").removeClass("selected");
    $(this).addClass("selected");
    $(".subcontent").hide();
    $("#" + $(this).attr("id") + "-subcontent").show();
    set_creative_licence_image($("#" + $(this).attr("id") + "-subcontent"), $(this));
  });

  $(".save .switch").click(function() {
    if ($(this).hasClass("active")) $(this).removeClass("active");
    else $(this).addClass("active");
    set_creative_licence_image($(this).closest(".subcontent"), $(this));
  });
  
  function set_creative_licence_image(subcontent, clicked) {
    var id = subcontent.attr("id").substr(0, subcontent.attr("id").indexOf("-"));
    var content_box_id = clicked.closest(".content").attr("id");
    content_box_id = content_box_id.substr(0, content_box_id.indexOf("_"));
    if (content_box_id == "designer") {
      var first = subcontent.find(".switch:first").hasClass("active") ? "1" : "0";
      var last = subcontent.find(".switch:last").hasClass("active") ? "1" : "0";
      if (first == "1" && last == "1") id = "photoshop"
      subcontent.closest(".content").find(".creative-licence-image").attr("src", $('#' + content_box_id + "-" + id + "-" + first + "-" + last).attr('src'));
    } else {
      subcontent.closest(".content").find(".creative-licence-image").attr("src", $('#' + content_box_id + "-" + id).attr('src'));
    }
  }
});