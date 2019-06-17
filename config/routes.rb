require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  mount Sidekiq::Web, at: '/sidekiq'
  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :things
  end

  root to: 'home#index'

  post '/authentication', to: 'authentication#authenticate_user'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index]
      resources :aqueducts, only: [:index]
    end
  end
end
