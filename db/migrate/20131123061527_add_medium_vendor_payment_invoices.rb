class AddMediumVendorPaymentInvoices < ActiveRecord::Migration
  def up
    add_column :payment_invoices, :vendor_id, :integer
    add_column :payment_invoices, :medium_id, :integer

    add_index :payment_invoices, :vendor_id
    add_index :payment_invoices, :medium_id
  end

  def down
    remove_index :payment_invoices, :vendor_id
    remove_index :payment_invoices, :medium_id

    remove_column :payment_invoices, :vendor_id
    remove_column :payment_invoices, :medium_id
  end
end
