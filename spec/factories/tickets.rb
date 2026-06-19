# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    user
    event
    comment { '参加しますー' }
  end
end
