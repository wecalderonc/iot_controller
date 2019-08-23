
require 'swagger_helper'

RSpec.describe "Users API", :type => :request do
  path "/authentication" do
    post 'Retrieves a token' do
      produces 'application/json'
      parameter name: :email, :in => :query, :type => :string
      parameter name: :password, :in => :query, :type => :string

      response '200', 'user found' do
        let(:user) { create(:user, email: 'valid@mail.com', password: 'validpassword') }
        let(:email) { user.email }
        let(:password) { user.password }

        schema type: :object,
          properties: {
            auth_token: { type: :string },
            email: { type: :string }
          },
          required: [ 'auth_token', 'email' ]

        run_test!
      end

      response '401', 'user not found' do
        let(:user) { create(:user, email: 'valid@mail.com', password: 'validpassword') }
        let(:email) { 'invalid@mail.com' }
        let(:password) { 'invalidpassword' }

        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          required: [ 'errors' ]

        run_test!
      end
    end
  end
end
