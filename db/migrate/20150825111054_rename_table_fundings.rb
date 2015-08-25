class RenameTableFundings < ActiveRecord::Migration
  def self.up
    rename_table :fundings, :funding_admins
  end 
  def self.down
    rename_table :funding_admins, :fundings
  end
end
