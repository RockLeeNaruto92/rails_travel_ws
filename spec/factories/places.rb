FactoryGirl.define do
  factory :place do
    code {Faker::Code.isbn}
    name {Faker::Address.street_name}
    city {Faker::Address.city}
    country {Faker::Address.country}
    address {Faker::Address.street_address}
    services {Faker::Lorem.paragraph 10, true}
    description {Faker::Lorem.paragraph 30, true}
  end
end
