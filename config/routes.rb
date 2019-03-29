Rails.application.routes.draw do
  root('events#index')

  get('events/:id', to: 'events#list', as: 'id')
end
