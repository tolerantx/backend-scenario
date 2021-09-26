require 'rails_helper'

RSpec.describe Api::V1::SchoolsController, type: :request do

  describe 'POST #create' do
    it 'creates a School' do
      expect {
        post api_v1_schools_path, params: { school: { name: 'School Name', address: 'Address' } }
      }.to change{ School.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    context 'when the params are missing or values are not correct' do
      it 'returns errors with name and address as nil' do
        post api_v1_schools_path, params: { school: { name: nil, address: nil } }

        expect(response).to have_http_status(422)
      end

      it 'returns errors if params are missing' do
        post api_v1_schools_path

        expect(json_response[:message].present?).to be_truthy
        expect(response).to have_http_status(422)
      end
    end
  end
end

