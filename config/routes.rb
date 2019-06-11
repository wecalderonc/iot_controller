require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  mount Sidekiq::Web, at: '/sidekiq'
  mount API::Base => '/api'
  root to: 'home#index'
  post '/authentication', to: 'authentication#authenticate_user'
end
