class ChangeCpmDiscountMediumPolicies < ActiveRecord::Migration
  def up
    add_column :medium_policies, :medium_cpm_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :medium_policies, :company_cpm_discount, :decimal, precision: 8, scale: 2, default: 1

    MediumPolicy.all.each do |item|
      item.medium_cpm_discount = item.cpm_discount
      item.company_cpm_discount = item.cpm_discount
      item.save!
    end

    remove_column :medium_policies, :cpm_discount
  end

  def down
    add_column :medium_policies, :cpm_discount, :decimal, precision: 8, scale: 2, default: 1

    MediumPolicy.all.each do |item|
      item.cpm_discount = item.medium_cpm_discount
      item.save!
    end

    remove_column :medium_policies, :medium_cpm_discount
    remove_column :medium_policies, :company_cpm_discount
  end
end
