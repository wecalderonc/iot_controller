require 'rails_helper'

RSpec.describe Owner do

it { is_expected.to come_from(:User) }
it { is_expected.to lead_to(:Thing) }


it { is_expected.to have_relationship_type(:OWN) }

end
