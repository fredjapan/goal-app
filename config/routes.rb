Rails.application.routes.draw do
  get 'life_goals/index'
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
end
