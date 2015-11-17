class Admin::BackgroundImagesController < Admin::AdminController
	

  before_filter :find_background_image, only: [:edit, :update, :destroy]

  def index
		@background_images = BackgroundImage.order("created_at DESC").page(params[:page] || 1)
	end

  def new
    @background_image = BackgroundImage.new
  end

  def edit
    render :new
  end

  def create
    @background_image = BackgroundImage.new params[:background_image]
    save_background_image "Product created successfully"
  end

  def update
    @background_image.attributes = params[:background_image]
    save_background_image "Product updated successfully"
  end

  def destroy
    @background_image.destroy
    redirect_to admin_background_images_path
  end

  protected

    def find_background_image
      @background_image = BackgroundImage.find params[:id]
    end

    def save_background_image(success_message)
      if @background_image.save
        redirect_to admin_background_images_path
      else
        render :new
      end
    end

end

