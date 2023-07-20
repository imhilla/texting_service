require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Tis is the default route path for checking if app is running
  root "application#health_check"
  resources :messages, only: [:create]
  resources :delivery_status, only: [:create]
  resources :providers, only: [:create, :update]
  mount Sidekiq::Web => "/sidekiq"
end
