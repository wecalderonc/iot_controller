class ThingsQuery

  def self.with_accumulators
    Thing.uplinks.accumulator
      .sort_by{ |accumulator| accumulator.created_at }.reverse
      .group_by{ |accumulator| accumulator.uplink.thing }
  end
end
