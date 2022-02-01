Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  resources :main, only: %i[index]
  resources :items
  post '/items/:id/addkeyword', to: 'items#add_keyword', as: 'add_keyword'
end
