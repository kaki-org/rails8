# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retirements', type: :request do
  describe '#new' do
    let(:user) { create(:user) }
    context 'ログインしたユーザで' do
      before do
        sign_in_as user
        get new_retirements_path
      end
      it '退会画面が表示される' do
        expect(response.status).to eq 200
      end
      context '退会処理をおこなう' do
        before do
          post retirements_path
        end
        it '退会される' do
          expect(session[:user_id]).to be nil
          expect(User.find_by(id: user.id)).to be nil
        end
      end
    end
  end
end
