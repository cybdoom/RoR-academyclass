class SalesContactsController < ApplicationController
  before_filter :check_admin
  layout "admin"
  
  def index
    @contacts = SalesContact.all(:order => "name")
  end
  
  def new
    @contact = SalesContact.new
  end
  
  def create
    @contact = SalesContact.new(params[:sales_contact])
    if @contact.save
      redirect_to sales_contacts_path
    else
      render "new"
    end
  end
  
  def edit
    @contact = SalesContact.find(params[:id])
  end
  
  def update
    @contact = SalesContact.find(params[:id])
    @contact.attributes = params[:sales_contact]
    if @contact.save
      redirect_to sales_contacts_path
    else
      render "edit"
    end
  end
end