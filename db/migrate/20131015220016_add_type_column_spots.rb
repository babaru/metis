class AddTypeColumnSpots < ActiveRecord::Migration
  def up
    add_column :spots, :type, :string

    Spot.all.each do |spot|
      spot.type = 'Spot' unless spot.type
      spot.save
    end
  end

  def down
    remove_column :spots, :type
  end
end
