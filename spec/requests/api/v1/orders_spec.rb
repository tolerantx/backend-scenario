require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  let(:school) { create(:school) }
  let(:recipient) { create(:recipient, school: school) }
  let(:order) { create(:order, school: school) }
  let!(:order_item) { create(:order_item, order: order, recipient: recipient, quantity: 1) }
  let(:params) do
    {
      order: {
        status: 'ORDER_RECEIVED',
        date: Date.today,
        items_attributes: [
          {
            recipient_id: recipient.id,
            gift_type: 'MUG',
            quantity: 1
          }
        ]
      }
    }
  end
  let(:update_params) do
    {
      order: {
        status: 'ORDER_RECEIVED',
        date: Date.today,
        items_attributes: [
          {
            id: order_item.id,
            recipient_id: recipient.id,
            gift_type: 'MUG',
            quantity: 1
          }
        ]
      }
    }
  end
  let(:update_order_item) do
    {
      order: {
        status: 'ORDER_PROCESSING',
        date: Date.today,
        items_attributes: [
          {
            id: order_item.id,
            gift_type: 'T_SHIRT',
            quantity: 2
          }
        ]
      }
    }
  end

  describe 'GET #index' do
    context 'when there are records' do
      it 'return a list of orders' do
        get api_v1_school_orders_path(school)

        expect(json_response.any?).to be_truthy
      end
    end

    context 'when there are not any records' do
      it 'does not return any data' do
        OrderItem.destroy_all
        Order.destroy_all
        get api_v1_school_orders_path(school)

        expect(json_response).to be_empty
      end
    end
  end

  describe 'POST #create' do
    it 'creates a Order' do
      expect do
        post api_v1_school_orders_path(school), params: params
      end.to change { Order.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if status and date are missing ' do
        post api_v1_school_orders_path(school), params: { order: { status: nil, date: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        post api_v1_school_orders_path(school)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the school does not exist' do
      it 'returns an error' do
        post api_v1_school_orders_path('foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do
    it 'update an Order' do
      put api_v1_school_order_path(school, order), params: params

      expect(response).to have_http_status(:ok)
    end

    context 'when an item is updated successfull' do
      it 'updates the order_item' do
        put api_v1_school_order_path(school, order), params: update_order_item

        expect(response).to have_http_status(:ok)
        expect(order_item.reload.gift_type).to eql('T_SHIRT')
        expect(order_item.reload.quantity).to eql(2)
      end
    end

    context 'when the request is not successfull about params' do
      it 'returns status 422 if status and date are missing ' do
        put api_v1_school_order_path(school, order), params: { order: { status: nil, date: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors if params are missing' do
        put api_v1_school_order_path(school, order)

        expect(json_response.dig(:error, :message).present?).to be_truthy
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the school does not exist' do
      it 'returns an error' do
        put api_v1_school_order_path('foo', order)

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the recipient does not exist' do
      it 'returns an error' do
        put api_v1_school_order_path(school, 'foo')

        expect(json_response[:error][:message].present?).to be_truthy
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
