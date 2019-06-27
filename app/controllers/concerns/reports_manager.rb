# this concern build manage report response
module ReportsManager

  def show_handler(input)
    thing = Thing.find_by(id: input[:params][:id])
    puts "thing -> #{thing.inspect}"

    if thing.present?
      a = ThingsQuery.new(thing)
      alarms = a.send("sort_#{input[:model].downcase}".to_sym)
      build_response(alarms, input[:model])
    else
      json_response({ errors: "Device not found" }, :not_found)
    end
  end

  private

  def build_response(collection, model)
    if collection.present?
      data =  Things::AlarmsReport.(collection)

      csv_response(data, "Device-#{model}")
    else
      json_response({ errors: "No results found" }, :not_found)
    end
  end
end
