class DropWebsites < ActiveRecord::Migration
  def up
    drop_table :websites
  end

  def down
    create_table :websites do |t|
      t.string :name
      t.string :url
      t.attachment :logo
      t.string :attachment_access_token
      t.string :type

      t.timestamps
    end
  end
end
