class CreateUserPermissions < ActiveRecord::Migration
  def change
    create_table :user_permissions do |t|
      t.references :user
      t.references :permission

      t.timestamps
    end
    add_index :user_permissions, :user_id
    add_index :user_permissions, :permission_id
  end
end
