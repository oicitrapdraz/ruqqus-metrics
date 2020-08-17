Rails.application.routes.draw do
  root to: 'guilds#index'

    get 'about', to: 'home#about'

  resources :guilds, only: %i[index show]
end
