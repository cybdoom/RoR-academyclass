class AddImageColumnsToNews < ActiveRecord::Migration
  def up
    add_attachment :news, :image
  end

  def down
    remove_attachment :news, :image
  end
end
