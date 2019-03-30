Rails.application.routes.draw do
  root('events#index')

  get('/:login', to: 'events#index')
  get('/:login/:page', to: 'events#index')
end
