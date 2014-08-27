class SurveyProductsController < ApplicationController
  before_filter :check_admin
  layout "admin"
  
  def index
    @survey_products = SurveyProduct.all
  end
  
  def new
    @survey_product = SurveyProduct.new
  end
  
  def create
    @survey_product = SurveyProduct.new(params[:survey_product])
    if @survey_product.save
      redirect_to survey_products_path
    else
      render :new
    end
  end
end