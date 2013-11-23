class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.references :space

      t.timestamps
    end
    add_index :departments, :space_id
  end
end
