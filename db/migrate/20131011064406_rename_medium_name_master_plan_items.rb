class RenameMediumNameMasterPlanItems < ActiveRecord::Migration
  def up
    rename_column :master_plan_items, :website_name, :medium_name
    rename_column :master_plan_items, :website_discount, :medium_discount
    rename_column :master_plan_items, :website_bonus_ratio, :medium_bonus_ratio
  end

  def down
    rename_column :master_plan_items, :medium_name, :website_name
    rename_column :master_plan_items, :medium_discount, :website_discount
    rename_column :master_plan_items, :medium_bonus_ratio, :website_bonus_ratio
  end
end
