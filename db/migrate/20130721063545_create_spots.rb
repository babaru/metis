class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.references :website
      t.references :channel
      t.string :name
      t.integer :price
      t.text :spec

      t.timestamps
    end
    add_index :spots, :website_id
    add_index :spots, :channel_id
  end
end
