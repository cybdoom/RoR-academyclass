module NewsHelper

  def news_date_val(date)
    date.strftime("%d/%m/%Y")
  end

  def funding_date_val(date)
    date.strftime("%d/%m/%Y")
  end

end
