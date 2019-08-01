require 'rails_helper'

RSpec.describe ThingLocation do

  it { is_expected.to come_from(:Thing) }
  it { is_expected.to lead_to(:Location) }

  it { is_expected.to have_relationship_type(:thing_location) }
end
