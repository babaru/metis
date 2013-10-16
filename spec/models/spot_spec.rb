require 'spec_helper'

describe Spot, '#unit_type' do

  let(:medium) { create(:medium, {name: 'Website 1'}) }
  let(:channel) { create(:channel, {name: 'Channel 1'}) }
  let(:spot_category) { create(:spot_category, {name: 'Spot Category 1', medium: medium}) }

  context 'when spot price unit is "元/天"' do
    let(:spot) { create(:spot, {price: 0, name: 'Position', unit: '元/天', medium: medium, channel: channel, spot_category: spot_category})}
    it 'should eq UnitType.Day' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.day)
    end
  end

  context 'when spot price unit is "元/天/轮"' do
    let(:spot) { create(:spot, {price: 0, name: 'Position', unit: '元/天/轮', medium: medium, channel: channel, spot_category: spot_category})}
    it 'should eq UnitType.DayPerRound' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.day_per_round)
    end
  end

  context 'when spot price unit is "元/CPM"' do
    let(:spot) { create(:spot, {price: 0, name: 'Position', unit: '元/CPM', medium: medium, channel: channel, spot_category: spot_category})}
    it 'should eq UnitType.DayPerRound' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.cpm)
    end
  end

  context 'when spot price unit is "元/CPC"' do
    let(:spot) { create(:spot, {price: 0, name: 'Position', unit: '元/cpC', medium: medium, channel: channel, spot_category: spot_category})}
    it 'should eq UnitType.DayPerRound' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.cpc)
    end
  end
end
