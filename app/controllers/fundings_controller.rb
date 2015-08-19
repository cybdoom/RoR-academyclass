class FundingsController < InheritedResources::Base
	before_filter :find_funding, only: [:edit, :update, :funding_destroy]
	layout "admin"

  def index
    @fundings = Funding.order("sticky DESC, created_at DESC").page(params[:page] || 1)
  end

  def new
    @funding = Funding.new
  end

  def edit
    render :new
  end

  def create
    @funding = Funding.new params[:funding]
    save_funding "Funding created successfully"
  end

  def update
    @funding.attributes = params[:funding]
    save_funding "Funding updated successfully"
  end

  def funding_destroy
    @funding.destroy
    redirect_to fundings_path
  end

  protected

    def find_funding
      @funding = Funding.find params[:id]
    end

    def save_funding(success_message)
      if @funding.valid?
        if params[:commit].include? "Publish"
          @funding.published_at = Time.now
        elsif params[:commit].include? "Unpublish"
          @funding.published_at = nil
        end

        if params[:funding][:custom_published_at].present? && @funding.published_at
          @funding.published_at = params[:funding][:custom_published_at]
        end

        @funding.save
        flash[:message] = success_message
        redirect_to fundings_path
      else
        render :new
      end
    end
  
end

