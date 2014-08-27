class VideoProductsController < ApplicationController
  before_filter :check_admin
  layout "admin"
  
  def index
    @products = VideoProduct.includes(:videos).order(:name)
  end
  
  def new
    @product = VideoProduct.new
  end
  
  def create
    @product = VideoProduct.new(params[:video_product])
    if @product.save
      flash[:success] = "Product created successfully"
      redirect_to video_products_path
    else
      render "new"
    end
  end
  
  def edit
    @product = VideoProduct.includes(:video_product_members => :video).find(params[:id])
  end

  def update
    @product = VideoProduct.find(params[:id])
    @product.attributes = params[:video_product]
    if @product.save
      flash[:success] = "Product saved successfully"
      redirect_to video_products_path
    else
      render "edit"
    end
  end
  
  def copy_members
    vp = VideoProduct.find(params[:id])
    vp.copy_members_to(params[:copy_to])
    redirect_to users_path(:user_type => params[:copy_to])
  end
end