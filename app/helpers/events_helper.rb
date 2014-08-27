# encoding: utf-8
module EventsHelper
  def display_date(event)
    return event.start_date.strftime("%d %B %Y")
  end

  def display_time(event)
    return event.start_date.strftime("%H:%M")
  end

  def display_event_cost(event)
    return event.cost.zero? ? "free" : number_to_currency(event.cost, :unit => "£")
  end

  def text_for_event_box(event)
    if event.description.blank?
      truncate(raw(event.info), :length => 300)
    else
      raw(textilize event.description)
    end
  end
end
