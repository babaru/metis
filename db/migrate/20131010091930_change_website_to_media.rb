class ChangeWebsiteToMedia < ActiveRecord::Migration
  def up
    # add media_id column to spots, spot_categories, channels, channel_groups, master_plan_items, spot_plan_items, client_discounts

    add_column :channel_groups, :media_id, :integer
    add_column :channels, :media_id, :integer
    add_column :spot_categories, :media_id, :integer
    add_column :spots, :media_id, :integer
    add_column :master_plan_items, :media_id, :integer
    add_column :spot_plan_items, :media_id, :integer
    add_column :client_discounts, :media_id, :integer
    rename_column :client_discounts, :website_discount, :media_discount
    rename_column :client_discounts, :website_bonus_ratio, :media_bonus_ratio

    add_index :channel_groups, :media_id
    add_index :channels, :media_id
    add_index :spot_categories, :media_id
    add_index :spots, :media_id
    add_index :master_plan_items, :media_id
    add_index :spot_plan_items, :media_id
    add_index :client_discounts, :media_id

    admin_user = User.first

    # set media_id to new media

    Media.transaction do
      Website.all.each do |website|
        media = Media.create!(name: website.name, url: website.url, created_by_id: admin_user.id)
        website.spots.each do |spot|
          spot.media_id = media.id
          spot.save!
        end

        website.spot_categories.each do |sc|
          sc.media_id = media.id
          sc.save!
        end

        website.channels.each do |channel|
          channel.media_id = media.id
          channel.save!
        end

        website.channel_groups.each do |channel_group|
          channel_group.media_id = media.id
          channel_group.save!
        end

        website.master_plan_items.each do |master_plan_item|
          master_plan_item.media_id = media.id
          master_plan_item.save!
        end

        website.spot_plan_items.each do |spot_plan_item|
          spot_plan_item.media_id = media.id
          spot_plan_item.save!
        end

        website.client_discounts.each do |cd|
          cd.media_id = media.id
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
      Media.all.each do |media|
        website = Website.create!(name: media.name, url: media.url)
        media.spots.each do |spot|
          spot.website_id = website.id
          spot.save!
        end

        media.spot_categories.each do |sc|
          sc.website_id = website.id
          sc.save!
        end

        media.channels.each do |channel|
          channel.website_id = website.id
          channel.save!
        end

        media.channel_groups.each do |channel_group|
          channel_group.website_id = website.id
          channel_group.save!
        end

        media.master_plan_items.each do |master_plan_item|
          master_plan_item.website_id = website.id
          master_plan_item.save!
        end

        media.spot_plan_items.each do |spot_plan_item|
          spot_plan_item.website_id = website.id
          spot_plan_item.save!
        end

        media.client_discounts.each do |cd|
          cd.website_id = website.id
          cd.save!
        end
      end
    end

    remove_index :channel_groups, :media_id
    remove_index :channels, :media_id
    remove_index :spot_categories, :media_id
    remove_index :spots, :media_id
    remove_index :master_plan_items, :media_id
    remove_index :spot_plan_items, :media_id
    remove_index :client_discounts, :media_id

    remove_column :channel_groups, :media_id
    remove_column :channels, :media_id
    remove_column :spot_categories, :media_id
    remove_column :spots, :media_id
    remove_column :master_plan_items, :media_id
    remove_column :spot_plan_items, :media_id
    remove_column :client_discounts, :media_id
  end
end
