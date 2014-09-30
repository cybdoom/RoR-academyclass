class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.string :image
      t.text   :description
      t.text   :content
      t.boolean :sticky, null: false, default: false

      t.timestamps
    end
  end
end
