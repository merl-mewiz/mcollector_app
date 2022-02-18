Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  resources :main, only: %i[index]
  resources :items
  post '/items/:id/addkeyword', to: 'items#add_keyword', as: 'add_keyword'
  post '/items/add-by-sku', to: 'items#add_by_sku', as: 'add_by_sku'

  resources :keywords, only: %i[index create destroy]
  post '/keywords/update/:keyword', to: 'keywords#update_data', as: 'update_keyword'
  post '/keywords/update_test/:keyword', to: 'keywords#update_data_test', as: 'update_test_keyword'

  post '/keywords/update_all', to: 'keywords#update_all_data', as: 'update_all_keywords'
  get '/keywords/:id/log', to: 'keywords#view_log', as: 'view_log_keyword'
end
