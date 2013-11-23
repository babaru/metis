class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :type
      t.references :space

      t.timestamps
    end

    add_index :agencies, :space_id
  end
end
