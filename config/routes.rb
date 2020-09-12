Rails.application.routes.draw do
  root to: 'guilds#index'

  get 'growth', to: 'guilds#growth'
  get 'about', to: 'home#about'

  resources :guilds, only: %i[index show new create]
end
