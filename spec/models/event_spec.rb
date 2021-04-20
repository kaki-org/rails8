# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '正常系' do
    context '正常なパラメータが入力されたイベントは' do
      let(:event) { build(:event) }
      it '正しくイベントが作成されること' do
        expect(event).to be_valid
      end
    end
    context '画像が指定されていない場合' do
      let(:event) { build(:event, image: nil) }
      it 'イベントが作成されること' do
        expect(event).to be_valid
        expect(event.errors[:image]).not_to eq(['を入力してください'])
      end
    end
    context '作成ユーザが作ったイベントの場合' do
      let(:user) { create(:user) }
      let(:event) { build(:event, owner: user) }
      it '作成者と判定されること' do
        expect(event.created_by?(event.owner)).to be_truthy
      end
    end
  end

  describe '異常系' do
    context '主催者が指定されていない場合' do
      let(:event) { build(:event, owner: nil) }
      it 'イベントが作成されないこと' do
        expect(event).not_to be_valid
        expect(event.errors[:owner]).to eq(['を入力してください'])
      end
    end

    context '名前が指定されていない場合' do
      let(:event) { build(:event, name: nil) }
      it 'イベントが作成されないこと' do
        expect(event).not_to be_valid
        expect(event.errors[:name]).to eq(['を入力してください'])
      end
    end
    context '場所が指定されていない場合' do
      let(:event) { build(:event, place: nil) }
      it 'イベントが作成されないこと' do
        expect(event).not_to be_valid
        expect(event.errors[:place]).to eq(['を入力してください'])
      end
    end
    context '開始時間が指定されていない場合' do
      let(:event) { build(:event, :no_start_at) }
      it 'イベントが作成されないこと' do
        expect(event).not_to be_valid
        expect(event.errors[:start_at]).to eq(['を入力してください'])
      end
    end
    context '終了時間が指定されていない場合' do
      let(:event) { build(:event, :no_end_at) }
      it 'イベントが作成されないこと' do
        expect(event).not_to be_valid
        expect(event.errors[:end_at]).to eq(['を入力してください'])
      end
    end
    context '作成ユーザ以外が作ったイベントの場合' do
      let(:user) { create(:user) }
      let(:event) { build(:event) }
      it '作成者と判定されること' do
        expect(event.created_by?(user)).to be_falsey
      end
    end
  end
end
