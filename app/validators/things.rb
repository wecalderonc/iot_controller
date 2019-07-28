module Validators::Things
  CreateSchema = Dry::Validation.Schema do
    required(:thing).schema do
      required(:name).filled(type?: String)
      required(:status).filled(type?: String)
      required(:pac).value(type?: String)
      required(:company_id).value(type?: Integer)
      required(:longitude).value(type?: Float)
      required(:latitude).value(type?: Float)
    end
  end

  GetPricesSchema = Dry::Validation.Schema do
    required(:thing).filled(type?: Thing)
    required(:unit).filled(type?: Symbol)
    required(:currency).value(type?: String)
  end

  UpdateSchema = Dry::Validation.Schema do
    optional(:name).filled(type?: String)
    optional(:status).filled(type?: String)
    optional(:pac).value(type?: String)
    optional(:company_id).value(type?: Integer)
    optional(:longitude).value(type?: Float)
    optional(:latitude).value(type?: Float)
  end


end
