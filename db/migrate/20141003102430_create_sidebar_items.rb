class CreateSidebarItems < ActiveRecord::Migration
  def change
    create_table :sidebar_items do |t|
      t.string :title
      t.text :content
      t.integer :order_num, null: false, default: 0

      t.timestamps
    end
  end
end
