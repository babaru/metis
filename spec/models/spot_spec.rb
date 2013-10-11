require 'spec_helper'

describe Spot, '#unit_type' do
  context 'when spot price unit is "元/天"' do
    let(:spot) { create(:spot, {unit: '元/天'})}
    it 'should eq UnitType.Day' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.day)
    end
  end

  context 'when spot price unit is "元/天/轮"' do
    let(:spot) { create(:spot, {unit: '元/天/轮'})}
    it 'should eq UnitType.DayPerRound' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.day_per_round)
    end
  end

  context 'when spot price unit is "元/CPM"' do
    let(:spot) { create(:spot, {unit: '元/CPM'})}
    it 'should eq UnitType.DayPerRound' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.cpm)
    end
  end

  context 'when spot price unit is "元/CPC"' do
    let(:spot) { create(:spot, {unit: '元/cpC'})}
    it 'should eq UnitType.DayPerRound' do
      spot.unit_type.should eq(Tida::Metis::SpotPriceUnitType.spot_price_unit_types.cpc)
    end
  end
end
