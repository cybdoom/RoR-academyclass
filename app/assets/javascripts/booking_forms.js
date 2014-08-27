//= require jquery
//= require_tree ./shared/
//= require_self

$(document).ready(function() {
  $('a[rel*=facebox]').facebox();

  $("#accurate_0").click(function() {
    $("#change").show();
    $("#payment").hide();
  });
  $("#accurate_1").click(function() {
    $("#change").hide();
    $("#payment").show();
  });
  
  $("input.choose-invoice").click(function() {
    $(this).closest("form").find("#invoice").val("1");
    pageTracker._trackPageview('/goal/pay-booking-form');    
  });
  
  $("form.edit_booking_form #delivery_location").change(function() {
    toggleDeliveryLocation();
  });
  
  $("#booking_form_booking_form_response_attributes_latest_version").change(function() {
    toggleSoftwareDetails();
  });
  
  toggleDeliveryLocation();
  toggleSoftwareDetails();
  
  $("form.edit_booking_form").submit(function() {
    var error = "";
    if ($('#booking_form_booking_form_response_attributes_address').length > 0) {
      error += validateInput('#booking_form_booking_form_response_attributes_address') ? "Please provide the actual training address\n" : "";
      if (!$("#delivery_location").attr('checked')) error += validateInput('#booking_form_booking_form_response_attributes_delivery_address') ? "Please provide the book delivery address\n" : "";
      error += validateInput('#booking_form_booking_form_response_attributes_contact_name') ? "Please provide the contact name\n" : "";
      error += validateInput('#booking_form_booking_form_response_attributes_contact_phone') ? "Please provide the contact phone number\n" : "";
      if (!$("#booking_form_booking_form_response_attributes_latest_version").attr('checked')) error += validateInput('#booking_form_booking_form_response_attributes_software_details') ? "Please provide the software version details\n" : "";
      
    }
    if (error.length > 0) {
      alert(error);
      return false;
    }
    return true;
  });
  
  function validateInput(id) {
    if ($(id).val().length == 0) {
      $(id).parent().addClass('error');
      return true;
    } else {
      $(id).parent().removeClass('error');
      return false;
    }
  }
  
  function toggleDeliveryLocation() {
    var checked = $("form.edit_booking_form #delivery_location").attr("checked");
    $(".delivery-address").css("display", checked ? "none" : "block");
    if (checked) {
      $("#booking_form_booking_form_response_attributes_delivery_address").val("");
    }
  }
  
  function toggleSoftwareDetails() {
    var checked = $("#booking_form_booking_form_response_attributes_latest_version").attr("checked");
    $(".software-details").css("display", checked ? "none" : "block");
    if (checked) {
      $("#booking_form_booking_form_response_attributes_software_details").val("");
    }
  }
});