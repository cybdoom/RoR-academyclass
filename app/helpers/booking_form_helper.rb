module BookingFormHelper

  def display_platform(del)
    selected = default_platform_item_id(del)
    title = platform_array.find {|p| p.last == selected}
    title ? title.first : "Not specified"
  end

  def show_delegate_email
    params[:action] == "edit"
  end

  def booking_form_statuses
    [["Outstanding",1], ["Cancelled",2], ["Part Paid", 4], ["Completed",3]]
  end

  def booking_payment_schedule
    @booking.payment_schedule.map {|date| date.strftime('%d %B %Y') }.join(', ')
  end

  def options_for_platform_select(del)
    default = default_platform_item_id(del)

    options_for_select(platform_array, default)
  end

  private
   
    def platform_array
      [
        ["Not specified", 0],
        ["Mac", 1],
        ["PC", 2],
        ["Bring your own laptop", 3]
      ]
    end

    def default_platform_item_id(del)
      if del.platform.nil?
        if del.platform_pc.nil?
          default = 0
        else
          default = del.platform_pc ? 2 : 1
        end
      else
        default = del.platform
      end
      default
    end
end
