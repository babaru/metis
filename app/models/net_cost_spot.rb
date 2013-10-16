class NetCostSpot < Spot
  def medium_discount(client_id)
    return 1
  end

  def company_discount(client_id)
    return 1
  end

  def medium_bonus_ratio(client_id)
    return 0
  end

  def company_bonus_ratio(client_id)
    return 0
  end
end
