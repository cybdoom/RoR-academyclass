class ProductParentsController < ApplicationController
  before_filter :check_admin, :except => [:show]
  before_filter :find_product_parent, :only => [:edit, :update, :destroy]
  cache_sweeper :product_parent_sweeper, :only => [:create, :update, :destroy]
  caches_page "view"
  layout "admin"
  
  def index
    @product_parents = ProductParent.all
  end
  
  def show
    @name = params[:name].gsub(/-/, " ")
    @product_parent = ProductParent.includes(:products).find_by_name(@name)
    if @product_parent.nil?
      @name.gsub!(/ and /, " & ")
      @product_parent = ProductParent.includes(:products).find_by_name(@name)
    end
    if @product_parent.nil?
      render "not_found", :layout => "application"
      return
    end
    render :layout => "application"
  end
  
  def new
    @product_parent = ProductParent.new
  end

  def current_product
  end
  
  def create
    @product_parent = ProductParent.new(params[:product_parent])
    if @product_parent.save
      flash[:success] = "Successfully created product parent."
      redirect_to @product_parent
    else
      render :action => 'new'
    end
  end
  
  def update
    if @product_parent.update_attributes(params[:product_parent])
      flash[:success] = "Successfully updated product parent."
      redirect_to product_parents_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @product_parent.destroy
    flash[:success] = "Successfully destroyed product parent."
    redirect_to product_parents_url
  end
  
  private
  def find_product_parent
    @product_parent = ProductParent.find(params[:id], :include => :products)
  end
end
