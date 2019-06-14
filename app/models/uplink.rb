class Uplink
  include Neo4j::ActiveNode

  property :data, type: String
  property :avgsnr, type: String
  property :rssi, type: String
  property :long, type: String
  property :lat, type: String
  property :snr, type: String
  property :station, type: String
  property :seqnumber, type: String
  property :time, type: String
  property :sec_uplinks, type: String
  property :sec_downlinks, type: String

  validates :long, :data, :avgsnr, :rssi, :long,
  :lat, :snr, :station, :seqnumber, :time, :sec_uplinks, :sec_downlinks, presence: true
end
