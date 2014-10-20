$(document).ready ->

  $('#q').on 'focus', ->
    $('#q').val('') if $('#q').val() == 'Search Here'

  $('#q').on 'blur', ->
    $('#q').val('Search Here') if $('#q').val() == ''


  $("a.bookmark").click (e) ->
    e.preventDefault() # this will prevent the anchor tag from going the user off to the link
    bookmarkUrl = @href
    bookmarkTitle = @title
    if window.sidebar or navigator.userAgent.toLowerCase().indexOf("chrome") > -1
      alert "This function is not available. Click the star symbol at the end of the address-bar or hit Ctrl-D (Command+D for Macs) to create a bookmark."
    else if window.external or document.all # For IE Favorite
      window.external.AddFavorite bookmarkUrl, bookmarkTitle
    else if window.opera # For Opera Browsers
      $("a.bookmark").attr "href", bookmarkUrl
      $("a.bookmark").attr "title", bookmarkTitle
      $("a.bookmark").attr "rel", "sidebar"
    else # for other browsers which does not support
      alert "Your browser does not support this bookmark action"
      false
      return


  $('#expired-events-tab').on 'click', ->
    $('#events_expired').show()
    $('#events_current').hide()
    false

  $('#current-events-tab').on 'click', ->
    $('#events_current').show()
    $('#events_expired').hide()
    false
