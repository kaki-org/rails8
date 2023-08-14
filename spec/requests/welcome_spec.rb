# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcomes', type: :request do
  describe 'GET /index' do
    let!(:event1) { create(:event, start_at: 1.day.from_now) }
    let!(:event2) { create(:event, start_at: 2.days.from_now) }
    let!(:event3) { create(:event, start_at: 3.days.from_now) }
    context '検索条件を指定しないとき' do
      before do
        Event.reindex
        get root_path, params: nil
      end
      it '全件かえってくる' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include event1.name
        expect(response.body).to include event2.name
        expect(response.body).to include event3.name
      end
    end
    context '検索条件を指定したとき' do
      let(:params) do
        {
          event_search_form: {
            start_at: 1.day.from_now
          }
        }
      end
      before do
        Event.reindex
        get root_path, params:
      end
      it '2件だけかえってくる' do
        expect(response).to be_successful
        expect(response.body).not_to include event1.name
        expect(response.body).to include event2.name
        expect(response.body).to include event3.name
      end
    end
  end
end
