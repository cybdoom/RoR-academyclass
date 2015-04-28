class AddFieldsForCourses < ActiveRecord::Migration
  def change
    add_column :courses, :head, :string
    add_column :courses, :head_subject, :text
  end
end
