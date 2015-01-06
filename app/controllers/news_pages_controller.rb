class NewsPagesController < AdminController
  
  layout "application", only: :show

  skip_before_filter :check_logged_on, only: :show

  def show
    @news_page = NewsPage.
      where(slug: params[:id]).
      where("published_at IS NOT NULL").first
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
    save
  end

  def edit
    @news_page = NewsPage.find(params[:id])
  end

  def update
    @news_page = NewsPage.find(params[:id])
    @news_page.attributes = params[:news_page]
    save
  end  

  def destroy
    @news_page = NewsPage.find(params[:id])
    @news_page.destroy
    redirect_to news_pages_path
  end  

  protected

    def save
      if @news_page.valid? && params[:commit].include?("Publish")
        @news_page.published_at = Time.now
      elsif params[:commit].include? "Unpublish"
        @news_page.published_at = nil
      end

      if @news_page.save
        if @news_page.new_record?
          flash[:success] = "News page created successfully"
        else
          flash[:success] = "News page updated successfully"
        end
        redirect_to news_pages_path
      else
        if @news_page.new_record?
          render :new
        else
          render :edit
        end
      end
    end

end
