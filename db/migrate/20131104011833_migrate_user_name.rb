class MigrateUserName < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.name = user.email
      user.save!
    end
  end

  def down
  end
end
