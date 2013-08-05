class Role < ActiveRecord::Base
  attr_accessible :name
  has_many :role_assignments
  has_many :users, through: :role_assignments

  def i18n_name
    I18n.t("roles.#{self.name.underscore}")
  end
end
