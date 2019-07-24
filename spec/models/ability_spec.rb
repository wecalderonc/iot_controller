# require "cancan/matchers"
 require 'rails_helper'

# RSpec.describe Ability do
#   let!(:user) { create(:user) }
#   let(:thing) { create(:thing) }
#   # subject(:ability) { Ability.new(Dry::Monads::Result::Success.new(user)) }
#   before(:each) do
#       @ability = Ability.new(Dry::Monads::Result::Success.new(user))
#     end

#   context 'first' do
#     it 'has  permissions' do

#      @ability.should be_able_to(:read, thing)
#     end
#   end
# end


require "cancan/matchers"


  describe "abilities" do

    context 'first' do
     let!(:user) { create(:user) }
      let(:thing) { create(:thing) }

      it 'something' do
        ability = Ability.new(Dry::Monads::Result::Success.new(user))
        expect(ability).to be_able_to(:read, thing)
      end
    end
  end

