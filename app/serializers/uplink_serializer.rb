class UplinkSerializer <  ActiveModel::Serializer
  attributes  :id,
              :data,
              :avgsnr,
              :rssi,
              :long,
              :lat,
              :snr,
              :station,
              :seqnumber,
              :time,
              :sec_uplinks,
              :sec_downlinks,
              :created_at,
              :updated_at
end
