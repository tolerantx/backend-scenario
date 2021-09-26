require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:school) { create(:school) }
  let(:recipient) { create(:recipient, school: school) }
  let(:order) { create(:order, school: school) }
  let!(:order_item) { create(:order_item, order: order, recipient: recipient, quantity: 16) }

  describe 'associations' do
    it { should belong_to(:school) }
    it { should have_many(:items) }
    it { should have_many(:recipients).through(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:school_id) }
    it { should validate_presence_of(:date) }
    it { should accept_nested_attributes_for(:items) }
    it { should define_enum_for(:status) }

    it 'Is not valid when order_item breaches daily gift limit' do
      expect { order_item.update!(quantity: 100) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not valid when it doesnt follow proper order flow' do
      expect { order.update!(status: 'ORDER_SHIPPED') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow updates when status is ORDER_SHIPPED' do
      order.update!(status: 'ORDER_PROCESSING')
      order.update!(status: 'ORDER_SHIPPED')

      expect { order.update!(date: Date.today + 19) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow updates when status is ORDER_CANCELLED' do
      order.update!(status: 'ORDER_CANCELLED')

      expect { order.update!(date: Date.today + 19) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'flags order for notification to user when ORDER_SHIPPED' do
      order.update!(status: 'ORDER_PROCESSING')
      order.update!(status: 'ORDER_SHIPPED')

      expect(order.notify_user).to be true
    end
  end

  describe 'methods' do
    it 'Calculates the gift count of an order' do
      expect(order.gift_count).to eq 16
    end

    it 'Returns an array of distinct recipient_ids' do
      recipients = [] << recipient.id
      expect(order.recipient_id_list).to eq recipients
    end

    it 'Counts the number of distinct recipients' do
      expect(order.recipient_count).to eq 1
    end
  end
end
