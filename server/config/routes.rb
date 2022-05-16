Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :services do 
        member do
          get :weeks
        end
        resources :workshifts do 
          collection do 
            get :week
          end
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
