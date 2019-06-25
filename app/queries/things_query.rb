class ThingsQuery

  def self.sort_accumulators(thing = Thing)
    thing.uplinks.accumulator
      .sort_by{ |accumulator| accumulator.created_at }
      .group_by{ |accumulator| accumulator.uplink.thing }
  end
end
