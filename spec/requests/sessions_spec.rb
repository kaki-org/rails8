# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }
  describe '#login' do
    before do
      sign_in_as user
    end
    it 'セッションが保持される' do
      expect(session[:user_id]).to eq user.id
    end
  end
  describe '#logout' do
    before do
      sign_in_as user
      delete logout_path
    end
    it 'セッションが破棄される' do
      expect(session[:user_id]).to eq nil
    end
  end
end
