class FundingAdminsController < InheritedResources::Base
	before_filter :find_funding, only: [:edit, :update, :funding_destroy]
	layout "admin"

  def index
    @fundings = FundingAdmin.order("sticky DESC, created_at DESC").page(params[:page] || 1)
  end

  def new
    @funding = FundingAdmin.new
  end

  def edit
    render :new
  end

  def create
    @funding = FundingAdmin.new params[:funding_admin]
    save_funding "Funding created successfully"
  end

  def update
    @funding.attributes = params[:funding_admin]
    save_funding "Funding updated successfully"
  end

  def funding_destroy
    @funding.destroy
    redirect_to funding_admins_path
  end

  protected

    def find_funding
      @funding = FundingAdmin.find params[:id]
    end

    def save_funding(success_message)
      if @funding.valid?
        if params[:commit].include? "Publish"
          @funding.published_at = Time.now
        elsif params[:commit].include? "Unpublish"
          @funding.published_at = nil
        end

        if params[:funding_admin][:custom_published_at].present? && @funding.published_at
          @funding.published_at = params[:funding_admin][:custom_published_at]
        end

        @funding.save
        flash[:message] = success_message
        redirect_to funding_admins_path
      else
        render :new
      end
    end
  
end

