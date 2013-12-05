class ChangeAmountColumns < ActiveRecord::Migration
  def up
    change_column :payments, :amount, :decimal, precision: 20, scale: 3
    change_column :payment_invoices, :amount, :decimal, precision: 20, scale: 3
    change_column :collections, :amount, :decimal, precision: 20, scale: 3
    change_column :collection_invoices, :amount, :decimal, precision: 20, scale: 3
  end

  def down
  end
end
