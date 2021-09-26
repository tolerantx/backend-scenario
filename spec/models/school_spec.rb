require 'rails_helper'

RSpec.describe School, type: :model do
  let(:school) { create(:school) }
  let(:recipient) { create(:recipient, school: school) }
  let(:order) { create(:order, school: school) }
  let!(:order_item) { create(:order_item, order: order, recipient: recipient, quantity: 16) }

  describe 'associations' do
    it { should have_many(:recipients) }
    it { should have_many(:orders) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }

    it 'is valid with valid attributes' do
      expect(school).to be_valid
    end
  end

  describe 'methods' do
    it 'Retrieves the orders from a school in a given date ' do
      expect(school.orders_on(order.date).count).to eq 1
    end

    it 'Counts the number of gifts order for a given date' do
      expect(school.ordered_gifts_count_on(order.date)).to eq 16
    end
  end
end
