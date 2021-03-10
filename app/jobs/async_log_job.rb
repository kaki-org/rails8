class AsyncLogJob < ApplicationJob
  queue_as :async_log

  def perform(message: "Hello")
    # Do something later
    AsyncLog.create!(message: message)
  end
end
