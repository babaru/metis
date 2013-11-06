class CreateSpaceUsers < ActiveRecord::Migration
  def change
    create_table :space_users do |t|
      t.references :space
      t.references :user

      t.timestamps
    end
    add_index :space_users, :space_id
    add_index :space_users, :user_id
  end
end
