FactoryBot.define do
  factory :order_item do
    order
    recipient
    gift_type { rand(1..4) }
    quantity { 1 }
  end
end
