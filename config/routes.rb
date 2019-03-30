Rails.application.routes.draw do
  root('events#index')

  get('/:login', to: 'events#index')
end
