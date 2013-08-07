class MasterPlan < ActiveRecord::Base
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  attr_accessible :project_id, :created_by_id, :name
  has_many :items, class_name: 'MasterPlanItem'

  def contract_price
    sum = 0
    items.where(is_on_house: false).each do |item|
      sum += (item.spot.price * item.count * project.client.our_discount_value(item.spot.website_id))
    end
    sum
  end

  def cost
    sum = 0
    items.where(is_on_house: false).each do |item|
      sum += (item.spot.price * item.count * project.client.website_discount_value(item.spot.website_id))
    end
    sum
  end

  def profit
    contract_price - cost
  end

  def on_house_rate
    total_price = 0
    items.where(is_on_house: false).each do |item|
      total_price += item.spot.price * item.count * item.master_plan.project.client.our_discount_value(item.spot.website_id)
    end

    on_house_amount = 0
    items.where(is_on_house: true).each do |item|
      on_house_amount += item.spot.price * item.count
    end
    (on_house_amount.to_f / total_price.to_f).to_f.round(2)
  end
end
