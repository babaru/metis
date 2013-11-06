class AddSpaceIdClients < ActiveRecord::Migration
  def up
    add_column :clients, :space_id, :integer
    add_column :clients, :space_name, :string
    add_index :clients, :space_id
  end

  def down
    remove_index :clients, :space_id
    remove_column :clients, :space_name
    remove_column :clients, :space_id
  end
end
