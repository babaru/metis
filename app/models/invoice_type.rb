class InvoiceType
  class << self
    def invoice_types
      ::Tida::Metis::InvoiceType.invoice_types.map{ |k,v| [I18n.t("invoice_types.#{k}"),v] }
    end

    def invoice_type_names
      Hash[::Tida::Metis::InvoiceType.invoice_types.map{ |k, v| [v, I18n.t("invoice_types.#{k}")]}]
    end
  end
end
