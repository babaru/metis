class AddRealityDiscountsMediumMasterPlans < ActiveRecord::Migration
  def up
    add_column :medium_master_plans, :reality_medium_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :medium_master_plans, :reality_company_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :medium_master_plans, :original_medium_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :medium_master_plans, :original_company_discount, :decimal, precision: 8, scale: 2, default: 1

    MediumMasterPlan.all.each do |item|
      medium_discount = MediumPolicy.medium_discount(item.medium_id, item.master_plan.client_id)
      Rails.logger.debug medium_discount
      medium_discount ||= 1
      item.original_medium_discount = medium_discount
      item.reality_medium_discount = medium_discount
      company_discount = MediumPolicy.company_discount(item.medium_id, item.master_plan.client_id)
      company_discount ||= 1
      item.original_company_discount = company_discount
      item.reality_company_discount = company_discount
      item.save!
    end
  end

  def down
    remove_column :medium_master_plans, :reality_medium_discount
    remove_column :medium_master_plans, :reality_company_discount
    remove_column :medium_master_plans, :original_medium_discount
    remove_column :medium_master_plans, :original_company_discount
  end
end
