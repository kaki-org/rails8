# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe '自分でつくったイベントは' do
    context '削除が成功すること' do
      let(:event_owner) { FactoryBot.create(:user) }
      let(:event) { FactoryBot.create(:event, owner: event_owner) }
      before do
        sign_in_as event_owner
        delete event_path(id: event.id)
      end

      it { expect(Event.all.size).to eq 0 }
    end
    describe '他人がつくったイベントは' do
      context '削除が失敗すること' do
        let(:event_owner) { FactoryBot.create(:user) }
        let(:user) { FactoryBot.create(:user) }
        let(:event) { FactoryBot.create(:event, owner: event_owner) }
        before do
          sign_in_as user
        end

        it {
          expect do
            delete event_path(id: event.id)
            Event.all.size
          end.to raise_error(ActiveRecord::RecordNotFound)
        }
      end
    end
  end
end
