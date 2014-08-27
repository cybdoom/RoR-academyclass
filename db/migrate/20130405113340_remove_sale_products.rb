class RemoveSaleProducts < ActiveRecord::Migration
  def change
    drop_table :purchases
    drop_table :sale_products
  end
end
