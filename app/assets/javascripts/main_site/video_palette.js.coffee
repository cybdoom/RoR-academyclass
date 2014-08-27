$(document).ready ->

	$('#videos-left-panel').accordion
		autoHeight: false
		active: 2

	$('body#video-palette .member-only a').on "click", ->
		return false

	$('body#video-palette').on "click", "#user_session_submit_action input", ->
		button = $(this)
		form = button.closest('form')
		form.find('.errors').hide()
		button.attr('disabled', true)
		form.find('#loading').show()
		$.ajax {
			data: form.serialize(),
			url: form.attr('action'),
			type: 'POST',
			dataType: 'JSON',
			success: (data) ->
				form.find('#loading').hide()
				button.attr('disabled', false)
				if data.errors
					form.find('.errors').show().text("Invalid username or password")
				else
					jQuery(document).trigger('close.facebox')
					$('#login').html($('<a>').attr({href: '/logout'}).text(data.name))
		}
		return false