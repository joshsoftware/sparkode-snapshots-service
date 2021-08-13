# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SnapshotsController, type: :controller do
  let!(:snapshot) { create(:snapshot, token: 'token123', image_url: 'abc.jpg') }

  describe 'GET #INDEX' do
    context 'with valid params' do
      it 'returns all snapshots related to a candidate' do
        get :index, params: { token: 'token123' }

        data = json

        expect(data['data']['snapshots'].count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'returns the missing parameter error as not sending token' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #presignedUrl' do
    context 'with valid params' do
      it 'return all snapshots related to a candidate' do
        post :presigned_url, params: { token: 'token123', first_name: 'kiran', last_name: 'patil' }
        data = json
        expect(data['message']).to eq('Success')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'save all snapshots related to a drives candidate' do
        post :create, params: { token: 'token123', presigned_url: Faker::Internet.url }

        data = json

        expect(data['data'].count).to eq(1)
        expect(data['message']).to eq('Snapshot created successfully.')
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with missing params' do
      it 'returns the missing params error as not passing token' do
        post :create
        message_response = JSON.parse(response.body)
        expect(message_response['message']).to eq('Missing parameter')
        expect(response).to have_http_status(200)
      end
    end
  end
end
