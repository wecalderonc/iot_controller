require 'rails_helper'

RSpec.describe Users::Update::Update do
  describe "#call" do
    let(:response) { subject.(input) }
    let(:user)     { create(:user) }
    let(:country)  { create(:country, code_iso: 'CO') }

    let(:input) {
      { id: user.id,
        first_name: "Daniela",
        last_name: "Patiño",
        email: "dpatino@proci.com",
        country_code: country.code_iso,
        password: "nuevopassword",
        password_confirmation: "nuevopassword",
        user: user
      }  
    }

    context 'right properties' do
      it 'should update the user properties' do

        expect(response).to be_success

        user.reload

        expect(user.first_name).to eq("Daniela")
        expect(user.last_name).to eq("Patiño")
        expect(user.email).to eq("dpatino@proci.com")
        expect(user.password).to eq("nuevopassword")
        expect(user.country.code_iso).to eq("CO")
      end
    end
 
    context 'wrong properties' do
      it 'should not update the user properties' do
        input[:country_code] = 'naditajeje'

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("Country not found")
      end
    end

    context 'without country' do
      it 'should update the other user properties' do
        input[:country_code] = nil

        expect(response).to be_success

        user.reload

        expect(user.first_name).to eq("Daniela")
        expect(user.last_name).to eq("Patiño")
        expect(user.email).to eq("dpatino@proci.com")
        expect(user.password).to eq("nuevopassword")
      end
    end
  end
end
