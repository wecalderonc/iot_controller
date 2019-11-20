require 'rails_helper'

RSpec.describe Api::V1::AccumulatorsReportController, :type => :request do
  let(:user) { create(:user, password: "Usuario123*") }
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
      let!(:price)        { create(:price) }
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

          units1 = uplink_1.thing.units["liter"]
          units2 = uplink_2.thing.units["liter"]

          accumulator2_response = {
            "thing_id" => uplink_2.thing.id,
            "thing_name" => uplink_2.thing.name,
            "accumulators" => [
              {
                  "date" => date2,
                  "value" => accumulator2.value,
                  "consumption_delta" => accumulator2.value.to_i(16) * units2,
                  "accumulated_delta" => accumulator2.value.to_i(16) * units2
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
                  "consumption_delta" => accumulator1.value.to_i(16) * units1,
                  "accumulated_delta" => accumulator1.value.to_i(16) * units1
              }
            ]
          }

          expect(body).to include(accumulator1_response)
          expect(body).to include(accumulator2_response)
        end
      end
    end

    context "date filter in params" do
      let(:start_date)     { (Time.now - 4.days).to_i.to_s }
      let(:end_date)       { Time.now.to_i.to_s }
      let(:uplink)         { create(:uplink, time: (Time.now - 2.days).to_i.to_s) }
      let!(:accumulator)   { create(:accumulator, uplink: uplink) }
      let(:thing)          { uplink.thing }
      let!(:accumulator2)  { create(:accumulator) }
      let(:thing2)         { accumulator2.uplink.thing }
      let(:params)         { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)           { CSV.parse(response.body) }

      context "csv response" do
        it "generate a CSV" do
          header["Content-Type"] = "text/csv"

          get '/api/v1/accumulators_report', headers: header, params: params

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
        end
      end

      context "json response" do
        it "generate a JSON response" do
          get "/api/v1/accumulators_report", headers: header, params: params

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body.count).to eq(1)
          expect(body[0]["thing_id"]).to eq(thing.id)
          expect(body[0]["thing_name"]).to eq(thing.name)
          expect(body[0]["accumulators"].count).to eq(1)
        end
      end
    end
  end

  describe "GET/show generate CSV" do
    let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (3.months + 22.days)) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, units: { liter: 200 }, locates: location) }
    let(:uplink)   { create(:uplink, thing: thing, time: (Time.now - 1.month).to_i) }
    let(:uplink2)  { create(:uplink, thing: thing, time: (Time.now - 2.months).to_i) }
    let(:uplink3)  { create(:uplink, thing: thing, time: (Time.now - 3.months).to_i) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (Time.now - 2.days).to_i ) }
    let!(:price)   { create(:price) }
    let!(:accumulator1) { create(:accumulator, value: "00000f", uplink: uplink4) }
    let!(:accumulator2) { create(:accumulator, value: "00000c", uplink: uplink3) }
    let!(:accumulator3) { create(:accumulator, value: "00000d", uplink: uplink2) }
    let!(:accumulator4) { create(:accumulator, value: "00000e", uplink: uplink) }
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
          get "/api/v1/accumulators_report/#{thing_name}", headers: header

          body = JSON.parse(response.body)
          start_date = Date.today - 22.days
          end_date = Date.today

          historical_response = {
            '1' => {
              "value" => 2400.0,
              "days_count" => ((start_date - 2.months - 1.day) - (start_date - 3.months)).to_i,
              "months" => ((start_date - 3.months)..(start_date - 2.months)).map(&:month).uniq
            },
            '2'=> {
              "value" => 2600.0,
              "days_count" => ((start_date - 1.month - 1.day) - (start_date - 2.months)).to_i,
              "months" => ((start_date - 2.months)..(start_date - 1.months)).map(&:month).uniq
            },
            '3' => {
              "value" => 2800.0,
              "days_count" => ((start_date - 1.day) - (start_date - 1.month)).to_i,
              "months" => ((start_date - 1.months)..start_date).map(&:month).uniq
            },
            '4' => {
              "value" => 3000.0,
              "days_count" => 22,
              "months" => (start_date..end_date).map(&:month).uniq
            }
          }

          projected_response = {
            "value" => 4090.909090909091,
            "days_count" => 8
          }

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body["thing_id"]).to eq(thing.id)
          expect(body["thing_name"]).to eq(thing.name)
          expect(body["accumulators"].count).to eq(4)
          expect(body["consumptions_by_month"]).to match(historical_response)
          expect(body["projected_consumption"]).to match(projected_response)
        end
      end
    end

    context "date filter in params" do
      let(:start_date)     { (Time.now - 4.days).to_i.to_s }
      let(:end_date)       { Time.now.to_i.to_s }
      let(:location)       { create(:location) }
      let(:thing_1)        { create(:thing, locates: location) }
      let(:uplink_1)       { create(:uplink, time: (Time.now - 2.days).to_i.to_s, thing: thing_1) }
      let(:uplink_2)       { create(:uplink, thing: thing_1) }
      let!(:accumulator)   { create(:accumulator, uplink: uplink_1) }
      let!(:accumulator2)  { create(:accumulator, uplink: uplink_2) }
      let(:params)         { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)           { CSV.parse(response.body) }

      context "csv response" do
        it "generate a CSV" do
          header["Content-Type"] = "text/csv"

          get "/api/v1/accumulators_report/#{thing.name}", headers: header, params: params

          headers = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Acumulador", "Delta Consumo", "Delta Acumulado"]

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
          expect(body[0]).to match_array(headers)
          expect(body[1]).to match_array(["Device name: #{thing.name}"])
        end
      end

      context "json response" do
        it "generate a JSON response" do
          get "/api/v1/accumulators_report/#{thing.name}", headers: header, params: params

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body["thing_id"]).to eq(thing.id)
          expect(body["thing_name"]).to eq(thing.name)
          expect(body["accumulators"].count).to eq(1)
        end
      end
    end

    context "device not found" do
      it "generate a CSV" do
        get "/api/v1/accumulators_report/#{"invalid_name"}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("The thing invalid_name does not exist")
      end
    end
  end
end
