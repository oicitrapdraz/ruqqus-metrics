Rails.application.routes.draw do
  root to: "guilds#index"

  resources :guilds, only: %i[index show]
end
