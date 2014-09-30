class NewsController < ApplicationController

  def index
    @news = News.published.order("sticky DESC, created_at DESC").
      page(params[:page] || 1).per_page(6)
  end

  def show
    @news = News.published.find params[:id]
    redirect_to news_index_path unless @news
  rescue ActiveRecord::RecordNotFound
    redirect_to news_index_path
  end

end
