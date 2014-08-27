class VideoProductMembersController < ApplicationController
  before_filter :check_admin

  def destroy
    m = VideoProductMember.find(params[:id])
    m.destroy
    render :nothing => true
  end
end