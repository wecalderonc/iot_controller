module Validators::Locations
  CreateSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

    required(:thing_name).filled(type?: String)
    required(:location).schema do
      required(:name).filled(type?: String, max_size?: 30)
      required(:address).filled(type?: String)
      optional(:latitude).filled(type?: Float)
      optional(:longitude).filled(type?: Float)

      validate(invalid_latitude: :latitude) do |latitude|
        false
        (latitude > 90 or latitude < -90) ? false : true
      end

      validate(invalid_longitude: :longitude) do |longitude|
        (longitude > 180 or longitude < -180) ? false : true
      end
    end
    required(:country_state_city).schema do
      required(:country).filled(type?: String)
      required(:state).filled(type?: String, max_size?: 50)
      required(:city).filled(type?: String, max_size?: 50)
    end
    required(:schedule_billing).schema do
      optional(:stratum).filled(type?: Integer)
      required(:basic_charge).filled(type?: Float)
      required(:top_limit).filled(type?: Float)
      required(:basic_price).filled(type?: Float)
      required(:extra_price).filled(type?: Float)
      required(:billing_frequency).filled(type?: Integer)
      required(:billing_period).value(type?: Symbol, included_in?: ScheduleBilling::VALID_PERIODS)
      required(:cut_day).filled(type?: Integer, lteq?: 30)
      required(:start_day).filled(type?: Integer, lteq?: 30)
      required(:start_month).filled(type?: Integer, lteq?: 12)
      required(:start_year).filled(type?: Integer)

      validate(invalid_basic_charge: :basic_charge) do |basic_charge|
        basic_charge >= 0 ? true : false
      end
    end
    required(:schedule_report).schema do
      required(:email).filled(type?: String, format?: User::VALID_EMAIL)
      required(:frequency_day).filled(type?: String)
      required(:frequency_interval).filled(type?: Symbol, included_in?: ScheduleReport::VALID_INTERVALS)
      required(:start_day).filled(type?: Integer)
      required(:start_month).filled(type?: Integer)
      required(:start_year).filled(type?: Integer)
    end
  end
end
