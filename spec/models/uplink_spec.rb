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

  it { is_expected.to have_one(:accumulator).with_direction(:in) }
  it { is_expected.to have_one(:alarm).with_direction(:in) }
  it { is_expected.to have_one(:sensor1).with_direction(:in) }
  it { is_expected.to have_one(:sensor2).with_direction(:in) }
  it { is_expected.to have_one(:sensor3).with_direction(:in) }
  it { is_expected.to have_one(:sensor4).with_direction(:in) }
  it { is_expected.to have_one(:timeUplink).with_direction(:in) }
  it { is_expected.to have_one(:uplinkBDownlink).with_direction(:in) }
  it { is_expected.to have_one(:valvePosition).with_direction(:in) }

  it { is_expected.to have_one(:uplinks_created).with_direction(:in) }
end
