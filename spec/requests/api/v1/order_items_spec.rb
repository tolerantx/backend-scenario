require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  let(:user) { create(:user) }
  sign_in(:user)

  let(:school) { create(:school) }
  let(:recipient) { create(:recipient, school: school) }
  let(:order) { create(:order, school: school) }
  let!(:order_item) { create(:order_item, order: order, recipient: recipient, quantity: 1) }
  let(:params) do
    {
      order_item: {
        recipient_id: recipient.id,
        gift_type: 'MUG',
        quantity: 1
      }
    }
  end

  describe 'GET #index' do
    context 'when there are records' do
      it 'return a list of orders' do
        get api_v1_order_items_path(order)

        expect(json_response.any?).to be_truthy
      end
    end

    context 'when there are not any records' do
      it 'does not return any data' do
        OrderItem.destroy_all
        get api_v1_order_items_path(order)

        expect(json_response).to be_empty
      end
    end
  end

  describe 'POST #create' do
    it 'creates a Order Item' do
      expect do
        post api_v1_order_items_path(order), params: params
      end.to change { OrderItem.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if recipient_id is missing ' do
        post api_v1_order_items_path(order), params: { order_item: { recipient_id: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        post api_v1_order_items_path(order)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the order does not exist' do
      it 'returns an error' do
        post api_v1_order_items_path('foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do
    it 'update an Order Item' do
      put api_v1_order_item_path(order, order_item), params: params

      expect(response).to have_http_status(:ok)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if recipient_id missing ' do
        put api_v1_order_item_path(order, order_item), params: { order_item: { recipient_id: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        put api_v1_order_item_path(order, order_item)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the order does not exist' do
      it 'returns an error' do
        put api_v1_order_item_path('foo', order_item)

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
