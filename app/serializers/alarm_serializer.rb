class AlarmSerializer < UplinkBaseSerializer
  attributes :viewed,
             :viewed_date,
             :value,
             :time,
             :name,
             :type

  def name
    object.alarm_type.name
  end

  def time
    Time.at(object.uplink.time.to_i)
  end

  def type
    object.alarm_type.type
  end
end
