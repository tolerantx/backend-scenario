class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :recipient

  validate :within_daily_gift_limit, :within_recipient_limit
  validate :order_not_shipped_or_cancelled, on: :update

  validates :recipient_id, presence: true

  include Filterable

  GIFT_TYPES = { MUG: 1, T_SHIRT: 2, HOODIE: 3, STICKER: 4 }.freeze

  enum gift_type: GIFT_TYPES

  private

  def within_daily_gift_limit
    return unless (already_ordered + quantity) > MAX_GIFTS_PER_DAY

    errors.add('Gift Count:', "Daily gift limit exceeded, Max: #{MAX_GIFTS_PER_DAY}")
  end

  def within_recipient_limit
    return unless recipients_count > MAX_RECIPIENTS_PER_ORDER

    errors.add('Recipient Count:',
               "Recipient limit exceeded, Max: #{MAX_RECIPIENTS_PER_ORDER}")
  end

  def order_not_shipped_or_cancelled
    return unless order.ORDER_SHIPPED? || order.ORDER_CANCELLED?

    errors.add('Status:', "Can't modify order items when #{order.status}")
  end

  def already_ordered
    order.school.ordered_gifts_count_on(order.date) - quantity_was.to_i
  end

  def recipients_count
    return order.recipient_count if order.recipient_id_list.include? recipient_id

    order.recipient_count + 1
  end
end
