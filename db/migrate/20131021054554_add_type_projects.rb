class AddTypeProjects < ActiveRecord::Migration
  def up
    add_column :projects, :type, :string

    Project.all.each do |p|
      p.type = Project.name
      p.save!
    end

    MasterPlan.all.each do |mp|
      mp.type = MasterPlan.name
      mp.save!
    end
  end

  def down
    remove_column :projects, :type
  end
end
