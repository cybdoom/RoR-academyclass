class TestimonialsController < ApplicationController
  cache_sweeper :testimonials_sweeper, :only => [:create, :update, :destroy]
  before_filter :check_admin, :except => [:video]
  layout "admin"
  
  def index
    @testimonials = Testimonial.order(:position)
  end
  
  def new
    @testimonial = Testimonial.new
  end
  
  def create
    @testimonial = Testimonial.new(params[:testimonial])
    if @testimonial.save
      flash[:message] = "Testimonial created successfully"
      redirect_to testimonials_path
    else
      render "new"
    end
  end
  
  def edit
    @testimonial = Testimonial.find(params[:id])
  end
  
  def update
    @testimonial = Testimonial.find(params[:id])
    @testimonial.attributes = params[:testimonial]
    if @testimonial.save
      flash[:message] = "Testimonial updated successfully"
      redirect_to testimonials_path
    else
      render "edit"
    end
  end
  
  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    flash[:message] = "Testimonial deleted successfully"
    redirect_to testimonials_path
  end
  
  def video
    @testimonial = Testimonial.find(params[:id])
    render :text => @testimonial.video
  end    
end
