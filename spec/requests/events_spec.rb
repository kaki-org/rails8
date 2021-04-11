# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe '参照' do
    let(:event_owner) { create(:user) }
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: event_owner) }
    context '自分が作ったイベントは' do
      before do
        sign_in_as event_owner
        get event_path(event)
      end
      it '参照できる' do
        expect(response.status).to eq 200
        expect(response.body).to include '参加する'
      end
    end
    context '他人が作ったイベントは' do
      before do
        sign_in_as user
        get event_path(event)
      end
      it '参照できる' do
        expect(response.status).to eq 200
        expect(response.body).to include '参加する'
      end
    end
  end
  describe '作成' do
    context '未ログイン状態' do
      before do
        get new_event_path
      end
      it '参照できない' do
        expect(response.status).to eq 302
      end
    end
    context 'ログイン状態' do
      let(:user) { create(:user) }
      before do
        sign_in_as user
        get new_event_path
      end
      it '参照できる' do
        expect(response.status).to eq 200
      end
      context 'パラメータを正しく入れる' do
        let(:params) do
          {
            event: {
              name: 'ビールイベント',
              place: '日比谷公園',
              image: nil,
              remove_image: nil,
              content: '真夏の太陽の下でビールを楽しもう',
              start_at: '2021-07-30 13:00',
              end_at: '2021-7-30 17:00'
            }
          }
        end
        let!(:event_count) { Event.all.size }
        before do
          post events_path, params: params
        end
        it '正しく作成される' do
          expect(event_count + 1).to eq(Event.all.size)
        end
      end
    end
  end
  describe '編集' do
    let(:event_owner) { create(:user) }
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: event_owner) }
    context '自分がつくったイベントは' do
      before do
        sign_in_as event_owner
        get edit_event_path(id: event.id)
      end
      it '参照できること' do
        expect(response.status).to eq 200
      end
    end
    context '他人がつくったイベントは' do
      before do
        sign_in_as user
      end
      it '参照できないこと' do
        expect do
          get edit_event_path(id: event.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe '更新' do
    let(:event_owner) { create(:user) }
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: event_owner) }
    let(:params) do
      {
        event: {
          place: '代々木公園'
        }
      }
    end
    context '自分がつくったイベントは' do
      before do
        sign_in_as event_owner
        patch event_path(id: event.id), params: params
      end
      it '更新が成功すること' do
        event.reload
        expect(event.place).to eq('代々木公園')
      end
    end
    context '他人がつくったイベントは' do
      before do
        sign_in_as user
      end
      it '更新が失敗すること' do
        expect do
          patch event_path(id: event.id), params: params
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe '削除' do
    let(:event_owner) { create(:user) }
    let(:user) { create(:user) }
    let!(:event) { create(:event, owner: event_owner) }
    context '自分が作ったイベントは' do
      before do
        sign_in_as event_owner
      end

      it '削除が成功すること' do
        expect do
          delete event_path(id: event.id)
        end.to change { Event.all.size }.by(-1)
      end
    end
    context '他人がつくったイベントは' do
      before do
        sign_in_as user
      end

      it '削除が失敗すること' do
        expect do
          delete event_path(id: event.id)
          Event.all.size
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
