module Reports::Show

  ParseInput = -> input do
    input.merge!(thing_name: input[:params][:thing_name])
  end

  _, BaseTx = Common::TxMasterBuilder.new do
    step :validation,   with: Common::Operations::Validator.(:get, :accumulators_report)
    map  :parse_input,  with: ParseInput
    step :get_thing,    with: Things::Get.new
    step :get_objects,  with: Reports::GetObjects.new
    map  :build_report, with: Reports::Accumulators::CsvReport.new
  end.Do

  Options = {
    csv_format: {
      accumulator: BaseTx.new,
      alarm:       BaseTx.new(
        build_report: Reports::Alarms::CsvReport.new
      )
    },
    json_format: {
      accumulator: BaseTx.new(
        build_report: Reports::Accumulators::JsonReport.new
      ),
      alarm: BaseTx.new(
        build_report: Reports::Alarms::JsonReport.new
      )
    }
  }

  Execute = -> input { puts "input -> #{input.inspect}"; Options[input[:option]][input[:model]].(input) }
end
