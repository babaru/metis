class ComboMediumMasterPlan < MediumMasterPlan

  def medium_net_cost
    return reality_medium_net_cost if reality_medium_net_cost
    super
  end

  def company_net_cost
    return reality_company_net_cost if reality_company_net_cost
    super
  end

  def medium_discount
    return reality_medium_discount if reality_medium_discount
    super
  end

  def company_discount
    return reality_company_discount if reality_company_discount
    super
  end

  def is_combo?
    true
  end

end
