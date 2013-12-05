class CreateCompanyPolicyItems < ActiveRecord::Migration
  def change
    create_table :company_policy_items do |t|
      t.references :company_policy
      t.decimal :min, precision: 20, scale: 3
      t.decimal :max, precision: 20, scale: 3
      t.decimal :rebate, precision: 8, scale: 4
      t.string :remark

      t.timestamps
    end
    add_index :company_policy_items, :company_policy_id
  end
end
