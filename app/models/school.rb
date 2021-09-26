class School < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  has_many :recipients
  has_many :orders

  def orders_on(date)
    orders.where(date: date)
  end

  def ordered_gifts_count_on(date)
    orders_on(date).sum(&:gift_count).to_i
  end
end
