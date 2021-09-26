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

  STATUSES = { ORDER_RECEIVED: 1, ORDER_PROCESSING: 2, ORDER_SHIPPED: 3, ORDER_CANCELLED: 4 }.freeze
  enum status: STATUSES

  def gift_count
    items.sum(:quantity)
  end

  def recipient_id_list
    items.pluck(:recipient_id).uniq
  end

  def recipient_count
    recipient_id_list.count
  end

  private

  def flag_if_status_changed_to_shipped
    flag_for_notification if status == 'ORDER_SHIPPED' && status_was != 'ORDER_SHIPPED'
  end

  def order_not_shipped_or_cancelled
    return unless %w[ORDER_SHIPPED ORDER_CANCELLED].include? status_was

    errors.add(:status, "Can't modify order in #{status_was} status")
  end

  def correct_order_flow
    old_status = Order.statuses[status_was]
    new_status = Order.statuses[status]
    return if ORDER_CANCELLED? || new_status == old_status + 1 || new_status == old_status

    errors.add('Status:',
               'Must follow proper flow: Received->Processing->Shipped unless Cancelled')
  end

  def flag_for_notification
    self.notify_user = true
  end
end
