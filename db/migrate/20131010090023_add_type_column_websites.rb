class AddTypeColumnWebsites < ActiveRecord::Migration
  def up
    add_column :websites, :type, :string

    Website.all.each do |website|
      website.type = Website.name
      website.save!
    end
  end

  def down
    remove_column :websites, :type
  end
end
