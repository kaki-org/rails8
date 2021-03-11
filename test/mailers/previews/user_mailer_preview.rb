class UserMailerPreview < ActionMailer::Preview
  def welcome
    UserMailer.with(to: 'kakikubo@example.com', name: 'kakky').welcome
  end
end