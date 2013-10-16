#encoding: utf-8
class Spot < ActiveRecord::Base
  belongs_to :medium
  belongs_to :channel
  belongs_to :spot_category

  validates :name, presence: true
  validates :medium_id, presence: true
  validates :channel_id, presence: true
  validates :spot_category_id, presence: true
  validates :price, presence: true
  validates :unit, presence: true

  attr_accessible :name, :price, :spec, :unit, :remark, :medium_id, :channel_id, :spot_category_id, :type

  def self.find_or_create_by_data!(data)
    spot = Spot.find_by_name_and_channel_id(data[:name], data[:channel_id])
    params = {
      name: data[:name],
      channel_id: data[:channel_id],
      medium_id: data[:medium_id],
      spot_category_id: data[:spot_category_id],
      price: data[:price],
      unit: data[:unit],
      remark: data[:remark],
      spec: data[:spec]
    }
    if spot.nil?
      Spot.create!(params)
    else
      spot.update_attributes!(params)
    end
  end

  def unit_type
    if self.unit
      self.unit.scan(/元\/天\/轮/) do |matches|
        return Tida::Metis::SpotPriceUnitType.spot_price_unit_types.day_per_round if matches.length > 0
      end

      self.unit.scan(/元\/天/) do |matches|
        return Tida::Metis::SpotPriceUnitType.spot_price_unit_types.day if matches.length > 0
      end

      self.unit.downcase.scan(/cpm/) do |matches|
        return Tida::Metis::SpotPriceUnitType.spot_price_unit_types.cpm if matches.length > 0
      end

      self.unit.downcase.scan(/cpc/) do |matches|
        return Tida::Metis::SpotPriceUnitType.spot_price_unit_types.cpc if matches.length > 0
      end
    end

    Tida::Metis::SpotPriceUnitType.spot_price_unit_types.unknown
  end

  def medium_discount(client_id)
    value = MediumPolicy.medium_discount(self.medium_id, client_id)
    return 1 unless value
    value
  end

  def company_discount(client_id)
    value = MediumPolicy.company_discount(self.medium_id, client_id)
    return 1 unless value
    value
  end

  def medium_bonus_ratio(client_id)
    value = MediumPolicy.medium_bonus_ratio(self.medium_id, client_id)
    return 0 unless value
    value
  end

  def company_bonus_ratio(client_id)
    value = MediumPolicy.company_bonus_ratio(self.medium_id, client_id)
    return 0 unless value
    value
  end
end
