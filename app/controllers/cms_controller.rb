class CmsController < ApplicationController
  caches_page "index", "consultancy", "creative_services", "aboutus", "training", "private_training", "what_clients_say", "meet_the_instructors", "certifications", "terms_and_conditions", "privacy_policy", "terms_of_business", "sitemap", "club", "certification", "training_vouchers", "blended_learning"
  
  def index
    @page     = "home"
    @content  = Page.find_by_name("home").content
    @families = Family.includes({:products => :product_parent}).order(:position)
    @news     = News.where("published_at IS NOT NULL").order("created_at DESC").limit(4)
  end
  
  def consultancy
    @page = "consultancy"
  end
  
  def creative_services
    @page = "creative-services"
  end
  
  def aboutus
    @page = "about-us"
  end
  
  def training
    @content = Page.find_by_name("training").content
    @page = "training"
  end
  
  def private_training
    @page = "training"
    products = Product.all
    half = (products.length / 2).ceil
    @products = [products[0, half],products[half, products.length]]
  end
  
  def what_clients_say
    @testimonials = Testimonial.order(:position)
    @page = "testimonial"
  end
  
  def meet_the_instructors
    @instructors = Instructor.all
  end
  
  def certifications
    @ace_courses = [
      ['Photoshop', 'Photoshop-Certification-Jumpstart', 'Photoshop ACE', 'adobe-photoshop.png', 'ACE_Exam_Guide_PhotoshopCS5.pdf'],
      ['Flash', 'Flash-Certification-Jumpstart', 'Flash ACE', 'adobe-flash.png', 'ACE_Exam_Guide_FlashCS5.pdf'],
      ['Illustrator', 'Illustrator-Certification-Jumpstart', 'Illustrator ACE', 'adobe-illustrator.png', 'ACE_Exam_Guide_IllustratorCS5.pdf'],
      ['Dreamweaver', 'Dreamweaver-Creative-License', 'Dreamweaver ACE', 'adobe-dreamweaver.png', 'ACE_Exam_Guide_DreamweaverCS5.pdf'],
      ['InDesign', 'Indesign-Certification-Jumpstart', 'InDesign ACE', 'adobe-indesign.png', 'ACE_Exam_Guide_InDesignCS5.pdf'],
      ['After Effects', 'After-Effects-Certification-Jumpstart', 'After Effects ACE', 'adobe-after-effects.png', 'ACE_Exam_Guide_AfterEffectsCS5.pdf'],
      ['Premiere-Pro', 'Premiere-Pro-Jumpstart---Zero-to-Premiere-Hero', 'Premiere ACE', 'adobe-premiere.png', 'ACE_Exam_Guide_PremiereProCS5.pdf'],
      ['Captivate', 'Captivate-Jumpstart---Zero-to-HERO', 'Captivate ACA', 'adobe-captivate.png', 'ACE_Exam_Guide_Captivate5.5.pdf']
    ]
    @aca_courses = [
      ['Photoshop', 'Photoshop-ACA-Jumpstart:-Zero-to-Hero', 'Photoshop ACA', 'adobe-photoshop.png', 'photoshop_exam_objectives.pdf'],
      ['Premiere-Pro', 'Premiere-Pro-Jumpstart---Zero-to-Premiere-Hero', 'Premiere ACA', 'adobe-premiere.png', 'premiere_exam_objectives.pdf'],
      ['Flash', 'Flash-ACA-Jumpstart---zero-to-HERO', 'Flash ACA', 'adobe-flash.png', 'flash_exam_objectives.pdf'],
      ['Dreamweaver', 'Dreamweaver-ACA:-Jumpstart', 'Dreamweaver ACA', 'adobe-dreamweaver.png', 'dreamweaver_exam_objectives.pdf']
    ]
    
    @apple_l1_courses = [
      ['Final-Cut-Pro', 'Final-Cut-Pro-101:-Rookie', 'FCP 101: Introduction to Final Cut Pro X', 'apple-final-cut-pro.png', 'final-cut-pro-x-exam-preparation.pdf'],
    ]
    
    @apple_l2_courses = [
      ['Final-Cut-Pro', 'Final-Cut-Pro-X-201:-HotShot', 'FCP 200: Comprehensive Study of Final Cut Pro X', 'apple-final-cut-pro.png'],
    ]
    
    @autodesk_associate_courses = [
      ['AutoCAD', 'AutoCAD-Creative-License', 'AutoCAD', 'autodesk-autocad.png', 'autocad_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['3ds-Max', '3ds-Max-Creative-License', '3DS Max', 'autodesk-3ds-max.png', 'autodesk_3ds_max_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['Revit', 'Revit-Architecture-101:-Rookie', 'Revit', 'autodesk-revit.png', 'autodesk_revit_architecture_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['Inventor', '', 'Inventor', 'autodesk-revit.png', 'autodesk_inventor_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['Maya', 'Maya-101:-Jumpstart:-zero-to-HERO', 'Maya', 'autodesk-maya.jpg', 'autodesk_maya_2012_cert_exam_prep_roadmap_lores.pdf']
    ]
    @autodesk_professional_courses = [
      ['AutoCAD', 'AutoCAD-Creative-License', 'AutoCAD', 'autodesk-autocad.png', 'autocad_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['3ds-Max', '3ds-Max-Creative-License', '3DS Max', 'autodesk-3ds-max.png', 'autodesk_3ds_max_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['Revit', 'Revit-Architecture-101:-Rookie', 'Revit', 'autodesk-revit.png', 'autodesk_revit_architecture_2012_certification_exam_preparation_roadmap_lores.pdf'],
      ['Maya', 'Maya-101:-Jumpstart:-zero-to-HERO', 'Maya', 'autodesk-maya.jpg', 'autodesk_maya_2012_cert_exam_prep_roadmap_lores.pdf']
    ]
  end
  
  def terms_and_conditions
  end
  
  def privacy_policy
  end
  
  def terms_of_business
    respond_to do |r|
      r.js { render layout: false }
      r.html
    end
  end
  
  def guarantee
  end
  
  def discounts
  end

  def club
  end
  
  def sitemap
    @urls = []
    pages = ["/aboutus", "About Us", "/consultancy", "Consultancy","/contact", "Contact Us", "/creative-services", "Creative Services","/locations", "Locations", "/training", "Training",	"/training/private-training", "Private Training",	"/training/evenings-and-weekends", "Weekend And Evening Courses",	"/aboutus/what-clients-say", "What Clients Say", "/meet-the-instructors", "Meet the Instructors",	"/certifications", "Certifications", "/events", "Seminars and Events", "/save-with-creative-licence", "SAVE with the Creative License", "/training", "Training", "/events/cs5-roadshow-3d", "CS5 Roadshow 3D Competition"]
    pages.each_index {|i| add_url(pages[i], pages[i+1]) if i % 2 == 0}
    Family.all.each { |f|add_url(family_path(f.slug), "Jumpstart: #{f.name}") }
    Event.all.each {|e| add_url("/events/#{e.id}", "Event: #{e.name}")}
    ProductParent.all.each {|p| add_url(p.url, "#{p.name} Training Courses")}
    Product.all(:include => :product_parent).each {|p| add_url(p.url, "#{p.name} Training Course")}
    
    respond_to do |r|
      r.html
      r.xml
    end
  end
  
  def creative_licence
    @page = "creative-licence"
    render "creative_licence/index"
  end

  def new_creative_licence
    render "creative_licence/new_creative_licence"
  end
  
  private
  def add_url(url, title)
    @urls << {:page => url, :title => title, :url => "http://#{request.host_with_port}#{url}", :priority => 0.5, :last_modified => "2010-05-25", :change_frequency => "monthly"}
  end
end
