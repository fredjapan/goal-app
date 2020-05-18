Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#home'
  
  resources :goals do
    collection do
      get :edit_multiple
      patch :update_multiple
      get :quarterly_index
    end
  end
end
