class UserMailer < ApplicationMailer
  def welcome
    @name = params[:name]
    mail(to: params[:to], subject: '登録完了')
  end
end
