module ExceptionHandler
  extend ActiveSupport::Concern

  def create_location_params
    params.permit(
      :thing_name,
      location: {
        Location::REQUIRED_FIELDS << [:latitude, :longitude]
      },
      country_state_city: {
        :country,
        :state,
        :city
      },
      schedule_billing: {
        :stratum,
        :basic_charge,
        :top_limit,
        :basic_price,
        :extra_price,
        :billing_frequency,
        :billing_period,
        :cut_day,
        :start_day,
        :start_month,
        :start_year
      },
      schedule_report: {
        :email,
        :frequency_day,
        :frequency_interval,
        :start_day,
        :start_month,
        :start_year
      }
    ).to_h.symbolize_keys
  end
end
