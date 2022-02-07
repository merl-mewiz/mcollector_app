Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  resources :main, only: %i[index]
  resources :items
  post '/items/:id/addkeyword', to: 'items#add_keyword', as: 'add_keyword'

  resources :keywords, only: %i[index create destroy]
  post '/keywords/update/:keyword', to: 'keywords#update_data', as: 'update_keywords'
  get '/keywords/:id/log', to: 'keywords#view_log', as: 'view_log_keyword'
end
