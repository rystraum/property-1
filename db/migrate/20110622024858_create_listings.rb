class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.float :latitude
      t.float :longitude
      t.string :title
      t.belongs_to :user
      t.belongs_to :property
      t.integer :land_area
      t.integer :residence_area
      t.string :residence_construction
      t.boolean :beach_front
      t.boolean :near_beach
      t.string :residence_type
      t.boolean :contact_directly
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
