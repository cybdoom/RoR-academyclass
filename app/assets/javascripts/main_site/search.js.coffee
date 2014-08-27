$(document).ready -> 

  $('#q').on 'focus', ->
    $('#q').val('') if $('#q').val() == 'Search Here'

  $('#q').on 'blur', ->
    $('#q').val('Search Here') if $('#q').val() == ''


  bookmarksite = (title, url) ->
    if window.sidebar then window.sidebar.addPanel(title, url,"")
    else if window.external.AddFavourite then window.external.AddFavorite(url, title)
    else alert("Sorry this doesn't work in your browser")

  $('#expired-events-tab').on 'click', ->
    $('#events_expired').show()
    $('#events_current').hide()
    false

  $('#current-events-tab').on 'click', ->
    $('#events_current').show()
    $('#events_expired').hide()
    false