# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    provider :github,
             ENV.fetch('GITHUB_CLIENT_ID', 'dummy_client_id'),
             ENV.fetch('GITHUB_CLIENT_SECRET', 'dummy_client_secret')
  else
    provider :github,
             ENV.fetch('GITHUB_CLIENT_ID'),
             ENV.fetch('GITHUB_CLIENT_SECRET')
  end
end
