# This service returns all alarms of a thing
module Things
  class AlarmsIndex

    def index
      thing = Thing.find_by(name: params[:thing_name])
      alarms = thing.uplinks.inject([]) do |array, uplink|
        array << uplink.alarm
     end
      json_response(alarms)
    end
  end
end
