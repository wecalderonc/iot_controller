module Reports::Accumulators::Index
  _, CsvFormat = Common::TxMasterBuilder.new do
    step :get_accumulators,  with: Reports::Accumulators::GetAccumulators.new
    map  :build_report,      with: Reports::Accumulators::Report.new
  end.Do
end
