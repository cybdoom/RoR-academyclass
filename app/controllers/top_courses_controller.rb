class TopCoursesController < ApplicationController
  cache_sweeper :top_course_sweeper, :only => [:create, :destroy, :update]
  before_filter :check_admin
  layout "admin"

  def index
    @top_courses = TopCourse.all(:include => :course)
  end
  
  def new
    @top_course = TopCourse.new
  end
  
  def create
    @top_course = TopCourse.new(params[:top_course])
    if @top_course.save
      flash[:success] = "Top Course created successfully"
      redirect_to top_courses_path
    else
      render "new"
    end
  end
  
  def edit
    @top_course = TopCourse.find(params[:id])
  end
  
  def update
    @top_course = TopCourse.find(params[:id])
    @top_course.attributes = params[:top_course]
    if @top_course.save
      flash[:success] = "Top Course updated successfully"
      redirect_to top_courses_path
    else
      render "edit"
    end
  end
  
  def destroy
    @top_course = TopCourse.find(params[:id])
    @top_course.destroy
    redirect_to top_courses_path
  end
end
