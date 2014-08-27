class MenuItemsController < AdminController
  cache_sweeper :menu_sweeper, :only => [:create, :update, :destroy, :sort]

  def sort
    MenuGroup.find(params[:menu_group_id]).reorder_items(params[:menu_item])
    render :nothing => true
  end

  def new
    @item = MenuItem.new(:menu_group_id => params[:menu_group_id])
  end

  def create
    @item = MenuItem.new(params[:menu_item])
    if @item.save
      flash[:success] = "Menu item created successfully"
      redirect_to edit_menu_group_path(@item.menu_group_id)
    else
      puts @item.errors.inspect
      render :new
    end
  end

  def edit
    @item = MenuItem.find(params[:id])
  end

  def update
    @item = MenuItem.find(params[:id])
    @item.attributes = params[:menu_item]
    if @item.save
      flash[:success] = "Menu item updated successfully"
      redirect_to edit_menu_group_path(@item.menu_group_id)
    else
      render :edit
    end
  end

  def destroy
    @item = MenuItem.find(params[:id])
    @item.destroy
    redirect_to edit_menu_group_path(@item.menu_group_id)
  end
end