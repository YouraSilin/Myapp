Rails.application.routes.draw do
  resources :timesheets do
    collection { post :import }
  end
  resources :timesheets do
    get 'delete_all'
    get 'delete_empty'
    get 'delete_duplicates'
    get 'delete_turquoise'
    get 'delete_not_turquoise'
  end
  resources :phones do
    collection { post :import }
  end
  resources :samples
  root "timesheets#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
