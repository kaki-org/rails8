require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome" do
    email = UserMailer.with(to: "kakikubo@example.com", name: "kakikubo").welcome
    context 'when send_mail' do
      it {
        expect { email.deliver_now }.to change { ActionMailer::Base.deliveries.count }
        expect(email.to.first).to eq('kakikubo@example.com')
        expect(email.from.first).to eq('from@example.com')
        expect(email.subject).to eq('登録完了')
        expect(email.text_part.decoded).to match(/kakikubo/)
        expect(email.html_part.decoded).to match(/kakikubo/)
      }
    end
  end
end
