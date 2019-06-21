require 'rails_helper'

RSpec.describe Things::AccumulatorsReport do
  describe "#call" do
    let(:data) { ThingsQuery.with_accumulators }
    let(:result) { subject.(data) }

    it "should return a csv file with thing's accumulators data"do
      create :accumulator
#     puts "acumulador -> #{accumulator.inspect}"
      puts "result -> #{result.inspect}"
     #expect(CSV.open(test_out_file.path).readlines).to eq(
     #  [["20"], ["60"], ["80"]]
     #)
    end
  end
end
