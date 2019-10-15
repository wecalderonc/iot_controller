module Reports::Show

  ParseInput = -> input do
    input.merge!(thing_name: input[:params][:thing_name])
  end

  _, BaseTx = Common::TxMasterBuilder.new do
    step :validation,         with: Common::Operations::Validator.(:get, :accumulators_report)
    map  :parse_input,        with: ParseInput
    step :get_thing,          with: Things::Get.new
    step :get_objects,        with: Reports::GetObjects.new
    step :get_location,       with: -> input { Dry::Monads::Result::Success.new(input)  }
    map  :dates_calculator,   with: -> input { input }
    map  :periods_calculator, with: -> input { input }
    map  :build_report,       with: Reports::Accumulators::CsvReport.new
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
        get_location: Locations::GetLocation.new,
        dates_calculator: Reports::DatesCalculator.new,
        periods_calculator: Reports::Accumulators::HistoricalCalculator.new,
        build_report: Reports::Accumulators::JsonReport.new
      ),
      alarm: BaseTx.new(
        build_report: Reports::BaseJsonReport.new
     )
    }
  }

  Execute = -> input do
    Options[input[:option]][input[:model]].(input)
  end
end
