require 'rails_helper'

RSpec.describe ModelModifiers do
  include ModelModifiers

  describe "delete_objects_with_property" do
    let(:uplink)         { create(:uplink) }
    let(:thing)          { uplink.thing }
    let(:uplink2)        { create(:uplink, thing: thing)}
    let(:uplink3)        { create(:uplink, thing: thing)}
    let(:uplink4)        { create(:uplink, thing: thing)}
    let(:uplink5)        { create(:uplink, thing: thing)}
    let(:uplink6)        { create(:uplink, thing: thing)}
    let(:accumulator)    { create(:accumulator, uplink: uplink) }
    let(:accumulator2)   { create(:accumulator, uplink: uplink2) }
    let(:accumulator3)   { create(:accumulator, uplink: uplink3) }
    let(:accumulator4)   { create(:accumulator, uplink: uplink4, wrong_consumption: true) }
    let(:accumulator5)   { create(:accumulator, uplink: uplink5, wrong_consumption: true) }
    let(:accumulator6)   { create(:accumulator, uplink: uplink6, wrong_consumption: true) }
    let(:objects)        { { thing => [accumulator, accumulator2, accumulator3, accumulator4, accumulator5, accumulator6] } }
    let(:property)       { :wrong_consumption }


    it "Should return array without the accumulators with wrong_consumption in true" do
      response = delete_objects_with_property!(objects, property)

      expect(response[0]).to include(accumulator)
      expect(response[0]).to include(accumulator2)
      expect(response[0]).to include(accumulator3)
      expect(response[0]).not_to include(accumulator4)
      expect(response[0]).not_to include(accumulator5)
      expect(response[0]).not_to include(accumulator6)
    end
  end
end
