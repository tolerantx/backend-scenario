require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:school) { create(:school) }
  let(:recipient) { create(:recipient, school: school) }
  let(:order) { create(:order, school: school) }
  let!(:order_item) { create(:order_item, order: order, recipient: recipient, quantity: 16) }

  describe 'validations' do
    it 'Is not valid when order_item breaches daily gift limit' do
      expect { order_item.update!(quantity: 100) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not valid when order_item breaches recipient limit' do
      1.upto(21) do |i|
        r = Recipient.create(school_id: school.id, name: "Recipient#{i}", address: 'Address')
        OrderItem.create(order_id: order.id,
                         recipient_id: r.id, gift_type: rand(1..4), quantity: 1)
      end
      new_item = OrderItem.new(order_id: order.id, recipient_id: Recipient.last.id,
                               gift_type: rand(1..4), quantity: 1)

      expect { new_item.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow updates when status is ORDER_SHIPPED' do
      order_item.order.update!(status: 'ORDER_PROCESSING')
      order_item.order.update!(status: 'ORDER_SHIPPED')

      expect { order_item.update!(quantity: 5) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow updates when status is ORDER_CANCELLED' do
      order_item.order.update!(status: 'ORDER_CANCELLED')

      expect { order_item.update!(quantity: 5) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
