class AddNameUsers < ActiveRecord::Migration
  def up
    add_column :users, :name, :string

    User.all.each do |user|
      user.name = user.email
      user.save
    end
  end

  def down
    remove_column :users, :name
  end
end
