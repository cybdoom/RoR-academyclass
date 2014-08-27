//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree ./shared/
//= require_self
//= require_tree ./main_site/

$.ajaxSetup({
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript"); 
  }
})

var scrollerInterval;
var scrollButton;
var menuTimeouts = [];

function fadeMenu(i) {
  if (menuTimeouts[i]) {
    var menu = menuTimeouts[i][0];
    if ($.support.opacity) menu.fadeTo('slow', 0, function() { menu.css("visibility", "hidden"); });
    else menu.css("visibility", "hidden");
  }
}

$(document).ready(function() {
  // auto focus on any field with a focus class
  $(".focus").focus();
  
  $(".product_link").click(function() {
    $.post($(this).attr("href"), null, $(this).parent().toggleClass("selected_item"));
    return false;
  });
    
  $('a[rel*=facebox], #newsletter').facebox();
  
  $(".meet-the-team #button-bar div").click(function() {
    var clicked = $("#" + $(this).attr("id") + "-content");
    $(".pics:not(.hidden)").fadeTo('fast', 0, function() {
      $(".pics:not(.hidden)").addClass("hidden");
      clicked.removeClass('hidden');
      clicked.fadeTo('slow', 1);
      click_staff($(clicked.find("a:first").attr("href")));
    });
  });
  $(".meet-the-team ul a").click(function() {
    click_staff($($(this).attr("href")));
  });
  
  function click_staff(staff) {
    $(".instructorBox:not(.hidden)").fadeTo('fast', 0, function() {
      $(".instructorBox:not(.hidden)").addClass("hidden");
      staff.removeClass('hidden');
      staff.fadeTo('slow', 1);
    });
  }
  
  $("#newsletter_subscription_submit_action input").live("click", function() {
    var $this = $(this);
    var div = $this.closest(".form-container");
    $this.attr("disabled", "1");
    $this.attr("value", "Submitting...");

    jQuery.ajax({
      type: 'POST', 
      data: $this.closest("form").serialize(), 
      dataType: 'json', 
      url: $this.closest("form").attr("action"),
      success: function(data) {
        if (data.saved) {
          $.event.trigger({type: "NewsletterSubscriptionSubmitFormSuccessEvent"})
        }
        div.replaceWith(data.partial)
      }
    });
    return false;
  });

  var htmlStr;
  $(".read-more").toggle(
    function(){
      htmlStr = $(this).html();
      $(this).html("Collapse &#0060;");
      var selector = $(this).attr('href').length > 1 ? $(this).attr('href') : '.additional-information';
      $(selector).show("blind",null,500,null);
    }, function(){
      $(this).html(htmlStr);
      var selector = $(this).attr('href').length > 1 ? $(this).attr('href') : '.additional-information';
      $(selector).hide("blind",null,500,null);
  });
  
  // for creative licence page
  if ( $.browser.msie ) {
    var $nav_li_elements = $(".creative_licences_nav li");
    $nav_li_elements.last().addClass("last-child")
    $nav_li_elements.first().addClass("first-child")
  }
  
  //set_content_height(".current div.content");
  $('.current div.content').equalizeHeights();
  
  $(".creative_licences_nav li").click(function(){
    var $this = $(this),
        clicked_element = $this.attr("id").match(/([\w]+)_nav/)[1]
    $(".current").removeClass("current");
    $this.addClass("current");
    $("#"+clicked_element+"_content").addClass("current");
    $('.current div.content').equalizeHeights();
  });
  
  $("div.enquire a").bind('click', function(){
    var $level = $(this).parents("li.level");
        level_name = $level.find("span.level_name span.name").text();
    $("#enquire-form").find("span.level").text(level_name);
  }).facebox();
  
  $(".course-list-box ul").each(function(index, element) {
    $(element).animate({top: -1 * ($(element).height() - 183) / 2});
  });
  $(".course-list-box .button.arrow-up, .course-list-box .image-up").click(function() {
    clearInterval(scrollerInterval);
    scrollButton = $(this);
    scroll_box_up();
  });

  $(".course-list-box .button.arrow-up, .course-list-box .image-up").mouseover(function() {
    clearInterval(scrollerInterval);
    scrollButton = $(this);
    scrollerInterval = setInterval("scroll_box_up()", 300);
  });

  $(".course-list-box .button.arrow-down, .course-list-box .image-down").click(function() {
    clearInterval(scrollerInterval);
    scrollButton = $(this);
    scroll_box_down();
  });

  $(".course-list-box .button.arrow-down, .course-list-box .image-down").mouseover(function() {
    clearInterval(scrollerInterval);
    scrollButton = $(this);
    scrollerInterval = setInterval("scroll_box_down()", 300);
  });

  $(".course-list-box .button.arrow-up, .course-list-box .image-up, .course-list-box .button.arrow-down, .course-list-box .image-down").mouseout(function() {
    clearInterval(scrollerInterval);
  });
});

function scroll_box_up() {
  var ul = scrollButton.closest(".course-list-box").find("ul");
  var top = ul.css("top").match(/[\-\d]+/);
  top = parseInt(top[0]);
  if (top >= 12) {
    clearInterval(scrollerInterval);
    return;
  }
  top = top + 20 > 12 ? 20 : top + 20;
  ul.css("top", (top) + "px");
}

function scroll_box_down(button) {
  var ul = scrollButton.parent().find("ul");
  var top = ul.css("top").match(/[\-\d]+/);
  top = parseInt(top[0]);
  if (top <= -1*(ul.height() - 190)) {
    clearInterval(scrollerInterval);
    return;
  }
  ul.css("top", (top - 20) + "px");
}

function set_content_height(context) {
  var max_height = 0
  $(context).each(function(){
    max_height = $(this).height() > max_height ? $(this).height() : max_height;
  });
  $(context).height(max_height);
}


$.fn.equalizeHeights = function(){
  return this.height( Math.max.apply(this, $(this).map(function(i,e){ return $(e).height() }).get() ) )
}
