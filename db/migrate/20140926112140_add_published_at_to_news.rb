class AddPublishedAtToNews < ActiveRecord::Migration
  def change
    add_column :news, :published_at, :timestamp
    add_index :news, :published_at
  end
end
