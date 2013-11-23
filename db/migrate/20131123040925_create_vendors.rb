class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :type
      t.references :space

      t.timestamps
    end

    add_index :vendors, :space_id
  end
end
