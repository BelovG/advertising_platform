FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |i| "Name#{i}" }
    url "https://vk.com/george.belov"
  end
end