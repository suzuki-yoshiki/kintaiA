Rails.application.routes.draw do
  root 'staticpages#top'
  get '/signup', to: 'users#new'
  
  resources :users
end