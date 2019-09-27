require 'rails_helper'

RSpec.describe Api::V1::AccumulatorsReportController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index index last accumulators from a thing" do
    let(:accumulator)    { create(:accumulator) }
    let(:uplink)         { create(:uplink, thing: accumulator.uplink.thing) }
    let(:uplink2)        { create(:uplink, thing: accumulator.uplink.thing) }
    let!(:accumulator2)  { create(:accumulator, uplink: uplink) }
    let!(:accumulator3)  { create(:accumulator, uplink: uplink2) }
    let(:thing)          { accumulator.uplink.thing }
    let(:thing_no_accs)  { create(:thing) }
    let(:params)         { { thing_name: thing.name, query: "last_accumulators" } }

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

        expected_response = {"errors"=>"Results not found", "code"=>10104}

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body).to eq(expected_response)
      end
    end

    context "results found" do
      let!(:accumulator1) { create(:accumulator) }
      let!(:accumulator2) { create(:accumulator) }
      let!(:uplink_1) { accumulator1.uplink }
      let!(:uplink_2) { accumulator2.uplink }

      context "csv response" do
        it "generate a CSV" do
          header["Content-Type"] = "text/csv"
          get '/api/v1/accumulators_report', headers: header

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
        end
      end

      context "json response" do
        it "generate a JSON" do
          get '/api/v1/accumulators_report', headers: header

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)

          date1 = uplink_1.created_at.strftime('%a %d %b %Y')
          date2 = uplink_2.created_at.strftime('%a %d %b %Y')

          accumulator2_response = {
            "thing_id" => uplink_2.thing.id,
            "thing_name" => uplink_2.thing.name,
            "accumulators" => [
              {
                  "date" => date2,
                  "value" => accumulator2.value,
                  "consumption_delta" => 0,
                  "accumulated_delta" => 0
              }
            ]
          }

          accumulator1_response = {
            "thing_id" => uplink_1.thing.id,
            "thing_name" => uplink_1.thing.name,
            "accumulators" => [
              {
                  "date" => date1,
                  "value" => accumulator1.value,
                  "consumption_delta" => 0,
                  "accumulated_delta" => 0
              }
            ]
          }

          expect(body).to include(accumulator1_response)
          expect(body).to include(accumulator2_response)
        end
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
        header["Content-Type"] = "text/csv"

        get '/api/v1/accumulators_report', headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.status).to eq(200)
        expect(body[2]).to include('90480')
        expect(body.last).not_to include('31249')
      end
    end
  end

  describe "GET/show generate CSV" do
    let(:thing)    { create(:thing) }
    let(:uplink_1) { create(:uplink, thing: thing) }
    let(:uplink_2) { create(:uplink, thing: thing) }
    let!(:accumulator1) { create(:accumulator, uplink: uplink_1) }
    let!(:accumulator2) { create(:accumulator, uplink: uplink_2) }
    let(:thing_name) { thing.name }

    context "result found" do
      context "csv response" do
        it "generate a csv" do
          header["Content-Type"] = "text/csv"

          get "/api/v1/accumulators_report/#{thing_name}", headers: header

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
        end
      end

      context "json response" do
        it "generate a JSON response" do
          header["Content-Type"] = "application/json"

          get "/api/v1/accumulators_report/#{thing_name}", headers: header
       
          body = JSON.parse(response.body)

          date1 = uplink_1.created_at.strftime('%a %d %b %Y')
          date2 = uplink_2.created_at.strftime('%a %d %b %Y')

          expected_response = {
            "thing_id" => thing.id,
            "thing_name" => thing.name,
            "accumulators" => [
                {
                    "date" => date1,
                    "value" => accumulator1.value,
                    "consumption_delta" => 0,
                    "accumulated_delta" => 0
                },
                {
                    "date" => date2,
                    "value" => accumulator2.value,
                    "consumption_delta" => 0,
                    "accumulated_delta" => 0
                }
            ]
          }

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body).to include(expected_response)
        end
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
