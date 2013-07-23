class AddUnitAndRemarkSpots < ActiveRecord::Migration
  def up
    add_column :spots, :unit, :string
    add_column :spots, :remark, :text
  end

  def down
    remove_column :spots, :unit
    remove_column :spots, :remark
  end
end
