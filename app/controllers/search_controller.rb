class SearchController < ApplicationController
  
  def index
    @search = params[:q]
    if @search.blank?
      flash.now[:error] = "Please enter a search string"
    else
      s = "%#{@search}%"
      @courses = Course.includes(:products => :product_parent).order("course_products.priority").where("courses.id IN (SELECT course_id FROM course_products) AND (courses.name LIKE ? OR courses.description LIKE ?)", s, s).limit(20)
      flash.now[:error] = "Sorry there were no matches for you search <strong>#{h params[:q]}</strong>." if @courses.empty?
    end
  end
end
