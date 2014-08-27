//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree ./shared/
//= require_tree ./admin_site/
//= require_self

$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function() { 
  // auto focus on any field with a focus class
  $(".focus").focus();
  $("textarea:not(.basic-input)").markItUp(mySettings);
  $('a.facebox').facebox();
  
  $(".datepicker").datepicker({numberOfMonths: 3, showButtonPanel: true, dateFormat: "dd MM yy"});
  
  $("#search_form #search").keyup(function() {
    $("#search_form .working").removeClass('hidden');
    $.ajax({
      url: $("#search_form").attr('action'),
      data: { "search": $(this).val() },
      dataType: "html",
      type: "get",
      success: function(data) {
        $("#search_form .working").addClass('hidden');
        $("ul.table.booking-forms").replaceWith(data);
        $('#search').val() == "" ? $('.pagination').show() : $('.pagination').hide();
      }
    })
  });


  $(".product_link").click(function() {
    $.post($(this).attr("href"), null, $(this).parent().toggleClass("selected_item"));
    return false;
  });
  
  $("form#email-logs #type").change(function() { $(this).closest("form").submit(); });
  
  if ($("#course_what_you_get").length == 1) {
    if ($("#course_course_template_id").val() != "") $("#course_what_you_get_input").hide();
    $("#course_course_template_id").change(function() {
      if ($("#course_course_template_id").val() == "") $("#course_what_you_get_input").show();
      else $("#course_what_you_get_input").hide();
    });
  }
  
  $(".select_image").live("click", function() {
    if ($("#image-type").val() == "1") {
      $("#image-id").val(this.id.substr(6));
      $("#product-image").html(this);
    } else {
      $("#course-palette-id").val(this.id.substr(6));
      $("#course-palette-image").html(this);
    }
    $.facebox.close();
    return false;
  });
  
  $("#image-type").change(function() { $(this).closest("form").submit(); });
  $('a[rel*=facebox]').facebox();
  
  $(".copy-outline").click(function() { return copy_outline() });
  suggest_trainers();
  
  $(".sortable").sortable({
    cursor: 'auto',
    opacity: 0.4,
    scroll: true,
    placeholder: 'ui-state-highlight',
    forcePlaceholderSize: true,
    handle: ".drag-handle",
    items: "li:not(.header,.section-title)"
  });
  $(".connected-sortable").sortable("option","connectWith", ".connected-sortable");

  selected_salesperson = function(s) {
    return s.replaceWith(s.find("option:selected").text().replace(/>/, "&gt;").replace(/</, "&lt;") + " on " + (new Date()).toUTCString());
  }
  
  $("#assign-recipient").change(function() {
    var select = $(this);
    $.ajax({
      type: "post",
      url: select.closest("form").attr("action"),
      data: select.closest("form").serialize(),
      success: function(data) { selected_salesperson(select) },
      error: function() { alert("An error occurred sending this message to the selected sales person. Please try again later")}
    });
  });
  
  $("#user_type").change(function() {
    $(this).closest('form').submit();
  })
  
  $('form.user #user_user_type').change(function() {
    $('#select-video-groups').attr("style", "display:" + ($(this).val() == 3 ? "block" : "none"));
  });
  
  $("#booking_forms select#status").change(function() { $(this).closest("form").submit(); });
  $("a.cancel-booking, a.complete-booking").click(function() {
    var li = $(this).closest('li');
    if (confirm($(this).data("confirm"))) {
      $.ajax({
        url: $(this).attr("href"),
        type: "POST",
        dataType: "html",
        success: function() { li.animate({"height": 0}, 'fast', 'linear', function() { li.remove(); }); }
      });
    }
    return false;
  });
  
  function copy_outline() {
    if (confirm("Are you sure you want to overwrite the overview text with the outline text?")) {
      bolds = [];
      var lines = $("#course_outline").html().split(/\n/);
      for (var i = 0; i < lines.length; i++) {
        var matches = lines[i].match(/(\*\S.*\S\*)+/);
        if (matches != null) {
          for (var j = 1; j < matches.length; j++) {
            if (matches[j] != null) bolds.push(matches[j]);
          }
        }
      }
      $("#course_overview").val(bolds.join("\n"));
    }
    return false;
  }
  
  function suggest_trainers() {
    if ($("#trainer_name").length == 0) return;
    $("#trainer_name").autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "/trainers/search/" + encodeURIComponent(request.term),
          dataType: "json",
          success: function(data) {
            var results = $.map(data, function(item) {
              return {
                label: item.trainer.name,
                value: item.trainer.name,
                id: item.trainer.id,
              }
            });
            results.push({label: "Add trainer: " + request.term, value: request.term, id: 0});
            response(results);
          }
        })
      },
      minLength: 1,
      select: function(event, ui) { select_trainer(ui.item); }
    });
  }
  
  function select_trainer(data) {
    if (data.id) {
      set_trainer({trainer: data});
    } else {
      create_trainer(data);
    }
  }
  
  function create_trainer(data) {
    $.ajax({url: "/trainers", dataType: "json", data: {trainer: {name: data.value}}, type: "post", success: function(data) { set_trainer(data); }});
  }
  
  function set_trainer(data) {
    if (data.error) {
      alert("Error creating this trainer:\n\n" + data.error);
    } else {
      $("#trainer_name").val(data.trainer.name);
      $("#survey_trainer").val(data.trainer.id);
    }
  }
});