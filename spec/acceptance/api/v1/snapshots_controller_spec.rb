# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Snapshots' do
  before do
  snapshot = create(:snapshot, image_url: 'abc.html', token: 'token123') 
  end
  get '/api/v1/snapshots' do
    parameter :token, 'token'
    context 'with valid params' do
      let!(:token) { 'token123' }
      example 'get snapshots of the candidate' do
        snapshot = create(:snapshot, image_url: 'abc.html', token: 'token123')
        do_request
        response = JSON.parse(response_body)
        expect(response['data']['snapshots'].count).to eq(2)
        expect(status).to eq(200)
      end
    end
    # context 'with invalid params' do
    #   # let!(:token) { 'token' }
    #   example 'returns not found error message' do
    #     snapshot = create(:snapshot, image_url: 'abc.html', token: 'token123')
    #     do_request
    #     byebug
    #     response = JSON.parse(response_body)
    #     expect(response['message']).to eq(I18n.t('not_found.message'))
    #     expect(status).to eq(200)
    #   end
    # end
  end

  post '/api/v1/snapshots' do
    parameter :token, 'token'
    parameter :presigned_url, 'presigned_url' 
    context 'with valid params' do
      let!(:token) { 'token123' }
      let!(:presigned_url) { 'https://abc.html' }
      example 'new snapshot and store into database' do
        do_request
        response = JSON.parse(response_body)
        byebug
        data = 'Snapshot created successfully.'
        expect(status).to eq(200)
        expect(response['message']).to eq(data)
      end
    end

  #   context 'with missing problem id returns missing parameter error' do
  #     let!(:answer) { Faker::Lorem.paragraph }
  #     let!(:language_id) { Faker::Number.digit }
  #     example ' returns not found error message as token is fake' do
  #       previous_code_count = Code.count
  #       do_request
  #       response = JSON.parse(response_body)
  #       expect(response['message']).to eq(I18n.t('missing_parameter.message'))
  #       expect(status).to eq(200)
  #       expect(Code.count).to eq(previous_code_count)
  #     end
  #   end
  end
end
