class JsController < ApplicationController
  caches_page :locations

  def locations
    @locations = Location.all
  end
end
