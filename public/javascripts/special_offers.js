$(document).ready(function() {
  $('a.select-courses').click(function() {
    if ($(this).data('on')) {
      $(this).html('Select courses');
      $('#select-courses').slideUp();
      $(this).data('on', false);
    } else {
      $(this).html('Hide courses');
      $('#select-courses').slideDown();
      $(this).data('on', true);
    }
    return false;
  });
  
  $('form.special_offer ul.products .courses a').click(function() {
    var form = $(this).closest('form');
    var id = $(this).data('course-id');
    if ($(this).hasClass('selected')) {
      $('li#select-courses a[data-course-id=' + id + ']').removeClass('selected');
      var rowId = $('ul#selected-courses li[data-course-id=' + id + ']').data('row-id');
      if (rowId == null) {
        $('ul#selected-courses li[data-course-id=' + id + ']').remove();
      } else {
        $('ul#selected-courses li[data-course-id=' + id + ']').hide();
        $('ul#selected-courses li[data-course-id=' + id + ']').append('<input type="hidden" name="special_offer[special_offer_course_dates_attributes][' + rowId + '][_destroy]" value="1" />');
      }
    } else {
      jQuery.facebox({ ajax: '/special_offer_course_dates/new?course_id=' + id });
//      form.append('<input type="hidden" name="special_offer[special_offer_courses][' + id + ']" id="special_offer_course_' + id + '" value="' + id + '" />');
    }
    return false;
  });
  
  $('#special_offer_course_date_submit').live('click', function() {
    var form = $(this).closest('form');
    $.ajax({
      data: form.serialize(),
      url: form.attr('action'),
      type: 'POST',
      success: function(data) {
        $('ul.courses a[data-course-id=' + $('#special-offer-course-date').data('course-id') + ']').addClass('selected');
        jQuery(document).trigger('close.facebox')
        $('ul#selected-courses').append(data);
        $('ul#selected-courses li.none').remove();
      },
      error: function() {
        alert("Error: please check you've entered valid values");
      }
    });
    return false;
  });
  
  $('#facebox #special-offer #booking_form_submit').live('click', function() {
    return validate_value("booking_form_contact_name", "name") && 
      validate_value("booking_form_contact_email", "email") &&
      validate_value("booking_form_telephone", "telephone number") &&
      validate_value("booking_form_address", "address") &&
      validate_value("booking_form_postcode", "postcode");
  });
  
  function validate_value(id, field) {
    var val = $("#" + id).val();
    val.trim();
    if (val.length == 0) {
      $("#" + id).focus().parent().addClass('error')
      alert("Please enter your " + field);
      return false;
    }
    return true;
  }
});
