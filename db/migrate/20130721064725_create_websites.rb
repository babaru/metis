class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
      t.string :url
      t.attachment :logo
      t.string :attachment_access_token

      t.timestamps
    end
  end
end
