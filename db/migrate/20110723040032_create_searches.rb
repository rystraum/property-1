class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer  :user_id
      t.integer  :range
      t.string   :address
      t.float    :latitude
      t.float    :longitude
      t.float    :sw_lat
      t.float    :sw_lng
      t.float    :ne_lat
      t.float    :ne_lng
      t.boolean  :for_sale
      t.boolean  :for_rent
      t.boolean  :native
      t.boolean  :basic
      t.boolean  :modern
      t.boolean  :elegant
      t.boolean  :house
      t.boolean  :apartment
      t.boolean  :chalet
      t.boolean  :private_room
      t.boolean  :shared_room
      t.boolean  :land
      t.boolean  :commercial
      t.string   :rental_term
      t.integer  :for_sale_min_price
      t.integer  :for_sale_max_price
      t.integer  :for_rent_min_price
      t.integer  :for_rent_max_price
      t.integer  :center_lat
      t.integer  :center_lng
      t.integer  :zoom
      t.timestamps
    end
  end
end
