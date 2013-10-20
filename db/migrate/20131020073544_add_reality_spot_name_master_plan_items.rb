class AddRealitySpotNameMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :reality_spot_name, :string

    MasterPlanItem.all.each do |item|
      item.reality_spot_name = item.spot_name
      item.save
    end
  end

  def down
    remove_column :master_plan_items, :reality_spot_name
  end
end
