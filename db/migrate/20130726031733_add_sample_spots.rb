class AddSampleSpots < ActiveRecord::Migration
  def up
    add_attachment :spots, :sample
    add_column :spots, :attachment_access_token, :string
  end

  def down
    remove_attachment :spots, :sample
    remove_column :spots, :attachment_access_token
  end
end
