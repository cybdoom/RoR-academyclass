class PrioritiseController < ApplicationController
  cache_sweeper :families_sweeper, :only => [:update]
  cache_sweeper :banner_sweeper, :only => [:update]
  cache_sweeper :testimonials_sweeper, :only => [:update]
  cache_sweeper :video_feature_sweeper, :only => [:update]
  cache_sweeper :sidebar_item_sweeper, :only => [:update]
  before_filter :check_admin
  layout "admin"
    
  def update
    params.each do |object, order|
      if order.class == Array
        cl = eval(object + ".all")
        cl.each do |c|
          c.position = order.index(c.id.to_s)+1
          c.save
        end
        break
      end
    end
    render :nothing => true  
  end
end
