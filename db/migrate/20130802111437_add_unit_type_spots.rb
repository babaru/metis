class AddUnitTypeSpots < ActiveRecord::Migration
  def up
    add_column :spots, :unit_type, :string
  end

  def down
    remove_column :spots, :unit_type
  end
end
