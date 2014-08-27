class PagesController < ApplicationController
  cache_sweeper :page_sweeper, :only => [:update]
  before_filter :check_admin
  layout "admin"

  def index
    @pages = Page.all
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])
    @page.attributes = params[:page]
    if @page.save
	    flash[:success] = "Page saved successfully"
      redirect_to pages_path
    else
      flash[:error] = "Saving this page failed"
      render :new
    end
  end
end
