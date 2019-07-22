require 'rails_helper'

RSpec.describe Types::UserType do
  subject { described_class.to_graphql }

  it { is_expected.to have_a_field(:id).of_type(!types.ID) }
  it { is_expected.to have_a_field(:thing).of_type([Thing!]) }
end
