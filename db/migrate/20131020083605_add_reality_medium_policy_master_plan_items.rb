class AddRealityMediumPolicyMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :reality_medium_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :master_plan_items, :reality_company_discount, :decimal, precision: 8, scale: 2, default: 1

    rename_column :master_plan_items, :medium_discount, :original_medium_discount
    rename_column :master_plan_items, :company_discount, :original_company_discount

    MasterPlanItem.all.each do |item|
      medium_discount = MediumPolicy.medium_discount(item.medium_id, item.client_id)
      medium_discount ||= 1
      item.original_medium_discount = medium_discount
      item.reality_medium_discount = medium_discount
      company_discount = MediumPolicy.company_discount(item.medium_id, item.client_id)
      company_discount ||= 1
      item.original_company_discount = company_discount
      item.reality_company_discount = company_discount
      item.save!
    end
  end

  def down
    remove_column :master_plan_items, :reality_medium_discount
    remove_column :master_plan_items, :reality_company_discount

    rename_column :master_plan_items, :original_medium_discount, :medium_discount
    rename_column :master_plan_items, :original_company_discount, :company_discount
  end
end
