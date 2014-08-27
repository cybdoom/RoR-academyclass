module LayoutHelper
  def body_tag_id
    return "twitter" if controller.class == TweetsController
    return "certifications" if controller.class == CmsController && params[:action] == "certifications"
    return "booking-form" if controller.class == BookingFormsController && (params[:action] == "show" || params[:action] == "update")
    return "video-palette" if controller.class == VideosController && (params[:action] == "home" || params[:action] == "show" || params[:action] == "tagged")
    return 'course' if controller.class == CoursesController && params[:action] == "show"
    defined?(@page) ? "#{@page}-page" : ""
  end
  
  def title(page_title, show_title = true)
    @content_for_meta_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def menu_items
    groups = []
    MenuGroup.with_items.ordered.each do |group|
      groups[group.menu_column - 1] ||= []
      groups[group.menu_column - 1] << group
    end
    groups
  end

  def menu_jumpstarts
    @menu_jumpstarts ||= [
      ["Photoshop", "Adobe", "Photoshop-ACA-Jumpstart:-Zero-to-Hero"],
      ["InDesign", "Adobe", "Indesign-Jumpstart---zero-to-HERO"],
      ["Illustrator", "Adobe", "Illustrator-Jumpstart---zero-to-HERO"],
      ["Flash", "Adobe", "Flash-ACA-Jumpstart---zero-to-HERO", "Flash ACA"],
      ["Flash", "Adobe", "Flash-AS3-Jumpstart---zero-to-Hero", "Flash AS3"],
      ["Dreamweaver", "Adobe", "Dreamweaver-ACA:-Jumpstart", "Dreamweaver ACA"],
      ["3ds Max", "Autodesk", "3ds-Max-Jumpstart---Zero-to-Hero"],
      ["AutoCAD", "Autodesk", "AutoCAD-Jumpstart-:-Get-Certified"],
      ["Cinema 4d", "Maxon", "Cinema-4d-Jumpstart---Zero-to-HERO"],
      ["Maya", "Autodesk", "Maya-101:-Jumpstart:-zero-to-HERO"],
      ["Acrobat", "Adobe", "Acrobat-Jumpstart---zero-to-HERO"],
      ["After Effects", "Adobe", "After-Effects-Jumpstart:-zero-to-HERO"],
      ["Final Cut Pro", "Apple", "Final-Cut-Pro-Jumpstart"],
      ["Captivate", "Adobe", "Captivate-Jumpstart---Zero-to-HERO"],
      ["Search Marketing", "Web-Marketing-&-PR", "SEO-Jumpstart:-zero-to-SEO-Hero"],
      ["Web Foundaments", "Adobe", "SEO-Jumpstart:-zero-to-SEO-Hero"]
    ]
  end    

  def first_banner
    @first_banner ||= all_banners.first
  end

  def all_banners
    @all_banners ||= Banner.order(:position)
  end

  def footer_products
    FooterLink.with_products.ordered
  end

  def top_courses
    TopCourse.with_products
  end
end
