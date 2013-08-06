class MasterPlan < ActiveRecord::Base
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  attr_accessible :project_id, :created_by_id, :name
  has_many :items, class_name: 'MasterPlanItem'

  def calculate_total_price
    items.inject(0) do |sum, item|
      sum += item.spot.price * item.count
    end
  end

  def on_house_ratio
    total_price = 0
    items.where(is_on_house: false).each do |item|
      total_price += item.spot.price * item.discount_value(item.spot.website.id)
    end

    on_house_amount = 0
    items.where(is_on_house: true).each do |item|
      on_house_amount += item.spot.price
    end
    (on_house_amount / total_price).round(1)
  end
end
