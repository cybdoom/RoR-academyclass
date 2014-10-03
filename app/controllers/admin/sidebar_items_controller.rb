class Admin::SidebarItemsController < Admin::AdminController

  before_filter :find_sidebar_item, only: [:edit, :update, :destroy]

  def index
    @sidebar_items = SidebarItem.all
  end

  def new
    @sidebar_item = SidebarItem.new
  end

  def edit
    render :new
  end

  def create
    @sidebar_item = SidebarItem.new params[:sidebar_item]
    save_sidebar_item
  end

  def update
    @sidebar_item.attributes = params[:sidebar_item]
    save_sidebar_item
  end

  def destroy
    @sidebar_item.destroy
    redirect_to admin_sidebar_items_path
  end

  protected

    def find_sidebar_item
      @sidebar_item = SidebarItem.find params[:id]
    end

    def save_sidebar_item
      if @sidebar_item.valid?
        @sidebar_item.save
        flash[:message] = "Sidebar item saved successfully"
        redirect_to admin_sidebar_items_path
      else
        render :new
      end
    end

end
