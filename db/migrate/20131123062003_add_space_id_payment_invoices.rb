class AddSpaceIdPaymentInvoices < ActiveRecord::Migration
  def up
    add_column :payment_invoices, :space_id, :integer
    add_index :payment_invoices, :space_id
  end

  def down
    remove_index :payment_invoices, :space_id
    remove_column :payment_invoices, :space_id
  end
end
