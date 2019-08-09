require 'rails_helper'

RSpec.describe Users::ParseEmail do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:input) {
      {
        first_name: 'Daniela',
        last_name: 'Patiño',
        new_email: 'unacosita123@gmail.com',
        email: 'unacosita123@gmail',
        format: 'com'
      }
    }

    context 'new_email come in params' do
      it 'should return email and format joined' do
        expect(response).to be_success
        expect(response.success[:email]).to eq('unacosita123@gmail.com')
      end
    end

    context 'new_email email not come in params' do
      it 'should return original input' do
        input.delete(:new_email)

        expected_response = {
          first_name: 'Daniela',
          last_name: 'Patiño'
        }

        expect(response).to be_success
        expect(response.success).to match(expected_response)
      end
    end
  end
end
