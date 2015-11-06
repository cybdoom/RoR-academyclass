$(document).ready(function() { 
  copy_content();
  adjust_calendar_heights();
  
  function track_page_view(page) {
    if (typeof pageTracker != 'undefined') {
      pageTracker._trackPageview(page);
    }
  }
  
  $('.book-now a').click( function() {
    $(this).closest('.course_information').find('.enquire a').trigger("click");
    return false;
  });
  
  $('.live-chat').click( function() {
    track_page_view('/goal/livechat/' + $(this).closest('.course_information').data('page-tracker'));
    $('#live-chat a').trigger("click");
    return false;
  });
  
  $('.email-course a').click(function(){
    track_page_view('/goal/email-details/' + $(this).closest('.course_information').data('page-tracker'));
    var id = $(this).attr("id").match(/email_course_details_(.*)/)[1];
    $('#course_detail_enquiry_course_id').val(id);
    $.facebox({div: $(this).attr("href") });
    return false;
  });
  
  //$('#product-page .download-course a').click(function() {
    //track_page_view('/goal/download-pdf/' + $(this).closest('.course_information').data('page-tracker'));
    //return true;
  //});
  
  $('.date-picker .date a').live("click", function(){
    var $this = $(this),
        city = $this.closest('.city').find('.city_name').text(),
        date = $this.closest('.month').attr('class').match(/(.*) month/)[1] + $this.text().replace(/\s/g,'');
    $(this).closest('.course_information').find('.enquire a').trigger("click");
    $this.closest('.course_information').find('.map_marker_'+city).trigger("click");
    $this.closest('.course_information').find('.course-enquire .cities .'+city+' a.'+date).trigger("click");
    return false;
  });
  
  $('.calendar-right').live('click', function(){
    var $calendar = $(this).siblings('.calendar'), 
        $remaining_months = $calendar.find('.header .months li').not('.collapsed');
    if ($remaining_months.length > 4) {
      var month = $remaining_months.first().attr('class').match(/(.*) month/)[1];
      
      $calendar.find('li.'+month).animate({width: 0}, 600, 'linear', function(){$(this).addClass('collapsed')});
    }
    return false;
  });
  
  $('.calendar-left').live('click', function(){
    var $calendar = $(this).siblings('.calendar'), 
        $months = $calendar.find('.header .months li'),
        $collapsed_months = $months.filter('.collapsed');
    if ($collapsed_months.length > 0) {
      var month = $collapsed_months.last().attr('class').match(/(.*) month/)[1];
      $calendar.find('li.'+month).removeClass('collapsed').animate({width: 75}, 600);
    }
    return false;
  });
  
  $('.course-enquire .date a').live("click", function(){
    var $this = $(this),
        currently_selected = $this.hasClass('selected');
    $this.closest('.cities').find('a').removeClass('selected');
    $this.toggleClass('selected', !currently_selected);
    return false;
  });
  
  $('.map a').live('click', function() {
    var $this = $(this);
    $this.toggleClass('selected');
    $this.siblings('a').removeClass('selected');
    $this.parent().siblings('input').val($this.hasClass('selected') ? $this.text() : "" );
    $this.closest('.locations').siblings('.dates').find('.cities > li').hide();
    if ($this.hasClass('selected')) {
      $this.closest('.locations').siblings('.dates').find('.'+$this.text()).show();
    }
    return false;
  }).tipTip({edgeOffset: 10});
  
  
  $('.submit a').live('click', function() {
    var $this = $(this),
        page_tracker = $(this).closest('.course_information').data('page-tracker'),
        course_id = $this.attr('id').match(/submit_enquiry_(.*)/)[1],
        $selected_date = $this.closest('form').find('.date a.selected'),
        selected_date = "";
    track_page_view('/goal/'+ page_tracker);
    selected_date = $selected_date.closest('.month').find('span').text() + " " +  $selected_date.text();
    $("#enquire_result_"+course_id).empty();
    jQuery.ajax({
      data: $this.closest('form').serialize() + '&course_enquiry[course_id]=' + course_id + '&course_enquiry[date]=' + selected_date,
      url: "/course_enquiry",
      type: "POST",
      dataType: "json",
      success: function(data) {
        if (data.saved) {
          $.event.trigger({type: "BookSubmitFormSuccessEvent"});
        }
        $("#enquire_result_"+course_id).html(data.msg);
        $("form input[type=text]").val("");
      }
    });
    return false;
  });
  
  $("#course_detail_enquiry_submit_action input").live("click", function() {
    var $this = $(this);
    $this.attr("disabled", "1");
    $this.attr("value", "Submitting...");
    jQuery.ajax({
      type: 'POST', 
      data: $this.closest("form").serialize(), 
      dataType: 'text', 
      url: $this.closest("form").attr("action"),
      success: function(data) { $('#facebox .email-course-details-form').html(data) }
    });
    return false;
  });
  
  $('.nav').find('li:first').addClass('selected');
  
  $('.nav a').live('click', function(){
    var $link_name = $(this).text();
    var $list_item = $(this).closest('li');
    $list_item.siblings('.selected').removeClass('selected');
    $list_item.addClass('selected');
    if ($link_name == 'OVERVIEW') {
      show_overview($list_item.closest('.nav').siblings('.data-container'));
    } else if ($link_name == 'DESCRIPTION') {
      show_description($list_item.closest('.nav').siblings('.data-container'));
    } else if ($link_name == 'OUTLINE') {
      show_outline($list_item.closest('.nav').siblings('.data-container'));
    } else if ($link_name == 'WHAT YOU GET') {
      show_what_you_get($list_item.closest('.nav').siblings('.data-container'), $(this));
    } else if ($link_name == 'ENQUIRE NOW') {
      show_enquire($list_item.closest('.nav').siblings('.data-container'));
    }
    return false;
  });  
});

function copy_content() {
  $('.course_information').each(function(){
    var $this = $(this),
        location_dates = "<ul class='cities'>";
    $('.calendar li.city', this).each(function(){
      var city = $('.city_name', this).text();
      var $dates = $('.month', this).map(function(){
        var obj = {},
            month = $(this).attr('class').match(/(.*) month/)[1];
        if ($(this).find('.date').length > 0) {
          obj[month] = $(this).find('.date').map(function() {return $(this).text()}).get();
          return obj // only return if there are dates
        }
      });
      location_dates += "<li class='"+city+"'style='display: none;'><ul class='months'>"
      $dates.each(function(index, month){
        $.each(month, function(month, dates) {
          location_dates += "<li class='month'><span>" + month + "</span><ul class='dates'>";
          $.each(dates, function(index, value) {
            location_dates += "<li class='date'><a class='"+month+value.replace(/\s/g,'')+"' href='#'>" + value + "</a></li>"
          });
          location_dates += "</ul></li>";
        });
      })
      if ($dates.length == 0) location_dates += "No upcoming dates";
       location_dates += "</ul></li>"
    });
    $this
      .find('.left-column')
        .append($this.find('ul.course-details').clone(true).hide())
        .append($this.find('div.acg-acd-links').clone(true).hide())
      .end()
      .find('.course-enquire div.dates')
        .append(location_dates);
  });
}

function adjust_calendar_heights() {
  $('.calendar .city ul.months').each(function(){
    var $this = $(this),
        height = $this.height(),
        $links = $this.closest('.calendar').siblings('a');
    $('ul.dates', $this).height(height);
    $links.height($links.height() + height);
    $links.css({"line-height": $links.height() +'px'})
  });
}

function show_overview($context) {
  hide_all($context);
  $context.find('.course-image').show();
  $context.find('.course-description').show();
  $context.find('.right-column .course-details').show();
  $context.find('.date-picker').show();
  $context.find('.right-column .acg-acd-links').show();
}
function show_description($context) {
  hide_all($context);
  $context.find('.course-image').show();
  $context.find('.description').show();
  $context.find('.left-column .course-details').show();
  $context.find('.left-column .acg-acd-links').show();
}
function show_outline($context) {
  hide_all($context);
  $context.find('.course-image').show();
  $context.find('.outline').show();
  $context.find('.left-column .course-details').show();
  $context.find('.left-column .acg-acd-links').show();
}
function show_what_you_get($context, link) {
  hide_all($context);
  $context.find('.course-image').show();
  $context.find('.left-column .course-details').show();
  $context.find('.left-column .acg-acd-links').show();
  $context.find('.right-column .what-you-get').html($('#what-you-get-' + link.attr("href")).html()).show();
}
function show_enquire($context) {
  hide_all($context);
  $context.find('.course-enquire').show();
}


function hide_all($context) {
  $context.find('.course-image').hide();
  $context.find('.date-picker').hide();
  $context.find('.course-details').hide();
  $context.find('.acg-acd-links').hide();
  $context.find('.description').hide();
  $context.find('.outline').hide();
  $context.find('.course-description').hide();
  $context.find('.course-enquire').hide();
  $context.find('.what-you-get').hide();
}
