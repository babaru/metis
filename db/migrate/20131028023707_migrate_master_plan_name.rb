class MigrateMasterPlanName < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      project.master_plans.each_with_index do |master_plan, index|
        master_plan.name = "第#{index + 1}版" unless master_plan.name
        master_plan.save!
      end
    end
  end

  def down
  end
end
