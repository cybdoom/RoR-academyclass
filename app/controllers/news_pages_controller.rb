class NewsPagesController < AdminController
  
  layout "application", only: :show

  skip_before_filter :check_logged_on, only: :show

  def show
    @news_page = NewsPage.find params[:id]
    redirect_to(root_path) unless @news_page
  end

  def index
    @news_pages = NewsPage.order(:id)
  end

  def new
    @news_page = NewsPage.new
  end

  def create
    @news_page = NewsPage.new(params[:news_page])
    if @news_page.save
      flash[:success] = "News page created successfully"
      #redirect_to edit_menu_group_path(@group)
      redirect_to news_pages_path
    else
      render :new
    end
  end

  def edit
    @news_page = NewsPage.find(params[:id])
  end

  def update
    @news_page = NewsPage.find(params[:id])
    @news_page.attributes = params[:news_page]
    if @news_page.save
      flash[:success] = "News page updated successfully"
      redirect_to news_pages_path
    else
      render :edit
    end
  end  

  def destroy
    @news_page = NewsPage.find(params[:id])
    @news_page.destroy
    redirect_to news_pages_path
  end  

end
