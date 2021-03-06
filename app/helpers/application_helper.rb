# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def slugify(s)
    s.gsub(/ \-/, '-').gsub(/\- /, '-').gsub(/  /, ' ').gsub(/ /, '-').gsub(/&/, 'and').gsub(/[^A-Za-z0-9\-\/()]/, "")
  end

  # helper for get course from url
  def search_course_from_url(course_name)
    Course.all.each do |c|
      if course_name == c.name.gsub(/ \-/, '-').gsub(/\- /, '-').gsub(/  /, ' ').gsub(/ /, '-').gsub(/&/, 'and').gsub(/[^A-Za-z0-9\-\/()]/, "")
        return current_course = c.id
        break
      end
    end
  end

  # helper for get style course
  def get_style_course(product)
    # you can specify a single product name
    # example
    # if product.name == 'Mac OS' || product.name == 'Edge' || product.name == 'Wordpress' || product.name == 'iOS App Developer'
      # @style = true
    # else
      # @style = false
    # end
    return @style
  end

  # get url from previws site
  def get_url_session
    @referer_url = request.referer
    @current_url = request.original_url
    if @referer_url
      @ref_url = @referer_url.split('/')[2]
      @cur_url = @current_url.split('/')[2]
      puts @ref_url.to_s + 'lol'
      puts @cur_url.to_s + 'lol'
      if @ref_url != @cur_url
        session[:url] = request.referer
      end
    end
    return session[:url]
  end

  def display_flash
    flash.map do |key, msg|
      return content_tag(:div, msg, :class => "flash-#{key}")
    end
    nil
  end
  
  def display_admin_date(date)
    date.strftime("%d %B %Y %H:%M")
  end
  
  def textilize(text)
    Textilizer.new(text).to_html unless text.blank?
  end
  
  def display_content_with_links(content)
    content = content.gsub(/(http:\/\/[a-zA-Z0-9\/\.\+\-_:?&=]+)/) {|a| "<a href=\"#{a}\" target='_blank'>#{a}</a>"}
    "#{content} ".gsub(/@([a-zA-Z_0-9]+) /) {|a| "<a href='http://www.twitter.com/#!/#{$1}' target='_blank'>@#{$1}</a> "}.strip
  end

  def breadcrumb_link_to(name, url, options = {})
    result = "&raquo; "
    if current_page?(url)
      result += content_tag(:span, name)
    else
      result += link_to name, url, options
    end
    raw result
  end
end
