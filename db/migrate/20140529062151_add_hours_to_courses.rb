class AddHoursToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :hours, :string, after: :duration
  end
end
