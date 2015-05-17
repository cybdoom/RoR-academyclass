class AddFieldForEmailLogs < ActiveRecord::Migration
  def change
  	add_column :email_logs, :link, :text
  end
end
