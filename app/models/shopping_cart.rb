class ShoppingCart < ActiveRecord::Base
  acts_as_shopping_cart

  belongs_to :master_plan
  belongs_to :user

  attr_accessible :master_plan_id, :user_id

  def taxes
    0
  end

  def shipping_cost
    0
  end

  def self.default_cart(user_id, master_plan_id)
    cart = ShoppingCart.find_by_user_id_and_master_plan_id(user_id, master_plan_id)
    unless cart
      cart = ShoppingCart.create({
        user_id: user_id,
        master_plan_id: master_plan_id
        })
    end
    cart
  end
end
