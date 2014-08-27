$(document).ready(function() { 
  $("li.course_link").each(function() {
    var course_link_position = $(this).position();
    var course_link_height = $(this).outerHeight();
    var course_info_height = $('ul', this).outerHeight();
    var bounding_box_height = $(this).parents(".course_buttons_wrapper").outerHeight();
    var course_link_middle_position = course_link_position.top + (course_link_height / 2 );
    var course_info_top = 0;
    
    if ( course_link_middle_position > (course_info_height / 2)) {
      course_info_top = course_link_middle_position - (course_info_height / 2);
    }
    if (course_info_top + course_info_height > bounding_box_height) {
      course_info_top = bounding_box_height - course_info_height;
    }
    $('ul', this).css({top: course_info_top});
  });
  // $("li.course_link").hover(function(){$('ul', this).css({display: 'block'})}, function() {$('ul', this).css({display: 'none'})});
});