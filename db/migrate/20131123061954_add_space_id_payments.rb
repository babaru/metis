class AddSpaceIdPayments < ActiveRecord::Migration
  def up
    add_column :payments, :space_id, :integer
    add_index :payments, :space_id
  end

  def down
    remove_index :payments, :space_id
    remove_column :payments, :space_id
  end
end
