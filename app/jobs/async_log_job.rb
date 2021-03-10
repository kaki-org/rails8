class AsyncLogJob < ApplicationJob
  queue_as :default

  def perform(message: "Hello")
    # Do something later
    AsyncLog.create!(message: message)
  end
end
