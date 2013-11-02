class SpotPlanItem < ActiveRecord::Base
  belongs_to :master_plan_item
  belongs_to :new_spot_plan_item, class_name: 'SpotPlanItem', foreign_key: :new_spot_plan_item_id
  has_one :spot_plan_item

  attr_accessible :count,
    :placed_at,
    :master_plan_item_id,
    :version,
    :new_spot_plan_item_id,
    :date_id

  scope :in_version, lambda{|master_plan_item_id, version| where(master_plan_item_id: master_plan_item_id, version: version)}

  def easy_id
    "SPI_#{self.master_plan_item_id}_#{self.placed_at.strftime('%Y%m%d')}"
  end

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
    item['master_plan_item_reality_count'] = self.master_plan_item.reality_count(self.version)
    item['placed_at'] = self.placed_at.strftime('%Y-%m-%d')
    item['easy_id'] = self.easy_id
    item['is_old_spot_plan_item'] = self.new_spot_plan_item && self.master_plan_item.master_plan.is_dirty && self.version > 0
    item
  end

  class << self
    def create_by_data!(data)
      SpotPlanItem.transaction do
        @spot_plan_item = SpotPlanItem.find_by_master_plan_item_id_and_placed_at_and_version(data[:master_plan_item_id], data[:placed_at], data[:version])
        if @spot_plan_item
          @spot_plan_item.count += data[:count].to_i
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
end
