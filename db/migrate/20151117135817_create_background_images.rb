class CreateBackgroundImages < ActiveRecord::Migration
  def change
    create_table :background_images do |t|
      t.string :title
      t.text :link

      t.timestamps
    end
  end
end
