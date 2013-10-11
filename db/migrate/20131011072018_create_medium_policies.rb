class CreateMediumPolicies < ActiveRecord::Migration
  def change
    create_table :medium_policies do |t|
      t.references :medium
      t.references :client
      t.references :channel

      t.decimal :medium_discount, precision: 8, scale: 2, default: 1
      t.decimal :company_discount, precision: 8, scale: 2, default: 1
      t.decimal :medium_bonus_ratio, precision: 8, scale: 2, default: 0
      t.decimal :company_bonus_ratio, precision: 8, scale: 2, default: 0
      t.decimal :cpm_discount, precision: 8, scale: 2, default: 1

      t.timestamps
    end

    add_index :medium_policies, :medium_id
    add_index :medium_policies, :client_id
    add_index :medium_policies, :channel_id
  end
end
