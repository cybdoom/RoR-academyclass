$(function() {
  $("select.platform_select").change(function() {
    var delId = $(this).data("id");
    var platformId = $(this).val();
    var url = "/booking_delegates/" + delId + "/platform";

    $.post(url, {platform: platformId});
  });
});
