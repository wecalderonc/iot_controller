require 'swagger_helper'

RSpec.describe "Uplinks API", :type => :request do
  path "/api/v1/uplinks" do
    get 'Retrieves all Uplinks' do
      tags 'Uplinks'
      produces 'application/json'
      parameter({
       :in => :header,
       :type => :string,
       :name => :Authorization,
       :required => true
     })

      response '200', 'last uplink found' do

       let(:Authorization) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGY5ZmVmZDUtOTA5Zi00ZWRiLWFiM2YtOGY2YjkwMTdlZWNhIiwiZXhwIjoxNTYwNjQ1ODMyfQ.qNUH2wvW-62GpJXTTDiXHwdB3CgXCS9tSoNz4CE2_yU' }
        #header 'Authorization', type: :string, value: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGY5ZmVmZDUtOTA5Zi00ZWRiLWFiM2YtOGY2YjkwMTdlZWNhIiwiZXhwIjoxNTYwNjQ1ODMyfQ.qNUH2wvW-62GpJXTTDiXHwdB3CgXCS9tSoNz4CE2_yU'
        let(:uplink) { create(:uplink) }
        schema type: :object,
          properties:
            {
              id: { type: :string },
              data: { type: :string },
              avgsnr: { type: :string },
              rssi: { type: :string },
              long: { type: :string },
              lat: { type: :string },
              snr: { type: :string },
              station: { type: :string },
              seqnumber: { type: :string },
              time: { type: :string },
              sec_uplinks: { type: :string },
              sec_downlinks: { type: :string },
            },
          required: [ 'id', 'data', 'avgsnr', 'rssi', 'long', 'lat', 'snr', 'station', 'seqnumber', 'time', 'sec_uplinks', 'sec_downlinks' ]
        run_test!
      end

      response '404', 'no uplinks found' do
        let(:Authorization) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGY5ZmVmZDUtOTA5Zi00ZWRiLWFiM2YtOGY2YjkwMTdlZWNhIiwiZXhwIjoxNTYwNjQ1ODMyfQ.qNUH2wvW-62GpJXTTDiXHwdB3CgXCS9tSoNz4CE2_yU' }
        run_test!
      end
    end
  end
end
