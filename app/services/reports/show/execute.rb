module Reports::Show
  _, BaseTx = Common::TxMasterBuilder.new do
    step :validation,       with: Common::Operations::Validator.(:get, :accumulator)
    step :get_thing,        with: Things::Get.new
    step :get_accumulators, with: Reports::GetAccumulators.new
    map  :build_report,     with: Reports::Accumulators::JsonReport.new
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
