require 'rails_helper'

RSpec.describe Api::V1::RecipientsController, type: :request do
  let(:user) { create(:user) }
  sign_in(:user)

  let!(:recipient) { create(:recipient) }
  let(:school) { recipient.school }

  describe 'GET #index' do
    context 'when there are records' do
      it 'return a list of recipients' do
        get api_v1_school_recipients_path(school)

        expect(json_response.any?).to be_truthy
      end
    end

    context 'when there are not any records' do
      it 'does not return any data' do
        OrderItem.destroy_all
        Order.destroy_all
        Recipient.destroy_all
        get api_v1_school_recipients_path(school)

        expect(json_response).to be_empty
      end
    end
  end

  describe 'POST #create' do
    it 'creates a Recipient' do
      expect do
        post api_v1_school_recipients_path(school), params: { recipient: { name: 'Recipient Name', address: 'Recipient Address' } }
      end.to change { Recipient.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if name and address are missing ' do
        post api_v1_school_recipients_path(school), params: { recipient: { name: nil, address: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        post api_v1_school_recipients_path(school)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the school does not exist' do
      it 'returns an error' do
        post api_v1_school_recipients_path('foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do
    it 'update a Recipient' do
      put api_v1_school_recipient_path(school, recipient), params: { recipient: { name: 'Recipient Name 2', address: '999 Street' } }

      expect(response).to have_http_status(:ok)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if name and address are missing ' do
        put api_v1_school_recipient_path(school, recipient), params: { recipient: { name: nil, address: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        put api_v1_school_recipient_path(school, recipient)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the school does not exist' do
      it 'returns an error' do
        put api_v1_school_recipient_path('foo', recipient)

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the recipient does not exist' do
      it 'returns an error' do
        put api_v1_school_recipient_path(school, 'foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'delete a Recipient' do
      expect do
        delete api_v1_school_recipient_path(school, recipient)
      end.to change { Recipient.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    context 'when the school does not exist' do
      it 'returns an error' do
        post api_v1_school_recipients_path('foo', recipient)

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the record does not exist' do
      it 'returns an error' do
        put api_v1_school_recipient_path(school, 'foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
