Rails.application.routes.draw do
  root to: 'main#index'
  get '/', to: 'main#index'
  # resources :main, only: [:index]
end
