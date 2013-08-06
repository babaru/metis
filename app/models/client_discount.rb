class ClientDiscount < ActiveRecord::Base
  belongs_to :client
  belongs_to :website
  attr_accessible :discount, :client_id, :website_id

  def discount_value(options={})
    default_options = {
      view: true
    }
    options = options.merge(default_options)

    if options[:percent]
      return (discount * 100).to_i
    end

    if options[:view]
      return discount * 10
    end

    discount
  end
end
