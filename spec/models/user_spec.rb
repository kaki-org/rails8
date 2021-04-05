# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '正常系' do
    context '正常なパラメータが入力されたユーザは' do
      let(:user) { build(:user) }
      it '正しく作成されること' do
        expect(user).to be_valid
      end
    end
  end
  describe '異常系' do
    context '名前が指定されていない場合' do
      let(:user) { build(:user, name: nil) }
      it 'ユーザが作成されないこと' do
        # binding.pry
        expect(user).not_to be_valid
        expect(user.errors[:name]).to eq(['を入力してください'])
      end
    end
  end
end
