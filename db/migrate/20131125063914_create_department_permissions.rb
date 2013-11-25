class CreateDepartmentPermissions < ActiveRecord::Migration
  def change
    create_table :department_permissions do |t|
      t.references :department
      t.references :permission

      t.timestamps
    end
    add_index :department_permissions, :department_id
    add_index :department_permissions, :permission_id
  end
end
