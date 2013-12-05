class AddProjectIdPaymentInvoices < ActiveRecord::Migration
  def up
    add_column :payment_invoices, :project_id, :integer
    add_index :payment_invoices, :project_id
  end

  def down
    remove_index :payment_invoices, :project_id
    remove_column :payment_invoices, :project_id
  end
end
