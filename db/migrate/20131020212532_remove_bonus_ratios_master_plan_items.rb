class RemoveBonusRatiosMasterPlanItems < ActiveRecord::Migration
  def up
    remove_column :master_plan_items, :medium_bonus_ratio
    remove_column :master_plan_items, :company_bonus_ratio
  end

  def down
    add_column :master_plan_items, :medium_bonus_ratio, :decimal, precision: 8, scale: 2, default: 0
    add_column :master_plan_items, :company_bonus_ratio, :decimal, precision: 8, scale: 2, default: 0
  end
end
