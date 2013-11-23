class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :client
      t.references :project
      t.decimal :amount
      t.string :unit
      t.references :medium
      t.references :vendor
      t.datetime :paid_at
      t.datetime :credit_on

      t.timestamps
    end
    add_index :payments, :client_id
    add_index :payments, :project_id
    add_index :payments, :medium_id
    add_index :payments, :vendor_id
  end
end
