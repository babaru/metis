require "spec_helper"

describe Project, '#create' do
  let(:client) { create(:client, {name: 'Client 1'}) }

  it 'creates a default master plan' do
    project = Project.create!({
      name: 'Project 1',
      client: client
      })
    expect(project.master_plans.count).to eq(1)
  end
end
