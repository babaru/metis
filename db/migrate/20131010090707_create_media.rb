class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :name
      t.string :url
      t.attachment :logo
      t.string :attachment_access_token
      t.string :type
      t.references :created_by

      t.timestamps
    end
    add_index :media, :created_by_id
  end
end
