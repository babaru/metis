class AddIsStartedProjects < ActiveRecord::Migration
  def up
    add_column :projects, :is_started, :boolean, default: false
    add_column :projects, :is_started_at, :datetime
  end

  def down
    remove_column :projects, :is_started
    remove_column :projects, :is_started_at
  end
end
