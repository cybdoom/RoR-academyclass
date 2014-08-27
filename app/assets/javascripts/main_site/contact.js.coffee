jQuery ->
  $("#contact_submit").on 'click', ->
    $("#contact_submit").attr("disabled", true)
    pageTracker._trackPageview('/goal/Contact-Form-Enquiry') if (typeof pageTracker != 'undefined')
    
    jQuery.ajax {
      data: $("#new_contact").serialize()
      url: $("#new_contact").attr('action')
      type: "POST"
      dataType: "text"
      error: ->
        $("#contact_submit").attr("disabled", false)
        alert("Problem submitting your contact form. Please check all the required fields have been completed and try again")
      success: (data) ->
        $("#contact_submit").attr("disabled", false)
        $(".flash-success").html(data)
        $(".inputs input, .inputs textarea").val("")
        $.event.trigger({type: "ContactSubmitFormSuccessEvent"})
        alert("Your contact enquiry has been submitted successfully")
    }
    false
