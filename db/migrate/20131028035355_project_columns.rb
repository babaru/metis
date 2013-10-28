class ProjectColumns < ActiveRecord::Migration
  def up
    add_column :projects, :client_name, :string
    add_column :projects, :created_by_name, :string

    Project.all.each do |project|
      project.client_name = project.client.name
      project.created_by_name = project.created_by.name
      project.save!
    end

    remove_column :projects, :budget_unit
  end

  def down
    add_column :projects, :budget_unit, :string
    remove_column :projects, :client_name
    remove_column :projects, :created_by_name
  end
end
