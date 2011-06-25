class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.integer :admin_id
      t.string :phone

      t.timestamps
    end
  end
end
