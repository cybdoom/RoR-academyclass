jQuery ->
  slugify = (str) ->
    str= str.toLowerCase().replace(/[^a-z0-9 ]/g, "").replace(/\s/g, "-")
  
  $('#video_tag_type_name').keyup ->
    $('#video_tag_type_slug').val(slugify($(this).val()))
    
  $('#video_product_name').keyup ->
    $('#video_product_slug').val(slugify($(this).val()))
    
  $('#videos .delete a').click ->
    a = $(this)
    if confirm("Are you sure?")
      $.ajax {
        url: a.attr("href")
        data: {"_method": "DELETE"},
        type: "DELETE"
        success: ->
          a.closest('li').remove()
      }
    return false
  
  video_url_is_valid = (url) ->
    url.match(/http:\/\/player.vimeo.com\/video\/[0-9]{8}/) || 
    url.match(/youtu.be\/[^#\&\?]{4,16}/) ||
    url.match(/youtube.com\/embed\/[^#\&\?]{4,16}/) ||
    url.match(/youtube.com\/watch\?v=[^#\&\?]{4,16}/)

  $('.download-from-vimeo a').click ->
    unless video_url_is_valid $('#video_video_url').val()
      alert("The URL isn't recognised. It should look like this: http://player.vimeo.com/video/12345678 or this: http://youtu.be/LfAVDuVUMzo")
      return false

    button = $(this)
    button.attr("disabled", true)
    $('.loading-image').show()
    $.ajax {
      url: button.attr('href'),
      data: button.closest('form').serialize(),
      dataType: "json",
      method: "GET",
      success: (json) ->
        $('.loading-image').hide()
        button.attr("disabled", false)
        $('#video_title').val(json["video"]["title"])
        $('#video_description').val(json["video"]["description"])
        $('#video_image').val(json["video"]["image"])
        $('#video_thumbnail').val(json["video"]["thumbnail"])
        $('#video_duration').val(json["video"]["duration"])
        $('#video_video_url').val(json["video"]["video_url"])
        $('li#image').html("<label>&nbsp;</label><img src='" + json["video"]["image"] + "' />")
        $('li#thumbnail').html("<label>&nbsp;</label><img src='" + json["video"]["thumbnail"] + "' />")
      error: ->
        alert("Something went wrong sorry. Ask Jonno to fix it...")
        $('.loading-image').hide()
        button.attr("disabled", false)
    }
    return false