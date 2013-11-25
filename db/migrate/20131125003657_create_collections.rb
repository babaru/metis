class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references :client
      t.references :project
      t.decimal :amount
      t.string :unit
      t.references :agency
      t.datetime :made_at
      t.datetime :credit_on
      t.references :space

      t.timestamps
    end
    add_index :collections, :client_id
    add_index :collections, :project_id
    add_index :collections, :agency_id
    add_index :collections, :space_id
  end
end
