module Tida
  module Metis
    class InvoiceType < ::Settingslogic
      source "#{Rails.root}/config/enums/invoice_types.yml"
      namespace Rails.env
    end
  end
end
