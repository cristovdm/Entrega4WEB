Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  patch '/tickets/:id/close', to: 'tickets#close', as: 'close_ticket'
  patch '/tickets/:id/reopen', to: 'tickets#reopen', as: 'reopen_ticket'
  patch '/tickets/:id/update_acceptance', to: 'tickets#update_acceptance', as: 'update_acceptance'
  get '/usersearch', to: 'static_pages#user_search', as: 'static_pages_user_search'
  get '/tickets', to: 'tickets#index', as: 'tickets_index'
  resources :tickets, except: [:edit, :update, :destroy] do
    resources :comments, only: [:create]
  end
end