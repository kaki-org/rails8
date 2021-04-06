# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe '参照' do
    let(:event_owner) { create(:user) }
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: event_owner) }
    context '自分が作ったイベントは' do
      before {
        sign_in_as event_owner
        get event_path(event)
      }
      it "参照できる" do
        expect(response.status).to eq 200
        expect(response.body).to include '参加する'
      end
    end
    context '他人が作ったイベントは' do
      before {
        sign_in_as user
        get event_path(event)
      }
      it "参照できる" do
        expect(response.status).to eq 200
        expect(response.body).to include '参加する'
      end
    end
  end
  describe '削除' do
    let(:event_owner) { create(:user) }
    let(:user) { create(:user) }
    let(:event) { create(:event, owner: event_owner) }
    context '自分が作ったイベントは' do
      before do
        sign_in_as event_owner
        delete event_path(id: event.id)
      end

      it "削除が成功すること" do
        expect(Event.all.size).to eq 0
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
