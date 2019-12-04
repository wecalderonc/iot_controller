require 'rails_helper'

RSpec.describe Inputs::UserInput do

  it 'validate arguments' do
    expect(subject.arguments).to include("id")
    expect(subject.arguments).to include("first_name")
    expect(subject.arguments).to include("last_name")
    expect(subject.arguments).to include("email")
    expect(subject.arguments).to include("phone")
    expect(subject.arguments).to include("id_number")
    expect(subject.arguments).to include("user_type")
  end
end
