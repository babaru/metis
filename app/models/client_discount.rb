class ClientDiscount < ActiveRecord::Base
  belongs_to :client
  belongs_to :website
  attr_accessible :website_discount, :client_id, :website_id, :our_discount, :on_house_rate

  def website_discount_value(options={})
    if options[:percent]
      return (website_discount * 100).to_i if website_discount
    end

    if options[:view]
      return website_discount * 10 if website_discount
    end

    return website_discount if website_discount
    0
  end

  def our_discount_value(options={})
    if options[:percent]
      return (our_discount * 100).to_i if our_discount
    end

    if options[:view]
      return our_discount * 10 if our_discount
    end

    return our_discount if our_discount
    0
  end
end
