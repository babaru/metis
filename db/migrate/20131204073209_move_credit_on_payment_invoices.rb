class MoveCreditOnPaymentInvoices < ActiveRecord::Migration
  def up
    add_column :payment_invoices, :credit_on, :datetime
    remove_column :payments, :credit_on
  end

  def down
    remove_column :payment_invoices, :credit_on
    add_column :payments, :credit_on, :datetime
  end
end
