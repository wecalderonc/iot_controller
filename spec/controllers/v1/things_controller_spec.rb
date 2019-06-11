# spec/requests/things_spec.rb
require 'rails_helper'

RSpec.describe 'things API', type: :request do
  # initialize test data
  let!(:things) { create_list(:thing, 10) }
  let(:thing_id) { things.first.id }

  after(:all) do
    Thing.all.each(&:destroy)
  end

  # Test suite for GET /things
  describe 'GET /things' do
    # make HTTP get request before each example
    before { get '/things' }

    it 'returns things' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      response
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /things/:id
  describe 'GET /things/:id' do
    before { get "/things/#{thing_id}" }

    context 'when the record exists' do
      it 'returns the thing' do
        expect(json).not_to be_empty
        expect(json['thing']['id']).to eq(thing_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:thing_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find thing/)
      end
    end
  end

  # Test suite for POST /things
  describe 'POST /things' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm' } }

    context 'when the request is valid' do
      before { post '/things', params: valid_attributes }

      it 'creates a thing' do
        expect(json['thing']['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/things', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

    end
  end

  # Test suite for PUT /things/:id
  describe 'PUT /things/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/things/#{thing_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /things/:id
  describe 'DELETE /things/:id' do
    before { delete "/things/#{thing_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
