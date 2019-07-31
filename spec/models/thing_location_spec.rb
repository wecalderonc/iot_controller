require 'rails_helper'

RSpec.describe ThingLocation do

  it { is_expected.to come_from(:Location) }
  it { is_expected.to lead_to(:Thing) }

  it { is_expected.to have_relationship_type(:thing_location) }
end
