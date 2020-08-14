Rails.application.routes.draw do
  resources :guilds, only: %i[index show]
end
