class PermissionGroupPermission < ActiveRecord::Base
  belongs_to :permission_group
  belongs_to :permission
  attr_accessible :permission_group, :permission
end
