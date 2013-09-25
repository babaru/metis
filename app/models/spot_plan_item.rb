class SpotPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :master_plan_item
  belongs_to :spot
  belongs_to :website
  belongs_to :channel
  belongs_to :created_by
  belongs_to :new_spot_plan_item, class_name: 'SpotPlanItem', foreign_key: :new_spot_plan_item_id
  has_one :spot_plan_item

  attr_accessible :count, :is_enabled, :placed_at, :master_plan_item_id,
    :created_by_id, :master_plan_item_reality_count, :version,
    :new_spot_plan_item_id, :client_id, :project_id, :master_plan_id, :spot_id, :website_id, :channel_id, :date_id
  attr_accessor :master_plan_item_reality_count

  scope :in_version, lambda{|master_plan_item_id, version| where(master_plan_item_id: master_plan_item_id, version: version)}

  def change_placed_at!(new_placed_at, current_user_id)
    SpotPlanItem.transaction do
      @new_spot_plan_item = SpotPlanItem.find_by_master_plan_item_id_and_placed_at(self.master_plan_item_id, new_placed_at)
      if @new_spot_plan_item.nil?
        @new_spot_plan_item = SpotPlanItem.new({
          master_plan_item_id: self.master_plan_item_id,
          client_id: self.client_id,
          project_id: self.project_id,
          master_plan_id: self.master_plan_id,
          spot_id: self.spot_id,
          website_id: self.website_id,
          channel_id: self.channel_id,
          version: self.master_plan.working_version,
          placed_at: new_placed_at,
          count: self.count,
          created_by_id: current_user_id
          })
      else
        @new_spot_plan_item.count = @new_spot_plan_item.count + self.count
      end

      @new_spot_plan_item.save!

      self.count = 0
      self.new_spot_plan_item_id = @new_spot_plan_item.id
      self.save!
    end
    @new_spot_plan_item
  end

  def copy_to_new_version!(new_version)
    SpotPlanItem.find_by_master_plan_item_id_and_placed_at_and_version(
      self.master_plan_item_id,
      self.placed_at,
      new_version
      ) || SpotPlanItem.create!({
      master_plan_item_id: self.master_plan_item_id,
      client_id: self.client_id,
      project_id: self.project_id,
      master_plan_id: self.master_plan_id,
      spot_id: self.spot_id,
      website_id: self.website_id,
      channel_id: self.channel_id,
      placed_at: self.placed_at,
      count: self.count,
      created_by_id: self.created_by_id,
      version: new_version
      })
  end

  def as_json(options={})
    item = super(options)
    item['master_plan_item_reality_count'] = self.master_plan_item_reality_count
    item['date_token'] = self.placed_at.strftime('%Y%m%d')
    item['day_index'] = self.placed_at.strftime('%d')
    item['placed_at'] = self.placed_at.strftime('%Y-%m-%d')
    item
  end
end
