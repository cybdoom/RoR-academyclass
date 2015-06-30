require 'prawn/fast_png'

header_color = "7E7E82"
section_header_color = "B5D224"
body_text_color = "333333"

pdf.repeat :all do
  pdf.image Rails.root.join("app", "assets", "images", "pdf", "header.png").to_s, :vposition => :top
  pdf.image Rails.root.join("app", "assets", "images", "pdf", "footer.png").to_s, :vposition => :bottom
end

pdf.image Rails.root.join("app", "assets", "images", "pdf", "graphic.png").to_s, :at => [336,580], :width => 259

pdf.font_families.update(
  "DIN" => {  :bold         => Rails.root.join("public","fonts","DINBd___.ttf").to_s,
              :italic       => Rails.root.join("public","fonts","DINMd___.ttf").to_s,
              :bold_italic  => Rails.root.join("public","fonts","DINBd___.ttf").to_s,
              :normal       => Rails.root.join("public","fonts","DINMd___.ttf").to_s })

                                    
pdf.bounding_box([50, pdf.bounds.top - 120], :width  => pdf.bounds.width - 100, :height => pdf.bounds.height - 220) do
  pdf.font "DIN", :size => 12 do
    if @course.logo.file?
      begin
        pdf.image @course.logo.path, :width => 50,  :at => [440,630]
      rescue => e
        Rails.logger.error "#{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
    pdf.fill_color body_text_color
    pdf.move_down 10
    pdf.text "<font size='24'><color rgb='#{header_color}'>#{@course.name}</color><font>", :inline_format => true
    pdf.move_down 15
    pdf.table([ ["<color rgb='#{section_header_color}'>Level:</color>", @course.level],
                ["<color rgb='#{section_header_color}'>Duration:</color>", "#{@course.duration} Days"],
                ["<color rgb='#{section_header_color}'>Time:</color>", "9:30 AM - 4:30 PM"],
                ["<color rgb='#{section_header_color}'>Cost:</color>", @course.cost]
              ],  
              :cell_style => {:inline_format => true, :padding => 0, :borders => [] },
              :column_widths => [60, 300])
    pdf.move_down 20
    pdf.text "<font size='13'><b>Overview</b><font>", :inline_format => true
    pdf.move_down 4
    pdf.indent(15) {pdf.text textile_to_prawn(@course.overview, :bold => false), :inline_format => true}
    pdf.move_down 10
    pdf.text "<font size='13'><b>Description</b><font>", :inline_format => true
    pdf.move_down 4
    pdf.indent(15) {pdf.text @course.description}
    pdf.move_down 10
    pdf.text "<font size='13'><b>Who is this course for?</b><font>", :inline_format => true
    pdf.move_down 4
    pdf.indent(15) {pdf.text @course.who_for}
    pdf.move_down 10
    pdf.text "<font size='13'><b>Assumed Knowledge</b><font>", :inline_format => true
    pdf.move_down 4
    pdf.indent(15) {pdf.text @course.assumed_knowledge}
    pdf.move_down 10
    pdf.text "<font size='13'><b>What you will learn</b><font>", :inline_format => true
    pdf.move_down 4
    pdf.indent(15) {pdf.text @course.you_will_learn}
    pdf.move_down 10
    pdf.text "<font size='13'><b>Outline</b><font>", :inline_format => true
    pdf.move_down 4
    pdf.indent(15) {pdf.text textile_to_prawn(@course.outline)}
    
  end
  
end
