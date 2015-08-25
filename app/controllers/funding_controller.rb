class FundingController < ApplicationController
  def index
  	@fundings = FundingAdmin.published.order("sticky DESC, created_at DESC").
      page(params[:page] || 1).per_page(6)
  end

  def show
  	@funding = FundingAdmin.published.find params[:id]
    redirect_to funding_path unless @funding
  rescue ActiveRecord::RecordNotFound
    redirect_to funding_path
  end
end
