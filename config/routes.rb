Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#home'
  
  resources :goals do
    collection do
      get :edit_multiple
      patch :update_multiple
    end
  end

  resources :life_goals do
    collection do
      get :edit_multiple
      patch :update_multiple
    end
  end

  resources :users, only: [:new, :create]
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  get 'authorized', to: 'sessions#page_requires_login'

end
