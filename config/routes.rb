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
      resources :users,                         only: [:index]
      resources :aqueducts,                     only: [:index]
      resources :things,                        only: [:show]
      resources :uplinks,                       only: [:index]
      resources :accumulators_report,           only: [:show, :index]
      resources :alarms_report,                 only: [:show, :index]
    end
  end
end
