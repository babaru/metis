class AddTypeRoles < ActiveRecord::Migration
  def up
    add_column :roles, :type, :string

    Role.transaction do
      Role.all.each do |role|
        role.type = Role.name
        role.save!
      end
    end
  end

  def down
    remove_column :roles, :type
  end
end
