# frozen_string_literal: true

FactoryBot.define do
  factory :snapshot, class: Snapshot do
    token { Faker::Internet.uuid }
    image_url {Faker::String.random}
  end
end
