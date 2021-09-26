class School < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  has_many :recipients
  has_many :orders

  def orders_on(date)
    orders.where(date: date)
  end

  def ordered_gifts_on(date)
    gift_count = orders_on(date).map(&:gift_count).reduce(:+)
    gift_count.nil? ? 0 : gift_count
  end
end
