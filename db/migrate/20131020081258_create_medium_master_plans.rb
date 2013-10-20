class CreateMediumMasterPlans < ActiveRecord::Migration
  def change
    create_table :medium_master_plans do |t|
      t.references :master_plan
      t.string :master_plan_name
      t.references :medium
      t.string :medium_name
      t.decimal :reality_medium_net_cost, precision: 20, scale: 3
      t.decimal :reality_company_net_cost, precision: 20, scale: 3

      t.timestamps
    end
    add_index :medium_master_plans, :master_plan_id
    add_index :medium_master_plans, :medium_id

    MasterPlan.all.each do |item|
      item.candidate_media.each do |medium|
        mmp = MediumMasterPlan.find_by_medium_id_and_master_plan_id(medium.id, item.id)
        unless mmp
          mmp = MediumMasterPlan.create!({
            master_plan_id: item.id,
            medium_id: medium.id,
            master_plan_name: item.name,
            medium_name: medium.name
          })
        end
      end
    end
  end
end
