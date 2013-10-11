class SetMediumType < ActiveRecord::Migration
  def up
    Medium.all.each do |m|
      m.type = Medium.name
      m.save
    end
  end

  def down
  end
end
