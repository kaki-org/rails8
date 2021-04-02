# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe '正常なパラメータが入力された場合' do
    context 'イベントは' do
      let(:event) { create(:event) }
      it '正しくイベントが作成されること' do
        expect(event).to be_valid
      end
    end
  end
end
