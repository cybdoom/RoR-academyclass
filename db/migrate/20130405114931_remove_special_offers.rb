class RemoveSpecialOffers < ActiveRecord::Migration
  def change
    drop_table :special_offers
    drop_table :special_offer_course_dates
  end
end
