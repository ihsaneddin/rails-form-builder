Rails.application.routes.draw do

  root "forms#index"

  resources :forms, except: %i[show] do
    scope module: :forms do
      resources :fields, except: %i[show]
    end
  end

  resources :fields, only: %i[] do
    scope module: :fields do
      resource :validations, only: %i[edit update]
      resource :options, only: %i[edit update]
    end
  end

end
