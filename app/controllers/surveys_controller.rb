class SurveysController < ApplicationController
  before_filter :check_admin, except: [:show, :complete]
  layout "admin"
  
  def index
    @surveys = Survey.includes(:survey_questions, :survey_responses).order("id DESC").page(params[:page])
  end
  
  def new
    @survey = Survey.new
    prepare_form
  end
  
  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      flash[:success] = "Survey created successfully"
      redirect_to edit_survey_path(@survey)
    else
      prepare_form
      render "new"
    end
  end
  
  def edit
    @survey = Survey.find(params[:id])
    @survey_questions = SurveyQuestion.where({:survey_id => @survey.id}).includes(:question)
    prepare_form
  end
  
  def update
    @survey = Survey.find(params[:id])
    @survey.attributes = params[:survey]
    if @survey.save
      flash[:success] = "Survey updated successfully"
      redirect_to :surveys
    else
      prepare_form
      render "new"
    end
  end
    
  def show
    @survey = Survey.find(params[:id])
    @survey_questions = SurveyQuestion.where({:survey_id => @survey.id}).includes(:question)
    @survey_response = SurveyResponse.new({:survey => @survey}) { [] }
    @survey_products = {}
    SurveyProduct.all.each do |sp|
      @survey_products[sp.product_parent] = [] unless @survey_products[sp.product_parent]
      @survey_products[sp.product_parent] << sp
    end
    render :layout => "minimal"
  end

  def complete
    render layout: "minimal"
  end
  
  # ajax
  def questions
    render :json => Question.where(["question LIKE ?", "%#{params[:id]}%"]).to_json
  end
    
  
  # ajax
  def courses
    render :json => Course.select("courses.id, courses.name").joins(:course_products).where("course_products.product_id=?", params[:id]).to_json
  end

  # ajax
  def course_dates
    dates = []
    CourseDate.includes(:location).where("course_id=? AND start_date>now()", params[:id]).each do |date|
      start_date = date.start_date.strftime("%d %b %Y")
      end_date = date.end_date.strftime("%d %b %Y")
      value = start_date + " to " + end_date + " in " + date.location.name
      dates << {:id => date.id, :value => value, :trainer => date.trainer, :location => date.location.name, :start_date => start_date, :end_date => end_date}
    end
    render :json => dates.to_json
  end
  
  # ajax
  def remove_question
    SurveyQuestion.destroy(params[:id])
    render :nothing => true
  end
  
  private
  def prepare_form
    @products = Product.all
    if @survey.course_date
      @course = @survey.course_date.course
      @product = @course.products.first
    end
    if @survey.new_record?
      @surveys = Survey.includes(:survey_questions).order("id DESC").limit(40).map {|s| [s, s.id]}
    else
      @questions = Question.where("one_off IS NULL OR one_off = 0")
    end
      
    @courses = @product.courses if @product
    @course_dates = CourseDate.where("course_id=? AND start_date>now()", @course.id).includes(:location) if @course
  end
end