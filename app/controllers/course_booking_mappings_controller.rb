class CourseBookingMappingsController < ApplicationController
  before_filter :check_admin
  layout "admin"
  
  def index
    @mappings = CourseBookingMapping.includes(:video_product).order(:course_name)
  end
  
  # called AJAXically
  def update
    @mapping = CourseBookingMapping.find(params[:id])
    @mapping.video_product_id = params[:video_product_id]
    @mapping.save
    render :nothing => true
  end
end