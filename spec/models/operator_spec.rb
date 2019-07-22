require 'rails_helper'

RSpec.describe Operator do

  it { is_expected.to come_from(:User) }
  it { is_expected.to lead_to(:Thing) }

  it { is_expected.to have_relationship_type(:OPERATE) }

end
