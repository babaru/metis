class ModifySpotPriceColumnsMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :unit_rate_card_unit, :string
    add_column :master_plan_items, :unit_rate_card_unit_type, :integer, default: 0
    change_column :master_plan_items, :unit_rate_card, :decimal, precision: 10, scale: 3, default: 0
    change_column :master_plan_items, :net_cost, :decimal, precision: 10, scale: 3, default: 0
    change_column :master_plan_items, :total_rate_card, :decimal, precision: 10, scale: 3, default: 0
  end

  def down
    remove_column :master_plan_items, :unit_rate_card_unit
    remove_column :master_plan_items, :unit_rate_card_unit_type
    change_column :master_plan_items, :unit_rate_card, :decimal, precision: 10, scale: 0
    change_column :master_plan_items, :net_cost, :decimal, precision: 10, scale: 0
    change_column :master_plan_items, :total_rate_card, :decimal, precision: 10, scale: 0
  end
end
