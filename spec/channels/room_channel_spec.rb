require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  describe "subscribes" do
    it {
      subscribe
      expect(subscription.confirmed?).to be_truthy
      expect(subscription).to have_stream_from("room_channel")
    }
    it {
      subscribe
      expect(subscription.confirmed?).to be_truthy
      expect(subscription).not_to have_stream_from("bad_channel")
    }
  end

  describe "broadcast" do
    let(:text){ "Hello"}
    let(:broadcast_text){ ApplicationController.render(
      partial: 'message2s/message2',
      locals: { message2: Message2.new(content: text)}
    )}
    xit {
      # ここはminitestだと以下のようなテストになる筈
      # assert_broadcast_on('room_channel', message: broadcast_text) do
      #   perform :speak, message: text
      # end
      subscribe
      expect {
        ActionCable.server.broadcast(
          "room_channel", text: broadcast_text
        )
      }.to have_broadcasted_to("room_channel").with("Hello")
    }
  end
end
