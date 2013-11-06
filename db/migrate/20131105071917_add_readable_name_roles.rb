class AddReadableNameRoles < ActiveRecord::Migration
  def up
    add_column :roles, :readable_name, :string
  end

  def down
    remove_column :roles, :readable_name
  end
end
