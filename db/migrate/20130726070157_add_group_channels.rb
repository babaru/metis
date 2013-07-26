class AddGroupChannels < ActiveRecord::Migration
  def up
    add_column :channels, :channel_group_id, :integer
    add_index :channels, :channel_group_id
  end

  def down
    remove_column :channels, :channel_group_id
    remove_index :channels, :channel_group_id
  end
end
