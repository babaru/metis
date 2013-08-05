class AddBudgetProjects < ActiveRecord::Migration
  def up
    add_column :projects, :budget, :integer
    add_column :projects, :budget_unit, :string
  end

  def down
    remove_column :projects, :budget
    remove_column :projects, :budget
  end
end
