class MasterPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :items, class_name: 'MasterPlanItem', dependent: :destroy
  has_many :medium_master_plans, dependent: :destroy

  before_create :set_name, :copy_name_attributes

  attr_accessible :name,
    :project_id,
    :project_name,
    :created_by_id,
    :created_by_name,
    :client_id,
    :client_name,
    :is_dirty,
    :is_readonly,
    :spot_plan_version,
    :reality_medium_net_cost,
    :reality_company_net_cost

  def medium_master_plan(medium_id)
    medium_master_plans.where(medium_id: medium_id).first
  end

  def medium_net_cost
    medium_master_plans.inject(0) {|sum, item| sum += item.medium_net_cost }
  end

  def company_net_cost
    medium_master_plans.inject(0) {|sum, item| sum += item.company_net_cost }
  end

  def profit
    company_net_cost - medium_net_cost
  end

  def spots_count(medium_id = nil)
    return self.items.count unless medium_id
    self.items.where('medium_id=?', medium_id).count
  end

  def confirm!
    MasterPlan.transaction do
      spot_plan_items = SpotPlanItem.where('master_plan_id=? and version=?', self.id, self.spot_plan_version)
      spot_plan_items.each {|item| item.clone_new_version!(self.spot_plan_version)}
      self.spot_plan_version += 1
      self.is_dirty = false
      self.save!
    end
  end

  def import_from_excel(excel_file)
    Tida::ExcelParsers::MasterPlanParser.parse excel_file
  end

  def as_json(options={})
    item = super(options)
    item[:budget] = self.project.budget
    item[:medium_net_cost] = self.medium_net_cost
    item[:company_net_cost] = self.company_net_cost
    item[:profit] = self.profit
    item
  end

  class << self

  def create_by_data!(data, user)
    data[:created_by_id] = user.id
    MasterPlan.create!(data)
  end

  end

  def clone(user)
    MasterPlan.transaction do
      @master_plan = MasterPlan.create_by_data!({
        client_id: client_id,
        project_id: project_id,
        is_dirty: is_dirty,
        is_readonly: is_readonly
        }, user)
      self.medium_master_plans.each do |medium_master_plan|
        new_mmp = MediumMasterPlan.create_by_data!({
          master_plan_id: @master_plan.id,
          medium_id: medium_master_plan.medium_id,
          is_combo: medium_master_plan.is_combo?
          })

        medium_master_plan.master_plan_items.each do |item|
          new_item = MasterPlanItem.create_by_data!({
            client_id: @master_plan.client_id,
            project_id: @master_plan.project_id,
            master_plan_id: @master_plan.id,
            medium_id: new_mmp.medium_id,
            channel_id: item.channel_id,
            medium_master_plan_id: new_mmp.id,
            spot_id: item.spot_id,
            count: item.count,
            is_on_house: item.is_on_house
            })
        end
      end
    end
    @master_plan
  end

  private

  def set_name
    self.name = Time.now.strftime('%Y年%m月%d日 %H:%M:%S') unless self.name
    logger.debug "Set name: #{self.name}"
  end

  def copy_name_attributes
    self.client_name = client.name unless self.client_name
    self.project_name = project.name unless self.project_name
    self.created_by_name = created_by.name unless self.created_by_name
  end
end
