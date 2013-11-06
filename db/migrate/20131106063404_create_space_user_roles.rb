class CreateSpaceUserRoles < ActiveRecord::Migration
  def change
    create_table :space_user_roles do |t|
      t.references :space_user
      t.references :role

      t.timestamps
    end
    add_index :space_user_roles, :space_user_id
    add_index :space_user_roles, :role_id
  end
end
