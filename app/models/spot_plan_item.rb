class SpotPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :master_plan_item
  belongs_to :spot
  belongs_to :medium
  belongs_to :channel
  belongs_to :created_by
  belongs_to :new_spot_plan_item, class_name: 'SpotPlanItem', foreign_key: :new_spot_plan_item_id
  has_one :spot_plan_item

  before_create :copy_mandatory_attributes

  attr_accessible :count,
    :is_enabled,
    :placed_at,
    :master_plan_item_id,
    :created_by_id,
    :master_plan_item_reality_count,
    :version,
    :new_spot_plan_item_id,
    :client_id,
    :project_id,
    :master_plan_id,
    :spot_id,
    :medium_id,
    :channel_id,
    :date_id
  attr_accessor :master_plan_item_reality_count

  scope :in_version, lambda{|master_plan_item_id, version| where(master_plan_item_id: master_plan_item_id, version: version)}

  def change_placed_at!(new_placed_at)
    SpotPlanItem.transaction do
      @new_spot_plan_item = SpotPlanItem.create_by_data!({
        master_plan_item_id: self.master_plan_item_id,
        placed_at: new_placed_at,
        count: self.count,
        version: self.version
        })

      self.count = 0
      self.new_spot_plan_item_id = @new_spot_plan_item.id
      self.save!
    end
    @new_spot_plan_item
  end

  def clone_new_version!(version)
    new_version = version + 1
    SpotPlanItem.create_by_data!({
      master_plan_item_id: self.master_plan_item_id,
      placed_at: self.placed_at,
      count: self.count,
      version: new_version
      })
  end

  def as_json(options={})
    item = super(options)
    item['date_token'] = self.placed_at.strftime('%Y%m%d')
    item['day_index'] = self.placed_at.strftime('%d')
    item['placed_at'] = self.placed_at.strftime('%Y-%m-%d')
    item['is_old_spot_plan_item'] = self.new_spot_plan_item && self.master_plan.is_dirty && self.version > 0
    item
  end

  class << self
    def create_by_data!(data)
      SpotPlanItem.transaction do
        @spot_plan_item = SpotPlanItem.find_by_master_plan_item_id_and_placed_at_and_version(data[:master_plan_item_id], data[:placed_at], data[:version])
        if @spot_plan_item
          @spot_plan_item.count += data[:count]
          @spot_plan_item.save!
        else
          @spot_plan_item = SpotPlanItem.create!(data)
        end
        @spot_plan_item.count = nil if @spot_plan_item.count == 0
        @spot_plan_item.save!
      end
      @spot_plan_item
    end
  end

  private

  def copy_mandatory_attributes
    self.client_id = self.master_plan_item.client_id unless self.client_id
    self.project_id = self.master_plan_item.project_id unless self.project_id
    self.spot_id = self.master_plan_item.spot_id unless self.spot_id
    self.medium_id = self.master_plan_item.medium_id unless self.medium_id
    self.channel_id = self.master_plan_item.channel_id unless self.channel_id
    self.master_plan_id = self.master_plan_item.master_plan_id unless self.master_plan_id
  end
end
