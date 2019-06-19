require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'home#index'

  post '/authentication', to: 'authentication#authenticate_user'

  namespace :api do
    namespace :v1 do
      resources :users,               only: [:index]
      resources :aqueducts,           only: [:index]
      resources :things,              only: [:index, :show] do
        # resources :accumulators,      only: [:index]
        # resources :alarms,            only: [:index]
        # resources :battery_levels,    only: [:index]
        # resources :valve_positions,   only: [:index]
        # resources :uplink_b_downlinks, only: [:index]
        # resources :time_uplinks,      only: [:index]
        # resources :sensor1s,          only: [:index]
        # resources :sensor2s,          only: [:index]
        # resources :sensor3s,          only: [:index]
        # resources :sensor4s,          only: [:index]
        get ':message_name', to: 'things#index'
      end
      resources :uplinks,        only: [:index]
    end
  end
end
