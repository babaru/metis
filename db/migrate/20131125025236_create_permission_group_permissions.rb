class CreatePermissionGroupPermissions < ActiveRecord::Migration
  def change
    create_table :permission_group_permissions do |t|
      t.references :permission_group
      t.references :permission

      t.timestamps
    end
    add_index :permission_group_permissions, :permission_group_id
    add_index :permission_group_permissions, :permission_id
  end
end
