Rails.application.routes.draw do
  resources :timesheets do
    collection { post :import }
  end
  resources :timesheets do
      get 'delete_all'
  end
  resources :phones do
    collection { post :import }
  end
  resources :samples
  root "phones#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
