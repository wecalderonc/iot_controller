require 'rails_helper'
RSpec.describe Api::V1::AccumulatorsController, :type => :request do
  let(:user)           { create(:user) }
  let(:thing)          { create(:thing, units: { "liter": 200 }) }
  let(:uplink)         { create(:uplink, thing: thing) }
  let!(:accumulator)   { create(:accumulator, value: 'BB', uplink: uplink) }
  let!(:accumulator2)  { create(:accumulator, value: 'AA', uplink: uplink) }
  let!(:price)         { create(:price) }
  let(:header)         { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index accumulators" do

    context "There is one thing with their accumulators" do
      it "Should return an array with all accumulatots of a one thing" do
        Owner.create(from_node: user, to_node: thing)

        get "/api/v1/things/#{thing.name}/accumulators", headers: header
#p thing
#p thing.units# -> Me permite ver los liter, pero cuando lo solicito en el expected response trae el dato como nil
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "id" => accumulator.id,
            "value" => accumulator.value,
            "units_count" => 759220.0,
            "final_price" => 1496,
            "created_at" => JSON.parse(accumulator.created_at.to_json),
            "updated_at" => JSON.parse(accumulator.updated_at.to_json)
          }, {
            "id" => accumulator2.id,
            "value" => accumulator2.value,
            "units_count" => 0,
            "final_price" => 0,
            "created_at" => JSON.parse(accumulator2.created_at.to_json),
            "updated_at" => JSON.parse(accumulator2.updated_at.to_json)
          }
        ]
        expect(body).to match_array(expected_response)
      end
    end

   context "Thing name don't exist" do
     it "Should return a message thing does not exist" do
       Owner.create(from_node: user, to_node: thing)
       thing_name = accumulator.uplink.thing.name

       get "/api/v1/things/wrongname/accumulators", headers: header


       parsed_response = JSON.parse(response.body)

       expected_response = "The thing wrongname does not exist"
       expect(parsed_response["message"]).to eq(expected_response)
       expect(response.status).to eq(404)

     end
   end

   context "Thing has no associated accumulators" do
     it "Should return a message of accumulators not found" do
     Owner.create(from_node: user, to_node: thing)
     thing = create(:thing)

       get "/api/v1/things/#{thing.name}/accumulators", headers: header

       body = JSON.parse(response.body)

       expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
       expetected_response = "The thing not have accumulators"
       expect(response.status).to eq(404)
     end
   end

#   context "User not authorized access to accumulator" do
#    it "Should return unauthorized_message" do
#
#      get "/api/v1/things/#{thing.name}/accumulators", headers: header
#
#      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
#      expect(response.status).to eq(403)
#
#      body = JSON.parse(response.body)
#
#      expetected_response = "Access Denied: You are not authorized to access this page."
#      expect(body["message"]).to eq(expected_response)
#    end
#  end
  end
end
