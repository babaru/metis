class CreateCompanyPolicies < ActiveRecord::Migration
  def change
    create_table :company_policies do |t|
      t.references :client
      t.references :medium
      t.decimal :framework, precision: 20, scale: 3
      t.integer :year

      t.timestamps
    end
    add_index :company_policies, :client_id
    add_index :company_policies, :medium_id
  end
end
