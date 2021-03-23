require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "自分でつくったイベントは" do
    context "削除がせいこうすること" do
      let(:event_owner){ FactoryBot.create(:user) }
      let(:event){ FactoryBot.create(:event, owner: event_owner) }
      before do
        sign_in_as event_owner
        delete event_path(id: event.id)
      end

      it { expect(Event.all.size).to eq 0 }
    end



  end
end
