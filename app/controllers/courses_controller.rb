# encoding: utf-8

require 'csv'

class CoursesController < ApplicationController
  cache_sweeper :course_sweeper, :only => [:create, :update, :destroy]
  caches_page :courses, :course_dates, :courses_with_dates, :learn_pipe, :courses_plus, :show
  before_filter :check_admin, :except => [:list, :enquire, :courses_with_dates, :courses, :courses_plus, :course_dates, :learn_pipe, :show]
  before_filter :find_course, :only => [:edit, :update, :destroy, :show]
  layout "admin", :except => [:enquire, :show]
  
  def index
    @letter = params[:letter] || "A"
    @courses = Course.matching_letter(@letter)
  end

  def export
    @course_dates = CourseDate.where("courses.publish_xml=1 AND start_date > now()").joins(:course).includes(:location, :course).order("courses.name, course_dates.start_date")
    send_data render_courses_csv, :type => "text/csv", :filename => "courses_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.csv"
  end

  def full_export
    @courses = Course.published.ordered
    @locations = Location.find_locations_by_course
    send_data render_full_courses_csv, :type => "text/csv", :filename => "courses.csv"
  end
  
  def show
    respond_to do |r|
      r.js do
        @product = @course.products.first
        @locations = Location.all
        render :partial => "products/course", :locals => {:course => @course}
      end
      r.pdf { prawnto :prawn => {:left_margin => 0, :right_margin => 0, :top_margin => 0, :bottom_margin => 0, :page_size => "A4"} }
      r.html do
        @product = Product.find_by_name(params[:product].gsub(/\-/, " "))
        if @product.nil? || !@course.products.include?(@product)
          render :template => "products/not_found", :layout => "alternative"
        else
          render :layout => "alternative"
        end
      end
    end
  end
  
  def new
    @course = Course.new
  end
  
  def edit
    @dates = CourseDate.find_all_by_course_id(@course.id, :conditions => "start_date > now()", :include => [:location])
  end
  
  def create
    @course = Course.new(params[:course])
    if @course.save
      flash[:message] = "Course created successfully"
      redirect_to :action => :edit, :id => @course
    else
      render "new"
    end
  end
  
  def update
    @course.attributes = params[:course]
    if @course.save
      flash[:message] = "Course updated successfully"
      redirect_to :action => :index
    else
      @dates = CourseDate.find_all_by_course_id(@course.id, :conditions => "start_date > now()", :include => [:location])
      render "edit"
    end
  end
  
  def list
    @courses = Course.all(:include => [:image, {:outlines => :bullets}])
    render :layout => false
  end
  
  def destroy
    @course.destroy
    redirect_to :action => :index, :page => params[:page]
  end
  
  def courses
    @manufacturers = ProductParent.with_courses
  end
  
  def courses_plus
    @supplier = 1224
    @courses = Course.includes(:products => :product_parent).where("id IN (SELECT course_id FROM course_products) AND publish_xml=1")
    @locations = Location.find_locations_by_course
  end

  def course_dates
    @manufacturers = ProductParent.with_dates_and_locations.after_today
  end
  
  def courses_with_dates
    @manufacturers = ProductParent.with_dates_and_locations
  end

  def learn_pipe
    @courses = Course.includes({:course_dates => :location}, :products).where("publish_xml=1")
  end
  
  private
  def find_course
    @course = Course.find(params[:id])
  end
  
  def render_full_courses_csv
    return CSV.generate(:force_quotes => true) do |csv|
      # header row
      csv << ["Course Title", "Summary", "Who For", "Assumed Knowledge", "You Will Learn", "Outline", "Duration", "Price", "Venues"]
      # data rows
      @courses.each do |c|
        locations = @locations[c.id] ? @locations[c.id].map {|l| l.name}.join(",") : ""
        csv << [c.name, c.description, c.who_for, c.assumed_knowledge, c.you_will_learn,c.outline, c.duration, c.cost, locations]
      end
    end
  end

  def render_courses_csv
    return CSV.generate(:force_quotes => true) do |csv|
      # header row
      csv << ["Code", "Course Title", "Days", "From", "To", "Venue", "Price"]
      # data rows
      @course_dates.each do |c|
        csv << [c.course.id, c.course.name, c.course.duration, c.start_date.strftime("%d/%m/%y"), c.end_date.strftime("%d/%m/%y"), c.location.name, "£#{c.course.cost.to_i}"]
      end
    end
  end
end