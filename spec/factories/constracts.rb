FactoryGirl.define do
  factory :constract do
    tour {Tour.all.sample}
    customer_id_number {Faker::Code.ean}
    company_name {Faker::Name.name}
    company_phone {Faker::PhoneNumber.phone_number}
    company_address {Faker::Address.street_address}

    before(:create) do |constract|
      constract.booking_tickets = Random.rand constract.tour.available_tickets
    end
  end
end
