require 'rails_helper'

RSpec.describe Inputs::ThingInput do

  it 'validate arguments' do
    expect(subject.arguments).to include("id")
    expect(subject.arguments).to include("name")
    expect(subject.arguments).to include("status")
    expect(subject.arguments).to include("company_id")
    expect(subject.arguments).to include("pac")
    expect(subject.arguments).to include("latitude")
    expect(subject.arguments).to include("longitude")
  end
end
