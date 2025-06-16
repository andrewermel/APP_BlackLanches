Rails.application.routes.draw do
  resources :lanches do
    member do
      delete "remove_photo/:photo_id", to: "lanches#remove_photo", as: "remove_photo"
    end
  end
  resources :porcaos
  resources :compras do
    collection do
      get "item_data/:id", to: "compras#item_data", as: "item_data"
    end
  end
  resources :items
  get "home/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
