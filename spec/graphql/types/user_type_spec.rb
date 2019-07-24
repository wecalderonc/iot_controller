require 'rails_helper'

RSpec.describe Types::UserType do
  subject { described_class.to_graphql }

  it { is_expected.to have_a_field(:id).of_type(!types.ID) }
  it { is_expected.to have_a_field(:firstName).of_type(!types.String) }
  it { is_expected.to have_a_field(:lastName).of_type(!types.String) }
  it { is_expected.to have_a_field(:email).of_type(!types.String) }
  it { is_expected.to have_a_field(:phone).of_type(!types.String) }
  it { is_expected.to have_a_field(:gender).of_type(!types.String) }
  it { is_expected.to have_a_field(:idNumber).of_type(!types.String) }
  it { is_expected.to have_a_field(:codeNumber).of_type(!types.String) }
  it { is_expected.to have_a_field(:userType).of_type(!types.String) }
end
