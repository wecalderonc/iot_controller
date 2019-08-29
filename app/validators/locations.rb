module Validators::Locations
  CreateSchema = Dry::Validation.Schema do

    configure { config.messages_file = "config/locales/en.yml" }

    required(:thing_name).filled(type?: String)
    optional(:new_thing_name).value(type?: String)
    required(:location).schema do
      required(:name).filled(type?: String, max_size?: 30)
      required(:address).filled(type?: String)
      optional(:latitude).value(type?: Float)
      optional(:longitude).value(type?: Float)

      validate(invalid_latitude: :latitude) do |latitude|
        latitude.present? ? (latitude <= 90 && latitude >= -90) : true
      end

      validate(invalid_longitude: :longitude) do |longitude|
        longitude.present? ? (longitude <= 180 && longitude >= -180) : true
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
      required(:billing_period).filled(type?: String)
      required(:cut_day).filled(type?: Integer, lteq?: 30)
      required(:start_day).filled(type?: Integer, lteq?: 30)
      required(:start_month).filled(type?: Integer, lteq?: 12)
      required(:start_year).filled(type?: Integer)

      validate(invalid_period: :billing_period) do |billing_period|
        ScheduleBilling::VALID_PERIODS.include?(billing_period.to_sym)
      end

      validate(invalid_basic_charge: :basic_charge) do |basic_charge|
        basic_charge >= 0 ? true : false
      end
    end

    required(:schedule_report).schema do
      required(:email).filled(type?: String, format?: User::VALID_EMAIL)
      required(:frequency_day).filled(type?: Integer)
      required(:frequency_interval).filled(type?: String)
      required(:start_day).filled(type?: Integer)
      required(:start_month).filled(type?: Integer)
      required(:start_year).filled(type?: Integer)

      validate(invalid_interval: :frequency_interval) do |frequency_interval|
        ScheduleReport::VALID_INTERVALS.include?(frequency_interval.to_sym)
      end
    end
  end
end
