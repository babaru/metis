class AddMediumMasterPlanMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :medium_master_plan_id, :integer
    add_index :master_plan_items, :medium_master_plan_id

    MasterPlanItem.all.each do |item|
      mmp = MediumMasterPlan.find_by_master_plan_id_and_medium_id(item.master_plan_id, item.medium_id)
      unless mmp
        mmp = MediumMasterPlan.create!({
            master_plan_id: item.master_plan_id,
            medium_id: item.medium_id,
            master_plan_name: item.master_plan_name,
            medium_name: item.medium_name
          })
      end
      item.medium_master_plan_id = mmp.id
      item.save
    end
  end

  def down
    remove_column :master_plan_items, :medium_master_plan_id
    remove_index :master_plan_items, :medium_master_plan_id
  end
end
