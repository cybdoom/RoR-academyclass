class AddImageColumnsToLocations < ActiveRecord::Migration
  def up
    add_attachment :locations, :image
  end

  def down
    remove_attachment :locations, :image
  end
end
