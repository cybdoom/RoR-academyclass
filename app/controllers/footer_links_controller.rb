class FooterLinksController < ApplicationController
  cache_sweeper :footer_link_sweeper, :only => [:create, :destroy]
  before_filter :check_admin
  layout "admin"
  
  def index
    @footer_links = FooterLink.all(:include => {:product => :product_parent}, :order => "products.name")
  end
  
  def new
    @footer_link = FooterLink.new
  end
  
  def create
    @footer_link = FooterLink.new(params[:footer_link])
    if @footer_link.save
      flash[:message] = "Footer link created successfully"
      redirect_to :action => :index
    else
      render "new"
    end
  end
  
  def destroy
    @footer_link = FooterLink.find(params[:id])
    @footer_link.destroy
    redirect_to :action => :index
  end
end
