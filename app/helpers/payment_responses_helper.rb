module PaymentResponsesHelper
  def payment_response_title(response)
    if response.booking_form?
      if response.payable
        string = response.payable.contact_name
        string += " from #{response.payable.company}" if response.payable.company
        return string
      else
        return "Unknown booking (#{response.payable_id})"
      end
    else
      return response.payable ? "response.payable.name <#{response.payable.email}>" : "Unknown purchase (#{response.payable_id})"
    end
  end
  
  def payment_response_salesperson(response)
    if response.booking_form?
      return response.payable ? response.payable.salesperson : "Unknown"
    else
      return "n/a"
    end
  end
  
  def card_verification_value_check(response)
    avs_value_to_string(response.avs[0,1])
  end

  def postcode_avs_check(response)
    avs_value_to_string(response.avs[1,1])
  end

  def address_avs_check(response)
    avs_value_to_string(response.avs[2,1])
  end

  def country_comparison_check(response)
    avs_value_to_string(response.avs[3,1])
  end

  def avs_value_to_string(value)
    case value.to_i
    when 0 then return "Not supported"
      when 1 then return "Not checked"
      when 2 then return "Matched"
      when 4 then return "Not match"
      when 8 then return "Partially match"
    end
  end
end