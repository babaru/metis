class CreateCollectionInvoices < ActiveRecord::Migration
  def change
    create_table :collection_invoices do |t|
      t.string :number
      t.decimal :amount
      t.string :unit
      t.integer :invoice_type_id
      t.datetime :sent_at
      t.references :collection
      t.references :space
      t.references :client
      t.references :agency

      t.timestamps
    end
    add_index :collection_invoices, :collection_id
    add_index :collection_invoices, :space_id
    add_index :collection_invoices, :client_id
    add_index :collection_invoices, :agency_id
  end
end
