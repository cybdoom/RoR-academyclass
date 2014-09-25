class NewsController < ApplicationController

  def index
    @news = News.order("sticky DESC, created_at DESC").page(params[:page] || 1)
  end

  def show
    @news = News.find params[:id]
    redirect_to news_index_path unless @news
  end

end
