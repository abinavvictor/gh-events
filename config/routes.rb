Rails.application.routes.draw do
  # TODO: ditch this, just display everything in a single page
  root('home#index')

  get('events/:login', to: 'events#index')
end
