class ChangeMediumMasterPlanColumns < ActiveRecord::Migration
  def up
    change_column_default :medium_master_plans, :original_medium_discount, nil
    change_column_default :medium_master_plans, :original_company_discount, nil
    change_column_default :medium_master_plans, :reality_medium_discount, nil
    change_column_default :medium_master_plans, :reality_company_discount, nil
  end

  def down
    change_column_default :medium_master_plans, :original_medium_discount, 1
    change_column_default :medium_master_plans, :original_company_discount, 1
    change_column_default :medium_master_plans, :reality_medium_discount, 1
    change_column_default :medium_master_plans, :reality_company_discount, 1
  end
end
