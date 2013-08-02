class CreateMasterPlans < ActiveRecord::Migration
  def change
    create_table :master_plans do |t|
      t.references :project
      t.references :created_by

      t.timestamps
    end
    add_index :master_plans, :project_id
    add_index :master_plans, :created_by_id
  end
end
