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

  post '/authentication',             to: 'authentication#authenticate_user'
  post '/request_password_recovery',  to: 'api/v1/users#request_password_recovery'
  put  '/change_forgotten_password',  to: 'api/v1/users#change_forgotten_password'
  post '/confirm_email',              to: 'api/v1/users#confirm_email'

  namespace :api do
    namespace :v1 do
      resources :users,                         except: [:destroy], param: :email, constraints: { email: /.*/ } do
        resources :locations,                   only: :index
      end
      resources :aqueducts,                     only: [:index]
      resources :things,                        only: [:show, :index, :update], param: :thing_name do
        resources :battery_levels,              only: [:index]
        resources :alarms,                      only: [:index, :update]
        resources :accumulators,                only: [:index]
      end
      resources :uplinks,                       only: [:index]
      resources :accumulators_report,           only: [:show, :index], param: :thing_name
      resources :alarms_report,                 only: [:show, :index], param: :thing_name
      resources :downlinks,                     only: [:create]
      resources :locations,                     only: [:show, :create, :update], param: :thing_name
      resources :countries,                     only: [:index]
      resources :states,                        only: [:index], param: :country_code
      resources :cities,                        only: [:index], param: :state_code
    end
  end
end
