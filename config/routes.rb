Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root "static_pages#home"
  patch '/tickets/:id/close', to: 'tickets#close', as: 'close_ticket'
  patch '/tickets/:id/reopen', to: 'tickets#reopen', as: 'reopen_ticket'
  patch '/tickets/:id/update_acceptance', to: 'tickets#update_acceptance', as: 'update_acceptance'
  get '/usersearch', to: 'static_pages#user_search', as: 'static_pages_user_search'
  get '/tickets', to: 'tickets#index', as: 'tickets_index'

  get '/user_roles', to: 'static_pages#user_roles', as: 'user_roles'
  patch '/user_roles/:id', to: 'static_pages#update_role', as: 'update_role'

  get '/tickets_report', to: 'tickets#tickets_report', as: 'tickets_report'
  get 'executive_performance_report', to: 'tickets#executive_performance_report', as: 'executive_performance_report'

  get '/manage_roles', to: 'static_pages#manage_roles', as: 'manage_roles'
  patch '/manage_roles/:id', to: 'static_pages#toggle_role', as: 'toggle_role'

  get '/supervisor_tickets', to: 'static_pages#supervisor_tickets', as: 'supervisor_tickets'
  
  get '/profile/edit', to: 'static_pages#edit_profile', as: 'edit_profile'
  patch '/profile', to: 'static_pages#update_profile', as: 'update_profile'
  resources :tickets, except: [:edit, :update] do
    resources :comments, only: [:create]
  end
end