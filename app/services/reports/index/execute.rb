module Reports::Index
  _, BaseTx = Common::TxMasterBuilder.new do
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
        build_report: Reports::BaseJsonReport.new
      ),
      alarm: BaseTx.new(
        build_report: Reports::BaseJsonReport.new
      )
    }
  }

  Execute = -> input { Options[input[:option]][input[:model]].(input) }
end
