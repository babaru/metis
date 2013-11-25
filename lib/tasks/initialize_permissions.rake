namespace :db do
  task :initialize_permissions => :environment do
    ActiveRecord::Base.connection.execute('TRUNCATE permissions')
    ActiveRecord::Base.connection.execute('TRUNCATE permission_groups')
    ActiveRecord::Base.connection.execute('TRUNCATE permission_group_permissions')
    ActiveRecord::Base.connection.execute('TRUNCATE user_permissions')

    ActiveRecord::Base.transaction do

      # Space
      # ------------------------------------------------------------------------

      create_space = Permission.create!({
        action: 'create',
        subject_class: 'Space'
      })

      read_space = Permission.create!({
        action: 'read',
        subject_class: 'Space'
      })

      update_space = Permission.create!({
        action: 'update',
        subject_class: 'Space'
      })

      destroy_space = Permission.create!({
        action: 'destroy',
        subject_class: 'Space'
      })

      crud_space = [create_space, read_space, update_space, destroy_space]

      # Department
      # ------------------------------------------------------------------------

      create_department = Permission.create!({
        action: 'create',
        subject_class: 'Department'
      })

      read_department = Permission.create!({
        action: 'read',
        subject_class: 'Department'
      })

      update_department = Permission.create!({
        action: 'update',
        subject_class: 'Department'
      })

      destroy_department = Permission.create!({
        action: 'destroy',
        subject_class: 'Department'
      })

      crud_department = [create_department, read_department, update_department, destroy_department]

      # Client
      # ------------------------------------------------------------------------

      create_client = Permission.create!({
        action: 'create',
        subject_class: 'Client'
      })

      read_client = Permission.create!({
        action: 'read',
        subject_class: 'Client'
      })

      update_client = Permission.create!({
        action: 'update',
        subject_class: 'Client'
      })

      destroy_client = Permission.create!({
        action: 'destroy',
        subject_class: 'Client'
      })

      crud_client = [create_client, read_client, update_client, destroy_client]

      # Project
      # ------------------------------------------------------------------------

      create_project = Permission.create!({
        action: 'create',
        subject_class: 'Project'
      })

      read_project = Permission.create!({
        action: 'read',
        subject_class: 'Project'
      })

      update_project = Permission.create!({
        action: 'update',
        subject_class: 'Project'
      })

      destroy_project = Permission.create!({
        action: 'destroy',
        subject_class: 'Project'
      })

      crud_project = [create_project, read_project, update_project, destroy_project]

      # Payment
      # ------------------------------------------------------------------------

      create_payment = Permission.create!({
        action: 'create',
        subject_class: 'Payment'
      })

      read_payment = Permission.create!({
        action: 'read',
        subject_class: 'Payment'
      })

      update_payment = Permission.create!({
        action: 'update',
        subject_class: 'Payment'
      })

      destroy_payment = Permission.create!({
        action: 'destroy',
        subject_class: 'Payment'
      })

      crud_payment = [create_payment, read_payment, update_payment, destroy_payment]

      # PaymentInvoice
      # ------------------------------------------------------------------------

      create_payment_invoice = Permission.create!({
        action: 'create',
        subject_class: 'PaymentInvoice'
      })

      read_payment_invoice = Permission.create!({
        action: 'read',
        subject_class: 'PaymentInvoice'
      })

      update_payment_invoice = Permission.create!({
        action: 'update',
        subject_class: 'PaymentInvoice'
      })

      destroy_payment_invoice = Permission.create!({
        action: 'destroy',
        subject_class: 'PaymentInvoice'
      })

      crud_payment_invoice = [create_payment_invoice, read_payment_invoice, update_payment_invoice, destroy_payment_invoice]

      # Collection
      # ------------------------------------------------------------------------

      create_collection = Permission.create!({
        action: 'create',
        subject_class: 'Collection'
      })

      read_collection = Permission.create!({
        action: 'read',
        subject_class: 'Collection'
      })

      update_collection = Permission.create!({
        action: 'update',
        subject_class: 'Collection'
      })

      destroy_collection = Permission.create!({
        action: 'destroy',
        subject_class: 'Collection'
      })

      crud_collection = [create_collection, read_collection, update_collection, destroy_collection]

      # CollectionInvoice
      # ------------------------------------------------------------------------

      create_collection_invoice = Permission.create!({
        action: 'create',
        subject_class: 'CollectionInvoice'
      })

      read_collection_invoice = Permission.create!({
        action: 'read',
        subject_class: 'CollectionInvoice'
      })

      update_collection_invoice = Permission.create!({
        action: 'update',
        subject_class: 'CollectionInvoice'
      })

      destroy_collection_invoice = Permission.create!({
        action: 'destroy',
        subject_class: 'CollectionInvoice'
      })

      crud_collection_invoice = [create_collection_invoice, read_collection_invoice, update_collection_invoice, destroy_collection_invoice]

      # Agency
      # ------------------------------------------------------------------------

      create_agency = Permission.create!({
        action: 'create',
        subject_class: 'Agency'
      })

      read_agency = Permission.create!({
        action: 'read',
        subject_class: 'Agency'
      })

      update_agency = Permission.create!({
        action: 'update',
        subject_class: 'Agency'
      })

      destroy_agency = Permission.create!({
        action: 'destroy',
        subject_class: 'Agency'
      })

      crud_agency = [create_agency, read_agency, update_agency, destroy_agency]

      # Vendor
      # ------------------------------------------------------------------------

      create_vendor = Permission.create!({
        action: 'create',
        subject_class: 'Vendor'
      })

      read_vendor = Permission.create!({
        action: 'read',
        subject_class: 'Vendor'
      })

      update_vendor = Permission.create!({
        action: 'update',
        subject_class: 'Vendor'
      })

      destroy_vendor = Permission.create!({
        action: 'destroy',
        subject_class: 'Vendor'
      })

      crud_vendor = [create_vendor, read_vendor, update_vendor, destroy_vendor]

      # Medium
      # ------------------------------------------------------------------------

      create_medium = Permission.create!({
        action: 'create',
        subject_class: 'Medium'
      })

      read_medium = Permission.create!({
        action: 'read',
        subject_class: 'Medium'
      })

      update_medium = Permission.create!({
        action: 'update',
        subject_class: 'Medium'
      })

      destroy_medium = Permission.create!({
        action: 'destroy',
        subject_class: 'Medium'
      })

      crud_medium = [create_medium, read_medium, update_medium, destroy_medium]

      # User
      # ------------------------------------------------------------------------

      create_user = Permission.create!({
        action: 'create',
        subject_class: 'User'
      })

      read_user = Permission.create!({
        action: 'read',
        subject_class: 'User'
      })

      update_user = Permission.create!({
        action: 'update',
        subject_class: 'User'
      })

      destroy_user = Permission.create!({
        action: 'destroy',
        subject_class: 'User'
      })

      crud_user = [create_user, read_user, update_user, destroy_user]

      # Permission
      # ------------------------------------------------------------------------

      create_permission = Permission.create!({
        action: 'create',
        subject_class: 'Permission'
      })

      read_permission = Permission.create!({
        action: 'read',
        subject_class: 'Permission'
      })

      update_permission = Permission.create!({
        action: 'update',
        subject_class: 'Permission'
      })

      destroy_permission = Permission.create!({
        action: 'destroy',
        subject_class: 'Permission'
      })

      crud_permission = [create_permission, read_permission, update_permission, destroy_permission]

      # PermissionGroup
      # ------------------------------------------------------------------------

      create_permission_group = Permission.create!({
        action: 'create',
        subject_class: 'PermissionGroup'
      })

      read_permission_group = Permission.create!({
        action: 'read',
        subject_class: 'PermissionGroup'
      })

      update_permission_group = Permission.create!({
        action: 'update',
        subject_class: 'PermissionGroup'
      })

      destroy_permission_group = Permission.create!({
        action: 'destroy',
        subject_class: 'PermissionGroup'
      })

      crud_permission_group = [create_permission_group, read_permission_group, update_permission_group, destroy_permission_group]

      # PermissionGroupPermission
      # ------------------------------------------------------------------------

      create_permission_group_permission = Permission.create!({
        action: 'create',
        subject_class: 'PermissionGroupPermission'
      })

      read_permission_group_permission = Permission.create!({
        action: 'read',
        subject_class: 'PermissionGroupPermission'
      })

      update_permission_group_permission = Permission.create!({
        action: 'update',
        subject_class: 'PermissionGroupPermission'
      })

      destroy_permission_group_permission = Permission.create!({
        action: 'destroy',
        subject_class: 'PermissionGroupPermission'
      })

      crud_permission_group_permission = [create_permission_group_permission, read_permission_group_permission, update_permission_group_permission, destroy_permission_group_permission]

      crud_system_permission = [crud_permission, crud_permission_group, crud_permission_group_permission].flatten

      # DepartmentPermission
      # ------------------------------------------------------------------------

      create_department_permission = Permission.create!({
        action: 'create',
        subject_class: 'DepartmentPermission'
      })

      read_department_permission = Permission.create!({
        action: 'read',
        subject_class: 'DepartmentPermission'
      })

      update_department_permission = Permission.create!({
        action: 'update',
        subject_class: 'DepartmentPermission'
      })

      destroy_department_permission = Permission.create!({
        action: 'destroy',
        subject_class: 'DepartmentPermission'
      })

      crud_department_permission = [create_department_permission, read_department_permission, update_department_permission, destroy_department_permission]

      # UserPermission
      # ------------------------------------------------------------------------

      create_user_permission = Permission.create!({
        action: 'create',
        subject_class: 'UserPermission'
      })

      read_user_permission = Permission.create!({
        action: 'read',
        subject_class: 'UserPermission'
      })

      update_user_permission = Permission.create!({
        action: 'update',
        subject_class: 'UserPermission'
      })

      destroy_user_permission = Permission.create!({
        action: 'destroy',
        subject_class: 'UserPermission'
      })

      crud_user_permission = [create_user_permission, read_user_permission, update_user_permission, destroy_user_permission]

      # ========================================================================
      # Permission Groups
      # ========================================================================

      # System Administrator

      pg_sys_admin = PermissionGroup.create!({name: '系统管理员'})

      [
        crud_space,
        crud_department,
        crud_user,
        crud_system_permission,
        crud_department_permission,
        crud_user_permission
      ].flatten.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_sys_admin,
          permission: permission
        })
      end

      # Space Department Administrator

      pg_space_department_admin = PermissionGroup.create!({name: '部门管理员'})

      crud_department.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_department_admin,
          permission: permission
        })
      end

      crud_department_permission.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_department_admin,
          permission: permission
        })
      end

      # Space User Administrator

      pg_space_user_admin = PermissionGroup.create!({name: '成员管理员'})

      crud_user.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_user_admin,
          permission: permission
        })
      end

      crud_user_permission.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_user_admin,
          permission: permission
        })
      end

      # Space Client Administrator

      pg_space_client_admin = PermissionGroup.create!({name: '客户管理员'})

      crud_client.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_client_admin,
          permission: permission
        })
      end

      # Space Project Administrator

      pg_space_project_admin = PermissionGroup.create!({name: '项目管理员'})

      crud_project.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_project_admin,
          permission: permission
        })
      end

      # Space Agency Administrator

      pg_space_agency_admin = PermissionGroup.create!({name: '代理商管理员'})

      crud_agency.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_agency_admin,
          permission: permission
        })
      end

      # Space Vendor Administrator

      pg_space_vendor_admin = PermissionGroup.create!({name: '供应商管理员'})

      crud_vendor.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_space_vendor_admin,
          permission: permission
        })
      end

      # Medium Administrator

      pg_medium_admin = PermissionGroup.create!({name: '媒介数据维护员'})

      crud_medium.each do |permission|
        PermissionGroupPermission.create!({
          permission_group: pg_medium_admin,
          permission: permission
        })
      end
    end
  end
end
