class AddDispatchedDateToEmails < ActiveRecord::Migration
  def change
    add_column :email_logs, :dispatched_at, :datetime
  end
end
