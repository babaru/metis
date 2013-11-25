class Permission < ActiveRecord::Base
  attr_accessible :action, :subject_class, :subject_id

  def name
    I18n.t("model.#{self.action}", model: self.subject_class.constantize.model_name.human)
  end
end
