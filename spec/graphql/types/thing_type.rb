require 'rails_helper'

RSpec.describe Types::ThingType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type(!types.ID) }
  it { is_expected.to have_field(:status).of_type('String!') }
  it { is_expected.to have_field(:pac).of_type('String!') }
  it { is_expected.to have_field(:companyId).of_type('String!') }
  it { is_expected.to have_field(:coordinates).of_type('[Float!]') }
end
