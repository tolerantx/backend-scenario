require 'rails_helper'

RSpec.describe School, type: :model do
  describe 'associations' do
    it { should have_many(:recipients) }
    it { should have_many(:orders) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }

    it 'is valid with valid attributes' do
      school = School.create(name: 'School1', address: 'Address1')
      expect(school).to be_valid
    end
  end

  describe 'methods' do
    before(:all) do
      @school = School.create(name: 'School1', address: 'Address1')
      @recipient = Recipient.create(school_id: @school.id, name: 'Recipient1', address: 'Address1')
      @order = Order.create(school_id: @school.id, date: Date.today)
      @order_items = OrderItem.create(order_id: @order.id,
                                      recipient_id: @recipient.id, gift_type: rand(1..4), quantity: 16)
    end

    it 'Retrieves the orders from a school in a given date ' do
      expect(@school.orders_on(@order.date).count).to eq 1
    end

    it 'Counts the number of gifts order for a given date' do
      expect(@school.ordered_gifts_on(@order.date)).to eq 16
    end
  end
end
