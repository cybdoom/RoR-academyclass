class RemoveImageFromNews < ActiveRecord::Migration
  def up
    remove_column :news, :image
  end

  def down
    add_column :news, :image, :string
  end
end
