class CreateSpotContracts < ActiveRecord::Migration
  def change
    create_table :spot_contracts do |t|
      t.references :client
      t.references :project
      t.references :created_by

      t.timestamps
    end
    add_index :spot_contracts, :client_id
    add_index :spot_contracts, :project_id
    add_index :spot_contracts, :created_by_id
  end
end
