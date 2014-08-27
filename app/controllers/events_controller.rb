class EventsController < ApplicationController
  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy]
  caches_page :index, :show
  before_filter :check_admin, :except => [:show, :index]
  
  def index
    @current = Event.where("start_date>=now()")
    @expired = Event.where("start_date<now()")
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    render :layout => "admin"
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = "Event created successfully"
      redirect_to events_list_path
    else
      render :new, :layout => "admin"
    end
  end
    
  def list
    @events = Event.all(:order => "start_date DESC")
    render :layout => "admin"
  end
  
  def edit
    @event = Event.find(params[:id])
    render :layout => "admin"
  end
  
  def update
    @event = Event.find(params[:id])
    @event.attributes = params[:event]
    if @event.save
      flash[:success] = "Event updated successfully"
      redirect_to events_list_path
    else
      render :edit, :layout => "admin"
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_list_path
  end
end