class AddWebsiteSpotCategories < ActiveRecord::Migration
  def up
    add_column :spot_categories, :website_id, :integer
    add_index :spot_categories, :website_id
  end

  def down
    remove_column :spot_categories, :website_id
    remove_index :spot_categories, :website_id
  end
end
