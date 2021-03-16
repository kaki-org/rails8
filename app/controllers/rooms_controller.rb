class RoomsController < ApplicationController
  def show
    @messages = Message2.all
  end
end
