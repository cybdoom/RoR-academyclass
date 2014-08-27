class Textilizer
  def initialize(text)
    @text = text
  end
  
  def to_html
    RedCloth.new(formatted_text).to_html
  end
  
  def formatted_text
    @text.gsub(/--- ?([\w ]*)\r?\n(.+?)\r?\n---\r?$/m) do |match|
      link_name = $1.empty? ? "Read More..." : $1
      "<notextile><a href='#' class = 'read-more' >#{link_name}</a></notextile><div class='additional-information'>#{$2}</div>"
    end
  end
end
