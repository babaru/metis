class CreateMediumMasterPlans < ActiveRecord::Migration
  def change
    create_table :medium_master_plans do |t|
      t.references :master_plan
      t.string :master_plan_name
      t.references :medium
      t.string :medium_name
      t.decimal :reality_medium_net_cost, precision: 10, scale: 3, default: 0
      t.decimal :reality_company_net_cost, precision: 10, scale: 3, default: 0
      t.decimal :medium_discount, precision: 8, scale: 2, default: 1
      t.decimal :company_discount, precision: 8, scale: 2, default: 1
      t.decimal :reality_medium_discount, precision: 8, scale: 2, default: 1
      t.decimal :reality_company_discount, precision: 8, scale: 2, default: 1

      t.timestamps
    end
    add_index :medium_master_plans, :master_plan_id
    add_index :medium_master_plans, :medium_id
  end
end
