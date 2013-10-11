require 'spec_helper'

describe MasterPlanItem, '#create' do
  let(:spot) { create(:spot, {name: 'Spot 1', price: 13932, unit: '元/天'}) }
  let(:master_plan) { create(:master_plan, {name: 'Master Plan 1'}) }
  let(:project) { create(:project, {name: 'Project 1'}) }
  let(:client) { create(:client, {name: 'Client 1'}) }
  let(:website) { create(:website, {name: 'Website 1'}) }
  let(:channel) { create(:channel, {name: 'Channel 1'}) }

  subject(:new_master_plan_item) { MasterPlanItem.create({
      count: 23,
      spot: spot,
      master_plan: master_plan,
      project: project,
      client: client,
      website: website,
      channel: channel
      }) }

  it 'copy "name" fields' do
    expect(new_master_plan_item.spot_name).to eq(spot.name)
    expect(new_master_plan_item.master_plan_name).to eq(master_plan.name)
    expect(new_master_plan_item.project_name).to eq(project.name)
    expect(new_master_plan_item.client_name).to eq(client.name)
    expect(new_master_plan_item.website_name).to eq(website.name)
    expect(new_master_plan_item.channel_name).to eq(channel.name)
  end

  it 'copy spot price as unit rate card' do
    expect(new_master_plan_item.unit_rate_card).to eq(spot.price)
    expect(new_master_plan_item.unit_rate_card_unit).to eq(spot.unit)
  end

  it 'copy spot price unit type as unit rate card unit type' do
    expect(new_master_plan_item.unit_rate_card_unit_type).to eq(spot.unit_type)
  end
end
