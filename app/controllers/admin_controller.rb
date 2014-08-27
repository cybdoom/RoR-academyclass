class AdminController < ApplicationController
  before_filter :check_logged_on
  layout "admin"
  
  def index
  end
end
