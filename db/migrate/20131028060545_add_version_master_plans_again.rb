class AddVersionMasterPlansAgain < ActiveRecord::Migration
  def up
    add_column :master_plans, :spot_plan_version, :integer, default: 0

    MasterPlan.all.each do |master_plan|
      result = MasterPlan.connection.select_all("select max(version) as working_version from spot_plan_items where master_plan_id=#{master_plan.id}")
      if result.length > 0 && result[0]['working_version']
        master_plan.spot_plan_version = result[0]['working_version']
        master_plan.save!
      end
    end
  end

  def down
    remove_column :master_plans, :spot_plan_version
  end
end
