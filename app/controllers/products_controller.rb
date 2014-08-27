class ProductsController < ApplicationController
  cache_sweeper :product_sweeper, :only => [:create, :update, :destroy, :select_course]
  caches_page :show
  before_filter :check_admin, :except => :show
  before_filter :find_product, :only => [:edit, :destroy, :update]
  layout "admin", :except => :show

  def index
    @products = Product.includes(:product_parent).page(params[:page])
  end
  
  def edit
    @courses = Course.all
    @product_courses = Course.all(:conditions => ["course_products.product_id=?", @product.id], :joins => :course_products, :order => "priority")
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:message] = "Product created successfully"
      redirect_to edit_product_url(@product)
    else
      render "new"
    end
  end
  
  def update
    @product.attributes = params[:product]
    if @product.save
      flash[:message] = "Product updated successfully"
      redirect_to edit_product_url(@product)
    else
      @courses = Course.all
      @product_courses = Course.all(:conditions => ["course_products.product_id=?", @product.id], :joins => :course_products, :order => "priority")
      render "edit"
    end
  end
  
  def show
    @parent = params[:product_parent].gsub(/\-/, " ")
    @product = Product.find_by_name(@name = product_name)
    return render template: "products/not_found", layout: "application" if @product.nil?
    @page = "product"
    render :layout => "application"
  end
  
  def destroy
    @product.destroy
    redirect_to :action => :index, :page => params[:page]
  end
  
  def select_course
    @product = Product.find(params[:id], :include => [:course_products])
    @product.set_courses(params[:course])
    render :nothing => true
  end
  
  private
  def find_product
    @product = Product.find(params[:id])
  end

  def product_name
    name = params[:product]
    name += "/#{params[:product2]}" if params[:product2]
    name.gsub(/\-/, " ")
  end
end
