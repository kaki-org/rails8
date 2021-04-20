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
    context 'auth_hashが正しく渡されたユーザは' do
      let(:params) do
        {
          provider: 'github',
          uid: 'uid99',
          info: {
            nickname: 'jimmy',
            image: 'http://example.com/uid99.png'
          }
        }
      end
      it '正しく作成されること' do
        user = User.find_or_create_from_auth_hash!(params)
        expect(user).to be_valid
      end
    end
  end
  describe '異常系' do
    context '名前が指定されていない場合' do
      let(:user) { build(:user, name: nil) }
      it 'ユーザが作成されないこと' do
        expect(user).not_to be_valid
        expect(user.errors[:name]).to eq(['を入力してください'])
      end
    end
    context '公開中の未終了イベントがある場合' do
      let!(:user) { create(:user) }
      let!(:event) { create(:event, owner: user) }
      it '削除しようとすると失敗する' do
        user.destroy
        expect(user.errors[:base]).to eq(['公開中の未終了イベントが存在します'])
      end
    end
    context '参加中の未終了イベントがある場合' do
      let!(:event) { create(:event) }
      let!(:user) { create(:user) }
      it '削除しようとすると失敗する' do
        ticket = user.tickets.build do |t|
          t.event = event
          t.comment = '参加します'
        end
        ticket.save
        user.destroy
        expect(user.errors[:base]).to eq(['未終了の参加イベントが存在します'])
      end
    end
  end
end
