class RemoveUserUploads < ActiveRecord::Migration
  def change
    drop_table :user_uploads
    drop_table :delayed_jobs
    rename_column :uploads, :file_created_at, :created_at
  end
end
