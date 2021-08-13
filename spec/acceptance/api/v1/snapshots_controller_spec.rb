# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Snapshots' do
  before do
    create(:snapshot, image_url: 'abc.html', token: 'token123')
  end
  get '/api/v1/snapshots' do
    context 'with valid params' do
      parameter :token, 'token'
      let!(:token) { 'token123' }
      example 'get snapshots of the candidate' do
        create(:snapshot, image_url: 'abc.html', token: 'token123')
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['snapshots'].count).to eq(2)
        expect(status).to eq(200)
      end
    end
    context 'with invalid params' do
      example 'returns not found error message' do
        create(:snapshot, image_url: 'abc.html')
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('missing_parameter.message'))
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/snapshots' do
    context 'with valid params' do
      parameter :token, 'token'
      parameter :presigned_url, 'presigned_url'
      let!(:token) { 'token123' }
      let!(:presigned_url) { 'https://abc.html' }
      example 'new snapshot and store into database' do
        do_request
        response = JSON.parse(response_body)
        data = 'Snapshot created successfully.'
        expect(status).to eq(200)
        expect(response['message']).to eq(data)
      end
    end

    context 'return missing params if token is not provided' do
      parameter :presigned_url, 'presigned_url'
      let!(:presigned_url) { 'https://abc.html' }
      example ' returns missing parameter error message as parameter token is not passed' do
        do_request
        response = JSON.parse(response_body)
        expect(response['message']).to eq(I18n.t('missing_parameter.message'))
        expect(status).to eq(200)
      end
    end
  end
end
