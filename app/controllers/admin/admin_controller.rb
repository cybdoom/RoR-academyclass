class Admin::AdminController < ApplicationController
  before_filter :check_logged_on

  layout "admin"

end
