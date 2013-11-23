class CreatePaymentInvoices < ActiveRecord::Migration
  def change
    create_table :payment_invoices do |t|
      t.string :number
      t.decimal :amount
      t.string :unit
      t.integer :invoice_type_id
      t.datetime :received_at
      t.references :payment

      t.timestamps
    end
    add_index :payment_invoices, :payment_id
  end
end
