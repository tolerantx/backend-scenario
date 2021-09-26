require 'rails_helper'

RSpec.describe Api::V1::SchoolsController, type: :request do
  describe 'POST #create' do
    it 'creates a School' do
      expect do
        post api_v1_schools_path, params: { school: { name: 'School Name', address: 'Address' } }
      end.to change { School.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if name and address are missing ' do
        post api_v1_schools_path, params: { school: { name: nil, address: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        post api_v1_schools_path

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:school) { create(:school) }

    it 'update a School' do
      put api_v1_school_path(school), params: { school: { name: 'Bella Vista High School', address: '123 Street' } }

      expect(response).to have_http_status(:ok)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if name and address are missing ' do
        put api_v1_school_path(school), params: { school: { name: nil, address: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        put api_v1_school_path(school)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the record does not exist' do
      it 'returns an error' do
        put api_v1_school_path('foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:school) { create(:school) }

    it 'delete a School' do
      expect do
        delete api_v1_school_path(school)
      end.to change { School.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    context 'when the record does not exist' do
      it 'returns an error' do
        put api_v1_school_path('foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
