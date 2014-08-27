//= require jquery
//= require_tree ./shared/
//= require_self

$(document).ready(function() {

  $("#anonymous").click(function() {
    $("#survey_response_name").val("");
    $("#survey_response_company").val("");
    $("#survey_response_name").attr("disabled", $("#anonymous:checked").length == 1);
    $("#survey_response_company").attr("disabled", $("#anonymous:checked").length == 1);
  });
});