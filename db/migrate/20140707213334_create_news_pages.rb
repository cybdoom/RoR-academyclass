class CreateNewsPages < ActiveRecord::Migration
  def change
    create_table :news_pages do |t|
      t.string :title
      t.string :slug, index: true, unique: true
      t.text :body

      t.timestamps
    end

    add_index :news_pages, :slug, unique: true
  end
end
