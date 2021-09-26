FactoryBot.define do
  factory :order do
    school
    date { Date.today }
  end
end
