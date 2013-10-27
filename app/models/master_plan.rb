class MasterPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :items, class_name: 'MasterPlanItem', dependent: :destroy
  has_many :medium_master_plans, dependent: :destroy

  attr_accessible :name,
    :project_id,
    :project_name,
    :created_by_id,
    :created_by_name,
    :client_id,
    :client_name,
    :is_dirty,
    :is_readonly,
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

  def working_version
    result = MasterPlan.connection.select_all("select max(version) as working_version from spot_plan_items where master_plan_id=#{id}")
    return result[0]['working_version'] if result.length > 0 && result[0]['working_version']
    0
  end

  def save_version!
    working_version = self.working_version
    MasterPlan.transaction do
      spot_plan_items = SpotPlanItem.where('master_plan_id=? and version=? and count>0', self.id, working_version)
      spot_plan_items.each {|item| item.copy_to_new_version!(working_version + 1)}
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
end
