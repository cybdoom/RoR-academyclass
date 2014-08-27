class InstructorsController < ApplicationController
  before_filter :check_admin
  cache_sweeper :instructors_sweeper, :only => [:create, :update, :destroy]
  layout "admin"
  
  def index
    @instructors = Instructor.all
  end
  
  def new
    @instructor = Instructor.new
  end
  
  def create
    @instructor = Instructor.new(params[:instructor])
    if @instructor.save
      redirect_to instructors_path
    else
      render :new
    end
  end
  
  def edit
    @instructor = Instructor.find(params[:id])
  end
  
  def update
    @instructor = Instructor.find(params[:id])
    @instructor.attributes = params[:instructor]
    if @instructor.save
      redirect_to instructors_path
    else
      render "edit"
    end
  end
  
  def destroy
    @instructor = Instructor.find(params[:id])
    @instructor.destroy
    redirect_to instructors_path
  end
end