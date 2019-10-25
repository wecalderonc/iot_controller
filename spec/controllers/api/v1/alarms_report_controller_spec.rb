require 'rails_helper'

RSpec.describe Api::V1::AlarmsReportController, :type => :request do
  let(:user) { create(:user, password: "Usuario123*") }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index generate CSV" do
    context "results not found" do
      it "generate return a JSON" do
        get '/api/v1/alarms_report', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("Results not found")
      end
    end

    context "results found" do
      let!(:alarm1) { create(:alarm) }
      let!(:alarm5) { create(:alarm) }
      let!(:uplink_1) { alarm1.uplink }
      let!(:uplink_2) { alarm5.uplink }

      context "csv response" do
        it "generate a CSV" do
          header["Content-Type"] = "text/csv"

          get '/api/v1/alarms_report', headers: header

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
        end
      end

      context "json response" do
        it "generate a JSON" do
          get '/api/v1/alarms_report', headers: header

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)

          date1 = uplink_1.created_at.strftime('%a %d %b %Y')
          date2 = uplink_2.created_at.strftime('%a %d %b %Y')

          alarm2_response = {
            "thing_id" => uplink_2.thing.id,
            "thing_name" => uplink_2.thing.name,
            "alarms" => [
              {
                  "date" => date2,
                  "value" => alarm5.value
              }
            ]
          }

          alarm1_response = {
            "thing_id" => uplink_1.thing.id,
            "thing_name" => uplink_1.thing.name,
            "alarms" => [
              {
                  "date" => date1,
                  "value" => alarm1.value
              }
            ]
          }

          expect(body).to include(alarm1_response)
          expect(body).to include(alarm2_response)
        end
      end
    end

    context "date filter in params" do
      let(:start_date)  { (Time.now - 2.days).to_time.to_i.to_s }
      let(:end_date)    { Time.now.to_time.to_i.to_s }
      let(:uplink)      { create(:uplink, time: end_date) }
      let!(:alarm)      { create(:alarm, uplink: uplink) }
      let!(:alarm2)     { create(:alarm) }
      let(:thing)       { uplink.thing }
      let(:thing2)      { alarm2.uplink.thing }
      let(:params)      { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)        { CSV.parse(response.body) }

      context "csv response" do
        it "generate a CSV" do
          header["Content-Type"] = "text/csv"

          get '/api/v1/alarms_report', headers: header, params: params

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
        end
      end

      context "json response" do
        it "generate a JSON response" do
          get "/api/v1/alarms_report", headers: header, params: params

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body.count).to eq(1)
          expect(body[0]["thing_id"]).to eq(thing.id)
          expect(body[0]["thing_name"]).to eq(thing.name)
          expect(body[0]["alarms"].count).to eq(1)
        end
      end
    end
  end

  describe "GET/show generate CSV" do
    let(:thing)    { create(:thing) }
    let(:uplink_1) { create(:uplink, thing: thing) }
    let(:uplink_2) { create(:uplink, thing: thing) }
    let!(:alarm1) { create(:alarm, uplink: uplink_1) }
    let!(:alarm2) { create(:alarm, uplink: uplink_2) }
    let(:thing_name) { thing.name }

    context "result found" do
      context "csv response" do
        it "generate a csv" do
          header["Content-Type"] = "text/csv"

          get "/api/v1/alarms_report/#{thing_name}", headers: header

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
        end
      end

      context "json response" do
        it "generate a JSON response" do
          get "/api/v1/alarms_report/#{thing_name}", headers: header

          body = JSON.parse(response.body)[0]

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body["thing_id"]).to eq(thing.id)
          expect(body["thing_name"]).to eq(thing.name)
          expect(body["alarms"].count).to eq(2)
        end
      end
    end

    context "date filter in params" do
      let(:start_date) { (Time.now - 2.days).to_time.to_i.to_s }
      let(:end_date)   { Time.now.to_time.to_i.to_s }
      let(:thing)      { create(:thing) }
      let(:uplink)     { create(:uplink, time: end_date, thing: thing) }
      let(:uplink2)    { create(:uplink, thing: thing) }
      let!(:alarm)     { create(:alarm, uplink: uplink) }
      let!(:alarm2)    { create(:alarm, uplink: uplink2) }
      let(:params)     { { date: { start_date: start_date, end_date: end_date } } }
      let(:body)       { CSV.parse(response.body) }

      context "csv response" do
        it "generate a CSV" do
          header["Content-Type"] = "text/csv"

          get "/api/v1/alarms_report/#{thing.name}", headers: header, params: params

          headers = ["BD ID", "ID Dispositivo", "Fecha/Hora", "Valor Alarma"]

          expect(response.headers["Content-Type"]).to eq("text/csv")
          expect(response.status).to eq(200)
          expect(body[0]).to match_array(headers)
          expect(body[1]).to match_array(["Device name: #{thing.name}"])
        end
      end

      context "json response" do
        it "generate a JSON response" do
          get "/api/v1/alarms_report/#{thing.name}", headers: header, params: params

          body = JSON.parse(response.body)[0]

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)
          expect(body["thing_id"]).to eq(thing.id)
          expect(body["thing_name"]).to eq(thing.name)
          expect(body["alarms"].count).to eq(1)
        end
      end
    end

    context "device not found" do
      it "generate an error response" do
        get "/api/v1/alarms_report/#{"invalid_name"}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("The thing invalid_name does not exist")
      end
    end
  end
end
