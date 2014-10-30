class BookingDelegatesController < ApplicationController

  def platform
    del = BookingDelegate.find params[:id]
    del.update_attributes platform: params[:platform]
    render text: "OK"
  end

end
