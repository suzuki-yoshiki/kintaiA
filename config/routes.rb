Rails.application.routes.draw do
  root 'staticpages#top'
  get '/signup', to: 'users#new'
  
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  
  resources :users do
    collection { post :import }
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      
      get 'attendances/edit_over_time'
      patch 'attendances/update_over_time'
      
      get 'attendances/edit_request_one_month'
      patch 'attendances/update_request_one_month'
      
      get 'attendances/edit_change_request'
      patch 'attendances/update_change_request'
      
      get 'attendances/edit_log'
    
    end
    resources :attendances
    resources :bases
  end
end