require 'rails_helper'

RSpec.describe Api::V1::AccumulatorsReportController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index generate CSV" do
    context "results not found" do
      it "generate return a JSON" do
        get '/api/v1/accumulators_report', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("No results found")
      end
    end

    context "results found" do
      before { create :accumulator }
      it "generate a CSV" do
        get '/api/v1/accumulators_report', headers: header

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
      end
    end

    context "date filter in params" do
      let(:start_date)     { (Time.now - 2.days).to_time.to_i.to_s }
      let(:end_date)       { Time.now.to_time.to_i.to_s }
      let(:uplink)         { create(:uplink, time: end_date) }
      let!(:accumulator)   { create(:accumulator, uplink: uplink) }
      let!(:accumulator2)  { create(:accumulator) }
      let(:thing2)         { accumulator2.uplink.thing }
      let(:params)         { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)           { CSV.parse(response.body) }

      it "generate a CSV" do
        get '/api/v1/accumulators_report', headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
        expect(body[2]).to include(uplink.thing.name)
        expect(body.last).not_to include(thing2.name)
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
        expect(response.status).to eq(200)
      end
    end

    context "device not found" do
      it "generate a CSV" do
        get "/api/v1/accumulators_report/#{"invalid_id"}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("Device not found")
      end
    end

    context "date filter in params" do
      let(:start_date)     { (Time.now - 2.days).to_time.to_i.to_s }
      let(:end_date)       { Time.now.to_time.to_i.to_s }
      let(:uplink)         { create(:uplink, time: end_date) }
      let(:thing)          { accumulator.uplink.thing }
      let!(:accumulator)   { create(:accumulator, uplink: uplink) }
      let!(:accumulator2)  { create(:accumulator) }
      let(:thing2)         { accumulator2.uplink.thing }
      let(:params)         { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)           { CSV.parse(response.body) }

      it "generate a CSV" do
        thing2.update(name: '20489')

        get "/api/v1/accumulators_report/#{thing.id}", headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
        expect(body[2]).to include(uplink.thing.name)
        expect(body.last).not_to include('20489')
      end
    end
  end
end
