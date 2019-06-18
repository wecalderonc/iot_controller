FactoryBot.define do
  factory :uplink do
    data          {"006774300806702ffff10000"}
    avgsnr        {"18.47"}
    rssi          {"-530.00"}
    long          {"-74.0"}
    lat           {"5.0"}
    snr           {"16.32"}
    station       {"146A"}
    seqnumber     {"77"}
    time          {"1548277798"}
    sec_uplinks   {"006"}
    sec_downlinks {"0"}

    association :thing, factory: :thing
  end
end
