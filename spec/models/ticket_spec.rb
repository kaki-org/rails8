# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    context '正常系' do
      it 'バリデーションを通過すること' do
        ticket = described_class.new(
          user: user,
          event: event,
          comment: SecureRandom.alphanumeric((0..30).to_a.sample)
        )
        expect(ticket).to be_valid
      end
      it 'ユーザが紐付いていなくてもバリデーションは通過すること' do
        ticket = described_class.new(
          user: nil,
          event: event,
          comment: SecureRandom.alphanumeric((0..30).to_a.sample)
        )
        expect(ticket).to be_valid
      end
    end
    context '異常系' do
      it 'バリデーションを通過しないこと' do
        ticket = described_class.new(
          user: user,
          event: event,
          comment: SecureRandom.alphanumeric(31)
        )
        expect(ticket).not_to be_valid
      end
    end

  end
end
