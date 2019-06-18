require 'rails_helper'

RSpec.describe Uplink, type: :model do

  it { is_expected.to define_property :data, :String }
  it { is_expected.to define_property :avgsnr, :String }
  it { is_expected.to define_property :rssi, :String }
  it { is_expected.to define_property :long, :String }
  it { is_expected.to define_property :lat, :String }
  it { is_expected.to define_property :snr, :String }
  it { is_expected.to define_property :station, :String }
  it { is_expected.to define_property :seqnumber, :String }
  it { is_expected.to define_property :time, :String }
  it { is_expected.to define_property :sec_uplinks, :String }
  it { is_expected.to define_property :sec_downlinks, :String }

  it { is_expected.to have_one(:Accumulator).with_direction(:in) }
  it { is_expected.to have_one(:Alarm).with_direction(:in) }
  it { is_expected.to have_one(:Sensor1).with_direction(:in) }
  it { is_expected.to have_one(:Sensor2).with_direction(:in) }
  it { is_expected.to have_one(:Sensor3).with_direction(:in) }
  it { is_expected.to have_one(:Sensor4).with_direction(:in) }
  it { is_expected.to have_one(:TimeUplink).with_direction(:in) }
  it { is_expected.to have_one(:UplinkBDownlink).with_direction(:in) }
  it { is_expected.to have_one(:ValvePosition).with_direction(:in) }

  it { is_expected.to have_one(:uplink_created).with_direction(:in) }
end
