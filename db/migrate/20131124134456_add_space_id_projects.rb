class AddSpaceIdProjects < ActiveRecord::Migration
  def up
    add_column :projects, :space_id, :integer
    add_index :projects, :space_id
  end

  def down
    remove_index :projects, :space_id
    remove_column :projects, :space_id
  end
end
