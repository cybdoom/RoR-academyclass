class ReplaceFieldInCourse < ActiveRecord::Migration
  def up
  	change_column :courses, :cost, :string
  end

  def down
  	change_column :courses, :cost, :decimal
  end
end
