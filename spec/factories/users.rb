FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test@example.com"
    password "please123"

    trait :admin do
      role 'admin'
    end

    trait :with_school do
      after(:create) do |user|
          create(:school, user_email: user.email)
      end
    end

  end
end
