  class ThingSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :updated_at, :uplinks

    def uplinks
      self.object.uplinks.map do |uplink|
        {
          id: uplink.id,
          data: uplink.data,
          accumulator: uplink.accumulator,
          alarms: uplink.alarms
        }
      end
    end
end
