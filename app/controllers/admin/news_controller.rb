class Admin::NewsController < Admin::AdminController

  before_filter :find_news, only: [:edit, :update, :destroy]

  def index
    @news = News.order("sticky DESC, created_at DESC").page(params[:page] || 1)
  end

  def new
    @news = News.new
  end

  def edit
    render :new
  end

  def create
    @news = News.new params[:news]
    save_news "Product created successfully"
  end

  def update
    @news.attributes = params[:news]
    save_news "Product updated successfully"
  end

  def destroy
    @news.destroy
    redirect_to admin_news_index_path
  end

  protected

    def find_news
      @news = News.find params[:id]
    end

    def save_news(success_message)
      if @news.valid?
        if params[:commit].include? "Publish"
          @news.published_at = Time.now
        elsif params[:commit].include? "Unpublish"
          @news.published_at = nil
        end
        @news.save
        flash[:message] = success_message
        redirect_to admin_news_index_path
      else
        render :new
      end
    end

end
