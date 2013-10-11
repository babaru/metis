class CopyNameValueMasterPlanItems < ActiveRecord::Migration
  def up
    MasterPlanItem.all.each do |item|
      item.spot_name = item.spot.name if item.spot_id
      item.unit_rate_card = item.spot.price if item.spot_id
      item.unit_rate_card_unit = item.spot.unit if item.spot_id
      item.unit_rate_card_unit_type = item.spot.unit_type if item.spot_id
      item.material_format = item.spot.spec if item.spot_id

      item.master_plan_name = item.master_plan.name if item.master_plan_id && item.master_plan
      item.project_name = item.project.name if item.project_id
      item.client_name = item.client.name if item.client_id
      item.medium_name = item.medium.name if item.medium_id
      item.channel_name = item.channel.name if item.channel_id

      item.medium_discount = item.client.medium_discount(item.medium_id) if item.client_id && item.medium_id
      item.company_discount = item.client.company_discount(item.medium_id) if item.client_id && item.medium_id
      item.medium_bonus_ratio = item.client.medium_bonus_ratio(item.medium_id) if item.client_id && item.medium_id
      item.company_bonus_ratio = item.client.company_bonus_ratio(item.medium_id) if item.client_id && item.medium_id

      item.save!
    end
  end

  def down
  end
end
