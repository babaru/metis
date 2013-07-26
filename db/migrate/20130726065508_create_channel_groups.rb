class CreateChannelGroups < ActiveRecord::Migration
  def change
    create_table :channel_groups do |t|
      t.string :name
      t.references :website

      t.timestamps
    end
    add_index :channel_groups, :website_id
  end
end
