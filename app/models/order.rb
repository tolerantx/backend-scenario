class Order < ApplicationRecord
  include Filterable

  belongs_to :school
  has_many :items, class_name: 'OrderItem'
  has_many :recipients, through: :items

  accepts_nested_attributes_for :items

  validates :school_id, presence: true
  validates :date, presence: true
  validate :correct_order_flow, :order_not_shipped_or_cancelled, on: :update

  before_save :flag_if_status_changed_to_shipped

  enum status: {
    ORDER_RECEIVED: 1, ORDER_PROCESSING: 2, ORDER_SHIPPED: 3, ORDER_CANCELLED: 4
  }

  def gift_count
    items.map(&:quantity).reduce(:+)
  end

  def recipient_id_list
    items.map(&:recipient_id).uniq
  end

  def recipient_count
    recipient_id_list.count
  end

  private

  def flag_if_status_changed_to_shipped
    old_status = attribute_in_database('status')
    flag_for_notification if status == 'ORDER_SHIPPED' && old_status != 'ORDER_SHIPPED'
  end

  def order_not_shipped_or_cancelled
    old_status = attribute_in_database('status')
    return unless %w[ORDER_SHIPPED ORDER_CANCELLED].include? old_status

    errors.add('Status:', "Can't modify order in #{old_status} status")
  end

  def correct_order_flow
    old_status = Order.statuses[attribute_in_database('status')]
    new_status = Order.statuses[status]
    return if ORDER_CANCELLED? || new_status == old_status + 1 || new_status == old_status

    errors.add('Status:',
               'Must follow proper flow: Received->Processing->Shipped unless Cancelled')
  end

  def flag_for_notification
    self.notify_user = true
  end
end
