module Validators::Downlinks
  InstantSchema = Dry::Validation.Schema {
    required(:thing_name).filled
  }

  ScheduledSchema = Dry::Validation.Schema {
    required(:value).filled
    required(:input_method).filled
  }

  ReportedSchema = Dry::Validation.Schema {
    required(:thing_name) {filled? && str?}
    required(:type).filled
  }
end
