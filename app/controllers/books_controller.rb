class BooksController < ApplicationController
  protect_from_forgery except: [:destroy] # テスト用にCSRF対策をOFFにする
  before_action :set_book, only: [:show, :destroy]
  around_action :action_logger
  def show
    respond_to do |format|
      format.html
      format.plain { render plain: 'OK' }
      format.json { render json: @book }
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
