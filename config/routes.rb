Rails.application.routes.draw do
  root('home#index')

  get('events/:login', to: 'events#index')
end
