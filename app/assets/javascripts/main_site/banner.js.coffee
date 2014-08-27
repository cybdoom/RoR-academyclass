jQuery ->
  
  $('#popup-newsletter').on 'click', ->
    jQuery.facebox { div: '#newsletter-form' }
    false

  if $('#banner-carousel a').length > 1

    select_banner_dot = (dot) ->
      $("#banner-chooser .banner-dot").removeClass('selected')
      $(dot).addClass('selected')

    next_image = ->
      image = $('#banner-carousel a:first')
      image.animate {'margin-left': "#{-1 * $(image).width()}px"}, 'slow', 'swing', ->
        image.remove()
        image.css 'margin-left': 0
        $('#banner-carousel #image-container').append image
        select_banner_dot $("#banner-chooser .#{$('#banner-carousel a:first').attr('class')}")
      null

    timer = null

    start_carousel = ->
      select_banner_dot $('.banner-dot:first')
      timer = setInterval((-> next_image()), 5000)

    stop_carousel = ->
      clearInterval(timer) if timer

    select_banner = (clazz) ->
      while !$('#banner-carousel a:first').hasClass(clazz)
        image = $('#banner-carousel a:first')
        image.remove()
        $('#banner-carousel #image-container').append image

    $("#banner-chooser .banner-dot").click ->
      stop_carousel()
      select_banner $(this).data('banner')
      select_banner_dot $(this)
      false

    start_carousel()