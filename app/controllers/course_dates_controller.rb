class CourseDatesController < ApplicationController
  cache_sweeper :course_date_sweeper, :only => [:create, :destroy]
  before_filter :check_admin, :except => [:set_course_seats, :index]
  before_filter :check_user_parameters, :only => [:update]
  protect_from_forgery :except => :set_course_seats

  layout "admin"
  
  def index
    @courses = Course.with_locations
    @current = params.has_key?(:current)
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
  
  def new
    @course_date = CourseDate.new({:course_id => params[:course_id], :total_seats => 10, :seats_sold => 0})
  end
  
  def create
    @course_date = CourseDate.new(params[:course_date])
    if @course_date.save
      flash[:success] = "Course date created successfully"
      redirect_to edit_course_path(@course_date.course_id, :anchor => 'course-dates')
    else
      render "new"
    end
  end
  
  def destroy
    @course_date = CourseDate.find(params[:id])
    @course_date.destroy
    flash[:success] = "Course date deleted successfully"
    redirect_to edit_course_path(@course_date.course_id)
  end
  
  # called from the API
  def set_course_seats
    @course_date = CourseDate.find_by_course_location_date(params[:name], params[:location], params[:start_date])
    if @course_date
    	@course_date = CourseDate.find(@course_date.id) # get a non-readonly version
      @course_date.total_seats = params[:total_seats] || 0
      @course_date.seats_sold = params[:seats_sold] || 0
      @course_date.save! # force an exception on failure
      render :nothing => true
    else
      render :text => "Invalid course date data. No course named #{params[:name]} found on #{params[:start_date]} in #{params[:location]}"
    end
  end
end