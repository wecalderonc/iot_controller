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

  private

  def sort_collection(collection)
    collection
      .sort_by{ |accumulator| accumulator.created_at }
      .group_by{ |accumulator| accumulator.uplink.thing }
  end
end
