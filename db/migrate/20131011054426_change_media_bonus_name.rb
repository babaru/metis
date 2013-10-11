class ChangeMediaBonusName < ActiveRecord::Migration
  def up
    rename_column :client_discounts, :media_bonus_ratio, :medium_bonus_ratio
    rename_column :client_discounts, :media_discount, :medium_discount
  end

  def down
    rename_column :client_discounts, :medium_bonus_ratio, :media_bonus_ratio
    rename_column :client_discounts, :medium_discount, :media_discount
  end
end
