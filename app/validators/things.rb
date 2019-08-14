module Validators::Things
  GetPricesSchema = Dry::Validation.Schema do
    configure { config.messages_file = "config/locales/en.yml" }

    required(:accumulator).filled(type?: Accumulator)
    required(:unit).filled(type?: Symbol)
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
