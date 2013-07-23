class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.attachment :logo
      t.references :created_by
      t.string :attachment_access_token

      t.timestamps
    end
    add_index :clients, :created_by_id
  end
end
