class HistoryMasterPlanItem < MasterPlanItem
  def theoritical_medium_net_cost
    0
  end

  def theoritical_company_net_cost
    reality_company_net_cost
  end
end
