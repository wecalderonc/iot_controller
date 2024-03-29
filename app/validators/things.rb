module Validators::Things
  GetPricesSchema = Dry::Validation.Schema do
    configure { config.messages_file = "config/locales/en.yml" }

    required(:accumulator).filled(type?: Accumulator)
    required(:unit).filled(type?: Symbol)
  end

  UpdateSchema = Dry::Validation.Schema do
    required(:thing_name).filled(type?: String)
    optional(:name).filled(type?: String)
    optional(:status).filled(type?: String)
    optional(:pac).value(type?: String)
    optional(:company_id).value(type?: Integer)
    optional(:longitude).value(type?: Float)
    optional(:latitude).value(type?: Float)
  end

  CreateSchema = Dry::Validation.Schema do
    required(:name).filled(type?: String)
    required(:status).filled(type?: String)
    required(:pac).value(type?: String)
    required(:company_id).value(type?: Integer)
    required(:longitude).value(type?: Float)
    required(:latitude).value(type?: Float)
  end
end
