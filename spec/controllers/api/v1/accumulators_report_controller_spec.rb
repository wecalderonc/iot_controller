require 'rails_helper'

RSpec.describe Api::V1::AccumulatorsReportController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index generate CSV" do
    context "results found" do
      it "generate return a JSON" do
        get '/api/v1/accumulators_report', headers: header
        body = JSON.parse(response.body)
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(body["errors"]).to eq("No results found")
      end
    end

    context "results found" do
      before { create :accumulator }
      it "generate a CSV" do
        get '/api/v1/accumulators_report', headers: header

        expect(response.headers["Content-Type"]).to eq("text/csv")
      end
    end
  end

  describe "GET/show generate CSV" do
    let(:accumulator) { create(:accumulator) }
    let(:thing_id) { accumulator.uplink.thing.id }
    context "result found" do
      it "generate return a JSON" do
        get "/api/v1/accumulators_report/#{thing_id}", headers: header

        expect(response.headers["Content-Type"]).to eq("text/csv")
      end
    end

    context "device not found" do
      it "generate a CSV" do
        get "/api/v1/accumulators_report/#{"invalid_id"}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(body["errors"]).to eq("Device not found")
      end
    end
  end
end
