class FamiliesController < ApplicationController
  cache_sweeper :product_sweeper, :only => [:create, :update, :destroy]
  cache_sweeper :families_sweeper, :only => [:create, :update, :destroy, :select_product]
  caches_page :show
  before_filter :check_admin, :except => :show
  before_filter :find_family, :only => [:update, :destroy]
  before_filter :find_all_products, :only => [:edit, :new]
  layout "admin", :except => :show
  
  def index
    @families = Family.includes(:products).all
  end
  
  def show
    @family = Family.with_products.find_by_slug(params[:id])
    @families = Family.all
    render :layout => "application"
  end
  
  def new
    @family = Family.new({:products => []})
  end
  
  def create
    @family = Family.new(params[:family])
    if @family.save
      flash[:success] = "Family created successfully"
      redirect_to families_path
    else
      find_all_products
      @family.products = []
      render :new
    end
  end      
  
  def edit
    @family = Family.find(params[:id], :include => [:products])
  end
  
  def update
    @family.attributes = params[:family]
    if @family.save
      flash[:success] = "Family updated successfully"
      redirect_to :action => :index
    else
      find_all_products
      render :show
    end
  end
  
  def destroy
    @family.destroy
    flash[:success] = "Family deleted successfully"
    redirect_to :action => :index
  end
  
  def select_product
    @family = Family.find(params[:id], :include => :products)
    @family.set_products(params[:product])
    render :nothing => true
  end  

  private
  def find_family
    @family = Family.find(params[:id])
  end
  
  def find_all_products
    @products = Product.includes(:product_parent)
  end
end
