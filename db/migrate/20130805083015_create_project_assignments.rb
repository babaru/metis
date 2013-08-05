class CreateProjectAssignments < ActiveRecord::Migration
  def change
    create_table :project_assignments do |t|
      t.references :project
      t.references :user

      t.timestamps
    end
    add_index :project_assignments, :project_id
    add_index :project_assignments, :user_id
  end
end
