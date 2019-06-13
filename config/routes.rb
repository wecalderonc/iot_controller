require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'

  post "/graphql", to: "graphql#execute"

  mount Rswag::Api::Engine => '/api-docs'

  mount Sidekiq::Web, at: '/sidekiq'

  mount API::Base => '/api'

  root to: 'home#index'

  post '/authentication', to: 'authentication#authenticate_user'

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
