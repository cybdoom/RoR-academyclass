class LocationsController < ApplicationController
  caches_page :index
  cache_sweeper :location_sweeper, :only => [:create, :update, :destroy]
  before_filter :check_logged_on, :except => :index
  before_filter :set_location, only: [:edit, :update, :destroy]
  layout "admin"

  def index
    @google_code = "ABQIAAAAn5I9SCqf9euA-mJEurvEHhRdPFx3DPdRc7UaLDxhMTO2mBCgyxQm1bErpf-FJfGVJc9UojHPmdAgUg"
    @page = "locations"
    render :layout => "application"
  end

  def list
    @locations = Location.order(:name)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:success] = "Location saved successfully"
      redirect_to list_locations_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @location.attributes = params[:location]
    if @location.save
      redirect_to list_locations_path
    else
      render :edit
    end
  end

  def destroy
    @location.destroy

    redirect_to list_locations_path
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end
end
