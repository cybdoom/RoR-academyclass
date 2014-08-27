jQuery ->

  dates_for_course = (course) ->
    $("#dates").empty().append("<option value='0'> - Select a date - </option>")
    if course isnt "0"
      $.getJSON "/surveys/course_dates/#{course}", null, (data) =>
        if data.length == 0
          alert("There are no dates entered for this course, please select another course or add some dates to this course")
          return

        jQuery.each data, (i, date) =>
          $("#dates").append($("<option>").val(date.id).text(date.value).data("location", date.location).data("start_date", date.start_date).data("end_date", date.end_date).data("trainer", date.trainer));
        $("#dates").attr("disabled", false)
    else
      $("#dates").attr("disabled", true)

  toggle_select_product = ->
    product = $("#product").val()
    $("#course").empty()
    $("#course").append("<option value='0'> - Select a course - </option>")
    if product != "0"
      $.getJSON "/surveys/courses/#{product}", null, (data) =>
        for row in data
          $("#course").append("<option value='#{row.course.id}'>#{row.course.name}</option>")
        $("#course").attr("disabled", false)

    toggle_select_course()
    return false

  toggle_select_course = ->
    dates_for_course($("#course").val())

  
  $("#product").change -> toggle_select_product()
  $("#course").change -> toggle_select_course()

  $("#new_survey #dates").change ->
    $("#survey_name").val $("#course option:selected").text()
    selected_date = $("#dates option:selected")
    $("#survey_start_date").val(selected_date.data("start_date"))
    $("#survey_end_date").val(selected_date.data("end_date"))
    $("#survey_location").val(selected_date.data("location"))
    $("#survey_trainer").val(selected_date.data("trainer"))
    
  remove_questions = ->
    $(".remove-question").click ->
      id = $(this).closest("li").find("input").val()
      $.ajax {url: "/surveys/remove_question/#{id}"}
      $(this).closest("li").remove()
      regenerate_question_titles()
      
  remove_questions()
  $(".add-question input[type=button]").live("click", => (create_question()))
  $(".done-add-question").live("click", => (add_questions_to_survey()))
  if $("#new_survey").length > 0 then toggle_select_product()
  
  create_question = ->
    $.ajax {
      url: "/questions",
      data: {
        question: {
          question: $("#facebox #question_text").val(), 
          question_type: $("#facebox .question-types").val(),
          section: $("#facebox #section").val(),
          one_off: $("#facebox #one_off:checked").val()
        },
        survey: survey_id()
      },
      type: "post",
      dataType: "json",
      success: (data) => add_question_to_page(data); $("#facebox #question_text").val("")
    }
    
  survey_id = -> $("form.survey").attr("id").match(/\d+/)[0]
  
  add_questions_to_survey = ->
    ids = new Array()
    jQuery.map($("#facebox .choose-questions input[type=checkbox]:checked"), (el) => ids.push(el.value))
    $.ajax {
      url: "/survey_questions/create",
      type: "post",
      data: {survey_id: survey_id(), question_ids: ids},
      dataType: "json",
      success: (data) => add_questions_to_page(data)
    }
    $.facebox.close()
  
  add_questions_to_page = (data) ->
    for question in data.questions
      add_question_to_page question
  
  add_question_to_page = (data) ->
    if data.error
      alert "Error adding this question:\n\n #{data.error}"
    else
      $(".question-list").append(question_html(data))
      regenerate_question_titles()
      remove_questions()
      $("#question_text").val("")

  add_section_to_page = (section) ->
    if section == null or section is "" then section = "No section title"
    $(".question-list li.add-question-text").before "<li class='section-title'><div class='section-title'><h2>#{htmlEscape(section)}</h2></div></li>"
  
  last_section = -> $("li.section-title:last").text().trim()
  
  question_html = (data) ->
    count = $("li.question:last .label").html()
    count = if count is null then 1 else parseInt(count.match(/\d+/))+1
    return "<li class='question'>
      <div class='drag-handle'>[handle]</div>
      <div class='label'>Question #{count}</div>
      <input id='survey_question_id' name='survey_question_id' type='hidden' value='#{data.id}' />
      <div class='question-section'>#{htmlEscape(data.section)}</div>
      <div class='question'>#{htmlEscape(data.question_text)}</div>
      <div class='question-type'>#{question_type_to_name(data.question_type)}</div>
      <div class='delete'><img class='remove-question' /></div>
      </li>"
  
  regenerate_question_titles = ->
    $("ul.question-list li.section-title").remove()
    last_section = ""
    $("ul.question-list li.question").each (index, li) =>
      li = $(li)
      section = li.find(".question-section").text().trim()
      li.find(".label").html "Question #{index+1}"
      if index % 2 == 0 then li.addClass("alt_row") else li.removeClass('alt_row')
      if last_section isnt section or index is 0
        title = if section is "" then "No section title" else section
        li.before "<li class='section-title'><div class='section-title'><h2>#{title}</h2></div></li>"
      last_section = section;
  
  htmlEscape = (s) -> if s? then s.replace(/\</g, "&gt;").replace(/\>/g, "&lt;") else ""
  
  question_type_to_name = (type) ->
    switch type
      when 1 then "Yes / No"
      when 2 then "Multichoice: 1 - 5"
      when 3 then "Free text"
      when 4 then "Multichoice: Poor - Excellent"
      when 5 then "Agree / Disagree"
      when 6 then "Multichoice: Disagree - Agree"
      else "Unknown"

  $('.sort-update').bind 'sortupdate', ->
    regenerate_question_titles()
    $.ajax {
      type: 'post', 
      data: $('.sort-update').sortable('serialize'), 
      dataType: 'script', 
      url: $("#prioritise-url").attr("href")
    }
