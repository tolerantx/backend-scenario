class Recipient < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true

  belongs_to :school
  has_many :order_items

  include Filterable
end
