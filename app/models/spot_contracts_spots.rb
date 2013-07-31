class SpotContractsSpots < ActiveRecord::Base
  belongs_to :spot
  belongs_to :spot_contract
  # attr_accessible :title, :body
end
