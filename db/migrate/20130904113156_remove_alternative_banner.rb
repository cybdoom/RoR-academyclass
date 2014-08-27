class RemoveAlternativeBanner < ActiveRecord::Migration
  def up
    remove_column :banners, :alternative_file_name
  end

  def down
    add_column :banners, :alternative_file_name, :string
  end
end
