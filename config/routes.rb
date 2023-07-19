require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Tis is the default route path for checking if app is running
  root "application#health_check"
  resources :messages
  resources :delivery_status
  mount Sidekiq::Web => "/sidekiq"
end
