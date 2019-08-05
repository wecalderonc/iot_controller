require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  post "/graphql", to: "graphql#execute"
  if not ENV['RAILS_ENV'].eql?('production')
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'home#index'

  post '/authentication', to: 'authentication#authenticate_user'

  namespace :api do
    namespace :v1 do
      resources :users,                         only: [:show, :index, :create, :update], param: :email
      resources :aqueducts,                     only: [:index]
      resources :things,                        only: [:show, :index, :update]
      resources :uplinks,                       only: [:index]
      resources :accumulators_report,           only: [:show, :index]
      resources :alarms_report,                 only: [:show, :index]
      resources :downlinks,                     only: [:create]
      resources :alarms,                        only: [:update]
    end
  end
end
