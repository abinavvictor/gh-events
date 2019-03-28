Rails.application.routes.draw do
  get 'events/index'

  root 'events#index'
end
