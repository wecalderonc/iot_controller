module Reports::Index
  _, BaseTx = Common::TxMasterBuilder.new do
    step :get_accumulators,  with: Reports::GetAccumulators.new
    map  :build_report,      with: Reports::Accumulators::CsvReport.new
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

  Execute = -> input { Options[input[:option]][input[:model]].(input) }
end
