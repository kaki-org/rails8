class AsyncLogJob < ApplicationJob
  queue_as :async_log
  queue_as do
    case self.arguments.first[:message]
    when "to async_log"
      :async_log
    else
      :default
    end
  end

  def perform(message: "Hello")
    # Do something later
    AsyncLog.create!(message: message)
  end
end
