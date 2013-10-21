class AddUserIdAndProjectIdShoppingCarts < ActiveRecord::Migration
  def up
    add_column :shopping_carts, :master_plan_id, :integer
    add_column :shopping_carts, :user_id, :integer
    add_index :shopping_carts, :master_plan_id
    add_index :shopping_carts, :user_id
  end

  def down
    remove_column :shopping_carts, :master_plan_id
    remove_column :shopping_carts, :user_id
  end
end
