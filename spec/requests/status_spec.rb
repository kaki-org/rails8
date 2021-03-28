require 'rails_helper'

RSpec.describe "Statuses", type: :request do

  describe "GET /status" do
    before { get status_path }

    context "response" do
      it "成功のステータスが返ること" do
        expect(response.status).to eq 200
      end
      it "レスポンスにjsonでokが入っていること" do
        json = JSON.parse(response.body)
        expect(json['status']).to eq "ok"
      end
      it "content-typeがapplication/jsonになっていること" do
        expect(response.media_type).to eq "application/json"
      end
    end
  end
end
