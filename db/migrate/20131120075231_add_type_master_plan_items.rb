class AddTypeMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :type, :string

    MasterPlanItem.all.each do |item|
      item.type = MasterPlanItem.name
      item.save!
    end
  end

  def down
    remove_column :master_plan_items, :type
  end
end
