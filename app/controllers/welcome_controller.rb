class WelcomeController < ApplicationController
  skip_before_action :authenticate

  def index
    @event_search_form = EventSearchForm.new(event_search_form_params)
    @events = @event_search_form.search
    # @events = Event.page(params[:page]).per(3).
    #   where("start_at > ?", Time.zone.now).order(:start_at)
    # @events = Event.where("start_at >= ?", Time.zone.now).order(:start_at)
    # @events = Event.where("end_at >= ?", Time.zone.now).order(:start_at)
  end

  private

  def event_search_form_params
    params.fetch(:event_search_form, {}).permit(:keyword, :start_at).merge(page: params[:page])
  end
end
