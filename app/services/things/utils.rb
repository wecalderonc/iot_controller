module Things
  class Utils

    GetUplinkDate = -> accumulator do
      accumulator.uplink.created_at.strftime('%a %d %b %Y')
    end
  end
end
