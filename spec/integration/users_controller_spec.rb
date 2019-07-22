require 'swagger_helper'

RSpec.describe "Users API", :type => :request do
  path "/api/v1/users/{email}" do
    get 'Retrieves a User' do
      tags 'Users'
      produces 'application/json'
      parameter name: :email, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'user found' do
        let(:user) { create(:user) }
        let(:email) { create(:user, email: 'valid@mail.com').email }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: {
            id: { type: :string },
            email: { type: :string },
            name: { type: :string },
          },
          required: [ 'id', 'email', 'name' ]

        run_test!
      end

      response '404', 'user not found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:email) { "invalid_email" }

        run_test!
      end
    end
  end

  path "/api/v1/users" do
    get 'index users' do
      tags 'Users'
      produces 'application/json'
      parameter name: :email, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'user found' do
        let(:user) { create(:user) }
        let(:email) { create(:user, email: 'valid@mail.com').email }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            first_name: { type: :string },
            last_name: { type: :string },
            email: { type: :string },
          },
          required: [ 'first_name', 'last_name', 'email' ]
        }

        run_test!
      end
    end
  end
end
