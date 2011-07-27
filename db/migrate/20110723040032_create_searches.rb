class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer  :user_id
      t.string   :address
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
      t.string   :center
      t.string   :sw_bounds
      t.string   :ne_bounds
      t.integer  :zoom
      t.timestamps
    end
  end
end
