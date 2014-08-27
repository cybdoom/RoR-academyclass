class ReferrersController < ApplicationController
  before_filter :check_admin, :except => [:new, :create]
  layout "worldpay"

  def index
    @referrers = Referrer.group(:referrer).order("count(*) DESC").count
    @total = @referrers.values.reduce(0) {|memo, val| memo + val}.to_f
    render :layout => "admin"
  end
  
  def new
    @referrer = Referrer.new
  end
  
  def create
    @referrer = Referrer.create(params[:referrer])
  end
end