require 'prawn/fast_png'

header_color = "7E7E82"
section_header_color = "B5D224"
body_text_color = "333333"

pdf.repeat :all do
  if @booking.lsm
    pdf.image Rails.root.join("app", "assets", "images", "header_images", "love-social-media.jpg").to_s, vposition: :top, position: :right
  else
    pdf.image Rails.root.join("app", "assets", "images", "pdf", "header.png").to_s, :vposition => :top
    pdf.image Rails.root.join("app", "assets", "images", "pdf", "footer.png").to_s, :vposition => :bottom
  end
end

unless @booking.lsm
  pdf.image Rails.root.join("app", "assets", "images", "pdf", "graphic.png").to_s, :at => [336,580], :width => 259
end

pdf.font_families.update(
  "DIN" => {  :bold         => Rails.root.join("public", "fonts", "DINBd___.ttf").to_s,
              :italic       => Rails.root.join("public", "fonts", "DINMd___.ttf").to_s,
              :bold_italic  => Rails.root.join("public", "fonts", "DINBd___.ttf").to_s,
              :normal       => Rails.root.join("public", "fonts", "DINMd___.ttf").to_s })

                                    
pdf.bounding_box([20, pdf.bounds.top - 120], :width  => pdf.bounds.width - 40, :height => pdf.bounds.height - 220) do
  pdf.font "DIN", :size => 12 do
    pdf.fill_color body_text_color
    pdf.move_down 10
    pdf.text "<font size='24'><color rgb='#{header_color}'>Course Booking Form</color><font>", :inline_format => true
    pdf.text "<font size='18'><color rgb='#{header_color}'>Pro Form Invoice</color><font>", :inline_format => true

  
    pdf.bounding_box([0, 540], :width  => 320, :height => 100) do
      pdf.stroke_bounds
      pdf.pad(10) do
        pdf.indent(10) do
          pdf.text @booking.contact_name
          unless @booking.company.blank?
            pdf.text @booking.company
          end
          pdf.text @booking.address
          pdf.text @booking.postcode
        end
      end
    end

    pdf.bounding_box([330, 540], :width  => 220, :height => 100) do
      pdf.stroke_bounds
      pdf.pad(10) do
        pdf.indent(10) do
          table = [ ["booking ref:", @booking.filemaker_code],
                    ["your ref / PO:", @booking.booking_approval ? @booking.booking_approval.po_number : ""],
                    ["terms:", "14 days"]
                  ]
          pdf.table(table, :cell_style => {:padding => 1, :borders => [] })
        end
      end
    end

    table = [["<b>Delegate</b>", "<b>Location</b>", "<b>Course</b>", "<b>Dates</b>", "<b>Price</b>"]]
    @booking.delegates.each do |d|
      table << [d.name, d.course_location, d.course_name, "#{d.start_date.strftime('%d/%m/%y')} to #{d.end_date.strftime('%d/%m/%y')}", number_to_currency(d.price, :unit => "£")]
    end
    pdf.move_down 20
    pdf.table(table) do
      row(0).borders = [:bottom]
      row(1..row_length).borders = []
      row(0..row_length).padding = [1,0]
      row(0).padding_bottom = 5
      row(1).padding_top = 5
      row(0..row_length).inline_format = true
      column(0).width = 90
      column(1).width = 60
      column(2).width = 200
      column(3).width = 120
      column(4).width = 65
      column(4).align = :right
    end
      
    pdf.move_down 40
    table = [ ["Total (excluding VAT)", number_to_currency(@booking.total_ex_vat, :unit => "£")],
              ["VAT @ #{@booking.vat}%", number_to_currency(@booking.vat_rate * @booking.total_ex_vat, :unit => "£")],
              ["Total (including VAT)", number_to_currency(@booking.total, :unit => "£")]]
    pdf.table(table) do
      row(0).borders = [:top]
      row(1..2).borders = []
      column(0).width = 475
      column(1).width = 65
      column(0..1).align = :right
    end
      
    pdf.text "All prices are in £GBP"
    pdf.move_down 20
    if @booking.lsm
      pdf.text "Love Social Media is part of the Academy Class group"
      pdf.move_down 10
    end
    pdf.text "Academy Class Limited", :size => 16, :style => :bold
    pdf.text "Registered in England and Wales No 5878400"
    pdf.text "Elizabeth House, 39 York Road, SE1 7NQ"
    pdf.text "VAT Reg No. 879 7243 63"
    pdf.text "Phone 0800 043 8889"
  end
end