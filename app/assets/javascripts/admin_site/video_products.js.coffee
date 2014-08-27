jQuery ->
  $('#video-product-mappings ul.table .video_product a').click ->
    original = $(this)
    $(".video-product-options").remove()
    $(this).parent().append("<div class='video-product-options'>#{$("#video-products").html()}</div>")
    
    $(".video-product-options a").click ->
      a = $(this)
      id = a.closest('.video_product').data('mapping-id')
      url = a.attr('href').replace(/mapping-id/, id)
      $.ajax {
        url: url
        type: "POST"
        data: {"_method": "PUT", "authenticity_token": $("meta[name=csrf-token]").attr("content")}
        success: ->
          $(".video-product-options").remove()
          original.html(a.html())
      }
      return false
    return false
    
  $('body#video-product li#videos ol').sortable()
  
  $('body#video-product .delete a').click ->
    
    $.ajax {
      url: $(this).attr('href'),
      type: "DELETE"
    }
    $(this).closest('li').remove()
    return false
  
  $('form.video_product ul#members').bind 'sortupdate', =>
    $(".sortable").children().each (index) ->
      $(this).attr("class", if index % 2 == 0 then "" else "alt_row")
      id = "#video_product_video_product_members_attributes_#{$(this).data('sequence')}_sequence"
      $(id).val(index+1)