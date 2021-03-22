require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  test "/events/:id ページを表示" do
    event = FactoryBot.create(:event)
    visit event_url(event)

    assert_selector "h1", text: event.name
  end

  test "/events/new ページを表示" do
    sign_in_as(FactoryBot.create(:user))

    visit new_event_url
    assert_selector "h1", text: "イベント作成"
  end

  test "/events/new ページでフォームを記入して登録" do
    sign_in_as(FactoryBot.create(:user))

    visit new_event_url
    assert_selector "h1", text: "イベント作成"

    fill_in "名前", with: "TokyuRubyKaigi"
    fill_in "場所", with: "東京"
    fill_in "内容", with: "tokyu.rbによる地域Ruby会議"

    start_at = Time.current
    end_at = start_at + 3.hour

    start_at_field = "event_start_at"
    select start_at.strftime("%Y"),      from: "#{start_at_field}_1i"
    select I18n.l(start_at, format: '%B'), from: "#{start_at_field}_2i"
    select start_at.strftime("%-d"),     from: "#{start_at_field}_3i"
    select start_at.strftime("%H"),      from: "#{start_at_field}_4i"
    select start_at.strftime("%M"),      from: "#{start_at_field}_5i"

    end_at_field = "event_end_at"
    select end_at.strftime("%Y"),        from: "#{end_at_field}_1i"
    select I18n.l(end_at, format: '%B'), from: "#{end_at_field}_2i"
    select end_at.strftime("%-d"),       from: "#{end_at_field}_3i"
    select end_at.strftime("%H"),        from: "#{end_at_field}_4i"
    select end_at.strftime("%M"),        from: "#{end_at_field}_5i"

    click_on "登録する"
    assert_selector "div.alert", text: "作成しました"
  end
end
