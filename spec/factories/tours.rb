FactoryGirl.define do
  factory :tour do
    place {Place.all.sample}
    code {Faker::Code.isbn}
    start_date {Faker::Date.between 1.year.ago, Date.today}
    tickets {Faker::Number.number 2}
    cost {Faker::Number.number 3}
    description {Faker::Lorem.paragraph 30, true}
  end
end
