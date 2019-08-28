require 'rails_helper'

RSpec.describe Api::V1::AccumulatorsReportController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index index last accumulators from a thing" do
    let(:accumulator)     { create(:accumulator) }
    let(:uplink)          { create(:uplink, thing: accumulator.uplink.thing) }
    let(:uplink2)         { create(:uplink, thing: accumulator.uplink.thing) }
    let!(:accumulator2)   { create(:accumulator, uplink: uplink) }
    let!(:accumulator3)   { create(:accumulator, uplink: uplink2) }
    let(:thing_name)      { accumulator.uplink.thing.name }
    let(:params)          { { thing_name: thing_name, query: "last_accumulators" } }
    let(:thing_no_accs)   { create(:thing) }

    context "index last accumulators" do
      it "return accumulators" do
        get '/api/v1/accumulators_report', headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)
        expect(body.count).to match(3)
      end
    end

    context "index last accumulators - wrong thing name" do
      it "return device not found" do
        params = { thing_name: "thing_no_exist", query: "last_accumulators" }
        get '/api/v1/accumulators_report', headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("Device not found")
      end
    end

    context "index last accumulators - thing without accumulators" do
      it "return device not found" do
        params = { thing_name: thing_no_accs.name, query: "last_accumulators" }
        get '/api/v1/accumulators_report', headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)
        expect(body.count).to eq(0)
      end
    end
  end

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
      let(:thing)          { uplink.thing }
      let!(:accumulator2)  { create(:accumulator) }
      let(:thing2)         { accumulator2.uplink.thing }
      let(:params)         { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)           { CSV.parse(response.body) }

      it "generate a CSV" do
        thing.update(name: '90480')
        thing2.update(name: '31249')

        get '/api/v1/accumulators_report', headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
        expect(body[2]).to include('90480')
        expect(body.last).not_to include('31249')
      end
    end
  end

  describe "GET/show generate CSV" do
    let(:accumulator) { create(:accumulator) }
    let(:thing_name) { accumulator.uplink.thing.name }

    context "result found" do
      it "generate return a JSON" do
        get "/api/v1/accumulators_report/#{thing_name}", headers: header

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
      end
    end

    context "device not found" do
      it "generate a CSV" do
        get "/api/v1/accumulators_report/#{"invalid_name"}", headers: header

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
        thing.update(name: '64029')

        get "/api/v1/accumulators_report/#{thing.name}", headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
        expect(body[2]).to include('64029')
        expect(body.last).not_to include('20489')
      end
    end
  end
end
