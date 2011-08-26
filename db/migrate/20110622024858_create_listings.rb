class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.belongs_to :user
      t.belongs_to :property

      t.float :latitude
      t.float :longitude
      t.string :address
      t.integer :land_area
      t.boolean :list_as_land, default: false
      t.integer :residence_area
      t.string :residence_construction
      t.boolean :beach_front
      t.boolean :near_beach
      t.string :residence_type
      t.text :description
      t.string :address

      t.integer :selling_price
      
      t.integer :rent_per_day
      t.integer :rent_per_week
      t.integer :rent_per_month
      t.integer :rent_per_month_biannual_contract
      t.integer :rent_per_month_annual_contract
      t.date :available_on
      
      t.boolean :anonymous
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.text :contact_note
      
      t.string :lister_interest
    
      t.timestamps
    end
    add_index :listings, :user_id
  end
end
