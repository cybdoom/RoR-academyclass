module AdminHelper

  def nl2br(val)
    h(val).gsub(/\n/, "\n<br/>")
  end

  def content_box(*args, &block)
    content_tag(:div, :class => "content-box") do
      temp = content_header
      temp << content_body(*args, &block)
    end
  end
  
  def content_head(&block)
    @header_content = capture(&block)
  end
  
  def content_header
    content_tag(:div, :class => "content-box-header") do
      concat content_tag(:div, @header_content)
    end    
  end
  
  def content_body(*args, &block)
    content_tag(:div, :class => "content-box-content") do
      concat content_tag(:div, capture(&block),:class => "wrapper")
    end
  end
  
  def user_type_list_options
    options = [["Delegates", 0], ["Staff", -1]]
    options_for_select(options, @user_type)
  end
  
  def user_type_options
    options = current_user.admin? ? [User::ADMIN, User::SALES, User::TRAINER, User::DELEGATE] : [User::DELEGATE]
    options.map do |t|
      [display_user_type(t), t]
    end
  end
  
  def display_user_type(t)
    case t
      when User::ADMIN then return "Admin"
      when User::SALES then return "Sales"
      when User::DELEGATE then return "Delegate"
      when User::TRAINER then return "Trainer"
    end
  end
end