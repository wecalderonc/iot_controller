require 'rails_helper'

RSpec.describe Types::ThingType do
  subject { described_class.to_graphql }

  it { is_expected.to have_a_field(:id).of_type(!types.ID) }
  it { is_expected.to have_field(:name).of_type(!types.String) }
  it { is_expected.to have_field(:status).of_type(!types.String) }
  it { is_expected.to have_field(:pac).of_type(!types.String) }
  it { is_expected.to have_a_field(:companyId).of_type(!types.String) }
  it { is_expected.to have_field(:coordinates).of_type(!types[!types.Float]) }
  it { is_expected.to have_field(:user).of_type('User!') }
end
