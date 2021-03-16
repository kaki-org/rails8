Rails.application.routes.draw do
  get 'rooms/show'
  resources :messages
  resources :users
  resources :comments
  resources :entries
  resources :blogs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  if Rails.env.development?
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end
end
