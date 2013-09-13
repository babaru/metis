class AddExtraColumnsMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :website_name, :string
    add_column :master_plan_items, :channel_name, :string
    add_column :master_plan_items, :position_name, :string
    add_column :master_plan_items, :material_format, :string
    add_column :master_plan_items, :pv_tracking, :boolean, default: false
    add_column :master_plan_items, :click_tracking, :boolean, default: false
    add_column :master_plan_items, :link_to_official_site, :boolean, default: false
    add_column :master_plan_items, :mr_deadline, :string
    add_column :master_plan_items, :est_total_imp, :integer
    add_column :master_plan_items, :est_total_clicks, :integer
    add_column :master_plan_items, :est_imp, :integer
    add_column :master_plan_items, :est_clicks, :integer
    add_column :master_plan_items, :est_ctr, :integer
    add_column :master_plan_items, :est_cpc, :integer
    add_column :master_plan_items, :est_cpm, :integer
    add_column :master_plan_items, :days, :integer
    add_column :master_plan_items, :cpc, :integer
    add_column :master_plan_items, :unit_rate_card, :decimal
    add_column :master_plan_items, :discount, :decimal
    add_column :master_plan_items, :net_cost, :decimal
    add_column :master_plan_items, :total_rate_card, :decimal
  end

  def down
    remove_column :master_plan_items, :website_name
    remove_column :master_plan_items, :channel_name
    remove_column :master_plan_items, :position_name
    remove_column :master_plan_items, :material_format
    remove_column :master_plan_items, :pv_tracking
    remove_column :master_plan_items, :click_tracking
    remove_column :master_plan_items, :link_to_official_site
    remove_column :master_plan_items, :mr_deadline
    remove_column :master_plan_items, :est_total_imp
    remove_column :master_plan_items, :est_total_clicks
    remove_column :master_plan_items, :est_imp
    remove_column :master_plan_items, :est_clicks
    remove_column :master_plan_items, :est_ctr
    remove_column :master_plan_items, :est_cpc
    remove_column :master_plan_items, :est_cpm
    remove_column :master_plan_items, :days
    remove_column :master_plan_items, :cpc
    remove_column :master_plan_items, :unit_rate_card
    remove_column :master_plan_items, :discount
    remove_column :master_plan_items, :net_cost
    remove_column :master_plan_items, :total_rate_card
  end
end
