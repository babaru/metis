class CreateClientAssignments < ActiveRecord::Migration
  def change
    create_table :client_assignments do |t|
      t.references :client
      t.references :user

      t.timestamps
    end
    add_index :client_assignments, :client_id
    add_index :client_assignments, :user_id
  end
end
