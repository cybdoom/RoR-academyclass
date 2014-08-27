class MenuGroupsController < AdminController
  cache_sweeper :menu_sweeper, :only => [:create, :update, :destroy]

  def index
    @groups = MenuGroup.includes(:menu_items).order(:menu_column, :sequence)
  end

  def new
    @group = MenuGroup.new
  end

  def create
    @group = MenuGroup.new(params[:menu_group])
    if @group.save
      flash[:success] = "Menu group created successfully"
      redirect_to edit_menu_group_path(@group)
    else
      render :new
    end
  end

  def edit
    @group = MenuGroup.find(params[:id])
  end

  def update
    @group = MenuGroup.find(params[:id])
    @group.attributes = params[:menu_group]
    if @group.save
      flash[:success] = "Menu group updated successfully"
      redirect_to menu_groups_path
    else
      render :edit
    end
  rescue ActiveRecord::StaleObjectError
    @group.reload
    flash[:error] = "Another user has made a change to that record. Please re-apply your changes."
    render :edit
  end  

  def destroy
    @group = MenuGroup.find(params[:id])
    @group.destroy
    redirect_to menu_groups_path
  end  
end
