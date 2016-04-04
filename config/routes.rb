Rails.application.routes.draw do
  resources :nick_whitelists
  resources :sayings
  resource :profile, only: [:show, :update]
  resources :chatlogs, only: [:index]
  get "/chatlogs/:channel/:date", to: "chatlogs#show", as: :chatlog_show
  devise_for :users
  root to: 'home#index'
end
