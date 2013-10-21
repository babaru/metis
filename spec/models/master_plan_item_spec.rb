require 'spec_helper'

describe MasterPlanItem, '#create' do
  let(:project) { create(:project, {name: 'Project 1'}) }
  let(:client) { create(:client, {name: 'Client 1'}) }
  let(:master_plan) { create(:master_plan, {name: 'Master Plan 1', project: project, client: client}) }

  let(:medium) { create(:medium, {name: 'Website 1'}) }
  let(:channel) { create(:channel, {name: 'Channel 1'}) }
  let(:spot_category) { create(:spot_category, {name: 'Spot Category 1', medium: medium}) }
  let(:medium_policy) { create(:medium_policy, {medium_id: medium.id, client_id: client.id, medium_discount: 0.6, company_discount: 0.7, medium_bonus_ratio: 2.0, company_bonus_ratio: 1.5})}

  let(:spot) { create(:spot, {name: 'Spot 1', price: 13932, unit: '元/天', channel_id: channel.id, medium_id: medium.id, spot_category_id: spot_category.id, type: 'Spot'}) }
  let(:net_cost_spot) { create(:spot, {name: 'Spot 2', price: 13932, unit: '元/天', channel: channel, medium: medium, spot_category: spot_category, type: NetCostSpot.name}) }

  subject(:new_master_plan_item) { MasterPlanItem.create({
      count: 23,
      spot: spot,
      master_plan: master_plan,
      project: project,
      client: client,
      medium: medium,
      channel: channel
      }) }

  subject(:net_cost_spot_master_plan_item) {
    MasterPlanItem.create({
        count: 23,
        spot: net_cost_spot,
        master_plan: master_plan,
        project: project,
        client: client,
        medium: medium,
        channel: channel
      })
  }

  it 'copy "name" fields' do
    expect(new_master_plan_item.spot_name).to eq(spot.name)
    expect(new_master_plan_item.master_plan_name).to eq(master_plan.name)
    expect(new_master_plan_item.project_name).to eq(project.name)
    expect(new_master_plan_item.client_name).to eq(client.name)
    expect(new_master_plan_item.medium_name).to eq(medium.name)
    expect(new_master_plan_item.channel_name).to eq(channel.name)
  end

  it 'copy spot price as unit rate card' do
    expect(new_master_plan_item.unit_rate_card).to eq(spot.price)
    expect(new_master_plan_item.unit_rate_card_unit).to eq(spot.unit)
  end

  it 'copy spot price unit type as unit rate card unit type' do
    expect(new_master_plan_item.unit_rate_card_unit_type).to eq(spot.unit_type)
  end

  it 'copy medium policy' do
    expect(new_master_plan_item.reality_medium_discount).to eq(spot.medium_discount(client.id))
    expect(new_master_plan_item.reality_company_discount).to eq(spot.company_discount(client.id))
    expect(new_master_plan_item.original_medium_discount).to eq(spot.medium_discount(client.id))
    expect(new_master_plan_item.original_company_discount).to eq(spot.company_discount(client.id))

    expect(net_cost_spot_master_plan_item.reality_medium_discount).to eq(1)
    expect(net_cost_spot_master_plan_item.reality_company_discount).to eq(1)
    expect(net_cost_spot_master_plan_item.original_medium_discount).to eq(1)
    expect(net_cost_spot_master_plan_item.original_company_discount).to eq(1)
  end
end
