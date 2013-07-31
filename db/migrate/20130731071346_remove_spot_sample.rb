class RemoveSpotSample < ActiveRecord::Migration
  def up
    remove_attachment :spots, :sample
    remove_column :spots, :attachment_access_token
  end

  def down
    add_attachment :spots, :sample
    add_column :spots, :attachment_access_token, :string
  end
end
