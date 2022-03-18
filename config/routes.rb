Rails.application.routes.draw do
  devise_for :users
  root to: 'main#index'
  resources :main, only: %i[index], format: false
  resources :items, format: false

  resources :users, only: %i[index show delete], format: false

  post '/items/:id/add-keyword', to: 'items#add_keyword', as: 'add_keyword', format: false
  post '/items/add-by-sku', to: 'items#add_by_sku', as: 'add_by_sku', format: false
  post '/items/add-by-list', to: 'items#add_by_list', as: 'add_items_by_list', format: false
  post '/items/:id/get-info-by-sku', to: 'items#get_info_by_sku', as: 'get_info_by_sku', format: false
  delete '/items/:id/del-keyword', to: 'items#del_item_keyword', as: 'del_item_keyword', format: false

  resources :keywords, only: %i[index create destroy], format: false
  post '/keywords/update/:keyword', to: 'keywords#update_data', as: 'update_keyword', format: false
  post '/keywords/update_test/:keyword', to: 'keywords#update_data_test', as: 'update_test_keyword', format: false

  post '/keywords/update-all', to: 'keywords#update_all_data', as: 'update_all_keywords', format: false
  get '/keywords/:id/log', to: 'keywords#view_log', as: 'view_log_keyword', format: false
end
