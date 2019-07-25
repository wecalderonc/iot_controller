module Validators::Things
  CreateSchema = Dry::Validation.Schema do
    required(:thing).schema do
      required(:name).filled(type?: String)
      required(:status).filled(type?: String)
      required(:pac).value(type?: String)
      required(:company_id).value(type?: Integer)
      required(:coordinates).value(:array?, size?: 2)
      required(:coordinates).each(:float?)
    end
  end

  GetPricesSchema = Dry::Validation.Schema do
    required(:thing).filled(type?: Thing)
    required(:unit).filled(type?: Symbol)
    required(:currency).value(type?: String)
  end
end
