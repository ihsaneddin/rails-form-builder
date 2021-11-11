Rails.application.routes.draw do

  root "forms#index"

  resources :forms, except: %i[show] do
    scope module: :forms do
      resources :fields, except: %i[show]
    end
  end

end
