class ThingsUtils

  GetUplinkDate = -> accumulator do
    date = accumulator.uplink.created_at
    date.present? ? date.strftime('%a %d %b %Y') : ""
  end
end
