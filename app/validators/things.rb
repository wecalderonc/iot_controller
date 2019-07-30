module Validators::Things
  GetPricesSchema = Dry::Validation.Schema do
    configure { config.messages_file = "config/locales/en.yml" }

    required(:thing).filled(type?: Thing)
    required(:unit).filled(type?: Symbol)
    required(:currency).value(type?: String)

    validate(valid_currency: :currency) do |currency|
      Price::CURRENCIES.include?(currency)
    end
  end

  UpdateSchema = Dry::Validation.Schema do
    required(:thing_name)
    required(:params).schema do
      optional(:name).filled(type?: String)
      optional(:status).filled(type?: String)
      optional(:pac).value(type?: String)
      optional(:company_id).value(type?: Integer)
      optional(:longitude).value(type?: Float)
      optional(:latitude).value(type?: Float)
    end
  end
end
