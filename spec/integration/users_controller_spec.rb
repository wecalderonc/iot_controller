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
            first_name: { type: :string },
            last_name: { type: :string },
            email: { type: :string },
          },
          required: [ 'first_name', 'last_name', 'email' ]

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

  path "/confirm_email" do
    post 'Retrieves a confirmation to the confirm email process' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          verification_code: { type: :string }
        },
        required: [ 'email', 'verification_code' ]
      }

      response '200', 'user found with verification_code' do
        let(:user) { create(:user) }
        let(:email) { user.email }
        let(:verification_code) { user.verification_code}

        schema type: :object,
          properties: {
            message: { type: :string },
          },
          required: [ 'message' ]

        let(:input) {{
          email: email,
          verification_code: verification_code
        }}

        run_test!
      end

      response '404', 'user not found or verification_code expired or fake' do
        let(:user) { create(:user, email: 'holaamigo@mail.com') }
        let(:email) { user.email }
        let!(:verification_code) { "fffffff" }

        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          required: [ 'errors' ]

        let(:input) {{
          email: email,
          verification_code: verification_code
        }}

        run_test!
      end

      response '404', 'without verification code' do
        let(:user) { create(:user, email: 'holaamigo@mail.com') }
        let(:email) { user.email }

        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          required: [ 'errors' ]

        let(:input) {{ email: email }}

        run_test!
      end
    end
  end

  path "/request_password_recovery" do
    post 'Retrieves a success response with recovery password email sended' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: [ 'email' ]
      }

      response '200', 'user found with email' do
        let(:user) { create(:user) }
        let(:email) { user.email }

        schema type: :object,
          properties: {
            message: { type: :string },
          },
          required: [ 'message' ]

        let(:input) {{
          email: email
        }}

        run_test!
      end

      response '404', 'user not found' do
        let(:user) { create(:user) }
        let(:email) { "bad_email@gmail.com" }

        schema type: :object,
          properties: {
            message: { type: :string }
          },
          required: [ 'message' ]

        let(:input) {{
          email: email
        }}

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
        let!(:user2) { create(:user) }
        let!(:user3) { create(:user) }
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

  path "/api/v1/users" do
    post 'create user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          country_code: { type: :string },
          phone: { type: :string  },
          gender: { type: :string },
          id_number: { type: :string },
          id_type: { type: :string },
          code_number: { type: :string }
        },
        required: [ 'first_name', 'last_name', 'email', 'password', 'phone', 'gender', 'id_number', 'id_type', 'code_number']
      }

      response '200', 'user created' do
        let(:user) { create(:user) }
        let!(:country) { create(:country, code_iso: 'CO') }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'first_name', 'last_name', 'email' ],
          properties: {
            first_name: { type: :string },
            last_name: { type: :string },
            email: { type: :string }
          }

        let(:input) {{
          first_name: "new_user",
          last_name: "new_last",
          email: "new_user@gmail.com",
          password: "Waico123*",
          phone: "3013632461",
          country_code: "CO",
          gender: :male,
          id_number: "123456",
          id_type: "cc",
          code_number: "123456789",
          admin: "true",
          user_type: "administrator"
        }}

        run_test!
      end
    end
  end

  path "/api/v1/users/{email}" do
    put 'update user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :email, :in => :path, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          new_email: { type: :string },
          country_code: { type: :string },
          current_password: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: [ 'first_name', 'last_name', 'new_email', 'country_code', 'current_password', 'password', 'password_confirmation']
      }

      response '200', 'user created' do
        let(:user) { create(:user, email: 'valid@mail.com', password: 'hola') }
        let(:email) { user.email }
        let!(:country) { create(:country, code_iso: 'CO') }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'first_name', 'last_name', 'email'],
          properties: {
            first_name: { type: :string },
            last_name: { type: :string },
            email: { type: :string }
          }

        let(:input) {
          {
            first_name: "Daniela",
            last_name: "Patiño",
            new_email: "unacosita123@gmail.com",
            country_code: "CO",
            current_password: user.password,
            password: "nuevopassword",
            password_confirmation: "nuevopassword"
          }
        }

        run_test!
      end

      response '404', 'user not found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:email) { "invalid_email" }

        let(:input) {{
          first_name: "new_user",
          last_name: "new_last"
        }}

        run_test!
      end
    end
  end

  path "/change_forgotten_password" do
    put 'update password user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          current_password: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: [ 'email', 'current_password', 'password', 'password_confirmation']
      }

      response '200', 'user password updated' do
        let(:user) { create(:user, email: 'valid@mail.com', password: 'hola') }
        let(:email) { user.email }
        let!(:country) { create(:country, code_iso: 'CO') }

        schema type: :object,
          required: [ 'first_name', 'last_name', 'email'],
          properties: {
            first_name: { type: :string },
            last_name: { type: :string },
            email: { type: :string }
          }

        let(:input) {
          {
            email: email,
            current_password: user.password,
            password: "nuevopassword",
            password_confirmation: "nuevopassword"
          }
        }

        run_test!
      end

      response '404', 'user not found' do
        let(:user) { create(:user) }
        let(:email) { "invalid_email" }

        let(:input) {
          {
            email: email,
            current_password: user.password,
            password: "nuevopassword",
            password_confirmation: "nuevopassword"
          }
        }

        run_test!
      end
    end
  end
end
