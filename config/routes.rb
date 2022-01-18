Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  resources :main, only: %i[index]
end
