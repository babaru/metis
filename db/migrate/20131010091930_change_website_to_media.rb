class ChangeWebsiteToMedia < ActiveRecord::Migration
  def up
    # add medium_id column to spots, spot_categories, channels, channel_groups, master_plan_items, spot_plan_items, client_discounts

    add_column :channel_groups, :medium_id, :integer
    add_column :channels, :medium_id, :integer
    add_column :spot_categories, :medium_id, :integer
    add_column :spots, :medium_id, :integer
    add_column :master_plan_items, :medium_id, :integer
    add_column :spot_plan_items, :medium_id, :integer
    add_column :client_discounts, :medium_id, :integer
    rename_column :client_discounts, :website_discount, :media_discount
    rename_column :client_discounts, :website_bonus_ratio, :media_bonus_ratio

    add_index :channel_groups, :medium_id
    add_index :channels, :medium_id
    add_index :spot_categories, :medium_id
    add_index :spots, :medium_id
    add_index :master_plan_items, :medium_id
    add_index :spot_plan_items, :medium_id
    add_index :client_discounts, :medium_id

    admin_user = User.first

    # set medium_id to new medium

    Medium.transaction do
      Website.all.each do |website|
        medium = Medium.create!(name: website.name, url: website.url, created_by_id: admin_user.id)
        website.spots.each do |spot|
          spot.medium_id = medium.id
          spot.save!
        end

        website.spot_categories.each do |sc|
          sc.medium_id = medium.id
          sc.save!
        end

        website.channels.each do |channel|
          channel.medium_id = medium.id
          channel.save!
        end

        website.channel_groups.each do |channel_group|
          channel_group.medium_id = medium.id
          channel_group.save!
        end

        website.master_plan_items.each do |master_plan_item|
          master_plan_item.medium_id = medium.id
          master_plan_item.save!
        end

        website.spot_plan_items.each do |spot_plan_item|
          spot_plan_item.medium_id = medium.id
          spot_plan_item.save!
        end

        website.client_discounts.each do |cd|
          cd.medium_id = medium.id
          cd.save!
        end
      end
    end

    remove_index :channel_groups, :website_id
    remove_index :channels, :website_id
    remove_index :spot_categories, :website_id
    remove_index :spots, :website_id
    remove_index :master_plan_items, :website_id
    remove_index :spot_plan_items, :website_id
    remove_index :client_discounts, :website_id

    remove_column :channel_groups, :website_id
    remove_column :channels, :website_id
    remove_column :spot_categories, :website_id
    remove_column :spots, :website_id
    remove_column :master_plan_items, :website_id
    remove_column :spot_plan_items, :website_id
    remove_column :client_discounts, :website_id
  end

  def down
    add_column :channel_groups, :website_id, :integer
    add_column :channels, :website_id, :integer
    add_column :spot_categories, :website_id, :integer
    add_column :spots, :website_id, :integer
    add_column :master_plan_items, :website_id, :integer
    add_column :spot_plan_items, :website_id, :integer
    add_column :client_discounts, :website_id, :integer
    rename_column :client_discounts, :media_discount, :website_discount
    rename_column :client_discounts, :media_bonus_ratio, :website_bonus_ratio

    add_index :channel_groups, :website_id
    add_index :channels, :website_id
    add_index :spot_categories, :website_id
    add_index :spots, :website_id
    add_index :master_plan_items, :website_id
    add_index :spot_plan_items, :website_id
    add_index :client_discounts, :website_id

    ActiveRecord::Base.transaction do
      Medium.all.each do |medium|
        website = Website.create!(name: medium.name, url: medium.url)
        medium.spots.each do |spot|
          spot.website_id = website.id
          spot.save!
        end

        medium.spot_categories.each do |sc|
          sc.website_id = website.id
          sc.save!
        end

        medium.channels.each do |channel|
          channel.website_id = website.id
          channel.save!
        end

        medium.channel_groups.each do |channel_group|
          channel_group.website_id = website.id
          channel_group.save!
        end

        medium.master_plan_items.each do |master_plan_item|
          master_plan_item.website_id = website.id
          master_plan_item.save!
        end

        medium.spot_plan_items.each do |spot_plan_item|
          spot_plan_item.website_id = website.id
          spot_plan_item.save!
        end

        medium.client_discounts.each do |cd|
          cd.website_id = website.id
          cd.save!
        end
      end
    end

    remove_index :channel_groups, :medium_id
    remove_index :channels, :medium_id
    remove_index :spot_categories, :medium_id
    remove_index :spots, :medium_id
    remove_index :master_plan_items, :medium_id
    remove_index :spot_plan_items, :medium_id
    remove_index :client_discounts, :medium_id

    remove_column :channel_groups, :medium_id
    remove_column :channels, :medium_id
    remove_column :spot_categories, :medium_id
    remove_column :spots, :medium_id
    remove_column :master_plan_items, :medium_id
    remove_column :spot_plan_items, :medium_id
    remove_column :client_discounts, :medium_id
  end
end
