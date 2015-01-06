class AddPublishedAtToNewsPages < ActiveRecord::Migration
  def change
    add_column :news_pages, :published_at, :timestamp
    add_index :news_pages, :published_at
  end
end
