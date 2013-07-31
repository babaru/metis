class CreateSpotContractsSpots < ActiveRecord::Migration
  def change
    create_table :spot_contracts_spots do |t|
      t.references :spot
      t.references :spot_contract

      t.timestamps
    end
    add_index :spot_contracts_spots, :spot_id
    add_index :spot_contracts_spots, :spot_contract_id
  end
end
