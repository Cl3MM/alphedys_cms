FactoryGirl.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  factory :user do
    email
    password "secret"
    role "user"
  end

  factory :admin do
    email
    password "foobar"
    role "admin"
  end
end
