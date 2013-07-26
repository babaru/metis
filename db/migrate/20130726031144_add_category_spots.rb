class AddCategorySpots < ActiveRecord::Migration
  def up
    add_column :spots, :spot_category_id, :integer
    add_index :spots, :spot_category_id
  end

  def down
    remove_column :spots, :spot_category_id
    remove_index :spots, :spot_category_id
  end
end
