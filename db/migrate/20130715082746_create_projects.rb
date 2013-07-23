class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :client
      t.references :created_by
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
    add_index :projects, :client_id
    add_index :projects, :created_by_id
  end
end
