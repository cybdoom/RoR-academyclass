jQuery ->
  $('ul#video-tag-members').sortable {
    update: (event, ui) ->
      $.ajax {
        type: 'post', 
        data: $('ul#video-tag-members').sortable('serialize'), 
        dataType: 'script', 
        url: "/video_tag_types/sort"
        success: ->
          $("ul#video-tag-members").children().each (index) ->
            $(this).attr("class", if index % 2 == 0 then "" else "alt_row")
      }
  }