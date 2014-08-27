class UploadsController < ApplicationController
  before_filter :check_admin, :except => [:view]
  layout "admin", :except => :view
  
  def index
    @uploads = Upload.all
  end
  
  def new
    @upload = Upload.new
  end
  
  def create
    @upload = Upload.new(params[:upload])
    if @upload.save
      flash[:success] = "File uploaded successfully"
      redirect_to uploads_path
    else
      flash[:error] = "Error uploading file"
      render :new
    end
  end
  
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to uploads_path
  end
end
