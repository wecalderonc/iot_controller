# app/controllers/concerns/locatiton_handler.rb
module LocationHandler

  START_DATE = [:start_day, :start_month, :start_year]
  COUNTRY_STATE_CITY = [:country, :state, :city]

  def create_location_params
    params.permit(
      :thing_name,
      location: (
        Location::REQUIRED_FIELDS << [:latitude, :longitude]
      ),
      country_state_city: (
        COUNTRY_STATE_CITY
      ),
      schedule_billing: (
        ScheduleBilling::REQUIRED_FIELDS << START_DATE
      ),
      schedule_report: (
        ScheduleReport::REQUIRED_FIELDS << START_DATE
      )
    ).to_h.deep_symbolize_keys
  end
end
