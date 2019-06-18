require 'rails_helper'

RSpec.describe ValvePosition, type: :model do

  it { is_expected.to define_property :value, :String }
  it { is_expected.to have_one(:uplink).with_direction(:out) }
end

