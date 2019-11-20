class ThingsQuery

  def initialize(thing = Thing)
    @thing = thing
  end

  def sort_accumulators
    sort_collection(@thing.uplinks.accumulator)
  end

  def sort_alarms
    sort_collection(@thing.uplinks.alarm)
  end

  def date_uplinks_filter(date, model)
    start_date, end_date = date.values_at(:start_date, :end_date)

    sort_collection(
      @thing.uplinks(:u)
      .where("u.time >= {start_date} and u.time <= {end_date}")
      .params(start_date: start_date, end_date: end_date)
      .send(model)
    )
  end

  private

  def sort_collection(collection)
    collection
      .sort_by{ |accumulator| accumulator.uplink.time }
      .group_by{ |accumulator| accumulator.uplink.thing }
  end
end
