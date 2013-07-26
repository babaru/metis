class CreateSpotCategories < ActiveRecord::Migration
  def change
    create_table :spot_categories do |t|
      t.string :name
      t.text :description
      t.attachment :sample
      t.string :attachment_access_token

      t.timestamps
    end
  end
end
