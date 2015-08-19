class AddImageColumnsToFundings < ActiveRecord::Migration
  def up
    add_attachment :fundings, :image
  end

  def down
    remove_attachment :fundings, :image
  end
end
