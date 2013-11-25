class CreateDepartmentUsers < ActiveRecord::Migration
  def change
    create_table :department_users do |t|
      t.references :department
      t.references :user

      t.timestamps
    end
    add_index :department_users, :department_id
    add_index :department_users, :user_id
  end
end
