class CreateFundings < ActiveRecord::Migration
  def change
    create_table :fundings do |t|
      t.string :title
      t.text :description
      t.text :content
      t.boolean :sticky
      t.string :slug
      t.datetime :published_at
      t.boolean :publish
      t.text :partner
      t.text :partner_link
      t.datetime :available_from
      t.datetime :ending_on

      t.timestamps
    end
  end
end
