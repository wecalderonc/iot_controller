class ScheduleReportSerializer < ActiveModel::Serializer
  attributes  :email,
              :frequency_day,
              :frequency_interval,
              :start_date
end
