require 'rails_helper'

RSpec.describe Api::V1::AlarmsController, :type => :request do
  let(:user)   { create(:user) }
  let(:alarm)  { create(:alarm) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "PUT/update alarm state" do
    context "The request is ok" do
      it "Should return a 200 status" do
        put "/api/v1/alarms/#{alarm.id}", headers: header

        expect(response.successful?).to be_truthy

        alarm.reload

        expect(alarm.viewed).to be_truthy
      end
    end

    context "The authorization code is wrong" do
      it "Should return a 401 status" do
        header['Authorization'] = "dsfkjsdhfsdhf"

        put "/api/v1/alarms/#{alarm.id}", headers: header

        expect(response.successful?).to be_falsey
        expect(response.status).to eq(401)

        alarm.reload

        expect(alarm.viewed).to be_falsey
      end
    end

    context "The URL is wrong" do
      it "Should return a bad URI error" do
        put "/api/v1/alarms/326478956743856fhdsj", headers: header

        expect(response.successful?).to be_truthy

        alarm.reload

        expect(alarm.viewed).to be_falsey
      end
    end
  end
end
