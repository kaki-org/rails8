# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tickets', type: :request do
  describe 'GET /new' do
    let(:event) { create(:event) }
    let(:user) { create(:user) }
    describe '未ログイン状態' do
      before do
        get new_event_ticket_path(event)
      end
      it 'リダイレクトされる' do
        expect(response.status).to eq 302
      end
    end
    describe 'ログイン状態' do
      before do
        sign_in_as user
      end
      it 'エラーになる' do
        expect do
          get new_event_ticket_path(event)
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end
  describe '#create' do
    let(:owner) { create(:user) }
    let(:event) { create(:event, owner: owner) }
    let(:user) { create(:user) }
    let(:params) do
      {
        ticket: {
          comment: '参加しまーす'
        }
      }
    end
    describe '未ログイン状態' do
      before do
        post event_tickets_path(event), params: params
      end
      it 'リダイレクトされる' do
        expect do
          post event_tickets_path(event), params: params
        end.to change { Ticket.all.size }.by(0)
        expect(response.status).to eq 302
      end
    end
    describe 'ログイン状態' do
      before do
        sign_in_as user
      end
      it 'イベントに参加できる' do
        expect do
          post event_tickets_path(event), params: params
        end.to change { Ticket.all.size }.by(1)
        expect(response.status).to eq 302
      end
    end
  end
  describe '#destroy' do
    let(:owner) { create(:user) }
    let(:event) { create(:event, owner: owner) }
    let(:user) { create(:user) }
    let!(:ticket) { create(:ticket, user: user, event: event) }
    describe '参加したイベントをキャンセルする' do
      before do
        sign_in_as user
      end
      it 'チケットが削除される' do
        expect do
          delete event_ticket_path(event, ticket)
        end.to change { Ticket.all.size }.by(-1)
      end
    end
  end
end
