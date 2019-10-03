module Validators::Accumulators
  GetSchema = Dry::Validation.Schema do
    required(:thing_name).filled(type?: String)
  end

  ReportSchema = Dry::Validation.Schema do
    required(:params).schema do
      required(:thing_name).filled(type?: String)
      optional(:date).schema do
        required(:start_date).filled(type?: String)
        required(:end_date).filled(type?: String)
      end
    end
  end
end
