class BooksController < ApplicationController
  protect_from_forgery except: [:destroy] # テスト用にCSRF対策をOFFにする
  before_action :set_book, only: [:show, :destroy]
  # こういう書き方もできるよという例
  # before_action do
  #   redirect_to access_denied_path if params[:token].blank?
  # end
  around_action :action_logger
  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def action_logger
    Rails.logger.info "( ﾟдﾟ)ﾊｯ!"
    yield
    Rails.logger.info "(　>д<)､;'.･　ｨｸｼｯ'"
  end
end
