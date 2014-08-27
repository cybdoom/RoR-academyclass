$(document).ready(function() {

   $("li[class=enquire]").on("click", function(){
     ga("send", "event", "button", "click", "BookRequestFormTop", 1);
   });

   //$('a[id^="submit_enquiry_"]').on("click", function(){
      //ga("send", "event", "enquiry", "form", "BookSubmitForm", 1);
   //});

   $(document).on("BookSubmitFormSuccessEvent", function() {
      ga("send", "event", "enquiry", "form", "BookSubmitForm", 1);
   });

   $(".book-now a").on("click", function(){
     ga("send", "event", "button", "click", "BookRequestFormBottom", 1);
   });

   $(".download-course a").on("click", function(){
     ga("send", "event", "PDF", "download", "CourseContent", 1);
   });

   $(".live-chat a").on("click", function(){
     ga("send", "event", "Chat", "click", "RequestChat", 1);
   });

   $(".email-course a").on("click", function(){
     ga("send", "event", "PDF", "EmailRequest", "CourseDetails", 1);
   });

   $(document).on("click", "#clickdesk_online_submit_text", function(){
     ga("send", "event", "Chat", "Form", "InitiateChat", 1);
   });

   $("#general_enquiries").on("click", function(){
     ga("send", "event", "Enquiry", "Email", "GeneralEnquiries", 1);
   });

   $("#training_enquiries").on("click", function(){
     ga("send", "event", "Enquiry", "Email", "TrainingEnquiries", 1);
   });

   $("#support_enquiries").on("click", function(){
     ga("send", "event", "Enquiry", "Email", "SupportEnquiries", 1);
   });

   //$("#contact_submit").on("click", function(){
   $(document).on("ContactSubmitFormSuccessEvent", function() {
     ga("send", "event", "Enquiry", "Form", "ContactPageEnquiry", 1);
   });

   //$(document).on("click", "#newsletter_subscription_submit_action input[type=submit]", function(){
   $(document).on("NewsletterSubscriptionSubmitFormSuccessEvent", function() {
     ga("send", "event", "Subscribe", "Form", "NewsletterSubscription", 1);
   });

   $('#social-media-icons img[title="Facebook"], #facebook').on("click", function(){
     ga("send", "event", "externalLink", "click", "Facebook", 1);
   });

   $('#social-media-icons img[title="Twitter"], #twitter').on("click", function(){
     ga("send", "event", "externalLink", "click", "Twitter", 1);
   });

   $('a[href="#newsletter-form"], #popup-newsletter').on("click", function(){
     ga("send", "event", "button", "click", "NewsletterRequest", 1);
   });
  
});
