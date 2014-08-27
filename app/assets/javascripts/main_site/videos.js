$(document).ready(function() {
  
  if ($('body').attr('id') == 'video-palette') $('.tipTip').tipTip();
  
  $("#new_purchase #purchase_submit").live('click', function() {
    var name = $.trim($('#purchase_name').val());
    var email = $.trim($('#purchase_email').val());
    if (name.length < 2 || email.length < 5) {
      alert("Please enter your name and email address to send the download code to");
      return false;
    }
  });
});