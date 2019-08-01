require 'rails_helper'

RSpec.describe UserLocation do

  it { is_expected.to come_from(:User) }
  it { is_expected.to lead_to(:Location) }

  it { is_expected.to have_relationship_type(:user_location) }
end
